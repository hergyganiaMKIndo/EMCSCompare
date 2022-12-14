USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CiplItemInArmada]    
 (        
 @IdCipl nvarchar(100),        
 @IdGr nvarchar(100),      
 @IdShippingFleet nvarchar(100)      
        
 )        
 As     
 BEGIN      
      
  select  t0.Id        
    , t0.IdCipl        
    , t0.IdReference        
    , (SELECT CASE        
        WHEN t0.ReferenceNo = '-' THEN t0.CaseNumber         
        ELSE t0.ReferenceNo        
        END) AS ReferenceNo        
    , t0.IdCustomer        
    , t0.Name        
    , t0.Uom         
    , t0.PartNumber        
    , t0.Sn        
    , t0.JCode        
    , t0.Ccr        
    , t0.CaseNumber        
    , t0.Type        
    , t0.IdNo        
    , t0.YearMade        
    , t0.Quantity        
    , t0.UnitPrice        
    , t0.ExtendedValue        
    , t0.Length        
    , t0.Width        
    , t0.Height        
    , t0.Volume        
    , t0.GrossWeight        
    , t0.NetWeight        
    , t0.Currency        
 , t0.CoO        
 , t0.IdParent        
 , t0.WONumber        
 , t0.SIBNumber        
    , t0.CreateBy        
    , t0.CreateDate        
    , t0.UpdateBy        
    , t0.UpdateDate        
    , t0.IsDelete        
 , t0.Claim        
 , t0.ASNNumber      
 , t3.IdShippingFleet      
   from CiplItem t0        
  join Cipl t1 on t0.IdCipl = t1.id      
  join ShippingFleetItem t3 on t3.IdCiplItem = t0.Id      
  where t0.IsDelete = 0 And t3.IdShippingFleet = @IdShippingFleet and t0.IdCipl In    
  (SELECT part FROM [SDF_SplitString](@IdCipl,','))  And t0.Id In      
  (select IdCiplItem from ShippingFleetItem t2 where t2.IdCipl In     
  (SELECT part FROM [SDF_SplitString](@IdCipl,',')) And t2.IdShippingFleet = @IdShippingFleet)     
  end 
  
GO
