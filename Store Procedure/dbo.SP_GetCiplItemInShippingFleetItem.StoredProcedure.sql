USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
 CREATE procedure [dbo].[SP_GetCiplItemInShippingFleetItem]
(
@IdCipl nvarchar(100),
@IdGr nvarchar(100)
)
as 
begin 
select count(IdCiplItem) from ShippingFleetItem
where IdCipl = @IdCipl and IdGr = @IdGr
end

GO
