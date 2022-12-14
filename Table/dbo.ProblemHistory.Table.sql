USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProblemHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReqType] [nvarchar](50) NOT NULL,
	[IDRequest] [bigint] NOT NULL,
	[Category] [nvarchar](100) NOT NULL,
	[Case] [nvarchar](200) NOT NULL,
	[Causes] [nvarchar](max) NOT NULL,
	[Impact] [nvarchar](max) NULL,
	[CaseDate] [smalldatetime] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL,
	[IdStep] [bigint] NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProblemHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
