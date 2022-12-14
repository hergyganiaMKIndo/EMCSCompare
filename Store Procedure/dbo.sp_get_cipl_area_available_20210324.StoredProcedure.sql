USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- drop procedure sp_get_cipl_available_by_area
-- exec [sp_get_cipl_area_available]
CREATE PROCEDURE [dbo].[sp_get_cipl_area_available_20210324] -- sp_get_cipl_available_by_area
AS
BEGIN
       SELECT 
              DISTINCT BAreaCode, BAreaName
       FROM dbo.Cipl t0 
       JOIN dbo.fn_get_cipl_request_list_all() t1 on t1.IdCipl = t0.id
       JOIN dbo.MasterArea t2 on RIGHT(t2.BAreaCode, 3) = RIGHT(t0.PickUpArea,3)
       WHERE 
       t0.id not in (select IdCipl from dbo.GoodsReceiveItem) 
       AND t1.IdNextStep IN (14, 10024, 10028, 30057);
END
GO
