USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowStep_20200928](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdFlow] [bigint] NOT NULL,
	[Step] [nvarchar](200) NOT NULL,
	[AssignType] [nvarchar](200) NOT NULL,
	[AssignTo] [nvarchar](50) NULL,
	[Sort] [int] NOT NULL,
	[CreateBy] [nvarchar](20) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](20) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL
) ON [PRIMARY]
GO
