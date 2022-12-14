USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[SP_DHLShipmentInsert] 
@DropOffType nvarchar(100)
, @ServiceType nvarchar(100)
, @PaymentInfo nvarchar(100)
, @Account nvarchar(60)
, @Currency nvarchar(20)
, @TotalNet decimal(18,2)
, @UnitOfMeasurement nvarchar(20)
, @PackagesCount int
, @LabelType nvarchar(100)
, @LabelTemplate nvarchar(100)
, @ShipTimestamp varchar(100)
, @PickupLocation nvarchar(100)
, @PickupLocationCloseTime nvarchar(100)
, @SpecialPickupInstruction nvarchar(max)
, @CommoditiesDescription nvarchar(max)
, @CommoditiesContent nvarchar(max)
, @ShipperPersonName nvarchar(100)
, @ShipperCompanyName nvarchar(100)
, @ShipperPhoneNumber nvarchar(100)
, @ShipperEmailAddress nvarchar(100)
, @ShipperStreetLines nvarchar(100)
, @ShipperCity nvarchar(100)
, @ShipperPostalCode nvarchar(100)
, @ShipperCountryCode nvarchar(100)
, @RecipientPersonName nvarchar(100)
, @RecipientCompanyName nvarchar(100)
, @RecipientPhoneNumber nvarchar(100)
, @RecipientEmailAddress nvarchar(100)
, @RecipientStreetLines nvarchar(100)
, @RecipientCity nvarchar(100)
, @RecipientPostalCode nvarchar(100)
, @RecipientCountryCode nvarchar(100)
, @PICPersonName nvarchar(100)
, @PICPhoneNumber nvarchar(100)
, @PICEmailAddress nvarchar(100)
, @PICStreetLines nvarchar(100)
, @PackagesQty int
, @PackagesPrice decimal(18,2)
, @Referrence nvarchar(255)
, @ShipmentIdentificationNumber nvarchar(100)
, @DispatchConfirmationNumber nvarchar(100)
, @UserId varchar(100)
, @DHLShipmentID bigint

As
Set Nocount On

----# Insert DHLShipment
if not exists (Select top 1 * from DHLShipment where DHLShipmentID = @DHLShipmentID)
begin
	Insert Into DHLShipment (DropOffType, ServiceType, PaymentInfo, Account, Currency, TotalNet, UnitOfMeasurement, PackagesCount, LabelType, LabelTemplate, ShipTimestamp, PickupLocation, PickupLocTime
		 , SpcPickupInstruction, CommoditiesDesc, CommoditiesContent, IdentifyNumber, ConfirmationNumber, PackagesQty, PackagesPrice, Referrence, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	Select DropOffType=@DropOffType, ServiceType=@ServiceType, PaymentInfo=@PaymentInfo, Account=@Account, Currency=@Currency, TotalNet=@TotalNet, UnitOfMeasurement=@UnitOfMeasurement, PackagesCount=@PackagesCount
		 , LabelType=@LabelType, LabelTemplate=@LabelTemplate, ShipTimestamp=CONVERT(datetime, Left(@ShipTimestamp, 19), 126), PickupLocation=@PickupLocation, PickupLocTime=@PickupLocationCloseTime
		 , SpcPickupInstruction=@SpecialPickupInstruction, CommoditiesDesc=@CommoditiesDescription, CommoditiesContent=@CommoditiesContent, IdentifyNumber=@ShipmentIdentificationNumber
		 , ConfirmationNumber=@DispatchConfirmationNumber, PackagesQty=@PackagesQty, PackagesPrice=@PackagesPrice, Referrence=@Referrence, IsDelete=0, CreateBy=@UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate=NULL	

	Select @DHLShipmentID = Convert(bigint, SCOPE_IDENTITY())
end
else
begin 
	Update DHLShipment 
		Set DropOffType=@DropOffType, ServiceType=@ServiceType, PaymentInfo=@PaymentInfo, Account=@Account, Currency=@Currency, TotalNet=@TotalNet, UnitOfMeasurement=@UnitOfMeasurement
		  , PackagesCount=@PackagesCount, LabelType=@LabelType, LabelTemplate=@LabelTemplate, ShipTimestamp=CONVERT(datetime, Left(@ShipTimestamp, 19), 126)
		  , PickupLocation=@PickupLocation, PickupLocTime=@PickupLocationCloseTime, SpcPickupInstruction=@SpecialPickupInstruction, CommoditiesDesc=@CommoditiesDescription
		  , CommoditiesContent=@CommoditiesContent, IdentifyNumber=@ShipmentIdentificationNumber, ConfirmationNumber=@DispatchConfirmationNumber, PackagesQty=@PackagesQty
		  , PackagesPrice=@PackagesPrice, Referrence=@Referrence, UpdateBy=@UserId, UpdateDate=GETDATE()
	Where DHLShipmentID = @DHLShipmentID
end


----# Insert DHLPerson
If Not Exists (Select top 1 * from DHLPerson where DHLShipmentID = @DHLShipmentID and PersonType = 'SHIPPER')
Begin
	Insert into DHLPerson (DHLShipmentID, PersonType, PersonName, CompanyName, PhoneNumber, EmailAddress, StreetLines, City, PostalCode, CountryCode, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	Select DHLShipmentID=@DHLShipmentID, PersonType='SHIPPER', PersonName=@ShipperPersonName, CompanyName=@ShipperCompanyName, PhoneNumber=@ShipperPhoneNumber, EmailAddress=@ShipperEmailAddress
	, StreetLines=@ShipperStreetLines, City=@ShipperCity, PostalCode=@ShipperPostalCode, CountryCode=@ShipperCountryCode, IsDelete=0, CreateBy=@UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate=NULL
End
Else
Begin
	Update DHLPerson
		Set PersonName=@ShipperPersonName, CompanyName=@ShipperCompanyName, PhoneNumber=@ShipperPhoneNumber, EmailAddress=@ShipperEmailAddress, StreetLines=@ShipperStreetLines
		  , City=@ShipperCity, PostalCode=@ShipperPostalCode, CountryCode=@ShipperCountryCode, UpdateBy=@UserId, UpdateDate=GETDATE()
	Where DHLShipmentID = @DHLShipmentID and PersonType = 'SHIPPER'
End

If Not Exists (Select top 1 * from DHLPerson where DHLShipmentID = @DHLShipmentID and PersonType = 'RECIPIENT')
Begin
	Insert into DHLPerson (DHLShipmentID, PersonType, PersonName, CompanyName, PhoneNumber, EmailAddress, StreetLines, City, PostalCode, CountryCode, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	Select DHLShipmentID=@DHLShipmentID, PersonType='RECIPIENT', PersonName=@RecipientPersonName, CompanyName=@RecipientCompanyName, PhoneNumber=@RecipientPhoneNumber, EmailAddress=@RecipientEmailAddress
	, StreetLines=@RecipientStreetLines, City=@RecipientCity, PostalCode=@RecipientPostalCode, CountryCode=@RecipientCountryCode, IsDelete=0, CreateBy=@UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate=NULL
End
Else
Begin
	Update DHLPerson
		Set PersonName=@RecipientPersonName, CompanyName=@RecipientCompanyName, PhoneNumber=@RecipientPhoneNumber, EmailAddress=@RecipientEmailAddress, StreetLines=@RecipientStreetLines
		  , City=@RecipientCity, PostalCode=@RecipientPostalCode, CountryCode=@RecipientCountryCode, UpdateBy=@UserId, UpdateDate=GETDATE()
	Where DHLShipmentID = @DHLShipmentID and PersonType = 'RECIPIENT'
End

If Not Exists (Select top 1 * from DHLPerson where DHLShipmentID = @DHLShipmentID and PersonType = 'PIC')
Begin
	Insert into DHLPerson (DHLShipmentID, PersonType, PersonName, CompanyName, PhoneNumber, EmailAddress, StreetLines, City, PostalCode, CountryCode, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	Select DHLShipmentID=@DHLShipmentID, PersonType='PIC', PersonName=@PICPersonName, CompanyName='', PhoneNumber=@PICPhoneNumber, EmailAddress=@PICEmailAddress, StreetLines=@PICStreetLines
			, City='', PostalCode='', CountryCode='', IsDelete=0, CreateBy=@UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate=NULL
End
Else
Begin
	Update DHLPerson
		Set PersonName=@PICPersonName, PhoneNumber=@PICPhoneNumber, EmailAddress=@PICEmailAddress, StreetLines=@PICStreetLines, UpdateBy=@UserId, UpdateDate=GETDATE()
	Where DHLShipmentID = @DHLShipmentID and PersonType = 'PIC'
End

Select @DHLShipmentID 'DHLShipmentID'
GO
