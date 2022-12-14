USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP PROCEDURE [dbo].[SP_GetCargoHeader]
CREATE PROCEDURE [dbo].[SP_GetCargoHeader]
	@CargoID bigint
AS
BEGIN
    select 
	ca.Id as CargoID, ca.ClNo, ca.Consignee ConsigneeName, ca.NotifyParty NotifyName, ca.ExportType ExportType, ca.Category, ca.IncoTerms
	,ca.StuffingDateStarted, ca.StuffingDateFinished, ca.VesselFlight, ca.ConnectingVesselFlight, ca.VoyageVesselFlight, ca.VoyageConnectingVessel, 
	ca.PortOfLoading, ca.PortOfDestination, ca.SailingSchedule, ca.ArrivalDestination, ca.BookingNumber, ca.BookingDate, ca.Liner, ca.ETA, ca.ETD
	from Cargo ca
	where ca.Id = @CargoID
END
GO
