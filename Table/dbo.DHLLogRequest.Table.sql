USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DHLLogRequest](
	[DHLLogRequestID] [bigint] IDENTITY(1,1) NOT NULL,
	[DHLShipmentID] [bigint] NULL,
	[DHLTrackingShipmentID] [bigint] NULL,
	[ReqType] [nvarchar](20) NULL,
	[Param] [varchar](max) NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DHLLogRequest] PRIMARY KEY CLUSTERED 
(
	[DHLLogRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
