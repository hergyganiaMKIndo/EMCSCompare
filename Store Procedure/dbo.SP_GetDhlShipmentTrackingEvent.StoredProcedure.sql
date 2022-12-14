USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetDhlShipmentTrackingEvent]
(    
	@AwbId BIGINT
)
AS
BEGIN

	SELECT EventDate
		, EventTime
		, EventDesc
		, SvcAreaDesc
	FROM DHLTrackingShipmentEvent 
	WHERE IsDelete = 0 AND DHLTrackingShipmentID = @AwbId
	AND EventType = 'SHIPMENT'
	ORDER BY EventDate, EventTime ASC
END

GO
