USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_remove_CiplItem]
	-- Add the parameters for the stored procedure here
	@idCIPL BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE CiplItem SET ISDELETE = 1 WHERE IDCIPL = @idCIPL
END

GO
