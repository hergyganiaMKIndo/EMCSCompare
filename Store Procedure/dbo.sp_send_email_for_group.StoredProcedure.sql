USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_send_email_for_group] -- sp_send_email_for_group 'Ali Mutasal', 'content', 'IMEX'
(
	@subject nvarchar(max) = '',
	@groupname nvarchar(max) = '',
	@content nvarchar(max) = ''
)
AS
BEGIN
	DECLARE @to NVARCHAR(MAX);
	DECLARE @EmailTos nvarchar(max);
	SELECT @EmailTos = cast(stuff((
		SELECT ';' + convert(nvarchar(max), '' + cast(d.Email as nvarchar(255))+'') 
		from (
			SELECT DISTINCT Email from fn_get_employee_internal_ckb() d where d.[Group] = @groupname 					
		) d
	for xml path('')), 1, 1, '') as nvarchar(max))

	IF (@EmailTos <> '') 
	BEGIN
		exec dbo.sp_send_email_for_single @subject, '', @content, @EmailTos
	END	 
END

GO
