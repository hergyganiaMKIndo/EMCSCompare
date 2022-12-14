USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterCustomer](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustNr] [nvarchar](50) NOT NULL,
	[CustName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](200) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[Region] [nvarchar](100) NULL,
	[Street] [nvarchar](200) NULL,
	[Country] [nvarchar](50) NULL,
	[Telp] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[CreateOn] [smalldatetime] NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MasterCustomer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
