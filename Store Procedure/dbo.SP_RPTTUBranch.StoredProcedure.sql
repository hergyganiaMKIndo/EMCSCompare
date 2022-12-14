USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RPTTUBranch]
	@StartMonth nvarchar(20),
	@EndMonth nvarchar(20),
	@Type nvarchar(20)
AS
BEGIN

	declare @tbl table (Name nvarchar(200), TotalPEB int, TotalPEBJan int, TotalPEBFeb int, TotalPEBMar int, TotalPEBApr int, TotalPEBMay int, TotalPEBJun int, TotalPEBJul int, TotalPEBAug int, TotalPEBSep int, TotalPEBOct int, TotalPEBNov int, TotalPEBDec int)

	IF(@Type = 'Branch')
	BEGIN
		insert into @tbl
		select 
			Branch
		, count(DISTINCT AjuNumber) as TotalPEB
			, IIF(DATEPART(MONTH, PebDateNumeric) = 1, count(DISTINCT AjuNumber), 0) as TotalPEBJan
			, IIF(DATEPART(MONTH, PebDateNumeric) = 2, count(DISTINCT AjuNumber), 0) as TotalPEBFeb
			, IIF(DATEPART(MONTH, PebDateNumeric) = 3, count(DISTINCT AjuNumber), 0) as TotalPEBMar
			, IIF(DATEPART(MONTH, PebDateNumeric) = 4, count(DISTINCT AjuNumber), 0) as TotalPEBApr
			, IIF(DATEPART(MONTH, PebDateNumeric) = 5, count(DISTINCT AjuNumber), 0) as TotalPEBMay
			, IIF(DATEPART(MONTH, PebDateNumeric) = 6, count(DISTINCT AjuNumber), 0) as TotalPEBJun
			, IIF(DATEPART(MONTH, PebDateNumeric) = 7, count(DISTINCT AjuNumber), 0) as TotalPEBJul
			, IIF(DATEPART(MONTH, PebDateNumeric) = 8, count(DISTINCT AjuNumber), 0) as TotalPEBAug
			, IIF(DATEPART(MONTH, PebDateNumeric) = 9, count(DISTINCT AjuNumber), 0) as TotalPEBSep
			, IIF(DATEPART(MONTH, PebDateNumeric) = 10, count(DISTINCT AjuNumber), 0) as TotalPEBOct
			, IIF(DATEPART(MONTH, PebDateNumeric) = 11, count(DISTINCT AjuNumber), 0) as TotalPEBNov
			, IIF(DATEPART(MONTH, PebDateNumeric) = 12, count(DISTINCT AjuNumber), 0) as TotalPEBDec 
		from [dbo].[fn_get_approved_npe_peb]() 
		where ((DATEPART(MONTH, PebDateNumeric) >= DATEPART(MONTH, @StartMonth) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @StartMonth)) OR @StartMonth = '') 
				AND ((DATEPART(MONTH, PebDateNumeric) <= DATEPART(MONTH, @EndMonth) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @EndMonth)) OR @EndMonth = '')
		group by Branch, DATEPART(MONTH, PebDateNumeric)
	END
	ELSE IF(@Type = 'Loading')
	BEGIN
		insert into @tbl
		select 
			PortOfLoading
			, count(DISTINCT AjuNumber) as TotalPEB
			, IIF(DATEPART(MONTH, PebDateNumeric) = 1, count(DISTINCT AjuNumber), 0) as TotalPEBJan
			, IIF(DATEPART(MONTH, PebDateNumeric) = 2, count(DISTINCT AjuNumber), 0) as TotalPEBFeb
			, IIF(DATEPART(MONTH, PebDateNumeric) = 3, count(DISTINCT AjuNumber), 0) as TotalPEBMar
			, IIF(DATEPART(MONTH, PebDateNumeric) = 4, count(DISTINCT AjuNumber), 0) as TotalPEBApr
			, IIF(DATEPART(MONTH, PebDateNumeric) = 5, count(DISTINCT AjuNumber), 0) as TotalPEBMay
			, IIF(DATEPART(MONTH, PebDateNumeric) = 6, count(DISTINCT AjuNumber), 0) as TotalPEBJun
			, IIF(DATEPART(MONTH, PebDateNumeric) = 7, count(DISTINCT AjuNumber), 0) as TotalPEBJul
			, IIF(DATEPART(MONTH, PebDateNumeric) = 8, count(DISTINCT AjuNumber), 0) as TotalPEBAug
			, IIF(DATEPART(MONTH, PebDateNumeric) = 9, count(DISTINCT AjuNumber), 0) as TotalPEBSep
			, IIF(DATEPART(MONTH, PebDateNumeric) = 10, count(DISTINCT AjuNumber), 0) as TotalPEBOct
			, IIF(DATEPART(MONTH, PebDateNumeric) = 11, count(DISTINCT AjuNumber), 0) as TotalPEBNov
			, IIF(DATEPART(MONTH, PebDateNumeric) = 12, count(DISTINCT AjuNumber), 0) as TotalPEBDec	
		from [dbo].[fn_get_approved_npe_peb]() 
		where ((DATEPART(MONTH, PebDateNumeric) >= DATEPART(MONTH, @StartMonth) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @StartMonth)) OR @StartMonth = '') 
				AND ((DATEPART(MONTH, PebDateNumeric) <= DATEPART(MONTH, @EndMonth) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @EndMonth)) OR @EndMonth = '')
		group by PortOfLoading, DATEPART(MONTH, PebDateNumeric)
	END

	select 
		CAST(ROW_NUMBER() OVER ( ORDER BY Name ) as NVARCHAR(5)) RowNumber
		, * 
	from @tbl

END
GO
