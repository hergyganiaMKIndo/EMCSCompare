USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_UpdateFileForHistory]
(
@IdShippingFleet bigint,
@FileName nvarchar(max) = ''
)
as
begin
declare @Id  bigint 
insert  into ShippingFleetDocumentHistory(IdShippingFleet,FileName,CreateDate)
values (@IdShippingFleet,@FileName,GETDATE())
set @Id = SCOPE_IDENTITY()
select @Id As Id
end
GO
