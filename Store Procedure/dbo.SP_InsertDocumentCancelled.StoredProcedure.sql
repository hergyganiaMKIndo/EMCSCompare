USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_InsertDocumentCancelled](
@id bigint ,
@FileName nvarchar(max)
)
as
begin
update NpePeb
set CancelledDocument = @FileName
where Id = @id
end
GO
