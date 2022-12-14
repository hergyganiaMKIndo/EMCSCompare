USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterVideo](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Video] [nvarchar](max) NULL,
	[StartedDate] [smalldatetime] NOT NULL,
	[FinishedDate] [smalldatetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_MasterVideo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
