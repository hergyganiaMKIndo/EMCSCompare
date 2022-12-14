USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hasni
-- Create date: 14/10/2019
-- Description:	SP Tax Audit Report
-- =============================================
--DROP PROCEDURE [dbo].[SP_RTaxAudit]
CREATE PROCEDURE [dbo].[SP_RTaxAudit_20211001]
(
	@StartDate nvarchar(100),
	@EndDate nvarchar(100)
)
AS
BEGIN
	SELECT  ROW_NUMBER() OVER(ORDER BY t2.idCipl ASC) AS [No],
		IIF(t0.ConsigneeName is NULL, t0.SoldToName, t0.ConsigneeName)  as [Name],
		IIF(t0.ConsigneeAddress is NULL, t0.SoldToAddress, t0.ConsigneeAddress) as [Address],
		t4.PebNumber pebNo,		
		FORMAT( t4.PebDate,'dd/MM/yyyy hh:mm:ss') PebDate,
		t1.Currency as CurrInvoice,
		t1.CurrValue,
		t4.Rate,
		t5.PPJKName,
		t5.Address as PPJKAddress,
		t1.CurrValue * t4.Rate as DPPExport,
		t6.DoNo,
		t6.DaNo,
		FORMAT( t7.ApprovedDate,'dd/MM/yyyy hh:mm:ss') DoDate,
		--CONVERT(varchar, t7.ApprovedDate, 113) as DoDate,
		t4.WarehouseLocation,
		t3.PortOfLoading as LoadingPort,
		t4.NpeNumber as NPENo,
		FORMAT(t4.NpeDate,'dd mmm yyyy hh:mm:ss') NpeDate,
		--CONVERT(varchar,t4.NpeDate, 113) NpeDate,
		t0.CiplNo as InvoiceNo,
		FORMAT(t0.CreateDate,'dd mmm yyyy hh:mm:ss') InvoiceDate,
		--CONVERT(varchar,t0.CreateDate, 113)  as InvoiceDate,
		t8.Publisher,
		t8.Number as BlAwbNo,
		FORMAT(t8.BlAwbDate,'dd mmm yyyy hh:mm:ss') BlAwbDate,
		--CONVERT(varchar,t8.BlAwbDate, 113)  as BlAwbDate,
		t3.PortOfDestination as DestinationPort,
		t0.Remarks 
	FROM
		Cipl t0
		JOIN (SELECT 
			DISTINCT Currency, 
					IdCipl, 
					SUM(UnitPrice) CurrValue 
			FROM CiplItem 
			GROUP BY Currency, IdCipl
			) as t1 on t1.IdCipl = t0.id
		JOIN CargoCipl t2 on t2.IdCipl = t0.id
		JOIN Cargo t3 on t3.Id = t2.IdCargo
		JOIN NpePeb t4 on t4.IdCl = t3.id
		JOIN (SELECT
				IIF(Attention is NULL, Company, Attention) PPJKName,Address,
				IdCipl
			FROM CiplForwader WHERE Forwader = 'CKB'
			) t5 on t5.IdCipl = t0.id
		JOIN GoodsReceiveItem t6 on t6.DoNo = t0.EdoNo
		JOIN (SELECT  max(CreateDate) as ApprovedDate, IdCipl
				FROM CiplHistory
				WHERE Status = 'Approve'
				GROUP BY IdCipl
			) t7 on t7.IdCipl = t0.id 
		JOIN BlAwb t8 on t8.IdCl = t3.Id
		JOIN RequestCl t9 on t9.IdCl = t3.Id
	WHERE t9.IdStep = 10022
		and t9.[Status] = 'Approve'
		and t4.NpeDate between @StartDate and @EndDate
END
GO
