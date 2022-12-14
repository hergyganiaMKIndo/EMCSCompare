USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterBranch](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AreaID] [int] NOT NULL,
	[BranchCode] [nvarchar](50) NULL,
	[BranchDesc] [nvarchar](255) NOT NULL,
	[PICBranch] [nvarchar](50) NOT NULL,
	[IsCC100] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL,
 CONSTRAINT [PK_MasterBranch] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
