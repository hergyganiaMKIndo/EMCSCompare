USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




  CREATE procedure [dbo].[sp_get_shippingfleet_gr]
  (
  @Id nvarchar(100)
  )
  as
  begin
  select * from ShippingFleet
  where IdGr = @Id
  End
  
GO
