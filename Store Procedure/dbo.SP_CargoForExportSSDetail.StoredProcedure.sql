USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[SP_CargoForExportSSDetail] @CargoID = 9
CREATE PROCEDURE [dbo].[SP_CargoForExportSSDetail] 
	@CargoID bigint
AS
BEGIN
	select 
		master.CiplID
		, MAX(master.CargoDescription) CargoDescription
		, MAX(cipl.CiplNo) as CiplNo
		, CAST(COUNT(DISTINCT IIF(cpi.CaseNumber IS NULL OR LEN(cpi.CaseNumber) <= 0, '-', cpi.CaseNumber)) as varchar(5)) as TotalCaseNumber
		, CAST(CAST(SUM(ISNULL(ci.Width, 0) * ISNULL(ci.Length, 0) * ISNULL(ci.Height, 0)) as decimal(18,2)) as varchar(20)) as TotalVolume
		, CAST(FORMAT(SUM(ISNULL(ci.Net, 0)), '#,0.00') as varchar(20)) as TotalNetWeight
		, CAST(FORMAT(SUM(ISNULL(ci.Gross, 0)), '#,0.00') as varchar(20)) as TotalGrossWeight
		, CAST(FORMAT(SUM(ISNULL(cpi.Extendedvalue, 0)), '#,0.00') as varchar(20)) as TotalAmount 
	from
	(
		select 
			ci.Id as CargoItemID
			, ci.IdCargo as CargoID
			, cpi.Id AS CiplItemID
			, cp.id as CiplID
			, IIF(cp.Category IS NULL OR LEN(cp.Category) <= 0, '-', cp.Category) as CargoDescription
		from CargoItem ci
		inner join CiplItem cpi on ci.IdCiplItem=cpi.Id
		inner join Cipl cp on cpi.IdCipl=cp.id
		where ci.isDelete = 0 and cpi.IsDelete = 0
	) master
	inner join CargoItem ci on master.CargoItemID = ci.Id
	inner join CiplItem cpi on master.CiplItemID = cpi.Id
	inner join dbo.Cipl cipl on master.CiplID = cipl.id
	where master.CargoID = @CargoID and ci.isDelete = 0 and cpi.IsDelete = 0
	group by master.CiplID, cipl.CiplNo
END



GO
