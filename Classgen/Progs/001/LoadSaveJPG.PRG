
* select a JPG:
liBlob = FileToStr(GetPict())

* we can save it in a table (even SQL Server supports it)
Insert into images (nID,bImage) values (1,liBlob)

Browse Last Nocaptions

* say we retrieved the BLOB and we want to save it back to a JPG:
StrToFile(liBlob, "c:\temp\myImage.jpg")

