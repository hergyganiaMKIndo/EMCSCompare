USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[SP_ChangeHistory_RequestForChange_Insert]
 @FormType nvarchar(100)
,@FormNo INT
,@Reason NVARCHAR(MAX)
,@CreateBy NVARCHAR(150)
AS
BEGIN
DECLARE @ResultID INT
INSERT INTO RequestForChange
(FormType,
FormNo,
Reason,
CreateBy)VALUES
(@FormType,
@FormNo,
@Reason,
@CreateBy)
SET @ResultID = SCOPE_IDENTITY()
SELECT @ResultID
END
GO
