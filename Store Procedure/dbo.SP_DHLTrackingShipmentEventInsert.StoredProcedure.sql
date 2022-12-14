USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_DHLTrackingShipmentEventInsert](@dtDHLTrackingEvent DHLTrackingEvent ReadOnly)  

As
Begin  
	IF NOT EXISTS (
		Select top 1 * from @dtDHLTrackingEvent a
		left join DHLTrackingShipmentEvent b on a.DHLTrackingShipmentID=b.DHLTrackingShipmentID and a.LicensePlate=b.LicensePlate
		where b.EventCode = 'OK'
	)
	BEGIN
		IF EXISTS(
			Select top 1 * from @dtDHLTrackingEvent a
			left join DHLTrackingShipmentEvent b on a.DHLTrackingShipmentID=b.DHLTrackingShipmentID and a.EventType=b.EventType and a.LicensePlate=b.LicensePlate
		)
		BEGIN
			Delete b
			From @dtDHLTrackingEvent a
			left join DHLTrackingShipmentEvent b on a.DHLTrackingShipmentID=b.DHLTrackingShipmentID and a.EventType=b.EventType and a.LicensePlate=b.LicensePlate
		END
	
		insert into DHLTrackingShipmentEvent (DHLTrackingShipmentID, EventType, EventDate, EventTime, EventCode, EventDesc, SvcAreaCode, SvcAreaDesc, Signatory
											, ReferenceID, LicensePlate, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
		select DHLTrackingShipmentID=[DHLTrackingShipmentID], EventType=[EventType], EventDate=[EventDate], EventTime=[EventTime], EventCode=[EventCode]
			 , EventDesc=[EventDesc], SvcAreaCode=[SvcAreaCode], SvcAreaDesc=[SvcAreaDesc], Signatory=[Signatory], ReferenceID=[ReferenceID]
			 , LicensePlate=[LicensePlate], IsDelete=0, CreateBy=[UserID], CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate =NULL
		from @dtDHLTrackingEvent  
	END
End  
GO
