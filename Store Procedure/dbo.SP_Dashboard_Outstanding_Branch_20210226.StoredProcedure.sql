USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[SP_Dashboard_Outstanding_Branch] 1, 5, '0A07'
CREATE PROCEDURE [dbo].[SP_Dashboard_Outstanding_Branch_20210226] (
	@Page NVARCHAR(10)
	,@Row NVARCHAR(10)
	,@user NVARCHAR(50)
	)
AS
BEGIN
	DECLARE @RowspPage AS NVARCHAR(10)
	DECLARE @sql NVARCHAR(max);
	DECLARE @and NVARCHAR(max);
	DECLARE @area NVARCHAR(max);
	DECLARE @role NVARCHAR(max);

	SELECT @area = U.Business_Area
		,@role = U.[Role]
	FROM dbo.fn_get_employee_internal_ckb() U
	WHERE U.AD_User = @user;;

	IF (
			@role = 'EMCS Warehouse'
			OR @role = 'EMCS IMEX'
			OR @role = 'EMCS PPJK'
			)
	BEGIN
		SET @and = 'AND C.PickUpArea IS NOT NULL';
	END
	ELSE
	BEGIN
		IF (
				@area = ''
				OR @area IS NULL
				)
		BEGIN
			SET @and = 'AND RIGHT(C.PickUpArea, 3) = RIGHT(''' + @user + ''',3)';
		END
		ELSE
		BEGIN
			SET @and = 'AND RIGHT(C.PickUpArea, 3) = RIGHT(''' + @area + ''',3)';
		END
	END

	SET @RowspPage = @Row

	SET @sql = 'SELECT C.CiplNo AS No
		,(
			SELECT tab0.PlantName
			FROM fn_get_cipl_businessarea_list(C.Area) AS tab0
			WHERE tab0.PlantCode = C.Area
			) Branch
		,CO.PortOfLoading
		,CO.PortOfDestination
		,CO.SailingSchedule ETD
		,CO.ArrivalDestination ETA
		,FS.ViewByUser
	FROM CIPL C
	INNER JOIN CargoCipl CC ON C.id = CC.IdCipl
	INNER JOIN Cargo CO ON CC.IdCargo = CO.Id
	INNER JOIN RequestCl RCL ON CC.IdCargo = RCL.IdCl
	INNER JOIN FlowStatus FS ON RCL.IdStep = FS.IdStep
		AND RCL.STATUS = FS.STATUS
	WHERE RCL.IdStep IN (
			12
			,10017
			,20033
			,10032
			)
		AND RCL.STATUS IN (
			''Draft''
			,''Submit''
			,''Approve''
			,''Revise''
			)
		AND YEAR(RCL.CreateDate) = YEAR(GETDATE())
		' + @and + '
	ORDER BY C.id OFFSET(('+@Page+' - 1) * '+@RowspPage+') ROWS

	FETCH NEXT '+@RowspPage+' ROWS ONLY';
	EXECUTE (@sql);
END
GO
