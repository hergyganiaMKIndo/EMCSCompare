USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GoodsReceiveArmadaNew](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DoNo] [nvarchar](100) NULL,
	[IdGr] [bigint] NULL,
	[PicName] [nvarchar](100) NULL,
	[PhoneNumber] [nvarchar](100) NULL,
	[KtpNumber] [nvarchar](100) NULL,
	[SimNumber] [nvarchar](100) NULL,
	[SimExpiryDate] [smalldatetime] NULL,
	[StnkNumber] [nvarchar](100) NULL,
	[KirNumber] [nvarchar](50) NULL,
	[KirExpire] [smalldatetime] NULL,
	[NoPolNumber] [nvarchar](100) NULL,
	[EstimationTimePickup] [smalldatetime] NULL,
	[Apar] [bit] NULL,
	[Apd] [bit] NULL,
	[DoReference] [nvarchar](255) NULL,
	[Notes] [nvarchar](max) NULL,
	[VehicleType] [nvarchar](100) NULL,
	[VehicleMark] [nvarchar](100) NULL,
 CONSTRAINT [PK_GoodsReceiveArmadaNew] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoodsReceiveArmadaNew]  WITH CHECK ADD  CONSTRAINT [FK_GoodsReceiveArmadaNew_GoodsReceiveNew] FOREIGN KEY([IdGr])
REFERENCES [dbo].[GoodsReceiveNew] ([Id])
GO
ALTER TABLE [dbo].[GoodsReceiveArmadaNew] CHECK CONSTRAINT [FK_GoodsReceiveArmadaNew_GoodsReceiveNew]
GO
