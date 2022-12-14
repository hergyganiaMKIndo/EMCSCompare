USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[GenerateGoodsReceiveNumber]
CREATE PROCEDURE [dbo].[GenerateGoodsReceiveNumber]
(

@ID bigint 
)
AS
BEGIN
		SET ANSI_WARNINGS OFF;
	   SET NOCOUNT ON;
       DECLARE @YEAR nvarchar(4), @MONTH nvarchar(20), @GRNO nvarchar(20), @DATE nvarchar(2), @LASTNUMBER nvarchar(20), @NEXTNUMBER int, @LASTVAL nvarchar(20)
	   SET @YEAR = YEAR(GETDATE())
	   SET @MONTH = RIGHT( '0' + CAST( MONTH( GETDATE() ) AS varchar(2) ), 2 )  
	   SET @DATE = RIGHT( '0' + CAST( DAY( GETDATE() ) AS varchar(2) ), 2 ) 
	   
	   SELECT @LASTNUMBER = ISNULL(MAX(SUBSTRING(G.GrNo,12,4)),0) FROM dbo.GoodsReceive G
	   SET @NEXTNUMBER = CAST(@LASTNUMBER as int) + 1;
	   SET @LASTVAL = right('0000' + convert(varchar(4),@NEXTNUMBER),4) 
	   --SELECT @CIPLNO = 'E.' + CAST(MU.RoleID AS nvarchar(10)) + @DATE + @MONTH + @YEAR + @LASTVAL + @DEPT  FROM dbo.MasterUser MU WHERE ID = @ID
	   SELECT @GRNO = 'GR.' + @DATE + @MONTH + @YEAR + @LASTVAL
	   
	   UPDATE [dbo].[GoodsReceive] SET GrNo = @GRNO WHERE Id = @ID 
END

GO
