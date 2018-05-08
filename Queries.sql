/*
CREATE FUNCTION checkSongDate(@artistname char(20),@year int)
RETURNS int
AS
BEGIN
DECLARE @result int
if (select year(startdate) from Artist A where A.artistname = @artistname) <= @year
SET @result = 1
ELSE
SET @result = 0
RETURN @result
END
*/

/*
ALTER TABLE Song
WITH CHECK
ADD CONSTRAINT CheckYear
CHECK (dbo.checkSongDate(artistname, year) = 0)
*/

/*
ALTER TABLE Song
drop CONSTRAINT CheckYear
*/

/*
ALTER TABLE Song
ADD CONSTRAINT Candidate_key unique (title, artistname)
*/

/*
ALTER TABLE Plays
ADD Primary key (artistname, msin)
*/

/*
create trigger Musician_Mem_Share_Insert on Plays
after insert
as
	if exists(select sum(i.share) from inserted i inner join Artist a on i.artistname = a.artistname group by i.artistname having sum(i.share) <> 1.0)
	raiserror('The sum of share is not equal',16,1)
go

create trigger Musician_Mem_Share_Update on Plays
after update
as
	if exists
	(
		select count(i.share) from inserted i right outer join plays p on i.artistname = p.artistname group by i.artistname having sum(i.share) <> 1.0
	)
	raiserror('The sum of share is not equal',16,1)
go

create trigger Musician_Mem_Share_Delete on Plays
after delete
as
	if exists(select sum(p.share) from plays p group by p.artistname having sum(p.share) <> 1.0)
	raiserror('The sum of share is not equal',16,1)
go

*/

--inserted and deleted table contain the row(s) for each insert or delete query recently made NOT ALL of the inserted and deleted queries

/*
create trigger Musician_Num_of_Mem_Insert_Update on Plays
for insert, update
as
begin
update artist set members = num.currnum from
(
select p.artistname, count(p.msin) as currnum from Plays p group by p.artistname 
) num
where artist.artistname = num.artistname
end
go
*/

/*
create trigger Musician_Num_of_Mem_Delete on Plays
for delete
as
if exists (select d.artistname from deleted d inner join plays p on d.artistname = p.artistname)
begin
	update artist set members = num.currnum from
	(
	select p.artistname, count(p.msin) as currnum from plays p group by p.artistname 
	) num
	where artist.artistname = num.artistname
end
else
begin
	update artist set members = 0 from
	(
	select p.artistname from deleted p group by p.artistname 
	) num
	where artist.artistname = num.artistname
end
go
*/



select *
from Musician M 

select *
from Artist A 

select *
from Plays P

select *
from Song S

INSERT [dbo].[Plays] ([artistname], [msin], [share]) VALUES (N'Ayumi Hamasaki      ', N'10631', CAST(0.500 AS Decimal(18, 3))),(N'Ayumi Hamasaki      ', N'10638', CAST(0.500 AS Decimal(18, 3)))
INSERT [dbo].[Plays] ([artistname], [msin], [share]) VALUES (N'Psy                 ', N'10456', CAST(1.000 AS Decimal(18, 3)))
Update [dbo].[Plays] set [share] = CAST(0.500 AS Decimal(18, 3)) where [artistname] = N'Ayumi Hamasaki      ' and [msin] = N'10631'
delete from [dbo].[Plays] where [msin] = N'10631'
delete from [dbo].[Plays] where [msin] = N'10638'

delete from [dbo].[Song] where [isrc] = N'RAT222'

INSERT [dbo].[Song] ([isrc], [title], [year], [artistname]) VALUES (N'JPEY0000000002', N'Sweet Scar          ', 2012, N'Ayumi Hamasaki      ')
