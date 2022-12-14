USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role_Access_Menu](
	[ID] [int] NOT NULL,
	[RoleID] [int] NULL,
	[MenuID] [int] NULL,
	[isRead] [bit] NULL,
	[isCreate] [bit] NULL,
	[isUpdated] [bit] NULL,
	[isDeleted] [bit] NULL,
	[EntryDate] [datetime] NULL,
	[EntryBy] [varchar](50) NULL
) ON [PRIMARY]
GO
