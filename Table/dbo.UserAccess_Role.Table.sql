USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccess_Role](
	[UserID] [varchar](20) NOT NULL,
	[RoleID] [int] NOT NULL,
	[RoleMode] [varchar](9) NOT NULL
) ON [PRIMARY]
GO
