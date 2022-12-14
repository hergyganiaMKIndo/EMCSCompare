USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_shippingsummary_list] 
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
	SET @sort = 'c.'+@sort;

	select @GroupId = Organization_Name from employee where Employee_Status = 'Active' AND AD_User = @Username;


	SELECT @area = U.Business_Area
		,@role = U.[Role]
	FROM dbo.fn_get_employee_internal_ckb() U
	WHERE U.AD_User = @Username;

	if @role !=''
	BEGIN


	IF (@role !='EMCS IMEX' and @Username !='ict.bpm')
	BEGIN
		SET @WhereSql = ' AND c.CreateBy='''+@Username+''' ';
	END

	SET @sql = 'SELECT ';
	IF (@isTotal <> 0)
	BEGIN
		SET @sql += 'count(*) total '
	END 
	ELSE
	BEGIN

		SET @sql += ' c.Id
						, c.SsNo
						, c.ClNo
						, c.CreateDate
						, si.CreateBy
						--, c.CreateBy		
						, cp.CiplNo		
						,cp.ConsigneeName
						, cp.ConsigneeAddress
						,cp.SoldToName
						,cp.SoldToAddress
						, fn.TotalPackage
						, fn.TotalVolume
						, c.ShippingMethod		
						, c.CargoType		
						, c.ClNo		
						, c.SsNo		
						, c.IsDelete		
						, c.ExportType
						, ci.IdCargo
						, COUNT(ci.IdCipl) totalId
						, ci.ContainerNumber	
						, ci.ContainerType	
						, ci.ContainerSealNumber	
						, CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Employee_Name ELSE t3.FullName END PreparedBy
						, CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Email ELSE t3.Email END Email  
						, ci.IdCipl
						, cp.Category  '
	END


	SET @sql +=' from Cargo c
            left join CargoItem ci on c.Id = ci.IdCargo
			left join CiplItem cpi on ci.IdCiplItem = cpi.Id
			left join Cipl cp on cpi.IdCipl = cp.id
			left join ShippingInstruction  si on si.IdCL = c.Id 
			left join fn_get_total_cipl_all()  fn on fn.IdCipl = cpi.IdCipl
			JOIN PartsInformationSystem.dbo.[UserAccess] t3 on t3.UserID = c.CreateBy
			LEFT JOIN employee t2 on t2.AD_User = c.CreateBy
			WHERE 1=1 AND c.IsDelete = 0  ' + @WhereSql+ ' AND  (c.ClNo like ''%'+@Search+'%'' OR c.SsNo like ''%'+@Search+'%'')
			GROUP BY 
				c.Id
				, c.SsNo
				, c.ClNo
				, c.CreateDate
				, si.CreateBy
				--, c.CreateBy
				, cp.CiplNo			
				, cp.ConsigneeName
				, cp.ConsigneeAddress
				, cp.SoldToName
				, cp.SoldToAddress
				, fn.TotalPackage
				, fn.TotalVolume
				, c.ShippingMethod	
				, c.CargoType		
				, c.ClNo		
				, c.SsNo		
				, c.IsDelete		
				, c.ExportType
				--, ci.Id
				, ci.IdCargo
				, ci.ContainerNumber	
				, ci.ContainerType	
				, ci.ContainerSealNumber	
				, CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Employee_Name ELSE t3.FullName END 
				, CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Email ELSE t3.Email END 
				, ci.IdCipl
				, cp.Category
				

				HAVING COUNT(ci.IdCipl) > 1
				';

	IF @isTotal = 0 
	BEGIN
		SET @sql += ' ORDER BY '+@sort+' '+@order+' OFFSET '+@offset+' ROWS FETCH NEXT '+@limit+' ROWS ONLY';
	END 

	PRINT(@sql);

	EXECUTE(@sql);

	END
	
END
GO
