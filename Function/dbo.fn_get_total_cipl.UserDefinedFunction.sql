USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		Ali Mutasal
-- ALTER date: 8 Des 2019
-- Description:	Function untuk mengambil total tiap Cipl
-- =============================================
CREATE FUNCTION [dbo].[fn_get_total_cipl]
(	
	-- Add the parameters for the function here
	@CiplId bigint = 0
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		t0.Id AS IdCipl, 
		t0.CiplNo CiplNumber,
		ISNULL(SUM(Volume),0) TotalVolume,
		ISNULL(SUM(NetWeight),0) TotalNetWeight,
		ISNULL(SUM(GrossWeight),0) TotalGrossWeight,
		ISNULL(COUNT(DISTINCT 
			CASE 
			WHEN t0.CategoriItem = 'SIB' 
				THEN JCode 
			WHEN t0.CategoriItem = 'PRA' OR t0.CategoriItem = 'REMAN'
				THEN CaseNumber
			ELSE Sn END),0) AS TotalPackage
	FROM dbo.Cipl t0
	LEFT JOIN dbo.CiplItem t1 on t0.id = t1.IdCipl
		AND t1.IsDelete = 0
	WHERE --t0.IsDelete = 0 AND 
	t0.Id = @CiplId
	GROUP BY t0.Id, CiplNo
)
GO
