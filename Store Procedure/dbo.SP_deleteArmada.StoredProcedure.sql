USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




 CREATE procedure [dbo].[SP_deleteArmada](  
  @id nvarchar(100))        
  as        
  begin        
  delete From ShippingFleet        
  where Id = @id      
  delete From ShippingFleetRefrence  
  where IdShippingFleet = @id        
  end 

GO
