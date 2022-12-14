USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_send_email_for_single_20200609](
	@subject nvarchar(max),
	@to nvarchar(max),
	@content nvarchar(max)
)
AS
BEGIN
	SET NOCOUNT ON

	-- Send Email to User Here
	DECLARE @Email nvarchar(100) = '';
	
	SELECT @Email = Email 
	FROM dbo.fn_get_employee_internal_ckb() 
	WHERE AD_User = @to;
	
	EXEC msdb.dbo.sp_send_dbmail 
		@recipients = 'fajar.imam14@yahoo.co.id;asmat.awaluddin@trakindo.co.id;ali.mutasal@gmail.com',
		@subject = @subject,
		@body = @content,
		@body_format = 'HTML',
		@profile_name = 'EMCS';

	insert into dbo.Test_Email_Log ([To], Content, [Subject], CreateDate) values (@Email, @Content, @subject, GETDATE());

END
GO
