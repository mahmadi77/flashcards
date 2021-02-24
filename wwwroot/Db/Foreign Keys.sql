


---------------------------------------------------------------------------
-- Users
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_Users_CurrentUsageCode')

alter table Users
add constraint FK_Users_CurrentUsageCode
foreign key (CurrentUsageCode)
references UsageStatus(Code)

---------------------------------------------------------------------------
-- Lessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_Lessons_OwnerId')

alter table Lessons
add constraint FK_Lessons_OwnerId
foreign key (OwnerId)
references Users(UserId)

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_Lessons_ThemeId')

alter table Lessons
add constraint FK_Lessons_ThemeId
foreign key (ThemeId)
references Themes(ThemeId)

---------------------------------------------------------------------------
-- UserLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_UserLessons_UserId')

alter table UserLessons
add constraint FK_UserLessons_UserId
foreign key (UserId)
references Users (UserId)

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_UserLessons_LessonId')

alter table UserLessons
add constraint FK_UserLessons_LessonId
foreign key (LessonId)
references Lessons (LessonId)

---------------------------------------------------------------------------
-- LessonEntries
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonEntries' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_LessonEntries_LessonId')

alter table LessonEntries
add constraint FK_LessonEntries_LessonId
foreign key (LessonId)
references Lessons(LessonId)

---------------------------------------------------------------------------
-- DemoLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'DemoLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_DemoLessons_LessonId')

alter table DemoLessons
add constraint FK_DemoLessons_LessonId
foreign key (LessonId)
references Lessons(LessonId)

---------------------------------------------------------------------------
-- UserLessonSettings
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_UserLessonSettings_UserId')

alter table UserLessonSettings
add constraint FK_UserLessonSettings_UserId
foreign key (UserId)
references Users (UserId)

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_UserLessonSettings_ThemeId')

alter table UserLessonSettings
add constraint FK_UserLessonSettings_ThemeId
foreign key (ThemeId)
references Themes(ThemeId)

---------------------------------------------------------------------------
-- LessonGroups
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_LessonGroups_UserId')

alter table LessonGroups
add constraint FK_LessonGroups_UserId
foreign key (UserId)
references Users(UserId)

---------------------------------------------------------------------------
-- LessonGroupLessons
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonGroupLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_LessonGroupLessons_LessonGroupId')

alter table LessonGroupLessons
add constraint FK_LessonGroupLessons_LessonGroupId
foreign key (LessonGroupId)
references LessonGroups(LessonGroupId)

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'LessonGroupLessons' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_LessonGroupLessons_LessonId')

alter table LessonGroupLessons
add constraint FK_LessonGroupLessons_LessonId
foreign key (LessonId)
references Lessons(LessonId)

---------------------------------------------------------------------------
-- UserSubscriptionHistory
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_UserSubscriptionHistory_SubscriptionTypeCode')

alter table UserSubscriptionHistory
add constraint FK_UserSubscriptionHistory_SubscriptionTypeCode
foreign key (UsageStatusCode)
references UsageStatus(Code)

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'FK_UserSubscriptionHistory_UserId')

alter table UserSubscriptionHistory
add constraint FK_UserSubscriptionHistory_UserId
foreign key (UserId)
references Users(UserId)






