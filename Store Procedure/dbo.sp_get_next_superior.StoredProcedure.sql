USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sp_get_next_superior 'xupj21ikx'
CREATE PROCEDURE [dbo].[sp_get_next_superior] (
	@username nvarchar(100) = ''
)
AS
BEGIN
	DECLARE @counter INT = 1;
	DECLARE @next_superior nvarchar(100) = @username;
	DECLARE @result_data nvarchar(100) = '';
	
	--DROP TABLE #testing;
	--SELECT '' AD_user, '' Employee_Name INTO #testing
	--TRUNCATE TABLE #testing;
	
	WHILE @counter <= 3
	BEGIN
		DECLARE @employee_id nvarchar(100) = '';
		DECLARE @employee_name nvarchar(100) = '';
	
		SELECT @employee_id = Superior_ID FROM MDS.HC.employee WHERE AD_User = @next_superior;
		SELECT @next_superior = AD_User, @employee_name = Employee_Name FROM MDS.HC.employee WHERE Employee_ID = @employee_id;
		--SELECT @next_superior AD_User, @employee_name Employee_Name into #testing
		--SET @result_data += @employee_id + '-' +@employee_name +'+';
		SET @result_data += @employee_id+'+';
		IF ISNULL(@employee_id, '') = ''
		BEGIN
			BREAK;
		END

	    SET @counter = @counter + 1;
		--print @employee_id + ' - '+ @employee_name;
		--print @next_superior;
	END

	SELECT t0.splitdata EmployeeId, t1.AD_User AdUser, t1.Employee_Name EmployeeName 
	FROM dbo.fnSplitString(LTRIM(RTRIM(@result_data)), '+') t0
	INNER JOIN dbo.fn_get_employee_internal_ckb() t1 on t1.Employee_ID = t0.splitdata;
	--print @result_data;
	--SELECT * FROM #testing;
	--DROP TABLE #testing;
END
GO
