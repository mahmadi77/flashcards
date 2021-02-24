

-- Remember to replace the table schema

---------------------------------------------------------------------------
-- TABLE: UsageStatus
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'UsageStatus' and TABLE_SCHEMA = 'xubuser')
begin

create table UsageStatus
(
	Code varchar(2) not null,
	Name varchar(50) not null,
	Description varchar(100) not null,
	Price float not null,
	MaxLessons int not null,
	MaxEntries int not null,
	MaxPrivateLessons int not null,
	MaxLessonGroups int not null,
	ViewPublicLessons bit not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: Users
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table Users
(
	UserId int identity not null,
	Username nvarchar(20) not null,
	Email nvarchar(50) not null,
	Password nvarchar(10) not null,
	IsAdmin bit not null,
	VerificationGuid varchar(100) not null,
	Verified bit not null,
	CurrentUsageCode varchar(2) not null,
	DateCreated datetime not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: Lessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table Lessons
(
	LessonId int identity not null,
	LessonName nvarchar(100) not null,
	OwnerId int not null,
	GloballyShared bit not null,
	Speed int not null,
	Direction bit not null,
	InOrder bit not null,
	AccentsOn bit not null,
	ShowSettings bit not null,
	ThemeId int not null,
	EntryMarkupType char(1) not null,
	DateCreated datetime not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: UserLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'UserLessons' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table UserLessons
(
	LessonId int not null,
	UserId int not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: SharedLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SharedLessons' and TABLE_SCHEMA = 'xubuser')
begin

create table SharedLessons
(
	LessonId int not null,
	SharedWithId int not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: LessonEntries
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LessonEntries' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table LessonEntries
(
	LessonEntryId int identity not null,	
	LessonId int not null,
	Entry nvarchar(200) not null,
	Translation nvarchar(200) not null,
	Accents nvarchar(200) null,
	AccentsBack nvarchar(200) null,
	SortOrder int not null,
	Solo bit not null,
	DateCreated datetime
)

end

go

---------------------------------------------------------------------------
-- TABLE: DemoLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DemoLessons' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table DemoLessons
(
	LessonId int not null,
	SortOrder int
)

end

go

---------------------------------------------------------------------------
-- TABLE: Configuration
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Configuration' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table Configuration
(
	ConfigurationId int not null identity,
	[Key] varchar(100) not null,
	[Value] varchar(2000) not null,
	[Description] varchar(500) null,
	
)

end

go

---------------------------------------------------------------------------
-- TABLE: UserLessonSettings
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table UserLessonSettings
(
	UserId int not null,
	[Public] bit not null,
	SettingsMenuShown bit not null,
	Speed int not null,
	Direction bit not null,
	InOrder bit not null,
	AccentsOn bit not null,
	ThemeId int not null,
	EntryMarkupType char(1) not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: Themes
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table Themes
(
	ThemeId int not null,
	[Code] varchar(10) not null,
	[Name] varchar(50) not null,
	BackgroundColor varchar(50) not null,
	BackgroundImage varchar(50) null,
	TextColor varchar(50) not null,
	MenuTextColor varchar(50) not null,
	HideButtonColor varchar(50) not null,
	AccentsColor varchar(50) not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: LessonViews
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LessonViews' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table LessonViews
(
	LessonId int not null,
	UserId int not null,
	NumViews int not null default(1)
)

end

go

---------------------------------------------------------------------------
-- TABLE: LessonGroups
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table LessonGroups
(
	[LessonGroupId] int identity not null,
	[Name] nvarchar(200) not null,
	[UserId] int not null,
	[DateCreated] datetime not null,
	[Speed] int not null,
	[Direction] bit not null,
	[InOrder] bit not null,
	[AccentsOn] bit not null,
	[ShowSettings] bit not null,
	[ThemeId] int not null,
	[EntryMarkupType] char(1) not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: LessonGroupLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LessonGroupLessons' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table LessonGroupLessons
(
	LessonGroupId int not null,
	LessonId int not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: UserSubscriptionHistory
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'xubuser')
begin

-- Create the table
create table UserSubscriptionHistory
(
	Id int identity not null,
	UserId int not null,
	StartDate datetime not null,
	EndDate datetime not null,
	UsageStatusCode varchar(2) not null,
	DateCreated datetime not null
)

end

go

---------------------------------------------------------------------------
-- TABLE: DemoLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DemoLessons' and TABLE_SCHEMA = 'xubuser')
begin

create table DemoLessons
(
	LessonId int not null,
	SortOrder int null,
)

end

go

