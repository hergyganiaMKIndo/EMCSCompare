USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_getcontainertype]
(
	@ContainerType nvarchar(50),
	@Value  nvarchar(50)
	
)	
as 
begin
select * from MasterParameter
where   Value = @Value  and [Group] = @ContainerType
end
GO
