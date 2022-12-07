USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[Sp_GetArmdaList]
(@IdGr bigint,
@Id BigInt )
as
begin
if @Id = 0
begin
select * from ShippingFleet
where IdGr = @IdGr 
end
else
begin 
select * from ShippingFleet
where Id = @Id
end 
end


GO
