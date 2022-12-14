USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlAwb_History](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdBlAwb] [bigint] NOT NULL,
	[IdCl] [bigint] NOT NULL,
	[Number] [nvarchar](200) NOT NULL,
	[MasterBlDate] [datetime] NULL,
	[HouseBlNumber] [nvarchar](200) NULL,
	[HouseBlDate] [datetime] NULL,
	[Description] [nvarchar](max) NOT NULL,
	[FileName] [nvarchar](200) NULL,
	[Publisher] [nvarchar](50) NOT NULL,
	[BlAwbDate] [smalldatetime] NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[Status] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[BlAwb_History] ADD  CONSTRAINT [DF_BlAwb_History_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
