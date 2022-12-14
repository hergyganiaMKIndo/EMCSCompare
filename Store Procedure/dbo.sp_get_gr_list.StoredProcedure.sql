USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_get_gr_list] -- [dbo].[sp_get_gr_list] 'XUPJ21WDN', '', 0
(
	@Username nvarchar(100),
	@Search nvarchar(100),
	@isTotal bit = 0,
	@sort nvarchar(100) = 'Id',
	@order nvarchar(100) = 'DESC',
	@offset nvarchar(100) = '0',
	@limit nvarchar(100) = '10'
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql nvarchar(max);  
	DECLARE @WhereSql nvarchar(max) = '';
	DECLARE @GroupId nvarchar(100);
	DECLARE @RoleID NVARCHAR(max);
	DECLARE @area NVARCHAR(max);
	DECLARE @role NVARCHAR(max) = '';
	SET @RoleID = (Select RoleID from PartsInformationSystem.dbo.UserAccess where UserID = @Username)         
	SET @sort = 't0.'+@sort;
  	--SET @sort = 't0.UpdateDate';

	select @GroupId = Organization_Name from employee where Employee_Status = 'Active' AND AD_User = @Username;


	SELECT @area = U.Business_Area
		,@role = U.[Role]
	FROM dbo.fn_get_employee_internal_ckb() U
	WHERE U.AD_User = @Username;

	if @role !=''
	BEGIN

	IF (@role !='EMCS IMEX' and @Username !='ict.bpm')
	BEGIN
		SET @WhereSql = ' AND t0.CreateBy='''+@Username+''' ';
	END


	SET @sql = 'SELECT ';
	IF (@isTotal <> 0)
	BEGIN
		SET @sql += 'count(*) total '
	END 
	ELSE
	BEGIN
		SET @sql += 't0.Id
					, t0.GrNo
					, (select top 1 PicName     from shippingfleet s where  t0.id = s.IdGr ) as PicName             
					, (select top 1 PhoneNumber    from shippingfleet s where  t0.id = s.IdGr)as PhoneNumber            
					, (select top 1 KtpNumber     from shippingfleet s where  t0.id = s.IdGr)as KtpNumber
					, (select top 1 SimNumber     from shippingfleet s where  t0.id = s.IdGr)as SimNumber
					, (select top 1 StnkNumber     from shippingfleet s where  t0.id = s.IdGr)as StnkNumber             
					, (select top 1 NopolNumber    from shippingfleet s where  t0.id = s.IdGr)as NopolNumber            
					, (select top 1 EstimationTimePickup from shippingfleet s where  t0.id = s.IdGr)as  EstimationTimePickup         
					, ISNULL((select TOP 1(Id) from RequestForChange WHERE FormId = t0.Id AND FormType = ''GoodsReceive'' AND [Status] = 0),0) AS PendingRFC      
					, t0.Notes
					, t2.Step
					, t1.Status
					, t0.PickupPoint
					, CASE WHEN (t3.ViewByUser =''Waiting for pickup goods approval'')
						THEN t3.ViewByUser +'' (''+ emp.Fullname +'')''
						WHEN t1.[IdStep] = 30074 THEN ''Request Cancel''        
						WHEN t1.[IdStep] = 30075 THEN ''waiting for beacukai approval''        
						WHEN t1.[IdStep] = 30076 THEN ''Cancelled''        
						ELSE t3.ViewByUser
					  END AS StatusViewByUser 
   					,'+@RoleID+' As RoleID '             
	END
	SET @sql +='FROM dbo.GoodsReceive as t0
			    INNER JOIN dbo.RequestGr as t1 on t1.IdGr = t0.Id
				--INNER JOIN ShippingFleetRefrence sfr on sfr.IdGr = gr.Id      --   INNER JOIN CargoCipl cc on cc.IdCipl = sfr.IdCipl
			    INNER JOIN dbo.FlowStep as t2 on t2.Id = t1.IdStep
				LEFT JOIN dbo.FlowStatus as t3 on t3.IdStep = t1.IdStep AND t3.Status = t1.Status
				left join PartsInformationSystem.dbo.useraccess emp on emp.userid = t0.PickupPic
			    where 1=1 '+@WhereSql+'  AND t0.IsDelete=0 AND (t0.GrNo like ''%'+@Search+'%'' OR t0.PicName like ''%'+@Search+'%'')';

	IF @isTotal = 0 
	BEGIN
		SET @sql += ' ORDER BY '+@sort+' '+@order+' OFFSET '+@offset+' ROWS FETCH NEXT '+@limit+' ROWS ONLY';
	END 

	--select @sql;
	EXECUTE(@sql);
	END
END

GO
