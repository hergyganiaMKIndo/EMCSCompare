USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingFleet_Change](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdShippingFleet] [bigint] NOT NULL,
	[IdGr] [bigint] NOT NULL,
	[IdCipl] [nvarchar](max) NULL,
	[DoNo] [nvarchar](max) NULL,
	[DaNo] [nvarchar](50) NOT NULL,
	[PicName] [nvarchar](100) NOT NULL,
	[PhoneNumber] [nvarchar](100) NULL,
	[KtpNumber] [nvarchar](100) NULL,
	[SimNumber] [nvarchar](100) NULL,
	[SimExpiryDate] [datetime] NULL,
	[StnkNumber] [nvarchar](100) NULL,
	[KirNumber] [nvarchar](50) NULL,
	[KirExpire] [datetime] NULL,
	[NopolNumber] [nvarchar](100) NULL,
	[EstimationTimePickup] [datetime] NULL,
	[Apar] [bit] NULL,
	[Apd] [bit] NULL,
	[FileName] [nvarchar](max) NULL,
	[Bast] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
