USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DHLTrackingShipmentEvent](
	[DHLTrackingShipmentEventID] [bigint] IDENTITY(1,1) NOT NULL,
	[DHLTrackingShipmentID] [bigint] NULL,
	[EventType] [nvarchar](50) NULL,
	[EventDate] [nvarchar](20) NULL,
	[EventTime] [nvarchar](20) NULL,
	[EventCode] [nvarchar](50) NULL,
	[EventDesc] [nvarchar](200) NULL,
	[SvcAreaCode] [nvarchar](50) NULL,
	[SvcAreaDesc] [nvarchar](200) NULL,
	[Signatory] [nvarchar](150) NULL,
	[ReferenceID] [nvarchar](200) NULL,
	[LicensePlate] [nvarchar](50) NULL,
	[IsDelete] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DHLTrackingShipmentEvent] PRIMARY KEY CLUSTERED 
(
	[DHLTrackingShipmentEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
