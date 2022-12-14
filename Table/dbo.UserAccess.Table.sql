USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccess](
	[UserID] [varchar](20) NOT NULL,
	[LevelID] [int] NULL,
	[RoleID] [int] NULL,
	[GroupID] [int] NULL,
	[Position] [nvarchar](100) NULL,
	[FullName] [varchar](50) NOT NULL,
	[Phone] [varchar](20) NULL,
	[Email] [varchar](50) NULL,
	[Password] [varchar](255) NULL,
	[UserType] [varchar](20) NOT NULL,
	[Cust_Group_No] [varchar](20) NULL,
	[Status] [tinyint] NULL,
	[EntryDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[EntryBy] [varchar](20) NULL,
	[ModifiedBy] [varchar](20) NULL
) ON [PRIMARY]
GO
