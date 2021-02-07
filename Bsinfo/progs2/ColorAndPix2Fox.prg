* Example
? LocalDevice2UNC("F:")
* Example
loColor = Color2Html( RGB(64,128,255) )
? loColor.cHTMLcolor
*? loColor.nR, loColor.nG, loColor.nB
* Example
loColor = Color2RGB( RGB(64,128,255) ) 
? loColor.cRGB  
? loColor.nR, loColor.nG, loColor.nB
*Example 1 of using above functions


* Convert Windows Desktop size to foxels and back
? SYSMETRIC(1), Pix2fox(SYSMETRIC(1)), Fox2pix(Pix2fox(SYSMETRIC(1)))
? SYSMETRIC(2), Pix2fox(SYSMETRIC(2), .T.), Fox2pix(Pix2fox(SYSMETRIC(2), .T.), .T.)
*Example 2 shows how to use Pix2fox() to correctly position a shortcut menu and WAIT window.


PUBLIC oform1

oform1=NEWOBJECT("form1")
oform1.Show
RETURN

DEFINE CLASS form1 AS form

    Top = 0
    Left = 0
    Caption = "Example of using Pix2fox() UDF"
    Name = "Form1"

    ADD OBJECT command1 AS commandbutton WITH ;
        Top = 140, ;
        Left = 145, ;
        Height = 27, ;
        Width = 84, ;
        Caption = "Menu", ;
        Name = "Command1"

    ADD OBJECT command2 AS commandbutton WITH ;
        Top = 40, ;
        Left = 145, ;
        Height = 27, ;
        Width = 84, ;
        Caption = "Wait", ;
        Name = "Command2"

    PROCEDURE command1.Click
        LOCAL lnPosX, lnPosY

        * Position a shortcut menu at the bottom-right corner of the button
        lnPosX = Pix2fox(This.Left + This.Width, .F.)
        lnPosY = Pix2fox(This.Top + This.Height, .T.)

        DEFINE POPUP test SHORTCUT RELATIVE FROM (lnPosY), (lnPosX)
        DEFINE BAR 1 OF test PROMPT "Menu 1" 
        DEFINE BAR 2 OF test PROMPT "Menu 2" 
        DEFINE BAR 3 OF test PROMPT "Menu 3" 
        ACTIVATE POPUP test
    ENDPROC

    PROCEDURE command2.Click
        LOCAL lnPosX, lnPosY, lnRow, lnCol

        * Position a WAIT WINDOW menu at the bottom-right corner of the button
        lnPosY = _screen.Top + Thisform.Top + SYSMETRIC(4) + SYSMETRIC(9) + This.Top + This.Height
        lnPosX = Thisform.Left + SYSMETRIC(3) + SYSMETRIC(12) + This.Left + This.Width

        lnRow = pix2fox(lnPosY, .T.,_screen.Fontname ,_screen.FontSize)
        lnCol = pix2fox(lnPosX, .F.,_screen.Fontname ,_screen.FontSize)

        WAIT WINDOW "TEST" AT (lnRow), (lnCol)
    ENDPROC

ENDDEFINE



FUNCTION LocalDevice2UNC(tcLocalName)
LOCAL lcUNCBuffer, lnLength, lcLocalName, lcRemoteName
DECLARE INTEGER WNetGetConnection IN WIN32API ;
    STRING lpLocalName, STRING @ lpRemoteName, INTEGER @ lplnLength

IF TYPE('tcLocalName') <> "C" OR EMPTY(tcLocalName) 
    ERROR 11
ENDIF
lcLocalName = ALLTRIM(tcLocalName)
lcUNCBuffer = REPL(CHR(0), 1024)
lnLength = LEN(lcUNCBuffer)
IF WNetGetConnection(lcLocalName, @lcUNCBuffer, @lnLength) = 0
    lcRemoteName = LEFT(lcUNCBuffer,AT(CHR(0),lcUNCBuffer)-1)
ELSE
    lcRemoteName = ""
ENDIF
RETURN lcRemoteName

*--------------------------------
* Converts color number to HTML color format
FUNCTION Color2Html
LPARAMETERS tnColor
LOCAL loColor
loColor = CREATEOBJECT("Empty")
ADDPROPERTY(loColor, "nR", BITAND(tnColor, 0xFF))
ADDPROPERTY(loColor, "nG", BITAND(BITRSHIFT(tnColor, 8), 0xFF))
ADDPROPERTY(loColor, "nB", BITAND(BITRSHIFT(tnColor, 16), 0xFF))
ADDPROPERTY(loColor, "cHTMLcolor", STRTRAN("#" + ;
        TRANSFORM(loColor.nR, "@0") +   ; 
        TRANSFORM(loColor.nG, "@0") +   ;
        TRANSFORM(loColor.nB, "@0"), "0x000000", "" ))
RETURN loColor
*--------------------------------
* Converts color number into RGB components and RGB() string  
FUNCTION Color2RGB
LPARAMETERS tnColor
* nColor = nR + nG*256 + nB*256*256

LOCAL loColor 
loColor = CREATEOBJECT("Empty") 
ADDPROPERTY(loColor, "nR", BITAND(tnColor, 0xFF))
ADDPROPERTY(loColor, "nG", BITAND(BITRSHIFT(tnColor, 8), 0xFF)) 
ADDPROPERTY(loColor, "nB", BITAND(BITRSHIFT(tnColor, 16), 0xFF))
ADDPROPERTY(loColor, "cRGB", "RGB(" + ;
        TRANSFORM(loColor.nR) + "," +  ; 
        TRANSFORM(loColor.nG) + "," +  ;
        TRANSFORM(loColor.nB) + ")")
RETURN loColor

*-----------------------------------------------

* Convert foxels to pixels
FUNCTION Fox2pix  
LPARAMETER tnFoxels, tlVertical, tcFontName, tnFontSize
* tnFoxels - foxels to convert
* tlVertical - .F./.T. convert horizontal/vertical coordinates
* tcFontName, tnFontSize - use specified font/size or current form (active output window) font/size, if not specified 

LOCAL lnPixels

IF PCOUNT() > 2
    lnPixels = tnFoxels * FONTMETRIC(IIF(tlVertical, 1, 6), tcFontName, tnFontSize)
ELSE
    lnpixels = tnFoxels * FONTMETRIC(IIF(tlVertical, 1, 6))
ENDIF    

RETURN lnPixels 
*------------------------------------

* Convert pixels to foxels 
FUNCTION Pix2fox
LPARAMETER tnPixels, tlVertical, tcFontName, tnFontSize
* tnPixels - pixels to convert
* tlVertical - .F./.T. convert horizontal/vertical coordinates
* tcFontName, tnFontSize - use specified font/size or current form (active output window) font/size, if not specified 
LOCAL lnFoxels

IF PCOUNT() > 2
    lnFoxels = tnPixels/FONTMETRIC(IIF(tlVertical, 1, 6), tcFontName, tnFontSize)
ELSE
    lnFoxels = tnPixels/FONTMETRIC(IIF(tlVertical, 1, 6))
ENDIF    

RETURN lnFoxels
