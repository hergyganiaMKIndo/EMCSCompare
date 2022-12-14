USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CiplForExportInvoicePL_Header] 
	@CiplID bigint
AS
BEGIN
    select 
		ISNULL(c.CiplNo, '-') as CiplNo
		, ISNULL(CONVERT(VARCHAR(9), c.CreateDate, 6), '-') as CreateDate
		, ISNULL(a.BAreaName, '-') as Area
		, 'PT. Trakindo Utama' + IIF(a.ID is not null, ' - ' + a.BAreaName, '-') as FullArea
		, e.Employee_Name as RequestorName
		, e.Email as RequestorEmail
		, IIF(c.ConsigneeName IS NULL OR LEN(c.ConsigneeName) <= 0, '-', c.ConsigneeName) as ConsigneeName
		, IIF(c.ConsigneeAddress IS NULL OR LEN(c.ConsigneeAddress) <= 0, '-', c.ConsigneeAddress) as ConsigneeAddress
		, IIF(c.ConsigneeTelephone IS NULL OR LEN(c.ConsigneeTelephone) <= 0, '-', c.ConsigneeTelephone) as ConsigneeTelephone
		, IIF(c.ConsigneeFax IS NULL OR LEN(c.ConsigneeFax) <= 0, '-', c.ConsigneeFax) as ConsigneeFax
		, IIF(c.ConsigneePic IS NULL OR LEN(c.ConsigneePic) <= 0, '-', c.ConsigneePic) as ConsigneePic
		, IIF(c.ConsigneeEmail IS NULL OR LEN(c.ConsigneeEmail) <= 0, '-', c.ConsigneeEmail) as ConsigneeEmail
		, IIF(c.NotifyName IS NULL OR LEN(c.NotifyName) <= 0, '-', c.NotifyName) as NotifyName
		, IIF(c.NotifyAddress IS NULL OR LEN(c.NotifyAddress) <= 0, '-', c.NotifyAddress) as NotifyAddress
		, IIF(c.NotifyTelephone IS NULL OR LEN(c.NotifyTelephone) <= 0, '-', c.NotifyTelephone) as NotifyTelephone
		, IIF(c.NotifyFax IS NULL OR LEN(c.NotifyFax) <= 0, '-', c.NotifyFax) as NotifyFax
		, IIF(c.NotifyPic IS NULL OR LEN(c.NotifyPic) <= 0, '-', c.NotifyPic) as NotifyPic
		, IIF(c.NotifyEmail IS NULL OR LEN(c.NotifyEmail) <= 0, '-', c.NotifyEmail) as NotifyEmail
		, IIF(c.SoldToName IS NULL OR LEN(c.SoldToName) <= 0, '-', c.SoldToName) as SoldToName
		, IIF(c.SoldToAddress IS NULL OR LEN(c.SoldToAddress) <= 0, '-', c.SoldToAddress) as SoldToAddress
		, IIF(c.SoldToTelephone IS NULL OR LEN(c.SoldToTelephone) <= 0, '-', c.SoldToTelephone) as SoldToTelephone
		, IIF(c.SoldToFax IS NULL OR LEN(c.SoldToFax) <= 0, '-', c.SoldToFax) as SoldToFax
		, IIF(c.SoldToPic IS NULL OR LEN(c.SoldToPic) <= 0, '-', c.SoldToPic) as SoldToPic
		, IIF(c.SoldToEmail IS NULL OR LEN(c.SoldToEmail) <= 0, '-', c.SoldToEmail) as SoldToEmail
		, IIF(ci.Currency IS NULL OR LEN(ci.Currency) <= 0, '-', ci.Currency) as CurrencyDesc
		, IIF(c.IncoTerm IS NULL OR LEN(c.IncoTerm) <= 0, '-', c.IncoTerm) as ShipmentTerm
		, case 
			when c.IncoTerm = 'EXW' 
				then c.IncoTerm + IIF(a.ID is not null, ' - PT. Trakindo Utama ' + a.BAreaName, '') 
			when c.IncoTerm = 'FCA' or c.IncoTerm = 'FAS' or c.IncoTerm = 'FOB' 
				then c.IncoTerm + IIF(load.Id is not null, ' - ' + load.Name, '')  
			when c.IncoTerm = 'CFR' or c.IncoTerm = 'CIF' or c.IncoTerm = 'CIP' or c.IncoTerm = 'CPT'or c.IncoTerm = 'DAT' 
				then c.IncoTerm + IIF(dest.Id is not null, ' - ' + dest.Name, '')  
			when c.IncoTerm = 'DAP' or c.IncoTerm = 'DDP' 
				then c.IncoTerm + IIF(c.SoldToName is not null and LEN(c.SoldToName) > 0, ' - ' + c.SoldToName, IIF(c.ConsigneeName is not null and LEN(c.ConsigneeName) > 0, ' - ' + c.ConsigneeName, '') ) 
			else IIF(c.IncoTerm IS NULL OR LEN(c.IncoTerm) <= 0, '-', c.IncoTerm) 
		end as TotalValue
		, IIF(c.ShippingMethod IS NULL OR LEN(c.ShippingMethod) <= 0, '-', c.ShippingMethod) as ShippingMethod
		, '-' as CODesc
		, ISNULL(cg.VesselFlight, '-') as VesselCarier
		, ISNULL(CONVERT(VARCHAR(9), cg.SailingSchedule, 6), '-') as SailingOn
		, IIF(load.Id IS NULL, '-', load.Country + ' - ' + load.Name) as LoadingPort
		, IIF(dest.Id IS NULL, '-', dest.Country + ' - ' + dest.Name) as DestinationPort
		--, IIF(c.DestinationPort IS NULL OR LEN(c.DestinationPort) <= 0, '-', c.DestinationPort) as DestinationPort
		, c.PaymentTerms
		, IIF(c.SoldToName IS NULL OR LEN(c.SoldToName) <= 0, IIF(c.ConsigneeName IS NULL OR LEN(c.ConsigneeName) <= 0, '-', c.ConsigneeName), c.SoldToName) as FinalDestination
		, ISNULL(ci.TotalQuantity, '-') as TotalQuantity
		, ISNULL(ci.TotalCaseNumber, '-') as TotalCaseNumber
		, ISNULL(ci.TotalVolume, '-') as TotalVolume
		, ISNULL(ci.TotalNetWeight, '-') as TotalNetWeight
		, ISNULL(ci.TotalGrossWeight, '-') as TotalGrossWeight
		, ISNULL(ci.TotalExtendedValue, '-') as TotalExtendedValue	
		, IIF(c.ShippingMarks IS NULL OR LEN(c.ShippingMarks) <= 0, '-', c.ShippingMarks) as ShippingMarksDesc
		, IIF(c.Remarks IS NULL OR LEN(c.Remarks) <= 0, '-', c.Remarks) as RemarksDesc
		, IIF(c.LcNoDate IS NULL OR LEN(c.LcNoDate) <= 0, '-', c.LcNoDate) as LcNoDate
		, IIF(s.Employee_Name IS NULL OR LEN(s.Employee_Name) <= 0, '-', s.Employee_Name) as SignedName
		, IIF(s.Position_Name IS NULL OR LEN(s.Position_Name) <= 0, '-', s.Position_Name) as SignedPosition
		, ISNULL(c.ShipDelivery, '-') as ShipDelivery	
		, ISNULL(c.EdoNo, '-') as EdiNo
	from Cipl c
	left join (
		select 
			c.id
			, case
				when c.Category = 'CATERPILLAR SPAREPARTS' AND c.CategoriItem = 'SIB'
					then CAST(count(distinct ISNULL(ci.JCode, '-')) as varchar(5))
				when c.Category = 'CATERPILLAR SPAREPARTS' AND (c.CategoriItem = 'PRA' OR c.CategoriItem = 'Old Core')
					then CAST(count(distinct ISNULL(ci.CaseNumber, '-')) as varchar(5))
				--
				when c.Category = 'CATERPILLAR USED EQUIPMENT'
					then CAST(count(distinct ISNULL(ci.Id, '-')) as varchar(5))
				--
				else CAST(count(distinct(IIF(sn != '', sn, null))) as varchar(5)) --CAST(count(distinct ci.Sn) as varchar(5))
			end as TotalCaseNumber
			, MAX(ISNULL(ci.Currency, '-')) as Currency
			, CAST(FORMAT(SUM(ISNULL(ci.Quantity, 0)), '#,0') as varchar(20)) as TotalQuantity
			--, CAST(count(ci.Id) as varchar(5)) as TotalCaseNumber
			--, CAST(count(distinct ISNULL(CaseNumber, '-')) as varchar(5)) as TotalCaseNumber
			, CAST(SUM(ISNULL(Volume, 0)) as varchar(20)) as TotalVolume
			, CAST(FORMAT(SUM(ISNULL(NetWeight, 0)), '#,0.00') as varchar(20)) as TotalNetWeight
			, CAST(FORMAT(SUM(ISNULL(GrossWeight, 0)), '#,0.00') as varchar(20)) as TotalGrossWeight
			, CONCAT(MAX(ISNULL(ci.Currency, '-')),' ', FORMAT(sum(ISNULL(ci.ExtendedValue, 0)), '#,0.00')) as TotalExtendedValue
		from Cipl c
		left join CiplItem ci on c.id=ci.IdCipl
			AND ci.IsDelete = 0 
		--where ci.IsDelete = 0 
		group by c.id, c.Category, c.CategoriItem
	)ci on c.id = ci.id
	--AND ci.IsDelete = 0 
	inner join dbo.fn_get_employee_internal_ckb() e on c.CreateBy = e.AD_User
	left join cargocipl cgc on cgc.idcipl = c.id 
		AND cgc.IsDelete = 0
	left join cargo cg on cg.id = cgc.idcargo
		AND cg.IsDelete = 0
	left join MasterArea a on c.Branch = a.BAreaCode
	left join fn_get_cipl_request_list_all() r on c.id = r.IdCipl
	left join fn_get_employee_internal_ckb() s on r.UpdateBy= s.AD_User
	left join MasterAirSeaPort load on (SELECT SUBSTRING(c.LoadingPort,0,CHARINDEX('-',c.LoadingPort,0))) = load.Code
	left join MasterAirSeaPort dest on (SELECT SUBSTRING(c.DestinationPort,0,CHARINDEX('-',c.DestinationPort,0))) = dest.Code
	where c.id = @CiplID  
END

GO
