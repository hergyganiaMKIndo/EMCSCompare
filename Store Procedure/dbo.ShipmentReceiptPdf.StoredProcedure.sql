USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShipmentReceiptPdf]
(
	@Id bigint
)
AS
BEGIN
	DECLARE @reference NVARCHAR(max);
	
	SELECT @reference = Referrence from DHLShipment where IsDelete = 0 AND DHLShipmentID = @Id;

	SELECT 
		 ps.CompanyName  AS ShipperCompany
		, ps.PersonName AS ShipperPerson
		, ps.StreetLines AS ShipperAddress
		, ps.PostalCode AS ShipperPostalCode
		, ps.City AS ShipperCity
		, ps.[Description] AS ShipperCountry
		, ps.PhoneNumber AS ShipperPhone
		, ps.EmailAddress AS ShipperEmail
		, pr.CompanyName  AS ReceipentCompany
		, pr.PersonName AS ReceipentPerson
		, pr.StreetLines AS ReceipentAddress
		, pr.PostalCode AS ReceipentPostalCode
		, pr.City AS ReceipentCity
		, pr.[Description] AS ReceipentCountry
		, pr.PhoneNumber AS ReceipentPhone
		, pr.EmailAddress AS ReceipentEmail
		, ShipTimestamp AS ShipmentDate
		, IdentifyNumber AS WaybillNumber
		, ( SELECT TOP 1 mp.GlobalProductName
			FROM DHLRate r 
			JOIN DHLMasterProduct mp ON mp.ServiceType = r.ServiceType AND mp.IsDelete = 0
			WHERE r.IsDelete = 0) AS ServiceType
		, '-' AS YourOwnPackages
		, s.PackagesCount AS NumberOfPiece
		, pc.Weight AS [Weight]
		, (pc.Length * pc.Width * pc.Height) / 5000 AS Dimensional
		, IIF(pc.Weight > ((pc.Length * pc.Width * pc.Height) / 5000), ROUND(pc.Weight, 2), ROUND((pc.Length * pc.Width * pc.Height / 5000),0)) AS Chargeable
		, pc.Insured AS Insured
		, s.PaymentInfo AS TermsOfTrade
		, pc.Insured AS DeclaredValue
		, '??' AS DutiesTaxes
		, '??' AS Dutiable
		, '??' AS EstimatedDelDate
		, '??' AS PromoCode
		, '??' AS PaymentType
		, s.Account AS BillingAccount
		, '??' AS Duties
		, ISNULL(rt.ChargeAmount,0) AS ChargeAmount
		, ISNULL(rt.SpecialService,'-') AS SpecialService
		, (SELECT STUFF((SELECT ',' + CiplNo 
							FROM Cipl t1
							WHERE t1.id = t2.id
							FOR XML PATH('')
						), 1, 1, '') AS CiplNo 
			FROM Cipl t2 
			WHERE IsDelete = 0 AND id IN ( select splitdata FROM fnSplitString(@reference,',') )
			) AS Reference
		, s.ConfirmationNumber AS PickupRef
		, s.CommoditiesDesc AS DescriptionContens
	FROM DHLShipment s 
	JOIN (
			SELECT DHLShipmentID
				, CompanyName
				, PersonName
				, StreetLines
				, PostalCode
				, City
				, mc.Description 
				, PhoneNumber
				, EmailAddress
			FROM DHLPerson p
			JOIN MasterCountry mc ON mc.CountryCode = p.CountryCode AND mc.IsDeleted = 0 AND mc.CreateBy != 'XUPJ21TYO'
			WHERE PersonType = 'SHIPPER' AND IsDelete = 0
		)ps ON ps.DHLShipmentID = s.DHLShipmentID 
	JOIN (
			SELECT DHLShipmentID
				, CompanyName
				, PersonName
				, StreetLines
				, PostalCode
				, City
				, mc.Description 
				, PhoneNumber
				, EmailAddress
			FROM DHLPerson p
			JOIN MasterCountry mc ON mc.CountryCode = p.CountryCode AND mc.IsDeleted = 0 AND mc.CreateBy != 'XUPJ21TYO'
			WHERE PersonType = 'RECIPIENT' AND IsDelete = 0
		)pr ON pr.DHLShipmentID = s.DHLShipmentID
	LEFT JOIN 
		(
			SELECT DHLShipmentID
				, SUM(Weight) AS [Weight]
				, SUM(Insured) AS Insured
				, SUM(Length) AS Length
				, SUM(Height) AS Height
				, SUM(Width) AS Width
			FROM DHLPackage
			WHERE IsDelete = 0 
				AND DHLShipmentID = @Id
			GROUP BY DHLShipmentID
		)pc ON pc.DHLShipmentID = s.DHLShipmentID
	LEFT JOIN 
		(
		SELECT DHLShipmentID, 
			SUM(ISNULL(ChargeAmount,0)) AS ChargeAmount, 
			STUFF((SELECT ',' + ChargeType 
					  FROM DHLRate t1
					FOR XML PATH('')
			), 1, 1, '') AS SpecialService
		FROM DHLRate
		WHERE IsDelete = 0 
			AND DHLShipmentID = @Id
		GROUP BY DHLShipmentID
		)rt ON rt.DHLShipmentID = s.DHLShipmentID
	WHERE s.isdelete = 0 AND s.DHLShipmentID = @Id

END
GO
