USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_send_email_notifications] 
AS
BEGIN

	DECLARE @ID AS VARCHAR(100);
	DECLARE @EmailTo AS VARCHAR(MAX);
	DECLARE @EmailSubject AS VARCHAR(500);
	DECLARE @EmailBody AS VARCHAR(MAX);
	DECLARE @MailItemID AS INT;
	DECLARE @result AS INT = -1;

	UPDATE [EmailQueue]
	SET IsSent = 0, [Message] = l.description 
	FROM [EmailQueue] mail
	JOIN msdb.dbo.sysmail_faileditems as items  ON (items.mailitem_id = mail.MailItemID)
	JOIN msdb.dbo.sysmail_event_log AS l ON items.mailitem_id = l.mailitem_id  

	DECLARE mail_cursor CURSOR FOR
	SELECT [ID]
			,[EmailTo]
			,[EmailSubject]
			,[EmailBody]
	FROM [EmailQueue]
	WHERE IsSent = 0

	OPEN mail_cursor  
	FETCH NEXT FROM mail_cursor   
	INTO @ID, @EmailTo, @EmailSubject, @EmailBody

	WHILE @@FETCH_STATUS = 0  																																																																										WHILE @@FETCH_STATUS = 0  
	BEGIN  		
		BEGIN TRY
			-- Send Email
		EXEC @result =  msdb.dbo.sp_send_dbmail 
				@recipients = @EmailTo,
				@subject = @EmailSubject,
				@body = @EmailBody,
				@body_format = 'HTML',
				@profile_name = 'EMCS',
				@mailitem_id = @MailItemID;
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS ErrorMessage;
			UPDATE [EmailQueue] SET [Message] = ERROR_MESSAGE(), MailItemID = NULL WHERE ID = @ID
		END CATCH

		IF @result = 0
		BEGIN
			UPDATE [EmailQueue] SET IsSent = 1, [Message] = 'Success', MailItemID = @MailItemID , SendDate = getDate() WHERE ID = @ID
		END

		FETCH NEXT FROM mail_cursor   
		INTO @ID, @EmailTo, @EmailSubject, @EmailBody
	END
	CLOSE mail_cursor;
	DEALLOCATE mail_cursor; 

END
GO
