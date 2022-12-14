USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TblEmailNotification](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[To] [nvarchar](max) NULL,
	[CC] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NOT NULL,
	[Auditor] [nvarchar](max) NULL,
	[PeriodAudit] [nvarchar](max) NOT NULL,
	[Notifperiod] [smalldatetime] NOT NULL,
	[AlreadySending] [bit] NOT NULL,
	[CreatedOn] [smalldatetime] NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[UpdatedOn] [smalldatetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[IsDelete] [bigint] NOT NULL,
 CONSTRAINT [PK_TblEmailNotification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
