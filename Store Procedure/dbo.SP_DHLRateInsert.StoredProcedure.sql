USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_DHLRateInsert](@dtDHLRateType DHLRateType ReadOnly)  

As
Begin  
	Declare @DHLShipmentID bigint
	Select @DHLShipmentID = a.DHLShipmentID From ( Select top 1 * From @dtDHLRateType )a
	
	If exists (Select Top 1 * from DHLRate where DHLShipmentID = @DHLShipmentID)
	Begin 
		Delete From DHLRate Where DHLShipmentID = @DHLShipmentID
	End

    insert into DHLRate (DHLShipmentID, ServiceType, Currency, ChargeCode, ChargeType, ChargeAmount, DeliveryTime, CutoffTime, NextBusinessDay, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	select DHLShipmentID=DHLShipmentID, ServiceType=ServiceType, Currency=Currency, ChargeCode=ChargeCode, ChargeType=ChargeType, ChargeAmount=ChargeAmount, DeliveryTime=DeliveryTime, CutoffTime=CutoffTime
		 , NextBusinessDay=NextBusinessDay, IsDelete=0, CreateBy=UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate =NULL
	from @dtDHLRateType  
End  
GO
