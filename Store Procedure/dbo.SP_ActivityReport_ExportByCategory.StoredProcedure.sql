USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ActivityReport_ExportByCategory]
	@startYear int,
	@endYear int
AS
BEGIN

	declare @totalCipl int
	select @totalCipl = count(distinct IdCipl) 
	from dbo.[fn_get_approved_npe_peb]() 
	where (YEAR(CreatedDate) >= @startYear or @startYear = 0) and (YEAR(CreatedDate) <= @endYear or @endYear = 0)

	select 
		Category,
		cast(
			LEFT(
				CONVERT(varchar, cast(count(distinct IdCipl) as decimal(16,2))/@totalCipl), 
				CHARINDEX('.',CONVERT(varchar, cast(count(distinct IdCipl) as decimal(16,2))/@totalCipl)) + 2
			)
		 as decimal(16,2)
	 ) as TotalPercentage
	from dbo.[fn_get_approved_npe_peb]()
	where (YEAR(CreatedDate) >= @startYear or @startYear = 0) and (YEAR(CreatedDate) <= @endYear or @endYear = 0)
	group by Category

END
GO
