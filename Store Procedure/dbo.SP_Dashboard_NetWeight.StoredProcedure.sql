USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[SP_Dashboard_NetWeight] '2020-01-01', '2020-12-12', '0A07'
--EXEC [dbo].[SP_Dashboard_NetWeight] '2020-01-01', '2020-12-12', 'XUPJ21PTR'
--EXEC [dbo].[SP_Dashboard_NetWeight] '2020-01-01', '2020-12-12', ''
CREATE PROCEDURE [dbo].[SP_Dashboard_NetWeight] (
	@date1 NVARCHAR(100)
	,@date2 NVARCHAR(100)
	,@user NVARCHAR(50)
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
		SET @and = 'AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
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

	SET @sql = 'SELECT T1.Name [Category]
		,(
			SELECT CASE 
					WHEN T1.Name = ''CATERPILLAR NEW EQUIPMENT''
						THEN ''CAT NE''
					WHEN T1.Name = ''CATERPILLAR SPAREPARTS''
						THEN ''CAT PARTS''
					WHEN T1.Name = ''CATERPILLAR USED EQUIPMENT''
						THEN ''CAT UE''
					WHEN T1.Name = ''MISCELLANEOUS''
						THEN ''MISC''
					END
			) [Desc]
		, ROUND(ISNULL(T2.Total/1000, 0), 2) AS Total
	FROM (
		SELECT MP.Name
		FROM MasterParameter MP
		WHERE MP.[Group] = ''Category''
		) T1
	LEFT JOIN (
		SELECT Sum(CI.Net) Total, CA.Category
			FROM CargoItem CI
			INNER JOIN RequestCl RCL ON RCL.IdCl = CI.IdCargo
			INNER JOIN Cargo CA ON CI.IdCargo = CA.Id
			INNER JOIN Cipl C ON C.id = CI.IdCipl
			LEFT JOIN MasterParameter MP ON MP.Name = CA.Category
			WHERE MP.[Group] = ''Category''
				AND RCL.IdStep IN ( 10020, 10021, 10022, 10043 )
				AND CI.isDelete = 0 
				AND C.IsDelete = 0
				AND C.CreateBy <>''System''
				' + @and + '
					GROUP BY CA.Category
		) AS T2 ON T2.Category = T1.Name';

	EXECUTE (@sql);
END
GO
