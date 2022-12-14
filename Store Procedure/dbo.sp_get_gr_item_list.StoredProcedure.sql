USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_get_gr_item_list 2
CREATE procedure [dbo].[sp_get_gr_item_list]( -- exec sp_get_gr_item_list 2
	@IdGr bigint
)
as
begin
	select
		t1.CiplNo, 
		t1.EdoNo, 
		t1.DaNo,
		t1.Category,
		t0.Sn, 
		t0.Name,
		t0.PartNumber,
		t0.CaseNumber, 
		t0.Uom, 
		t0.CoO, 
		t0.Currency, 
		t0.JCode,
		t0.[Type],
		t0.YearMade,
		t0.ExtendedValue,
		t0.UnitPrice,
		t0.Quantity,
		t0.[Length],
		t0.Width,
		t0.Height,
		t0.GrossWeight,
		t0.NetWeight,
		t0.Volume
	from dbo.CiplItem t0
	inner join (
		select 
			tx0.DaNo
			, tx0.IdGr
			, tx0.DoNo
			, tx0.[FileName]
			, tx1.id IdCipl
			, tx1.Da
			, tx1.EdoNo
			, tx1.Category
			, tx1.CiplNo
			, tx1.DestinationPort
			, tx1.LoadingPort 
		From dbo.GoodsReceiveItem tx0
		left join dbo.Cipl tx1 on tx1.id = tx0.IdCipl where tx0.IdGr = @IdGr) t1 on t1.IdCipl = t0.IdCipl and t0.IsDelete = 0
end
GO
