
-- Remember to replace the schema

---------------------------------------------------------------------------
-- SPROC: InsertUser
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertUser' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertUser
go

create procedure InsertUser(
	@UserId int output,
	@Username nvarchar(20),
	@Email nvarchar(50),
	@Password nvarchar(10),
	@VerificationGuid varchar(100),
	@IsAdmin bit = 0)
as

insert into Users
(Username, Email, Password, VerificationGuid, IsAdmin)
values
(@Username, @Email, @Password, @VerificationGuid, @IsAdmin)

set @UserId = @@identity

go

---------------------------------------------------------------------------
-- SPROC: GetUser
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetUser' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetUser
go

create procedure GetUser(@UserId int)
as

select
	UserId,
	Username,
	Email,
	Password,
	IsAdmin
from
	Users
where UserId = @UserId

go

---------------------------------------------------------------------------
-- SPROC: GetUsageStatusDescriptions
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetUsageStatusDescriptions' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetUsageStatusDescriptions
go

create procedure GetUsageStatusDescriptions(@UserId int)
as

select
	us.Code,
	us.Name,
	us.Price,
	us.MaxLessons,
	us.MaxEntries,
	us.MaxPrivateLessons,
	us.MaxLessonGroups,
	u.CurrentUsageCode
from
	UsageStatus us
	left join (select CurrentUsageCode from Users where UserId = @UserId) u
	on u.CurrentUsageCode = us.Code
where
	us.Code != 'SU'

go

---------------------------------------------------------------------------
-- SPROC: GetDemoLessons
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetDemoLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetDemoLessons
go

create procedure GetDemoLessons
as

select
	l.LessonId,
	l.LessonName,
	pl.SortOrder
from
	Lessons l
	join DemoLessons pl on pl.LessonId = l.LessonId
order by
	pl.SortOrder

go

---------------------------------------------------------------------------
-- SPROC: GetLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLesson
go

create procedure GetLesson(@LessonId int)
as

-- Determine if any entries are currently "soloed"
declare @numSoloed int
select @numSoloed = count(*) from LessonEntries where LessonId = @LessonId and Solo = 1

-- If there are no soloed entires, select all of the entries
if (@numSoloed = 0)
	select
		le.Entry,
		le.Translation,
		le.Accents,
		le.AccentsBack
	from
		Lessons l
		join LessonEntries le on le.LessonId = l.LessonId
	where
		l.LessonId = @LessonId
	order by
		le.SortOrder

-- If there are soloed entries, select only the soloed entries
else
	select
		le.Entry,
		le.Translation,
		le.Accents,
		le.AccentsBack
	from
		Lessons l
		join LessonEntries le on le.LessonId = l.LessonId
	where
		l.LessonId = @LessonId
		and Solo = 1
	order by
		le.SortOrder

go

---------------------------------------------------------------------------
-- SPROC: InsertLessonEntry
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertLessonEntry' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertLessonEntry
go

create procedure InsertLessonEntry(
	@LessonId int,
	@Entry nvarchar(200),
	@Translation nvarchar(200),
	@Accents nvarchar(200) = null,
	@AccentsBack nvarchar(200) = null)
as

declare @count int
set @count = (select count(*) + 1 from lessonentries where lessonid = @lessonid)

insert into LessonEntries
(LessonId, Entry, Translation, Accents, AccentsBack, SortOrder)
values
(@LessonId, @Entry, @Translation, @Accents, @AccentsBack, @Count)

go

---------------------------------------------------------------------------
-- SPROC: GetMyLessons
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetMyLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetMyLessons
go

create procedure GetMyLessons(@UserId int)
as

-- Available lesson ids
declare @MyLessons table (LessonId int)

-- Insert
insert into @MyLessons
select LessonId from Lessons where OwnerId = @UserId
union
select LessonId from UserLessons where UserId = @UserId
-- Three tables, one for each lesson entry
declare @le1 table (lessonentryid int, lessonid int)
declare @le2 table (lessonentryid int, lessonid int)
declare @le3 table (lessonentryid int, lessonid int)

-- The first entry
insert into @le1
	select
		min(lessonentryid),
		lessonid
	from
		lessonentries
	where
		LessonId in (select LessonId from @MyLessons)
	group by
		lessonid

-- The second entry
insert into @le2
select
	min(le.lessonentryid),
	le.lessonid
from
	lessonentries le
	join @le1 le1 on le1.lessonid = le.lessonid
where
	le.LessonId in (select LessonId from @MyLessons)
	and le.lessonentryid > le1.lessonentryid
group by
	le.lessonid

-- The third entry
insert into @le3
select
	min(le.lessonentryid),
	le.lessonid
from
	lessonentries le
	join @le2 le2 on le2.lessonid = le.lessonid
where
	le.LessonId in (select LessonId from @MyLessons)
	and le.lessonentryid > le2.lessonentryid
group by
	le.lessonid


-- The returned table
select
	le.lessonid,
	le.entry
from
	lessonentries le
	join 
	(
		select * from @le1
		union
		select * from @le2
		union
		select * from @le3
	) a
	on a.lessonentryid = le.lessonentryid
	join lessons l on l.lessonid = le.lessonid
order by
	l.lessonname


select
	l.LessonId,
	l.LessonName,
	l.OwnerId,
	u.Username
from
	Lessons l
	join Users u on u.UserId = l.OwnerId
where
	l.OwnerId = @UserId

union

select
	l.LessonId,
	l.LessonName,
	l.OwnerId,
	u.UserName
from
	Lessons l
	join UserLessons ul on ul.LessonId = l.LessonId
	join Users u on u.UserId = l.OwnerId
where
	ul.UserId = @UserId

order by
	LessonName

go

---------------------------------------------------------------------------
-- SPROC: InsertLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertLesson
go

create procedure InsertLesson(
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
join Users u on u.CurrentUsageCode = us.Code
where u.UserId = @OwnerId

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

go

---------------------------------------------------------------------------
-- SPROC: InsertUserLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertUserLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertUserLesson
go
create procedure InsertUserLesson(@LessonId int, @UserId int)
as


if 
(
  ( 
  select
  	count(*)
  from
  	UserLessons
  where
  	UserId = @UserId
  	and LessonId = @LessonId
  ) = 0

  and

  	(
	select
		count(*)
	from
		Lessons
	where
		OwnerId = @UserId
		and LessonId = @LessonId
	) = 0
)


insert into
	UserLessons
(
	LessonId,
	UserId
)
values
(
	@LessonId,
	@UserId
)

go

---------------------------------------------------------------------------
-- SPROC: ExistsUser
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ExistsUser' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ExistsUser
go

create procedure ExistsUser(@Username nvarchar(20), @Email nvarchar(50))
as

declare @NumUsernames int
declare @NumEmails int

select
	@NumUsernames = count(*)
from
	Users
where
	Username = @Username

select
	@NumEmails = count(*)
from
	Users
where
	Email = @Email

select
	@NumUsernames NumUsernames,
	@NumEmails NumEmails

go

---------------------------------------------------------------------------
-- SPROC: ValidateUserOwnsLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ValidateUserOwnsLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ValidateUserOwnsLesson
go

create procedure ValidateUserOwnsLesson(@UserId int, @LessonId int)
as

select
	count(*)
from
	Lessons
where
	OwnerId = @UserId
	and LessonId = @LessonId

go

---------------------------------------------------------------------------
-- SPROC: CopyLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CopyLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure CopyLesson
go

create procedure CopyLesson(@UserId int, @LessonId int)
as

declare @SharedWith int
declare @GloballyShared bit

select
	@SharedWith = count(*)
from
	SharedLessons
where
	LessonId = @LessonId
	and SharedWithId = @UserId

select
	@GloballyShared = GloballyShared
from
	Lessons
where
	LessonId = @LessonId

if (@SharedWith >= 1 or @GloballyShared = 1)
begin

insert into Lessons
(
	LessonName,
	OwnerId,
	GloballyShared,
	Speed,
	Direction,
	InOrder,
	AccentsOn,
	ShowSettings,
	ThemeId,
	EntryMarkupType
)

select
	N'* My Copy of ' + LessonName,
	@UserId,
	0,
	Speed,
	Direction,
	InOrder,
	AccentsOn,
	ShowSettings,
	ThemeId,
	EntryMarkupType
from
	Lessons
where
	LessonId = @LessonId


insert into LessonEntries
(LessonId, Entry, Translation, Accents, AccentsBack, SortOrder)
select
@@identity, Entry, Translation, Accents, AccentsBack, SortOrder
from LessonEntries
where LessonId = @LessonId

end

go

---------------------------------------------------------------------------
-- SPROC: ValidateUserInfo
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ValidateUserInfo' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ValidateUserInfo
go

create procedure ValidateUserInfo(@user nvarchar(50), @password nvarchar(10))
as

select
	userid
from
	users
where
	(username = @user or email = @user)
	and password = @password
	and verified = 1

go

---------------------------------------------------------------------------
-- SPROC: GetLessonSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonSettings
go

create procedure GetLessonSettings(@LessonId int)
as

select
	LessonName,
	OwnerId UserId,
	GloballyShared,
	Speed,
	InOrder,
	Direction,
	AccentsOn,
	ShowSettings,
	t.ThemeId,
	t.BackgroundColor,	t.BackgroundImage,
	t.TextColor,
	t.HideButtonColor,
	t.MenuTextColor,
	t.AccentsColor,	EntryMarkupType
from
	Lessons l
	join Themes t on t.ThemeId = l.ThemeId
where
	LessonId = @LessonId

select
	COUNT(*) NumEntriesWithAccents
from
	LessonEntries le
where
	le.LessonId = @LessonId
	and
	(
		(le.Accents is not null and le.Entry != le.Accents)
		or
		(le.AccentsBack is not null and le.Translation != le.AccentsBack)
	)

go

---------------------------------------------------------------------------
-- SPROC: UpdateLessonSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateLessonSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateLessonSettings
go

create procedure UpdateLessonSettings(
	@LessonId int,
	@LessonName nvarchar(100),
	@Speed int,
	@Direction bit,
	@InOrder bit,
	@ShowSettings bit,
	@AccentsOn bit,
	@GloballyShared bit,
	@ThemeId int,
	@EntryMarkupType char(1)
	)
as

update
	Lessons
set
	LessonName = @LessonName,
	Speed = @Speed,
	Direction = @Direction,
	InOrder = @InOrder,
	ShowSettings = @ShowSettings,
	AccentsOn = @AccentsOn,
	GloballyShared = @GloballyShared,
	ThemeId = @ThemeId,
	EntryMarkupType = @EntryMarkupType
where
	LessonId = @LessonId

go

---------------------------------------------------------------------------
-- SPROC: GetLessonEntries
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonEntries' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonEntries
go

create procedure GetLessonEntries(@LessonId int)
as

select
	le.LessonId,
	le.LessonEntryId,
	le.Entry,
	le.Translation,
	le.Accents,
	le.AccentsBack,
	le.Solo
from
	LessonEntries le
where
	le.LessonId = @LessonId
order by
	le.SortOrder

go

---------------------------------------------------------------------------
-- SPROC: DeleteLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure DeleteLesson
go

create procedure DeleteLesson(@LessonId int)
as

delete from LessonEntries where LessonId = @LessonId
delete from LessonGroupLessons where LessonId = @LessonId
delete from Lessons where LessonId = @LessonId
delete from UserLessons where LessonId = @LessonId

go

---------------------------------------------------------------------------
-- SPROC: DeleteUserLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteUserLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure DeleteUserLesson
go

create procedure DeleteUserLesson(@LessonId int, @UserId int)
as

delete from UserLessons
where UserId = @UserId
and LessonId = @LessonId

go

---------------------------------------------------------------------------
-- SPROC: DeleteUser
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteUser' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure DeleteUser
go

create procedure DeleteUser(@UserId int)
as

delete from lessonentries where lessonid in
(select lessonid from lessons where ownerid = @userid)

delete from lessons where ownerid = @userid

delete from sharedlessons where lessonid in
(select lessonid from lessons where ownerid = @userid)

delete from userlessons where userid = @userid

delete from users where userid = @userid

delete from userlessonsettings where userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: GetLessonEntry
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonEntry' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonEntry
go

create procedure GetLessonEntry(@LessonEntryId int)
as

select
	Entry,
	[Translation],
	Accents,
	AccentsBack
from
	LessonEntries
where
	LessonEntryId = @LessonEntryId

go

---------------------------------------------------------------------------
-- SPROC: UpdateLessonEntry
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateLessonEntry' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateLessonEntry
go

create procedure UpdateLessonEntry(@LessonEntryId int, @Entry nvarchar(200), @Translation nvarchar(200), @Accents nvarchar(200) = null, @AccentsBack nvarchar(200) = null)
as

update
	LessonEntries
set
	Entry = @Entry,
	[Translation] = @Translation,
	Accents = @Accents,
	AccentsBack = @AccentsBack
where
	LessonEntryId = @LessonEntryId

go

---------------------------------------------------------------------------
-- SPROC: DeleteLessonEntry
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteLessonEntry' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure DeleteLessonEntry
go

create procedure DeleteLessonEntry(@LessonEntryId int)
as

delete from LessonEntries where LessonEntryId = @LessonEntryId

go

---------------------------------------------------------------------------
-- SPROC: GetConfiguraitonSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetConfigurationSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetConfigurationSettings
go

create procedure GetConfigurationSettings
as

select
	[Key],
	[Value]
from
	Configuration

go

---------------------------------------------------------------------------
-- SPROC: UpdateVerified
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateVerified' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateVerified
go

create procedure UpdateVerified(@VerificationGuid varchar(100))
as

update users
set verified = 1
where verificationguid = @verificationguid

go

---------------------------------------------------------------------------
-- SPROC: ValidateUserInfoFromGuid
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ValidateUserInfoFromGuid' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ValidateUserInfoFromGuid
go

create procedure ValidateUserInfoFromGuid(@VerificationGuid varchar(100))
as

select
	userid, username
from
	users
where
	verificationguid = @verificationguid

go

---------------------------------------------------------------------------
-- SPROC: UpdateVerificationGuid
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateVerificationGuid' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateVerificationGuid
go

create procedure UpdateVerificationGuid(@verificationguid varchar(100), @email nvarchar(50))
as

update
	users
set
	verificationguid = @verificationguid
where
	email = @email

go

---------------------------------------------------------------------------
-- SPROC: ResetPassword
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ResetPassword' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ResetPassword
go

create procedure ResetPassword(@verificationguid varchar(100), @password nvarchar(10))
as

update
	users
set
	password = @password
where
	verificationguid = @verificationguid

go

---------------------------------------------------------------------------
-- SPROC: UpdateEntryOrder
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateEntryOrder' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateEntryOrder
go

create procedure UpdateEntryOrder(@LessonEntryId int, @SortOrder int)
as

update
	LessonEntries
set
	SortOrder = @SortOrder
where
	LessonEntryId = @LessonEntryId

go

---------------------------------------------------------------------------
-- SPROC: UpdatePassword
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdatePassword' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdatePassword
go

create procedure UpdatePassword(@userId int, @password varchar(10))
as

update users
set password = @password
where userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: ValidatePassword
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ValidatePassword' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ValidatePassword
go

create procedure ValidatePassword(@userId int, @password varchar(10))
as

declare @isvalid bit
set @isvalid = 0

if ((select count(*) from users where userid = @userid and password = @password) > 0)
  set @isvalid = 1

select @isvalid

go

---------------------------------------------------------------------------
-- SPROC: GetUserSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetUserSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetUserSettings
go

create procedure GetUserSettings(@userId int)
as

select * from UserLessonSettings where userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: InsertUserSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertUserSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertUserSettings
go

create procedure InsertUserSettings(
	@userId int,
	@public bit = 1,
	@showsettings bit = 1,
	@Speed float = 2000,
	@Direction bit = 0,
	@InOrder bit = 0,
	@AccentsOn bit = 1,
	@ThemeId int = 1,
	@EntryMarkupType char(1) = 'A')

as

insert into userlessonsettings
(
	UserId,
	[Public],
	SettingsMenuShown,
	Speed,
	Direction,
	InOrder,
	AccentsOn,
	ThemeId,
	EntryMarkupType
)
values
(
	@userId,
	@public,
	@showsettings,
	@Speed,
	@Direction,
	@InOrder,
	@AccentsOn,
	@ThemeId,
	@EntryMarkupType
)

go

---------------------------------------------------------------------------
-- SPROC: UpdateUserSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateUserSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateUserSettings
go

create procedure UpdateUserSettings(
	@userId int,
	@public bit,
	@showsettings bit,
	@Speed float,
	@Direction bit,
	@InOrder bit,
	@AccentsOn bit,
	@ThemeId int,
	@EntryMarkupType char(1))

as

update userlessonsettings
set
	
	[Public] = @public,
	SettingsMenuShown = @showsettings,
	Speed = @speed,
	Direction = @direction,
	InOrder = @inorder,
	AccentsOn = @accentson,
	ThemeId = @themeid,
	EntryMarkupType = @EntryMarkupType
where
	userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: GetThemes
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetThemes' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetThemes
go

create procedure GetThemes
as

select * from Themes

go

---------------------------------------------------------------------------
-- SPROC: GetSharedLessons
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetSharedLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetSharedLessons
go

create procedure GetSharedLessons(@ResultsPerPage int, @PageNumber int)
as

-- A table to hold the top X number of Lessons ordered by number of views descending
declare @TopLessons table
(
	Id int identity,
	LessonId int,
	DateCreated datetime
)

-- Insert the top X lessons
insert into @TopLessons (LessonId, DateCreated)
select l.LessonId, l.DateCreated from Lessons l

-- We're commenting this out because we originally sorted by the number of lesson views
-- descending.  Now we want to sort by creation date descending.
-- Eventually we should have a modification date on lessons and sort by that
-- descending.
/*
left join
-- We select a count instead of a sum because we want the number of distinct user views,
-- not the number of total views
(
	select
		lessonid,
		count(*) numviews
	from
		lessonviews
	group by
		lessonid
) lv
on lv.lessonid = l.lessonid
*/
where
	-- The lesson is public
	GloballyShared = 1
	-- It's not a demo lesson
	and l.LessonId not in
	(select LessonId from DemoLessons)
order by
	l.DateCreated desc

-- Three tables, one for each lesson entry
declare @le1 table (lessonentryid int, lessonid int)
declare @le2 table (lessonentryid int, lessonid int)
declare @le3 table (lessonentryid int, lessonid int)

-- The first entry
insert into @le1
	select
		min(lessonentryid),
		lessonid
	from
		lessonentries
	where
		LessonId in (select LessonId from @TopLessons where Id between
(@PageNumber - 1) * @ResultsPerPage + 1  and @PageNumber * @ResultsPerPage
)
	group by
		lessonid

-- The second entry
insert into @le2
select
	min(le.lessonentryid),
	le.lessonid
from
	lessonentries le
	join @le1 le1 on le1.lessonid = le.lessonid
where
	le.LessonId in (select LessonId from @TopLessons where Id between
(@PageNumber - 1) * @ResultsPerPage + 1  and @PageNumber * @ResultsPerPage)
	and le.lessonentryid > le1.lessonentryid
group by
	le.lessonid

-- The third entry
insert into @le3
select
	min(le.lessonentryid),
	le.lessonid
from
	lessonentries le
	join @le2 le2 on le2.lessonid = le.lessonid
where
	le.LessonId in (select LessonId from @TopLessons where Id between
(@PageNumber - 1) * @ResultsPerPage + 1  and @PageNumber * @ResultsPerPage)
	and le.lessonentryid > le2.lessonentryid
group by
	le.lessonid

-- The returned table
select
	le.lessonid,
	le.entry
from
	lessonentries le
	join 
	(
		select * from @le1
		union
		select * from @le2
		union
		select * from @le3
	) a
	on a.lessonentryid = le.lessonentryid
	join @TopLessons tl on tl.LessonId = le.LessonId

order by
	tl.DateCreated desc,
	le.LessonId

-- The lessons
select
	l.lessonid,
	l.lessonname,
	l.OwnerId,
	u.Username,
	tl.DateCreated
from
	lessons l
	join @TopLessons tl on tl.LessonId = l.lessonid
	join Users u on u.UserId = l.OwnerId
where
	tl.Id between
(@PageNumber - 1) * @ResultsPerPage + 1  and @PageNumber * @ResultsPerPage
order by
	tl.DateCreated desc

-- The count
select count(*) NumLessons from lessons
where
	GloballyShared = 1
	and LessonId not in
	(select LessonId from PublicLessons)

go

---------------------------------------------------------------------------
-- FUNCTION: fn_ParseCommaDelimitedStringToTable
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fn_ParseCommaDelimitedStringToTable' and ROUTINE_SCHEMA = 'xubuser')
	drop function fn_ParseCommaDelimitedStringToTable
go

create function [dbo].[fn_ParseCommaDelimitedStringToTable](@commaDelimitedString nvarchar(2000))
returns

@values table
(
	Val nvarchar(100)
)
as

begin

	-- Index and string variables
	declare @stringToParse nvarchar(2000)
	declare @currentString nvarchar(15)
	declare @indexOfDelimiter int

	-- Initialize
	set @stringToParse = @commaDelimitedString + N','
	set @indexOfDelimiter = charindex(N',', @stringToParse)

	-- Go through all the ids
	while (@indexOfDelimiter > 0)
	begin

		-- Some parsing logic
		set @currentString = substring(@stringToParse, 1, @indexOfDelimiter - 1)

		-- Insert the account and the weight
		insert into @values (Val) values (@currentString)

		-- Update for the next account weight pair
		set @stringToParse = substring(@stringToParse, @indexOfDelimiter + 1, len(@stringToParse) - len(@currentString) - 1)
		set @indexOfDelimiter = charindex(N',', @stringToParse)

	end

	return

end

go

---------------------------------------------------------------------------
-- SPROC: SearchLessons
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SearchLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure SearchLessons
go

create procedure SearchLessons(@SearchTerms nvarchar(1000))
as

declare @SearchTable table (LessonId int, LessonEntryId int, SearchTerm nvarchar(200), NumHits int)

insert into @SearchTable

select lessonid, lessonentryid, entry, 0 
from lessonentries 
where 
lessonid in (select lessonid from lessons where globallyshared = 1) 
and lessonid not in (select lessonid from publiclessons)

union

select lessonid, lessonentryid, translation, 0 
from lessonentries 
where 
lessonid in (select lessonid from lessons where globallyshared = 1) 
and lessonid not in (select lessonid from publiclessons)

union

select lessonid, null, lessonname, 0 
from lessons 
where 
lessonid in (select lessonid from lessons where globallyshared = 1) 
and lessonid not in (select lessonid from publiclessons)


declare @SearchTermsTable table (SearchTerm nvarchar(200))
insert into @SearchTermsTable select [val] from fn_ParseCommaDelimitedStringToTable(@SearchTerms)

declare @currentSearchTerm nvarchar(200)
declare searchTermCursor cursor for
select SearchTerm from @SearchTermsTable

open searchTermCursor
fetch next from searchTermCursor into @currentSearchTerm

while @@fetch_status = 0  
begin  
	delete from
		st
	from
		@SearchTable st
		join @SearchTermsTable stt on st.SearchTerm not like N'%' + stt.SearchTerm + N'%'

	fetch next from searchTermCursor into @currentSearchTerm
end  

close searchTermCursor  
deallocate searchTermCursor

select top 100 st.*, l.lessonName from @searchtable st join lessons l on l.lessonid = st.lessonid

go

---------------------------------------------------------------------------
-- SPROC: IncrementNumViews
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'IncrementNumViews' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure IncrementNumViews
go

create procedure IncrementNumViews(@LessonId int, @UserId int)
as

declare @count int

select @count = count(*) from lessonviews where lessonid = @lessonid and userid = @userid

if @count = 0
	insert into lessonviews (lessonid, userid) values (@lessonid, @userid)
else
	update lessonviews set numviews = numviews + 1 where lessonid = @lessonid and userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: ToggleSolo
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ToggleSolo' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ToggleSolo
go

create procedure ToggleSolo(@EntryId int, @Soloed bit)
as

update LessonEntries
set Solo = @Soloed
where LessonEntryId = @EntryId

go

---------------------------------------------------------------------------
-- SPROC: InsertLessonGroup
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertLessonGroup' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertLessonGroup
go

create procedure InsertLessonGroup(@Name nvarchar(200), @UserId int, @LessonGroupId int out)
as

if ((select count(*) from userlessonsettings where userid = @UserId) > 0)
insert into LessonGroups
	(
		[Name],
		[UserId],
		[Speed],
		[Direction],
		[InOrder],
		[AccentsOn],
		[ShowSettings],
		[ThemeId],
		[EntryMarkupType]
	)
	select
		@Name,
		@UserId,
		[Speed],
		[Direction],
		[InOrder],
		[AccentsOn],
		[SettingsMenuShown],
		[ThemeId],
		[EntryMarkupType]
	from
		userlessonsettings
	where
		UserId = @UserId


else
	insert into LessonGroups ([Name], [UserId]) values (@Name, @UserId)

select @LessonGroupId = @@identity

go

---------------------------------------------------------------------------
-- SPROC: InsertLessonGroupLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertLessonGroupLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertLessonGroupLesson
go

create procedure InsertLessonGroupLesson(@LessonGroupId int, @LessonId int)
as

insert into LessonGroupLessons ([LessonGroupId], [LessonId]) values (@LessonGroupId, @LessonId)

go

---------------------------------------------------------------------------
-- SPROC: DeleteLessonGroupLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteLessonGroupLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure DeleteLessonGroupLesson
go

create procedure DeleteLessonGroupLesson(@LessonGroupId int, @LessonId int)
as

delete from LessonGroupLessons where LessonGroupId = @LessonGroupId and LessonId = @LessonId

go

---------------------------------------------------------------------------
-- SPROC: DeleteLessonGroup
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteLessonGroup' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure DeleteLessonGroup
go

create procedure DeleteLessonGroup(@LessonGroupId int)
as

delete from LessonGroupLessons where LessonGroupId = @LessonGroupId
delete from LessonGroups where LessonGroupId = @LessonGroupId

go

---------------------------------------------------------------------------
-- SPROC: GetLessonGroups
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonGroups' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonGroups
go

create procedure GetLessonGroups(@UserId int)
as

select * from LessonGroups where UserId = @UserId order by [Name]

select
	lgl.LessonGroupId,
	lgl.LessonId,
	l.LessonName
from
	LessonGroups lg
	join LessonGroupLessons lgl on lgl.LessonGroupId = lg.LessonGroupId
	join Lessons l on l.LessonId = lgl.LessonId
where
	lg.UserId = @UserId
	
go

---------------------------------------------------------------------------
-- SPROC: ValidateUserOwnsLessonGroup
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ValidateUserOwnsLessonGroup' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ValidateUserOwnsLessonGroup
go

create procedure ValidateUserOwnsLessonGroup(@UserId int, @LessonGroupId int)
as

declare @count int
select @count = count(*) from LessonGroups where UserId = @UserId and LessonGroupId = @LessonGroupId

declare @valid bit
set @valid = 0

if (@count > 0)
	set @valid = 1

select @valid

go

---------------------------------------------------------------------------
-- SPROC: GetLessonGroup
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonGroup' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonGroup
go

create procedure GetLessonGroup(@LessonGroupId int)
as

select
	l.LessonId,
	l.LessonName,
	case when lg.LessonId is not null then cast(1 as bit) else cast(0 as bit) end IsPartOfLessonGroup
from
	Lessons l
	left join
	(
		select
			lgl.LessonId
		from
			LessonGroups lg
			join LessonGroupLessons lgl on lgl.LessonGroupId = lg.LessonGroupId
			join Lessons l on l.LessonId = lgl.LessonId
		where
			lg.LessonGroupId = @LessonGroupId
	) lg
	on lg.LessonId = l.LessonId
	
where
	OwnerId = (select UserId from LessonGroups where LessonGroupId = @LessonGroupId)

order by
	l.LessonName

go

---------------------------------------------------------------------------
-- SPROC: GetLessonGroupAsLesson
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonGroupAsLesson' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonGroupAsLesson
go

create procedure GetLessonGroupAsLesson(@LessonGroupId int)
as

declare @LessonsWithSolos table (LessonId int)

insert into @LessonsWithSolos
select
	distinct LessonId
from
	LessonEntries
where
	LessonId in (select LessonId from LessonGroupLessons where LessonGroupId = @LessonGroupId)
	and Solo = 1

select
	le.Entry,
	le.Translation,
	le.Accents,
	le.AccentsBack,
	l.LessonId,
	le.SortOrder
from
	Lessons l
	join LessonEntries le on le.LessonId = l.LessonId
where
	l.LessonId in (select LessonId from LessonGroupLessons where LessonGroupId = @LessonGroupId)
	and l.LessonId not in (select LessonId from @LessonsWithSolos)

union

select
	le.Entry,
	le.Translation,
	le.Accents,
	le.AccentsBack,
	l.LessonId,
	le.SortOrder
from
	Lessons l
	join LessonEntries le on le.LessonId = l.LessonId
where
	l.LessonId in (select LessonId from LessonGroupLessons where LessonGroupId = @LessonGroupId)
	and l.LessonId in (select LessonId from @LessonsWithSolos)
	and le.Solo = 1

order by
	l.LessonId,
	SortOrder

go

---------------------------------------------------------------------------
-- SPROC: GetLessonGroupSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetLessonGroupSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetLessonGroupSettings
go

create procedure GetLessonGroupSettings(@LessonGroupId int)
as

select
	lg.Name LessonName,
	lg.UserId,
	cast(0 as bit) GloballyShared,
	Speed,
	InOrder,
	Direction,
	AccentsOn,
	ShowSettings,
	t.ThemeId,
	t.BackgroundColor,	t.BackgroundImage,
	t.TextColor,
	t.HideButtonColor,
	t.MenuTextColor,
	t.AccentsColor,	EntryMarkupType
from
	LessonGroups lg
	join Themes t on t.ThemeId = lg.ThemeId
where
	LessonGroupId = @LessonGroupId

select
	COUNT(*)
from
	LessonEntries le
	join LessonGroupLessons lgl on lgl.LessonId = le.LessonId
where
	lgl.LessonGroupId = @LessonGroupId
	and
	(
		(le.Accents is not null and le.Entry != le.Accents)
		or
		(le.AccentsBack is not null and le.Translation != le.AccentsBack)
	)

go

---------------------------------------------------------------------------
-- SPROC: UpdateLessonGroupSettings
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateLessonGroupSettings' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure UpdateLessonGroupSettings
go

create procedure UpdateLessonGroupSettings(
	@LessonGroupId int,
	@Name nvarchar(200),
	@Speed int,
	@Direction bit,
	@InOrder bit,
	@ShowSettings bit,
	@AccentsOn bit,
	@ThemeId int,
	@EntryMarkupType char(1)
	)
as

update
	LessonGroups
set
	Name = @Name,
	Speed = @Speed,
	Direction = @Direction,
	InOrder = @InOrder,
	ShowSettings = @ShowSettings,
	AccentsOn = @AccentsOn,
	ThemeId = @ThemeId,
	EntryMarkupType = @EntryMarkupType
where
	LessonGroupId = @LessonGroupId

go

---------------------------------------------------------------------------
-- SPROC: InsertSubscriptionHistory
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'InsertSubscriptionHistory' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure InsertSubscriptionHistory
go

create procedure InsertSubscriptionHistory(@UserId int, @Date datetime, @UsageStatusCode varchar(2))
as

-- Insert a row into the subscription history table, the end date being
-- one month after the start date
insert into UserSubscriptionHistory (UserId, StartDate, EndDate, UsageStatusCode)
values (@UserId, @Date, dateadd(mm, 1, @Date), @UsageStatusCode)

-- Get the usage status id that the user currently has
declare @currentCode varchar(2)
select @currentCode = currentusagecode from users where userid = @userid

-- If the usage status being inserted is greater than the user's current status,
-- update their current status
if (@UsageStatusCode > @currentCode)
update users set currentusagecode = @usagestatuscode where userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: GetUsageStatus
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetUsageStatus' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetUsageStatus
go

create procedure GetUsageStatus(@UserId int)
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
	join UsageStatus us on us.Code = u.CurrentUsageCode
	left join usersubscriptionhistory ush on u.userid = ush.userid and u.currentusagecode = ush.usagestatuscode
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

go

---------------------------------------------------------------------------
-- SPROC: ExpireUsage
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ExpireUsage' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ExpireUsage
go

create procedure ExpireUsage(@UserId int)
as

declare @date datetime
set @date = getdate()

exec InsertSubscriptionHistory @userId, @date, 'R'

update users set currentusagecode = 'R' where userid = @userid

go

---------------------------------------------------------------------------
-- SPROC: GetNumEntries
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetNumEntries' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetNumEntries
go

create procedure GetNumEntries(@LessonId int)
as

select count(*) NumEntries from LessonEntries where LessonId = @LessonId

go

---------------------------------------------------------------------------
-- SPROC: ReachedMaxPrivateLessons
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ReachedMaxPrivateLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure ReachedMaxPrivateLessons
go

create procedure ReachedMaxPrivateLessons(@UserId int)
as

declare @public bit
declare @numLessonSettings int
declare @hasLessonSettings bit

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
	join Users u on u.CurrentUsageCode = us.Code
	where u.UserId = @UserId

	if (@numPrivateLessons >= @maxPrivateLessons)
		select cast(1 as bit)
	else
		select cast(0 as bit)
end

go

---------------------------------------------------------------------------
-- SPROC: GetUserStatistics
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetUserStatistics' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetUserStatistics
go

create procedure GetUserStatistics(@UserId int)
as

declare @numlessons int
declare @numuserlessons int
declare @numlessongroups int
declare @numprivatelessons int

select @numlessons = count(*) from lessons where ownerid = @userid
select @numuserlessons = count(*) from userlessons where userid = @userid
select @numlessongroups = count(*) from lessongroups where userid = @userid
select @numprivatelessons = count(*) from lessons where ownerid = @userid and globallyshared = 0

select
@numlessons + @numuserlessons NumLessons,
@numlessongroups NumLessonGroups,
@numprivatelessons NumPrivateLessons

select
	l.lessonname,
	count(*) numentries
from
	lessons l
	join lessonentries le on le.lessonid = l.lessonid
where
	l.ownerid = @userid
group by
	l.lessonname
order by
	l.lessonname

go

---------------------------------------------------------------------------
-- SPROC: GetDemoLessons
---------------------------------------------------------------------------

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetDemoLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure GetDemoLessons
go

create procedure GetDemoLessons
as

select
	l.LessonId,
	l.LessonName,
	pl.SortOrder
from
	Lessons l
	join DemoLessons pl on pl.LessonId = l.LessonId
order by
	pl.SortOrder

go


---------------------------------------------------------------------------
-- SPROC: DeleteUnregisteredUsersLessons
---------------------------------------------------------------------------


if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DeleteUnregisteredUsersLessons' and ROUTINE_SCHEMA = 'xubuser')
	drop procedure dbo.DeleteUnregisteredUsersLessons
go

create procedure dbo.DeleteUnregisteredUsersLessons(@min int)
as

declare @lessonId int

declare lessonCursor cursor for

select
	l.LessonId
from
	Lessons l
	join Users u on u.UserId = l.OwnerId
where
	u.CurrentUsageCode = 'R'
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

go




