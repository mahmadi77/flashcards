

---------------------------------------------------------------------------
-- Users
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'IsAdmin') is null)

alter table Users
add constraint DF_Users_IsAdmin
default 0 for IsAdmin

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Verified') is null)

alter table Users
add constraint DF_Users_Verified
default 0 for Verified

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'DateCreated') is null)

alter table Users
add constraint DF_Users_DateCreated
default getdate() for DateCreated

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'CurrentUsageCode') is null)

alter table Users
add constraint DF_Users_CurrentUsageCode
default 'R' for CurrentUsageCode

go

---------------------------------------------------------------------------
-- Themes
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'BackgroundColor') is null)

alter table Themes
add constraint DF_Themes_BackgroundColor
default '#ffffff' for BackgroundColor

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'TextColor') is null)

alter table Themes
add constraint DF_Themes_TextColor
default '#000000' for TextColor

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'MenuTextColor') is null)

alter table Themes
add constraint DF_Themes_MenuTextColor
default '#000000' for MenuTextColor

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'HideButtonColor') is null)

alter table Themes
add constraint DF_Themes_HideButtonColor
default '#000000' for HideButtonColor

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'AccentsColor') is null)

alter table Themes
add constraint DF_Themes_AccentsColor
default '#00ff00' for AccentsColor

go

---------------------------------------------------------------------------
-- Lessons
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Speed') is null)

alter table Lessons
add constraint DF_Lessons_Speed
default 2000 for Speed

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Direction') is null)

alter table Lessons
add constraint DF_Lessons_Direction
default 0 for Direction

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'InOrder') is null)

alter table Lessons
add constraint DF_Lessons_InOrder
default 0 for InOrder

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'AccentsOn') is null)

alter table Lessons
add constraint DF_Lessons_AccentsOn
default 1 for AccentsOn

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'ShowSettings') is null)

alter table Lessons
add constraint DF_Lessons_ShowSettings
default 1 for ShowSettings

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'EntryMarkupType') is null)

alter table Lessons
add constraint DF_Lessons_EntryMarkupType
default 'A' for EntryMarkupType

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Lessons' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'DateCreated') is null)

alter table Lessons
add constraint DF_Lessons_DateCreated
default getdate() for DateCreated

go

---------------------------------------------------------------------------
-- LessonEntries
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonEntries' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Solo') is null)

alter table LessonEntries
add constraint DF_LessonEntries_Solo
default 0 for Solo

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonEntries' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'DateCreated') is null)

alter table LessonEntries
add constraint DF_LessonEntries_DateCreated
default getdate() for DateCreated

go

---------------------------------------------------------------------------
-- UserLessonSettings
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Public') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_Public
default 1 for [Public]

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'SettingsMenuShown') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_SettingsMenuShown
default 1 for SettingsMenuShown

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Speed') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_Speed
default 2000 for Speed

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Direction') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_Direction
default 0 for Direction

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'InOrder') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_InOrder
default 0 for InOrder

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'AccentsOn') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_AccentsOn
default 1 for AccentsOn

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'ThemeId') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_ThemeId
default 1 for ThemeId

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserLessonSettings' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'EntryMarkupType') is null)

alter table UserLessonSettings
add constraint DF_UserLessonSettings_EntryMarkupType
default 'A' for EntryMarkupType

go

---------------------------------------------------------------------------
-- LessonGroups
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'DateCreated') is null)

alter table LessonGroups
add constraint DF_LessonGroups_DateCreated
default getdate() for DateCreated

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Speed') is null)

alter table LessonGroups
add constraint DF_LessonGroups_Speed
default 2000 for Speed

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'Direction') is null)

alter table LessonGroups
add constraint DF_LessonGroups_Direction
default 0 for Direction

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'InOrder') is null)

alter table LessonGroups
add constraint DF_LessonGroups_InOrder
default 0 for InOrder

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'AccentsOn') is null)

alter table LessonGroups
add constraint DF_LessonGroups_AccentsOn
default 1 for AccentsOn

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'ShowSettings') is null)

alter table LessonGroups
add constraint DF_LessonGroups_ShowSettings
default 1 for ShowSettings

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'EntryMarkupType') is null)

alter table LessonGroups
add constraint DF_LessonGroups_EntryMarkupType
default 'A' for EntryMarkupType

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonGroups' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'ThemeId') is null)

alter table LessonGroups
add constraint DF_LessonGroups_ThemeId
default 1 for ThemeId


go

---------------------------------------------------------------------------
-- UserSubscriptionHistory
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'StartDate') is null)

alter table UserSubscriptionHistory
add constraint DF_UserSubscriptionHistory_StartDate
default getdate() for StartDate

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'EndDate') is null)

alter table UserSubscriptionHistory
add constraint DF_UserSubscriptionHistory_EndDate
default dateadd(mm, 1, getdate()) for EndDate

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'UsageStatusCode') is null)

alter table UserSubscriptionHistory
add constraint DF_UserSubscriptionHistory_UsageStatusCode
default 'R' for UsageStatusCode

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'DateCreated') is null)

alter table UserSubscriptionHistory
add constraint DF_UserSubscriptionHistory_DateCreated
default getdate() for DateCreated

go

---------------------------------------------------------------------------
-- LessonAccesses
---------------------------------------------------------------------------

if ((select COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'LessonAccesses' and TABLE_SCHEMA = 'dbo' and COLUMN_NAME = 'DateCreated') is null)

alter table LessonAccesses
add constraint DF_LessonAccesses_DateAccessed
default getdate() for DateAccessed

go



