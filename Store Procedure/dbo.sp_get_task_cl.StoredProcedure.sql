USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_task_cl] -- [dbo].[sp_get_task_cl] 'CKB1'
(
	@Username nvarchar(100),
	@isTotal bit = 0,
	@sort nvarchar(100) = 'Id',
	@order nvarchar(100) = 'ASC',
	@offset nvarchar(100) = '0',
	@limit nvarchar(100) = '10'
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql nvarchar(max);  --select * from dbo.vw_container
	DECLARE @GroupId nvarchar(100);
	DECLARE @PicNpe nvarchar(100);
	DECLARE @UserType nvarchar(100);
	DECLARE @UserGroupNameExternal nvarchar(100) = '';

	SELECT @UserType = UserType, @UserGroupNameExternal = Cust_Group_No from PartsInformationSystem.dbo.UserAccess where UserID = @Username;

	if @UserType <> 'internal' 
	BEGIN
		SET @GroupId = 'CKB';
		SET @PicNpe = 'CKB';
	END
	ELSE
	BEGIN
		select @GroupId = Organization_Name from employee where Employee_Status = 'Active' AND AD_User = @Username;
		IF @GroupId = 'Import Export Operation' OR @GroupId = 'Import Export' OR @GroupId = 'Import Export Operation Mgmt.'
		BEGIN
			SET @GroupId = 'Import Export';
		END
		SET @PicNpe = 'IMEX';
	END

    SET @sql = CASE 
			   WHEN @isTotal = 1 
					THEN 'SELECT COUNT(*) as total' 
			   ELSE 'select tab0.* '
			   END + ' FROM fn_get_cl_request_list('''+@Username+''', '''+ISNULL(@GroupId, 0)+''', '''+@PicNpe+''') as tab0 WHERE IdNextStep IN (11, 12) AND Status IN(''Submit'', ''Revise'')' +
			   CASE 
					WHEN @isTotal = 0 
					THEN ' ORDER BY '+@sort+' '+@order+' OFFSET '+@offset+' ROWS FETCH NEXT '+@limit+' ROWS ONLY' ELSE '' END;

	--select @sql;
	EXECUTE(@sql);
END

GO
