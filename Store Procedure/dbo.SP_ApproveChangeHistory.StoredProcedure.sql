USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_ApproveChangeHistory]         
        
 @Id INT      
 ,@UpdatedBy NVARCHAR(200)     
AS        
BEGIN        
 UPDATE RequestForChange        
 SET [Status] = 1 ,  UpdateBy = @UpdatedBy       
 WHERE         
   Id = @Id       
     
    EXEC [dbo].[sp_Process_Email_RFC] @Id,'Approved'     
END 
GO
