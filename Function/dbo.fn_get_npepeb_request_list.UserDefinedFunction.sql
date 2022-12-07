USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_npepeb_request_list] -- select * from [fn_get_npepeb_request_list]('xupj21wdn', 'Import Export','xupj21wdn')         
(         
 -- Add the parameters for the function here        
 @Username nvarchar(100),        
 @GroupId nvarchar(100),        
 @Pic nvarchar(100)        
)        
RETURNS TABLE         
AS        
RETURN         
(        
 -- Add the SELECT statement with parameter references here        
 select * from (        
   select distinct t0.[Id]          
   ,t0.IdCl         
   ,t0.[IdFlow]         
   ,t0.[IdStep]         
   ,t0.[Status]         
   ,t0.[Pic]          
   ,t0.[CreateBy]         
   ,t0.[CreateDate]         
   ,t0.[UpdateBy]          
   ,t0.[UpdateDate]         
   ,t0.[IsDelete]          
   ,t12.IsCancelled      
   ,CASE WHEN t12.Id Is null Then 0    
   else t12.Id end AS IdNpePeb    
   ,t3.Name FlowName        
   ,t3.Type SubFlowType        
   , CASE      
    WHEN t0.[IdStep] = 30074 THEN 30075      
 WHEN t0.[IdStep] = 30075 THEN 30076      
 WHEN t0.[IdStep] = 30076 THEN Null      
 WHEN t0.[IdStep] = 30070 THEN 30071 ELSE [dbo].[fn_get_next_step_id](        
    t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.[Status]), t0.Id        
     ) END as IdNextStep         
   , CASE WHEN t0.[IdStep] = 30069 THEN 'Approve draft NPE & PEB'         
   WHEN t0.[IdStep] = 30070 THEN 'Create NPE'      
 WHEN t0.[IdStep] = 30074 THEN 'waiting for beacukai approval'      
 WHEN t0.[IdStep] = 30075 THEN 'Cancelled'      
 WHEN t0.[IdStep] = 30076 THEN ''      
    WHEN t0.[IdStep] = 30071 THEN 'Approve NPE' ELSE [dbo].[fn_get_step_name](        
     [dbo].[fn_get_next_step_id](        
      t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.[Status]), t0.Id        
     )        
     ) END as NextStepName        
   , [dbo].[fn_get_next_assignment_type](t1.NextAssignType, t0.Pic, t1.IdNextStep, t0.Id) NextAssignType        
   , CASE WHEN t0.[IdStep] = 30069 THEN 'Waiting approval draft PEB'         
    WHEN (t0.[IdStep] = 30070 AND t0.[Status] = 'Approve') THEN 'Waiting NPE document'         
    WHEN ((t0.[IdStep] = 30070 OR t0.[IdStep] = 30072) AND t0.[Status] = 'Revise') THEN 'Need revision review by imex'         
    when t12.IsCancelled = 0 then 'Request Cancel Only PebNpe'      
    when t12.IsCancelled = 1 then 'waiting for beacukai approval'      
    when t12.IsCancelled = 2 then 'Cancelled'      
    WHEN t0.[IdStep] = 30071 THEN 'Waiting approval NPE'      
    WHEN t0.[IdStep] = 30074 THEN 'Request Cancel'      
    WHEN t0.[IdStep] = 30075 THEN 'waiting for beacukai approval'      
    WHEN t0.[IdStep] = 30076 THEN 'Cancelled'      
    ELSE CASE WHEN t11.Step = 'System' THEN t8.ViewByUser ELSE t1.ViewByUser END END as StatusViewByUser        
   , t1.CurrentStep        
   , t2.ClNo        
   , t2.BookingNumber        
   , t2.BookingDate        
   , t2.PortOfLoading        
   , t2.PortOfDestination        
   , t2.Liner        
   , t2.SailingSchedule ETD        
   , t2.ArrivalDestination ETA        
   , t2.VesselFlight        
   , t2.Consignee        
   , t2.StuffingDateStarted        
   , t2.StuffingDateFinished        
   , t5.AD_User        
   , t4.FullName        
   , t5.Employee_Name        
   , CASE WHEN ISNULL(t5.AD_User, '') <> '' THEN t4.FullName ELSE CASE WHEN ISNULL(t5.Employee_Name, '') <> '' THEN t5.Employee_Name ELSE t4.FullName END END PreparedBy         
   , t7.AssignType as AssignmentType        
   , CASE       
  --WHEN (t0.[IdStep] = 30069 OR t0.[IdStep] = 30071 )       
   -- THEN 'XUPJ21WDN'       
    --WHEN (t0.[IdStep] = 30074)      
    --then 'IMEX'      
    WHEN (t0.[IdStep] = 30070)       
     THEN t6.PicBlAwb      
    when (((select RoleID from PartsInformationSystem.[dbo].UserAccess where UserID = @Username) = 8 and t0.[IdStep] = 30069 OR t0.[IdStep] = 30071 or t0.IdStep = 30074 or t0.IdStep = 30075 or t0.IdStep = 30076  or t12.IsCancelled = 0 or t12.IsCancelled =
  
    
 1 or t12.IsCancelled = 2) or      
   ((select RoleID from PartsInformationSystem.[dbo].UserAccess where UserID = @Username) = 24 and t0.[IdStep] = 30069 OR t0.[IdStep] = 30071 or t0.IdStep = 30074 or t0.IdStep = 30075 or t0.IdStep = 30076 or t12.IsCancelled = 0 or t12.IsCancelled = 1 or  
 
    
t12.IsCancelled = 2))      
    then @Username      
    ELSE       
     [dbo].[fn_get_next_approval] (t7.AssignType, t0.Pic, t7.AssignTo, t0.CreateBy, t0.Id)       
     END AS NextAssignTo      
  , t6.SpecialInstruction        
   , t6.SlNo        
   , t6.Description        
   , t6.DocumentRequired        
   , t2.ShippingMethod        
   , t12.AjuNumber as PebNumber        
   , t2.SailingSchedule        
   , t2.ArrivalDestination        
   , t6.PicBlAwb        
  from dbo.NpePeb t12     
  left join dbo.RequestCl t0 on   t0.IdCl = t12.IdCl    
  left join (        
   select         
    nx.Id, nx.IdStep IdNextStep, nx.IdStatus, nx.IdStep NextStep,         
    nf.Name, nf.Type, nf.Id IdFlow, np.Id IdCurrentStep,         
    ns.Status, np.Step CurrentStep, np.AssignType, np.AssignTo, ns.ViewByUser,        
    nt.AssignType NextAssignType, nt.AssignTo NextAssignTo, nt.Step NextStepName        
   from dbo.FlowNext nx        
   join dbo.FlowStatus ns on ns.Id = nx.IdStatus        
   join dbo.FlowStep np on np.Id = ns.IdStep        
   join dbo.Flow nf on nf.Id = np.IdFlow        
   join dbo.FlowStep nt on nt.Id = nx.IdStep        
  ) as t1 on t1.IdFlow = t0.IdFlow AND t1.IdCurrentStep = t0.IdStep AND t1.Status = t0.Status        
  inner join dbo.Cargo t2 on t2.id = t0.IdCl        
  inner join dbo.Flow t3 on t3.id = t0.IdFlow        
  left join PartsInformationSystem.dbo.UserAccess t4 on t4.UserID = t2.CreateBy        
  left join employee t5 on t5.AD_User = t2.CreateBy        
  left join dbo.ShippingInstruction t6 on t6.IdCL = t0.IdCl          
  left join dbo.FlowStep t7 on t7.Id = [dbo].[fn_get_next_step_id](        
    t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.[Status]), t0.Id        
     ) and t7.IdFlow = t1.IdFlow        
  left join dbo.FlowStatus t8 on t8.[Status] = t0.[Status] AND t8.IdStep = [dbo].[fn_get_next_step_id](        
    t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.[Status]), t0.Id        
     )        
  left join dbo.FlowStatus t9 on t9.[Status] = t0.[Status] AND t9.IdStep = t1.IdNextStep        
  left join dbo.FlowNext t10 on t10.IdStatus = t9.Id        
  left join dbo.FlowStep t11 on t11.Id = t10.IdStep        
      
  WHERE t0.CreateBy <> 'System' and t0.IsDelete = 0  and t2.CreateBy <> 'System'        
 ) as tab0         
 WHERE (tab0.NextAssignTo = @Username OR tab0.NextAssignTo = @GroupId OR tab0.PicBlAwb = @Pic)        
) 
GO
