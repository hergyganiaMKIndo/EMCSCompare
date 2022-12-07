USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_searchContainerNumber]
(
	@IdCargo bigint,
	@ContainerNumber  nvarchaR(100)
	
)	
as 
begin
select * from CargoItem
where IdCargo = @IdCargo and ContainerNumber = @ContainerNumber
end
GO
