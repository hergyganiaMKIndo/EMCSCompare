USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Insert_Temptable_gr_request_list_all]
AS
BEGIN
	DROP TABLE Temptable_gr_request_list_all;
	SELECT * INTO Temptable_gr_request_list_all  FROM fn_get_gr_request_list_all();
END
GO
