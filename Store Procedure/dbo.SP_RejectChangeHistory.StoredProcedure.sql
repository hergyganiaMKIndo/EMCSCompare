USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ALTER PROCEDURE [dbo].[SP_PackagesItemUpdate]
-- (
-- 	@Id BIGINT,
-- 	@PackagesInsured DECIMAL(20,2) = 0,
-- 	@CustReferences NVARCHAR(50) = '',
-- 	@UpdateBy NVARCHAR(50),
-- 	@UpdateDate datetime
-- )
-- AS
-- BEGIN

-- 	UPDATE dbo.DHLPackage
-- 	SET Insured = @PackagesInsured
-- 		   ,CustReferences = @CustReferences
-- 		   ,UpdateBy = @UpdateBy
--            ,UpdateDate = UpdateDate
-- 	WHERE DHLPackageID = @Id;

-- END
-- GO



CREATE PROC [dbo].[SP_RejectChangeHistory]             
 @Id INT        
 ,@Reason NVARCHAR(MAX)        
 ,@UpdatedBy NVARCHAR(MAX)        
AS            
BEGIN  

DECLARE @FormId INT
 UPDATE RequestForChange            
 SET [Status] = 2 , ReasonIfRejected = @Reason ,  UpdateBy =  @UpdatedBy         
 WHERE             
   Id = @Id     

   

   DELETE FROM CiplItem_Change where IdCipl = (SELECT FormId FROM RequestForChange where Id = @Id)

   EXEC [dbo].[sp_Process_Email_RFC] @Id,'Reject'     


END 
GO
