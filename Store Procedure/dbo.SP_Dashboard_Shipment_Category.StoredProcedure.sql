USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[SP_Dashboard_Shipment_Category] '2019-01-01', '2019-12-12', 'XUPJ21WDN'     
CREATE PROCEDURE [dbo].[SP_Dashboard_Shipment_Category] (
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
		SET @and = 'AND C.PickUpArea IS NOT NULL AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
	END
	ELSE
	BEGIN
		IF (
				@area = ''
				OR @area IS NULL
				)
		BEGIN
			SET @and = 'AND RIGHT(C.PickUpArea, 3) = RIGHT(''' + @user + ''',3) AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
		END
		ELSE
		BEGIN
			SET @and = 'AND RIGHT(C.PickUpArea, 3) = RIGHT(''' + @area + ''',3) AND RCL.CreateDate BETWEEN CONVERT(DATETIME, ''' + @date1 + ''') AND CONVERT(DATETIME, ''' + @date2 + ''')';
		END
	END

	SET @sql = 'SELECT ''PP/UE'' [Desc]
	,(
		SELECT CASE 
				WHEN T1.Name = ''Engine''
					THEN ''Engine''
				WHEN T1.Name = ''Machine''
					THEN ''Machine''
				WHEN T1.Name = ''Forklift''
					THEN ''Forklift''
				ELSE ''Parts''
				END
		) Category
,ISNULL(T2.Total, 0) Total
FROM (
	SELECT MP.Name, MP.[Group]
	FROM MasterParameter MP
	WHERE MP.[Group] IN (
			''CategoryUnit'')
	) T1
LEFT JOIN (
	SELECT A1.CategoriItem, A1.Total * 100/T2.Total Total FROM (SELECT Count(C.CategoriItem) Total, C.CategoriItem
                        FROM cipl C
						INNER JOIN CargoCipl CC ON CC.IdCipl = C.id
                        INNER JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo
						INNER JOIN MasterParameter MP ON MP.Name = C.CategoriItem
                        WHERE MP.[Group] = ''CategoryUnit''
							AND RCL.IdStep IN (
                                10019,10020
                                ,10021
                                ,10022
                                ,10043
                                )
                            AND RCL.STATUS = ''Approve''
							' + @and + '
                            AND C.IsDelete = 0
							GROUP BY C.Category,C.CategoriItem) A1
							LEFT JOIN (

							SELECT Count(C.CategoriItem) Total, C.CategoriItem
                        FROM cipl C
                        LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id
                        LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo
						LEFT JOIN MasterParameter MP ON MP.Name = C.CategoriItem
                        WHERE MP.[Group] = ''CategoryUnit''
							' + @and + '
                            AND C.IsDelete = 0
							GROUP BY C.CategoriItem) T2 ON T2.CategoriItem = A1.CategoriItem
	) AS T2 ON T2.CategoriItem = T1.Name
UNION ALL
SELECT (
		SELECT CASE 
				WHEN T1.Name = ''CATERPILLAR SPAREPARTS''
					THEN ''PARTS''
				WHEN T1.Name = ''MISCELLANEOUS''
					THEN ''MISC''
				END
		)
,(
		SELECT CASE 
				WHEN T1.Name = ''CATERPILLAR SPAREPARTS''
					THEN ''Parts''
				WHEN T1.Name = ''MISCELLANEOUS''
					THEN ''Misc''
				END
		) Category
	,ISNULL(T2.Total, 0) Total
FROM (
	SELECT MP.Name, MP.[Group]
	FROM MasterParameter MP
	WHERE MP.[Name] IN (
			''CATERPILLAR SPAREPARTS'', ''MISCELLANEOUS'')
	) T1
LEFT JOIN (
	SELECT A1.Category, A1.Total * 100/T2.Total Total FROM (SELECT Count(C.Category) Total, C.Category
                        FROM cipl C
						LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id
                        LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo
						LEFT JOIN MasterParameter MP ON MP.Name = C.Category
                        WHERE MP.Name IN (''CATERPILLAR SPAREPARTS'',''MISCELLANEOUS'')
							AND RCL.IdStep IN (
                                10019,10020
                                ,10021
                                ,10022
                                ,10043
                                )
                            AND RCL.STATUS = ''Approve''
							' + @and + '
                            AND C.IsDelete = 0
							GROUP BY C.Category) A1
							LEFT JOIN (

							SELECT Count(C.Category) Total, C.Category
                        FROM cipl C
                        LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id
                        LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo
                        WHERE C.Category IN (''CATERPILLAR SPAREPARTS'',''MISCELLANEOUS'')
						' + @and + '
                            AND C.IsDelete = 0
							GROUP BY C.Category) T2 ON T2.Category = A1.Category
	) AS T2 ON T2.Category = T1.Name';

	EXECUTE (@sql);
END
GO
