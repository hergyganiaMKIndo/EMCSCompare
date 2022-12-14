USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Ali Mutasal
-- ALTER date	: 2019 Sep 04
-- Description	: Get Next Status Id
-- =============================================
CREATE FUNCTION [dbo].[fn_get_status_id]
(
	-- Add the parameters for the function here
	@IdStep nvarchar(100),
	@Status nvarchar(100)
)
RETURNS bigint
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(100);
	SELECT @Result = Id FROM [dbo].[FlowStatus] where IdStep = @IdStep AND [Status] = @Status 

	RETURN @Result;
END
GO
