USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RptToDoList](
	[ReportName] [varchar](100) NULL,
	[Name] [varchar](50) NULL,
	[Url] [varchar](50) NULL,
	[Value] [int] NULL,
	[TotalValue] [decimal](18, 2) NULL,
	[TotalWeight] [decimal](18, 2) NULL,
	[UserID] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]
GO
