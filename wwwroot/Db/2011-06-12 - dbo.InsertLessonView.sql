USE [xublimynal]
GO

if exists (select * from information_schema.routines where routine_name = 'IncrementNumViews' and routine_schema = 'dbo')
	drop procedure dbo.IncrementNumViews
go

if exists (select * from information_schema.routines where routine_name = 'InsertLessonViews' and routine_schema = 'dbo')
	drop procedure dbo.InsertLessonView
go

create procedure [dbo].[InsertLessonView](@LessonId int, @UserId int = null)
as

insert into dbo.LessonViews
(
	LessonId,
	UserId,
	DateViewed
)
values
(
	@LessonId,
	@UserId,
	default
)

go

