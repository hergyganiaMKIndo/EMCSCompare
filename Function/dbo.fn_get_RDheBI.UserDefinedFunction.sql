USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_RDheBI]
(	
	-- Add the parameters for the function here
	
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
SELECT 
		--t1.NpeDate,
	    '' as NomorIdentifikasi, 
		t1.NPWP as NPWP,
		t1.ReceiverName as NamaPenerimaDHE,
		t1.PassPabeanOffice as SandiKantorPabean,
		t1.NpeNumber as NomorPendaftaranPEB,
		ISNULL(CONVERT(VARCHAR(11), t1.NpeDate, 106), '-') as TanggalPEB,
		t1.Valuta as JenisValutaDHE,
		CAST(t1.Dhe as varchar(18)) as NilaiDHE,
		CAST(t1.PebFob as varchar(18)) as NilaiPEB,
		CASE
			WHEN t1.DocumentComplete = 1 THEN 'Yes'
			
			ELSE 'No'
		END KelengkapanDokumen,
		t1.DescriptionPassword as SandiKeterangan,
		--t1.DocumentComplete as KelengkapanDokumen,
		t1.Valuta as JenisValutaPEB,
		t0.Category,t0.ExportType,
		t1.NpeDate
	FROM
		Cargo t0
	JOIN NpePeb t1 on t1.IdCl = t0.Id
	JOIN BlAwb t2 on t2.IdCl = t0.Id 
	JOIN RequestCl t3 on t3.IdCl = t0.Id
	WHERE t3.IdStep = 10022
		and t3.[Status] = 'Approve'
)
GO
