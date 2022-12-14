USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ShipmentDhlInsertDetail]
(    
	@DHLShipmentID BIGINT,
	@CreateBy NVARCHAR(200)
)
AS
BEGIN
	--DECLARE @DHLShipmentID BIGINT = 12;
	--DECLARE @CreateBy NVARCHAR(200) = 'XUPJ21WDN';
	DECLARE @Reference nvarchar(max);

	update DHLPackage set IsDelete = 1 Where DHLShipmentID = @DHLShipmentID

	SELECT @Reference = Referrence FROM DHLShipment WHERE DHLShipmentID = @DHLShipmentID
	print @Reference	

	INSERT INTO dbo.DHLPackage (DHLShipmentID, PackageNumber, Insured, Weight, Length, Width, Height, CustReferences, CaseNumber, CiplNumber, IsDelete, CreateBy, CreateDate)
	SELECT @DHLShipmentID AS DHLShipmentID, ROW_NUMBER() OVER(ORDER BY ci.CaseNumber ASC) AS PackageNumber, '0.00', SUM(ci.GrossWeight)
	, SUM(ci.Length), SUM(ci.Width), SUM(ci.Height), '-', ci.CaseNumber, ci.IdCipl AS CiplNumber, 0 AS IsDelete, @CreateBy AS CreateBy, GETDATE() AS CreateDate
	FROM fnSplitString(@Reference, ',') t0 
	JOIN CiplItem ci ON ci.IdCipl = t0.splitdata AND ci.IsDelete = 0
	GROUP BY ci.CaseNumber, ci.IdCipl

END


GO
