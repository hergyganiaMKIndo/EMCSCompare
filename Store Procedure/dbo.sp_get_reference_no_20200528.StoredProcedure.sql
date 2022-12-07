USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_reference_no_20200528] -- EXEC [sp_get_reference_no] 'REMAN', '', 'QuotationNO'
(
	@Category nvarchar(100), 
	@ReferenceNo nvarchar(100) = '',
	@CategoryReference nvarchar(100)
)
AS
BEGIN
-- select * from dbo.Reference
	SET NOCOUNT ON;
	DECLARE @SQL nvarchar(max);
	IF(@Category = 'REMAN') 
	BEGIN 
		SET @SQL = 'select DISTINCT "'+@CategoryReference+'" as ReferenceNo, IdCustomer, Category from dbo.Reference where 1=1 and AvailableQuantity > 0';
	END
	ELSE
	BEGIN 
		SET @SQL = 'select DISTINCT "'+@CategoryReference+'" as ReferenceNo, IdCustomer, Category from dbo.Reference where 1=1 and AvailableQuantity > 0';	
	END
	

	IF (ISNULL(@Category, '') <> '')
	BEGIN
		SET @SQL = @SQL + ' AND Category='''+@Category+'''';
	END

	IF (ISNULL(@ReferenceNo, '') <> '')
	BEGIN
		SET @SQL = @SQL + ' AND "'+@CategoryReference+'" like ''%'+@ReferenceNo+'%''';
	END

	EXECUTE(@SQL);
END
GO
