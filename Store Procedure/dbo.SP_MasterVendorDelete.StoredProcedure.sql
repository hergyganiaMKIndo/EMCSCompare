USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_MasterVendorDelete]  
(@Id bigint)  
as   
begin  
delete from MasterVendor  
where Id = @Id   
select @Id as Id  
end 
GO
