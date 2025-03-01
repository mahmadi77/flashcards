USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[GetUsageStatusDescriptions]    Script Date: 06/11/2011 16:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[GetUsageStatusDescriptions](@UserId int)
as

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


select
	us.Code,
	us.Name,
	us.Price,
	us.MaxLessons,
	us.MaxEntries,
	us.MaxPrivateLessons,
	us.MaxLessonGroups,
	case
		when @currentUsageCode = us.Code then us.Code
		else null
	end CurrentUsageCode
from
	UsageStatus us
where
	us.Code != 'SU'


