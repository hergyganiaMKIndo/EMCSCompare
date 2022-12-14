USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_get_shipment_dhl_available] -- SP_get_cipl_available '', '1', '1' select * from dbo.Cipl
(
	@Search nvarchar(100) = '',
	@CiplList nvarchar(max) = '',
	@AwbId nvarchar(10) = '0',
	@ConsigneePic nvarchar(max) = '',
	@ConsigneeName nvarchar(max) = '',
	@ConsigneeTelephone nvarchar(max) = '',
	@ConsigneeEmail nvarchar(max) = '',
	@ConsigneeAddress nvarchar(max) = '',
	@ConsigneeCountry nvarchar(max) = ''
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql nvarchar(max);

	--SELECT c.Id, 
	--	c.CiplNo, 
	--	c.ConsigneeName, 
	--	c.ConsigneeAddress, 
	--	c.ConsigneeCountry, 
	--	c.ConsigneeTelephone, 
	--	c.ConsigneePic, 
	--	c.ConsigneeEmail 
	--FROM cipl c
	--JOIN requestcipl rc on rc.idcipl = c.id AND rc.isdelete = 0
	--WHERE c.isdelete = 0 AND rc.idstep = 10 and rc.status = 'Approve'

	SET @sql = 'SELECT c.Id, 
		c.CiplNo, 
		c.ConsigneeName, 
		c.ConsigneeAddress, 
		c.ConsigneeCountry, 
		c.ConsigneeTelephone, 
		c.ConsigneePic, 
		c.ConsigneeEmail 
	FROM cipl c
	JOIN requestcipl rc on rc.idcipl = c.id AND rc.isdelete = 0
	WHERE c.isdelete = 0 AND rc.idstep = 10 and rc.status = ''Approve'' ';

	SET @sql =	@sql + CASE WHEN ISNULL(@ConsigneeName, '') <> '' THEN 'AND c.ConsigneeName like ''%'+@ConsigneeName+'%''' ELSE '' END + 
				CASE WHEN ISNULL(@ConsigneeName, '') <> '' THEN 'AND c.ConsigneeAddress like ''%'+@ConsigneeAddress+'%''' ELSE '' END +  
				CASE WHEN ISNULL(@ConsigneeName, '') <> '' THEN 'AND c.ConsigneeCountry like ''%'+@ConsigneeCountry+'%''' ELSE '' END + 
				CASE WHEN ISNULL(@ConsigneeName, '') <> '' THEN 'AND c.ConsigneeTelephone like ''%'+@ConsigneeTelephone+'%''' ELSE '' END + 
				CASE WHEN ISNULL(@ConsigneeName, '') <> '' THEN 'AND c.ConsigneePic like ''%'+@ConsigneePic+'%''' ELSE '' END + 
				CASE WHEN ISNULL(@ConsigneeName, '') <> '' THEN 'AND c.ConsigneeEmail like ''%'+@ConsigneeEmail+'%''' ELSE '' END 
				--+
				--' AND t1.id NOT IN (
				--	SELECT IdCipl FROM dbo.cargocipl WHERE 1=1 AND isDelete = 0 '+ CASE WHEN @CargoId <> '0' THEN 'AND IdCargo <> '+@CargoId ELSE '' END +
				--')'

	EXECUTE(@sql);
END



GO
