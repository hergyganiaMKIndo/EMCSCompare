USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_get_npepeb_list] --exec [sp_get_npepeb_list] 'xupj21wdn',''            
(            
 @Username nvarchar(100),            
 @Search nvarchar(100),            
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
 DECLARE @WhereSql nvarchar(max) = '';            
 DECLARE @GroupId nvarchar(100);            
 DECLARE @RoleID bigint;            
 DECLARE @area NVARCHAR(max);            
 DECLARE @role NVARCHAR(max) = '';             
 SET @sort = 'np.'+@sort;            
            
 select @GroupId = Organization_Name from employee where Employee_Status = 'Active' AND AD_User = @Username;            
            
            
 SELECT @area = U.Business_Area            
  ,@role = U.[Role]            
 FROM dbo.fn_get_employee_internal_ckb() U            
 WHERE U.AD_User = @Username;            
            
 if @role !=''            
 BEGIN            
            
            
 IF (@role !='EMCS IMEX' and @Username !='ict.bpm')            
 BEGIN            
  SET @WhereSql = ' AND np.CreateBy='''+@Username+''' ';            
 END            
            
 SET @sql = 'SELECT ';            
 IF (@isTotal <> 0)            
 BEGIN            
  SET @sql += 'count(*) total '            
 END             
 ELSE            
 BEGIN            
             
  SET @sql += '   np.Id            
      , np.IdCl            
      , np.AjuNumber            
      , np.AjuDate            
      , np.PebNumber            
      , np.NpeNumber             
      , np.NpeDate            
      , np.PassPabeanOffice            
      , np.Valuta        
   ,np.RegistrationNumber        
   ,ISNULL((select TOP 1(Id) from RequestForChange WHERE FormId = np.IdCl AND FormType = ''NpePeb'' AND [Status] = 0),0) AS PendingRFC          
      , CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Employee_Name ELSE ua.FullName END PreparedBy            
      , CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Email ELSE ua.Email END Email                   
      , STUFF((SELECT '', ''+ISNULL(tx1.EdoNo, ''-'')              
           FROM dbo.CargoItem tx0              
           JOIN dbo.Cipl tx1 on tx1.id = tx0.IdCipl              
           WHERE tx0.IdCargo = tx0.Id              
           GROUP BY tx1.EdoNo              
           FOR XML PATH(''''),type).value(''.'',''nvarchar(max)''),1,1,'''') [RefEdo]               
      , c.ClNo            
      , c.CargoType            
      , CASE WHEN t0.[IdStep] = 30069 THEN ''Waiting approval draft PEB''             
    WHEN (t0.[IdStep] = 30070 AND t0.[Status] = ''Approve'') THEN ''Waiting NPE document''             
    WHEN ((t0.[IdStep] = 30070 OR t0.[IdStep] = 30072) AND t0.[Status] = ''Revise'') THEN ''Need revision review by imex''        
 when np.IsCancelled = 0 then ''Request Cancel Only PebNpe''      
 when np.IsCancelled = 1 then ''waiting for beacukai approval''      
 when np.IsCancelled = 2 then ''Cancelled''      
 WHEN t0.IdStep= 30076 THEN ''Cancelled''      
 WHEN t0.IdStep= 30075 THEN ''waiting for beacukai approval''      
 WHEN t0.IdStep= 30074 THEN ''Request Cancel''       
    WHEN t0.[IdStep] = 30071 THEN ''Waiting approval NPE''    
 WHEN (t0.[IdStep] = 10021 OR t0.IdStep = 30063) THEN ''Approve''    
 --WHEN t0.[IdStep] = 10022 THEN ''Submit''    
    ELSE CASE WHEN t4.Step = ''System'' THEN t5.ViewByUser ELSE t5.ViewByUser END END as StatusViewByUser  '            
 END            
 SET @sql +='  FROM NpePeb np            
      JOIN dbo.Cargo c on c.Id = np.IdCl            
  --   left join RequestCl t0 on t0.IdCl = np.IdCl            
  --   left join (            
  -- select             
  --  nx.Id, nx.IdStep IdNextStep, nx.IdStatus, nx.IdStep NextStep,             
  --  nf.Name, nf.Type, nf.Id IdFlow, np.Id IdCurrentStep,             
  --  ns.Status, np.Step CurrentStep, np.AssignType, np.AssignTo, ns.ViewByUser,            
  --  nt.AssignType NextAssignType, nt.AssignTo NextAssignTo, nt.Step NextStepName            
  -- from dbo.FlowNext nx            
  -- join dbo.FlowStatus ns on ns.Id = nx.IdStatus            
  -- join dbo.FlowStep np on np.Id = ns.IdStep            
  -- join dbo.Flow nf on nf.Id = np.IdFlow            
  -- join dbo.FlowStep nt on nt.Id = nx.IdStep            
  --) as t1 on t1.IdFlow = t0.IdFlow AND t1.IdCurrentStep = t0.IdStep AND t1.Status = t0.Status            
  --inner join dbo.Flow t3 on t3.id = t0.IdFlow            
  --left join dbo.FlowStep t7 on t7.Id = [dbo].[fn_get_next_step_id](            
  --  t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.[Status]), t0.Id            
  --   ) and t7.IdFlow = t1.IdFlow            
  --left join dbo.FlowStatus t8 on t8.[Status] = t0.[Status] AND t8.IdStep = [dbo].[fn_get_next_step_id](            
  --  t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.[Status]), t0.Id            
  --   )            
    join dbo.RequestCl t0 on t0.IdCl = c.Id  
    JOIN dbo.FlowStep t4 on t4.Id = t0.IdStep    
    JOIN dbo.FlowStatus t5 on t5.[Status] = t0.[Status] AND t5.IdStep = t0.IdStep            
    JOIN PartsInformationSystem.dbo.[UserAccess] ua on ua.UserID = np.CreateBy            
    LEFT JOIN employee t2 on t2.AD_User = np.CreateBy            
    WHERE 1=1 AND np.IsDelete = 0 and c.IsDelete = 0 and t0.Status <> ''Draft''  AND c.CargoType != ''''' + @WhereSql+ ' AND (np.AjuNumber like ''%'+@Search+'%'' OR c.ClNo like ''%'+@Search+'%'')';            
            
 IF @isTotal = 0             
 BEGIN            
  SET @sql += ' ORDER BY '+@sort+' '+@order+' OFFSET '+@offset+' ROWS FETCH NEXT '+@limit+' ROWS ONLY';            
 END             
            
 Print(@sql);            
 EXECUTE(@sql);            
 END            
END 
GO
