USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cipl](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[CiplNo] [nvarchar](20) NULL,
	[ClNo] [nvarchar](20) NULL,
	[EdoNo] [nvarchar](20) NULL,
	[Category] [nvarchar](100) NOT NULL,
	[CategoriItem] [nvarchar](50) NULL,
	[ExportType] [nvarchar](100) NULL,
	[ExportTypeItem] [nvarchar](100) NULL,
	[SoldToName] [nvarchar](200) NOT NULL,
	[SoldToAddress] [nvarchar](max) NOT NULL,
	[SoldToCountry] [nvarchar](100) NOT NULL,
	[SoldToTelephone] [nvarchar](100) NOT NULL,
	[SoldToFax] [nvarchar](100) NULL,
	[SoldToPic] [nvarchar](200) NULL,
	[SoldToEmail] [nvarchar](200) NULL,
	[ConsigneeName] [nvarchar](200) NULL,
	[ConsigneeAddress] [nvarchar](max) NULL,
	[ConsigneeCountry] [nvarchar](100) NULL,
	[ConsigneeTelephone] [nvarchar](100) NULL,
	[ConsigneeFax] [nvarchar](100) NULL,
	[ConsigneePic] [nvarchar](max) NULL,
	[ConsigneeEmail] [nvarchar](200) NULL,
	[NotifyName] [nvarchar](200) NULL,
	[NotifyAddress] [nvarchar](max) NULL,
	[NotifyCountry] [nvarchar](100) NULL,
	[NotifyTelephone] [nvarchar](100) NULL,
	[NotifyFax] [nvarchar](100) NULL,
	[NotifyPic] [nvarchar](200) NULL,
	[NotifyEmail] [nvarchar](200) NULL,
	[ConsigneeSameSoldTo] [bit] NOT NULL,
	[NotifyPartySameConsignee] [bit] NOT NULL,
	[Area] [nvarchar](100) NULL,
	[Branch] [nvarchar](100) NULL,
	[PaymentTerms] [nvarchar](50) NULL,
	[ShippingMethod] [nvarchar](30) NULL,
	[CountryOfOrigin] [nvarchar](100) NULL,
	[Da] [nvarchar](100) NULL,
	[LcNoDate] [nvarchar](30) NULL,
	[IncoTerm] [nvarchar](100) NOT NULL,
	[FreightPayment] [nvarchar](30) NULL,
	[Forwader] [nvarchar](100) NULL,
	[ShippingMarks] [nvarchar](max) NULL,
	[Remarks] [nvarchar](200) NULL,
	[SpecialInstruction] [nvarchar](max) NULL,
	[LoadingPort] [nvarchar](200) NULL,
	[DestinationPort] [nvarchar](200) NULL,
	[ETD] [smalldatetime] NULL,
	[ETA] [smalldatetime] NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL,
	[SoldConsignee] [nvarchar](30) NULL,
	[ShipDelivery] [nvarchar](30) NULL,
	[Rate] [decimal](18, 2) NULL,
	[Currency] [nvarchar](20) NULL,
	[PickUpPic] [nvarchar](50) NULL,
	[PickUpArea] [nvarchar](50) NULL,
	[CategoryReference] [nvarchar](50) NULL,
	[ReferenceNo] [nvarchar](50) NULL,
	[Consolidate] [bit] NULL,
 CONSTRAINT [PK_Cipl] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cipl] ADD  CONSTRAINT [DF_Cipl_Consolidate]  DEFAULT ((0)) FOR [Consolidate]
GO
