USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlAwb](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdCl] [bigint] NOT NULL,
	[Number] [nvarchar](200) NOT NULL,
	[MasterBlDate] [datetime] NULL,
	[HouseBlNumber] [nvarchar](200) NULL,
	[HouseBlDate] [datetime] NULL,
	[Description] [nvarchar](max) NOT NULL,
	[FileName] [nvarchar](200) NULL,
	[Publisher] [nvarchar](50) NOT NULL,
	[BlAwbDate] [smalldatetime] NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_BlAwb] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
