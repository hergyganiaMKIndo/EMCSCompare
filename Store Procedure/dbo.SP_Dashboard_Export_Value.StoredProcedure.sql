USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[SP_Dashboard_Export_Value] '2020-01-01', '2020-12-12', '0A07'
--EXEC [dbo].[SP_Dashboard_Export_Value] '2020-01-01', '2020-12-12', 'XUPJ21PTR'
--EXEC [dbo].[SP_Dashboard_Export_Value] '2020-01-01', '2020-12-12', ''
CREATE PROCEDURE [dbo].[SP_Dashboard_Export_Value] (
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
		SET @and = 'AND CC.PickUpArea IS NOT NULL AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
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

	SET @sql = 'SELECT ''ExportType'' Category
		,MP.Name [Desc]
		,ISNULL((
				SELECT SUM(CI.ExtendedValue)
				FROM CiplItem CI
				INNER JOIN Cipl CC ON CC.id = CI.IdCipl
				INNER JOIN CargoItem CAI ON CI.Id = CAI.IdCiplItem
				INNER JOIN Cargo C ON CAI.IdCargo = C.Id
				INNER JOIN RequestCl RCL ON CAI.IdCargo = RCL.IdCl
				WHERE RCL.IdStep IN (
						10020
						,10021
						,10022
						,10043
						)
					AND C.ExportType = ''Non Sales - Repair Return (Temporary)''
					AND CAI.IsDelete = 0
					AND CI.IsDelete = 0
					' + @and + 
		'
				), 0) Total
	FROM RequestCl RCL
	INNER JOIN Cargo C ON RCL.IdCl = C.Id
	RIGHT JOIN MasterParameter MP ON C.ExportType = MP.Name
	WHERE MP.[Group] = ''ExportType''
		AND MP.Name = ''Non Sales - Repair Return (Temporary)''
	GROUP BY MP.Name
	
	UNION ALL
	
	SELECT ''ExportType'' Category
		,MP.Name [Desc]
		,ISNULL((
				SELECT SUM(CI.ExtendedValue)
				FROM CiplItem CI
				INNER JOIN Cipl CC ON CC.id = CI.IdCipl
				INNER JOIN CargoItem CAI ON CI.Id = CAI.IdCiplItem
				INNER JOIN Cargo C ON CAI.IdCargo = C.Id
				INNER JOIN RequestCl RCL ON CAI.IdCargo = RCL.IdCl
				WHERE RCL.IdStep IN (
						10020
						,10021
						,10022
						,10043
						)
					AND C.ExportType = ''Non Sales - Return (Permanent)''
					AND CAI.IsDelete = 0
					AND CI.IsDelete = 0
					' + @and + 
		'
				), 0) Total
	FROM RequestCl RCL
	INNER JOIN Cargo C ON RCL.IdCl = C.Id
	RIGHT JOIN NpePeb N ON C.Id = N.IdCl AND NpeNumber not in ('''',''-'') 
	RIGHT JOIN MasterParameter MP ON C.ExportType = MP.Name
	WHERE MP.[Group] = ''ExportType''
		AND MP.Name = ''Non Sales - Return (Permanent)''
		
	GROUP BY MP.Name
	
	UNION ALL
	
	SELECT ''ExportType'' Category
		,MP.Name [Desc]
		,ISNULL((
				SELECT SUM(CI.ExtendedValue)
				FROM CiplItem CI
				INNER JOIN Cipl CC ON CC.id = CI.IdCipl
				INNER JOIN CargoItem CAI ON CI.Id = CAI.IdCiplItem
				INNER JOIN Cargo C ON CAI.IdCargo = C.Id
				INNER JOIN RequestCl RCL ON CAI.IdCargo = RCL.IdCl
				WHERE RCL.IdStep IN (
						10020
						,10021
						,10022
						,10043
						)
					AND C.ExportType = ''Non Sales - Personal Effect (Permanent)''
					AND CAI.IsDelete = 0
					AND CI.IsDelete = 0
					' + @and + 
		'
				), 0) Total
	FROM RequestCl RCL
	INNER JOIN Cargo C ON RCL.IdCl = C.Id
	RIGHT JOIN MasterParameter MP ON C.ExportType = MP.Name
	WHERE MP.[Group] = ''ExportType''
		AND MP.Name = ''Non Sales - Personal Effect (Permanent)''
	GROUP BY MP.Name
	
	UNION ALL
	
	SELECT ''ExportType'' Category
		,MP.Name [Desc]
		,ISNULL((
				SELECT SUM(CI.ExtendedValue)
				FROM CiplItem CI
				INNER JOIN Cipl CC ON CC.id = CI.IdCipl
				INNER JOIN CargoItem CAI ON CI.Id = CAI.IdCiplItem
				INNER JOIN Cargo C ON CAI.IdCargo = C.Id
				INNER JOIN RequestCl RCL ON CAI.IdCargo = RCL.IdCl
				WHERE RCL.IdStep IN (
						10020
						,10021
						,10022
						,10043
						)
					AND C.ExportType = ''Non Sales - Exhibition (Temporary)''
					AND CAI.IsDelete = 0
					AND CI.IsDelete = 0
					' + @and + 
		'
				), 0) Total
	FROM RequestCl RCL
	INNER JOIN Cargo C ON RCL.IdCl = C.Id
	RIGHT JOIN MasterParameter MP ON C.ExportType = MP.Name
	WHERE MP.[Group] = ''ExportType''
		AND MP.Name = ''Non Sales - Exhibition (Temporary)''
	GROUP BY MP.Name
	
	UNION ALL
	
	SELECT ''ExportType'' Category
		,MP.Name [Desc]
		,ISNULL((
				SELECT SUM(CI.ExtendedValue)
				FROM CiplItem CI
				INNER JOIN Cipl CC ON CC.id = CI.IdCipl
				INNER JOIN CargoItem CAI ON CI.Id = CAI.IdCiplItem
				INNER JOIN Cargo C ON CAI.IdCargo = C.Id
				INNER JOIN RequestCl RCL ON CAI.IdCargo = RCL.IdCl
				WHERE RCL.IdStep IN (
						10020
						,10021
						,10022
						,10043
						)
					AND C.ExportType = ''Sales (Permanent)''
					AND CAI.IsDelete = 0
					AND CI.IsDelete = 0
					' + @and + '
				), 0) Total
	FROM RequestCl RCL
	INNER JOIN Cargo C ON RCL.IdCl = C.Id
	RIGHT JOIN MasterParameter MP ON C.ExportType = MP.Name
	WHERE MP.[Group] = ''ExportType''
		AND MP.Name = ''Sales (Permanent)''
	GROUP BY MP.Name'
		;

	EXECUTE (@sql);
END
GO
