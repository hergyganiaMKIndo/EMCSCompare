USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterRegulation](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Instansi] [nvarchar](50) NOT NULL,
	[Nomor] [nvarchar](50) NOT NULL,
	[RegulationType] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Reference] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[RegulationNo] [nvarchar](50) NOT NULL,
	[TanggalPenetapan] [date] NOT NULL,
	[TanggalDiUndangkan] [date] NOT NULL,
	[TanggalBerlaku] [date] NOT NULL,
	[TanggalBerakhir] [date] NOT NULL,
	[Keterangan] [nvarchar](max) NOT NULL,
	[Files] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_MasterRegulation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
