USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_CiplInsert]
(
  @Category NVARCHAR(100),
  @CategoryItem NVARCHAR(50),
  @ExportType NVARCHAR(100),
  @ExportTypeItem NVARCHAR(100),
  @SoldConsignee NVARCHAR(30),
  @SoldToName NVARCHAR(200),
  @SoldToAddress NVARCHAR(MAX),
  @SoldToCountry NVARCHAR(100),
  @SoldToTelephone NVARCHAR(100),
  @SoldToFax NVARCHAR(100),
  @SoldToPic NVARCHAR(200),
  @SoldToEmail NVARCHAR(200),
  @ShipDelivery NVARCHAR(30),
  @ConsigneeName NVARCHAR(200),
  @ConsigneeAddress NVARCHAR(MAX),
  @ConsigneeCountry NVARCHAR(100),
  @ConsigneeTelephone NVARCHAR(100),
  @ConsigneeFax NVARCHAR(100),
  @ConsigneePic NVARCHAR(200),
  @ConsigneeEmail NVARCHAR(200),
  @NotifyName NVARCHAR(200),
  @NotifyAddress NVARCHAR(MAX),
  @NotifyCountry NVARCHAR(100),
  @NotifyTelephone NVARCHAR(100),
  @NotifyFax NVARCHAR(100),
  @NotifyPic NVARCHAR(200),
  @NotifyEmail NVARCHAR(200),
  @ConsigneeSameSoldTo BIGINT,
  @NotifyPartySameConsignee BIGINT,
  @Area NVARCHAR(100),
  @Branch NVARCHAR(100),
  @Currency NVARCHAR(20),
  @Rate DECIMAL(18,2),
  @PaymentTerms NVARCHAR(50),
  @ShippingMethod NVARCHAR(30),
  @CountryOfOrigin NVARCHAR(200),
  @LcNoDate NVARCHAR(200),
  @IncoTerm NVARCHAR(50),
  @FreightPayment NVARCHAR(30),
  @ShippingMarks NVARCHAR(MAX),
  @Remarks NVARCHAR(200),
  @SpecialInstruction NVARCHAR(MAX),
  @CreateBy NVARCHAR(50),
  @CreateDate datetime,
  @UpdateBy NVARCHAR(50),
  @UpdateDate datetime,
  @Status NVARCHAR(10),
  @IsDelete BIT,
  @LoadingPort NVARCHAR(200),
  @DestinationPort NVARCHAR(200),
  @PickUpPic NVARCHAR(200),
  @PickUpArea NVARCHAR(200),
  @CategoryReference NVARCHAR(50),
  @ReferenceNo NVARCHAR(50),
  @Consolidate NVARCHAR(10),
  @Forwader NVARCHAR(200),
  @BranchForwarder NVARCHAR(200),
  @Attention NVARCHAR(200),
  @Company NVARCHAR(200),
  @SubconCompany NVARCHAR(200),
  @Address NVARCHAR(MAX),
  @AreaForwarder NVARCHAR(100),
  @City NVARCHAR(100),
  @PostalCode NVARCHAR(100),
  @Contact NVARCHAR(200),
  @FaxNumber NVARCHAR(200),
  @Forwading NVARCHAR(200),
  @Email NVARCHAR(200),
  @Type NVARCHAR(10),
  @ExportShipmentType NVARCHAR(Max),
  @Vendor NVARCHAR(Max)

  --@LASTCIPLID bigint output
)
AS
BEGIN
  DECLARE @LASTID bigint
  INSERT INTO [dbo].[Cipl]
           ([Category]
           ,[CategoriItem]
           ,[ExportType]
           ,[ExportTypeItem]
		   ,[SoldConsignee]
           ,[SoldToName]
           ,[SoldToAddress]
           ,[SoldToCountry]
           ,[SoldToTelephone]
           ,[SoldToFax]
           ,[SoldToPic]
           ,[SoldToEmail]
           ,[ShipDelivery]
           ,[ConsigneeName]
           ,[ConsigneeAddress]
           ,[ConsigneeCountry]
           ,[ConsigneeTelephone]
           ,[ConsigneeFax]
           ,[ConsigneePic]
           ,[ConsigneeEmail]
           ,[NotifyName]
           ,[NotifyAddress]
           ,[NotifyCountry]
           ,[NotifyTelephone]
           ,[NotifyFax]
           ,[NotifyPic]
           ,[NotifyEmail]
           ,[ConsigneeSameSoldTo]
           ,[NotifyPartySameConsignee]
       ,[Area]
       ,[Branch]
	   ,[Currency]
	   ,[Rate]
           ,[PaymentTerms]
           ,[ShippingMethod]
           ,[CountryOfOrigin]
           ,[LcNoDate]
           ,[IncoTerm]
           ,[FreightPayment]
           ,[ShippingMarks]
           ,[Remarks]
           ,[SpecialInstruction]
           ,[CreateBy]
           ,[CreateDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsDelete]
		   ,[LoadingPort]
		   ,[DestinationPort]
		   ,[PickUpPic]
       ,[PickUpArea]
	   ,[CategoryReference]
	   ,[ReferenceNo]
	   ,[Consolidate]
           )
     VALUES
           (@Category
           ,@CategoryItem
           ,@ExportType
           ,@ExportTypeItem
       ,@SoldConsignee
           ,@SoldToName
           ,@SoldToAddress
           ,@SoldToCountry
           ,@SoldToTelephone
           ,@SoldToFax
           ,@SoldToPic
           ,@SoldToEmail
       ,@ShipDelivery
           ,@ConsigneeName
           ,@ConsigneeAddress
           ,@ConsigneeCountry
           ,@ConsigneeTelephone
           ,@ConsigneeFax
           ,@ConsigneePic
           ,@ConsigneeEmail
           ,@NotifyName
           ,@NotifyAddress
           ,@NotifyCountry
           ,@NotifyTelephone
           ,@NotifyFax
           ,@NotifyPic
           ,@NotifyEmail
           ,@ConsigneeSameSoldTo
           ,@NotifyPartySameConsignee
       ,@Area
       ,@Branch
	   ,@Currency
	   ,@Rate
           ,@PaymentTerms
           ,@ShippingMethod
           ,@CountryOfOrigin
           ,@LcNoDate
           ,@IncoTerm
           ,@FreightPayment
           ,@ShippingMarks
           ,@Remarks
           ,@SpecialInstruction
           ,@CreateBy
           ,@CreateDate
           ,@UpdateBy
           ,@UpdateDate
           ,@IsDelete
		   ,@LoadingPort
		   ,@DestinationPort
		   ,@PickUpPic
       ,@PickUpArea
	   ,@CategoryReference
	   ,@ReferenceNo
	   ,@Consolidate)

  SET @LASTID = CAST(SCOPE_IDENTITY() as bigint)
  --SET @LASTCIPLID =@LASTID
  INSERT INTO [dbo].[CiplForwader]
           ([IdCipl]
       ,[Forwader]
	   ,[Branch]
	   ,[Attention]
       ,[Company]
	   ,[SubconCompany]
       ,[Address]
	   ,[Area]
	   ,[City]
	   ,[PostalCode]
       ,[Contact]
	   ,[FaxNumber]
	   ,[Forwading]
       ,[Email]
           ,[CreateBy]
           ,[CreateDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsDelete]
		   ,[Type]
		   ,[ExportShipmentType]
		   ,[Vendor]
           )
     VALUES
           (@LASTID
       ,@Forwader
	   ,@BranchForwarder
	   ,@Attention
       ,@Company
	   ,@SubconCompany
       ,@Address
	   ,@AreaForwarder
	   ,@City
	   ,@PostalCode	
       
       ,@Contact
	   ,@FaxNumber
	   ,@Forwading
       ,@Email
           ,@CreateBy
           ,@CreateDate
           ,@UpdateBy
           ,@UpdateDate
           ,@IsDelete
		   ,@Type
		   ,@ExportShipmentType
		   ,@Vendor)



  EXEC dbo.GenerateCiplNumber @LASTID, @CreateBy;

  DECLARE @CIPLNO nvarchar(20), @GETCATEGORY nvarchar(2)
  
  SELECT @GETCATEGORY = 
    CASE
      WHEN C.Category = 'CATERPILLAR NEW EQUIPMENT' THEN 'PP'
      WHEN C.Category = 'CATERPILLAR SPAREPARTS' THEN 'SP'
      WHEN C.Category = 'CATERPILLAR USED EQUIPMENT' THEN 'UE'
	  WHEN C.Category = 'MISCELLANEOUS' THEN 'MC'
    ELSE Null
    END 
    FROM Cipl C WHERE C.id = @LASTID
    
  EXEC dbo.sp_insert_request_data @LASTID, 'CIPL', @GETCATEGORY, @Status, 'CREATE';

END


GO
