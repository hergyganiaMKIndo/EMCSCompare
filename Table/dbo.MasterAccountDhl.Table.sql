USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterAccountDhl](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountNumber] [nvarchar](200) NOT NULL,
	[AccountName] [nvarchar](500) NOT NULL,
	[CreateBy] [nvarchar](500) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[UpdateBy] [nvarchar](500) NULL,
	[UpdateDate] [datetime] NULL,
	[IsDelete] [bit] NULL,
 CONSTRAINT [PK_MasterAccountDhl] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
