USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_SubConCompanyDelete]
(@Id bigint)
as 
begin
delete from MasterSubConCompany
where Id = @Id 
select @Id as Id
end	

GO
