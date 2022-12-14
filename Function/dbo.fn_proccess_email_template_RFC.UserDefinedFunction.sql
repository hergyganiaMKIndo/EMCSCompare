USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_proccess_email_template_RFC]    
(        
                @RFCId INT = '',        
                @Template nvarchar(max) = ''       
)        
RETURNS NVARCHAR(MAX)    
AS    
BEGIN    
    
DECLARE @RequestNo NVARCHAR(MAX)    
DECLARE @CreatedDate DATETIME    
DECLARE @DocumentType NVARCHAR(MAX)    
DECLARE @DocumentNo NVARCHAR(MAX)    
DECLARE @RequestReason NVARCHAR(MAX)    
DECLARE @SuperiorName NVARCHAR(MAX)    
DECLARE @SuperiorEmpID NVARCHAR(MAX)    
DECLARE @MobileLink NVARCHAR(MAX)    
DECLARE @DesktopLink NVARCHAR(MAX)    
DECLARE @RequestorName NVARCHAR(MAX)    
DECLARE @RequestorEmpID NVARCHAR(MAX)    
DECLARE @ApproverName NVARCHAR(MAX)    
DECLARE @ReasonIfRejected NVARCHAR(MAx)    
DECLARE @UpdatedDate Datetime    
    
    
SET @MobileLink = 'http://pis.trakindo.co.id'    
SET @DesktopLink = 'http://pis.trakindo.co.id'    
    
SELECT @RequestNo = RFC.RFCNumber    
,@DocumentType = RFC.FormType    
,@DocumentNo = RFC.FormNo    
,@RequestReason = RFC.Reason    
,@RequestorEmpID = RFC.CreateBy    
,@CreatedDate = RFC.CreateDate    
,@SuperiorEmpID = RFC.Approver    
,@UpdatedDate = RFC.UpdateDate    
,@ReasonIfRejected = RFC.ReasonIfRejected    
,@ApproverName = t2.Employee_Name    
,@RequestorName = t1.Employee_Name    
,@SuperiorName = t2.Employee_Name    
FROM RequestForChange RFC     
LEFT JOIN dbo.fn_get_employee_internal_ckb() t1 on t1.AD_User = RFC.CreateBy      
LEFT JOIN dbo.fn_get_employee_internal_ckb() t2 on t2.AD_User =RFC.Approver    
WHERE ID = @RFCId    
    
BEGIN    
 DECLARE @variable_table TABLE (        
                                    key_data VARCHAR(MAX) NULL,        
                                    val_data VARCHAR(MAX) NULL        
                                );        
           DECLARE @key NVARCHAR(MAX),         
                                                @flow NVARCHAR(MAX),         
                                                @val NVARCHAR(MAX)    
INSERT         
    INTO         
      @variable_table         
      VALUES         
      ('@RequestNo', ISNULL(@RequestNo, '-'))        
      ,('@DocumentType', ISNULL(@DocumentType, '-'))     
   ,('@DocumentNo', ISNULL(@DocumentNo, '-'))     
   ,('@RequestReason', ISNULL(@RequestReason, '-'))     
   ,('@RequestorEmpID', ISNULL(@RequestorEmpID, '-'))     
   ,('@CreatedDate', ISNULL(CONVERT(nvarchar(10), @CreatedDate, 103), '-'))     
   ,('@SuperiorEmpID', ISNULL(@SuperiorEmpID, '-'))     
   ,('@UpdatedDate', ISNULL(CONVERT(nvarchar(10), @UpdatedDate, 103), '-'))     
   ,('@ReasonIfRejected', ISNULL(@ReasonIfRejected, '-'))     
   ,('@ApproverName', ISNULL(@ApproverName, '-'))     
   ,('@RequestorName', ISNULL(@RequestorName, '-'))     
   ,('@SuperiorName', ISNULL(@SuperiorName, '-'))     
      
              
    
    
    BEGIN        
                                DECLARE cursor_variable CURSOR        
                                FOR         
                                                SELECT         
                                                                key_data,         
                                                                val_data         
                                                FROM         
                                                                @variable_table;        
                                                                                                        
                                OPEN cursor_variable;         
                                FETCH NEXT FROM cursor_variable INTO @key, @val;         
                                WHILE @@FETCH_STATUS = 0        
                                    BEGIN        
                                                                -- Melakukan Replace terhadap variable di template dengan value dari hasil pencarian data diata.        
                                                                IF ISNULL(@key, '') <> ''        
                                                                BEGIN        
          SET @Template = REPLACE(@Template, @key, @val);        
                                                   END        
        
                                                                FETCH NEXT FROM cursor_variable INTO         
       @key,         
                                           @val;        
                                    END;        
                                        
                                CLOSE cursor_variable;         
                                DEALLOCATE cursor_variable;        
                END        
        
        
    
END    
Return @Template    
    
END
GO
