USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getListAllBranch]
AS
BEGIN
      select b.ID, a.Area, b.BranchCode, b.BranchDesc, b.IsCC100, v.Employee_Name PICBranch from MasterBranch b 
	  join MasterArea a on b.AreaID = a.ID 
	  left join [dbo].[vEmployeeMaster] v on b.PICBranch = v.Employee_xupj collate DATABASE_DEFAULT
	  where b.IsActive = 1 order by b.BranchDesc asc
END
GO
