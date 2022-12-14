USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_ActivityReport_TotalExport]
       @year int
AS
BEGIN
       declare @invoice TABLE (month int, count int, peb int)
       insert into @invoice
       select 
              Month(CreatedDate), 
              count(distinct IdCipl), 
              count(distinct NpeNumber) 
              from(
              select 
                     ci.IdCargo, 
                     ci.Id as IdCargoItem, 
                     cpi.Id as IdCiplItem, 
                     cp.id as IdCipl, 
                     peb.NpeNumber, 
                     CONVERT(VARCHAR(10), 
                     rc.CreateDate, 120) as CreatedDate
              from fn_get_cl_request_list_all_report() rc
              left join NpePeb peb on rc.IdCl = peb.IdCl
              left join CargoItem ci on rc.IdCl = ci.IdCargo
              left join CiplItem cpi on ci.IdCiplItem = cpi.Id
              left join Cipl cp on cpi.IdCipl = cp.id
              where (YEAR(rc.CreateDate) = @year) and
              --OR rc.IdStep = 10019
              --AND ((rc.IdStep = 10020 AND rc.Status = 'Approve')
              --OR rc.IdStep = 10021   
              --OR (rc.IdStep = 10022 AND (rc.Status = 'Submit' OR rc.Status = 'Approve'))) 
              peb.NpeNumber IS NOT NULL AND cp.IsDelete = 0
       )data group by Month(CreatedDate)

       declare @outstanding TABLE (month int, count int)
       insert into @outstanding
       select Month(CreatedDate), count(distinct IdCipl) from(
              select 
                     rc.IdCipl,
                     CASE WHEN MONTH(rc.CreateDate) <> MONTH(rc.UpdateDate) OR MONTH(rc.CreateDate) < MONTH(GETDATE()) THEN CONVERT(VARCHAR(10), rc.CreateDate, 120) ELSE CONVERT(VARCHAR(10), rc.UpdateDate, 120) END AS CreatedDate,  
                     CONVERT(VARCHAR(10),rc.UpdateDate, 120) AS UpdateDate    
              from	[fn_ActivityReport_TotalExport_Outstanding]() rc
              where	YEAR(rc.CreateDate) = @year
              --prev version
              -- FROM (select     
       	--  ci.IdCargo,     
       	--  ci.Id AS IdCargoItem,     
       	--  cpi.Id AS IdCiplItem,     
       	--  cp.id AS IdCipl,  
       	--  rc.IdCl,   
       	--  rc.Status,  
       	--  CONVERT(VARCHAR(10), rc.CreateDate, 120) AS CreatedDate,  
       	--  CONVERT(VARCHAR(10), rc.UpdateDate, 120) AS UpdateDate    
       	--  , fs.Step  
       	--  , fs.Id    
       	--FROM fn_get_cl_request_list_all_report() rc    
       	--  --RequestCl rc     
       	--  left join NpePeb peb ON rc.IdCl = peb.IdCl    
       	--  INNER JOIN FlowStep fs ON rc.IdStep = fs.Id    
       	--  left join CargoItem ci ON rc.IdCl = ci.IdCargo    
       	--  left join CiplItem cpi ON ci.IdCiplItem = cpi.Id    
       	--  left join Cipl cp ON cpi.IdCipl = cp.id    
       	--  left join CiplHistory chis ON chis.IdCipl = cp.id   
       	--WHERE (YEAR(rc.CreateDate) = @year OR @year = 0)  
       	--  AND ((rc.IdStep = 10020 AND (rc.Status NOT IN ('Approve', 'Reject')))   
       	--  OR (rc.IdStep NOT IN (10020, 10021, 10022) AND rc.Status <> 'Reject'))  
       	--  AND ((peb.NpeNumber IS NULL OR peb.NpeNumber = '') OR (peb.NpeNumber IS NOT NULL OR peb.NpeNumber <> '' AND MONTH(rc.CreateDate) <= MONTH(GETDATE())))  
       	--  AND chis.Step = 'Approval By Superior'  
       	--  AND cp.IsDelete = 0  
       	--  AND rc.IdCl NOT IN (SELECT npe.IdCl  
       	--   FROM CargoCipl cc  
       	--	 INNER JOIN NpePeb npe ON npe.IdCl = cc.Id  
       	--   WHERE YEAR(npe.CreateDate) = @year)  
       )data group by Month(CreatedDate)

       declare @monthly_tbl table(MonthNumber int, MonthName nvarchar(10))
       declare @month int = 1
       WHILE @month <= 12
       BEGIN
          insert into @monthly_tbl 
          select @month, LEFT(DATENAME(MONTH , DATEADD(MONTH, @month , -1)), 3)
          SET @month = @month + 1;
       END;

       select 
              m.MonthName as Month, 
              ISNULL(i.count, 0) as Invoice, 
              ISNULL(i.peb, 0) as PEB, 
              ISNULL(o.count, 0) as Outstanding 
       from @monthly_tbl m
       left join @invoice i on m.MonthNumber = i.month
       left join @outstanding o on m.MonthNumber = o.month

END
GO
