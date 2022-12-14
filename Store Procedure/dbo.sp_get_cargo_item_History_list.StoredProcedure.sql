USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_cargo_item_History_list] -- [dbo].[sp_get_cargo_item_History_list] 41784       
(        
 @IdCargo nvarchar(100),        
 @isTotal bit = 0,        
 @sort nvarchar(100) = 'Id',        
 @order nvarchar(100) = 'ASC',        
 @offset nvarchar(100) = '0',        
 @limit nvarchar(100) = '10'        
)        
AS        
BEGIN        
 SET NOCOUNT ON;        
 DECLARE @sql nvarchar(max);          
 SET @sort = 't0.'+@sort;        
        
 SET @sql = 'SELECT ';        
 IF (@isTotal <> 0)        
  BEGIN        
   SET @sql += 'count(*) total '        
  END         
 ELSE        
  BEGIN        
   SET @sql += 'ROW_NUMBER() OVER ( ORDER BY t0.Id ) RowNo        
      ,t0.Id Id      
   ,t0.IdCargo IdCargo      
   ,t0.IdCargoItem       
      ,t0.IdCipl       
   ,t0.IdCiplItem      
   ,t0.CreateBy      
   ,t0.CreateDate      
   ,t0.UpdateBy      
   ,t0.UpdateDate      
   ,t0.IsDelete      
   ,t0.Status      
   ,t2.Incoterms IncoTerm                         
      ,t2.Incoterms IncoTermNumber        
      ,t3.CiplNo                                           
      ,t1.CaseNumber                         
      ,t3.EdoNo                         
      ,t6.DaNo InboundDa                         
      ,ISNULL(t0.NewLength, t0.Length) Length                        
      ,ISNULL(t0.NewWidth,t0.Width) Width                         
      ,ISNULL(t0.NewHeight,t0.Height) Height                        
      ,ISNULL(t0.NewNet,t0.Net) Net                    
      ,ISNULL(t0.NewGross,t0.Gross) Gross        
      ,t0.NewLength                         
      ,t0.NewWidth                         
      ,t0.NewHeight                        
      ,t0.NewNet NewNetWeight                      
      ,t0.NewGross NewGrossWeight                       
      ,t1.Sn                
      ,t1.PartNumber                
      ,t1.Quantity                
      ,t1.Name ItemName                
      ,t1.JCode                
      ,t2.Category CargoDescription                
      ,t0.ContainerNumber        
      ,t5.Description ContainerType  
	  ,t0.ContainerType ContainerTypeId 
      ,t0.ContainerSealNumber'        
  END        
   SET @sql +='        
     FROM dbo.CargoItem_Change t0        
     JOIN dbo.CiplItem t1 on t1.Id = t0.IdCiplItem AND t1.isdelete = 0        
     JOIN dbo.Cargo t2 on t2.Id = t0.IdCargo AND t2.isdelete = 0        
     JOIN dbo.Cipl t3 on t3.id = t1.IdCipl AND t3.isdelete = 0        
    LEFT JOIN dbo.ShippingFleetRefrence t4 on t4.DoNo = t3.EdoNo      
 Left JOIN dbo.ShippingFleet t6 on t6.Id = t4.IdShippingFleet      
 -- LEFT JOIN dbo.GoodsReceiveItem t4 on t4.DoNo = t3.EdoNo AND t4.isdelete = 0        
     LEFT JOIN dbo.MasterParameter t5 on t5.Value = t0.ContainerType AND t5.[Group] = ''ContainerType''        
     WHERE t0.IdCargo='+@IdCargo+' ';        
 --IF @isTotal = 0         
 --BEGIN        
 -- SET @sql += ' ORDER BY '+@sort+' '+@order+' OFFSET '+@offset+' ROWS FETCH NEXT '+@limit+' ROWS ONLY';        
 --END         
 --select @sql;        
 EXEC(@sql);        
END 

GO
