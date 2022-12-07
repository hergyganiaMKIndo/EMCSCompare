USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[SP_UpdateGr](
  @Id nvarchar(100),
   @PickupPoint nvarchar(100),
   @PickupPic nvarchar(100)
  )
  as 
  begin 
  Update GoodsReceive
  set PickupPoint = @PickupPoint,
  PickupPic = @PickupPic
  where Id = @Id
  select * from GoodsReceive
  where Id = @Id
  End
  

GO
