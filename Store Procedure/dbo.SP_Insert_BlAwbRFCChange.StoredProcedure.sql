USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Insert_BlAwbRFCChange]          
(          
 @Id BIGINT,  
 @IdBlAwb BIGINT ,  
 @Number NVARCHAR(100),          
 @MasterBlDate datetime,          
 @HouseBlNumber NVARCHAR(200),          
 @HouseBlDate datetime,          
 @Description NVARCHAR(50),          
 @FileName NVARCHAR(max),          
 @Publisher NVARCHAR(50),          
 @CreateBy NVARCHAR(50),          
 @CreateDate datetime,          
 @UpdateBy NVARCHAR(50),          
 @UpdateDate datetime,          
 @IsDelete BIT,          
 @IdCl BIGINT ,  
 @Status nvarchar(max)  
)          
AS          
BEGIN       
 if( @FileName  IS NULL or @FileName = '')        
 begin        
 set @FileName = (select [FileName] From BlAwb where Id = @IdBlAwb)        
 end  
if(@IdBlAwb <> 0 and @Id = 0)        
 begin       
 set @Id = (select Id from BlAwb_Change where IdBlAwb = @IdBlAwb)        
 set @Id = (select IIF(@Id IS NULL, -1, @Id) As Id)        
 end    
 IF @Id <= 0          
 BEGIN          
 INSERT INTO [dbo].[BlAwb_Change]          
           ([Number],[MasterBlDate],[HouseBlNumber],[HouseBlDate],[Description],[FileName],[Publisher],[CreateBy],[CreateDate],[UpdateBy],[UpdateDate],[IsDelete],[IdCl]  
  ,[IdBlAwb],[Status])          
     VALUES          
           (@Number,@MasterBlDate,@HouseBlNumber,@HouseBlDate,@Description ,@FileName,@Publisher,@CreateBy,@CreateDate,@UpdateBy,@UpdateDate,@IsDelete,@IdCl,@IdBlAwb,@Status)          
          
 set  @Id = SCOPE_IDENTITY()           
 --SELECT C.Id as ID, CONVERT(nvarchar(5), C.IdCl) as [NO], C.CreateDate as CREATEDATE FROM BlAwb C WHERE C.id = @LASTID          
 END          
 ELSE           
 BEGIN          
 UPDATE [dbo].[BlAwb_Change]          
  SET [Number] = @Number ,[MasterBlDate] = @MasterBlDate   ,[HouseBlNumber] = @HouseBlNumber  ,[HouseBlDate] = @HouseBlDate          
           ,[Description] = @Description  ,[Publisher] = @Publisher  ,[CreateBy] = @CreateBy  ,[CreateDate] = @CreateDate          
           ,[UpdateBy] = @UpdateBy   ,[UpdateDate] = @UpdateDate ,[Status] = @Status,  
     FileName = @FileName  
     WHERE Id = @Id          
     --SELECT C.Id as ID, CONVERT(nvarchar(5), C.IdCl) as [NO], C.CreateDate as CREATEDATE FROM BlAwb C WHERE C.id = @Id          
 END          
 select CAST(@Id as bigint) as Id     
 --IF(@Status <> 'Draft')      
 --BEGIN      
 -- SET @Status = 'Create BL AWB'    
 -- EXEC [sp_update_request_cl] @IdCl, @CreateBy, @Status, ''      
 --END      
END 
GO
