USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotifikasiEmail_20200728](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IdFlow] [bigint] NULL,
	[IdStep] [bigint] NULL,
	[Status] [nvarchar](50) NULL,
	[SendType] [nvarchar](50) NULL,
	[SendTo] [nvarchar](50) NULL,
	[Name] [nvarchar](200) NULL,
	[Subject] [nvarchar](50) NULL,
	[Template] [nvarchar](max) NULL,
 CONSTRAINT [PK_NotifikasiEmail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
