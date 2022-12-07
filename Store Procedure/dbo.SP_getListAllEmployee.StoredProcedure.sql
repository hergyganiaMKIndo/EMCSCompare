USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_getListAllEmployee]
	
AS
BEGIN
		
	SELECT Employee_ID AS Id, Employee_Name + ' - ' + AD_User AS Name, AD_User AS AdUser from Employee
	WHERE AD_User IS NOT NULL
	ORDER BY Employee_Name ASC

END


GO
