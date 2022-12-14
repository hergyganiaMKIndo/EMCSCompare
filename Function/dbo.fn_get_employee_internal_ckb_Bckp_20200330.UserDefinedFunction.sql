USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_employee_internal_ckb_Bckp_20200330] ()
RETURNS TABLE 
AS
RETURN 
(
	select 
		Employee_ID
		, AD_User
		, Employee_Name
		, Email
		, Superior_Name
		, Organization_Name
		, Position_Name
		, Job_Name
		, Business_Area
		, t1.BAreaName
		, 'internal' UserType
		, CASE 
					WHEN Job_Name = 'Sales Manager' AND Position_Name like '%Area%' THEN 'Area Manager'
					WHEN Job_Name = 'Sales Manager' AND Position_Name like '%Region%' THEN 'Region Manager' 
					ELSE 
						CASE 
						WHEN Organization_Name = 'Import Export' THEN 'IMEX'
						ELSE '-'
					END
		  END AS [Group] 
		, '[unset]' [Role] 
		, t0.Superior_ID
	from employee t0 
	join EMCS.dbo.MasterArea t1 on t1.BAreaCode = t0.Business_Area
	where t0.employee_Status  != 'Withdrawn' AND t0.AD_User NOT IN (select UserID from PartsInformationSystem.dbo.UserAccess)
	union
	select 
		ISNULL(t2.Employee_ID, '') Employee_ID
		, t1.UserID AD_User
		, t1.FullName Employee_Name
		, ISNULL(t2.Email, t1.Email) Email
		, ISNULl(t2.Superior_Name, '') Superior_Name
		, ISNULL(t2.Organization_Name, '') Organization_Name
		, ISNULL(t2.Position_Name, '') Position_Name
		, ISNULL(t2.Job_Name, '') Job_Name
		, ISNULL(t2.Business_Area, '') Business_Area
		, ISNULL(t4.BAreaName, '') BAreaName
		, t1.UserType
		, CASE 
		  WHEN Job_Name = 'Sales Manager' AND Position_Name like '%Area%' THEN 'Area Manager'
		  WHEN Job_Name = 'Sales Manager' AND Position_Name like '%Region%' THEN 'Region Manager' 
		  ELSE 
		  	CASE 
		  	WHEN Organization_Name = 'Import Export' THEN 'IMEX'
			WHEN UserType = 'ext-imex' THEN 'CKB' 
		  	ELSE  '-'
			END
		  END AS [Group]
		, ISNULL(t3.Description, '[unset]') [Role] 
		, t2.Superior_ID
	from PartsInformationSystem.dbo.UserAccess t1
	left join employee t2 on t2.AD_User = t1.UserID AND t2.Employee_Status != 'Withdrawn'
	left join PartsInformationSystem.dbo.RoleAccess t3 on t3.RoleID = t1.RoleID
	left join dbo.MasterArea t4 on t4.BAreaCode = t2.Business_Area
)
GO
