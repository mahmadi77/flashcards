USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[InsertSubscriptionHistory]    Script Date: 06/11/2011 17:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[InsertSubscriptionHistory](@UserId int, @Date datetime, @UsageStatusCode varchar(2))
as

-- Insert a row into the subscription history table, the end date being
-- one month after the start date
insert into UserSubscriptionHistory (UserId, StartDate, EndDate, UsageStatusCode)
values (@UserId, @Date, dateadd(mm, 1, @Date), @UsageStatusCode)

