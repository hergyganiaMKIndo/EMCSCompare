USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
CREATE PROCEDURE [dbo].[sp_get_blawb_list_idcl]   
(  
 @IdCargo NVARCHAR(10),  
 @IsTotal bit = 0,  
 @sort nvarchar(100) = 'Id',  
 @order nvarchar(100) = 'ASC',  
 @offset nvarchar(100) = '0',  
 @limit nvarchar(100) = '10'  
)   
AS  
BEGIN  
 DECLARE @sql nvarchar(max);    
 SET @sql = 'SELECT ';  
 SET @sort = 't0.'+@sort;  
  
 IF (@IsTotal <> 0)  
 BEGIN  
  SET @sql += 'count(*) total'  
 END   
 ELSE  
 BEGIN  
  SET @sql += 't0.Id  
      ,t0.IdCl  
      ,t0.Number  
      ,t0.MasterBlDate  
      ,t0.HouseBlNumber  
      ,t0.HouseBlDate  
      ,t0.Description  
      ,t0.FileName  
      ,t0.Publisher  
      ,t0.BlAwbDate  
      ,t0.CreateDate
	  ,t0.CreateBy
	  ,t0.UpdateDate
	  ,t0.UpdateBy
	  ,t0.IsDelete'  
 END  
 SET @sql +=' FROM BlAwb t0   
  WHERE  t0.IsDelete = 0 AND t0.IdCl = '+@IdCargo;  
 EXECUTE(@sql);  
 --select @sql;  
END  
  
GO
