USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_CiplItemChangeList]
(
@Id nvarchar(50)
)
as 
begin
select * from CiplItem_Change
where IdCipl = @Id
END

GO
