USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BastNumber](
	[BastNo] [numeric](38, 0) NULL,
	[ReferenceNo] [varchar](40) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nomor BAST (DA) untuk RUE dari SAP (EDW_STG_SAP_ECC_DAILY)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BastNumber'
GO
