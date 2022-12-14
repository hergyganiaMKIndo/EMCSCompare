USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterSuperior](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeUsername] [nvarchar](100) NOT NULL,
	[EmployeeName] [nvarchar](500) NOT NULL,
	[SuperiorUsername] [nvarchar](100) NOT NULL,
	[SuperiorName] [nvarchar](500) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreateBy] [nvarchar](100) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](100) NULL,
	[UpdateDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
