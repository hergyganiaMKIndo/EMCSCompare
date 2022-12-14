USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingInstruction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SlNo] [nvarchar](20) NULL,
	[IdCL] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[DocumentRequired] [nvarchar](max) NULL,
	[SpecialInstruction] [nvarchar](max) NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[CreateBy] [nvarchar](20) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](20) NULL,
	[IsDelete] [bit] NOT NULL,
	[PicBlAwb] [nvarchar](10) NULL,
	[ExportType] [nvarchar](10) NULL,
 CONSTRAINT [PK_ShippingInstruction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
