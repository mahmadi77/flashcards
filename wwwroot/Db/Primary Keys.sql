
---------------------------------------------------------------------------
-- UsageStatus
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UsageStatus' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_UsageStatus')

alter table UsageStatus
add constraint PK_UsageStatus
primary key (Code)

go

---------------------------------------------------------------------------
-- Users
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_Users')

alter table Users
add constraint PK_Users
primary key (UserId)

go

---------------------------------------------------------------------------
-- Themes
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_Themes')

alter table Themes
add constraint PK_Themes
primary key (ThemeId)

go

---------------------------------------------------------------------------
-- Lessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_Lessons')

alter table Lessons
add constraint PK_Lessons
primary key (LessonId)

go

---------------------------------------------------------------------------
-- UserLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_UserLessons')

alter table UserLessons
add constraint PK_UserLessons
primary key (LessonId, UserId)

go

---------------------------------------------------------------------------
-- LessonEntries
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonEntries' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_LessonEntries')

alter table LessonEntries
add constraint PK_LessonEntries
primary key (LessonEntryId)

go

---------------------------------------------------------------------------
-- DemoLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'DemoLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_DemoLessons')

alter table DemoLessons
add constraint PK_DemoLessons
primary key (LessonId)

go

---------------------------------------------------------------------------
-- Configuration
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Configuration' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_Configuration')

alter table Configuration
add constraint PK_Configuration
primary key (ConfigurationId)

go

---------------------------------------------------------------------------
-- UserLessonSettings
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_UserLessonSettings')

alter table UserLessonSettings
add constraint PK_UserLessonSettings
primary key (UserId)

go

---------------------------------------------------------------------------
-- LessonViews
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonViews' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_LessonViews')

alter table LessonViews
add constraint PK_LessonViews
primary key (LessonId, UserId)

go

---------------------------------------------------------------------------
-- LessonGroups
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_LessonGroups')

alter table LessonGroups
add constraint PK_LessonGroups
primary key (LessonGroupId)

go

---------------------------------------------------------------------------
-- LessonGroupLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonGroupLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_LessonGroupLessons')

alter table LessonGroupLessons
add constraint PK_LessonGroupLessons
primary key (LessonGroupId, LessonId)

go

---------------------------------------------------------------------------
-- UserSubscriptionHistory
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_UserSubscriptionHistory')

alter table UserSubscriptionHistory
add constraint PK_UserSubscriptionHistory
primary key (Id)

go

---------------------------------------------------------------------------
-- DemoLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'DemoLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'PK_DemoLessons')

alter table DemoLessons
add constraint PK_DemoLessons
primary key (LessonId)

go



