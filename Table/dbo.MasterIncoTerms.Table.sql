USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterIncoTerms](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Number] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL,
 CONSTRAINT [PK_MasterIncoTerms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
