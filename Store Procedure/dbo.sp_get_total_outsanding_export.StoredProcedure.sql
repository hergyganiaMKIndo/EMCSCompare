USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_get_total_outsanding_export]
AS
BEGIN
	select 
		count(*) as total
	from dbo.Cipl t0 
	left join dbo.CargoCipl t1 on t1.IdCipl = t0.id
	left join dbo.BlAwb t2 on t2.IdCl = t1.IdCargo
	left join dbo.NpePeb t3 on t2.IdCl = t1.IdCargo
	left join dbo.ShippingInstruction t4 on t2.IdCl = t1.IdCargo
	left join dbo.GoodsReceiveItem t5 on t5.IdCipl = t0.id
	where t2.Id IS NULL AND t0.CreateBy <>'SYSTEM'
END
GO
