USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_insert_cipl_history;      
CREATE PROCEDURE [dbo].[sp_insert_document]      
(      
 @IdRequest bigint,     
 @Category nvarchar(20),      
 @Status nvarchar(100),      
 @Step bigint,      
 @Name nvarchar(100),      
 @Tag nvarchar(20),      
 @FileName nvarchar(max),      
 @Date datetime,      
 @CreateBy nvarchar(100),      
 @CreateDate datetime,      
 @UpdateBy nvarchar(100),      
 @UpdateDate datetime,      
 @IsDelete BIT      
)      
AS       
BEGIN      
  
 
 DELETE FROM [dbo].[Documents] WHERE IdRequest = @IdRequest AND Status = @Status AND Tag = @Tag;      
      
 INSERT INTO [dbo].[Documents]      
       ([IdRequest],[Category],[Status],[Step],[Name],[Tag],[FileName],[Date],[CreateBy],[CreateDate],[UpdateBy],[UpdateDate],[IsDelete])      
     VALUES      
       (@IdRequest,@Category,@Status,@Step,@Name,@Tag,@FileName,@Date,@CreateBy,@CreateDate,@UpdateBy,@UpdateDate,@IsDelete)      
END 
GO
