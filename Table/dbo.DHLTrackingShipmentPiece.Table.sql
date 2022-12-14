USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DHLTrackingShipmentPiece](
	[DHLTrackingShipmentPieceID] [bigint] IDENTITY(1,1) NOT NULL,
	[DHLTrackingShipmentID] [bigint] NULL,
	[AWBNumber] [nvarchar](50) NULL,
	[LicensePlate] [nvarchar](50) NULL,
	[PieceNumber] [int] NULL,
	[Depth] [decimal](18, 2) NULL,
	[Width] [decimal](18, 2) NULL,
	[Height] [decimal](18, 2) NULL,
	[Weight] [decimal](18, 2) NULL,
	[PackageType] [nvarchar](50) NULL,
	[DimWeight] [decimal](18, 2) NULL,
	[WeightUnit] [nvarchar](50) NULL,
	[IsDelete] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DHLTrackingShipmentPiece] PRIMARY KEY CLUSTERED 
(
	[DHLTrackingShipmentPieceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
