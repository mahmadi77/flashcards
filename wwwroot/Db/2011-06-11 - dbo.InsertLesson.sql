USE [xublimynal]
GO
/****** Object:  StoredProcedure [dbo].[InsertLesson]    Script Date: 06/11/2011 18:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[InsertLesson](
	@LessonName nvarchar(100),
	@OwnerId int,
	@GloballyShared bit = 1,
	@Direction bit = 0,
	@InOrder bit = 0,
	@Speed int = 2000,
	@AccentsOn bit = 1,
	@ShowSettings bit = 1,
	@ThemeId int = 1,
	@EntryMarkupType char(1) = 'A',
	@LessonId int output
)
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
			ush.UserId = @OwnerId
	) maxSubscriptionHistory
	left join dbo.UserSubscriptionHistory ush on ush.SubscriptionHistoryId = maxSubscriptionHistory.SubscriptionHistoryId


declare @shared bit
if ((select count(*) from userlessonsettings where userid = @ownerid) > 0)
	select @shared = [public] from userlessonsettings where userid = @ownerid
else
	select @shared = @globallyshared

declare @numPrivateLessons int
select @numPrivateLessons = count(*) from Lessons where OwnerId = @OwnerId and GloballyShared = 0

declare @maxPrivateLessons int
select @maxPrivateLessons = MaxPrivateLessons
from UsageStatus us
where us.Code = @currentUsageCode

if (@numPrivateLessons + 1 > @maxPrivateLessons)
	set @shared = 0

if ((select count(*) from userlessonsettings where userid = @ownerid) > 0)
	insert into Lessons
	(
		LessonName,
		OwnerId,
		GloballyShared,
		Direction,
		InOrder,
		Speed,
		AccentsOn,
		ShowSettings,
		ThemeId,
		EntryMarkupType
	)
	select
		@LessonName,
		@OwnerId,
		@shared,
		Direction,
		InOrder,
		Speed,
		AccentsOn,
		SettingsMenuShown,
		ThemeId,
		EntryMarkupType
	from
		UserLessonSettings
	where
		UserId = @OwnerId

else
	insert into Lessons
	(
		LessonName,
		OwnerId,
		GloballyShared,
		Direction,
		InOrder,
		Speed,
		AccentsOn,
		ShowSettings,
		ThemeId,
		EntryMarkupType
	)
	values
	(
		@LessonName,
		@OwnerId,
		@shared,
		@Direction,
		@InOrder,
		@Speed,
		@AccentsOn,
		@ShowSettings,
		@ThemeId,
		@EntryMarkupType
	)

set @LessonId = @@identity

