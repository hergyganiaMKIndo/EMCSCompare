USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GRHistoryGetById] -- [dbo].[SP_GRHistoryGetById] 1
(
	@id NVARCHAR(10),
	@IsTotal bit = 0,
	@sort nvarchar(100) = 'CreateDate',
	@order nvarchar(100) = 'DESC',
	@offset nvarchar(100) = '0',
	@limit nvarchar(100) = '10'
)	
AS
BEGIN
DECLARE @sql nvarchar(max);  
	SET @sql = 'SELECT DISTINCT';
	SET @sort = 't0.'+@sort;

	IF (@IsTotal <> 0)
	BEGIN
		SET @sql += 'count(*) total'
	END 
	ELSE
	BEGIN
	SET @sql += ' t0.IdGr
				, t0.Flow
				, t0.Step
				, t0.Status
				, t3.ViewByUser
				, t0.Notes
				, t4.Employee_Name CreateBy
				, t0.CreateDate'
	END
	SET @sql +=' FROM GoodsReceiveHistory t0
					join Flow t2 on t2.Name = t0.Flow
					join FlowStep t1 on t1.Step = t0.Step AND t1.IdFlow = t2.Id
					join FlowStatus t3 on t3.[Status] = t0.[Status] AND t3.IdStep = t1.Id
					left join employee t4 on t4.AD_User = t0.CreateBy					
					WHERE t0.isdelete = 0 AND t0.IdGr = '+@id;
	IF @isTotal = 0 
	BEGIN
	SET @sql += ' ORDER BY t0.CreateDate DESC OFFSET '+@offset+' ROWS FETCH NEXT '+@limit+' ROWS ONLY';
	END 

	EXECUTE(@sql);
END

GO
