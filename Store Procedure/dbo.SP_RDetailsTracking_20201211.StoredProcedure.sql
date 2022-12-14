USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_RDetailsTracking_20201211] 
	@StartMonth NVARCHAR(20),
	@EndMonth NVARCHAR(20),
	@ParamName NVARCHAR(50),
	@ParamValue NVARCHAR(200),
	@KeyNum NVARCHAR(200)
AS
BEGIN

	declare @sql varchar(max) = 
	--N'declare @StartMonth NVARCHAR(20)='''+@StartMonth+''',
	--		@EndMonth NVARCHAR(20)='''+@EndMonth+'''
	--SELECT 
	--	PebMonth
	--		, CAST(ROW_NUMBER() OVER (PARTITION BY PebMonth ORDER BY PebMonth) as varchar(5)) RowNumber
	--		, MAX(AjuNumber) AS AjuNumber
	--		, MAX(NpeNumber) AS NpeNumber
	--		, MAX(NpeDate) AS NpeDate
	--		, MAX(CustomBroker) AS CustomsBroker
	--		, MAX(ShippingMethod) AS ShippingMethod
	--		, MAX(CargoType) AS CargoType
	--		, MAX(ContainerNumber) AS ContainerNumber
	--		, CAST(COUNT(DISTINCT Name) as varchar(10)) AS Packages
	--		, FORMAT(SUM(GrossWeight),''#,0.00'') AS GrossWeight
	--		, MAX(PermanentTemporary) AS PermanentTemporary
	--		, MAX(SalesNonSales) AS SalesNonSales
	--		, MAX(PortOfLoading) AS PortOfLoading
	--		, MAX(PortOfDestination) AS PortOfDestination
	--		, MAX(ETD) AS ETD
	--		, MAX(ETA) AS ETA
	--		, MAX(MasterBlAwbNumber) AS MasterBlAwbNumber
	--		, MAX(MasterBlAwbDate) AS MasterBlAwbDate
	--		, MAX(SsNo) AS SsNo
	--		, MAX(PebDate) AS PebDate
	--		, MAX(IncoTerm) AS IncoTerms
	--		, MAX(Currency) AS Currency
	--		, FORMAT(SUM(UnitPrice),''#,0.00'') AS UnitPrice
	--		, FORMAT(SUM(FreightPayment),''#,0.00'') AS FreightPyment
	--		, FORMAT(SUM(InsuranceAmount),''#,0.00'') AS InsuranceAmount
	--		, FORMAT(SUM(TotalAmount),''#,0.00'') AS TotalAmount
	--		, MAX(CiplNo) AS CiplNo
	--		, MAX(Branch) AS Branch
	--		, MAX(CiplCreateDate) AS CiplCreateDate
	--		, MAX(Remarks) AS Remarks
	--		, MAX(ConsigneeName) AS ConsigneeName
	--		, MAX(ConsigneeCountry) AS ConsigneeCountry
	--		, MAX(CustomerName) AS CustomerName
	--		, MAX(CustomerCountry) AS CustomerCountry
	--		, MAX(Category) AS Category
	--		, CAST(SUM(Quantity) as varchar(10)) AS Quantity
	--		, MAX(QuantityUom) AS QuantityUom
	--		, FORMAT(SUM(Weight),''#,0.00'') AS Weight
	--		, MAX(WeightUom) AS WeightUom
	--		, FORMAT(MAX(ExtendedValue),''#,0.00'') AS ExtendedValue
	--		, FORMAT(MAX(USDRate),''#,0.00'') AS USDRate
	--		, FORMAT(MAX(CurrencyRate),''#,0.00'') AS CurrencyRate
	--		, FORMAT(SUM(USDTotalExport),''#,0.00'') AS USDTotalExport
	--		, FORMAT(SUM(IDRTotalExport),''#,0.00'') AS IDRTotalExport
	--		, FORMAT(SUM(SalesValue),''#,0.00'') AS SalesValue
	--		, FORMAT(SUM(NonSalesValue),''#,0.00'') AS NonSalesValue
	--FROM [dbo].[fn_get_approved_npe_peb] ()
	--WHERE ((DATEPART(MONTH, PebDateNumeric) >= DATEPART(MONTH, @StartMonth) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @StartMonth)) OR @StartMonth = '''') 
	--		AND ((DATEPART(MONTH, PebDateNumeric) <= DATEPART(MONTH, @EndMonth) AND DATEPART(YEAR, PebDateNumeric) = DATEPART(YEAR, @EndMonth)) OR @EndMonth = '''')'+ 
	--		IIF(@ParamName <> '', 'AND ('+@ParamName+' like ''%'+@ParamValue+'%'')', '') +'
	--GROUP BY PebMonth, IdCargo, IdCipl
	--ORDER BY PebMonth, IdCargo, IdCipl'
	N'declare @StartMonth NVARCHAR(20)='''+@StartMonth+''',
			@EndMonth NVARCHAR(20)='''+@EndMonth+'''
	'
	
	--print(@sql);
	if (@KeyNum='undefined')

	SELECT 
		CONCAT(LEFT(DATENAME(MONTH,  t0.UpdateDate), 3), '-', DATEPART(YEAR,  t0.UpdateDate)) PebMonth,
		CAST(ROW_NUMBER() OVER (PARTITION BY CONCAT(LEFT(DATENAME(MONTH,  t0.UpdateDate), 3), '-', DATEPART(YEAR,  t0.UpdateDate)) ORDER BY t0.UpdateDate) as varchar(5)) RowNumber,
		IIF(t0.ReferenceNo = '', '-', t0.ReferenceNo) ReferenceNo,
		t0.CiplNo,
		t0.EdoNo as EDINo,
		IIF(t0.PermanentTemporary = 'Repair Return (Temporary)', 
			'Temporary', IIF(t0.PermanentTemporary = 'Return (Permanent)', 
				'Permanent', IIF(t0.PermanentTemporary = 'Personal Effect (Permanent)', 
					'Permanent', 
		'Permanent'))) as PermanentTemporary,
		IIF(t0.SalesNonSales <> 'Non Sales', IIF(
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.SalesNonSales, ' ' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
					IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.SalesNonSales, ' ' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))) <= 0, ' ',
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.SalesNonSales, ' ' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
		), t0.SalesNonSales) as SalesNonSales,
		t0.Remarks,
		t0.ConsigneeName,
		t0.ConsigneeAddress,
		t0.ConsigneeCountry,
		t0.ConsigneeTelephone,
		t0.ConsigneeFax,
		t0.ConsigneePic,
		t0.ConsigneeEmail,
		t0.NotifyName,
		t0.NotifyAddress,
		t0.NotifyCountry,
		t0.NotifyTelephone,
		t0.NotifyFax,
		t0.NotifyPic,
		t0.NotifyEmail,
		t0.SoldToName,
		t0.SoldToAddress,
		t0.SoldToCountry,
		t0.SoldToTelephone,
		t0.SoldToFax,
		t0.SoldToPic,
		t0.SoldToEmail,
		t0.ShippingMethod,
		t0.IncoTerm as IncoTerms,
		IIF(t0.Category = 'MISCELLANEOUS', t0.CategoriItem, t0.Category) as DescGoods, 
		IIF(t0.Category = 'MISCELLANEOUS', t0.Category, IIF(t0.Category = 'CATERPILLAR SPAREPARTS', 'SPAREPARTS' , t0.CategoriItem)) as Category,
		IIF(t0.Category = 'MISCELLANEOUS' or t0.Category = 'CATERPILLAR USED EQUIPMENT' or t0.Category = 'CATERPILLAR UNIT', '-', t0.CategoriItem) as SubCategory,
		IIF(t0.ExportType = 'Sales (Permanent)', 
			'-', IIF(t0.ExportType = 'Non Sales - Repair Return (Temporary)', 
					'RR', IIF(t0.ExportType = 'Non Sales - Return (Permanent)', 
					'R' , IIF(t0.ExportType = 'Non Sales - Personal Effect (Permanent)',
					'PE', '-'))))
		as [Type],
		CONCAT(CONVERT(VARCHAR(9), t0.UpdateDate, 6), ' ', CONVERT(VARCHAR(9), t0.UpdateDate, 8)) CiplCreateDate,
		t0.CiplApprovalDate,
		t0.PICName,
		t0.PICApproverName,
		t0.GrNo as RGNo,
		t0.RGDate,
		t0.RGApprovalDate,
		t0.RGApproverName,
		CONCAT(CONVERT(VARCHAR(18), t2.CreateDate, 6), ' ', CONVERT(VARCHAR(20), t2.CreateDate, 8)) ClDate,
		t2.ClNo,
		CONVERT(VARCHAR(11), t2.SailingSchedule, 106) as ETD,
		CONVERT(VARCHAR(11), t2.ArrivalDestination, 106) as ETA,
		t2.PortOfLoading,
		t2.PortOfDestination,
		t2.CargoType,
		'-' as ContainerNumber,
		'-' as SEAL,
		'-' as ContainerType,
		'-' as TotalColly,
		t2.Liner,
		IIF(t0.ShippingMethod = 'Sea', t2.VesselFlight, '') VesselName,
		IIF(t0.ShippingMethod = 'Air', t2.VesselFlight, '') FlightName,
		IIF(t0.ShippingMethod = 'Sea', t2.VoyageVesselFlight, '') VesselVoyNo,
		IIF(t0.ShippingMethod = 'Air', t2.VoyageVesselFlight, '') FlightVoyNo,
		t2.SsNo as SSNo,
		t2.ClApprovalDate as CLApprovalDate,
		t2.ClApproverName,
		t3.SlNo as SINo,
		CONCAT(CONVERT(VARCHAR(9), t3.CreateDate, 6), ' ', CONVERT(VARCHAR(9), t3.CreateDate, 8)) as SIDate,
		CONCAT(CONVERT(VARCHAR(9), t4.AjuDate, 6), ' ', CONVERT(VARCHAR(9), t4.AjuDate, 8)) as AjuDate,
		t4.AjuNumber,
		CONCAT(CONVERT(VARCHAR(9), t4.NpeDate, 6), ' ', CONVERT(VARCHAR(9), t4.NpeDate, 8)) as NpeDate,
		t4.NpeNumber,
		t4.RegistrationNumber as NOPEN,
		FORMAT(t4.PebFob, '#,0.00') PebFob,
		FORMAT(t4.FreightPayment, '#,0.00') FreightPyment,
		FORMAT(t4.InsuranceAmount, '#,0.00') InsuranceAmount,
		CONCAT(CONVERT(VARCHAR(9), t4.PEBApprovalDate, 6), ' ', CONVERT(VARCHAR(9), t4.PEBApprovalDate, 8)) as PEBApprovalDate,
		t4.PEBApproverName,
		t5.Number as MasterBlAwbNumber,
		CONVERT(VARCHAR(10), t5.MasterBlDate, 120) as MasterBlAwbDate,
		t5.HouseBlNumber HouseBlAwbNumber,
		CONVERT(VARCHAR(10), t5.HouseBlDate, 120) as HouseBlAwbDate,
		FORMAT(t4.PebFob + t4.FreightPayment + t4.InsuranceAmount, '#,0.00') as TotalPEB,
		'-' as InvoiceNoServiceCharges,
		'-' as CurrencyServiceCharges,
		'-' as TotalServiceCharges,
		'-' as InvoiceNoConsignee,
		'-' as CurrencyValueConsignee,
		'-' as TotalValueConsignee,
		'-' as ValueBalanceConsignee,
		'-' as [Status]

	FROM 
		(SELECT DISTINCT t0.CiplNo, t0.ReferenceNo, t0.Category, t0.CategoriItem,
				IIF(t0.UpdateBy IS NOT NULL, t0.UpdateDate, t0.CreateDate) UpdateDate, 
				IIF(t0.UpdateBy IS NOT NULL, t0.UpdateBy, t0.CreateBy) PICName,
				t0.id,
				t0.EdoNo,
				IIF(
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))
					IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))) <= 0, IIF(CHARINDEX('Permanent', t0.ExportType) > 0, 'Permanent', '-'),--'-',
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))
				) As PermanentTemporary,
				IIF(
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
					IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))) <= 0, '-',
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
				) As SalesNonSales,
				t0.ExportType,
				t0.Remarks,
				t0.ConsigneeName,
				t0.ConsigneeAddress,
				t0.ConsigneeCountry,
				t0.ConsigneeTelephone,
				t0.ConsigneeFax,
				t0.ConsigneePic,
				t0.ConsigneeEmail,
				t0.NotifyName,
				t0.NotifyAddress,
				t0.NotifyCountry,
				t0.NotifyTelephone,
				t0.NotifyFax,
				t0.NotifyPic,
				t0.NotifyEmail,
				t0.SoldToName,
				t0.SoldToAddress,
				t0.SoldToCountry,
				t0.SoldToTelephone,
				t0.SoldToFax,
				t0.SoldToPic,
				t0.SoldToEmail,
				t0.ShippingMethod,
				t0.IncoTerm,
				CONCAT(CONVERT(VARCHAR(9), t4.CreateDate, 6), ' ', CONVERT(VARCHAR(9), t4.CreateDate, 8)) as CiplApprovalDate,
				t4.Pic as PICApproverName,
				t3.GrNo,
				CONCAT(CONVERT(VARCHAR(9), t3.CreateDate, 6), ' ', CONVERT(VARCHAR(9), t3.CreateDate, 8)) as RGDate,
				CONCAT(CONVERT(VARCHAR(9), t5.UpdateDate, 6), ' ', CONVERT(VARCHAR(9), t5.UpdateDate, 8)) as RGApprovalDate,
				t5.UpdateBy as RGApproverName
		FROM Cipl t0 join CiplItem t1 on t0.id = t1.idCipl 
		left join RequestCipl t4 on t4.IdCipl = t0.id AND t4.IdStep IN (2, 7, 10, 8) AND t4.Status = 'Approve'
		left join GoodsReceiveItem t2 on t2.IdCipl = t0.id
		left join GoodsReceive t3 on t3.Id = t2.IdGr 
		left join RequestGr t5 on t5.IdGr = t2.IdGr and t5.IdStep = 16
		) t0
	left join CargoCipl t1 on t1.IdCipl = t0.id
	left join (SELECT t0.*, 
						t1.UpdateBy ClApproverName, 
						CONCAT(CONVERT(VARCHAR(9), t1.UpdateDate, 6), ' ', CONVERT(VARCHAR(9), t1.UpdateDate, 8)) ClApprovalDate 
				FROM Cargo t0
				left join RequestCl t1 on t0.Id = t1.IdCl and t1.IdStep = 12) t2 on t2.Id = t1.IdCargo
	left join ShippingInstruction t3 on t3.IdCL = t2.Id
	left join (SELECT t0.*, t1.Pic as PEBApproverName, t1.UpdateDate as PEBApprovalDate
				FROM NpePeb t0 
				left join RequestCl t1 on t0.IdCl = t1.IdCl and IdStep = 10020) t4 on t4.IdCl = t2.Id
	left join BlAwb t5 on t5.IdCl = t2.Id

	WHERE ((DATEPART(MONTH, t0.UpdateDate) >= DATEPART(MONTH, t0.UpdateDate) AND DATEPART(YEAR, t0.UpdateDate) = DATEPART(YEAR, @StartMonth)) OR @StartMonth = '') 
				AND ((DATEPART(MONTH, t0.UpdateDate) <= DATEPART(MONTH, t0.UpdateDate) AND DATEPART(YEAR, t0.UpdateDate) = DATEPART(YEAR, @EndMonth)) OR @EndMonth = '')
	and t0.Category = @ParamName
	and t0.CategoriItem = @ParamValue
	
	
	GROUP BY t0.id, t0.UpdateDate, t0.CiplNo, t0.EdoNo,t0.ReferenceNo, t0.PICName,
			t0.PermanentTemporary, t0.SalesNonSales, t0.Remarks, t0.ConsigneeName,
			t0.ConsigneeAddress, t0.ConsigneeCountry, t0.ConsigneeTelephone,
			t0.ConsigneeFax, t0.ConsigneePic, t0.ConsigneeEmail, t0.NotifyName,
			t0.NotifyAddress, t0.NotifyCountry, t0.NotifyTelephone, t0.NotifyFax,
			t0.NotifyPic, t0.NotifyEmail, t0.SoldToName, t0.SoldToAddress,
			t0.SoldToCountry, t0.SoldToTelephone, t0.SoldToFax, t0.SoldToPic,
			t0.SoldToEmail, t0.PICApproverName, t0.GrNo, t2.ClNo, t2.SsNo,t3.SlNo,
			t4.AjuDate, t4.AjuNumber, t4.NpeDate, t4.NpeNumber, t5.Number, 
			t5.MasterBlDate, t5.HouseBlNumber, t5.HouseBlDate, t2.SailingSchedule, 
			t2.ArrivalDestination, t2.PortOfLoading, t2.PortOfDestination, t0.ShippingMethod, 
			t2.CargoType, t0.IncoTerm, t4.PebFob, t4.FreightPayment, t4.InsuranceAmount, t0.Category, 
			t0.CategoriItem, t0.CiplApprovalDate, t0.RGApprovalDate, t0.RGDate, t2.CreateDate, t0.ExportType,
			t2.ClApprovalDate, t2.ClApproverName, t0.RGApproverName, t3.CreateDate, t4.RegistrationNumber, 
			t4.PEBApproverName, t4.PEBApprovalDate, t2.VesselFlight, t2.VoyageVesselFlight, t2.Liner
	ORDER BY t0.UpdateDate
	ElSE 
		SELECT 
		CONCAT(LEFT(DATENAME(MONTH,  t0.UpdateDate), 3), '-', DATEPART(YEAR,  t0.UpdateDate)) PebMonth,
		CAST(ROW_NUMBER() OVER (PARTITION BY CONCAT(LEFT(DATENAME(MONTH,  t0.UpdateDate), 3), '-', DATEPART(YEAR,  t0.UpdateDate)) ORDER BY t0.UpdateDate) as varchar(5)) RowNumber,
		IIF(t0.ReferenceNo = '', '-', t0.ReferenceNo) ReferenceNo,
		t0.CiplNo,
		t0.EdoNo as EDINo,
		IIF(t0.PermanentTemporary = 'Repair Return (Temporary)', 
			'Temporary', IIF(t0.PermanentTemporary = 'Return (Permanent)', 
				'Permanent', IIF(t0.PermanentTemporary = 'Personal Effect (Permanent)', 
					'Permanent', 
		'Permanent'))) as PermanentTemporary,
		IIF(t0.SalesNonSales <> 'Non Sales', IIF(
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.SalesNonSales, ' ' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
					IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.SalesNonSales, ' ' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))) <= 0, ' ',
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.SalesNonSales, ' ' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
		), t0.SalesNonSales) as SalesNonSales,
		t0.Remarks,
		t0.ConsigneeName,
		t0.ConsigneeAddress,
		t0.ConsigneeCountry,
		t0.ConsigneeTelephone,
		t0.ConsigneeFax,
		t0.ConsigneePic,
		t0.ConsigneeEmail,
		t0.NotifyName,
		t0.NotifyAddress,
		t0.NotifyCountry,
		t0.NotifyTelephone,
		t0.NotifyFax,
		t0.NotifyPic,
		t0.NotifyEmail,
		t0.SoldToName,
		t0.SoldToAddress,
		t0.SoldToCountry,
		t0.SoldToTelephone,
		t0.SoldToFax,
		t0.SoldToPic,
		t0.SoldToEmail,
		t0.ShippingMethod,
		t0.IncoTerm as IncoTerms,
		IIF(t0.Category = 'MISCELLANEOUS', t0.CategoriItem, t0.Category) as DescGoods, 
		IIF(t0.Category = 'MISCELLANEOUS', t0.Category, IIF(t0.Category = 'CATERPILLAR SPAREPARTS', 'SPAREPARTS' , t0.CategoriItem)) as Category,
		IIF(t0.Category = 'MISCELLANEOUS' or t0.Category = 'CATERPILLAR USED EQUIPMENT' or t0.Category = 'CATERPILLAR UNIT', '-', t0.CategoriItem) as SubCategory,
		IIF(t0.ExportType = 'Sales (Permanent)', 
			'-', IIF(t0.ExportType = 'Non Sales - Repair Return (Temporary)', 
					'RR', IIF(t0.ExportType = 'Non Sales - Return (Permanent)', 
					'R' , IIF(t0.ExportType = 'Non Sales - Personal Effect (Permanent)',
					'PE', '-'))))
		as [Type],
		CONCAT(CONVERT(VARCHAR(9), t0.UpdateDate, 6), ' ', CONVERT(VARCHAR(9), t0.UpdateDate, 8)) CiplCreateDate,
		t0.CiplApprovalDate,
		t0.PICName,
		t0.PICApproverName,
		t0.GrNo as RGNo,
		t0.RGDate,
		t0.RGApprovalDate,
		t0.RGApproverName,
		CONCAT(CONVERT(VARCHAR(18), t2.CreateDate, 6), ' ', CONVERT(VARCHAR(20), t2.CreateDate, 8)) ClDate,
		t2.ClNo,
		CONVERT(VARCHAR(11), t2.SailingSchedule, 106) as ETD,
		CONVERT(VARCHAR(11), t2.ArrivalDestination, 106) as ETA,
		t2.PortOfLoading,
		t2.PortOfDestination,
		t2.CargoType,
		'-' as ContainerNumber,
		'-' as SEAL,
		'-' as ContainerType,
		'-' as TotalColly,
		t2.Liner,
		IIF(t0.ShippingMethod = 'Sea', t2.VesselFlight, '') VesselName,
		IIF(t0.ShippingMethod = 'Air', t2.VesselFlight, '') FlightName,
		IIF(t0.ShippingMethod = 'Sea', t2.VoyageVesselFlight, '') VesselVoyNo,
		IIF(t0.ShippingMethod = 'Air', t2.VoyageVesselFlight, '') FlightVoyNo,
		t2.SsNo as SSNo,
		t2.ClApprovalDate as CLApprovalDate,
		t2.ClApproverName,
		t3.SlNo as SINo,
		CONCAT(CONVERT(VARCHAR(9), t3.CreateDate, 6), ' ', CONVERT(VARCHAR(9), t3.CreateDate, 8)) as SIDate,
		CONCAT(CONVERT(VARCHAR(9), t4.AjuDate, 6), ' ', CONVERT(VARCHAR(9), t4.AjuDate, 8)) as AjuDate,
		t4.AjuNumber,
		CONCAT(CONVERT(VARCHAR(9), t4.NpeDate, 6), ' ', CONVERT(VARCHAR(9), t4.NpeDate, 8)) as NpeDate,
		t4.NpeNumber,
		t4.RegistrationNumber as NOPEN,
		FORMAT(t4.PebFob, '#,0.00') PebFob,
		FORMAT(t4.FreightPayment, '#,0.00') FreightPyment,
		FORMAT(t4.InsuranceAmount, '#,0.00') InsuranceAmount,
		CONCAT(CONVERT(VARCHAR(9), t4.PEBApprovalDate, 6), ' ', CONVERT(VARCHAR(9), t4.PEBApprovalDate, 8)) as PEBApprovalDate,
		t4.PEBApproverName,
		t5.Number as MasterBlAwbNumber,
		CONVERT(VARCHAR(10), t5.MasterBlDate, 120) as MasterBlAwbDate,
		t5.HouseBlNumber HouseBlAwbNumber,
		CONVERT(VARCHAR(10), t5.HouseBlDate, 120) as HouseBlAwbDate,
		FORMAT(t4.PebFob + t4.FreightPayment + t4.InsuranceAmount, '#,0.00') as TotalPEB,
		'-' as InvoiceNoServiceCharges,
		'-' as CurrencyServiceCharges,
		'-' as TotalServiceCharges,
		'-' as InvoiceNoConsignee,
		'-' as CurrencyValueConsignee,
		'-' as TotalValueConsignee,
		'-' as ValueBalanceConsignee,
		'-' as [Status]

	FROM 
		(SELECT DISTINCT t0.CiplNo, t0.ReferenceNo, t0.Category, t0.CategoriItem,
				IIF(t0.UpdateBy IS NOT NULL, t0.UpdateDate, t0.CreateDate) UpdateDate, 
				IIF(t0.UpdateBy IS NOT NULL, t0.UpdateBy, t0.CreateBy) PICName,
				t0.id,
				t0.EdoNo,
				IIF(
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))
					IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))) <= 0, IIF(CHARINDEX('Permanent', t0.ExportType) > 0, 'Permanent', '-'),--'-',
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[2]', 'varchar(50)')))
				) As PermanentTemporary,
				IIF(
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
					IS NULL OR LEN(LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))) <= 0, '-',
					LTRIM(RTRIM(CAST('<M>' + REPLACE(t0.ExportType, '-' , '</M><M>') + '</M>' AS XML).value('/M[1]', 'varchar(50)')))
				) As SalesNonSales,
				t0.ExportType,
				t0.Remarks,
				t0.ConsigneeName,
				t0.ConsigneeAddress,
				t0.ConsigneeCountry,
				t0.ConsigneeTelephone,
				t0.ConsigneeFax,
				t0.ConsigneePic,
				t0.ConsigneeEmail,
				t0.NotifyName,
				t0.NotifyAddress,
				t0.NotifyCountry,
				t0.NotifyTelephone,
				t0.NotifyFax,
				t0.NotifyPic,
				t0.NotifyEmail,
				t0.SoldToName,
				t0.SoldToAddress,
				t0.SoldToCountry,
				t0.SoldToTelephone,
				t0.SoldToFax,
				t0.SoldToPic,
				t0.SoldToEmail,
				t0.ShippingMethod,
				t0.IncoTerm,
				CONCAT(CONVERT(VARCHAR(9), t4.CreateDate, 6), ' ', CONVERT(VARCHAR(9), t4.CreateDate, 8)) as CiplApprovalDate,
				t4.Pic as PICApproverName,
				t3.GrNo,
				CONCAT(CONVERT(VARCHAR(9), t3.CreateDate, 6), ' ', CONVERT(VARCHAR(9), t3.CreateDate, 8)) as RGDate,
				CONCAT(CONVERT(VARCHAR(9), t5.UpdateDate, 6), ' ', CONVERT(VARCHAR(9), t5.UpdateDate, 8)) as RGApprovalDate,
				t5.UpdateBy as RGApproverName
		FROM Cipl t0 join CiplItem t1 on t0.id = t1.idCipl 
		left join RequestCipl t4 on t4.IdCipl = t0.id AND t4.IdStep IN (2, 7, 10, 8) AND t4.Status = 'Approve'
		left join GoodsReceiveItem t2 on t2.IdCipl = t0.id
		left join GoodsReceive t3 on t3.Id = t2.IdGr 
		left join RequestGr t5 on t5.IdGr = t2.IdGr and t5.IdStep = 16
		) t0
	left join CargoCipl t1 on t1.IdCipl = t0.id
	left join (SELECT t0.*, 
						t1.UpdateBy ClApproverName, 
						CONCAT(CONVERT(VARCHAR(9), t1.UpdateDate, 6), ' ', CONVERT(VARCHAR(9), t1.UpdateDate, 8)) ClApprovalDate 
				FROM Cargo t0
				left join RequestCl t1 on t0.Id = t1.IdCl and t1.IdStep = 12) t2 on t2.Id = t1.IdCargo
	left join ShippingInstruction t3 on t3.IdCL = t2.Id
	left join (SELECT t0.*, t1.Pic as PEBApproverName, t1.UpdateDate as PEBApprovalDate
				FROM NpePeb t0 
				left join RequestCl t1 on t0.IdCl = t1.IdCl and IdStep = 10020) t4 on t4.IdCl = t2.Id
	left join BlAwb t5 on t5.IdCl = t2.Id

	WHERE ((DATEPART(MONTH, t0.UpdateDate) >= DATEPART(MONTH, t0.UpdateDate) AND DATEPART(YEAR, t0.UpdateDate) = DATEPART(YEAR, @StartMonth)) OR @StartMonth = '') 
				AND ((DATEPART(MONTH, t0.UpdateDate) <= DATEPART(MONTH, t0.UpdateDate) AND DATEPART(YEAR, t0.UpdateDate) = DATEPART(YEAR, @EndMonth)) OR @EndMonth = '')
	and t0.Category = @ParamName
	and t0.CategoriItem = @ParamValue
	and (t0.CiplNo = @KeyNum or t0.GrNo = @KeyNum or t2.ClNo = @KeyNum or t2.SsNo = @KeyNum or t3.SlNo = @KeyNum or t4.RegistrationNumber = @KeyNum)
	
	GROUP BY t0.id, t0.UpdateDate, t0.CiplNo, t0.EdoNo,t0.ReferenceNo, t0.PICName,
			t0.PermanentTemporary, t0.SalesNonSales, t0.Remarks, t0.ConsigneeName,
			t0.ConsigneeAddress, t0.ConsigneeCountry, t0.ConsigneeTelephone,
			t0.ConsigneeFax, t0.ConsigneePic, t0.ConsigneeEmail, t0.NotifyName,
			t0.NotifyAddress, t0.NotifyCountry, t0.NotifyTelephone, t0.NotifyFax,
			t0.NotifyPic, t0.NotifyEmail, t0.SoldToName, t0.SoldToAddress,
			t0.SoldToCountry, t0.SoldToTelephone, t0.SoldToFax, t0.SoldToPic,
			t0.SoldToEmail, t0.PICApproverName, t0.GrNo, t2.ClNo, t2.SsNo,t3.SlNo,
			t4.AjuDate, t4.AjuNumber, t4.NpeDate, t4.NpeNumber, t5.Number, 
			t5.MasterBlDate, t5.HouseBlNumber, t5.HouseBlDate, t2.SailingSchedule, 
			t2.ArrivalDestination, t2.PortOfLoading, t2.PortOfDestination, t0.ShippingMethod, 
			t2.CargoType, t0.IncoTerm, t4.PebFob, t4.FreightPayment, t4.InsuranceAmount, t0.Category, 
			t0.CategoriItem, t0.CiplApprovalDate, t0.RGApprovalDate, t0.RGDate, t2.CreateDate, t0.ExportType,
			t2.ClApprovalDate, t2.ClApproverName, t0.RGApproverName, t3.CreateDate, t4.RegistrationNumber, 
			t4.PEBApproverName, t4.PEBApprovalDate, t2.VesselFlight, t2.VoyageVesselFlight, t2.Liner
	ORDER BY t0.UpdateDate

END
GO
