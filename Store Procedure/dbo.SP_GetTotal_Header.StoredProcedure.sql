USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetTotal_Header]
(
	@AwbId BIGINT
)
AS
BEGIN

	SELECT SUM(ci.ExtendedValue) AS TotalUnitPrice, SUM(ci.Quantity) AS TotalQuantity, ci.Currency AS Currency
	, c.IncoTerm AS IncoTerm, c.Category AS Category, c.CategoriItem AS CategoriItem
	FROM CiplItem ci
	JOIN Cipl c ON ci.IdCipl = c.id AND c.IsDelete = 0
	WHERE ci.IdCipl IN (
		SELECT CiplNumber FROM DHLPackage WHERE DHLShipmentID = @AwbId and IsDelete = 0
	) GROUP BY ci.Currency, c.IncoTerm, c.Category, c.CategoriItem

END
GO
