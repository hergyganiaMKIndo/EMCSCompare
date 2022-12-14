USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[SP_Dashboard_Export_Today] '2020-01-01', '2020-12-12', '1A07'
--EXEC [dbo].[SP_Dashboard_Export_Today] '2020-01-01', '2020-12-12', 'XUPJ21PTR'
--EXEC [dbo].[SP_Dashboard_Export_Today] '2020-01-01', '2020-12-12', 'XUPJ21WDN'
--EXEC [dbo].[SP_Dashboard_Export_Today] '2020-01-01', '2020-12-12', 'ict.bpm'
CREATE PROCEDURE [dbo].[SP_Dashboard_Export_Today] (
	@date1 NVARCHAR(100)
	,@date2 NVARCHAR(100)
	,@user NVARCHAR(10)
	)
AS
BEGIN





	DECLARE @sql NVARCHAR(max);
	DECLARE @and NVARCHAR(max);
	DECLARE @area NVARCHAR(max);
	DECLARE @role NVARCHAR(max);

	SELECT @area = U.Business_Area
		,@role = U.[Role]
	FROM dbo.fn_get_employee_internal_ckb() U
	WHERE U.AD_User = @user;

	IF (
			@role = 'EMCS Warehouse'
			OR @role = 'EMCS IMEX'
			OR @role = 'EMCS PPJK'
			)
	BEGIN
		SET @and = 'AND CI.PickUpArea IS NOT NULL AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
	END
	ELSE
	BEGIN
		IF (
				@area = ''
				OR @area IS NULL
				)
		BEGIN
			SET @and = 'AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
		END
		ELSE
		BEGIN
			SET @and = 'AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
		END
	END

	--IF (@area = '' OR @area IS NULL)
	--BEGIN
	--	IF (@user = '' OR @user IS NULL)
	--	BEGIN
	--		SET @and = 'AND CI.PickUpArea IS NOT NULL AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
	--	END
	--	ELSE
	--	BEGIN
	--		SET @and = 'AND RIGHT(CI.PickUpArea, 3) = RIGHT(''' + @user + ''',3) AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
	--	END 
	--END
	--ELSE
	--BEGIN
	--	SET @and = 'AND RIGHT(CI.PickUpArea, 3) = RIGHT(''' + @area + ''',3) AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
	--END
	SET @sql = 
		'SELECT T1.Name [Desc]
		,(
			SELECT CASE 
					WHEN T1.Name = ''Non Sales - Repair Return (Temporary)''
						THEN ''NS-RR''
					WHEN T1.Name = ''Non Sales - Return (Permanent)''
						THEN ''NS-R''
					WHEN T1.Name = ''Non Sales - Personal Effect (Permanent)''
						THEN ''NS-PE''
					WHEN T1.Name = ''Non Sales - Exhibition (Temporary)''
						THEN ''NS-E''
					ELSE ''Sales''
					END
			) Category
		,ISNULL(T2.Total, 0) Total
	FROM (
		SELECT MP.Name
		FROM MasterParameter MP
		WHERE MP.[Group] = ''ExportType''
		) T1
	LEFT JOIN (
		SELECT Count(C.ExportType) Total
			,C.ExportType
		FROM MasterParameter MP
		LEFT JOIN Cargo C ON C.ExportType = MP.Name
		LEFT JOIN RequestCl RCL ON RCL.IdCl = C.Id
		LEFT JOIN CargoCipl CC ON CC.IdCargo = C.Id
		LEFT JOIN Cipl CI ON CI.id = CC.IdCipl 
		LEFT JOIN NpePeb N on C.Id = N.IdCl
		WHERE MP.[Group] = ''ExportType'' AND CI.CreateBy <>''System''
			AND RCL.IdStep IN (
				10019
				,10020
				,10021
				,10022
				,10043
				,30042
				)
			AND RCL.Status IN (''Draft'',''Submit'',''Revise'',''Approve'')
			' 
		+ @and + '
			AND C.IsDelete = 0
			AND N.NpeNumber is not null
		GROUP BY C.ExportType
			,MP.Name
		) AS T2 ON T2.ExportType = T1.Name'

	EXECUTE (@sql);
END
GO
