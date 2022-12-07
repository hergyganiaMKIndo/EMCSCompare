USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_gr_list_20210322] -- [dbo].[sp_get_gr_list] 'xupj21ech', '', 0
(
	@Username nvarchar(100),
	@Search nvarchar(100),
	@isTotal bit = 0,
	@sort nvarchar(100) = 'Id',
	@order nvarchar(100) = 'ASC',
	@offset nvarchar(100) = '0',
	@limit nvarchar(100) = '10'
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql nvarchar(max);  
	DECLARE @WhereSql nvarchar(max) = '';
	DECLARE @GroupId nvarchar(100);
	DECLARE @RoleID bigint;
	DECLARE @area NVARCHAR(max);
	DECLARE @role NVARCHAR(max) = '';
	SET @sort = 't0.'+@sort;

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
					, t0.PicName
					, t0.KtpNumber
					, t0.PhoneNumber
					, t0.SimNumber
					, t0.StnkNumber
					, t0.NopolNumber
					, t0.EstimationTimePickup
					, t0.Notes
					, t2.Step
					, t1.Status
					, t0.PickupPoint
					, t3.ViewByUser StatusViewByUser '
	END
	SET @sql +='FROM dbo.GoodsReceive as t0
			    INNER JOIN dbo.RequestGr as t1 on t1.IdGr = t0.Id
			    INNER JOIN dbo.FlowStep as t2 on t2.Id = t1.IdStep
				LEFT JOIN dbo.FlowStatus as t3 on t3.IdStep = t1.IdStep AND t3.Status = t1.Status
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
