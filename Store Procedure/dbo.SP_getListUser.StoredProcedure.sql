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
CREATE PROCEDURE [dbo].[SP_getListUser]
	
AS
BEGIN
	
    -- Insert statements for procedure here
	SELECT UserId, FullName from [PartsInformationSystem].[dbo].[UserAccess]
	WHERE UserType = 'ext-imex'
END
GO
