USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetMenuRoleAccess]
(
@RoleID INT,
@ViewHome INT
)
AS
BEGIN
if @RoleID = 1
begin
	select a.ID, a.ParentID, 1 RoleID, a.Name, a.URL, a.OrderNo, a.icon,
	CAST(1 as bit) as IsRead, CAST(1 as bit) as IsCreate, CAST(1 as bit) as IsUpdated, CAST(1 as bit) as IsDelete 
	from Master_Menu a		
	 where a.IsActive = 1 and ParentID <> 0 and a.Name not in ('Log Off') 
end
else
	if @ViewHome = 1
		begin 
		select a.ID, a.ParentID, b.RoleID, a.Name, a.URL, a.OrderNo, a.icon, ISNULL(b.IsRead, 0) IsRead, ISNULL(b.IsCreate, 0) IsCreate, ISNULL(b.IsUpdated, 0) IsUpdated, ISNULL(b.IsDeleted, 0) IsDelete 
		from Master_Menu a
		inner join Role_Access_Menu b on a.ID=b.MenuID where b.RoleID = @RoleID
		and a.IsActive = 1 and ParentID <> 0 and a.Name not in ('Log Off') and b.isRead=1 
end
	else if @ViewHome = 0
		select a.ID, a.ParentID, b.RoleID, a.Name, a.URL, a.OrderNo, a.icon, ISNULL(b.IsRead, 0) IsRead, ISNULL(b.IsCreate, 0) IsCreate, ISNULL(b.IsUpdated, 0) IsUpdated, ISNULL(b.IsDeleted, 0) IsDelete 
		from Master_Menu a
		inner join Role_Access_Menu b on a.ID=b.MenuID where b.RoleID = @RoleID
		and a.IsActive = 1 and ParentID <> 0 and a.Name not in ('Log Off') and a.Name not in ('Home') and b.isRead=1 
END
GO
