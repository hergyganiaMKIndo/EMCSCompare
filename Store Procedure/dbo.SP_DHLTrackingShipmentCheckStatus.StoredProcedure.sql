USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SP_DHLTrackingShipmentCheckStatus]
@DHLShipmentID bigint
, @UserId varchar(50)

As
Set Nocount on

Declare @TrackingStat varchar(20)
Set @TrackingStat = 'PROCESS'

IF EXISTS (Select top 1 * From DHLShipment Where DHLShipmentID = @DHLShipmentID)
BEGIN
	IF EXISTS (
		Select Top 1 *
		From DHLTrackingShipment a
		Left Join DHLTrackingShipmentEvent c on a.DHLTrackingShipmentID = c.DHLTrackingShipmentID and c.EventType = 'SHIPMENT'
		Where a.DHLTrackingShipmentID = @DHLShipmentID and c.EventCode = 'OK'
	)
	BEGIN
		Set @TrackingStat = 'FINISH'
	END
END
ELSE
BEGIN
	Set @TrackingStat = 'NOTFOUND'
END


SELECT @TrackingStat 'TrackingStat'
GO
