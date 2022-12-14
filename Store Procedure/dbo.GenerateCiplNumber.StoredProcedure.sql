USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- EXEC [dbo].[GenerateCiplNumber] '1', 'ICT'
	-- EXEC [dbo].[GenerateCiplNumber] '1', 'XUPJ21ECH'
	CREATE PROCEDURE [dbo].[GenerateCiplNumber]
	(
	
	@ID bigint, @CreateBy nvarchar(255)
	)
	AS
	BEGIN
	       DECLARE @YEAR nvarchar(2), @MONTH nvarchar(2), @CIPLNO nvarchar(20), @DATE nvarchar(2), @LASTNUMBER nvarchar(20), @NEXTNUMBER int, 
		   @LASTVAL nvarchar(20), @CATEGORY bigint, @GETCATEGORY nvarchar(2), @DEPT nvarchar(4)
		   SET @YEAR = YEAR(GETDATE())%100
		   SET @MONTH = RIGHT( '0' + CAST( MONTH( GETDATE() ) AS varchar(2) ), 2 )  
		   SET @DATE = RIGHT( '0' + CAST( DAY( GETDATE() ) AS varchar(2) ), 2 ) 
		   
		   SELECT @LASTNUMBER = ISNULL(MAX(SUBSTRING(C.CiplNo,9,4)),0) FROM dbo.Cipl C where DATEPART(YEAR, CreateDate) = DATEPART(YEAR, GETDATE()) AND C.CreateBy <> 'System'
		   SET @NEXTNUMBER = CAST(@LASTNUMBER as int) + 1;
		   SET @LASTVAL = right('0000' + convert(varchar(4),@NEXTNUMBER),4) 
		   SELECT @DEPT = ISNULL((SELECT E.Dept_Code FROM employee E WHERE E.AD_User = @CreateBy), 'NULL')
		   SELECT @CIPLNO = 'E.' + @DATE + @MONTH + @YEAR + @LASTVAL + @DEPT
		   UPDATE dbo.Cipl SET CiplNo = @CIPLNO WHERE id = @ID
	
		   SELECT top 1 C.id as ID, @CIPLNO as [NO], C.CreateDate as CREATEDATE FROM Cipl C WHERE C.id = @ID
	
	END
GO
