USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlAwbDocumentHistory](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdBlAwb] [bigint] NOT NULL,
	[FileName] [nvarchar](max) NOT NULL,
	[CreateDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
