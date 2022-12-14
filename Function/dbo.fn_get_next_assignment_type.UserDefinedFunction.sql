USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_next_assignment_type] -- select dbo.fn_get_next_assignment_type('System', 'xupj21ech', '3') NextApproval
(
	-- Add the parameters for the function here
	@Type nvarchar(100),
	@Username nvarchar(100),
	@IdNextStep nvarchar(100) = '0',
	@IdReq bigint = 0
)
RETURNS nvarchar(100)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(100);
	DECLARE @BArea nvarchar(100);
	SELECT @BArea = Business_Area FROM employee WHERE AD_User = @Username;

	IF ISNULL(@Type, '') <> 'System'
	BEGIN
		SET @Result = @Type;
	END

	IF ISNULL(@Type, '') = 'System'
	BEGIN
		IF (@IdNextStep = 10037)
		BEGIN
			-- cek apakah cargo memiliki history perubahan item 
			DECLARE @total_update_item int;
			
			-- ambil data request dan id cargo
			DECLARE @IdCargo bigint;
			SELECT @IdCargo = IdCl FROM dbo.RequestCl WHERE Id = @IdReq;
			
			-- ambil total perubahan
			SELECT @total_update_item = count(*) from dbo.CiplItemUpdateHistory t0 where t0.IdCargo = @IdCargo;

			IF (@total_update_item <> 0)
			BEGIN
				-- get cipl list yang harus diupdate
				DECLARE @totalWaitingApprove int = 0;

				SELECT @totalWaitingApprove = count(*) 
				FROM dbo.RequestCipl where IdStep IN (10032, 10033, 10035) AND [Status] = 'Draft'
				AND IdCipl IN (
					SELECT DISTINCT IdCipl 
					FROM dbo.CiplItemUpdateHistory 
					WHERE IdCargo = @IdCargo
				)
			
				IF (@totalWaitingApprove = 0)
				BEGIN
					SET @Result = 'Group';
				END 
				ELSE 
				BEGIN
					SET @Result = '-';
				END 
			END 
			ELSE 
			BEGIN
				SET @Result = 'Group';
			END 
		END
	END

	RETURN @Result;
END
GO
