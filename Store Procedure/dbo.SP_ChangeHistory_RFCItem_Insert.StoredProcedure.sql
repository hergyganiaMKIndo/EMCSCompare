USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[SP_ChangeHistory_RFCItem_Insert]
@RFCID INT
,@FieldName NVARCHAR(200)
,@BeforeValue NVARCHAR(200)
,@AfterValue NVARCHAR(200)
AS
BEGIN
DECLARE @ResultID INT
INSERT INTO RFCItem
(RFCID,
AfterValue,
BeforeValue,
FieldName)VALUES
(@RFCID,
@AfterValue,
@BeforeValue,
@FieldName)
SET @ResultID = SCOPE_IDENTITY()
SELECT @ResultID
END

GO
