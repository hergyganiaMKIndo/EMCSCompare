USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[Sp_checkarmadadata] --'40946'
(
@Id nvarchar(max)
)
as
begin

select Count(*) from CiplItem where IdCipl In (select distinct IdCipl from ShippingFleetItem where IdGr = @Id)
end
GO
