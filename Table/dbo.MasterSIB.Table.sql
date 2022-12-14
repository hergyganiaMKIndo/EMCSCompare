USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterSIB](
	[ReqNumber] [nvarchar](20) NOT NULL,
	[DlrWO] [nvarchar](20) NOT NULL,
	[DlrClm] [nvarchar](10) NOT NULL,
	[SvcClm] [nvarchar](10) NOT NULL,
	[PartNo] [nvarchar](10) NOT NULL,
	[SerialNumber] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[DlrCode] [nvarchar](5) NOT NULL,
	[UnitPrice] [decimal](18, 3) NOT NULL,
	[Currency] [nvarchar](10) NULL,
	[Qty] [nvarchar](100) NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MasterSIB] ADD  CONSTRAINT [DF_MasterSIB_UnitPrice]  DEFAULT ((0)) FOR [UnitPrice]
GO
