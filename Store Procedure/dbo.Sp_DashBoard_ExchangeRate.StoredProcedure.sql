USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_DashBoard_ExchangeRate] -- exec Sp_DashBoard_ExchangeRate '2020-03-17','2020-03-23'  
(  
@date1 Date,  
@date2 Date  
)  
as  
begin  
select * from masterkurs   
where StartDate <= @date1  AND EndDate >= @date2  
order by StartDate Desc  
end
GO
