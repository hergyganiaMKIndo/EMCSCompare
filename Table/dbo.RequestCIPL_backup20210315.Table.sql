USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequestCIPL_backup20210315](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdCipl] [nvarchar](20) NOT NULL,
	[IdFlow] [bigint] NOT NULL,
	[IdStep] [bigint] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Pic] [nvarchar](20) NOT NULL,
	[CreateBy] [nvarchar](20) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](20) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL
) ON [PRIMARY]
GO
