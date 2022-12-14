USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[sp_get_cargo_item_data]
CREATE PROCEDURE [dbo].[sp_get_cargo_item_data_20210721] -- [dbo].[sp_get_cargo_item_data] 1
(
	@Id nvarchar(100) = ''
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql nvarchar(max);  

	SET @sql = 'SELECT TOP 1 ';
	BEGIN
		SET @sql += 't0.Id ID    
					,t1.Id IdCargoItem
					,t2.Id IdCargo
					,t0.IdCipl      
					,t0.IdCiplItem           
					,t3.CiplNo                 
					,t2.Incoterms IncoTerm                 
					,t2.Incoterms IncoTermNumber                 
					,t1.CaseNumber                 
					,t3.EdoNo                 
					,t4.DaNo InboundDa                 
					,t0.Length                 
					,t0.Width                 
					,t0.Height                
					,t0.Net NetWeight                 
					,t1.Sn        
					,t1.PartNumber        
					,t1.Ccr        
					,t1.Quantity        
					,t1.Name ItemName        
					,t1.JCode        
					,t1.ReferenceNo              
					,t0.Gross GrossWeight                 
					,CAST(1 as bit) state        
					,t2.Category CargoDescription        
					,t0.ContainerNumber
					,t5.Description ContainerType
					,t0.ContainerSealNumber'
		END
			SET @sql +='
					FROM dbo.CargoItem t0
					JOIN dbo.CiplItem t1 on t1.Id = t0.IdCiplItem
					JOIN dbo.Cargo t2 on t2.Id = t0.IdCargo
					JOIN dbo.Cipl t3 on t3.id = t1.IdCipl
					LEFT JOIN dbo.GoodsReceiveItem t4 on t4.DoNo = t3.EdoNo
					LEFT JOIN dbo.MasterParameter t5 on t5.Value = t0.ContainerType AND t5.[Group] = ''ContainerType''
					WHERE 1=1 AND t0.Id='+@Id+' ';
	--select @sql;
	EXECUTE(@sql);
END
GO
