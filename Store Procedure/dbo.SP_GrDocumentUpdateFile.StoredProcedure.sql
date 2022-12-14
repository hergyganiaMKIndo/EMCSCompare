USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_GrDocumentUpdateFile]
(
	@Id BIGINT,
	@Filename NVARCHAR(MAX) = '',
	@UpdateBy NVARCHAR(MAX) = ''
)
AS
BEGIN
 
	UPDATE dbo.GoodsReceiveDocument
	SET [Filename] = @Filename,
	[UpdateBy] = @Updateby,
	[UpdateDate] = GETDATE()
	WHERE Id = @Id;

END
GO
