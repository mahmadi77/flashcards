
---------------------------------------------------------------------------
-- UsageStatus
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UsageStatus' and TABLE_SCHEMA = 'xubuser' and CONSTRAINT_NAME = 'UK_UsageStatus')

alter table UsageStatus
add constraint UK_UsageStatus
unique (Code)

go

---------------------------------------------------------------------------
-- Users
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'xubuser' and CONSTRAINT_NAME = 'UK_Users_Email')

alter table Users
add constraint UK_Users_Email
unique (Email)

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Users' and TABLE_SCHEMA = 'xubuser' and CONSTRAINT_NAME = 'UK_Users_Username')

alter table Users
add constraint UK_Users_Username
unique (Username)

go

---------------------------------------------------------------------------
-- Themes
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Themes' and TABLE_SCHEMA = 'xubuser' and CONSTRAINT_NAME = 'UK_Themes')

alter table Themes
add constraint UK_Themes
unique ([Code])

go

---------------------------------------------------------------------------
-- Configuration
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'Configuration' and TABLE_SCHEMA = 'xubuser' and CONSTRAINT_NAME = 'UK_Configuration')

alter table Configuration
add constraint UK_Configuration
unique ([Key])

go

---------------------------------------------------------------------------
-- UserSubscriptionHistory
---------------------------------------------------------------------------

if not exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'UserSubscriptionHistory' and TABLE_SCHEMA = 'xubuser' and CONSTRAINT_NAME = 'UK_UserSubscriptionHistory')

alter table UserSubscriptionHistory
add constraint UK_UserSubscriptionHistory
unique (UserId, StartDate, EndDate, UsageStatusCode)

go



