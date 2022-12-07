USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_GRDocumentAdd]
(
	@Id BIGINT,
	@IdGr BIGINT,
	@DocumentDate datetime,
	@DocumentName NVARCHAR(MAX) = '',
	@Filename NVARCHAR(MAX) = '',
	@CreateBy NVARCHAR(50),
	@CreateDate datetime,
	@UpdateBy NVARCHAR(50),
	@UpdateDate datetime,
	@IsDelete BIT
)
AS
BEGIN
	IF @Id <= 0
	BEGIN
	INSERT INTO [dbo].[GoodsReceiveDocument]
           ([IdGr]
		   ,[DocumentDate]
		   ,[DocumentName]
		   ,[Filename]
           ,[CreateBy]
           ,[CreateDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsDelete]
           )
     VALUES
           (@IdGr
			,@DocumentDate
			,@DocumentName
			,@Filename
			,@CreateBy
			,@CreateDate
			,@UpdateBy
			,@UpdateDate
			,@IsDelete
		   )

	END
	ELSE 
	BEGIN
	UPDATE dbo.GoodsReceiveDocument
	SET [DocumentDate] = @DocumentDate
		   ,[DocumentName] = @DocumentName
	WHERE Id = @Id;
	END

END
GO
