USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SP_GRForExport_Header]
	@GRID bigint
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @Id nvarchar(100);
	--SET @Id = 1;
	SELECT 
		t0.Id
		,t0.GrNo AS RgNo
		,t0.PicName
		,t0.PhoneNumber
		,t0.KtpNumber
		,t0.SimNumber
		,t0.StnkNumber
		,t0.NopolNumber
		,ISNULL(CONVERT(VARCHAR(11), t0.EstimationTimePickup, 106), '-') as [EstimationTimePickup]
		,t0.Vendor
		,t0.KirNumber
		,ISNULL(CONVERT(VARCHAR(11), t0.KirExpire, 106), '-') as [KirExpire]
	   ,IIF(CAST(t0.Apar as varchar(20)) = '1', 'Yes', 'No') as [Apar]
	   ,IIF(CAST(t0.Apd as varchar(20)) = '1', 'Yes', 'No') as [Apd]
		,t0.Notes
		,t0.VehicleType
		,t0.VehicleMerk
		,t0.CreateBy
		,ISNULL(CONVERT(VARCHAR(11), t0.CreateDate, 106), '-') as [CreateDate]
		,t0.UpdateBy
		,ISNULL(CONVERT(VARCHAR(11), t0.UpdateDate, 106), '-') as [UpdateDate]
		,t0.IsDelete
		,ISNULL(CONVERT(VARCHAR(11), t0.SimExpiryDate, 106), '-') as [SimExpiryDate]
		,t0.ActualTimePickup
		,t2.Step
		,t3.[Status]
		,t4.[Address] VendorAddress
		,t4.City VendorCity
		,t4.[Name] VendorName
		,t4.Telephone VendorTelephone
		,t4.[Code] VendorCode
		,t0.PickupPoint
		,t0.PickupPic
		,t7.Employee_Name PickupPicName
		,t5.BAreaName PlantName
		,t5.BAreaCode PlantCode
		,t6.Employee_Name as RequestorName
		,t6.Email as RequestorEmail
		,CAST((	
			(SELECT SUM(TotalVolume) FROM dbo.fn_get_total_cipl_all() 
					WHERE Idcipl IN (SELECT IdCipl FROM dbo.GoodsReceiveItem where IdGr = t0.Id))
		  ) as nvarchar(max)) TotalVolume
		, t8.Employee_Name RequestorName
		, t8.Email RequestorEmail
		,CAST((	
			FORMAT((SELECT SUM(TotalNetWeight) FROM dbo.fn_get_total_cipl_all() 
					WHERE Idcipl IN (SELECT IdCipl FROM dbo.GoodsReceiveItem where IdGr = t0.Id)), '#,0.00')
		 ) as nvarchar(max)) TotalNetWeight
		,CAST((	
			FORMAT((SELECT SUM(TotalGrossWeight) FROM dbo.fn_get_total_cipl_all() 
			WHERE Idcipl IN (SELECT IdCipl FROM dbo.GoodsReceiveItem where IdGr = t0.Id)), '#,0.00')
		  ) as nvarchar(max)) TotalGrossWeight
		,CAST((	
			FORMAT((SELECT SUM(TotalPackage) FROM dbo.fn_get_total_cipl_all() 
			WHERE Idcipl IN (SELECT IdCipl FROM dbo.GoodsReceiveItem where IdGr = t0.Id)), '#,0.00')
		  ) as nvarchar(max)) TotalPackages
		  , IIF(s.Employee_Name IS NULL OR LEN(s.Employee_Name) <= 0, '-', s.Employee_Name) as SignedName
		, IIF(s.Position_Name IS NULL OR LEN(s.Position_Name) <= 0, '-', s.Position_Name) as SignedPosition
	FROM dbo.GoodsReceive as t0
	INNER JOIN dbo.RequestGr as t1 on t1.IdGr = t0.Id
	INNER JOIN dbo.FlowStep as t2 on t2.Id = t1.IdStep
	LEFT JOIN dbo.FlowStatus as t3 on t3.IdStep = t1.IdStep AND t3.Status = t1.Status
	LEFT JOIN dbo.MasterVendor as t4 on t4.Code = t0.Vendor 
	LEFT JOIN dbo.MasterArea as t5 on t5.BAreaCode = t0.PickupPoint
	LEFT join dbo.fn_get_employee_internal_ckb() t6 on t0.UpdateBy = t6.AD_User
	LEFT JOIN dbo.fn_get_employee_internal_ckb() t7 on t7.AD_User = t0.PickupPic 
	LEFT JOIN dbo.fn_get_employee_internal_ckb() t8 on t8.AD_User = t0.CreateBy
	left join fn_get_employee_internal_ckb() s on t0.UpdateBy= s.AD_User
    WHERE 1=1 AND t0.id = @GRID
END
GO
