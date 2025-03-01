USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[ReachedMaxPrivateLessons]    Script Date: 06/11/2011 17:51:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[ReachedMaxPrivateLessons](@UserId int)
as

declare @public bit
declare @numLessonSettings int
declare @hasLessonSettings bit

declare @currentUsageCode varchar(2)

select
	@currentUsageCode = isnull(ush.UsageStatusCode, 'R')
from
	(
		select
			max(ush.SubscriptionHistoryId) SubscriptionHistoryId
		from
			dbo.UserSubscriptionHistory ush
		where
			ush.UserId = @UserId
	) maxSubscriptionHistory
	left join dbo.UserSubscriptionHistory ush on ush.SubscriptionHistoryId = maxSubscriptionHistory.SubscriptionHistoryId

select @numLessonSettings = count(*) from UserLessonSettings where UserId = @UserId
if (@numLessonSettings > 0)
	select @hasLessonSettings = 1
else
	select @hasLessonSettings = 0

if (@hasLessonSettings = 1)
	select @public = [public] from UserLessonSettings where UserId = @UserId
else
	select @public = 1

if (@public = 1)
	select cast(0 as bit)
else
begin
	declare @numPrivateLessons int
	select @numPrivateLessons = count(*) from Lessons where OwnerId = @UserId and GloballyShared = 0

	declare @maxPrivateLessons int
	select @maxPrivateLessons = MaxPrivateLessons
	from UsageStatus us
	where us.Code = @currentUsageCode

	if (@numPrivateLessons >= @maxPrivateLessons)
		select cast(1 as bit)
	else
		select cast(0 as bit)
end

