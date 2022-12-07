USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_GetAvailableShippingCiplItem] -- exec [dbo].[SP_GetAvailableShippingCiplItem] '13383','101423','50669'   
(      
@IdCipl nvarchar(100) = 0,    
@IdGr nvarchar(100),   
@IdShippingFleet nvarchar(100)   
)     
As    
Begin                                                       
--DECLARE @sql nvarchar(max);   
--DECLARE @CiplItemCount nvarchar(max);   
--Set @CiplItemCount = (select Count(IdCiplItem) from ShippingFleetItem t2 where t2.IdCipl = @IdCipl And t2.IdGr = @IdGr And t2.IdShippingFleet = @IdShippingFleet)
IF @IdShippingFleet = 0
BEGIN
  SELECT t0.id ,
         t0.idcipl ,
         t0.idreference ,
         (
                SELECT
                       CASE
                              WHEN t0.referenceno = '-' THEN t0.casenumber
                              ELSE t0.referenceno
                       END) AS referenceno ,
         t0.idcustomer ,
         t0.NAME ,
         t0.uom AS unituom ,
         t0.partnumber ,
         t0.sn ,
         t0.jcode ,
         t0.ccr ,
         t0.casenumber ,
         t0.type ,
         t0.idno ,
         t0.yearmade ,
         t0.quantity ,
         t0. unitprice ,
         t0.extendedvalue ,
         t0.length ,
         t0.width ,
         t0.height ,
         t0.volume ,
         t0.grossweight ,
         t0.netweight ,
         t0.currency ,
         t0.CoO ,
         t0.idparent ,
         t0.wonumber ,
         t0.sibnumber ,
         t0.createby ,
         t0.createdate ,
         t0.updateby ,
         t0.updatedate ,
         t0.isdelete ,
         t0.claim ,
         t0.asnnumber
  FROM   ciplitem t0
  JOIN   cipl t1
  ON     t0.idcipl = t1.id
  WHERE  t0.isdelete = 0
  AND    t0.idcipl IN
         (
                SELECT part
                FROM   [SDF_SplitString](@IdCipl,','))
  AND    t0.id NOT IN
(SELECT idciplitem FROM   shippingfleetitem t2 WHERE  t2.idcipl IN ( SELECT part FROM   [SDF_SplitString](@IdCipl,','))
                AND    t2.idgr = @IdGr)
END
ELSE 
begin
SELECT t0.id ,
       t0.idcipl ,
       t0.idreference ,
       (
              SELECT
                     CASE
                            WHEN t0.referenceno = '-' THEN t0.casenumber
                            ELSE t0.referenceno
                     END) AS referenceno ,
       t0.idcustomer ,
       t0.name ,
       t0.uom AS unituom ,
       t0.partnumber ,
       t0.sn ,
       t0.jcode ,
       t0.ccr ,
       t0.casenumber ,
       t0.type ,
       t0.idno ,
       t0.yearmade ,
       t0.quantity ,
       t0.unitprice ,
       t0.extendedvalue ,
       t0.length ,
       t0.width ,
       t0.height ,
       t0.volume ,
       t0.grossweight ,
       t0.netweight ,
       t0.currency ,
       t0.CoO ,
       t0.idparent ,
       t0.wonumber ,
       t0.sibnumber ,
       t0.createby ,
       t0.createdate ,
       t0.updateby ,
       t0.updatedate ,
       t0.isdelete ,
       t0.claim ,
       t0.asnnumber ,
       t3.idshippingfleet
FROM   ciplitem t0
JOIN   cipl t1
ON     t0.idcipl = t1.id
JOIN   shippingfleetitem t3
ON     t3.idciplitem = t0.id
WHERE  t0.isdelete = 0
AND    t3.idshippingfleet = @IdShippingFleet AND    t0.idcipl IN ( SELECT part FROM   [SDF_SplitString](@IdCipl,','))
AND    t0.id IN ( SELECT idciplitem FROM   shippingfleetitem t2 WHERE  t2.idcipl IN
(SELECT part FROM   [SDF_SplitString](@IdCipl,','))AND    t2.idgr = @IdGr AND    t2.idshippingfleet = @IdShippingFleet)
UNION
SELECT t0.id ,
       t0.idcipl ,
       t0.idreference ,
       (
              SELECT
                     CASE
                            WHEN t0.referenceno = '-' THEN t0.casenumber 
							else t0.referenceno
                     END) AS referenceno ,
       t0.idcustomer ,
       t0.NAME ,
       t0.uom AS unituom ,
       t0.partnumber ,
       t0.sn ,
       t0.jcode ,
       t0.ccr ,
       t0.casenumber ,
       t0.type ,
       t0.idno ,
       t0.yearmade ,
       t0.quantity ,
       t0.unitprice ,
       t0.extendedvalue ,
       t0.length ,
       t0.width ,
       t0.height ,
       t0.volume ,
       t0.grossweight ,
       t0.netweight ,
       t0.currency ,
       t0.CoO ,
       t0.idparent ,
       t0.wonumber ,
       t0.sibnumber ,
       t0.createby ,
       t0.createdate ,
       t0.updateby ,
       t0.updatedate ,
       t0.isdelete ,
       t0.claim ,
       t0.asnnumber ,
       -1 As IdShippingFleet
FROM   ciplitem t0

JOIN   cipl t1
ON     t0.idcipl = t1.id
WHERE  t0.isdelete = 0
AND    t0.idcipl IN
       (
              SELECT part
              FROM   [SDF_SplitString](@IdCipl,','))
AND    t0.id NOT IN
       (
              SELECT idciplitem
              FROM   shippingfleetitem t2
              WHERE  t2.idcipl IN
                     (
                            SELECT part
                            FROM   [SDF_SplitString](@IdCipl,','))
              AND    t2.idgr = @IdGr
              --AND    t2.idshippingfleet = @IdShippingFleet
			  )
END
END
GO
