USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFCItem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RFCID] [int] NULL,
	[TableName] [nvarchar](100) NULL,
	[LableName] [nvarchar](100) NULL,
	[FieldName] [nvarchar](100) NULL,
	[BeforeValue] [nvarchar](max) NULL,
	[AfterValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_RFCItem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
