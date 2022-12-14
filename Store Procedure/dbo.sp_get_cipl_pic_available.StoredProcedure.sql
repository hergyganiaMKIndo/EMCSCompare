USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_cipl_pic_available] -- exec [sp_get_cipl_pic_available] '1s80'
(
       @BAreaCode nvarchar(10)
)
AS
BEGIN
       SELECT DISTINCT 
              t0.PickUpPic
              , t0.PickUpArea
              , t3.BAreaName
              , t2.Employee_Name EmployeeName
       FROM dbo.Cipl t0 
       JOIN dbo.fn_get_cipl_request_list_all() t1 on t1.IdCipl = t0.id
       JOIN dbo.fn_get_employee_internal_ckb() t2 on t2.AD_User = t0.PickUpPic
       JOIN dbo.MasterArea t3 on RIGHT(t3.BAreaCode,3) = RIGHT(t0.PickUpArea,3)
       WHERE 
       t0.id not in 
		(
			select gi.IdCipl 
			from dbo.GoodsReceiveItem gi
			join RequestGr rg ON gi.idgr = rg.idgr
			where gi.isdelete = 0 AND rg.[status] != 'Reject'
		) 
       AND t1.IdNextStep IN (14, 10024, 10028, 30057)
       AND RIGHT(t0.PickUpArea,3) = RIGHT(@BAreaCode,3);
END


GO
