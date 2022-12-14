USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterGroup](
	[ID] [bigint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [smalldatetime] NULL
) ON [PRIMARY]
GO
