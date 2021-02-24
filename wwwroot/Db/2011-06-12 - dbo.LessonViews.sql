

drop table dbo.LessonViews

create table dbo.LessonViews
(
	LessonId int not null,
	DateViewed datetime not null,
	UserId int null,
	constraint PK_LessonViews primary key
	(
		LessonId,
		DateViewed
	)
)

alter table dbo.LessonViews
add constraint DF_LessonViews_DateViewed
default getdate() for DateViewed

