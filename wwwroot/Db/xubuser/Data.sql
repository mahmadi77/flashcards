


---------------------------------------------------------------------------
-- UsageStatus
---------------------------------------------------------------------------

-- R = Registered
if not exists (select Code from UsageStatus where Code = 'R')
	insert into UsageStatus (Description, Name, Code, Price, MaxLessons, MaxEntries, MaxPrivateLessons, MaxLessonGroups, ViewPublicLessons)
	values ('Registered only', 'Registered', 'R', 0.0, 3, 10, 1, 1, 0) 

-- S1 = Subscription level 1
if not exists (select Code from UsageStatus where Code = 'S1')
	insert into UsageStatus (Description, Name, Code, Price, MaxLessons, MaxEntries, MaxPrivateLessons, MaxLessonGroups, ViewPublicLessons)
	values ('Basic subscription', 'Basic Subscription', 'S1', 5.99, 25, 20, 10, 3, 1) 

-- S2 = Subscription level 2
if not exists (select Code from UsageStatus where Code = 'S2')
	insert into UsageStatus (Description, Name, Code, Price, MaxLessons, MaxEntries, MaxPrivateLessons, MaxLessonGroups, ViewPublicLessons)
	values ('Enhanced subscription', 'Enhanced Subscription', 'S2', 7.99, 100, 25, 50, 10, 1) 

-- S3 = Subscription level 3
if not exists (select Code from UsageStatus where Code = 'S3')
	insert into UsageStatus (Description, Name, Code, Price, MaxLessons, MaxEntries, MaxPrivateLessons, MaxLessonGroups, ViewPublicLessons)
	values ('Deluxe subscription', 'Deluxe Subscription', 'S3', 9.99, 1000, 100, 500, 100, 1) 

-- SU = Super User
if not exists (select Code from UsageStatus where Code = 'SU')
	insert into UsageStatus (Description, Name, Code, Price, MaxLessons, MaxEntries, MaxPrivateLessons, MaxLessonGroups, ViewPublicLessons)
	values ('Super User', 'Super User', 'SU', 0.0, 1000000, 1000, 1000000, 1000, 1) 

go

---------------------------------------------------------------------------
-- Themes
---------------------------------------------------------------------------

if not exists (select * from Themes where Code = 'BM')
	insert into themes values (1, 'BM', 'Brushed Metal', 'white', 'images/bg3.gif', '#221921', 'black', '#cccccc', '#167600')

if not exists (select * from Themes where Code = 'HC')
	insert into themes values (2, 'HC', 'High Contrast', 'black', null, 'green', 'green', 'green', 'yellow')

if not exists (select * from Themes where Code = 'ST')
	insert into themes values (3, 'ST', 'Standard', '#eeeeee', null, '#303030', 'black', 'black', '#55c961')

go

---------------------------------------------------------------------------
-- Configuration
---------------------------------------------------------------------------

-- Registration Email Subject
if not exists (select * from Configuration where [Key] = 'Registration.Email.Subject')
insert into Configuration ([Key], [Value], [Description]) values ('Registration.Email.Subject', 'Registration Confirmation', 'Subject line for registration email.')

-- Registration Email Body
if not exists (select * from Configuration where [Key] = 'Registration.Email.Body')
insert into
	Configuration ([Key], [Value], [Description])
values
	(
		'Registration.Email.Body',
'You''re receiving this email because you registered at xublimynal.com.  To complete your registration, please click the link below or paste it into your browser''s address bar.
{0}
',
		'The body of the registration email.'
	)

-- Registration Email From
if not exists (select * from Configuration where [Key] = 'Registration.Email.From')
insert into Configuration ([Key], [Value], [Description]) values ('Registration.Email.From', 'mail@xublimynal.com', 'Sender address for registration email.')

-- Forgot Password Email Subject
if not exists (select * from Configuration where [Key] = 'ForgotPassword.Email.Subject')
insert into Configuration ([Key], [Value], [Description]) values ('ForgotPassword.Email.Subject', 'Password reset info', 'Subject line for password reset email.')

-- Forgot Password Email Body
if not exists (select * from Configuration where [Key] = 'ForgotPassword.Email.Body')
insert into Configuration ([Key], [Value], [Description])
values
(
	'ForgotPassword.Email.Body',
	'Click on the link below to reset your password.
{0}',
	'The body of password email.'
)

-- Forgot Password Email From
if not exists (select * from Configuration where [Key] = 'ForgotPassword.Email.From')
insert into Configuration ([Key], [Value], [Description]) values ('ForgotPassword.Email.From', 'mail@xublimynal.com', 'Sender address for password email.')

-- Highlight Markup
if not exists (select * from Configuration where [Key] = 'HighlightMarkup')
insert into Configuration ([Key], [Value], [Description]) values ('HighlightMarkup', '<font color="<<ACCENT_COLOR>>">{0}</font>', 'Html markup for highlighting characters.')

-- Accent Markup
if not exists (select * from Configuration where [Key] = 'AccentMarkup')
insert into Configuration ([Key], [Value], [Description]) values ('AccentMarkup', '{0}<span style="visibility: Visible;">&amp;#0769;</span>', 'Html markup for accenting characters.')

-- Cookie Expiration in seconds
if not exists (select * from Configuration where [Key] = 'CookieExpiration')
insert into Configuration ([Key], [Value], [Description]) values ('CookieExpiration', '7200', 'Seconds before login cookie expiration.')

-- Number of Lessons Per Page during paging
if not exists (select * from Configuration where [Key] = 'NumLessonsPerPage')
insert into Configuration ([Key], [Value], [Description]) values ('NumLessonsPerPage', '100', 'Number of lessons per page.')

go

---------------------------------------------------------------------------
-- Users
---------------------------------------------------------------------------

if not exists (select * from Users where Username = 'michael')
insert into Users (Username, Email, Password, IsAdmin, VerificationGuid, Verified, CurrentUsageCode)
values ('michael', 'michael.ahmadi@yahoo.com', 'password', 1, '', 1, 'SU')

go

---------------------------------------------------------------------------
-- Lessons
---------------------------------------------------------------------------

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @StandardThemeId int
select @StandardThemeId = ThemeId from Themes where Code = 'ST'

declare @HighContrastThemeId int
select @HighContrastThemeId = ThemeId from Themes where Code = 'HC'

declare @LessonIdOut int

if not exists (select * from Lessons where LessonName = 'State Capitals' and OwnerId = @UserId)
exec InsertLesson
	@LessonName = 'State Capitals',
	@OwnerId = @UserId,
	@GloballyShared = 1,
	@Direction = 0,
	@InOrder = 0,
	@Speed = 1500,
	@AccentsOn = 0,
	@ShowSettings = 1,
	@LessonId = @LessonIdOut

if not exists (select * from Lessons where LessonName = 'Fun With Images' and OwnerId = @UserId)
exec InsertLesson
	@LessonName = 'Fun With Images',
	@OwnerId = @UserId,
	@GloballyShared = 1,
	@Direction = 0,
	@InOrder = 1,
	@Speed = 2000,
	@AccentsOn = 0,
	@ShowSettings = 0,
	@LessonId = @LessonIdOut

if not exists (select * from Lessons where LessonName = 'Languages - Foreign Characters' and OwnerId = @UserId)
exec InsertLesson
	@LessonName = 'Languages - Foreign Characters',
	@OwnerId = @UserId,
	@GloballyShared = 1,
	@Direction = 0,
	@InOrder = 1,
	@Speed = 2500,
	@AccentsOn = 1,
	@ShowSettings = 1,
	@ThemeId = @StandardThemeId,
	@LessonId = @LessonIdOut

if not exists (select * from Lessons where LessonName = 'National Anthem' and OwnerId = @UserId)
exec InsertLesson
	@LessonName = 'National Anthem',
	@OwnerId = @UserId,
	@GloballyShared = 1,
	@Direction = 0,
	@InOrder = 1,
	@Speed = 150,
	@AccentsOn = 1,
	@ShowSettings = 0,
	@ThemeId = @HighContrastThemeId,
	@EntryMarkupType = 'H',
	@LessonId = @LessonIdOut
go

---------------------------------------------------------------------------
-- LessonEntries
---------------------------------------------------------------------------

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'State Capitals'

declare @count int
select @count = COUNT(*) from LessonEntries where LessonId = @LessonId

if (@count = 0)
begin

insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Alabama', N'Montgomery', null, 1, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Alaska', N'Juneau', null, 2, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Arizona', N'Phoenix', null, 3, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Arkansas', N'Little Rock', null, 4, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'California', N'Sacramento', null, 5, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Colorado', N'Denver', null, 6, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Connecticut', N'Hartford', null, 7, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Delaware', N'Dover', null, 8, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Florida', N'Tallahassee', null, 9, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Georgia', N'Atlanta', null, 10, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Hawaii', N'Honolulu', null, 11, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Idaho', N'Boise', null, 12, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Illinois', N'Springfield', null, 13, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Indiana', N'Indianapolis', null, 14, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Iowa', N'Des Moines', null, 15, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Kansas', N'Topeka', null, 16, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Kentucky', N'Frankfort', null, 17, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Louisiana', N'Baton Rouge', null, 18, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Maine', N'Augusta', null, 19, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Maryland', N'Annapolis', null, 20, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Massachusetts', N'Boston', null, 21, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Michigan', N'Lansing', null, 22, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Minnesota', N'Saint Paul', null, 23, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Mississippi', N'Jackson', null, 24, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Missouri', N'Jefferson City', null, 25, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Montana', N'Helena', null, 26, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Nebraska', N'Lincoln', null, 27, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Nevada', N'Carson City', null, 28, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'New Hampshire', N'Concord', null, 29, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'New Jersey', N'Trenton', null, 30, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'New Mexico', N'Santa Fe', null, 31, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'New York', N'Albany', null, 32, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'North Carolina', N'Raleigh', null, 33, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'North Dakota', N'Bismarck', null, 34, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Ohio', N'Columbus', null, 35, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Oklahoma', N'Oklahoma City', null, 36, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Oregon', N'Salem', null, 37, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Pennsylvania', N'Harrisburg', null, 38, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Rhode Island', N'Providence', null, 39, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'South Carolina', N'Columbia', null, 40, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'South Dakota', N'Pierre', null, 41, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Tennessee', N'Nashville', null, 42, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Texas', N'Austin', null, 43, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Utah', N'Salt Lake City', null, 44, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Vermont', N'Montpelier', null, 45, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Virginia', N'Richmond', null, 46, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Washington', N'Olympia', null, 47, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'West Virginia', N'Charleston', null, 48, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Wisconsin', N'Madison', null, 49, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Wyoming', N'Cheyenne', null, 50, null, 0)

end

go


declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'Fun With Images'

declare @count int
select @count = COUNT(*) from LessonEntries where LessonId = @LessonId

if (@count = 0)
begin

insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/apple.jpg" />', N'apple', null, 1, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/bat.jpg" />', N'bat', null, 2, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/car.jpg" />', N'car', null, 3, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/dog.jpg" />', N'dog', null, 4, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/earth.jpg" />', N'earth', null, 5, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/flower.jpg" />', N'flower', null, 6, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/goose.jpg" />', N'goose', null, 7, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/hat.jpg" />', N'hat', null, 8, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/ice.jpg" />', N'ice', null, 9, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/jack.jpg" />', N'jack', null, 10, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/kiss.jpg" />', N'kiss', null, 11, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/log.jpg" />', N'log', null, 12, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/mouse.jpg" />', N'mouse', null, 13, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/nurse.jpg" />', N'nurse', null, 14, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/owl.jpg" />', N'owl', null, 16, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/pig.jpg" />', N'pig', null, 17, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/queen.jpg" />', N'queen', null, 18, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/rainbow.jpg" />', N'rainbow', null, 19, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/star.jpg" />', N'star', null, 20, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/turtle.jpg" />', N'turtle', null, 21, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/umbrella.jpg" />', N'umbrella', null, 22, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/vodka.jpg" />', N'vodka', null, 23, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/wolf.jpg" />', N'wolf', null, 24, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/xray.jpg" />', N'x-ray', null, 25, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/yogurt.jpg" />', N'yogurt', null, 26, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'<img style="margin-top: -1em; border: 5px solid black;" src="lessonimages/zebra.jpg" />', N'zebra', null, 27, null, 0)

end

go

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'Languages - Foreign Characters'

declare @count int
select @count = COUNT(*) from LessonEntries where LessonId = @LessonId

if (@count = 0)
begin

insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Qu''est-ce qui se passe, mec?  Tu parles français?', N'What''s happening, dude?  You speak French?', null, 1, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Ты знаешь, что мои туфли очень грязные.', N'You know my shoes are very dirty.', null, 2, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'.شیر بسیار بزرگ است', N'The lion is very big.', null, 3, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'我一个医生。', N'I think these might be Chinese characters, but I really have no clue.', null, 4, null, 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'איך דאַרף נאָך פרוץ און וועדזשטאַבאַלז אין מיין דיעטע.', N'The whole point is to show you that you can write in all different scripts.', null, 5, null, 0)

end

go


declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'National Anthem'

declare @count int
select @count = COUNT(*) from LessonEntries where LessonId = @LessonId

if (@count = 0)
begin

insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'1 2 3 4', N'1 2 3 4', N'^ 2 3 4',1, N'^ 2 3 4', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'1 2 3 4', N'1 2 3 4', N'^ 2 3 4',2, N'^ 2 3 4', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'1 2 3 4', N'1 2 3 4', N'1 ^ 3 4',3, N'1 ^ 3 4', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'1 2 3 4', N'1 2 3 4', N'1 ^ 3 4',4, N'1 ^ 3 4', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'1 2 3 4', N'1 2 3 4', N'1 2 ^ 4',5, N'1 2 ^ 4', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'1 2 3 4', N'1 2 3 4', N'1 2 ^ 4',6, N'1 2 ^ 4', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'^ o say can you see?',7, N'^ o say can you see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O ^ say can you see?',8, N'O ^ say can you see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o ^^^ can you see?',9, N'O o ^^^ can you see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o ^^^ can you see?',10, N'O o ^^^ can you see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say ^^^ you see?',11, N'O o say ^^^ you see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say ^^^ you see?',12, N'O o say ^^^ you see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can ^^^ see?',13, N'O o say can ^^^ see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can ^^^ see?',14, N'O o say can ^^^ see?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can you ^^^?',15, N'O o say can you ^^^?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can you ^^^?',16, N'O o say can you ^^^?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can you ^^^?',17, N'O o say can you ^^^?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can you ^^^?',18, N'O o say can you ^^^?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can you ^^^?',19, N'O o say can you ^^^?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say can you see?', N'O o say can you see?', N'O o say can you ^^^?',20, N'O o say can you ^^^?', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'^^ the dawn''s early light',21, N'^^ the dawn''s early light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By ^^^ dawn''s early light',22, N'By ^^^ dawn''s early light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the ^^^^^^ early light',23, N'By the ^^^^^^ early light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the ^^^^^^ early light',24, N'By the ^^^^^^ early light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s ^^^ly light',25, N'By the dawn''s ^^^ly light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s ^^^ly light',26, N'By the dawn''s ^^^ly light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s ear^^ light',27, N'By the dawn''s ear^^ light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s ear^^ light',28, N'By the dawn''s ear^^ light', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s early ^^^^^',29, N'By the dawn''s early ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s early ^^^^^',30, N'By the dawn''s early ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s early ^^^^^',31, N'By the dawn''s early ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s early ^^^^^',32, N'By the dawn''s early ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s early ^^^^^',33, N'By the dawn''s early ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'By the dawn''s early light', N'By the dawn''s early light', N'By the dawn''s early ^^^^^',34, N'By the dawn''s early ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'^^^^ so proudly we hailed',35, N'^^^^ so proudly we hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What ^^ proudly we hailed',36, N'What ^^ proudly we hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so ^^^^^ly we hailed',37, N'What so ^^^^^ly we hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so ^^^^^ly we hailed',38, N'What so ^^^^^ly we hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so ^^^^^ly we hailed',39, N'What so ^^^^^ly we hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proud^^ we hailed',40, N'What so proud^^ we hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly ^^ hailed',41, N'What so proudly ^^ hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly ^^ hailed',42, N'What so proudly ^^ hailed', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly we ^^^^^^',43, N'What so proudly we ^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly we ^^^^^^',44, N'What so proudly we ^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly we ^^^^^^',45, N'What so proudly we ^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly we ^^^^^^',46, N'What so proudly we ^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly we ^^^^^^',47, N'What so proudly we ^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'What so proudly we hailed', N'What so proudly we hailed', N'What so proudly we ^^^^^^',48, N'What so proudly we ^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'^^ the twilight''s last gleaming',49, N'^^ the twilight''s last gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At ^^^ twilight''s last gleaming',50, N'At ^^^ twilight''s last gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the ^^^light''s last gleaming',51, N'At the ^^^light''s last gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the ^^^light''s last gleaming',52, N'At the ^^^light''s last gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twi^^^^^^^ last gleaming',53, N'At the twi^^^^^^^ last gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twi^^^^^^^ last gleaming',54, N'At the twi^^^^^^^ last gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twilight''s ^^^^ gleaming',55, N'At the twilight''s ^^^^ gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twilight''s ^^^^ gleaming',56, N'At the twilight''s ^^^^ gleaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twilight''s last ^^^^^ing',57, N'At the twilight''s last ^^^^^ing', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twilight''s last ^^^^^ing',58, N'At the twilight''s last ^^^^^ing', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twilight''s last gleam^^^',59, N'At the twilight''s last gleam^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'At the twilight''s last gleaming', N'At the twilight''s last gleaming', N'At the twilight''s last gleam^^^',60, N'At the twilight''s last gleam^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'^^^^^ broad stripes and bright stars',61, N'^^^^^ broad stripes and bright stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose ^^^^^ stripes and bright stars',62, N'Whose ^^^^^ stripes and bright stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad ^^^^^^^ and bright stars',63, N'Whose broad ^^^^^^^ and bright stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad ^^^^^^^ and bright stars',64, N'Whose broad ^^^^^^^ and bright stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes ^^^ bright stars',65, N'Whose broad stripes ^^^ bright stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes ^^^ bright stars',66, N'Whose broad stripes ^^^ bright stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and ^^^^^^ stars',67, N'Whose broad stripes and ^^^^^^ stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and ^^^^^^ stars',68, N'Whose broad stripes and ^^^^^^ stars', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and bright ^^^^^',69, N'Whose broad stripes and bright ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and bright ^^^^^',70, N'Whose broad stripes and bright ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and bright ^^^^^',71, N'Whose broad stripes and bright ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and bright ^^^^^',72, N'Whose broad stripes and bright ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and bright ^^^^^',73, N'Whose broad stripes and bright ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Whose broad stripes and bright stars', N'Whose broad stripes and bright stars', N'Whose broad stripes and bright ^^^^^',74, N'Whose broad stripes and bright ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'^^^^^^^ the perilous fight',75, N'^^^^^^^ the perilous fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through ^^^ perilous fight',76, N'Through ^^^ perilous fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the ^^^ilous fight',77, N'Through the ^^^ilous fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the ^^^ilous fight',78, N'Through the ^^^ilous fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the per^lous fight',79, N'Through the per^lous fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the per^lous fight',80, N'Through the per^lous fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the peri^^^^ fight',81, N'Through the peri^^^^ fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the peri^^^^ fight',82, N'Through the peri^^^^ fight', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the perilous ^^^^^',83, N'Through the perilous ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the perilous ^^^^^',84, N'Through the perilous ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the perilous ^^^^^',85, N'Through the perilous ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the perilous ^^^^^',86, N'Through the perilous ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the perilous ^^^^^',87, N'Through the perilous ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Through the perilous fight', N'Through the perilous fight', N'Through the perilous ^^^^^',88, N'Through the perilous ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'^''er ramparts we watched',89, N'^''er ramparts we watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''^^ ramparts we watched',90, N'O''^^ ramparts we watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ^^^parts we watched',91, N'O''er ^^^parts we watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ^^^parts we watched',92, N'O''er ^^^parts we watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ^^^parts we watched',93, N'O''er ^^^parts we watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ram^^^^^ we watched',94, N'O''er ram^^^^^ we watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts ^^ watched',95, N'O''er ramparts ^^ watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts ^^ watched',96, N'O''er ramparts ^^ watched', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts we ^^^^^^^',97, N'O''er ramparts we ^^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts we ^^^^^^^',98, N'O''er ramparts we ^^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts we ^^^^^^^',99, N'O''er ramparts we ^^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts we ^^^^^^^',100, N'O''er ramparts we ^^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts we ^^^^^^^',101, N'O''er ramparts we ^^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er ramparts we watched', N'O''er ramparts we watched', N'O''er ramparts we ^^^^^^^',102, N'O''er ramparts we ^^^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'^^^^ so gallantly streaming',103, N'^^^^ so gallantly streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were ^^ gallantly streaming',104, N'Were ^^ gallantly streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so ^^^lantly streaming',105, N'Were so ^^^lantly streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so ^^^lantly streaming',106, N'Were so ^^^lantly streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gal^^^^ly streaming',107, N'Were so gal^^^^ly streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gal^^^^ly streaming',108, N'Were so gal^^^^ly streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gallant^^ streaming',109, N'Were so gallant^^ streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gallant^^ streaming',110, N'Were so gallant^^ streaming', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gallantly ^^^^^^ing',111, N'Were so gallantly ^^^^^^ing', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gallantly ^^^^^^ing',112, N'Were so gallantly ^^^^^^ing', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gallantly stream^^^',113, N'Were so gallantly stream^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Were so gallantly streaming', N'Were so gallantly streaming', N'Were so gallantly stream^^^',114, N'Were so gallantly stream^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'^^^ the rockets'' red glare',115, N'^^^ the rockets'' red glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And ^^^ rockets'' red glare',116, N'And ^^^ rockets'' red glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the ^^^^ets'' red glare',117, N'And the ^^^^ets'' red glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the ^^^^ets'' red glare',118, N'And the ^^^^ets'' red glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rock^^^^ red glare',119, N'And the rock^^^^ red glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rock^^^^ red glare',120, N'And the rock^^^^ red glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' ^^^ glare',121, N'And the rockets'' ^^^ glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' ^^^ glare',122, N'And the rockets'' ^^^ glare', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' red ^^^^^',123, N'And the rockets'' red ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' red ^^^^^',124, N'And the rockets'' red ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' red ^^^^^',125, N'And the rockets'' red ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' red ^^^^^',126, N'And the rockets'' red ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' red ^^^^^',127, N'And the rockets'' red ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the rockets'' red glare', N'And the rockets'' red glare', N'And the rockets'' red ^^^^^',128, N'And the rockets'' red ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'^^^ bombs bursting in air',129, N'^^^ bombs bursting in air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The ^^^^^ bursting in air',130, N'The ^^^^^ bursting in air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs ^^^^^ing in air',131, N'The bombs ^^^^^ing in air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs ^^^^^ing in air',132, N'The bombs ^^^^^ing in air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs burst^^^ in air',133, N'The bombs burst^^^ in air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs burst^^^ in air',134, N'The bombs burst^^^ in air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting ^^ air',135, N'The bombs bursting ^^ air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting ^^ air',136, N'The bombs bursting ^^ air', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting in ^^^',137, N'The bombs bursting in ^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting in ^^^',138, N'The bombs bursting in ^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting in ^^^',139, N'The bombs bursting in ^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting in ^^^',140, N'The bombs bursting in ^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting in ^^^',141, N'The bombs bursting in ^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'The bombs bursting in air', N'The bombs bursting in air', N'The bombs bursting in ^^^',142, N'The bombs bursting in ^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'^^^^ proof through the night',143, N'^^^^ proof through the night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'^^^^ proof through the night',144, N'^^^^ proof through the night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave ^^^^^ through the night',145, N'Gave ^^^^^ through the night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave ^^^^^ through the night',146, N'Gave ^^^^^ through the night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave ^^^^^ through the night',147, N'Gave ^^^^^ through the night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof ^^^^^^^ the night',148, N'Gave proof ^^^^^^^ the night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through ^^^ night',149, N'Gave proof through ^^^ night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through ^^^ night',150, N'Gave proof through ^^^ night', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through the ^^^^^',151, N'Gave proof through the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through the ^^^^^',152, N'Gave proof through the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through the ^^^^^',153, N'Gave proof through the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through the ^^^^^',154, N'Gave proof through the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through the ^^^^^',155, N'Gave proof through the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'Gave proof through the night', N'Gave proof through the night', N'Gave proof through the ^^^^^',156, N'Gave proof through the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'^^^^ our flag was still there',157, N'^^^^ our flag was still there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That ^^^ flag was still there',158, N'That ^^^ flag was still there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our ^^^^ was still there',159, N'That our ^^^^ was still there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our ^^^^ was still there',160, N'That our ^^^^ was still there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag ^^^ still there',161, N'That our flag ^^^ still there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag ^^^ still there',162, N'That our flag ^^^ still there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was ^^^^^ there',163, N'That our flag was ^^^^^ there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was ^^^^^ there',164, N'That our flag was ^^^^^ there', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was still ^^^^^',165, N'That our flag was still ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was still ^^^^^',166, N'That our flag was still ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was still ^^^^^',167, N'That our flag was still ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was still ^^^^^',168, N'That our flag was still ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was still ^^^^^',169, N'That our flag was still ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'That our flag was still there', N'That our flag was still there', N'That our flag was still ^^^^^',170, N'That our flag was still ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'^ o say does that star-spangled banner yet wave',171, N'^ o say does that star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O ^ say does that star-spangled banner yet wave',172, N'O ^ say does that star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o ^^^ does that star-spangled banner yet wave',173, N'O o ^^^ does that star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o ^^^ does that star-spangled banner yet wave',174, N'O o ^^^ does that star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say ^^^^ that star-spangled banner yet wave',175, N'O o say ^^^^ that star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say ^^^^ that star-spangled banner yet wave',176, N'O o say ^^^^ that star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does ^^^^ star-spangled banner yet wave',177, N'O o say does ^^^^ star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does ^^^^ star-spangled banner yet wave',178, N'O o say does ^^^^ star-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that ^^^^-spangled banner yet wave',179, N'O o say does that ^^^^-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that ^^^^-spangled banner yet wave',180, N'O o say does that ^^^^-spangled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-^^^^gled banner yet wave',181, N'O o say does that star-^^^^gled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-^^^^gled banner yet wave',182, N'O o say does that star-^^^^gled banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-span^^^^ banner yet wave',183, N'O o say does that star-span^^^^ banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-span^^^^ banner yet wave',184, N'O o say does that star-span^^^^ banner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled ^^^ner yet wave',185, N'O o say does that star-spangled ^^^ner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled ^^^ner yet wave',186, N'O o say does that star-spangled ^^^ner yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled ban^^^ yet wave',187, N'O o say does that star-spangled ban^^^ yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled ban^^^ yet wave',188, N'O o say does that star-spangled ban^^^ yet wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner ^^^ wave',189, N'O o say does that star-spangled banner ^^^ wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner ^^^ wave',190, N'O o say does that star-spangled banner ^^^ wave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet ^^^^',191, N'O o say does that star-spangled banner yet ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet ^^^^',192, N'O o say does that star-spangled banner yet ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet ^^^^',193, N'O o say does that star-spangled banner yet ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet ^^^^',194, N'O o say does that star-spangled banner yet ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet ^^^^',195, N'O o say does that star-spangled banner yet ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet wave', N'O o say does that star-spangled banner yet ^^^^',196, N'O o say does that star-spangled banner yet ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'^^^^ the land of the free',197, N'^^^^ the land of the free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er ^^^ land of the free',198, N'O''er ^^^ land of the free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the ^^^^ of the free',199, N'O''er the ^^^^ of the free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the ^^^^ of the free',200, N'O''er the ^^^^ of the free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the ^^^^ of the free',201, N'O''er the ^^^^ of the free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land ^^ the free',202, N'O''er the land ^^ the free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of ^^^ free',203, N'O''er the land of ^^^ free', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of the ^^^^',204, N'O''er the land of the ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of the ^^^^',205, N'O''er the land of the ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of the ^^^^',206, N'O''er the land of the ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of the ^^^^',207, N'O''er the land of the ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of the ^^^^',208, N'O''er the land of the ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'O''er the land of the free', N'O''er the land of the free', N'O''er the land of the ^^^^',209, N'O''er the land of the ^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'^^^ the home of the brave',210, N'^^^ the home of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And ^^^ home of the brave',211, N'And ^^^ home of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the ^^^^ of the brave',212, N'And the ^^^^ of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the ^^^^ of the brave',213, N'And the ^^^^ of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the ^^^^ of the brave',214, N'And the ^^^^ of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the ^^^^ of the brave',215, N'And the ^^^^ of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the ^^^^ of the brave',216, N'And the ^^^^ of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the ^^^^ of the brave',217, N'And the ^^^^ of the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home ^^ the brave',218, N'And the home ^^ the brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of ^^^ brave',219, N'And the home of ^^^ brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of ^^^ brave',220, N'And the home of ^^^ brave', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of the ^^^^^',221, N'And the home of the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of the ^^^^^',222, N'And the home of the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of the ^^^^^',223, N'And the home of the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of the ^^^^^',224, N'And the home of the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of the ^^^^^',225, N'And the home of the ^^^^^', 0)
insert into LessonEntries (LessonId, Entry, Translation, Accents, SortOrder, AccentsBack, Solo) values (@LessonId, N'And the home of the brave', N'And the home of the brave', N'And the home of the ^^^^^',226, N'And the home of the ^^^^^', 0)


end

go

---------------------------------------------------------------------------
-- DemoLessons
---------------------------------------------------------------------------

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'State Capitals'

if not exists (select * from DemoLessons where LessonId = @LessonId)
	insert into DemoLessons (LessonId, SortOrder) values (@LessonId, 1)

go

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'Fun With Images'

if not exists (select * from DemoLessons where LessonId = @LessonId)
	insert into DemoLessons (LessonId, SortOrder) values (@LessonId, 2)

go

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'Languages - Foreign Characters'

if not exists (select * from DemoLessons where LessonId = @LessonId)
	insert into DemoLessons (LessonId, SortOrder) values (@LessonId, 3)

go

declare @UserId int
select @UserId = UserId from Users where Username = 'michael'

declare @LessonId int
select @LessonId = LessonId from Lessons where OwnerId = @UserId and LessonName = 'National Anthem'

if not exists (select * from DemoLessons where LessonId = @LessonId)
	insert into DemoLessons (LessonId, SortOrder) values (@LessonId, 4)

go


