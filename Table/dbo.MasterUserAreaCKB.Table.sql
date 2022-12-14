USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterUserAreaCKB](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AreaID] [bigint] NOT NULL,
	[AreaCKB] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[ChangeBy] [nvarchar](50) NULL,
	[ChangeDate] [smalldatetime] NULL,
 CONSTRAINT [PK_MasterUserAreaCKB] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
