USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GoodsReceiveDocument](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdGr] [bigint] NOT NULL,
	[DocumentDate] [datetime] NOT NULL,
	[DocumentName] [nvarchar](max) NOT NULL,
	[Filename] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[UpdateBy] [nvarchar](max) NULL,
	[UpdateDate] [datetime] NULL,
	[IsDelete] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
