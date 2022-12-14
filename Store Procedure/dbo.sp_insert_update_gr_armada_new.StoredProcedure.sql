USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--DROP PROCEDURE sp_insert_update_gr
CREATE PROCEDURE [dbo].[sp_insert_update_gr_armada_new] --exec sp_insert_update_gr 0, 'Tri Artha', '3211022907890004', '234002000', '32001000', 'Z5226BW', '20 Jan 2020', 'testing notes dan lain lain', 'xupj21fig', '20 Jan 2019', 'xupj21fig', '29 Jan 2019', 0 
(
	@Id nvarchar(100),
	@DoNo nvarchar(100),
	@IdGr bigint,
	@PicName nvarchar(100),
	@PhoneNumber nvarchar(100),
	@KtpNumber nvarchar(100),
	@SimNumber nvarchar(100),
	@SimExpiryDate smalldatetime,
	@StnkNumber nvarchar(100),
	@KirNumber nvarchar(50),
	@KirExpire smalldatetime,
	@NoPolNumber nvarchar(100),
	@EstimationTimePickup date,
	@Apar bit,
	@Apd bit,
	@DoReference nvarchar(100),
	@Notes nvarchar(MAX) = '',
	@VehicleType nvarchar(100),
	@VehicleMark nvarchar(100)

)
AS
BEGIN
	SET NOCOUNT ON;
	IF ISNULL(@Id, 0) = 0 
	BEGIN
		INSERT INTO [dbo].[GoodsReceiveArmadaNew]
           (
			  [DoNo]
			, [IdGr]
			, [PicName]
			, [PhoneNumber]
			, [KtpNumber]
			, [SimNumber]
			, [SimExpiryDate]
			, [StnkNumber]
			, [KirNumber]
			, [KirExpire]
			, [NoPolNumber]
			,[EstimationTimePickup]
			,[Apar]
			,[Apd]
			,[DoReference]
			,[Notes]
			,[VehicleType]
			,[VehicleMark])

		VALUES
           (@DoNo
			, @IdGr
			, @PicName
			, @PhoneNumber
			, @KtpNumber
			, @SimNumber
			, @SimExpiryDate
			,@StnkNumber
			, @KirNumber
			,@KirExpire
			,@NoPolNumber
			,@EstimationTimePickup
			,@Apar
			,@Apd
			,@DoReference
			,@Notes
			,@VehicleType
			,@VehicleMark)

		SET @Id = SCOPE_IDENTITY()
	END
	ELSE 
	BEGIN
		UPDATE [dbo].[GoodsReceiveArmadaNew]
		SET    [Notes] = @Notes
			  ,[DoReference] = @DoReference		
		      ,[VehicleType] = @VehicleType
		      ,[VehicleMark] = @VehicleMark
		
		
		WHERE Id = @Id

	END
	SELECT CAST(@Id as bigint) as ID
END

GO
