                     Notes on Using the SETFONT() Function
                     
1. Purpose of SETFONT()
2. What Printers Does SETFONT() Work With?
3. How Do I Add SETFONT() To My Application?
4. How Do I Call SETFONT()?
5. Working with Proportional Fonts in FoxPro for DOS
6. Using SETFONT() with @...SAY
7. Using SETFONT() with the Report Writer
APPENDIX: Structure of the Font Table

-----------------------
1. Purpose of SETFONT()
-----------------------
I wrote SETFONT() to make it easy to use a printer's resident, or internal, fonts when generating reports in FoxPro for DOS. Many printers come with a set of resident fonts, and all that's required to invoke them is to send the printer the appropriate character string, called an escape sequence. It's called an escape sequence because it starts with the ASCII escape character, chr(27). 

Of course, you could always hard-code the necessary escape sequences into your FoxPro application, for example as memory variables or compile-time constants, but it's more than a little tedious to type them in. In addition, most of the fonts are scalable and the escape sequence is slightly different for each size. A complete list of all available fonts in all available sizes would be a long list indeed!

The SETFONT() function allows you to simply specify the font name and size you want, and it then returns the appropriate escape sequence. It does this by looking up the escape sequence in a table and modifying it 'on the fly' for the desired size. All you need to know is what font name and size you want, and SETFONT() gives you the correct escape sequence.

------------------------------------------
2. What Printers Does SETFONT() Work With?
------------------------------------------
SETFONT() will work with any printer that has internal fonts. It comes with a table called HP4FONTS.DBF which contains the escape sequences and other necessary data for the resident fonts found in the Hewlett-Packard LaserJet 4 (HP4) printer. HP4FONTS.DBF is an ordinary FoxPro table which you can browse, edit or add to as needed. 

If you're using another printer, check its user manual to find out what resident fonts, if any, are available. Some printers, such as the HP4, can generate a list of their resident fonts for you, showing the font names, escape sequences, and other information. Once you have the font information for your particular printer, simply make a copy of HP4FONTS.DBF under a new name and edit it to correspond to your printer's fonts. Then replace any occurrences of "HP4FONTS.DBF" in the SETFONT() source code with the name of your table. [In some future edition of SETFONT() I'll make the table name a parameter so you won't have to hard-code it.]

If you create your own font table, you'll also need to create a structural index file with a tag named TYPEFACE whose index expression is UPPER(TYPEFACE). See the section entitled "Structure of the Font Table" in this README file for complete information on the structure of the font table.

--------------------------------------------
3. How Do I Add SETFONT() To My Application?
--------------------------------------------
To add SETFONT() to your application, cut the SETFONT() and COMPRESS() functions from SETFONT.PRG and paste them into your application's main procedure file. The SETFONT() function calls the COMPRESS() function to remove embedded spaces from the font name parameter.

Alternatively, you can add SETFONT.PRG to your app and then SET PROCEDURE TO SETFONT before issuing any calls to the SETFONT() function. Please note that SETFONT.PRG is simply a shell I used to distribute the two functions. It isn't a runnable program and writing DO SETFONT.PRG in your app won't do anything useful.

In either case, you also need to include the font table in your app, either HP4FONTS.DBF or your own font table. SETFONT() doesn't modify the font table so you can embed it in your app as a read-only file, or you can distribute it as an external file.

---------------------------
4. How Do I Call SETFONT()?
---------------------------
SETFONT() is a FoxPro function which you call like any other UDF. It requires one parameter, the font name. An optional second parameter can be used to specify the font size, which is expressed in terms of point or pitch depending on the font. 

For example, if you wanted to store the escape sequence for CG Times 10-point Bold to a memvar called lcTimes10B, you could write

     lcTimes10B = SetFont("CG Times Bold", 10)

The first parameter, the font name, must be a character string and must correspond to one of the entries in the TYPEFACE column of the font table. It is not case sensitive, and you can have embedded blanks for readability. In the example above, you could pass "CG Times Bold", "CGTIMESBOLD" or even "c g times bold" as the font name. If this parameter is missing or invalid, or if the value passed cannot be found in the font table, SETFONT() returns the empty string "".

Note the SETFONT() does not change the value of SET EXACT. If SET EXACT is OFF, you can use a partial string for the font name and SETFONT() will find a match if one exists (for example, "CG" will find "CG Times"). If SET EXACT is ON, you'll need to pass the full name of the font.

The second parameter, the font size, must be a numeric value and must be within the range of permissible values, which on the HP4 are .25 thru 999.75 for fonts with point sizes, and .10 thru 576 for fonts with pitch sizes. These limits are hard-coded into SETFONT(). If this parameter is omitted or invalid, SETFONT() uses a default of 12 point or 10 pitch.

----------------------------------------------------
5. Working with Proportional Fonts in FoxPro for DOS
----------------------------------------------------
Working with proportional fonts in FoxPro for DOS is more of an art than a science, and somewhat of a black art at that. In FoxPro for DOS, we're used to working with non-proportional fonts both on our screens and our reports. With a non-proportional font, every character occupies the same width, and so a report can be said to be 'x' characters wide. At the conventional 10 characters per inch (10 cpi), 80 characters is 8 inches, which of course fits nicely on standard 8 1/2 by 11" paper.

Most of the fonts we like to use in Windows(R), however, are proportional fonts, meaning the width of each character is proportional to the character itself: an "n" is narrower than an "m", for example. Many of the resident fonts in a printer are proportional fonts. This after all is why we want to use them. However, this means we can no longer talk about a report being 'x' number of characters wide or about a field starting in column 'y' of a report. In Windows(R), of course, we can refer to these things in inches, but in FoxPro for DOS we're stuck with specifying character positions even if we use proportional fonts. This leads to some interesting challenges.

With a proportional font, an 8-inch report width may accomodate 40 characters or it may accomodate 160 characters, depending on which character in what font and at what size you're talking about. If you use @...SAY commands in a report procedure using proportional fonts, you'll find that you'll often need to specify a "column" above 80 in order to print toward the right-hand side of the page. If you're using FoxPro's Report Writer, you'll want to set the report's right margin to a number higher than 80 even if you're designing a report which will be printed on 8 1/2 by 11" paper. This will allow you to position fields far enough to the right on the report design surface in order to use the entire 8-inch printable area of the paper. 

Lining up columns when using proportional fonts in FoxPro for DOS is tricky. I've found a couple of approaches that work pretty well when you're using @...SAY commands to generate the report. It's harder when using the Report Writer. Read the next two sections for more information, but the general rule is that it will be a process of trial and error.

-------------------------------
6. Using SETFONT() with @...SAY
-------------------------------
To use SETFONT() in a report procedure using @...SAY commands, simply include SETFONT() at the appropriate point in your code, preceeding the line(s) you want to print with the specified font. For example, to print in Times New Roman 11 point starting in line 7 of a report, simply write

     @7,0 say SETFONT("Times New", 11)
     
in your procedure. Everything printed thereafter will be in Times New Roman 11 point font, until the printer is reset or it receives a different escape sequence.

If you're going to be using the same SETFONT() string more than once in your app, you can improve performance a little bit by assigning the SETFONT() value to a memory variable or compile-time constant at the beginning of your app, instead of calling the function each time you need that string.

As noted earlier, aligning columns with proportional fonts is tricky because you can't rely on the column value of the @...SAY command to always be in the same physical location on the page from one line to the next. Let's say we want to print the following three lines in Arial 10 point, in such a way that the amounts all line up in a column:

     Total Sales                           $ 10,000.00
     Cost of Goods Sold                       8,500.00
     Gross Profit                             1,500.00

You could tell FoxPro to @...SAY each of the three amount fields at column 120, for example, but when they're printed in Arial font they won't be properly aligned because the location of column 120 isn't the same on each line. 

However, the distance from the left margin to the left edge of the amount column IS fixed when measured in inches, and once you know how many Arial 10-point spaces it takes to cover that distance, you can use it to line up the amount column. Assuming this works out to be 120 Arial 10-point spaces, and that this portion of the report starts on line 10, then the code could look like this:

     @ 10,0 say "Total Sales"
     @ 10,0 say space(120)
     @ 10,$ say lcTotSales

     @ 11,0 say "Cost of Goods Sold"
     @ 11,0 say space(120)
     @ 11,$ say lcCOGS

     @ 12,0 say "Gross Profit"      
     @ 12,0 say space(120)
     @ 12,$ say lcGProfit
     
By starting the "space(120)" in column 0 (the left margin), you move to the right the same distance each time, regardless of how much space the label on that line used up. Notice that you can print spaces on top of something you've already printed without causing a problem!

In order to decimal align the amount fields, you'll probably want to convert them to fixed-length strings with enough leading spaces to make them all the same size. Hence the character memvar names "lcTotSales" etc. in the example above. A good rule of thumb is to use two proportional-font spaces for each character position you want to leave blank. The result isn't exact but it's usually close enough to look good. If you want more information about a specific font, take a look at the FONTMETRIC() function in FoxPro for Windows(R).

-----------------------------------------
7. Using SETFONT() with the Report Writer
-----------------------------------------
You can use SETFONT() with FoxPro's Report Writer too. If you have already created a memory variable or compile-time constant in your app for the needed escape sequences, simply use it as a field on your report. If not, then you can create report variables and set their value to the SETFONT() expression you want. For example, to make Arial Bold 12 point available to your report, define a report variable called "lcArial12B" and set its value to SETFONT("Arial Bold", 12). Create as many different report variables as you need, one for each different font you want to use in the report. 

To invoke a font, simply insert a field to "print" the desired escape sequence at the appropriate place on the report. Be sure to make your field wide enough to accept the entire escape sequence. If you make the field 10 characters wide, for example, and the escape sequence is 20 characters long, the string will be truncated, the font change won't work and results will be unpredictable.

You'll want to set the report width (the "Right margin column" value in the Page Layout dialog) to something higher than 80 to be able to access the entire width of an 8 1/2 by 11-inch sheet of paper in portrait mode.

You can place the SETFONT() fields anywhere on the report. Since the escape sequence doesn't actually print, it doesn't take up any room on the printed page, but its field does take up room on the report design surface. If you can, you may want to place the SETFONT() fields on a line by themselves. If this isn't possible you may need to overlay a SETFONT() field with an actual field on the same line in your report. In this case you can probably use the "Bring to front" and "Send to back" feature to control what gets printed first. I haven't tried this yet - if you do, I'd like to know how it worked out for you.

-------------------------------------
APPENDIX: Structure of the Font Table
-------------------------------------
The font table contains one record for each available font. Bold and italic variations count as separate fonts, but size does not. Size is controlled by a variable embedded in the escape sequence, which is done by SETFONT() at run time.

The fields in the font table are as follows:

     TYPEFACE   Character     30     The name of the font (this must be
                                     entered with no embedded spaces)

     ESCSEQ     Character     30     The PCL escape sequence (see below for
                                     how to type in the 'escape' character)

     VARTYPE    Character      6     The type of size variable ("POINT" or
                                     "PITCH")

     VARLOC     Numeric        2     The location of the size field within
                                     the escape sequence

     VARTERM    Character      1     The character which terminates the
                                     size field (not used at present)

You can't type the 'escape' character directly in FoxPro, even if you use the Alt-0-2-7 method, because FoxPro reacts as if you had actually pressed the ESC key. To insert the escape character into a string, open the ASCII Chart from FoxPro's System menu, select the escape character, and then copy and paste it into your string. Note that escape sequences are case sensitive. 


Rick Borup
Information Technology Associates
Champaign, IL
April, 1997

Comments, suggestions and feedback are welcome!
     rborup@prairienet.org
     CompuServe 72632,1274
     www.prairienet.org/ita

                                   ::