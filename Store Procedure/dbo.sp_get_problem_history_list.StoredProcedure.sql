USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_problem_history_list] --[dbo].[sp_get_problem_history_list] 1
(
	@id NVARCHAR(10),
	@Type Nvarchar(100) = 'CIPL',
	@IsTotal bit = 0,
	@sort nvarchar(100) = 'ID',
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
				   , t0.ReqType
				   , t0.Category
				   , t0.[Case]
				   , t0.Causes
				   , t0.Impact
				   , t0.Comment
				   , t0.CaseDate
				   , CASE WHEN ISNULL(t2.Employee_Name, '''') <> '''' THEN t2.Employee_Name ELSE t3.FullName END as PIC'
	END
	SET @sql +=' FROM ProblemHistory t0 
	join employee t2 on t2.AD_User = t0.CreateBy
	left join [PartsInformationSystem].[dbo].[UserAccess] t3 on t3.UserID = t0.CreateBy
	WHERE  t0.ReqType= '''+@Type+''' and t0.IDRequest = '+@id;
	--select @sql;
	EXECUTE(@sql);
END
GO
