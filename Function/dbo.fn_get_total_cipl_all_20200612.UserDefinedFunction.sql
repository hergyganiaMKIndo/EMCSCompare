USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ali Mutasal
-- ALTER date: 8 Des 2019
-- Description:	Function untuk mengambil total tiap Cipl
-- =============================================
CREATE FUNCTION [dbo].[fn_get_total_cipl_all_20200612]
(	
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		IdCipl, 
		t1.CiplNo CiplNumber,
		SUM(Volume) TotalVolume,
		SUM(NetWeight) TotalNetWeight,
		SUM(GrossWeight) TotalGrossWeight,
		COUNT(DISTINCT 
			CASE 
			WHEN t1.CategoriItem = 'PRA' OR t1.CategoriItem = 'SIB' 
				THEN JCode 
			WHEN t1.CategoriItem = 'REMAN'
				THEN CaseNumber
			ELSE Sn END) AS TotalPackage
	FROM dbo.CiplItem t0
	LEFT JOIN dbo.Cipl t1 on t1.id = t0.IdCipl
	WHERE t0.IsDelete = 0
	GROUP BY IdCipl, CiplNo
)
GO
