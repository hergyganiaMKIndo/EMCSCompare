USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetArea_NEW]
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

		MERGE dbo.MasterArea AS T
			USING 
			(
				SELECT *
				  FROM  BI_PROD.[EDW_ANALYTICS].[ECC].[dim_plant_area] WHERE PLANT NOT in ('-2','-1')
			) AS S ON T.[BAreaName] = S.PLANT_NAME
			WHEN MATCHED THEN
			UPDATE SET T.[BAreaName] = S.PLANT,
			
			[BLatitude] = 0,
			[BLongitude]  = 0,
			[AreaCode] = Isnull([Area_Code],''),
			[AreaName] = [Area_Name],
			[ALatitude] = 0,
			[ALongitude] = 0,
			[IsActive] = 1,
			CreateBy ='SYSTEM',
			CreateDate = GETDATE()
			WHEN NOT MATCHED BY TARGET THEN
			Insert ([BAreaCode]
      ,[BAreaName]
      ,[BLatitude]
      ,[BLongitude]
      ,[AreaCode]
      ,[AreaName]
      ,[ALatitude]
      ,[ALongitude]
      ,[IsActive]
	  ,CreateBy
	  ,CreateDate)
	  VALUES(
   S.PLANT 
      ,S.PLANT_NAME    
      ,0 
      ,0 
	  ,Isnull(S.[Area_Code],'')
	  ,S.[Area_Name]
      ,0 
      ,0 
      , 1 
	  ,'SYSTEM'
	  ,GETDATE());
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		IF(@@TRANCOUNT > 0)
			ROLLBACK TRAN;

		
	

	END CATCH
END
GO
