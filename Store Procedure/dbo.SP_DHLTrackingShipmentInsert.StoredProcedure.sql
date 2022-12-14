USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SP_DHLTrackingShipmentInsert] 
@DHLShipmentID bigint
, @AWBNumber nvarchar(100)
, @ServiceAreaCode nvarchar(100)
, @ServiceAreaDescription nvarchar(100)
, @DestinationAreaCode nvarchar(100)
, @DestinationAreaDescription nvarchar(100)
, @DestinationAreaFacilityCode nvarchar(100)
, @ShipperName nvarchar(100)
, @ConsigneeName nvarchar(100)
, @ShipmentDate nvarchar(100)
, @Pieces int
, @Weight nvarchar(100)
, @WeightUnit nvarchar(100)
, @ServiceType nvarchar(100)
, @ShipmentDescription nvarchar(100)
, @ShipperCity nvarchar(100)
, @ShipperSuburb nvarchar(100)
, @ShipperPostalCode nvarchar(100)
, @ShipperCountryCode nvarchar(100)
, @ConsigneeCity nvarchar(100)
, @ConsigneePostalCode nvarchar(100)
, @ConsigneeCountryCode nvarchar(100)
, @ReferenceID nvarchar(100)
, @ServiceInvocationID nvarchar(100)
, @UserId nvarchar(100)


As
Set Nocount On

Declare @DHLTrackingShipmentID bigint

IF EXISTS (Select Top 1 * From DHLTrackingShipment with(nolock) where DHLShipmentID <> 0 And DHLShipmentID = @DHLShipmentID)
BEGIN 
	Update DHLTrackingShipment set UpdateBy = @UserId, UpdateDate = GETDATE() Where DHLShipmentID = @DHLShipmentID

	Select @DHLTrackingShipmentID = DHLTrackingShipmentID From DHLTrackingShipment with(nolock) where DHLShipmentID = @DHLShipmentID
END
ELSE
BEGIN
	Insert Into DHLTrackingShipment (DHLShipmentID, AWBNumber, OriginSvcAreaCode, OriginSvcAreaDesc, DestSvcAreaCode, DestSvcAreaDesc, DestSvcAreaFacility
			  , ShipperName, ConsigneeName, ShipmentDate, Pieces, Weight, WeightUnit, ServiceType, ShipmentDescription, ShipperCity, ShipperSuburb
			  , ShipperPostalCode, ShipperCountryCode, ConsigneeCity, ConsigneePostalCode, ConsigneeCountryCode, ShipperReferenceID, ServiceInvocationID
			  , IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	Select DHLShipmentID=@DHLShipmentID, AWBNumber=@AWBNumber, OriginSvcAreaCode=@ServiceAreaCode, OriginSvcAreaDesc=@ServiceAreaDescription
		 , DestSvcAreaCode=@DestinationAreaCode, DestSvcAreaDesc=@DestinationAreaDescription, DestSvcAreaFacility=@DestinationAreaFacilityCode, ShipperName=@ShipperName
		 , ConsigneeName=@ConsigneeName, ShipmentDate=@ShipmentDate, Pieces=@Pieces, [Weight]=@Weight, WeightUnit=@WeightUnit, ServiceType=@ServiceType
		 , ShipmentDescription=@ShipmentDescription, ShipperCity=@ShipperCity, ShipperSuburb=@ShipperSuburb, ShipperPostalCode=@ShipperPostalCode
		 , ShipperCountryCode=@ShipperCountryCode, ConsigneeCity=@ConsigneeCity, ConsigneePostalCode=@ConsigneePostalCode, ConsigneeCountryCode=@ConsigneeCountryCode
		 , ShipperReferenceID=@ReferenceID, ServiceInvocationID=@ServiceInvocationID, IsDelete=0, CreateBy=@UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate=NULL

	Select @DHLTrackingShipmentID = Convert(bigint, SCOPE_IDENTITY())
END

Select @DHLTrackingShipmentID 'DHLTrackingShipmentID'
GO
