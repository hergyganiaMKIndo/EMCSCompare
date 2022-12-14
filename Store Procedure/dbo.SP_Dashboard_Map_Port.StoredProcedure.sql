USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Dashboard_Map_Port] (@user NVARCHAR(50))
AS
BEGIN
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
	--ELSE
	--BEGIN
	--	IF (
	--			@area = ''
	--			OR @area IS NULL
	--			)
	--	BEGIN
	--		SET @and = 'AND RIGHT(C.PickUpArea, 3) = RIGHT(''' + @user + ''',3)';
	--	END
	--	ELSE
	--	BEGIN
	--		SET @and = 'AND RIGHT(C.PickUpArea, 3) = RIGHT(''' + @area + ''',3)';
	--	END
	--END

	SET @sql = 'SELECT C.CiplNo [no]
		,E.Employee_Name employee 
		,CONVERT(nvarchar, HP.latitude) lat
		,CONVERT(nvarchar, HP.longitude) lon
		,HP.[name] provinsi
		,MASP.Name area
		,COUNT(CC.Id) total
	FROM Highchartprovince HP
	INNER JOIN MasterArea MA ON MA.ProvinsiCode = HP.id
	INNER JOIN Cipl C ON RIGHT(C.Area, 3) = RIGHT(MA.BAreaCode, 3)
	INNER JOIN CargoCipl CC ON CC.IdCipl = C.id
	INNER JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo
	INNER JOIN employee E ON E.AD_User = C.CreateBy
	INNER JOIN Cargo CA ON CA.Id = CC.IdCargo
	INNER JOIN MasterAirSeaPort MASP ON MASP.Code = LEFT(CA.PortOfLoading, 5)
	WHERE RCL.IdStep IN (10019,10020,30041,30042,10021,10022)
	AND      RCL.Status IN (''Draft'',''Submit'',''Approve'',''Revise'',''Finish'')
	AND C.CreateBy <>''System''
	AND YEAR(RCL.CreateDate) = YEAR(GETDATE())
	' + @and + '
	GROUP BY 
		C.CiplNo
		,E.Employee_Name
		,MA.BAreaName
		,HP.latitude
		,HP.longitude
		,HP.name
		,C.id
		,MASP.Name
		,HP.latitude
		,HP.longitude
		ORDER BY C.id DESC';

	EXECUTE (@sql);
END
GO
