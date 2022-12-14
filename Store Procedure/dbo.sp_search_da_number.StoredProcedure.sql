USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Sandi Febrian
-- Create date: 2022-08-16
-- Description:	Search DA Number
-- =============================================
CREATE PROCEDURE [dbo].[sp_search_da_number] 
	-- Add the parameters for the stored procedure here
	@keyword varchar(50) ='', 
	@withExisting bit = 0,
	@currentGrId bigint = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT DaNo 
		FROM BastNumber bast
		WHERE 1 = 0';

	IF @withExisting < 1
	BEGIN
		SET @SQL = 'SELECT DaNo 
		FROM BastNumber bast
		WHERE NOT EXISTS (
			SELECT 1
			FROM GoodsReceiveItem grItem 
			WHERE grItem.DaNo = bast.DaNo
		) AND DaNo LIKE '''+@keyword+'%'' ';
	END
	ELSE IF @currentGrId IS NOT NULL
	BEGIN
		SET @SQL = 'SELECT DaNo 
		FROM BastNumber bast
		WHERE NOT EXISTS (
			SELECT 1
			FROM GoodsReceiveItem grItem 
			WHERE grItem.DaNo = bast.DaNo
				OR grItem.grId <> '+ @currentGrId +'
		) AND DaNo LIKE '''+@keyword+'%'' ';
	END
	ELSE
	BEGIN 
		SET @SQL = 'SELECT DaNo 
		FROM BastNumber bast
		WHERE DaNo LIKE '''+@keyword+'%'' ';
	END

	EXECUTE(@SQL);
END
GO
