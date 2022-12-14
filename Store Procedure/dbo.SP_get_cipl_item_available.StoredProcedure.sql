USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_get_cipl_item_available] -- SP_get_cipl_item_available 6, 1
(
	@idCipl nvarchar(max) = '',
	@idCargo nvarchar(100) = ''
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL nvarchar(max);
	DECLARE @WHERE nvarchar(max) = '';
	IF ISNULL(@idCipl, '') <> '' 
	BEGIN
		SET @WHERE = ' AND t0.IdCipl IN ('+@idCipl+') AND t0.Id NOT IN (select IdCiplItem from dbo.CargoItem where IdCargo = '+@idCargo+' and isDelete = 0)'; 
	END

	SET @SQL = 'SELECT t0.*
				FROM dbo.CiplItem as t0
				JOIN dbo.Cipl as t1 on t1.id = t0.IdCipl
				WHERE 1=1 AND t0.IsDelete = 0 '+ @WHERE; 

	--PRINT @SQL;
	EXECUTE(@SQL);
END

GO
