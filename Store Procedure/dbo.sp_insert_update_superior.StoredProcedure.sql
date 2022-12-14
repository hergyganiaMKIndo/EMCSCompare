USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_insert_update_superior] --exec sp_insert_update_gr 0, 'Tri Artha', '3211022907890004', '234002000', '32001000', 'Z5226BW', '20 Jan 2020', 'testing notes dan lain lain', 'xupj21fig', '20 Jan 2019', 'xupj21fig', '29 Jan 2019', 0 
(
	@Id bigint,
	@EmployeeUsername nvarchar(100),
	@SuperiorUsername nvarchar(100),
	@Isdelete bit = 0,
	@UpdateBy nvarchar(100),
	@UpdateDate nvarchar(100),
	@CreateBy nvarchar(100),
	@CreateDate nvarchar(100)
)
AS
BEGIN
	DECLARE @EmployeeName nvarchar(500);
	DECLARE @SuperiorName nvarchar(500);

	SELECT @EmployeeName = Employee_Name + ' - ' + AD_User from Employee
	WHERE AD_User = @EmployeeUsername;

	SELECT @SuperiorName = Employee_Name + ' - ' + AD_User from Employee
	WHERE AD_User = @SuperiorUsername;

	
	SET NOCOUNT ON;
	IF ISNULL(@Id, 0) = 0 
	BEGIN
		INSERT INTO [dbo].[MasterSuperior]
			   ([EmployeeUsername]
			   ,[EmployeeName]
			   ,[SuperiorUsername]
			   ,[SuperiorName]
			   ,[IsDeleted]
			   ,[CreateBy]
			   ,[CreateDate]
			   ,[UpdateBy]
			   ,[UpdateDate])
		 VALUES
			   (@EmployeeUsername
			   ,@EmployeeName
			   ,@SuperiorUsername
			   ,@SuperiorName
			   ,@IsDelete
			   ,@CreateBy
			   ,@CreateDate
			   ,Null
			   ,NULL)
	END
	ELSE 
	BEGIN
		UPDATE [dbo].[MasterSuperior] SET 
		[EmployeeUsername] = @EmployeeUsername,
		[EmployeeName] = @EmployeeName,
		[SuperiorUsername] = @SuperiorUsername,
		[SuperiorName] = @SuperiorName,
		[UpdateBy] = @UpdateBy,
		[UpdateDate] = @UpdateDate,
		[IsDeleted] = @IsDelete
		WHERE Id = @Id
	END
	SELECT CAST(1 as bigint) as ID
END


GO
