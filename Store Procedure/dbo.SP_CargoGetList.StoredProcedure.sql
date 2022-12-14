USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[SP_CargoGetList]
CREATE PROCEDURE [dbo].[SP_CargoGetList]
AS
BEGIN
	select 
		ca.Id as CargoID, ca.ClNo, ca.Consignee ConsigneeName, ca.NotifyParty NotifyName, ca.ExportType ExportType, ca.Category, ca.IncoTerms--, ci.Container
		--, ca.CargoDescription,
	,ca.StuffingDateStarted, ca.StuffingDateFinished, ca.VesselFlight, ca.ConnectingVesselFlight, ca.VoyageVesselFlight, ca.VoyageConnectingVessel, 
	ca.PortOfLoading, ca.PortOfDestination, ca.SailingSchedule, ca.ArrivalDestination, ca.BookingNumber, ca.BookingDate, ca.Liner, ca.ETA, ca.ETD
	from Cargo ca
	Where IsDelete = 0
 --   select ca.Id as ID, ca.ClNo as CLNo, ISNULL(cp.ConsigneeName, '-') as Consignee, CONVERT(VARCHAR(9), ca.ETA, 6) AS ETA, CONVERT(VARCHAR(9), ca.ETD, 6) AS ETD,
	--ISNULL(cp.ShippingMethod, '-') as ShippingMethod, ISNULL(cp.Forwader, '-') as Forwarder, 
	--ISNULL(ca.PortOfLoading, '-') as PortOfLoading, ISNULL(ca.PortOfDestination, '-') as PortOfDestination, f.Status
	--from Cargo ca
	--cross apply (
	--	select TOP 1 * from CargoItem where IdCargo = ca.Id
	--)ci
	--left join CiplItem cpi on ci.IdCipl = cpi.id
	--left join Cipl cp on cpi.IdCipl = cp.id
	--inner join RequestCl f on ca.Id = f.IdCl
END
GO
