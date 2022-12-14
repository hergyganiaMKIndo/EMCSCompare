USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DHLLogResponse](
	[DHLLogResponseID] [bigint] IDENTITY(1,1) NOT NULL,
	[DHLLogRequestID] [bigint] NULL,
	[ReqStatus] [nvarchar](50) NULL,
	[ResponseCode] [nvarchar](50) NULL,
	[ResponseMsg] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DHLLogResponse] PRIMARY KEY CLUSTERED 
(
	[DHLLogResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
