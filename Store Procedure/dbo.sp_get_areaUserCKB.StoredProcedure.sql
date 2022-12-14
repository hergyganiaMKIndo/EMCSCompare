USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_areaUserCKB]
(
	@Name NVARCHAR(200)
)
AS
BEGIN
	SELECT CAST(t0.Id as bigint) Id, BAreaName, 
	Username, t0.CreateBy, t0.CreateDate, t0.UpdateBy, t0.UpdateDate, 
	t0.IsActive FROM [dbo].[MasterAreaUserCKB] as t0 inner join [dbo].[MasterArea] as t1 on t0.BAreaCode = t1.BAreaCode 
	where t0.IsActive = 0
	  --AND ISNULL(@Name, '') = ''
END
GO
