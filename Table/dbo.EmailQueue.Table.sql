USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailQueue](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Module] [nvarchar](50) NULL,
	[RecipientType] [nvarchar](50) NULL,
	[IdRequest] [bigint] NULL,
	[EmailTo] [nvarchar](max) NULL,
	[EmailSubject] [nvarchar](200) NULL,
	[EmailBody] [nvarchar](max) NULL,
	[MailItemID] [int] NULL,
	[IsSent] [bit] NULL,
	[Message] [nvarchar](max) NULL,
	[SendDate] [smalldatetime] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NULL,
 CONSTRAINT [PK_EmailQueue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
