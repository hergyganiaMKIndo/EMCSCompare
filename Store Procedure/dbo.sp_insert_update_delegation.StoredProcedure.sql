USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP PROCEDURE [sp_insert_update_delegation]
-- sp_insert_update_delegation 'CIPL', 33, 'xupj21ech', 'user', 'xupj21wdn'
CREATE PROCEDURE [dbo].[sp_insert_update_delegation]
(
		@Type nvarchar(50),
		@IdReq bigint,		
		@Username nvarchar(100),
		@AssignType nvarchar(50),
		@AssignTo nvarchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	-- Insert data to table delegation
	DECLARE @Status nvarchar(50),
			@IdDelegation bigint = 0,
			@IdFlow bigint = 0,
			@Id bigint = 0,
			@IdStep bigint = 0

	SELECT @Id = Id, @IdFlow = IdFlow, @IdStep = IdStep
	FROM dbo.fn_get_cipl_request_list_all() 
	WHERE IdCipl = @IdReq;	
	
	IF @IdDelegation = 0 
	BEGIN
		-- Insert data into table delegation
		INSERT INTO [dbo].[FlowDelegation]
		           ([Type], [IdReq], [IdFlow], [IdStep], [AssignType], [AssignTo], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate], [IsDelete])
		     VALUES
		           (@Type, @Id, @IdFlow, @IdStep, @AssignType, @AssignTo, @Username, GETDATE(), @Username, GETDATE(), 0)
		
			SET @IdDelegation = SCOPE_IDENTITY();
		
		--INSERT INTO [dbo].[RequestDelegation]
		--			([IdFlowDelegation], [IdFlow], [IdStep], [Status], [Pic], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate], [IsDelete])
		--     VALUES
		--           (@IdDelegation, @IdFlow, @IdReq, 'Submit', @Username, @Username, GETDATE(), @Username, GETDATE(),0)
		
		--	 SELECT @IdReq = Id FROM [RequestDelegation] WHERE IdFlowDelegation = @IdDelegation
		
		-- Insert data into table cipl history
		INSERT INTO [dbo].[CiplHistory]
		           ([IdCipl], [Flow], [Step], [Status], [Notes], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate], [IsDelete])
		     VALUES
		           (@Id, 'CIPL', @IdStep, 'Submit', 'Delegation Approval', @Username, GETDATE(), @Username, GETDATE(), 0)
	END
	ELSE 
	BEGIN
		UPDATE dbo.FlowDelegation SET AssignTo = @AssignTo WHERE Id = @IdDelegation;
		--UPDATE dbo.RequestDelegation SET UpdateDate = GETDATE() where IdFlowDelegation = @IdDelegation;
	END
END


GO
