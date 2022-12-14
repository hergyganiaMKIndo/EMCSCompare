USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[Sp_RequestForChange_Insert]      
@FormType nvarchar(300)      
,@FormNo nvarchar(300)     
,@FormId int     
,@Reason nvarchar(MAX)      
,@CreateBy nvarchar(300)      
AS      
BEGIN      
    
DECLARE @Approver NVARCHAR(150)

SET @Approver = CASE
    WHEN (@CreateBy ='XUPJ21WDN') THEN 'xupj21dxd' 
    WHEN (@CreateBy ='xupj21dxd') THEN 'xupj21fig'
END;
    
DECLARE @RFCNumber NVARCHAR(50)       
SELECT TOP 1 @RFCNumber = RFCNumber FROM RequestForChange ORDER BY ID DESC        
DECLARE @PrefixCode NVARCHAR(15)      
DECLARE @Year as NVARCHAR(20)        
SET @PrefixCode = 'RFC'      
SET @Year = YEAR(getdate())      
iF @RFCNumber IS NuLL      
BEGIN        
DECLARE @invnumber NVARCHAR(50)      
SET @invnumber = @PrefixCode + @Year + '000000'       
SET  @RFCNumber =  @invnumber       
END      
ELSE      
BEGIN       
    DECLARE @ID INT             
  DECLARE @Temp NVARCHAR(20)          
  DECLARE @Temp1 NVARCHAR(20)          
  DECLARE @Temp2 NVARCHAR(20)       
  DECLARE @Temp3 NVARCHAR(20)         
  DECLARE @TmpInvoiceNo TABLE (Id INT IDENTITY(1,1), Col4 VARCHAR(50))         
  INSERT INTO @TmpInvoiceNo(Col4) SELECT Data As QuotationNo FROM [fnSplitStringRFC](@RFCNumber,'')          
          
  DECLARE @No as NVARCHAR(20)          
  DECLARE @TableName NVARCHAR(200)          
  SELECT @Year = Col4 FROM @TmpInvoiceNo WHERE Id = 1          
  SELECT @No = Col4 FROM @TmpInvoiceNo WHERE Id = 2            
        
        
  SET @Temp =  SUBSTRING(@RFCNumber, 1, 3)      
  SET @Temp1 = SUBSTRING(@RFCNumber, 4, 4)      
  SET @Temp2 = SUBSTRING(@RFCNumber, 8, 9)      
  SET @Temp3 = SUBSTRING(@RFCNumber, 8, 9)      
  SET @Temp2 = right('00000' + cast(@Temp3 as varchar(6))+ 1, 6)      
  SET @Temp3 = right('00000' + cast(@Temp2 as varchar(6)), 6)      
  IF YEAR(getdate()) = @Temp1          
   BEGIN          
    SET @RFCNumber = @Temp +''+ @Temp1 +''+ @Temp3      
   END          
  ELSE          
   BEGIN       
   SET @RFCNumber = @Temp + CAST(YEAR(getdate()) AS NVARCHAR(4))+''+CAST('000001' AS NVARCHAR(6))          
          
   END        
 END    
    
    
-------------------------------------------------------------------------------    
DECLARE @ResultId INT      
INSERT INTO RequestForChange (FormType,      
FormNo,    
RFCNumber,    
FormId,    
Reason,      
CreateBy,Approver) VALUES (@FormType,@FormNo,@RFCNumber,@FormId,@Reason,@CreateBy,@Approver)      
      
SET @ResultId = SCOPE_IDENTITY()  
  EXEC [dbo].[sp_Process_Email_RFC] @ResultId,'Approval'   
SELECT @ResultId      
END
GO
