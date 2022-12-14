USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RProblemHistory]
(
	@startdate nvarchar(100),
	@enddate nvarchar(100)
)	
AS
BEGIN	
	DECLARE @ProblemHistory TABLE (
		[ID] [bigint],
		ParentID [bigint], 
		[ReqType] [nvarchar](50),
		[Category] [nvarchar](100),
		[Cases] [nvarchar](200),
		[Causes] [nvarchar](MAX),
		[Impact] [nvarchar](MAX),
		[TotalCauses] [nvarchar](50),
		[TotalCases] [nvarchar](50),
		[TotalCategory] [nvarchar](50),
		[TotalCategoryPercentage] [nvarchar](50)
	)

	INSERT INTO @ProblemHistory
	SELECT 
		ROW_NUMBER() over(order by Category, Category ASC) as ID, 
		0 ParentID
		, '-' [ReqType]
		, Category
		, '-' [Cases]
		, '-' [Causes]
		, '-' [Impact]
		, '-' [TotalCauses]
		, '-' [TotalCases]
		, CAST(totalCategory as nvarchar(max)) [TotalCategory]
		, CAST([TotalCategoryPercentage] as nvarchar(max)) [TotalCategoryPercentage]
	FROM (
		select 
			Category
			,totalCategory 
			,round((totalCategory/totalAll) * 100, 0) as [TotalCategoryPercentage] 
			,'-' ReqType, '-' as Cases, '-' as Causes, '-' as Impact, '-' as TotalCauses, '-' as TotalCases
		from (
			select 
				t0.Category, 
				count(*) as totalCategory,
				(
					select cast(count(*) as decimal(16,2)) totalAllProblem 
					from dbo.ProblemHistory t3 
					where Category IS NOT NULL) as totalAll
			from dbo.ProblemHistory t0
			group by t0.Category
		) as totalProblemPerCategory
	) as result

	select * from @ProblemHistory

END
GO
