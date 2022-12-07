USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_delete_cargo_item_Change]
@Id nvarchar(100)
as
begin
delete from CargoItem_Change
where IdCargo = @Id
select Cast(@Id as bigint) As Id
end
GO
