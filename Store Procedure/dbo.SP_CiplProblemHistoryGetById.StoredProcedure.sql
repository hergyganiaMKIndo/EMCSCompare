USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CiplProblemHistoryGetById] --[dbo].[SP_CiplProblemHistoryGetById] 1
(
	@id NVARCHAR(10),
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
		SET @sql += 't1.id
				   , t0.ReqType
				   , t0.Category
				   , t0.[Case] as CiplCase
				   , t0.Causes
				   , t0.Impact
				   , t0.CaseDate
				   , t2.Employee_Name as PIC'
	END
	SET @sql +=' FROM ProblemHistory t0 
	join Cipl t1 on t0.IDRequest = t1.id
	join employee t2 on t2.AD_User = t0.CreateBy
	WHERE  t0.ReqType= ''Cipl'' and t1.id = '+@id;
	--select @sql;
	EXECUTE(@sql);
	--print(@sql);
END
GO
