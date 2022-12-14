USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_email_body]
(
	@RequestID int,-- = 2, 
	@Module nvarchar(20),--='Cargo', 
	@Status nvarchar(20),-- = 'Revise', 
	@RecipientType nvarchar(20),-- = 'Approver', 
	@AssignType nvarchar(20),-- = 'Approver', 
	@AssignTo nvarchar(20),-- = 'rouli.a.siregar', 
	@MobileLink nvarchar(200),-- = '#', 
	@DesktopLink nvarchar(200)-- = '#'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @EmailBody nvarchar(MAX)
	select @EmailBody = Message from EmailTemplate where Module = @Module and Status = @Status and RecipientType = @RecipientType

	declare @RequestNo nvarchar(20), @AD_User nvarchar(20), @RequestorEmpID int, @RequestorName nvarchar(200), @CreatedDate nvarchar(20), 
	@SuperiorEmpID nvarchar(20), @SuperiorName nvarchar(200), @ApproverName nvarchar(200)

	IF @Module = 'Cargo'
	BEGIN
		select @RequestNo = ClNo, @AD_User = CreateBy, @CreatedDate = RIGHT('0' + DATENAME(DAY, CreateDate), 2) + ' ' + DATENAME(MONTH, CreateDate)+ ' ' + DATENAME(YEAR, CreateDate) 
		from Cargo where id = @RequestID
	END

	select @RequestorEmpID = e.Employee_ID, @RequestorName = e.Employee_Name, @SuperiorEmpID = spv.Employee_ID, @SuperiorName = spv.Employee_Name from Employee e
	inner join Employee spv on e.Superior_ID = spv.Employee_ID
	where e.AD_User = @AD_User and e.employee_status = 'Active'

	IF @Status = 'Submit'
	BEGIN
		set @ApproverName = IIF(@AssignType = 'Group' , @AssignTo + ' Group', @SuperiorName)
	END
	ELSE
	BEGIN
		select @ApproverName = Employee_Name from Employee where AD_User = @AssignTo
	END

	set @EmailBody = 
		REPLACE(
			REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										REPLACE(
											@EmailBody, '@RequestorName', @RequestorName
										), '@RequestNo', @RequestNo
									), '@CreatedDate', @CreatedDate
								), '@SuperiorEmpID', @SuperiorEmpID
							), '@SuperiorName', @SuperiorName
						), '@MobileLink', @MobileLink
					), '@DesktopLink', @DesktopLink
				), '@ApproverName', @ApproverName
			), '@RequestorEmpID', @RequestorEmpID
		)

		--select @EmailBody

	return @EmailBody
END
GO
