USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--DROP PROCEDURE sp_insert_update_gr
CREATE PROCEDURE [dbo].[sp_insert_update_gr] --exec sp_insert_update_gr 0, 'Tri Artha', '3211022907890004', '234002000', '32001000', 'Z5226BW', '20 Jan 2020', 'testing notes dan lain lain', 'xupj21fig', '20 Jan 2019', 'xupj21fig', '29 Jan 2019', 0 
(
	@Id nvarchar(100),
	@PicName nvarchar(100),
	@KtpName nvarchar(100),
	@PhoneNumber nvarchar(100),
	@SimNumber nvarchar(100),
	@StnkNumber	nvarchar(100),
	@NopolNumber nvarchar(100),
	@EstimationTimePickup date,
	@Notes nvarchar(max),
	@Vendor nvarchar(100),
	@KirNumber nvarchar(50),
	@KirExpire date,
	@Apar bit,
	@Apd bit,
	@VehicleType nvarchar(100),
	@VehicleMerk nvarchar(100),
	@CreateBy nvarchar(100),
	@CreateDate date,
	@UpdateBy nvarchar(100) = '',
	@UpdateDate date,
	@IsDelete bit = 0,
	@SimExpiryDate date,
	@ActualTimePickup date,
	@Status nvarchar(100) = 'Draft',
	@PickupPoint nvarchar(100) = '',
	@PickupPic nvarchar(100) = ''
)
AS
BEGIN
	SET NOCOUNT ON;
	IF ISNULL(@Id, 0) = 0 
	BEGIN
		INSERT INTO [dbo].[GoodsReceive]
           ([PicName]
			, [KtpNumber]
			, [PhoneNumber]
			, [SimNumber]
			, [StnkNumber]
			, [NopolNumber]
			, [EstimationTimePickup]
			, [Notes]
			, [Vendor]
			, [KirNumber]
			, [KirExpire]
			, [Apar]
			, [Apd]
			, [VehicleType]
			, [VehicleMerk]
			, [CreateBy]
			, [CreateDate]
			, [UpdateBy]
			, [UpdateDate]
			, [SimExpiryDate]
			, [PickupPoint]
			, [PickupPic]
			, [IsDelete])
		VALUES
           (@PicName
			, @KtpName
			, @PhoneNumber
			, @SimNumber
			, @StnkNumber
			, @NopolNumber
			, @EstimationTimePickup
			, @Notes
			, @Vendor
			, @KirNumber
			, @KirExpire
			, @Apar
			, @Apd
			, @VehicleType
			, @VehicleMerk
			, @CreateBy
			, @CreateDate
			, @UpdateBy
			, @UpdateDate
			, @SimExpiryDate
			, @PickupPoint
			, @PickupPic
			,0)

		SET @Id = SCOPE_IDENTITY()
		EXEC [dbo].[GenerateGoodsReceiveNumber] @Id
		EXEC [dbo].[sp_insert_request_data] @Id, 'GR', '', @Status, 'Create'
	END
	ELSE 
	BEGIN
		UPDATE [dbo].[GoodsReceive]
		SET [PicName] = @PicName
		      ,[KtpNumber] = @KtpName
		      ,[PhoneNumber] = @PhoneNumber
		      ,[SimNumber] = @SimNumber
		      ,[StnkNumber] = @StnkNumber
		      ,[NopolNumber] = @NopolNumber
		      ,[EstimationTimePickup] = @EstimationTimePickup
		      ,[Notes] = @Notes
			  ,[Vendor] = @Vendor
			  ,[KirNumber] = @KirNumber
			  ,[KirExpire] = @KirExpire
			  ,[Apar] = @Apar
			  ,[Apd] = @Apd
			  ,[VehicleType] = @VehicleType
			  ,[VehicleMerk] = @VehicleMerk
		      ,[UpdateBy] = @UpdateBy
		      ,[UpdateDate] = @UpdateDate
			  ,[SimExpiryDate] = @SimExpiryDate
			  ,[PickupPoint] = @PickupPoint
			  ,[PickupPic] = @PickupPic
		      ,[IsDelete] = @IsDelete
		WHERE Id = @Id

		EXEC [dbo].[sp_update_request_gr] @Id, @UpdateBy, @Status, ''
	END
	SELECT CAST(@Id as bigint) as ID
END

GO
