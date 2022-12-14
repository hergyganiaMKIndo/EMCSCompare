USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
        
CREATE PROCEDURE [dbo].[SP_Insert_BlAwbHistory]                  
(                
@Id BigInt = 0,          
 @IdBlAwb NVARCHAR(100) = '',                  
 @Number NVARCHAR(100) = '',                  
 @MasterBlDate  NVARCHAR(max) ,                  
 @HouseBlNumber NVARCHAR(200) = '',                  
 @HouseBlDate  NVARCHAR(max),                  
 @Description NVARCHAR(50) = '',                  
 @FileName NVARCHAR(max) = '',                  
 @Publisher NVARCHAR(50) = '',                  
 @CreateBy NVARCHAR(50) = '',                            
 @IsDelete BIT,                  
 @IdCl NVARCHAR(100) = '',                  
 @Status NVARCHAR(100) = ''                  
)                  
 AS                  
BEGIN            
--if @IdBlAwb = 0        
--begin        
 INSERT INTO [dbo].[BlAwb_History]                  
           ([Number]                  
     ,[MasterBlDate]                  
     ,[HouseBlNumber]                  
     ,[HouseBlDate]                  
           ,[Description]                  
     ,[FileName]                  
     ,[Publisher]                  
     ,[CreateBy]                    
     ,[CreateDate]                            
           ,[IsDelete]                  
     ,[IdCl]          
  ,[IdBlAwb]          
  ,[Status]        
           )                  
     VALUES                  
           (@Number                  
     ,@MasterBlDate                  
     ,@HouseBlNumber                  
     ,@HouseBlDate                  
           ,@Description                  
     ,@FileName                  
     ,@Publisher                  
           ,@CreateBy 
		   ,GETDATE()
           ,@IsDelete                  
     ,@IdCl          
  ,@IdBlAwb        
  ,@Status)                  
--end        
--else         
--begin        
--set @Id = (select MAX( Id) from BlAwb_History where IdBlAwb = @IdBlAwb)        
--If @Id Is Null And @Id <> '' And @Id = 0      
--begin      
--INSERT INTO [dbo].[BlAwb_History]                  
--           ([Number]                  
--     ,[MasterBlDate]                  
--     ,[HouseBlNumber]                  
--     ,[HouseBlDate]                  
--           ,[Description]                  
--     ,[FileName]                  
--     ,[Publisher]                  
--     ,[CreateBy]                             
--           ,[IsDelete]                  
--     ,[IdCl]          
--  ,[IdBlAwb]          
--  ,[Status]        
--           )                  
--     VALUES                  
--           (@Number                  
--     ,@MasterBlDate                  
--     ,@HouseBlNumber                  
--     ,@HouseBlDate                  
--           ,@Description                  
--     ,@FileName                  
--     ,@Publisher                  
--           ,@CreateBy                             
--           ,@IsDelete                  
--     ,@IdCl          
--  ,@IdBlAwb        
--  ,@Status)            
--end      
--else       
--begin      
--update BlAwb_History        
--set Number          =@Number,        
--     [MasterBlDate]   = @MasterBlDate       ,        
--     [HouseBlNumber]  = @HouseBlNumber,                
--     [HouseBlDate]    = @HouseBlDate,        
--     [Description]    = @Description,              
--     [FileName]          =@FileName,        
--     [Publisher]          =@Publisher,        
--     [CreateBy]                     =@CreateBy,        
--     [IsDelete]          =@IsDelete,        
--     [IdCl]  = @IdCl,        
--  [IdBlAwb]  = @IdBlAwb,        
--  [Status] = @Status        
--  where Id = @Id and IdBlAwb = @IdBlAwb        
--end        
--end      
      
 SELECT @Id = CAST(SCOPE_IDENTITY() as bigint)                            
END
GO
