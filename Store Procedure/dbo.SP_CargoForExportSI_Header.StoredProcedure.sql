USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CargoForExportSI_Header]
	@CargoID bigint
AS
BEGIN

    select 
		ISNULL(si.SlNo, '-') as SiNo
		, ISNULL(CONVERT(VARCHAR(11), ch.CreateDate, 106), '-') as SiSubmitDate
		, ISNULL(e.Employee_Name, '-') as SiSubmitter
		, ISNULL(c.SsNo, ISNULL(cp.CiplNo, '-')) as ReferenceNo
		, IIF(cf.Forwader IS NULL OR LEN(cf.Forwader) <= 0, '-', cf.Forwader) as Forwarder
		, IIF(cf.Attention IS NULL OR LEN(cf.Attention) <= 0, '-', cf.Attention) as ForwarderAttention
		, IIF(cf.Email IS NULL OR LEN(cf.Email) <= 0, '-', cf.Email) as ForwarderEmail
		, IIF(cf.Contact IS NULL OR LEN(cf.Contact) <= 0, '-', cf.Contact) as ForwarderContact
		, IIF(cp.ShipDelivery IS NULL OR LEN(cp.ShipDelivery) <= 0, '-', cp.ShipDelivery) as ShipDelivery
		, IIF(cp.ConsigneeName IS NULL OR LEN(cp.ConsigneeName) <= 0, '-', cp.ConsigneeName) as ConsigneeName
		, IIF(cp.ConsigneeAddress IS NULL OR LEN(cp.ConsigneeAddress) <= 0, '-', cp.ConsigneeAddress) as ConsigneeAddress
		, IIF(cp.ConsigneePic IS NULL OR LEN(cp.ConsigneePic) <= 0, '-', cp.ConsigneePic) as ConsigneePic
		, IIF(cp.ConsigneeEmail IS NULL OR LEN(cp.ConsigneeEmail) <= 0, '-', cp.ConsigneeEmail) as ConsigneeEmail
		, IIF(cp.ConsigneeTelephone IS NULL OR LEN(cp.ConsigneeTelephone) <= 0, '-', cp.ConsigneeTelephone) as ConsigneeTelephone
		, IIF(cp.NotifyName IS NULL OR LEN(cp.NotifyName) <= 0, '-', cp.NotifyName) as NotifyName
		, IIF(cp.NotifyAddress IS NULL OR LEN(cp.NotifyAddress) <= 0, '-', cp.NotifyAddress) as NotifyAddress
		, IIF(cp.NotifyPic IS NULL OR LEN(cp.NotifyPic) <= 0, '-', cp.NotifyPic) as NotifyPic
		, IIF(cp.NotifyEmail IS NULL OR LEN(cp.NotifyEmail) <= 0, '-', cp.NotifyEmail) as NotifyEmail
		, IIF(cp.NotifyTelephone IS NULL OR LEN(cp.NotifyTelephone) <= 0, '-', cp.NotifyTelephone) as NotifyTelephone
		, IIF(cp.SoldToName IS NULL OR LEN(cp.SoldToName) <= 0, '-', cp.SoldToName) as SoldToName
		, IIF(cp.SoldToAddress IS NULL OR LEN(cp.SoldToAddress) <= 0, '-', cp.SoldToAddress) as SoldToAddress
		, IIF(cp.SoldToPic IS NULL OR LEN(cp.SoldToPic) <= 0, '-', cp.SoldToPic) as SoldToPic
		, IIF(cp.SoldToEmail IS NULL OR LEN(cp.SoldToEmail) <= 0, '-', cp.SoldToEmail) as SoldToEmail
		, IIF(cp.SoldToTelephone IS NULL OR LEN(cp.SoldToTelephone) <= 0, '-', cp.SoldToTelephone) as SoldToTelephone
		, IIF(cp.IncoTerm IS NULL OR LEN(cp.IncoTerm) <= 0, '-', cp.IncoTerm) as IncoTerm
		, IIF(cp.ShippingMarks IS NULL OR LEN(cp.ShippingMarks) <= 0, '-', cp.ShippingMarks) as ShippingMarks
		, IIF(cp.Category IS NULL OR LEN(cp.Category) <= 0, '-', cp.Category) as Description
		--, CAST(FORMAT(ISNULL(CAST(ct.TotalVolume as decimal(18,2)), 0), '#,0.00') as varchar(20)) as TotalVolume
		, CAST(FORMAT(ISNULL(ct.TotalVolume, 0), '#,0.000000') as varchar(20)) as TotalVolume
		, CAST(FORMAT(ISNULL(ct.TotalNetWeight, 0), '#,0.00') as varchar(20)) as TotalNetWeight
		, CAST(FORMAT(ISNULL(ct.TotalGrossWeight, 0), '#,0.00') as varchar(20)) as TotalGrossWeight
		, IIF(c.BookingNumber IS NULL OR LEN(c.BookingNumber) <= 0, '-', c.BookingNumber) as BookingNumber
		, ISNULL(CONVERT(VARCHAR(11), c.BookingDate, 106), '-') as BookingDate
		, ISNULL(c.PortOfLoading, '-') as PortOfLoading
		, IIF(dest.Id IS NULL, '-', dest.Country + ' - ' + dest.Name) as PortOfDestination
		, ISNULL(CONVERT(VARCHAR(11), c.ArrivalDestination, 106), '-') as ETA
		, ISNULL(CONVERT(VARCHAR(11), c.SailingSchedule, 106), '-') as ETD
		, IIF(c.VoyageVesselFlight IS NULL OR LEN(c.VoyageVesselFlight) <= 0, '-', c.VoyageVesselFlight) as VesselVoyage
		, IIF(c.VoyageConnectingVessel IS NULL OR LEN(c.VoyageConnectingVessel) <= 0, '-', c.VoyageConnectingVessel) as ConnectingVesselVoyage
		, IIF(cp.ConsigneeName IS NULL OR LEN(cp.ConsigneeName) <= 0, '-', cp.ConsigneeName) as FinalDestination
		, IIF(si.DocumentRequired IS NULL OR LEN(si.DocumentRequired) <= 0, '-', si.DocumentRequired) as DocumentRequired
		, IIF(si.SpecialInstruction IS NULL OR LEN(si.SpecialInstruction) <= 0, '-', si.SpecialInstruction) as SpecialInstruction
		, IIF(c.StuffingDateStarted IS NULL OR LEN(c.StuffingDateStarted) <= 0, 'No Stuffing', 'Stuffing on : ' + CONVERT(VARCHAR(20), c.StuffingDateStarted, 107)) as StuffingDate
		, IIF(c.StuffingDateFinished IS NULL OR LEN(c.StuffingDateFinished) <= 0, 'No Stuffing', 'Stuffing off : ' + CONVERT(VARCHAR(20), c.StuffingDateFinished, 107)) as StuffingDateOff
		, IIF(c.Liner IS NULL OR LEN(c.Liner) <= 0, 'No Shipping Line', 'Shipping Line : ' + c.Liner) as Liner
		, IIF(s.Employee_Name IS NULL OR LEN(s.Employee_Name) <= 0, '-', s.Employee_Name) as SignedName
		, IIF(s.Position_Name IS NULL OR LEN(s.Position_Name) <= 0, '-', s.Position_Name) as SignedPosition
	from Cargo c
	left join (
		select 
			ci.IdCargo
			, max(cpi.IdCipl) as IdCipl 
		from CargoItem ci
		inner join CiplItem cpi on ci.IdCiplItem = cpi.Id
		where ci.isDelete = 0 and cpi.IsDelete = 0
		group by ci.IdCargo
	) cpi on c.Id = cpi.IdCargo
	outer apply(
		select top 1* from Cipl where id= cpi.IdCipl and IsDelete = 0 order by Id desc
	) cp
	outer apply(
		select top 1* from CiplForwader where IdCipl IN(
			select distinct cp.id from CargoItem ci
			inner join CiplItem cpi on ci.IdCiplItem=cpi.Id
			inner join Cipl cp on cpi.IdCipl=cp.id
			where ci.IdCargo = @CargoID and ci.isDelete = 0 and cpi.IsDelete = 0 and cp.IsDelete = 0
		) order by Id desc
	) cf
	left join ShippingInstruction si on c.Id = si.IdCL
	left join (
		select 
			CargoID
			, SUM(CaseNumber) as TotalCaseNumber
			, SUM(NetWeight) as TotalNetWeight
			, SUM(GrossWeight) as TotalGrossWeight
			, SUM(Volume) as TotalVolume
			, SUM(Amount) as TotalAmount 
		from (
			select 
				master.CargoID
				, master.CiplID
				, COUNT(cpi.Id) as CaseNumber
				--, COUNT(DISTINCT cpi.CaseNumber) as CaseNumber
				, SUM(ci.Net) as NetWeight, SUM(ci.Gross) as GrossWeight
				, SUM((ci.Width*ci.Length*ci.Height)/1000000) as Volume
				, SUM(cpi.UnitPrice) as Amount 
			from (
				select 
					ci.Id as CargoItemID
					, ci.IdCargo as CargoID
					, cpi.Id AS CiplItemID
					, cp.id as CiplID
					--, ISNULL(cc.Description, '-') as CargoDescription 
					, ISNULL(cp.Category, '-') as Description
				from CargoItem ci
				inner join CiplItem cpi on ci.IdCiplItem=cpi.Id
				inner join Cipl cp on cpi.IdCipl=cp.id
				--left join CargoContainer cc on ci.IdContainer = cc.Id
			) master
			inner join CargoItem ci on master.CargoItemID = ci.Id
			inner join CiplItem cpi on master.CiplItemID = cpi.Id
			where ci.isDelete = 0 and cpi.IsDelete = 0
			group by master.CargoID, master.CiplID
		) data
		group by CargoID
	) ct on c.Id = ct.CargoID
	outer apply(
		select top 1* from CargoHistory where IdCargo = c.id and Step='Create SI' and Status = 'Submit' order by Id desc
	) ch
	left join dbo.fn_get_employee_internal_ckb() e on ch.CreateBy = e.AD_User
	left join MasterAirSeaPort load on LEFT(c.PortOfLoading, 5) = load.Code
	left join MasterAirSeaPort dest on LEFT(c.PortOfDestination, 5) = dest.Code
	left join fn_get_cl_request_list_all() r on c.id = r.IdCl
	left join fn_get_employee_internal_ckb() s on ch.UpdateBy= s.AD_User
	where c.Id = @CargoID and c.IsDelete = 0

END
GO
