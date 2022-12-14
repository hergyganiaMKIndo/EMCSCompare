USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CiplGetList_WithPaging]
(    
	@ConsigneeName NVARCHAR(200),
	@CreateBy NVARCHAR(200),
	@Offset INT = 0,
	@Limit INT = 5
)
AS
BEGIN
	DECLARE @Sql nvarchar(max);
	DECLARE @Sql2 nvarchar(max);
	DECLARE @WhereSql nvarchar(max) = '';
	DECLARE @RoleID bigint;
	DECLARE @area NVARCHAR(max);
	DECLARE @role NVARCHAR(max);
	DECLARE @usertype NVARCHAR(max);

	SELECT @area = U.Business_Area
		,@role = U.[Role],@usertype = UserType
	FROM dbo.fn_get_employee_internal_ckb() U
	WHERE U.AD_User = @CreateBy;

	
	if @role !=''
	BEGIN
	IF (@role !='EMCS IMEX' and @CreateBy !='xupj21fig' and @CreateBy !='ict.bpm' and @usertype !='ext-imex' )
	BEGIN
		SET @WhereSql = ' AND c.CreateBy='''+@CreateBy+''' ';
	END

	IF @ConsigneeName <> ''
	BEGIN
		SET @WhereSql = ' AND (C.CiplNo LIKE ''%'+@ConsigneeName+'%'' OR C.ConsigneeName LIKE ''%'+@ConsigneeName+'%'')';
	END
	--IF @usertype ='ext-imex'
	--BEGIN
	--	SET @WhereSql = @WhereSql + ' AND ((fnReqCl.IdNextStep is NULL  AND RC.[Status]=''Approve'')  OR (fnReqCl.IdNextStep = 10021 AND RC.[Status]=''Approve'')) ';
	--END
	set @Sql = ' 
	with cte as
		(
		SELECT * FROM
			(
			SELECT A.id, A.EdoNo, A.CiplNo, A.Category, A.ConsigneeName, A.ShippingMethod, A.Forwader, A.CreateDate, A.GrossWeight, A.[Status]
			,  CASE					
							WHEN fnreq.NextStatusViewByUser =''Pickup Goods''
							 THEN
								  CASE WHEN 
								  (fnReqGr.Status=''DRAFT'') OR (fnReq.Status=''APPROVE'' AND (fnReqGr.Status is null OR fnReqGr.Status = ''Waiting Approval'') AND A.Status =''APPROVE'') 
										THEN ''Waiting for Pickup Goods''
									WHEN (fnReqGr.IdFlow = 14 AND (fnReqGr.Status =''Submit'' OR fnReqGr.Status =''APPROVE'' ) AND (fnReqCl.Status is Null OR (fnReqCl.Status=''Submit'' AND fnReqCl.IdStep != 10017)))
										THEN ''On process Pickup Goods''
									WHEN (fnReqCl.IdFlow = 4 AND fnReqCl.IdStep not in (10022))
										THEN ''Preparing for export''
									WHEN (fnReqCl.IdFlow = 4 AND fnReqCl.IdStep = 10022)
										THEN ''Finish''
									END			
									WHEN fnReq.Status =''Reject''
									THEN ''Reject''
							WHEN fnReq.NextStatusViewByUser = ''Waiting for superior approval''
								THEN fnReq.NextStatusViewByUser +'' (''+ emp.Employee_Name +'')''
							WHEN fnReq.Status =''Reject''
							THEN ''Reject''
							ELSE fnReq.NextStatusViewByUser
						  END AS [StatusViewByUser]
			FROM
			(
				SELECT DISTINCT C.id,C.EdoNo
						, C.CiplNo
						, C.Category
						, C.ConsigneeName
						, C.ShippingMethod
						, CF.Forwader
						, C.CreateDate
						, ISNULL((Select SUM(CI.GrossWeight) FROM dbo.CiplItem CI WHERE CI.idcipl = C.id),0) GrossWeight
						, RC.[Status]
						, RC.Id as RCId
				  
							FROM dbo.Cipl C		
							INNER JOIN dbo.RequestCipl RC ON RC.IdCipl = C.id
							INNER JOIN dbo.CiplForwader CF ON CF.IdCipl = C.id
							INNER JOIN dbo.FlowStatus FS on FS.IdStep = RC.IdStep AND FS.[Status] = RC.Status
							INNER JOIN PartsInformationSystem.dbo.UserAccess PIS on PIS.UserID = c.CreateBy
							INNER JOIN dbo.[fn_get_cipl_request_list_all]() as fnReq on fnReq.Id = rc.Id 
					
					
							WHERE 1=1 '+@WhereSql+'
							AND C.IsDelete = 0	
							ORDER BY C.id DESC
							OFFSET ' + CAST(@Offset as nvarchar(4)) +' ROWS FETCH NEXT ' + CAST(@Limit as nvarchar(4)) + ' ROWS ONLY
				) A
				LEFT JOIN GoodsReceiveItem as GR on GR.IdCipl = A.id AND GR.isdelete = 0
				LEFT JOIN CargoCipl as CC on CC.IdCipl = A.id AND CC.Isdelete = 0
				LEFT JOIN dbo.[fn_get_cipl_request_list_all]() as fnReq on fnReq.Id = A.RCId 
				LEFT JOIN (
							select t0.IdGr, t0.Status, t0.IdStep, t0.IdFlow from dbo.RequestGr t0 ) fnReqGr ON fnReqGr.IdGr = GR.IdGr
				LEFT JOIN (
							select t0.IdCl, t0.Status, t0.IdStep, t0.IdFlow from dbo.RequestCl t0 ) fnReqCl ON fnReqCl.IdCl = CC.IdCargo
				left join employee emp on emp.AD_User = fnReq.NextAssignTo
				--ORDER BY ID desc
				) A
		
		)
	
	SELECT A.*,cte.StatusViewByUser FROM
	(
		SELECT DISTINCT C.id,C.EdoNo
				, C.CiplNo
				, C.Category
				, C.ConsigneeName
				, C.ShippingMethod
				, CF.Forwader
				, C.CreateDate
				, ISNULL((Select SUM(CI.GrossWeight) FROM dbo.CiplItem CI WHERE CI.idcipl = C.id),0) GrossWeight
				, RC.[Status]
				--, RC.Id as RCId
				
				  
					FROM dbo.Cipl C		
					INNER JOIN dbo.RequestCipl RC ON RC.IdCipl = C.id
					INNER JOIN dbo.CiplForwader CF ON CF.IdCipl = C.id
					INNER JOIN dbo.FlowStatus FS on FS.IdStep = RC.IdStep AND FS.[Status] = RC.Status
					INNER JOIN PartsInformationSystem.dbo.UserAccess PIS on PIS.UserID = c.CreateBy
					INNER JOIN dbo.[fn_get_cipl_request_list_all]() as fnReq on fnReq.Id = rc.Id 
					
					
					WHERE 1=1 '+@WhereSql+'
					AND C.IsDelete = 0	
				
					
			) A
			LEFT JOIN cte ON a.ID = cte.id
			order by A.ID desc
		';

	
		
		--drop table #temp_cipl2
		--print (@WhereSql);
		print (@sql);
	exec(@Sql);	
	END
END
GO
