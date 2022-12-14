USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_picdhl_data] -- sp_get_cargo_data 1
(
	@Id bigint,
	@PersonType nvarchar(50)
)
AS
BEGIN
	--DECLARE @Id bigint = 2;
	SELECT PersonName
	, CompanyName
	, PhoneNumber
	, EmailAddress
	, StreetLines
	, City
	, PostalCode
	, p.CountryCode	
	, mc.CountryCode + ' - ' + mc.[Description] AS CountryText
	FROM DHLPerson p
	LEFT JOIN MasterCountry mc ON p.CountryCode = mc.CountryCode AND mc.IsDeleted = 0 AND mc.CreateBy != 'XUPJ21TYO'
	WHERE 1=1 AND isdelete = 0 AND DHLShipmentID = @Id AND PersonType = @PersonType;
END
GO
