USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ali Mutasal
-- Create date: 24 Nov 2019
-- Description:	sp untuk mengambil data request perubahan cipl berdasarkan cipl id
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_req_revise_cipl] 
	-- Add the parameters for the stored procedure here
	@ciplid nvarchar = 100, 
	@username nvarchar = 100
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT @ciplid, @username
	SELECT 
		t0.IdCipl
		, t0.IdCiplItem
		, t0.IdCargo
		, t2.[Name] ItemName
		, t2.CaseNumber 
		, t2.Sn
		, t2.Ccr
		, t2.ExtendedValue
		, t2.JCode
		, t2.Type
		, t2.Uom
		, t2.PartNumber
		, t2.Quantity
		, t2.YearMade
		, t0.OldHeight
		, t0.NewHeight
		, t0.OldWidth
		, t0.NewWidth
		, t0.OldLength
		, t0.NewLength
		, t0.OldNetWeight
		, t0.NewNetWeight
		, t0.OldGrossWeight
		, t0.NewGrossWeight
	FROM dbo.CiplItemUpdateHistory t0 
	left join dbo.Cipl t1 on t1.id = t0.IdCipl
	left join dbo.CiplItem t2 on t2.Id = t0.IdCiplItem and t2.IdCipl = t1.id
	where t0.IdCipl = @ciplid AND t0.IsApprove = 0;
END
GO
