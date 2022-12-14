USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[sp_get_flow_next]
CREATE PROCEDURE [dbo].[sp_get_flow_next] -- [dbo].[sp_get_flow_next] 0, 5, 'Id', 'ASC', '1',  '', 0
        -- Add the parameters for the stored procedure here
         @page int = 1,
         @limit int = 5,
         @sort nvarchar(100) = 'Id',
         @order nvarchar(100) = 'DESC',
		 @IdStatus nvarchar(10),
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
					ELSE 'SELECT t0.*, t3.Step CurrentStep, t1.Status CurrentStatus, t2.Step NextStep, t2.Id NextIdStep, t1.IdStep CurrentIdStep' 
					END + ' from dbo.FlowNext t0 
							join dbo.FlowStatus t1 on t1.Id = t0.IdStatus
							join dbo.FlowStep t2 on t2.Id = t0.IdStep
							join dbo.FlowStep t3 on t3.Id = t1.IdStep
							WHERE t0.IdStatus= '+@IdStatus+''+
                    CASE WHEN ISNULL(@term, '') <> '' THEN ' AND (t3.Step like ''%'+@term+'%'' OR t1.Status like ''%'+@term+'%'') ' ELSE '' END +
                    CASE WHEN @isTotal = 0 THEN ' ORDER BY '+@sort+' '+@order+' OFFSET '+CAST(@offset as nvarchar(100))+' ROWS FETCH NEXT '+CAST(@limit as nvarchar(100))+' ROWS ONLY' ELSE '' END;
        --select @sql;
		execute(@sql);
		
END
GO
