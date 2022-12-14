USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_plant_barea_user] ()
RETURNS TABLE 
AS
RETURN 
(
	select t1.AD_User, t1.Employee_Name, t1.Email, t3.PlantCode, t2.BAreaCode, t2.BAreaName 
	from dbo.fn_get_employee_internal_ckb() t1
	join dbo.MasterArea t2 on t2.BAreaCode = t1.Business_Area
	join dbo.MasterPlant t3 on RIGHT(t3.PlantCode, 3) = RIGHT(t2.BAreaCode, 3)
)


GO
