USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROCEDURE [dbo].[GenerateCargoNumber]
		@ID bigint
	AS
	BEGIN
		   
		DECLARE @YEAR nvarchar(2), @MONTH nvarchar(2), @DATE nvarchar(2), @CURRENTNUMBER int, @NEXTNUMBER varchar(4)
		SET @YEAR = YEAR(GETDATE())%100
		SET @MONTH = RIGHT( '0' + CAST( MONTH( GETDATE() ) AS varchar(2) ), 2 )  
		SET @DATE = RIGHT( '0' + CAST( DAY( GETDATE() ) AS varchar(2) ), 2 ) 
	
		select @CURRENTNUMBER = ISNULL(MAX(SUBSTRING(ClNo,11,4)), 0) FROM dbo.Cargo where DATEPART(YEAR, CreateDate) = DATEPART(YEAR, GETDATE()) AND CreateBy <> 'System'
		select @NEXTNUMBER = right('0000' + convert(varchar(4), @CURRENTNUMBER + 1),4)
	
		UPDATE dbo.Cargo SET ClNo = 'CL.' + @DATE + @MONTH + @YEAR + @NEXTNUMBER WHERE id = @ID
	END
GO
