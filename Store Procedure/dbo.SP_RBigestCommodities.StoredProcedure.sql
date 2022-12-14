USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SELECT * FROM Cipl
--EXEC [dbo].[SP_RBigestCommodities] '2020', 'Sales'
--EXEC [dbo].[SP_RBigestCommodities] '2020', 'Non Sales'
CREATE PROCEDURE [dbo].[SP_RBigestCommodities] (@date1        nvarchar(50),
                                               @ExportType   nvarchar(100)) 
AS 
  BEGIN
	DECLARE @sql NVARCHAR(max);
	DECLARE @and NVARCHAR(max);

	IF(@ExportType IS NULL OR @ExportType = '')
	BEGIN
		SET @and = 'AND C.ExportType IS NOT NULL';
	END
	ELSE 
	BEGIN
		SET @and = 'AND C.ExportType LIKE '''+@ExportType+'%'' ';
	END

	SET @sql = 'SELECT ''PP/UE'' Category
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
		) [Desc]
	, ISNULL(T2.TotalSales, 0) [TotalSales]
	, ISNULL(T2.TotalNonSales, 0) [TotalNonSales]
,ISNULL(T2.Total, 0) Total
FROM (
	SELECT MP.Name, MP.[Group]
	FROM MasterParameter MP
	WHERE MP.[Group] IN (
			''CategoryUnit'')
	) T1
LEFT JOIN (
	SELECT	T3.CategoriItem, SUM(T3.TotalSales) [TotalSales], SUM(T3.TotalNonSales) [TotalNonSales], SUM(T3.Total) [Total]
						FROM (	SELECT DISTINCT A1.CategoriItem, A1.TotalSales * 100/T2.Total [TotalSales], A1.TotalNonSales * 100/T2.Total [TotalNonSales], A1.Total * 100/T2.Total [Total]
							FROM (	SELECT	C.CategoriItem, 
											CASE WHEN C.ExportType LIKE ''Sales%'' THEN Count(C.ExportType) ELSE 0 END [TotalSales],
											CASE WHEN C.ExportType LIKE ''Non Sales%'' THEN Count(C.ExportType) ELSE 0 END [TotalNonSales],
											COUNT(C.CategoriItem) [Total]
									FROM	cipl C  
											INNER JOIN CargoCipl CC ON CC.IdCipl = C.id  
											INNER JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo  
											INNER JOIN MasterParameter MP ON MP.Name = C.CategoriItem  
									WHERE	MP.[Group] = ''CategoryUnit''  
											AND RCL.IdStep IN ( 10019
																,10020  
																,10021  
																,10022  
																,10043)  
											AND RCL.STATUS = ''Approve'' 
											' + @and + '   
											AND C.IsDelete = 0  
									GROUP BY C.ExportType, C.Category, C.CategoriItem) A1  
									LEFT JOIN (	SELECT	Count(C.CategoriItem) Total, C.CategoriItem  
												FROM	cipl C  
														LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id  
														LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo  
														LEFT JOIN MasterParameter MP ON MP.Name = C.CategoriItem  
												WHERE MP.[Group] = ''CategoryUnit'' 
												' + @and + '   
												AND C.IsDelete = 0  
												GROUP BY C.CategoriItem) T2 ON T2.CategoriItem = A1.CategoriItem ) AS T3
					GROUP BY CategoriItem) AS T2 ON T2.CategoriItem = T1.Name
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
	, ISNULL(T2.TotalSales, 0) [TotalSales]
	, ISNULL(T2.TotalNonSales, 0) [TotalNonSales]
	, ISNULL(T2.Total, 0) [Total] 
FROM	(SELECT	MP.Name, MP.[Group]  
		 FROM	MasterParameter MP  
		 WHERE	MP.[Name] IN (''CATERPILLAR SPAREPARTS'', ''MISCELLANEOUS'')) T1  
		LEFT JOIN ( SELECT	T3.Category, SUM(T3.TotalSales) [TotalSales], SUM(T3.TotalNonSales) [TotalNonSales], SUM(T3.Total) [Total]
					FROM	(	SELECT DISTINCT A1.Category, A1.TotalSales * 100/T2.Total [TotalSales], A1.TotalNonSales * 100/T2.Total [TotalNonSales], A1.Total * 100/T2.Total [Total]
								FROM (	SELECT  DISTINCT C.Category, 
												CASE WHEN C.ExportType LIKE ''Sales%'' THEN Count(C.ExportType) ELSE 0 END [TotalSales],
												CASE WHEN C.ExportType LIKE ''Non Sales%'' THEN Count(C.ExportType) ELSE 0 END [TotalNonSales],
												COUNT(C.Category) [Total]
										FROM	cipl C  
												LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id  
												LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo  
												LEFT JOIN MasterParameter MP ON MP.Name = C.Category  
										WHERE	MP.Name IN (''CATERPILLAR SPAREPARTS'',''MISCELLANEOUS'')  
												AND RCL.IdStep IN (  10019
																	,10020  
																	,10021  
																	,10022  
																	,10043)  
												AND RCL.STATUS = ''Approve''
												' + @and + '   
												AND C.IsDelete = 0  
										GROUP BY C.Category, C.ExportType) A1  
										LEFT JOIN (	SELECT Count(C.Category) Total, C.Category  
													FROM cipl C  
														LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id  
														LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo  
													WHERE C.Category IN (''CATERPILLAR SPAREPARTS'',''MISCELLANEOUS'') 
													' + @and + '   
														AND C.IsDelete = 0  
													GROUP BY C.Category) T2 ON T2.Category = A1.Category ) AS T3
						GROUP BY Category) AS T2 ON T2.Category = T1.Name
 ORDER BY [Desc], TotalSales, TotalNonSales DESC';
	EXECUTE (@sql);
END
--USE [EMCS]
--GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[SP_RBigestCommodities] (@date1        datetime, 
--                                               @date2        datetime, 
--                                               @CategoryItem nvarchar(50), 
--                                               @ExportType   nvarchar(100)) 
--AS 
--  BEGIN 
--      SET NOCOUNT ON; 

--      DECLARE @SQL nvarchar(max); 

--      IF( @CategoryItem = 'Parts' ) 
--        BEGIN 
--            SET @SQL = 
--            '''PRA'' OR C.CategoryItem = ''Old Core'' OR C.Categori = ''SIB'''; 
--        END 
--      ELSE IF( @CategoryItem = 'Engine' ) 
--        BEGIN 
--            SET @SQL = 'Engine'; 
--        END 
--      ELSE IF( @CategoryItem = 'Forklift' ) 
--        BEGIN 
--            SET @SQL = 'Forklift'; 
--        END 
--      ELSE IF( @CategoryItem = 'Mesin' ) 
--        BEGIN 
--            SET @SQL = 'Mesin'; 
--        END 
--      ELSE 
--        BEGIN 
--            SET @SQL = '' + @CategoryItem + ' '; 
--        END 

--      SELECT MP.[Group] 
--             Category, 
--             MP.Name 
--             [DESC] 
--             , 
--             ISNULL(Cast(NULLIF((SELECT Count(C.CategoriItem) 
--                                 FROM   cipl C 
--                                        INNER JOIN CargoItem CI 
--                                                ON C.id = CI.IdCipl 
--                                        INNER JOIN RequestCl RCL 
--                                                ON CI.IdCargo = RCL.Id 
--                                 WHERE  C.CategoriItem = @SQL 
--                                        AND C.ExportType LIKE '' + @ExportType + 
--                                                              '%' 
--                                        AND C.CreateDate BETWEEN 
--                                            CONVERT(datetime, @date1) 
--                                            AND 
--                                            CONVERT(datetime, @date2) 
--                                        AND RCL.IdStep IN ( 10020, 10021, 10022, 
--                                                            10043 
--                                                          ) 
--                                        AND RCL.Status = 'Approve' 
--                                        AND C.IsDelete = 0), 0) * 100 / NULLIF( 
--                                     (SELECT Count(C.CategoriItem) 
--                                      FROM   cipl C 
--                                                                        INNER 
--                                             JOIN 
--                                             CargoItem CI 
--                                                     ON 
--                                             C.id = CI.IdCipl 
--                                             INNER JOIN 
--                                             RequestCl RCL 
--                                                     ON CI.IdCargo 
--                                                        = 
--                                                        RCL.Id 
--                                                     WHERE 
--                                             C.CategoriItem = 
--                                             @CategoryItem 
--                                             AND 
--                                     C.ExportType 
--                                     LIKE '' + @ExportType 
--                                          + 
--                                          '%' 
--                                             AND 
--  C.CreateDate 
--  BETWEEN 
--  CONVERT(datetime, @date1) AND 
--  CONVERT(datetime, @date2) 
--  AND C.IsDelete = 0), 0) AS int), 0) TOTAL 
--  FROM   MasterParameter MP 
--  WHERE  MP.Name = @CategoryItem 
--  END 
GO
