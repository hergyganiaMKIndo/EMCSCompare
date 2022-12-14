USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[sp_get_flow_step]
CREATE PROCEDURE [dbo].[sp_get_flow_step] -- [dbo].[sp_get_flow_step] 0, 5, 'Id', 'ASC', '1',  '', 0
        -- Add the parameters for the stored procedure here
         @page int = 1,
         @limit int = 5,
         @sort nvarchar(100) = 'Id',
         @order nvarchar(100) = 'DESC',
		 @IdFlow nvarchar(10),
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
						THEN 'SELECT COUNT(*) as total' 
					ELSE 'SELECT 
								t0.Id
								, t0.IdFlow
								, t0.Step StepName
								, t0.AssignType
								, t0.AssignTo
								, t0.Sort
								, t1.Name FlowName
								, t1.Type FlowType' 
					END + ' FROM [dbo].[FlowStep] as t0 
							INNER JOIN [dbo].[Flow] as t1 on t1.Id = t0.IdFlow
							WHERE t0.IdFlow= '+@IdFlow+' '+
                    CASE WHEN ISNULL(@term, '') <> '' THEN ' AND (t0.Name like ''%'+@term+'%'') ' ELSE '' END +
                    CASE WHEN @isTotal = 0 THEN ' ORDER BY '+@sort+' '+@order+' OFFSET '+CAST(@offset as nvarchar(100))+' ROWS FETCH NEXT '+CAST(@limit as nvarchar(100))+' ROWS ONLY' ELSE '' END;
        --select @sql;
		execute(@sql);
		
END
GO
