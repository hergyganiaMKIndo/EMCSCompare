USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hasni
-- Create date: 16/10/2019
-- Description:	Trend Export (Interval Year)
-- =============================================
CREATE PROCEDURE [dbo].[SP_RTrendExport]
	--@year int
AS
BEGIN
	-- Insert statements for procedure here
	-- total export value per thn (peb approved)
	SELECT 
		SUM(ExtendedValue) as totalExportValue, 
		COUNT(DISTINCT AjuNumber) totalPeb, 
		Year(t4.CreateDate) as [year]
	FROM NpePeb t0
	JOIN RequestCl t1 
		on t1.IdCl = t0.IdCl AND t1.IdStep = 10020
		and t1.[Status] = 'Approve'
	JOIN Cargo t2 on t2.id = t1.IdCl
	JOIN CargoCipl t3 on t3.IdCargo = t2.Id
	JOIN CiplItem t4 on t4.IdCipl = t3.IdCipl AND t4.Currency = 'USD'
	WHERE Year(t4.CreateDate)= 2019--@year
	GROUP BY Year(t4.CreateDate)

END
GO
