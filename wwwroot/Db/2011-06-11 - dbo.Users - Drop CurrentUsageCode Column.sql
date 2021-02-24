
alter table dbo.Users
drop constraint DF_Users_CurrentUsageCode
go

alter table dbo.Users
drop constraint FK_Users_CurrentUsageCode
go

alter table dbo.Users
drop column CurrentUsageCode
go

