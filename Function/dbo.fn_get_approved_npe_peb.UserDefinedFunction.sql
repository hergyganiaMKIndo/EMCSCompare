USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_approved_npe_peb] ()
RETURNS TABLE 
AS
RETURN 
(
	select 
		CONVERT(VARCHAR(10), cp.CreateDate, 120) as CiplDate,
		ci.IdCargo, 
		ci.Id as IdCargoItem, 
		cpi.Id as IdCiplItem, 
		cp.id as IdCipl, 
		IIF(p.Value = 4, 'Sales', 'Non Sales') as ExportType,
		CONVERT(VARCHAR(10), rc.CreateDate, 120) as CreatedDate,
		c.ClNo,
		ISNULL(peb.AjuNumber, '-') as AjuNumber,
		ISNULL(peb.NpeNumber, '-') as NpeNumber,
		ISNULL(CONVERT(VARCHAR(11), peb.NpeDate, 106), '-') as NpeDate,
		IIF(cf.Attention IS NULL OR LEN(cf.Attention) <= 0, ISNULL(cf.Forwader, '-'), cf.Attention) as CustomBroker,
		IIF(cp.ShippingMethod IS NULL OR LEN(cp.ShippingMethod) <= 0, '-', cp.ShippingMethod) as ShippingMethod,
		IIF(c.CargoType IS NULL OR LEN(c.CargoType) <= 0, '-', c.CargoType) as CargoType,
		IIF(ci.ContainerNumber IS NULL OR LEN(ci.ContainerNumber) <= 0, '-', ci.ContainerNumber) as ContainerNumber,
		IIF(c.CargoType IS NULL OR LEN(c.CargoType) <= 0, '-', c.CargoType) as Name,
		ISNULL(cpi.GrossWeight, 0) as GrossWeight,
		IIF(
			LTRIM(RTRIM(CAST('<M>' + REPLACE(cp.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))
			IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(cp.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))) <= 0, IIF(CHARINDEX('Permanent', cp.ExportType) > 0, 'Permanent', '-'),--'-',
			LTRIM(RTRIM(CAST('<M>' + REPLACE(cp.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))
		) As PermanentTemporary,
		IIF(
			LTRIM(RTRIM(CAST('<M>' + REPLACE(cp.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
			IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(cp.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))) <= 0, '-',
			LTRIM(RTRIM(CAST('<M>' + REPLACE(cp.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
		) As SalesNonSales,
		IIF(c.PortOfLoading IS NULL OR LEN(c.PortOfLoading) <= 0, '-', c.PortOfLoading) as PortOfLoading,
		IIF(c.PortOfDestination IS NULL OR LEN(c.PortOfDestination) <= 0, '-', c.PortOfDestination) as PortOfDestination,
		ISNULL(CONVERT(VARCHAR(11), c.SailingSchedule, 106), '-') as ETD,
		ISNULL(CONVERT(VARCHAR(11), c.ArrivalDestination, 106), '-') as ETA,
		IIF(bl.Number IS NULL OR LEN(bl.Number) <= 0, '-', bl.Number) as MasterBlAwbNumber,
		ISNULL(CONVERT(VARCHAR(11), bl.MasterBlDate, 106), '-') as MasterBlAwbDate,
		IIF(bl.HouseBlNumber IS NULL OR LEN(bl.HouseBlNumber) <= 0, '-', bl.HouseBlNumber) as HouseBlAwbNumber,
		ISNULL(CONVERT(VARCHAR(11), bl.HouseBlDate, 106), '-') as HouseBlAwbDate,
		IIF(c.SsNo IS NULL OR LEN(c.SsNo) <= 0, '-', c.SsNo) as SsNo,
		ISNULL(CONVERT(VARCHAR(11), peb.PebDate, 106), '-') as PebDate,		
		CONCAT(LEFT(DATENAME(MONTH, peb.PebDate), 3),'-', DATEPART(YEAR, peb.PebDate)) as PebMonth,
		CONCAT(DATEPART(YEAR, peb.PebDate), '-', DATEPART(MONTH, peb.PebDate), '-', DATEPART(DAY, peb.PebDate)) as PebDateNumeric,
		IIF(LEN(cp.IncoTerm) <= 0, '-', cp.IncoTerm) as IncoTerm,
		IIF(cpi.Currency IS NULL OR LEN(cpi.Currency) <= 0, 
			IIF(cp.Currency IS NULL OR LEN(cp.Currency) <= 0, '-', cp.Currency)
		, cpi.Currency) as Currency,
		ISNULL(cpi.UnitPrice, 0) as UnitPrice,
		ISNULL(peb.FreightPayment, 0) as FreightPayment,
		ISNULL(peb.InsuranceAmount, 0) as InsuranceAmount,
		ISNULL(cpi.UnitPrice, 0) + ISNULL(peb.FreightPayment, 0) + ISNULL(peb.InsuranceAmount, 0) as TotalAmount,
		IIF(cp.CiplNo IS NULL OR LEN(cp.CiplNo) <= 0, '-', cp.CiplNo) as CiplNo,
		IIF(a.BAreaName IS NULL OR LEN(a.BAreaName) <= 0, '-', a.BAreaName) as Branch,
		ISNULL(CONVERT(VARCHAR(11), cp.CreateDate, 106), '-') as CiplCreateDate,
		IIF(cp.Remarks IS NULL OR LEN(cp.Remarks) <= 0, '-', cp.Remarks) as Remarks,
		IIF(cp.ConsigneeName IS NULL OR LEN(cp.ConsigneeName) <= 0, '-', cp.ConsigneeName) as ConsigneeName,
		IIF(cp.ConsigneeCountry IS NULL OR LEN(cp.ConsigneeCountry) <= 0, '-', cp.ConsigneeCountry) as ConsigneeCountry,
		IIF(mc.CustName IS NULL OR LEN(mc.CustName) <= 0, '-', mc.CustName) as CustomerName,
		IIF(mc.Country IS NULL OR LEN(mc.Country) <= 0, '-', mc.Country) as CustomerCountry,
		IIF(LEN(cp.Category) <= 0, '-', cp.Category) as Category, 
		IIF(cpi.CaseNumber IS NULL OR LEN(cpi.CaseNumber) <= 0, '-', cpi.CaseNumber) as CaseNumber,
		ISNULL(cpi.Quantity, 0) as Quantity,
		IIF(cpi.Uom IS NULL OR LEN(cpi.Uom) <= 0, '-', cpi.Uom) as QuantityUom,
		ISNULL(cpi.NetWeight, 0) as Weight,
		'KGS' as WeightUom,
		ISNULL(cpi.ExtendedValue, 0) as ExtendedValue, 
		ISNULL(mkUSD.Rate, 0) as USDRate,
		ISNULL(mk.Rate, 0) as CurrencyRate,
		ISNULL(cpi.ExtendedValue, 0) * IIF(mkUSD.Rate IS NULL, ISNULL(mk.Rate, 0), ISNULL(mk.Rate, 0) / mkUSD.Rate) as USDTotalExport,
		ISNULL(cpi.ExtendedValue, 0) * ISNULL(mk.Rate, 0) as IDRTotalExport,
		IIF(p.Value = 4, cpi.ExtendedValue * IIF(mkUSD.Rate IS NULL, ISNULL(mk.Rate, 0), ISNULL(mk.Rate, 0) / mkUSD.Rate), 0) as SalesValue,
		IIF(p.Value = 4, 0, cpi.ExtendedValue * IIF(mkUSD.Rate IS NULL, ISNULL(mk.Rate, 0), ISNULL(mk.Rate, 0) / mkUSD.Rate)) as NonSalesValue,
		peb.PebDate PebData

	from Temptable_cl_request_list_all rc
	--RequestCl rc 
	--inner join FlowStep fs on rc.IdStep = fs.Id
	inner join Cargo c on rc.IdCl = c.Id
	left join CargoItem ci on rc.IdCl = ci.IdCargo
	left join CiplItem cpi on ci.IdCiplItem = cpi.Id
	left join Cipl cp on cpi.IdCipl = cp.id
	left join CiplForwader cf on cp.id = cf.IdCipl 
	left join MasterArea a on right(cp.Branch,3) = right(a.BAreaCode,3)
	left join MasterParameter p on cp.ExportType = p.Name
	left join NpePeb peb on rc.IdCl = peb.IdCl 
	left join BlAwb bl on rc.IdCl = bl.IdCl 
	outer apply( 
		select top 1 * from MasterCustomer where CustNr = cpi.IdCustomer order by ID desc
	)mc
	left join MasterKurs mk on mk.Curr = ISNULL(cpi.Currency, cp.Currency) and CONVERT(VARCHAR(11), cpi.CreateDate, 23) >= mk.StartDate and CONVERT(VARCHAR(11), cpi.CreateDate, 23) <= mk.EndDate
	left join MasterKurs mkUSD on mkUSD.Curr = 'USD' and CONVERT(VARCHAR(11), cpi.CreateDate, 23) >= mkUSD.StartDate and CONVERT(VARCHAR(11), cpi.CreateDate, 23) <= mkUSD.EndDate
	where (rc.IdStep = 10020 and rc.Status = 'Approve') or rc.IdStep = 10021 or (rc.IdStep = 10022 and (rc.Status = 'Submit' or rc.Status = 'Approve'))
	AND Cp.IsDelete = 0 ANd cp.CreateBy<>'System'
	--rc.Status = 'Approve' and fs.Step = 'Approve NPE & PEB'
)


GO
