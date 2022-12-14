USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Documents](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdRequest] [bigint] NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Step] [bigint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Tag] [nvarchar](100) NULL,
	[Date] [smalldatetime] NOT NULL,
	[FileName] [nvarchar](max) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
