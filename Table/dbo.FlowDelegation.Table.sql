USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowDelegation](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[IdReq] [bigint] NOT NULL,
	[IdFlow] [bigint] NOT NULL,
	[IdStep] [bigint] NOT NULL,
	[AssignType] [nvarchar](50) NOT NULL,
	[AssignTo] [nvarchar](50) NOT NULL,
	[CreateBy] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[UpdateDate] [datetime] NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_DelegationReq] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FlowDelegation] ADD  CONSTRAINT [DF_DelegationReq_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
