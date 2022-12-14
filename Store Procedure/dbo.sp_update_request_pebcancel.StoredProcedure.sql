USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_update_request_pebcancel] -- exec [sp_update_request_pebcancel] 1, 'CKB1', 'Submit', 'Testing Notes'    
 (    
  @IdCl BIGINT    
 ,@Username NVARCHAR(100)    
 ,@NewStatus NVARCHAR(100)    
 ,@Notes NVARCHAR(100) = ''    
 ,@IsCancelled int     
 )    
AS    
BEGIN    
 DECLARE @NewStepId BIGINT;    
 DECLARE @IdFlow BIGINT;    
 DECLARE @FlowName NVARCHAR(100);    
 DECLARE @NextStepName NVARCHAR(100);    
 DECLARE @Now DATETIME;    
 DECLARE @GroupId NVARCHAR(100);    
 DECLARE @UserType NVARCHAR(100);    
 DECLARE @NextStepIdSystem BIGINT;    
 DECLARE @LoadingPort NVARCHAR(100);    
 DECLARE @DestinationPort NVARCHAR(100);    
 DECLARE @CurrentStepId BIGINT;    
 DECLARE @CurrentStatus NVARCHAR(100);    
    
 SET @Now = GETDATE();    
 IF @IsCancelled = 4 and @NewStatus = 'CancelRequest'    
 begin    
 SET @FlowName = 'PebNpe'    
 set @NextStepName = @NewStatus    
 update NpePeb     
 set IsCancelled = 0    
 where Id = @IdCl     
 end    
 else if @IsCancelled = 4 and @NewStatus = 'CancelApproval'    
 begin    
 SET @FlowName = 'PebNpe'    
 set @NextStepName = @NewStatus    
 update NpePeb    
 set IsCancelled = 1    
 where Id = @IdCl     
 end    
 else if @IsCancelled = 4 and @NewStatus = 'Cancel'    
 begin    
 SET @FlowName = 'PebNpe'    
 set @NextStepName = @NewStatus    
 update NpePeb    
 set IsCancelled = 2    
 where Id = @IdCl    
 end    
 else if(@NewStatus = 'CancelRequest' and @IsCancelled = 3)    
 begin    
   SET @NewStepId = 30074    
   SET @NextStepName = 'CancelRequest'    
   SET @FlowName = 'CL'    
   set @NextStepName = 'CancelApproval'    
  UPDATE [dbo].[RequestCl]    
  SET [IdStep] = 30074    
   ,[Status] = 'CancelRequest'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
  WHERE IdCl = @IdCl    
  UPDATE [dbo].[RequestCipl]    
  SET IdStep = 30074    
   ,[Status] ='CancelRequest'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
  WHERE IdCipl = (select Top(1)IdCipl from  CargoCipl where IdCargo =  @IdCl)   
  update [dbo].RequestGr  
  set IdStep = 30074    
   ,[Status] ='CancelRequest'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()   
   where IdGr = (select Top(1) IdGr from ShippingFleetRefrence where IdCipl = (select Top(1)IdCipl from  CargoCipl where IdCargo =  @IdCl))  
 end    
 else if(@NewStatus = 'CancelApproval' and @IsCancelled = 3)    
 begin    
 SET @NewStepId = 30075    
   SET @NextStepName = 'CancelApproval'    
   SET @FlowName = 'CL'    
   set @NextStepName = 'Cancel'    
  UPDATE [dbo].[RequestCl]    
  SET [IdStep] = 30075    
   ,[Status] = 'CancelApproval'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
  WHERE IdCl = @IdCl    
  UPDATE [dbo].[RequestCipl]    
  SET IdStep = 30075    
   ,[Status] ='CancelApproval'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
  WHERE IdCipl = (select Top(1)IdCipl from  CargoCipl where IdCargo =  @IdCl)    
  update [dbo].RequestGr  
  SET IdStep = 30075    
   ,[Status] ='CancelApproval'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
   where IdGr = (select Top(1) IdGr from ShippingFleetRefrence where IdCipl = (select Top(1)IdCipl from  CargoCipl where IdCargo =  @IdCl))  
 end    
 else if(@NewStatus = 'Cancel' and @IsCancelled = 3)    
 begin    
  SET @NewStepId = 30076    
   SET @NextStepName = 'Cancel'    
   SET @FlowName = 'CL'    
   set @NextStepName = 'Cancel'    
  UPDATE [dbo].[RequestCl]    
  SET [IdStep] = 30076    
   ,[Status] = 'Cancel'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
  WHERE IdCl = @IdCl    
  UPDATE [dbo].[RequestCipl]    
  SET IdStep = 30076    
   ,[Status] = 'Cancel'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
  WHERE IdCipl = (select Top(1)IdCipl from  CargoCipl where IdCargo =  @IdCl)   
  update [dbo].RequestGr  
  SET IdStep = 30076    
   ,[Status] = 'Cancel'    
   --,[Pic] = @Username    
   ,[UpdateBy] = @Username    
   ,[UpdateDate] = GETDATE()    
   where IdGr = (select Top(1) IdGr from ShippingFleetRefrence where IdCipl = (select Top(1)IdCipl from  CargoCipl where IdCargo =  @IdCl))  
 end    
 --======================================================    
 EXEC [dbo].[sp_insert_cl_history] @id = @IdCl    
  ,@Flow = @FlowName    
  ,@Step = @NextStepName    
  ,@Status = @NewStatus    
  ,@Notes = @Notes    
  ,@CreateBy = @Username    
  ,@CreateDate = @Now;    
END
GO
