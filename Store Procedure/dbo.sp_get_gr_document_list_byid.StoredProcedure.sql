USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_get_gr_document_list_byid] 
(
	@Id NVARCHAR(10),
	@IsTotal bit = 0,
	@sort nvarchar(100) = 'Id',
	@order nvarchar(100) = 'ASC',
	@offset nvarchar(100) = '0',
	@limit nvarchar(100) = '10'
)	
AS
BEGIN
	DECLARE @sql nvarchar(max);  
	SET @sql = 'SELECT ';
	SET @sort = 't0.'+@sort;

	IF (@IsTotal <> 0)
	BEGIN
		SET @sql += 'count(*) total'
	END 
	ELSE
	BEGIN
		SET @sql += 't0.Id
					 , t0.IdGr
					 , t0.DocumentDate
					 , t0.DocumentName
					 , t0.[Filename]
					 , '''' AS CreateBy
					 , t0.CreateDate
					 , t0.UpdateBy
					 , t0.UpdateDate
					 , t0.IsDelete '
	END
	SET @sql +=' FROM GoodsReceiveDocument t0  
	WHERE  IsDelete = 0 AND t0.Id = '+@Id;
	EXECUTE(@sql);
	
END

GO
