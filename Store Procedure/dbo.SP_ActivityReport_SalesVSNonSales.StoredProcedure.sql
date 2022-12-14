USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ActivityReport_SalesVSNonSales]
	@startYear int,
	@endYear int
AS
BEGIN

	declare @temp_tbl table(Year int, ExportType nvarchar(100), ExtendedValue decimal(20,2))

	insert into @temp_tbl
	select 
		YEAR(CreatedDate), 
		t.ExportType, 
		sum(ExtendedValue)
	from dbo.[fn_get_approved_npe_peb]() t
	where (YEAR(CreatedDate) >= @startYear or @startYear = 0) and (YEAR(CreatedDate) <= @endYear or @endYear = 0)
	group by YEAR(CreatedDate), t.ExportType

	declare @minYear int, @maxYear int
	select @minYear = IIF(@startYear <> 0, @startYear, MIN(Year)), @maxYear = IIF(@endYear <> 0, @endYear, MAX(Year)) from @temp_tbl

	declare @yearly_tbl table(Year int, ExportType nvarchar(100))
	WHILE @minYear <= @maxYear
	BEGIN
	   insert into @yearly_tbl values(@minYear, 'Sales'), (@minYear, 'Non Sales')
	   SET @minYear = @minYear + 1;
	END;
	
	declare @tbl table (ExportType varchar(20), Year int, ExtendedValue decimal(20,2))
	insert into @tbl
	select 
		y.ExportType, 
		y.[Year], 
		ISNULL(t.ExtendedValue, 0) as ExtendedValue 
	from @yearly_tbl y
	left join @temp_tbl t on y.[Year] = t.[Year] and y.ExportType = t.ExportType
	
	SELECT * FROM  
	(
		select * from @tbl
		) AS SourceTable  
	PIVOT  
	(  
		MAX(ExtendedValue) FOR ExportType IN ([Sales], [Non Sales])  
	) AS PivotTable

END
GO
