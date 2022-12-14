USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_insert_cipl_history;
CREATE PROCEDURE [dbo].[sp_insert_update_problem_history]
(
	@ReqType nvarchar(100),
	@IDRequest nvarchar(100),
	@Category nvarchar(100),
	@Case nvarchar(100),
	@Causes nvarchar(100),
	@Impact nvarchar(100),
	@Comment nvarchar(max),
	@CaseDate nvarchar(100),
	@CreateBy nvarchar(100),
	@CreateDate nvarchar(100),
	@UpdateBy nvarchar(100),
	@UpdateDate nvarchar(100),
	@IdStep nvarchar(100),
	@Status nvarchar(100),
	@IsDelete nvarchar(100) = '0'
)
AS 
BEGIN
	SET NOCOUNT ON;  
	DECLARE @sql nvarchar(max);
	DECLARE @Id bigint;
	SET @sql = 'INSERT INTO [dbo].[ProblemHistory](
					[ReqType],[IDRequest],[Category],[Case],[Causes],[Impact],[Comment],[CaseDate],[CreateBy],[CreateDate],[UpdateBy],[UpdateDate],[IsDelete],[IdStep],[Status])
				VALUES	
					('''+@ReqType+''','''+@IDRequest+''','''+@Category+''','''+@Case+''','''+@Causes+''','''+@Impact+''','''+@Comment+''','''+@CaseDate+''','''+@CreateBy+''','''+@CreateDate+''','''+@UpdateBy+''','''+@UpdateDate+''','''+@IsDelete+''', '''+@IdStep+''', '''+@Status+''')';
	--select @sql;
	execute(@sql);
	select CAST(@@IDENTITY as bigint) ID
END
GO
