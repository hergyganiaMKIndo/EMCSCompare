USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [sp_insert_update_gr_item]
CREATE PROCEDURE [dbo].[sp_insert_update_gr_item] --exec [sp_insert_update_gr_item] 0, 'Tri Artha', '3211022907890004', '234002000', '32001000', 'Z5226BW', '20 Jan 2020', 'testing notes dan lain lain', 'xupj21fig', '20 Jan 2019', 'xupj21fig', '29 Jan 2019', 0 
(
	@Id nvarchar(100),
	@IdCipl nvarchar(100),
	@IdGr nvarchar(100),
	@DoNo nvarchar(100),
	@DaNo nvarchar(100),
	@FileName	nvarchar(100),
	@CreateBy nvarchar(100),
	@CreateDate nvarchar(100),
	@UpdateBy nvarchar(100) = '',
	@UpdateDate nvarchar(100) = '',
	@IsDelete bit = 0
)
AS
BEGIN
	SET NOCOUNT ON;
	IF ISNULL(@Id, 0) = 0 
	BEGIN
		INSERT INTO [dbo].[GoodsReceiveItem]
           ([IdGr],[IdCipl],[DoNo],[DaNo],[FileName],[CreateDate],[CreateBy],[UpdateDate],[UpdateBy],[IsDelete])
		VALUES
           (@IdGr, @IdCipl, @DoNo, @DaNo, @FileName, @CreateDate, @CreateBy, @UpdateDate, @UpdateBy, @IsDelete)

		SET @Id = SCOPE_IDENTITY()
	END
	ELSE 
	BEGIN
		UPDATE [dbo].[GoodsReceiveItem] SET 
			  IdGr = @IdGr
			  , IdCipl = @IdCipl
			  , DoNo = @DoNo
			  , DaNo = @DaNo
			  , FileName = @FileName
		      ,[UpdateBy] = @UpdateBy
		      ,[UpdateDate] = @UpdateDate
		      ,[IsDelete] = @IsDelete
		WHERE Id = @Id
	END
	SELECT CAST(@Id as bigint) as ID
END

GO
