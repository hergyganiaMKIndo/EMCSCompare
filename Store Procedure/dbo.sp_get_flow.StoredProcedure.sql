USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[sp_get_flow]
CREATE PROCEDURE [dbo].[sp_get_flow] -- [dbo].[sp_get_flow] 0, 5, 'Id', 'ASC', '', 0
        -- Add the parameters for the stored procedure here
         @page int = 1,
         @limit int = 5,
         @sort nvarchar(100) = 'Id',
         @order nvarchar(100) = 'DESC',
         @term nvarchar(100) = '', 
         @isTotal bit = 0
AS
BEGIN
        SET NOCOUNT ON;
        DECLARE @sql nvarchar(max);
		DECLARE @offset int;
		SET @offset = @page;
		--if @page > 1 
		--BEGIN 
		--	SET @offset = ((@page - 1) * @limit);
		--END

        SET @sql = CASE 
					WHEN @isTotal = 1 
						THEN 'SELECT COUNT(*) as total' 
					ELSE 'SELECT CAST(Id as bigint) Id, Name, Type, CreateBy, CreateDate, UpdateBy, UpdateDate, IsDelete' 
					END + ' FROM [dbo].[Flow] as t0 WHERE 1=1 '+
                    CASE WHEN ISNULL(@term, '') <> '' THEN ' AND (t0.Name like ''%'+@term+'%'') ' ELSE '' END +
                    CASE WHEN @isTotal = 0 THEN ' ORDER BY '+@sort+' '+@order+' OFFSET '+CAST(@offset as nvarchar(100))+' ROWS FETCH NEXT '+CAST(@limit as nvarchar(100))+' ROWS ONLY' ELSE '' END;
        --select @sql;
		execute(@sql);
		
END
GO
