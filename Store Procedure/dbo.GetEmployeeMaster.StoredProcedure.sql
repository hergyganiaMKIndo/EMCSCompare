USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeMaster]
(
@Name nvarchar(255)
)
AS
BEGIN
      select * from Employee where Employee_Name like '%'+@Name+'%'
END
GO
