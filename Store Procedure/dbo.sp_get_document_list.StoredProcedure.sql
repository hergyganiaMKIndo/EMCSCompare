USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_document_list] --[dbo].[sp_get_document_list] 1, 'cipl'
(
	@id NVARCHAR(10),
	@category nvarchar(100) = 'CIPL',
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
		SET @sql += 't0.ID
					 , t0.Step
					 , t0.[Status]
					 , t0.[Name]
					 , t0.IdRequest
					 , t0.Category
					 , t0.[Date]
					 , t0.[FileName]
					 , t0.CreateBy
					 , t0.CreateDate
					 , t0.UpdateBy
					 , t0.UpdateDate
					 , t2.Employee_Name as PIC '
	END
	SET @sql +=' FROM Documents t0 
	JOIN employee t2 on t2.AD_User = t0.CreateBy   
	WHERE  t0.Category= '''+@category+''' and t0.IDRequest = '+@id;
	EXECUTE(@sql);
	--select @sql;
END
GO
