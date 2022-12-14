USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_SubConCompanyAdd]  
(  
@Id nvarchar(100),  
@Name nvarchar(max),  
@Value nvarchar(max),  
@CreateBy nvarchar(Max),  
@UpdatedBy nvarchar(Max) 
)  
as  
begin  
If (@Id = 0)  
begin  
insert into MasterSubConCompany([Name],[Value],CreatedBy,UpdatedBy,CreateDate,UpdateDate)  
VALUES(@Name,@Value,@CreateBy,'',GetDate(),'')  
SET @Id = SCOPE_IDENTITY()  
end  
else  
begin  
update MasterSubConCompany  
set [Name] = @Name,  
[Value] = @Value,  
UpdatedBy = @UpdatedBy,   
UpdateDate = GETDATE()  
where Id = @Id  
end  
select CAST(@Id as bigint) as Id
end


GO
