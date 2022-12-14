USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_ActivityReport_TotalExport_Outstanding](
	--@year VARCHAR(7) = ''
)
RETURNS TABLE
AS
RETURN
(
	SELECT	DISTINCT a.id [IdCipl], a.CiplNo, a.ClNo, a.CreateDate, a.CreateBy, b.Step, b.[Status], b.UpdateDate
	FROM	Cipl a
			JOIN CiplHistory b ON a.id = b.IdCipl
	WHERE	a.IsDelete = 0
			AND b.IsDelete = 0
			AND b.Status = 'Approve'
			AND b.Step = 'Approval By Superior'
			AND (a.id NOT IN (SELECT	b.IdCipl
							FROM	NpePeb a
									JOIN CargoCipl b ON a.IdCl = b.IdCargo
							WHERE	a.IsDelete = 0
									AND b.IsDelete = 0
									AND b.IdCargo IN (
									SELECT	DISTINCT a.IdCargo
									FROM	CargoCipl a
											JOIN Cipl b ON a.IdCipl = b.id
									WHERE	a.IsDelete = 0
											AND b.IsDelete = 0 
											AND a.IdCipl IN (SELECT	DISTINCT a.id
														FROM	Cipl a
																JOIN CiplHistory b ON a.id = b.IdCipl
														WHERE	a.IsDelete = 0 
																AND b.IsDelete = 0
																AND b.Status = 'Approve'
																AND b.Step = 'Approval By Superior')))
			OR MONTH(a.CreateDate) < MONTH(GETDATE()))
)
GO
