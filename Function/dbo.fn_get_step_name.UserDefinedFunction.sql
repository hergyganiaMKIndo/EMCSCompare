USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Ali Mutasal
-- ALTER date	: 2019 Sep 04
-- Description	: Get Next Step Id When The Step Name is System
-- =============================================
CREATE FUNCTION [dbo].[fn_get_step_name]
(
	-- Add the parameters for the function here
	@StepId bigint
)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @Result nvarchar(100)
	select @Result = Step from dbo.FlowStep where Id = @StepId;
	RETURN @Result;
END
GO
