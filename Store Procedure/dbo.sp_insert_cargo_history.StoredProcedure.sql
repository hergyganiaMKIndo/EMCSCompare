USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [sp_insert_cargo_history];
CREATE PROCEDURE [dbo].[sp_insert_cargo_history]
(
	@Id bigint,
	@Flow nvarchar(100),
	@Step nvarchar(100),
	@Status nvarchar(100),
	@Notes nvarchar(max) = '',
	@CreateBy nvarchar(100),
	@CreateDate datetime
)
AS 
BEGIN
	INSERT INTO [dbo].[CargoHistory]
       ([IdCargo],[Flow],[Step],[Status],[Notes],[CreateBy],[CreateDate],[UpdateBy],[UpdateDate],[IsDelete])
     VALUES
       (@Id,@Flow,@Step,@Status,@Notes,@CreateBy,@CreateDate,@CreateBy,GETDATE(),0)
END
GO
