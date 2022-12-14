USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_send_email_for_group_20200727] -- sp_send_email_for_group 'Ali Mutasal', 'content', 'IMEX'
(
	@subject nvarchar(max) = '',
	@groupname nvarchar(max) = '',
	@content nvarchar(max) = ''
)
AS
BEGIN
	
	DECLARE @to NVARCHAR(MAX);
	 
	DECLARE cursor_group CURSOR
	FOR 
		SELECT AD_User FROM dbo.fn_get_employee_internal_ckb() where [Group] = @groupname;
	 
	OPEN cursor_group;
	 
	FETCH NEXT FROM cursor_group INTO @to;
	 
	WHILE @@FETCH_STATUS = 0
	    BEGIN
	        PRINT @to;
			-- send email to every one in group here
			exec sp_send_email_for_single @subject, @to, @content
	        FETCH NEXT FROM cursor_group INTO @to;
	    END;
	 
	CLOSE cursor_group;
	 
	DEALLOCATE cursor_group;
END

GO
