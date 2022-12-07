USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[SP_GetCiplId]
(@DoNo nvarchar(max))
as
begin
select * from Cipl
where EdoNo In (select * from [SDF_SplitString](@DoNo,','))
end

GO
