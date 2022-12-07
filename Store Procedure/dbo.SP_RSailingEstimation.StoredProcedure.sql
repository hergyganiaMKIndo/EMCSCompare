USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_RSailingEstimation]
	-- Add the parameters for the stored procedure here
	@origin varchar(50),
	@destination varchar(50)
AS
BEGIN
DECLARE @SQL as nvarchar(Max)
declare @whereRef nvarchar(max) =''
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	IF @origin <>'' 
	BEGIN
    	SET @whereRef=' and ConsigneeCountry = '''' + @origin +'''''
	 END
	 print (@whereRef)
   IF @destination <>''
	BEGIN
    	SET @whereRef+=' and SoldToCountry = '''' + @destination +'''''
	 END
    -- Insert statements for procedure here
SET @SQL = 'SELECT * FROM [Fn_RSailingEstimation]() WHERE 1=1 '+ @whereRef
   
	  exec(@SQL);
END
GO
