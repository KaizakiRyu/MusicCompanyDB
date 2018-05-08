import sys
import datetime
import pymssql #import python ms sql library
from os import getenv


conn = pymssql.connect(host='cypress.csil.sfu.ca',
user='s_leom', password='nEeMttYN7qe3Af2n',
database='leom354')
conn.autocommit(True)
mycursor = conn.cursor()
inserted = False
while not inserted:
    try:
        isrc = raw_input("Please enter the ISRC of the song ")
        title = raw_input("Please enter the title of the song ")
        year = raw_input("Please enter the year of the song ")
        artistname = raw_input("Please enter the artist name of the song ")
        insert_song = ("INSERT [dbo].[Song] ([isrc], [title], [year], [artistname]) VALUES (%s,%s,%d,%s)")
        data = (isrc,title,year,artistname)
        mycursor.execute(insert_song, data)
        mycursor.close()
        inserted = True
    except Exception, e:
        print("Invalid song infomation")
        continue

mycursor = conn.cursor()
view_song = ("Select isrc, title from Song where artistname = %s" )
mycursor.execute(view_song,(artistname))
row = mycursor.fetchone()
print("")
print("List of songs associated with the Artist")
while row:
    print("ISRC: %s, title: %s"
      %(row[0], row [1]))
    row = mycursor.fetchone()
mycursor.close()

mycursor = conn.cursor()
view_musician = ("Select M.firstname, M.lastname, M.birthdate from Plays P inner join Musician M on P.artistname = %s and P.msin = M.msin" )
mycursor.execute(view_musician,(artistname))
row = mycursor.fetchone()
print("")
print("List of musician associated with the Artist")
while row:
    print("Mfirstname: %s, Mlastname: %s, birthdate = %s"
      %(row[0], row[1], row[2]))
    row = mycursor.fetchone()
mycursor.close()
