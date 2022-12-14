USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------
-- ALTER PROCEDURE / FUNCTION
----------------------------------------------------
-- =============================================
-- Author		: Ali Mutasal
-- ALTER date	: 2019-11
-- Description	: 
-- =============================================
CREATE FUNCTION [dbo].[fn_get_cipl_request_list_all] -- select * from [fn_get_cipl_request_list_all]() where id = 3
(	
--	-- Add the parameters for the function here
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select * from (
	  select 
			t0.[Id]		
			,t0.[IdCipl]	
			,t0.[IdFlow]	
			,t0.[IdStep]	
			,t0.[Status]	
			,t0.[Pic]		
			,t0.[CreateBy]	
			,t0.[CreateDate]	
			,t0.[UpdateBy]		
			,t0.[UpdateDate]	
			,t0.[IsDelete]		
			, t3.Name FlowName
			, t3.Type SubFlowType
			, case when t0.[IdStep]	= 30076 then 0
			  else[dbo].[fn_get_next_step_id](
					t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.Status), t0.Id
			  ) END as IdNextStep
			, [dbo].[fn_get_step_name]([dbo].[fn_get_next_step_id](
					t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.Status), t0.Id)
			  ) as NextStepName
			, [dbo].[fn_get_next_assignment_type](
					t1.NextAssignType, t0.Pic, t1.IdNextStep, t0.Id
			  ) NextAssignType
			, CASE WHEN [dbo].[fn_get_next_step_id](
					t1.NextAssignType, t0.Pic, t0.IdFlow, t1.IdNextStep, [dbo].fn_get_status_id(t0.IdStep, t0.Status), t0.Id
			  ) IN (14, 10024, 10028) THEN 'Pickup Goods' ELSE t1.ViewByUser END NextStatusViewByUser
			--, t1.ViewByUser NextStatusViewByUser
			, t2.CiplNo
			, t2.Category
			, t2.ETD
			, t2.ETA
			, t2.LoadingPort
			, t2.DestinationPort
			, t2.ShippingMethod
			, t4.Forwader
			, t2.ConsigneeCountry
			, CASE WHEN ISNULL(t6.AssignType, '') <> '' 
			  THEN
				t6.AssignType
			  ELSE
				[dbo].[fn_get_next_assignment_type](t1.NextAssignType, t0.Pic, t1.IdNextStep, t0.Id) 
			  END 
			  as AssignmentType
			, CASE WHEN ISNULL(t6.AssignTo, '') <> '' 
			  THEN 
			  	t6.AssignTo
			  ELSE
				CASE WHEN LOWER(t1.NextAssignType) = 'user'
				THEN
					t1.NextAssignTo
				ELSE
					[dbo].[fn_get_next_approval] ([dbo].[fn_get_next_assignment_type](t1.NextAssignType, t0.Pic, t1.IdNextStep, t0.Id), t0.Pic, t1.NextAssignTo, t0.CreateBy, '0') 			  	
				END
			  END as NextAssignTo
			 , t5.Business_Area as BAreaUser
		from dbo.RequestCipl t0
		left join (
			select 
				nx.Id, nx.IdStep IdNextStep, nx.IdStatus, nx.IdStep NextStep, 
				nf.Name, nf.Type, nf.Id IdFlow, np.Id IdCurrentStep, 
				ns.Status, np.Step CurrentStep, np.AssignType, np.AssignTo, 
				ns.ViewByUser,
				nt.AssignType NextAssignType, nt.AssignTo NextAssignTo, nt.Step NextStepName
			from dbo.FlowNext nx
			join dbo.FlowStatus ns on ns.Id = nx.IdStatus
			join dbo.FlowStep np on np.Id = ns.IdStep
			join dbo.Flow nf on nf.Id = np.IdFlow
			join dbo.FlowStep nt on nt.Id = nx.IdStep
		) as t1 on t1.IdFlow = t0.IdFlow AND t1.IdCurrentStep = t0.IdStep AND t1.Status = t0.Status
		inner join dbo.Cipl t2 on t2.id = t0.IdCipl 
		inner join dbo.Flow t3 on t3.id = t0.IdFlow
		left join dbo.CiplForwader t4 on t4.IdCipl = t0.IdCipl
		left join dbo.fn_get_employee_internal_ckb() as t5 on t5.AD_User = t0.CreateBy
		left join dbo.FlowDelegation as t6 on t6.IdFlow = t0.IdFlow AND t6.IdStep = t0.IdStep AND t6.IdReq = t0.Id
	) as tab0 
	--WHERE (tab0.NextAssignTo = @Username OR tab0.NextAssignTo = @GroupId)
)
GO
