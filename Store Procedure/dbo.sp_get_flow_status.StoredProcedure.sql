USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[sp_get_flow_status]
CREATE PROCEDURE [dbo].[sp_get_flow_status] -- [dbo].[sp_get_flow_status] 0, 5, 'Id', 'ASC', '1',  '', 0
         @page int = 1,
         @limit int = 5,
         @sort nvarchar(100) = 'Id',
         @order nvarchar(100) = 'DESC',
		 @IdStep nvarchar(10),
         @term nvarchar(100) = '', 
         @isTotal bit = 0
AS
BEGIN
        SET NOCOUNT ON;
        DECLARE @sql nvarchar(max);
		DECLARE @offset int;
		SET @offset = @page;
		--if @page > 0 
		--BEGIN 
		--	SET @offset = ((@page - 1) * @limit);
		--END

        SET @sql = CASE 
					WHEN @isTotal = 1 
						THEN 'SELECT COUNT(*) as total ' 
					ELSE 'SELECT t0.*, t1.IdFlow, t1.Step StepName, t1.AssignType, t1.AssignTo, t2.Name FlowName ' END 
					+ 'FROM dbo.FlowStatus t0
					   JOIN dbo.FlowStep t1 on t1.Id = t0.IdStep
					   JOIN dbo.flow t2 on t2.Id = t1.IdFlow
					   WHERE t0.IdStep= '+@IdStep+' '+
                    CASE WHEN ISNULL(@term, '') <> '' THEN ' AND (t0.Status like ''%'+@term+'%'') ' ELSE '' END +
                    CASE WHEN @isTotal = 0 THEN ' ORDER BY '+@sort+' '+@order+' OFFSET '+CAST(@offset as nvarchar(100))+' ROWS FETCH NEXT '+CAST(@limit as nvarchar(100))+' ROWS ONLY' ELSE '' END;
        --select @sql;
		execute(@sql);
		
END
GO
