USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[DeleteUnregisteredUsersLessons]    Script Date: 06/11/2011 17:57:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[DeleteUnregisteredUsersLessons](@min int)
as

declare @lessonId int

declare lessonCursor cursor for

select
	l.LessonId
from
	Lessons l
	join Users u on u.UserId = l.OwnerId
	left join
	(
		select
			ush.UserId,
			ush.UsageStatusCode
		from
			(
				select
					max(ush.SubscriptionHistoryId) SubscriptionHistoryId,
					ush.UserId
				from
					dbo.UserSubscriptionHistory ush
				group by
					ush.UserId
			) maxSubscriptionHistory
			left join dbo.UserSubscriptionHistory ush on ush.SubscriptionHistoryId = maxSubscriptionHistory.SubscriptionHistoryId
	) registeredUsers
	on registeredUsers.UserId = u.UserId
where
	(
		registeredUsers.UsageStatusCode = 'R' or
		registeredUsers.UsageStatusCode is null
	)
	and datediff(mi, l.DateCreated, GETDATE()) > @min

open lessonCursor

fetch next from lessonCursor into @lessonId

while @@FETCH_STATUS = 0
begin

	exec DeleteLesson @lessonId

	fetch next from lessonCursor into @lessonId

end

close lessonCursor

deallocate lessonCursor

