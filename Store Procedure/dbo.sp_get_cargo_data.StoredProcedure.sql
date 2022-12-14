USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_get_cargo_data] -- sp_get_cargo_data 1
(
	@Id bigint
)
AS
BEGIN
	--DECLARE @Id bigint = 2;
	SELECT 
		t0.Id        
		, t0.ClNo        
		, t0.Consignee        
		, t0.NotifyParty        
		, t0.ExportType        
		, t0.Category        
		, t0.IncoTerms
		, CONCAT(t0.IncoTerms, ' - ', t6.[Name]) [IncotermsDesc]        
		, t0.StuffingDateStarted        
		, t0.StuffingDateFinished        
		, t0.TotalPackageBy
		, t0.VesselFlight        
		, t0.ConnectingVesselFlight        
		, t0.VoyageVesselFlight        
		, t0.VoyageConnectingVessel        
		, t0.PortOfLoading        
		, t0.PortOfDestination        
		, t0.SailingSchedule        
		, t0.ArrivalDestination        
		, t0.BookingNumber        
		, t0.BookingDate        
		, t0.Liner        
		, t0.ETA        
		, t0.ETD
		, t0.Referrence
		, t0.CreateDate
		, t0.CreateBy
		, t0.UpdateDate
		, t0.UpdateBy
		, CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Employee_Name ELSE t3.FullName END PreparedBy
		, CASE WHEN t2.Employee_Name IS NOT NULL THEN t2.Email ELSE t3.Email END Email
		, t4.Step
		, t5.[Status]
		, t5.ViewByUser [StatusViewByUser]
		, t0.CargoType
		, t0.ShippingMethod		
		, t7.[Name] CargoTypeName
		, STUFF((SELECT ', '+ISNULL(tx1.EdoNo, '-')
			FROM dbo.CargoItem tx0
			JOIN dbo.Cipl tx1 on tx1.id = tx0.IdCipl
			WHERE tx0.IdCargo = @Id
			GROUP BY tx1.EdoNo
			FOR XML PATH(''),type).value('.','nvarchar(max)'),1,1,'') [RefEdo]
		, t8.SlNo Si_No
		, t8.[Description] Si_Description
		, t8.DocumentRequired Si_DocumentRequired
		, t8.SpecialInstruction Si_SpecialInstruction
	FROM Cargo t0      
	JOIN dbo.RequestCl as t1 on t1.IdCl = t0.Id
	JOIN PartsInformationSystem.dbo.[UserAccess] t3 on t3.UserID = t0.CreateBy
	LEFT JOIN employee t2 on t2.AD_User = t0.CreateBy
	JOIN dbo.FlowStep t4 on t4.Id = t1.IdStep
	JOIN dbo.FlowStatus t5 on t5.[Status] = t1.[Status] AND t5.IdStep = t1.IdStep
	LEFT JOIN dbo.MasterIncoTerms t6 on t6.Number = t0.Incoterms
	LEFT JOIN dbo.MasterParameter t7 on t7.[Group] = 'CargoType' AND t7.Value = ISNULL(t0.CargoType,0)
	LEFT JOIN dbo.ShippingInstruction t8 on t8.IdCL = t0.Id
	WHERE 1=1 AND t0.Id = @Id;
END
GO
