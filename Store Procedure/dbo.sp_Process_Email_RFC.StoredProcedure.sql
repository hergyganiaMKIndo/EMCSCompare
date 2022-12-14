USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[sp_Process_Email_RFC]  --exec      [sp_Process_Email_RFC]  '281','Approval'  
@RFCId int,        
@Doctype nvarchar(200)        
AS        
BEGIN        
  DECLARE @Email nvarchar(200)        
  DECLARE @Subject nvarchar(max)        
  DECLARE @Template nvarchar(max)        
  DECLARE @NextApproverEmail nvarchar(max)        
  DECLARE @ApproverUser nvarchar(max)        
  DECLARE @RequestorUser nvarchar(max)        
  DECLARE @FormType nvarchar(max)        
  DECLARE @FormId int        
  DECLARE @CreatorEmail nvarchar(max)        
  DECLARE @CCReceipent nvarchar(max)        
  DECLARE @MailTo nvarchar(max)        
  DECLARE @ProfileName nvarchar(max) = 'EMCS'        
  SELECT        
    @FormType = RFC.FormType,        
    @FormId = CONVERT(int, RFC.FormId),        
    @RequestorUser = (SELECT Email FROM dbo.fn_get_employee_internal_ckb() WHERE AD_User = RFC.CreateBy),        
    @ApproverUser = (SELECT Email FROM dbo.fn_get_employee_internal_ckb() WHERE AD_User = RFC.Approver)        
  FROM RequestForChange RFC        
  WHERE ID = @RFCId        
        
  SET @NextApproverEmail =        
                          CASE        
                            WHEN (@ApproverUser = 'xupj21dxd') THEN (SELECT        
                                Email        
                              FROM dbo.fn_get_employee_internal_ckb()        
                              WHERE AD_User = 'xupj21fig')        
                            WHEN (@ApproverUser = 'xupj21fig') THEN (SELECT        
                                Email        
                              FROM dbo.fn_get_employee_internal_ckb()        
                              WHERE AD_User = 'xupj21dxd')        
                            ELSE (SELECT        
                                Email        
                              FROM dbo.fn_get_employee_internal_ckb()        
                              WHERE AD_User = 'xupj21dxd')        
                          END;        
        
  SET @CreatorEmail =        
                     CASE        
                       WHEN @FormType = 'CIPL' THEN (SELECT        
                           Email        
                         FROM dbo.fn_get_employee_internal_ckb()        
                         WHERE AD_User = (SELECT TOP 1        
                           CreateBy        
                         FROM Cipl        
                         WHERE id = @FormId))        
                       WHEN @FormType = 'Cargo' THEN (SELECT        
                           Email        
                         FROM dbo.fn_get_employee_internal_ckb()        
                         WHERE AD_User = (SELECT TOP 1        
                           CreateBy        
                         FROM Cargo        
                         WHERE id = @FormId))        
      WHEN @FormType = 'GoodsReceive' THEN (SELECT        
                           Email        
                         FROM dbo.fn_get_employee_internal_ckb()        
                         WHERE AD_User = (SELECT TOP 1        
                           CreateBy        
                         FROM GoodsReceive        
                         WHERE id = @FormId))     
                       WHEN @FormType = 'ShippingInstruction' THEN (SELECT        
                           Email        
                         FROM dbo.fn_get_employee_internal_ckb()        
                         WHERE AD_User = (SELECT TOP 1        
                           CreateBy        
                         FROM ShippingInstruction        
                         WHERE IdCL = @FormId))        
                       WHEN @FormType = 'BlAwb' THEN (SELECT        
                           Email        
                         FROM dbo.fn_get_employee_internal_ckb()        
                         WHERE AD_User = (SELECT TOP 1        
                           CreateBy        
                         FROM BlAwb        
                         WHERE IdCl = @FormId))        
                       ELSE (SELECT     
                           Email        
                         FROM dbo.fn_get_employee_internal_ckb()        
                         WHERE AD_User = (SELECT TOP 1        
                           CreateBy        
                         FROM NpePeb        
                         WHERE IdCl = @FormId))        
                     END        
        
  SET @CCReceipent = @CreatorEmail + ';' + @NextApproverEmail  + ';' + 'projectsupport@mkindo.com' 
        
  IF (@Doctype = 'Approval')        
  BEGIN        
    SELECT        
      @Subject = [Subject],        
      @Template = [Message]        
    FROM EmailTemplate        
    WHERE [Module] = 'RFC'        
    AND [Status] = 'Approval'        
    AND RecipientType = 'Requestor'        
        
    SET @Subject = dbo.[fn_proccess_email_template_RFC](@RFCId, @Subject)        
    SET @Template = dbo.[fn_proccess_email_template_RFC](@RFCId, @Template)        
    SET @MailTo = @RequestorUser       
        
BEGIN        
    EXEC msdb.dbo.sp_send_dbmail @recipients = @MailTo,        
                                 @copy_recipients = @CCReceipent,        
                                 @subject = @subject,        
                           @body = @Template,        
                                 @body_format = 'HTML',        
                                 @profile_name = @ProfileName;        
        
    INSERT INTO dbo.Test_Email_Log ([To], Content, [Subject], CreateDate)        
      VALUES (@Email, @Template, @subject, GETDATE());        
  END        
        
    SELECT        
      @Subject = [Subject],        
      @Template = [Message]        
    FROM EmailTemplate        
    WHERE [Module] = 'RFC'        
    AND [Status] = 'Approval'        
    AND RecipientType = 'Approver'        
        
    SET @Subject = dbo.[fn_proccess_email_template_RFC](@RFCId, @Subject)        
    SET @Template = dbo.[fn_proccess_email_template_RFC](@RFCId, @Template)        
    SET @MailTo = @ApproverUser        
        
  BEGIN        
    EXEC msdb.dbo.sp_send_dbmail @recipients = @MailTo,        
                                 @copy_recipients = @CCReceipent,        
                                 @subject = @subject,        
                                 @body = @Template,        
                                 @body_format = 'HTML',        
                                 @profile_name = @ProfileName;        
        
    INSERT INTO dbo.Test_Email_Log ([To], Content, [Subject], CreateDate)        
      VALUES (@Email, @Template, @subject, GETDATE());        
  END        
        
  END        
  ELSE        
  IF (@Doctype = 'Approved')        
  BEGIN        
    SELECT        
      @Subject = [Subject],        
      @Template = [Message]        
    FROM EmailTemplate        
    WHERE [Module] = 'RFC'        
    AND [Status] = 'Approved'        
    AND RecipientType = 'Requestor'        
        
    SET @Subject = dbo.[fn_proccess_email_template_RFC](@RFCId, @Subject)        
    SET @Template = dbo.[fn_proccess_email_template_RFC](@RFCId, @Template)        
    SET @MailTo = @RequestorUser        
  BEGIN        
    EXEC msdb.dbo.sp_send_dbmail @recipients = @MailTo,        
                                 @copy_recipients = @CCReceipent,        
                                 @subject = @subject,        
                                 @body = @Template,        
                                 @body_format = 'HTML',        
                                 @profile_name = @ProfileName;        
        
    INSERT INTO dbo.Test_Email_Log ([To], Content, [Subject], CreateDate)        
      VALUES (@Email, @Template, @subject, GETDATE());        
  END        
        
        
    SELECT        
      @Subject = [Subject],        
      @Template = [Message]        
    FROM EmailTemplate        
    WHERE [Module] = 'RFC'        
    AND [Status] = 'Approved'        
    AND RecipientType = 'Approver'        
        
    SET @Subject = dbo.[fn_proccess_email_template_RFC](@RFCId, @Subject)        
    SET @Template = dbo.[fn_proccess_email_template_RFC](@RFCId, @Template)        
    SET @MailTo = @ApproverUser        
        
  BEGIN        
    EXEC msdb.dbo.sp_send_dbmail @recipients = @MailTo,        
                                 @copy_recipients = @CCReceipent,        
                                 @subject = @subject,        
                                 @body = @Template,        
                                 @body_format = 'HTML',        
                                 @profile_name = @ProfileName;        
        
    INSERT INTO dbo.Test_Email_Log ([To], Content, [Subject], CreateDate)        
      VALUES (@Email, @Template, @subject, GETDATE());        
  END        
        
  END        
  ELSE        
  BEGIN        
    SELECT        
      @Subject = [Subject],        
      @Template = [Message]        
    FROM EmailTemplate        
    WHERE [Module] = 'RFC'        
    AND [Status] = 'Reject'        
    AND RecipientType = 'Requestor'        
        
    SET @Subject = dbo.[fn_proccess_email_template_RFC](@RFCId, @Subject)        
    SET @Template = dbo.[fn_proccess_email_template_RFC](@RFCId, @Template)        
    SET @MailTo = @RequestorUser        
        
  BEGIN        
    EXEC msdb.dbo.sp_send_dbmail @recipients = @MailTo,        
                                 @copy_recipients = @CCReceipent,        
                                 @subject = @subject,       
                                 @body = @Template,        
                                 @body_format = 'HTML',        
                                 @profile_name = @ProfileName;        
        
    INSERT INTO dbo.Test_Email_Log ([To], Content, [Subject], CreateDate)        
      VALUES (@Email, @Template, @subject, GETDATE());        
  END        
        
        
    SELECT        
      @Subject = [Subject],        
      @Template = [Message]        
    FROM EmailTemplate        
    WHERE [Module] = 'RFC'        
    AND [Status] = 'Reject'        
    AND RecipientType = 'Approver'        
        
    SET @Subject = dbo.[fn_proccess_email_template_RFC](@RFCId, @Subject)        
    SET @Template = dbo.[fn_proccess_email_template_RFC](@RFCId, @Template)        
    SET @MailTo = @ApproverUser        
        
  BEGIN        
    EXEC msdb.dbo.sp_send_dbmail @recipients = @MailTo,        
                                 @copy_recipients = @CCReceipent,        
                                 @subject = @subject,        
                                 @body = @Template,        
                                 @body_format = 'HTML',        
                                 @profile_name = @ProfileName;        
        
    INSERT INTO dbo.Test_Email_Log ([To], Content, [Subject], CreateDate)        
      VALUES (@Email, @Template, @subject, GETDATE());        
  END        
        
  END        
        
        
        
END
GO
