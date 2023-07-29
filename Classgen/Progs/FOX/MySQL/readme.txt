Program is written in MS Visual FoxPro 6.0 and works fine
for me. It should also work fine for any older dbf file version
foxpro 6.0 can read. 

Yes, it works with memo fields.

Creates tablename.sql file from any open and selected table 
and fills it with sql create table ... and insert ... commands 
for each record. You might want to prepend this commands with 
drop table ... command using any txt editor.

Just open table, select it and run this program. You should
find (tablename).sql file in prg directory.

There are some comments in dbf2sql.prg source you might
find useful.

If you improve this code please send it back to me and I shall 
publish it on www.j-sistem.hr/online/dev/index.htm


Danko Josic
dj@j.sistem.hr
www.j.sistem.hr
