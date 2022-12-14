USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec DROP PROCEDURE SP_CargoForExportSSHeader @CargoID = 9;
CREATE PROCEDURE [dbo].[SP_CargoForExportSSHeader]
	@CargoID bigint
AS
BEGIN
    declare @Branch nvarchar(MAX) = '-'
	declare @branches table(branch nvarchar(200))

	INSERT INTO @branches
	select distinct ISNULL(a.BAreaName, '-') from CargoItem ci
	inner join CiplItem cpi on ci.IdCiplItem = cpi.Id
	inner join Cipl cp on cpi.IdCipl = cp.id
	left join MasterArea a on cp.Branch = a.BAreaCode
	where cp.Branch is not null and cp.Branch <> '' and ci.isDelete = 0 and cpi.IsDelete = 0 and ci.IdCargo = @CargoID

	IF(EXISTS(SELECT branch FROM @branches))
	BEGIN
		SET @Branch = STUFF(
			(
				SELECT ', ' + branch FROM @branches FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)') 
		,1,1,'')
	END

	select 
		ISNULL(c.SsNo, '-') as SsNo
		, ISNULL(CONVERT(VARCHAR(11), ch.CreateDate, 106), '-') as ClApprovedDate
		, ISNULL(c.ClNo, '-') as ReferenceNo
		, ISNULL(e.Employee_Name, '-') as RequestorName
		, ISNULL(e.Email, '-') as RequestorEmail
		, IIF(e.usertype IS NOT NULL, IIF(e.usertype = 'internal', 'PT. TRAKINDO UTAMA', 'PT. Cipta Krida Bahari'),'-') AS UserType
		, IIF(cp.ShipDelivery IS NULL OR LEN(cp.ShipDelivery) <= 0, '-', cp.ShipDelivery) as ShipDelivery
		, IIF(cp.ConsigneeName IS NULL OR LEN(cp.ConsigneeName) <= 0, '-', cp.ConsigneeName) as ConsigneeName
		, IIF(cp.ConsigneeAddress IS NULL OR LEN(cp.ConsigneeAddress) <= 0, '-', cp.ConsigneeAddress) as ConsigneeAddress
		, IIF(cp.ConsigneePic IS NULL OR LEN(cp.ConsigneePic) <= 0, '-', cp.ConsigneePic) as ConsigneePic
		, IIF(cp.ConsigneeEmail IS NULL OR LEN(cp.ConsigneeEmail) <= 0, '-', cp.ConsigneeEmail) as ConsigneeEmail
		, IIF(cp.NotifyName IS NULL OR LEN(cp.NotifyName) <= 0, '-', cp.NotifyName) as NotifyName
		, IIF(cp.NotifyAddress IS NULL OR LEN(cp.NotifyAddress) <= 0, '-', cp.NotifyAddress) as NotifyAddress
		, IIF(cp.NotifyPic IS NULL OR LEN(cp.NotifyPic) <= 0, '-', cp.NotifyPic) as NotifyPic
		, IIF(cp.NotifyEmail IS NULL OR LEN(cp.NotifyEmail) <= 0, '-', cp.NotifyEmail) as NotifyEmail
		, IIF(cp.SoldToName IS NULL OR LEN(cp.SoldToName) <= 0, '-', cp.SoldToName) as SoldToName
		, IIF(cp.SoldToAddress IS NULL OR LEN(cp.SoldToAddress) <= 0, '-', cp.SoldToAddress) as SoldToAddress
		, IIF(cp.SoldToPic IS NULL OR LEN(cp.SoldToPic) <= 0, '-', cp.SoldToPic) as SoldToPic
		, IIF(cp.SoldToEmail IS NULL OR LEN(cp.SoldToEmail) <= 0, '-', cp.SoldToEmail) as SoldToEmail
		, IIF(cp.Category IS NULL OR LEN(cp.Category) <= 0, '-', cp.Category) as Category
		--, CAST(FORMAT(ISNULL(ct.TotalCaseNumber, 0), '#,0.00') as varchar(20)) as TotalCaseNumber
		, CAST(ISNULL(ct.TotalCaseNumber, 0) as varchar(20)) as TotalCaseNumber
		, CAST(FORMAT(ISNULL(ct.TotalNetWeight, 0), '#,0.00') as varchar(20)) as TotalNetWeight
		, CAST(FORMAT(ISNULL(ct.TotalGrossWeight, 0), '#,0.00') as varchar(20)) as TotalGrossWeight
		, CAST(FORMAT(CAST(ISNULL(ct.TotalVolume, 0) as decimal(8,4)), '#,0.00') as varchar(20)) as TotalVolume
		, CAST(FORMAT(ISNULL(ct.TotalAmount, 0), '#,0.00') as varchar(20)) as TotalAmount
		, @Branch as Branch
		, IIF(s.Employee_Name IS NULL OR LEN(s.Employee_Name) <= 0, '-', s.Employee_Name) as SignedName
		, IIF(s.Position_Name IS NULL OR LEN(s.Position_Name) <= 0, '-', s.Position_Name) as SignedPosition
	from Cargo c
	left join (
		select ci.IdCargo, max(cpi.IdCipl) as IdCipl from CargoItem ci
		inner join CiplItem cpi on ci.IdCiplItem = cpi.Id
		where ci.isDelete = 0 and cpi.IsDelete = 0
		group by ci.IdCargo
	) cpi on c.Id = cpi.IdCargo
	outer apply(
		select top 1* from Cipl where id= cpi.IdCipl order by Id desc
	) cp
	left join (
		select 
			CargoID
			, COUNT(CaseNumber) as TotalCaseNumber
			, SUM(NetWeight) as TotalNetWeight
			, SUM(GrossWeight) as TotalGrossWeight
			, SUM(Volume) as TotalVolume
			, SUM(Amount) as TotalAmount 
		from (
			select 
				master.CargoID, master.CiplID
				, MAX(master.CargoDescription) as CargoDescription
				,cpi.CaseNumber as CaseNumber
				--, COUNT(cpi.Id) as CaseNumber
				, (SUM(ci.Width * ci.Length * ci.Height)/1000000) as Volume
				, SUM(ci.Net) as NetWeight
				, SUM(ci.Gross) as GrossWeight
				, SUM(cpi.Extendedvalue) as Amount 
			from
			(
				select 
					ci.Id as CargoItemID
					, ci.IdCargo as CargoID
					, cpi.Id AS CiplItemID
					, cp.id as CiplID
					, ISNULL(cp.Category, '-') as CargoDescription
				from CargoItem ci
				inner join CiplItem cpi on ci.IdCiplItem=cpi.Id and cpi.IsDelete = 0
				inner join Cipl cp on cpi.IdCipl=cp.id and cp.IsDelete = 0
				where ci.Isdelete = 0
			) master
			inner join CargoItem ci on master.CargoItemID = ci.Id and ci.isDelete = 0
			inner join CiplItem cpi on master.CiplItemID = cpi.Id and cpi.IsDelete = 0
			where master.CargoID = @CargoID  
			group by master.CargoID, master.CiplID, cpi.CaseNumber
		) data
		group by CargoID
	) ct on c.Id = ct.CargoID
	outer apply(
		select top 1* from CargoHistory where IdCargo = c.id and Step='Approval By Imex' and Status = 'Approve' order by Id desc
	) ch
	left join dbo.fn_get_employee_internal_ckb() e on c.CreateBy = e.AD_User
	left join fn_get_cl_request_list_all() r on c.id = r.IdCl
	left join fn_get_employee_internal_ckb() s on ch.UpdateBy= s.AD_User
	where c.Id = @CargoID
END


GO
