USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RDetailsTracking] 
	@StartMonth NVARCHAR(20),
	@EndMonth NVARCHAR(20),
	@ParamName NVARCHAR(50),
	@ParamValue NVARCHAR(200),
	@KeyNum NVARCHAR(200)
AS
BEGIN
DECLARE @SQL as nvarchar(Max)
declare @whereRef nvarchar(max) =''

IF @StartMonth <>'' AND @EndMonth<>''
	BEGIN
    	SET @whereRef=' AND CiplDate >= '''+ @StartMonth +''' AND CiplDate <= '''+ @EndMonth +''' '
	 END
	 print (@whereRef)

	  IF @ParamName <>''
	BEGIN
    	SET @whereRef+=' and DescGoods = ''' + @ParamName  +''''
	 END
	  IF @ParamValue <>''
	BEGIN
    	SET @whereRef+=' and CategoriItem = ''' + @ParamValue +'''' 
	 END
	IF @KeyNum <> ''
	BEGIN
    	SET @whereRef+=' AND CiplNo = '''+ @KeyNum +''' or RGNo = '''+ @KeyNum +''' or ClNo ='''+ @KeyNum +''' or SsNo = '''+ @KeyNum +''' or SINo = '''+ @KeyNum +''' or NOPEN = '''+ @KeyNum +''''
	 END
    -- Insert statements for procedure here
SET @SQL = 'SELECT * FROM [fn_GetReportDetailTracking_RDetails]() WHERE CIPLNo<>'''' '+ @whereRef + ' ORDER BY CiplDate ASC'
   print @whereRef
    print @SQL
	  exec(@SQL);
END

GO
