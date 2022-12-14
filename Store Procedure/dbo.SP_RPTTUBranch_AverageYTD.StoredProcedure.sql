USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RPTTUBranch_AverageYTD]
	@StartPeriod nvarchar(20),
	@EndPeriod nvarchar(20)
AS
BEGIN

	declare @YTDMonthlyAVG decimal(18,2), @YTDWeeklyAVG decimal(18,2), @YTDDailyAVG decimal(18,2)

	declare @year int = DATEPART(YEAR, @StartPeriod)
	declare @StartMonth int = DATEPART(MONTH, @StartPeriod), @EndMonth int = DATEPART(MONTH, @EndPeriod)

	declare @monthly_tbl table(MonthNumber int, TotalDays int)
	declare @month int = 1

	WHILE @month <= 12
	BEGIN
		insert into @monthly_tbl 
		select @month
		, DATEDIFF(DAY, cast(@year as char(4)) + '-' + cast(@month as char(2)) + '-01', cast(IIF(@month+1 > 12, @year + 1, @year) as char(4)) + '-' + cast(IIF(@month+1 > 12, 1, @month+1) as char(2)) + '-01')
		SET @month += 1;
	END;

	--============ Average per Month ============
	select @YTDMonthlyAVG = CAST(ROUND(AVG(CAST(ISNULL(src.TotalPEB, 0) as float)), 2, 1) as decimal(18,2))
	from @monthly_tbl m
	left join (
		select 
			DATEPART(MONTH, PebDateNumeric) as MonthNumber
			, COUNT(DISTINCT AjuNumber) as TotalPEB
		from [dbo].[fn_get_approved_npe_peb]() 
		where ((DATEPART(MONTH, PebDateNumeric) >= DATEPART(MONTH, @StartPeriod) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @StartPeriod)) OR @StartPeriod = '') 
				AND ((DATEPART(MONTH, PebDateNumeric) <= DATEPART(MONTH, @EndPeriod) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @EndPeriod)) OR @EndPeriod = '')
		group by DATEPART(MONTH, PebDateNumeric)
	)src on m.MonthNumber = src.MonthNumber


	--============ Weekly Average (YTD) ============
	declare @maxweek int, @week int = 1
	declare @startdate datetime = CAST(@year as nvarchar(4)) + '-01-01'
	declare @enddate datetime = CAST(@year as nvarchar(4)) + '-12-31'
	set @maxweek = DATEPART(WEEK, @enddate)
	declare @weekly_tbl table(WeekNumber int, MonthNumber int)

	WHILE @week <= @maxweek
	BEGIN
		insert into @weekly_tbl 
		select @week, DATEPART(MONTH, DATEADD(WW, @week - 1, @startdate))
		SET @week = @week + 1;
	END;

	select @YTDWeeklyAVG = CAST(ROUND(AVG(TotalPEB), 2, 1) as decimal(18,2)) 
	from (
		select w.MonthNumber, AVG(CAST(ISNULL(src.TotalPEB, 0) as float)) as TotalPEB
		from @weekly_tbl w
		left join(
			select 
				DATEPART(WK, PebDateNumeric) as WeekNumber
				, COUNT(DISTINCT AjuNumber) as TotalPEB
			from [dbo].[fn_get_approved_npe_peb]() 
			where ((DATEPART(MONTH, PebDateNumeric) >= DATEPART(MONTH, @StartPeriod) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @StartPeriod)) OR @StartPeriod = '') 
					AND ((DATEPART(MONTH, PebDateNumeric) <= DATEPART(MONTH, @EndPeriod) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @EndPeriod)) OR @EndPeriod = '')
			group by DATEPART(WK, PebDateNumeric)
		)src on w.WeekNumber = src.WeekNumber
		GROUP BY w.MonthNumber
	)src where MonthNumber >= @StartMonth and MonthNumber <= @EndMonth


	--============ Daily Average (YTD) ============
	select @YTDDailyAVG = CAST(ROUND(AVG(TotalPEB), 2, 1) as decimal(18,2)) 
	from (
		select m.MonthNumber, CAST(ISNULL(src.TotalPEB, 0) as float)/m.TotalDays as TotalPEB
		from @monthly_tbl m
		left join (
			select 
				DATEPART(MONTH, PebDateNumeric) as MonthNumber
				, COUNT(DISTINCT AjuNumber) as TotalPEB
			from [dbo].[fn_get_approved_npe_peb]() 
			where ((DATEPART(MONTH, PebDateNumeric) >= DATEPART(MONTH, @StartPeriod) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @StartPeriod)) OR @StartPeriod = '') 
					AND ((DATEPART(MONTH, PebDateNumeric) <= DATEPART(MONTH, @EndPeriod) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @EndPeriod)) OR @EndPeriod = '')
			group by DATEPART(MONTH, PebDateNumeric)
		)src on m.MonthNumber = src.MonthNumber
	)src where MonthNumber >= @StartMonth and MonthNumber <= @EndMonth

	select @YTDMonthlyAVG as YTDMonthlyAVG, @YTDWeeklyAVG as YTDWeeklyAVG, @YTDDailyAVG as YTDDailyAVG

END
GO
