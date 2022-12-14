USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CIPLHistory_backup20210315](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdCipl] [bigint] NOT NULL,
	[Flow] [nvarchar](50) NOT NULL,
	[Step] [nvarchar](100) NOT NULL,
	[Status] [nvarchar](200) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](20) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](20) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
