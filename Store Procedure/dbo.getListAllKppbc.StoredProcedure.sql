USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getListAllKppbc]
(
	@Name NVARCHAR(200)
)
AS
BEGIN
	select v.ID, a.BAreaName, v.Code, v.Name, v.Address, v.Propinsi, v.CreateBy, v.CreateDate from MasterArea a 
	  left join [dbo].[MasterKPBC] v on a.ID = v.AreaID 
	  where v.IsDeleted = 0
	  AND Name LIKE '%'+IIF(ISNULL(@Name, '') = '', Name, @Name )+'%'
END
GO
