USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROCEDURE [dbo].[GenerateShippingSummaryNumber] -- [GenerateShippingSummaryNumber] 1, ''
	(
	
	@ID bigint , @DEPT nvarchar(10) 
	)
	AS
	BEGIN
		   SET NOCOUNT ON;
	       DECLARE @YEAR nvarchar(2), @MONTH nvarchar(2), @DATE nvarchar(2), @CIPLNO nvarchar(20), @LASTNUMBER nvarchar(20), @NEXTNUMBER int, @LASTVAL nvarchar(20)
		   SET @YEAR = YEAR(GETDATE())%100
		   SET @MONTH = RIGHT( '0' + CAST( MONTH( GETDATE() ) AS varchar(2) ), 2 )  
		   SET @DATE = RIGHT( '0' + CAST( DAY( GETDATE() ) AS varchar(2) ), 2 ) 
		   
		   SELECT @LASTNUMBER = SUBSTRING(MAX(SsNo), 10,4) FROM dbo.Cargo WHERE CreateBy <> 'System'
		   SET @NEXTNUMBER = ISNULL(CAST(@LASTNUMBER as int), 0) + 1;
		   SET @LASTVAL = right('0000' + convert(varchar(4),@NEXTNUMBER),4) 
		   
		   SELECT @CIPLNO = 'SS.' + @DATE + @MONTH + @YEAR + @LASTVAL;
	
		   update dbo.Cargo set SsNo = @CIPLNO where Id = @ID;
	END
GO
