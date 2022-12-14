USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CargoDocumentGetById]
(
	@id BIGINT
)	
AS
BEGIN
	SELECT
		CAST(t0.IdCargo as bigint) IdCargo
		, t0.Flow
		, t0.Step
		, t0.Status
		, t3.ViewByUser
		, t0.Notes
		, t0.CreateBy
		, t0.CreateDate
	FROM CargoHistory t0
	join FlowStep t1 on t1.Step = t0.Step
	join Flow t2 on t2.Id = t1.IdFlow
	join FlowStatus t3 on t3.[Status] = t0.[Status] AND t3.IdStep = t1.Id
	join employee t4 on t4.AD_User = t0.CreateBy
	WHERE t0.IdCargo = @id;
END
GO
