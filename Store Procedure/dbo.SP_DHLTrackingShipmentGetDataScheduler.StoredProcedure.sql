USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_DHLTrackingShipmentGetDataScheduler]
@userid varchar(50)

As
Set Nocount On

declare @MsgTime varchar(25), @FirstDate datetime, @LastThreeMonth varchar(8)
Set @MsgTime = convert(varchar(19), GETDATE(), 127)
----Set @FirstDate = DATEADD(month, DATEDIFF(month, 0, getdate()), 0)
----Set @LastThreeMonth = CONVERT(varchar(8), DATEADD(MONTH, -3, @FirstDate), 112)
Set @LastThreeMonth = CONVERT(varchar(8), DATEADD(DAY, -91, GETDATE()), 112)

--select @LastThreeMonth

select top 10 LevelOfDetails = 'ALL_CHECKPOINTS', PiecesEnabled = 'B', MessageTime = @MsgTime, MessageReference = 'Tracking Automatic (' + ISNULL(b.HouseBlNumber, '') + ')'
, AWBNumber = b.HouseBlNumber
into #temp
from Cargo a
Left Join BlAwb b on a.Id = b.IdCl
where LEN(b.HouseBlNumber)=10 
and CONVERT(varchar(8), a.CreateDate, 112) > @LastThreeMonth


Select *
From(
	Select a.*, Tracking_Stat = Case When c.DHLTrackingShipmentID is NULL Then 'PROGRESS' Else 'FINISH' End
	From #temp a
	Left Join DHLTrackingShipment b on a.AWBNumber=b.AWBNumber
	Left Join DHLTrackingShipmentEvent c on b.DHLTrackingShipmentID = c.DHLTrackingShipmentID and c.EventType = 'SHIPMENT' and c.EventCode = 'OK'
)a
Where Tracking_Stat = 'PROGRESS'


Drop table #temp
GO
