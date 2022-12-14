USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleAccess](
	[RoleID] [int] NOT NULL,
	[RoleName] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[EntryDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[EntryBy] [varchar](20) NULL,
	[ModifiedBy] [varchar](20) NULL
) ON [PRIMARY]
GO
