USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Menu](
	[ID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[Name] [nvarchar](200) NULL,
	[URL] [nvarchar](max) NULL,
	[OrderNo] [int] NULL,
	[Icon] [nvarchar](50) NULL,
	[isDefault] [bit] NULL,
	[isActive] [bit] NULL,
	[EntryDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[EntryBy] [varchar](50) NULL,
	[ModifiedBy] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
