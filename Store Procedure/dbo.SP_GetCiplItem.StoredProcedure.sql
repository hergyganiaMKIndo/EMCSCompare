USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_GetCiplItem]
(
@IdCipl nvarchar(100)
)
as 
begin 
select count(Id) from CiplItem
where IdCipl = @IdCipl and IsDelete = 0
end

GO
