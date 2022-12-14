USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotifikasiEmail](
	[ID] [bigint] NOT NULL,
	[IdFlow] [bigint] NULL,
	[IdStep] [bigint] NULL,
	[Status] [nvarchar](50) NULL,
	[SendType] [nvarchar](50) NULL,
	[SendTo] [nvarchar](50) NULL,
	[Name] [nvarchar](200) NULL,
	[Subject] [nvarchar](50) NULL,
	[Template] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
