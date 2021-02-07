* Program....: SETFONT.PRG
* Author.....: Rick Borup
* Date.......: April, 1997
*
* Description: The SetFont() function allows you to easily activate any 
*              internal font available on your printer. Use SetFont()
*              to print Windows(R)-style reports from FoxPro(R) for DOS.
*
*              Please read the accompanying README.TXT file for instructions.
*
*              SetFont() comes with a DBF for the fonts available on the 
*              HP LaserJet 4 printer. You can create your own table for
*              other printers. 
*
* Copyright..: Copyright (c) 1997 Information Technology Associates
*                 All rights reserved.
*
*              This program is distributed free of charge. 
*
*              You may redistribute SETFONT.PRG and its accompanying
*              files as long as (a) you redistribute it in its original 
*              form, with the copyright and legal notice intact, and 
*              (b) you do not charge anything for it.
*
* Legal
* Notice.....: Information Techology Associates (ITA) hereby disclaims
*              all warranties relating to this software, whether expressed
*              or implied, including without limitation any implied 
*              warranties of merchantability or fitness for a particular
*              purpose. ITA will not be liable for any damages resulting 
*              from the use of this software, including without limitation 
*              any special, incidental, consequential, indirect or similar 
*              damages due to loss of data, loss of functionality of a 
*              computer or peripheral devices, or any other reason, even 
*              if ITA has been advised of the possibility of such damages. 
*              In no event shall ITA's liability for any damages ever exceed
*              the price paid to ITA for the license to use this software, 
*              regardless of the form of the claim. The person or entity 
*              using the software bears all risk as the to quality and 
*              performance of the software.
*
* Friendly
* Notice.....: Having said all that, I hope you find this stuff useful!
*
*              Feedback and suggestions are always welcome: send e-mail
*              to infotech@prairienet.org or CompuServe 72632,1274.
*
*              This file is downloadable as SETFONT.ZIP from
*              www.prairienet.org/ita.
*              
* Version....: 1.0
* Changes....:

*컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴*
* Function...: SetFont
*
* Author.....: Rick Borup
*
* Date.......: April, 1997
*
* Copyright..: Copyright (c) 1997 Information Technology Associates
*                 All rights reserved.
*
* Description: Generate the PCL string for a given typeface and size
*
* Returns....: Character
*
* Parameters.: tcTypeFace - type face (character)
*              tnSize - point size (numeric, .25 thru 999.75),
*                       or pitch size (numeric, .10 thru 576)
*
* Notes......: Defaults to 12 point size or 10 pitch if size parameter 
*              is missing or invalid.
*
FUNCTION SetFont
parameter tcTypeFace, tnSize
if parameters() = 0 or type("tcTypeFace") != "C"
   RETURN ""
endif
if parameters() = 1 or type("tnSize") != "N"
   tnSize = 12
endif
private lnCurrArea
lnCurrArea = select()
private lcPCLString
lcPCLString = ""
if not used("fontfile")
   use locfile("hp4fonts.dbf", "DBF", "Where is HP4FONTS.DBF?") ;
       in 0 alias fontfile
endif
if not used("fontfile")
	RETURN ""
endif
select fontfile
set order to tag typeface
seek(upper(COMPRESS(tcTypeFace)))
if found()
   do case
      case upper(fontfile.vartype) = "POINT"
         if tnSize >= .25 and tnSize <= 999.75
            lcPCLString = stuff(fontfile.escseq, fontfile.varloc, 2, ;
                                alltrim(str(tnSize,6,2)))
         else
            lcPCLSring = fontfile.escseq
         endif
      case upper(fontfile.vartype) = "PITCH"
         if tnSize >= .10 and tnSize <= 576
            lcPCLString = stuff(fontfile.escseq, fontfile.varloc, 2, ;
                                alltrim(str(tnSize,6,2)))
         else
            lcPCLSring = fontfile.escseq
         endif
      otherwise		
         lcPCLString = fontfile.escseq
   endcase
else
   lcPCLString = ""
endif
select (lnCurrArea)
RETURN alltrim(lcPCLString)
*EOF SetFont

*컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴*
* Function...: Compress
*
* Author.....: Rick Borup
*
* Date.......: April, 1997
*
* Copyright..: Copyright (c) 1997 Information Technology Associates
*                 All rights reserved.
*
* Description: Compresses a string by removing all blanks.
*
* Returns....: Character
*
* Parameters.: tcString - the string to be compressed
*
* Notes......: Returns an empty string if the parameter
*              is missing or is not a character string.
*
FUNCTION Compress
parameter tcString
if parameters() = 0 or type("tcString") != "C"
	RETURN ""
endif
private lcTrimmed, lnLen, lcResult
lcTrimmed = alltrim(tcString)
lnLen = len(lcTrimmed)
lcResult = ""
private i, lcChar
FOR i = 1 to lnLen
   lcChar = substr(lcTrimmed, i, 1) 
   if lcChar != space(1)
   	lcResult = lcResult + lcChar
   endif
ENDFOR i = 1 to lnLen

RETURN lcResult
*EOF Compress

