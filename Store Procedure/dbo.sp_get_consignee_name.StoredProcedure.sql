USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_consignee_name]
	(
	@ReferenceNo NVARCHAR(100) = ''
	,@Category NVARCHAR(100) = ''
	,@CategoryReference NVARCHAR(100) = ''
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(max);

	IF @CategoryReference = 'Other'
		BEGIN
			SET @CategoryReference = 'Email'
		END


	SET @sql = 'SELECT ';
	BEGIN
		SET @sql += 'DISTINCT ConsigneeName 
		,IdCustomer
		,Street 
		,City 
		,PIC
		,Fax 
		,Telephone 
		,Email 
		,Currency';
	END

	SET @sql += ' FROM Reference'

		--SET @SQL = @SQL + ' WHERE '+@Column+' = '''+@ColumnValue+''' AND Category = '''+@Category+'''  AND AvailableQuantity > 0';
		SET @SQL = @SQL + ' WHERE '+@CategoryReference+' IN (SELECT F.splitdata FROM [dbo].[fnSplitString](''' + @ReferenceNo + ''', '','') F)  AND Category = ''' + @Category + '''  AND AvailableQuantity > 0';

	EXECUTE (@sql);
END


GO
