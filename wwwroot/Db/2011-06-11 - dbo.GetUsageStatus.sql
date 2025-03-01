USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[GetUsageStatus]    Script Date: 06/11/2011 17:37:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[GetUsageStatus](@UserId int)
as

declare @numLessons int
declare @numUserLessons int
declare @numPrivateLessons int
declare @numLessonGroups int

select @numLessons = count(*) from lessons where ownerid = @userid
select @numUserLessons = count(*) from userlessons where userid = @userid
select @numPrivateLessons = count(*) from lessons where ownerid = @userid and globallyshared = 0
select @numLessonGroups = count(*) from lessongroups where userid = @userid


select
	us.Description,
	us.Name,
	us.Code,
	us.Price,
	us.MaxLessons,
	us.MaxEntries,
	us.MaxPrivateLessons,
	us.MaxLessonGroups,
	us.ViewPublicLessons,
	isnull(max(ush.EndDate), getdate() + 30) EndDate,
	@numPrivateLessons CurrentNumPrivateLessons,
	@numLessons + @numUserLessons CurrentNumLessons,
	@numLessonGroups CurrentNumLessonGroups
from
	Users u
	left join
	(
		select
			isnull(ush.UsageStatusCode, 'R') CurrentUsageCode,
			ush.EndDate
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
	) ush
	on u.UserId = @UserId
	left join dbo.UsageStatus us on us.Code = ush.CurrentUsageCode
where
	u.UserId = @UserId
group by
	us.Description,
	us.Name,
	us.Code,
	us.Price,
	us.MaxLessons,
	us.MaxEntries,
	us.MaxPrivateLessons,
	us.MaxLessonGroups,
	us.ViewPublicLessons

