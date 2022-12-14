USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_employee_internal_ckb] ()
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
	left join EMCS.dbo.MasterArea t1 on t1.BAreaCode = t0.Business_Area
	where t0.employee_Status  != 'Withdrawn' AND t0.AD_User NOT IN (select UserID from PartsInformationSystem.dbo.UserAccess) AND t0.AD_User not like '000%' AND t0.AD_User not like 'EMP%' 
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
		, CASE WHEN t1.UserID ='XUPJ21FIG' THEN ''
		ELSE
		ISNULL(t2.Business_Area, '')
		END Business_Area
		, ISNULL(t4.BAreaName, '') BAreaName
		, t1.UserType
		, CASE 
			WHEN Job_Name = 'Sales Manager' AND Position_Name like '%Area%' THEN 'Area Manager'
			WHEN Job_Name = 'Sales Manager' AND Position_Name like '%Region%' THEN 'Region Manager' 
			ELSE 
			CASE 
			WHEN Organization_Name = 'Import Export' THEN 'IMEX'
			ELSE  t5.[Name]
			END
			END AS [Group]
		, CASE WHEN t1.UserID ='XUPJ21FIG' THEN 'EMCS IMEX'
		ELSE
		ISNULL(t3.Description, '[unset]')
		END  [Role] 
		, t2.Superior_ID
	from PartsInformationSystem.dbo.UserAccess t1
	left join employee t2 on t2.AD_User = t1.UserID AND t2.Employee_Status != 'Withdrawn' --AND t2.AD_User not like '000%'-- AND t2.AD_User not like 'EMP%'
	left join PartsInformationSystem.dbo.RoleAccess t3 on t3.RoleID = t1.RoleID
	left join dbo.MasterArea t4 on t4.BAreaCode = t2.Business_Area
	left join PartsInformationSystem.dbo.Master_Group t5 on t5.ID = t1.GroupID
	WHERE t1.UserID not like '000%' AND UserID not like 'EMP%'
)

GO
