USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Temptable_cl_request_list_all](
	[Id] [bigint] NOT NULL,
	[IdCl] [nvarchar](20) NOT NULL,
	[IdFlow] [bigint] NOT NULL,
	[IdStep] [bigint] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Pic] [nvarchar](20) NOT NULL,
	[SlNo] [nvarchar](20) NULL,
	[CreateBy] [nvarchar](20) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[UpdateBy] [nvarchar](20) NULL,
	[UpdateDate] [smalldatetime] NULL,
	[IsDelete] [bit] NOT NULL,
	[FlowName] [nvarchar](200) NOT NULL,
	[SubFlowType] [nvarchar](50) NOT NULL,
	[IdNextStep] [bigint] NULL,
	[NextStepName] [nvarchar](100) NULL,
	[NextAssignType] [nvarchar](100) NULL,
	[StatusViewByUser] [nvarchar](200) NULL,
	[CurrentStep] [nvarchar](200) NULL,
	[ClNo] [nvarchar](100) NULL,
	[ETD] [smalldatetime] NULL,
	[ETA] [smalldatetime] NULL,
	[BookingNumber] [nvarchar](20) NULL,
	[BookingDate] [smalldatetime] NULL,
	[PortOfLoading] [nvarchar](max) NULL,
	[PortOfDestination] [nvarchar](max) NULL,
	[Liner] [nvarchar](max) NULL,
	[SailingSchedule] [smalldatetime] NULL,
	[ArrivalDestination] [smalldatetime] NULL,
	[VesselFlight] [nvarchar](30) NULL,
	[Consignee] [nvarchar](100) NULL,
	[StuffingDateStarted] [smalldatetime] NULL,
	[StuffingDateFinished] [smalldatetime] NULL,
	[PreparedBy] [nvarchar](80) NULL,
	[AssignmentType] [nvarchar](200) NULL,
	[NextAssignTo] [nvarchar](100) NULL,
	[SpecialInstruction] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DocumentRequired] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
