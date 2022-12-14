USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[Sp_ChangeHistory_Insert]          
@FormType nvarchar(300)          
,@FormNo nvarchar(300)         
,@FormId int         
,@Reason nvarchar(MAX)          
,@CreateBy nvarchar(300)          
AS          
BEGIN          
        
DECLARE @Approver NVARCHAR(150)    
    
       
DECLARE @ResultId INT          
INSERT INTO RequestForChange (FormType,          
FormNo,        
RFCNumber,        
FormId,        
Reason,          
CreateBy,Approver,[Status]) VALUES (@FormType,@FormNo,'',@FormId,@Reason,@CreateBy,'',1)          
          
SET @ResultId = SCOPE_IDENTITY()      
        
SELECT @ResultId          
END
GO
