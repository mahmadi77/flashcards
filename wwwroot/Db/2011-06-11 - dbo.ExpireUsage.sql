USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[ExpireUsage]    Script Date: 06/11/2011 17:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[ExpireUsage](@UserId int)
as

declare @date datetime
set @date = getdate()

exec InsertSubscriptionHistory @userId, @date, 'R'



