USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_Superior]
(
	@EmployeeUsername NVARCHAR(200)
)
AS
BEGIN
	SELECT CAST(Id as bigint) Id, EmployeeUsername, 
	EmployeeName, SuperiorUsername, SuperiorName, CreateBy, CreateDate, UpdateBy, UpdateDate, 
	Isdeleted 
	FROM [dbo].[MasterSuperior] 
	WHERE IsDeleted = 0 AND EmployeeUsername LIKE ('%'+ @EmployeeUsername + '%')
END

GO
