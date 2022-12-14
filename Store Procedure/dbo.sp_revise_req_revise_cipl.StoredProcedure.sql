USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ali Mutasal
-- Create date: 24 Nov 2019
-- Description:	sp jika requestor cipl tidak setuju dengan perubahan dimension di cargo
-- =============================================
CREATE PROCEDURE [dbo].[sp_revise_req_revise_cipl] 
	-- Add the parameters for the stored procedure here
	@ciplid bigint, 
	@username nvarchar = 100
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @clid bigint;

	select TOP 1 @clid = IdCargo from dbo.CiplItemUpdateHistory where IdCipl = @ciplid;

	exec sp_update_request_cl @clid, @username, 'Revise', ''
    -- Insert statements for procedure here
	--SELECT @p1, @p2
END
GO
