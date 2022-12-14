USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequestForChange](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RFCNumber] [nvarchar](150) NULL,
	[FormType] [nvarchar](150) NULL,
	[FormId] [int] NULL,
	[FormNo] [nvarchar](150) NULL,
	[Status] [int] NOT NULL,
	[Reason] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](150) NULL,
	[CreateDate] [datetime] NOT NULL,
	[Approver] [nvarchar](150) NULL,
	[UpdateBy] [nvarchar](150) NULL,
	[UpdateDate] [datetime] NULL,
	[ReasonIfRejected] [nvarchar](max) NULL,
 CONSTRAINT [PK_RequestForChange] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RequestForChange] ADD  CONSTRAINT [DF_RequestForChange_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[RequestForChange] ADD  CONSTRAINT [DF_RequestForChange_CreateDate]  DEFAULT (getutcdate()) FOR [CreateDate]
GO
