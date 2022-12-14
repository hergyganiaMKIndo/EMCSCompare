USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Dashboard_Outstanding_Branch] (
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
		,Isnull((SELECT top 1  CA.PortOfLoading FROM CargoCipl CC 
		LEFT JOIN Cargo CA ON CA.Id = CC.IdCargo WHERE CC.IdCipl = C.id and  CA.PortOfLoading is not null ),c.LoadingPort) PortOfLoading
		,Isnull((SELECT top 1  CA.PortOfDestination FROM CargoCipl CC 
		LEFT JOIN Cargo CA ON CA.Id = CC.IdCargo WHERE CC.IdCipl = C.id and  CA.PortOfDestination is not null),c.DestinationPort) PortOfDestination
		
		,(SELECT top 1  CA.SailingSchedule FROM CargoCipl CC 
		LEFT JOIN Cargo CA ON CA.Id = CC.IdCargo WHERE CC.IdCipl = C.id and  CA.SailingSchedule is not null) ETD
		
		,(SELECT top 1  CA.ArrivalDestination FROM CargoCipl CC 
		LEFT JOIN Cargo CA ON CA.Id = CC.IdCargo		
		 WHERE CC.IdCipl = C.id and  CA.ArrivalDestination is not null) ETA
		
		--,isnull((SELECT top 1 FS.ViewByUser FROM CargoCipl CC 
		--LEFT JOIN Cargo CA ON CA.Id = CC.IdCargo
		--LEFT JOIN RequestCl rcl ON rcl.IdCl = cc.IdCargo
		--LEFT JOIN FlowStatus FS ON RCL.IdStep = FS.IdStep AND RCL.STATUS = FS.STATUS WHERE CC.IdCipl = C.id AND  FS.ViewByUser is not null),
		--(Select FS.ViewByUser From FlowStatus FS WHERE FS.IdStep = RC.idstep AND FS.STATUS = RC.STATUS)) ViewByUser

		,CASE					
			WHEN fnreq.NextStatusViewByUser =''Pickup Goods''
				THEN
					CASE WHEN 
					(fnReqGr.Status=''DRAFT'') OR (fnReq.Status=''APPROVE'' AND fnReqGr.Status is null AND RC.Status =''APPROVE'') 
						THEN ''Waiting for Pickup Goods''
					WHEN (fnReqGr.IdFlow = 14 AND (fnReqGr.Status =''Submit'' OR fnReqGr.Status =''APPROVE'' ) AND (fnReqCl.Status is Null OR fnReqCl.Status=''Submit''))
						THEN ''On process Pickup Goods''
					WHEN (fnReqCl.IdFlow = 4 AND fnReqCl.IdStep not in (10022))
						THEN ''Preparing for export''
					WHEN (fnReqCl.IdFlow = 4 AND fnReqCl.IdStep = 10022)
						THEN ''Finish''	
					END			
			ELSE fnReq.NextStatusViewByUser
			END AS ViewByUser

		--,CO.PortOfLoading
		--,CO.PortOfDestination
		--,CO.SailingSchedule ETD
		--,CO.ArrivalDestination ETA
		--,CO.*
		--,FS.ViewByUser
	FROM Highchartprovince HP
	INNER JOIN MasterArea MA ON MA.ProvinsiCode = HP.id
	INNER JOIN Cipl C ON RIGHT(C.Area, 3) = RIGHT(MA.BAreaCode, 3)
	--LEFT JOIN CargoCipl CC ON CC.IdCipl = C.id
	INNER JOIN RequestCipl RC ON RC.IdCipl = C.id
	--LEFT JOIN RequestCl RCL ON RCL.IdCl = CC.IdCargo
	--LEFT JOIN Cargo CO ON CO.Id = CC.IdCargo
	--LEFT JOIN FlowStatus FS ON RCL.IdStep = FS.IdStep
	--	AND RCL.STATUS = FS.STATUS
	INNER JOIN Temptable_cipl_request_list_all as fnReq on fnReq.Id = rc.Id 
	LEFT JOIN GoodsReceiveItem as GR on GR.IdCipl = C.id
	LEFT JOIN CargoCipl as CC on CC.IdCipl = C.id
	LEFT JOIN Temptable_gr_request_list_all as fnReqGr on fnReqGr.IdGr = GR.IdGr
	LEFT JOIN Temptable_cl_request_list_all as fnReqCl on fnReqCl.IdCl = CC.IdCargo
	WHERE 
	--RCL.IdStep IN (
	--		11
	--		,12
	--		,10017
	--		,20033
	--		,10020
	--		,10022
	--		)
	--	AND RCL.STATUS IN (
	--		''Submit''
	--		,''Approve''
	--		,''Revise''
	--		)
	--	AND 
		RC.STATUS IN (			
			''Submit''
			,''Approve''
			,''Revise''
			)	
			AND RC.IdCipl NOT IN (SELECT IdCipl FROM CargoCipl CC LEFT JOIN RequestCl RCL ON CC.IdCargo = RCL.IdCl WHERE RCL.Status =''DRAFT''   )
		
		AND YEAR(RC.CreateDate) = YEAR(GETDATE())
	' + @and + '
	ORDER BY C.id OFFSET(('+@Page+' - 1) * '+@RowspPage+') ROWS

	FETCH NEXT '+@RowspPage+' ROWS ONLY';
	EXECUTE (@sql);
END

GO
