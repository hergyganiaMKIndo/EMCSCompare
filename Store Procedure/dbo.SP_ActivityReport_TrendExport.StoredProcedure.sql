USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_ActivityReport_TrendExport]
	@startYear int,
	@endYear int,
	@filter NVARCHAR(MAX)
AS
BEGIN

	declare @yearly_tbl table(Year int)
	declare @year int = @startYear
	WHILE @year <= @endYear
	BEGIN
	   insert into @yearly_tbl values(@year)
	   SET @year = @year + 1;
	END;
	
	select 
		DISTINCT y.Year, 
		ISNULL(b.TotalExportSales, 0) AS TotalExportSales,
		ISNULL(b.TotalExportNonSales, 0) AS TotalExportNonSales, 
		ISNULL(b.TotalExport, 0) AS TotalExport,
		ISNULL(b.TotalPEB, 0) As TotalPEB 
	from @yearly_tbl y
	left join(
		select 
			c.Year,
			SUM(c.TotalExportSales) [TotalExportSales],
			SUM(c.TotalExportNonSales) [TotalExportNonSales],
			SUM(c.TotalExport) [TotalExport],
			SUM(c.TotalPEB) [TotalPEB]
		from (
			SELECT
				DISTINCT YEAR(CreatedDate) AS Year, 
					CASE WHEN ExportType LIKE 'Sales%' THEN SUM(ExtendedValue) ELSE 0 END [TotalExportSales], 
					CASE WHEN ExportType LIKE 'Non Sales%' THEN SUM(ExtendedValue) ELSE 0 END [TotalExportNonSales],
					SUM(ExtendedValue) As TotalExport,   
					COUNT(DISTINCT AjuNumber) AS TotalPEB  
		from dbo.[fn_get_approved_npe_peb]()
		where (YEAR(CreatedDate) >= @startYear or @startYear = 0) and (YEAR(CreatedDate) <= @endYear or @endYear = 0)
			AND ExportType LIKE '' + @filter + '%'
		group by YEAR(CreatedDate)
			, ExportType) AS c
	GROUP BY Year)b ON y.Year = b.Year

END
GO
