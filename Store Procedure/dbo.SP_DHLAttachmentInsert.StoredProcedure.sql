USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SP_DHLAttachmentInsert]
@DHLShipmentID nvarchar(100)
, @LabelImageFormat nvarchar(50)
, @GraphicImage varchar(MAX)
, @UserId varchar(100)

As
Set Nocount On

Insert Into DHLAttachment (DHLShipmentID, ImageFormat, GraphicImage, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
Select DHLShipmentID=@DHLShipmentID, ImageFormat=@LabelImageFormat, GraphicImage=@GraphicImage, IsDelete=0, CreateBy=@UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate=NULL
GO
