USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROCEDURE [dbo].[GenerateEDONumber_20210414] -- [GenerateEDONumber] '1', 'xupj21ech'
	(
		@ID bigint, 
		@CreateBy nvarchar(255)
	)
	AS
	BEGIN
	       DECLARE @YEAR nvarchar(2), @MONTH nvarchar(2), @EDONUMBER nvarchar(20), @DATE nvarchar(2), @LASTNUMBER nvarchar(20), 
		   @NEXTNUMBER int, @LASTVAL nvarchar(20), @DEPT nvarchar(2)
		   SET @YEAR = YEAR(GETDATE())%100
		   SET @MONTH = RIGHT( '0' + CAST( MONTH( GETDATE() ) AS varchar(2) ), 2 )  
		   SET @DATE = RIGHT( '0' + CAST( DAY( GETDATE() ) AS varchar(2) ), 2 ) 
		   
		   SELECT @LASTNUMBER = ISNULL(MAX(SUBSTRING(C.EdoNo,10,4)),0) FROM dbo.Cipl C WHERE C.CreateBy <> 'System'
		   SET @NEXTNUMBER = CAST(@LASTNUMBER as int) + 1;
		   SET @LASTVAL = right('0000' + convert(varchar(4),@NEXTNUMBER),4) 
		   SELECT @DEPT = E.Dept_Code  FROM employee E WHERE E.AD_User = @CreateBy
		   SELECT @EDONUMBER = 'DO.' + @DATE + @MONTH + @YEAR + @LASTVAL + @DEPT
		   --SELECT @CIPLNO = 'E.' + CAST(MU.RoleID AS nvarchar(10)) + @DATE + @MONTH + @YEAR + @LASTVAL + @DEPT  FROM dbo.MasterUser MU WHERE ID = @ID
		   UPDATE dbo.Cipl SET EdoNo = @EDONUMBER WHERE id = @ID
	END
GO
