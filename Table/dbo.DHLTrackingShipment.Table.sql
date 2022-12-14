USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DHLTrackingShipment](
	[DHLTrackingShipmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[DHLShipmentID] [bigint] NULL,
	[AWBNumber] [nvarchar](50) NULL,
	[OriginSvcAreaCode] [nvarchar](50) NULL,
	[OriginSvcAreaDesc] [nvarchar](50) NULL,
	[DestSvcAreaCode] [nvarchar](50) NULL,
	[DestSvcAreaDesc] [nvarchar](50) NULL,
	[DestSvcAreaFacility] [nvarchar](50) NULL,
	[ShipperName] [nvarchar](100) NULL,
	[ConsigneeName] [nvarchar](100) NULL,
	[ShipmentDate] [datetime] NULL,
	[Pieces] [int] NULL,
	[Weight] [decimal](18, 2) NULL,
	[WeightUnit] [nvarchar](20) NULL,
	[ServiceType] [nvarchar](20) NULL,
	[ShipmentDescription] [nvarchar](255) NULL,
	[ShipperCity] [nvarchar](100) NULL,
	[ShipperSuburb] [nvarchar](50) NULL,
	[ShipperPostalCode] [nvarchar](50) NULL,
	[ShipperCountryCode] [nvarchar](50) NULL,
	[ConsigneeCity] [nvarchar](100) NULL,
	[ConsigneePostalCode] [nvarchar](50) NULL,
	[ConsigneeCountryCode] [nvarchar](50) NULL,
	[ShipperReferenceID] [nvarchar](200) NULL,
	[ServiceInvocationID] [nvarchar](200) NULL,
	[IsDelete] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DHLTrackingShipment] PRIMARY KEY CLUSTERED 
(
	[DHLTrackingShipmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
