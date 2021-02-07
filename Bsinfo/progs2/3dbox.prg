***************************************************************************
*
* Procedure file: 3DBOX.PRG
* System: 3DBox
* Version: 1.5
* Author: Bill Anderson
* Copyright: None (Public Domain)
*
***************************************************************************
*
* 3DBOX - 3D Box Generator.
*
* Description:
* This program is used to draw a 3-D box.
*
* * * * PARAMETER MEMORY VARIABLES * * *
*
* m.boxrow = holds the beginning row of the box.
* m.boxcol = holds the beginning column of the box.
* m.boxhgt = holds the height of the drawn box.
* m.boxwdth = holds the width of the drawn box.
* m.boxpenw = holds the pen width of the bevel.
* m.sunr = holds the red color intensity of
* the sun color.
* m.sung = holds the green color intensity of
* the sun color.
* m.sunb = holds the blue color intensity of
* the sun color.
* m.shader = holds the red color intensity of
* the shade color.
* m.shadeg = holds the green color intensity of
* the shade color.
* m.shadeb = holds the blue color intensity of
* the shade color.
* m.facer = holds the red color intensity of
* the face color.
* m.faceg = holds the green color intensity of
* the face color.
* m.faceb = holds the blue color intensity of
* the face color.
* m.outliner = holds the red color intensity of
* the outline color.
* m.outlineg = holds the green color intensity of
* the outline color.
* m.outlineb = holds the blue color intensity of
* the outline color.
* m.pattern = holds the pattern of the face of the
* 3-D box.
* m.pentype = holds the pen type used for
* the outline box.
*
* * * * DECLARED MEMORY VARIABLES * * *
*
* m.curpenw = holds the passed pen width.
* m.tempr = holds the red sun color intensity.
* Used for in-laid effects.
* m.tempg = holds the green sun color intensity.
* Used for in-laid effects.
* m.tempb = holds the blue sun color intensity.
* Used for in-laid effects.
* m.out_on = used as a logical variable in order to
* determine whether the outline box
* should be drawn.
* m.setdec = holds the previous SET DECIMAL setting
* m.curfont = holds the font type used to calculate
* the pixel lengths.
* m.cursize = holds the font size used to calculate
* the pixel lengths.
* m.curstyle = holds the font style used to calculate
* the pixel lengths.
* m.hclength = holds the horizontal pixel to
* character ratio.
* m.vclength = holds the vertical pixel to
* character ratio.
* m.currow = holds the passed row.
* m.curcol = holds the passed column.
* m.looppen = holds the interim pen value for the boxes
* and triangles.
* m.prevpen = holds the previous pen value when
* going through the drawing loop.
* m.counter = a counter.
* mcounter = another counter.
*
*
************************************************************************
* Example:
*
* DO 3DBOX.PRG WITH 6, 10, 10, 5, 4, 255, 255, 255, ;
* 128, 128, 128, 192, 192, 192, 0, 0, 0, 1, -1
*
************************************************************************
*

PARAMETERS boxrow, boxcol, boxhgt, boxwdth, boxpenw, sunr, sung, sunb,;
shader, shadeg, shadeb, facer, faceg, faceb, outliner, outlineg, outlineb,;
pattern, pentype

PRIVATE curpenw, tempr, tempg, tempb, out_on, setdec, curfont, cursize,;
curstyle, hclength, vclength, currow, curcol, looppen, prevpen, counter,;
mcounter, row, col

** Windows/Mac platform test
IF TYPE([_WINDOWS])# [L] OR (NOT _WINDOWS AND NOT _MAC)

  RETURN .f.

ENDIF TYPE([_WINDOWS])# [L] OR (NOT _WINDOWS AND NOT _MAC)
** End windows platform test

** Negative row test
IF m.boxrow < 0

  WAIT WINDOW [Negative row provided for this box.] NOWAIT
  RETURN .f.

ENDIF m.boxrow < 0
** End negative row test

** Negative column test
IF m.boxcol < 0

  WAIT WINDOW [Negative column provided for this box.] NOWAIT
  RETURN .f.

ENDIF m.boxcol < 0
** End negative column test

** Bad height test
IF m.boxhgt <= 0

  WAIT WINDOW [Invalid height provided for this box.] NOWAIT
  RETURN .f.

ENDIF m.boxhgt <= 0
** End bad height test

** Bad width test
IF m.boxwdth <= 0

  WAIT WINDOW [Invalid width provided for this box.] NOWAIT
  RETURN .f.

ENDIF m.boxwdth <= 0
** End bad width test

** Empty button face pattern test
IF TYPE([m.pattern]) # [N] OR EMPTY(m.pattern)

  m.pattern = 1

ENDIF TYPE([m.pattern]) # [N] OR EMPTY(m.pattern)
** End empty button face pattern test

** Empty outline pen type test
IF TYPE([m.pentype]) # [N] OR EMPTY(m.pentype)

  m.pentype = -1

ENDIF EMPTY([m.pentype])
** End empty outline pen type test

** Width too long test
IF m.boxcol + m.boxwdth >= WCOLS()

  WAIT WINDOW [Box width too long for window.] NOWAIT
  RETURN .f.

ENDIF m.boxcol + m.boxwdth >= WCOLS()
** End width too long test

** Height too big test
IF m.boxrow + m.boxhgt >= WROWS()

  WAIT WINDOW [Box height too big for window.] NOWAIT
  RETURN .f.

ENDIF m.boxrow + m.boxhgt >= WROWS()
** End height too big test

m.curpenw = m.boxpenw

** Pen width type test
IF TYPE([m.curpenw]) # [N]

  m.curpenw = 0

ENDIF TYPE([m.curpenw]) # [N]
** End pen width type test

** Pen width value test
IF BETWEEN(m.curpenw, -2, 2)

  m.curpenw = ROUND(m.curpenw, 0)

ENDIF BETWEEN(m.curpenw, -2, 2)
** End pen width value test

** Memory variable type test
IF TYPE([m.sunr]) # [N]

  m.sunr = 255

ENDIF TYPE([m.sunr]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.sung]) # [N]

  m.sung = 255

ENDIF TYPE([m.sung]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.sunb]) # [N]

  m.sunb = 255

ENDIF TYPE([m.sunb]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.shader]) # [N]

  m.shader = 128

ENDIF TYPE([m.shader]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.shadeg]) # [N]

  m.shadeg = 128

ENDIF TYPE([m.shadeg]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.shadeb]) # [N]

  m.shadeb = 128

ENDIF TYPE([m.shadeb]) # [N]
** End memory variable type test

** In-laid box test
IF m.curpenw < 0

  m.tempr = m.sunr
  m.tempg = m.sung
  m.tempb = m.sunb
  m.sunr = m.shader
  m.sung = m.shadeg
  m.sunb = m.shadeb
  m.shader = m.tempr
  m.shadeg = m.tempg
  m.shadeb = m.tempb
  m.curpenw = -m.curpenw

ENDIF m.curpenw < 0
** End in-laid box test

** Memory variable type test
IF TYPE([m.facer]) # [N]

  m.facer = 192

ENDIF TYPE([m.facer]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.faceg]) # [N]

  m.faceg = 192

ENDIF TYPE([m.faceg]) # [N]
** End memory variable type test

** Memory variable type test
IF TYPE([m.faceb]) # [N]

  m.faceb = 192

ENDIF TYPE([m.faceb]) # [N]
** End memory variable type test

** Outline color parameter passing test
IF TYPE([m.outliner]) # [N] AND ;
TYPE([m.outlineg]) # [N] AND TYPE([m.outlineb]) # [N]

  m.out_on = .f.
  STORE 192 TO m.outliner, m.outlineg, m.outlineb

ELSE

  m.out_on = .t.

  ** Memory variable type test
  IF TYPE([m.outliner]) # [N]

    m.outliner = 192

  ENDIF TYPE([m.outliner]) # [N]
  ** End memory variable type test

  ** Memory variable type test
  IF TYPE([m.outlineg]) # [N]

    m.outlineg = 192

  ENDIF TYPE([m.outlineg]) # [N]
  ** End memory variable type test

  ** Memory variable type test
  IF TYPE([m.outlineb]) # [N]

    m.outlineb = 192

  ENDIF TYPE([m.outlineb]) # [N]
  ** End memory variable type test

ENDIF TYPE([m.outliner]) # [N] AND ;
TYPE([m.outlineg]) # [N] AND TYPE([m.outlineb]) # [N]
** End outline color parameter passing test

m.setdec = SET([DECIMALS])
SET DECIMALS TO 15
m.woutput = WOUTPUT()
m.curfont = WFONT(1, m.woutput) && holds the current font
m.cursize = WFONT(2, m.woutput) && holds the current size
m.curstyle = WFONT(3, m.woutput) && holds the current style
m.hclength = FONTMETRIC(6, m.curfont, m.cursize, m.curstyle)
m.vclength = FONTMETRIC(1, m.curfont, m.cursize, m.curstyle) + ;
FONTMETRIC(5, m.curfont, m.cursize, m.curstyle)

** Pen thickness test
IF m.hclength * m.boxwdth <= m.curpenw * 2

  WAIT WINDOW [Pen width along horizontal axis too thick.] NOWAIT
  SET DECIMALS TO (m.setdec)
  RETURN .f.

ENDIF m.hclength * m.boxwdth <= m.curpenw * 2
** End pen thickness test

** Pen thickness test
IF m.vclength * m.boxhgt <= m.curpenw * 2

  WAIT WINDOW [Pen width along vertical axis too thick.] NOWAIT
  SET DECIMALS TO (m.setdec)
  RETURN .f.

ENDIF m.hclength * m.boxwdth <= m.curpenw * 2
** End pen thickness test

m.currow = m.boxrow
m.curcol = m.boxcol
m.looppen = m.curpenw

** Box drawing loop
FOR m.counter = 1 TO CEILING(m.curpenw / 6)

   m.looppen = IIF(m.looppen < 7, m.looppen, 6)

   ** First time through test
   IF m.counter = 1

     m.prevpen = m.looppen

   ENDIF m.counter = 1
   ** End first time through test

   DO BOXDRAW

   ** Row adjustment test
   IF m.counter < CEILING(m.curpenw / 6)

     m.boxrow = m.boxrow + (m.looppen / m.vclength)
     m.boxcol = m.boxcol + (m.looppen / m.hclength)
     m.prevpen = m.looppen
     m.looppen = m.curpenw - (6 * m.counter)

   ENDIF m.counter < CEILING(m.curpenw / 6)
   ** End row adjustment test

ENDFOR m.counter = 1 TO CEILING(m.curpenw / 6)
** End box drawing loop

** Button face
@ m.currow + (m.curpenw / m.vclength), ;
m.curcol + (m.curpenw / m.hclength) TO ;
(m.currow + m.boxhgt) - (m.curpenw / m.vclength), ;
(m.curcol + m.boxwdth) - (m.curpenw / m.hclength) ;
PATTERN m.pattern COLOR ;
RGB(m.facer, m.faceg, m.faceb, m.facer, m.faceg, m.faceb)

** Outline box drawing test
IF m.out_on

  @ m.currow, m.curcol TO m.currow + m.boxhgt, m.curcol + m.boxwdth ;
  PATTERN 0 PEN 0, m.pentype STYLE [1] ;
  COLOR RGB(m.outliner, m.outlineg, m.outlineb, ;
  m.outliner, m.outlineg, m.outlineb)

ENDIF m.out_on
** End outline box drawing test

SET DECIMALS TO (m.setdec)

RETURN

*****************
PROCEDURE BOXDRAW
*****************

** Top line
@ m.boxrow, m.boxcol TO m.boxrow, m.boxcol + ;
(m.boxwdth - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.hclength)) ;
PATTERN 0 PEN m.looppen STYLE [0] ;
COLOR RGB(m.sunr, m.sung, m.sunb, m.sunr, m.sung, m.sunb)

** Upper right triangles
DO TRIANGLES WITH m.boxrow, m.boxcol + ;
(m.boxwdth - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.hclength))

** Left line
@ m.boxrow + (m.looppen / m.vclength), m.boxcol TO ;
m.boxrow + (m.boxhgt - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.vclength)), m.boxcol ;
PATTERN 0 PEN m.looppen STYLE [0] ;
COLOR RGB(m.sunr, m.sung, m.sunb, m.sunr, m.sung, m.sunb)

** Right line
@ m.boxrow + (m.looppen / m.vclength), ;
m.boxcol + (m.boxwdth - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.hclength)) TO ;
m.boxrow + m.boxhgt - ;
((((m.counter - 1) * 2) * m.prevpen) / m.vclength), ;
m.boxcol + (m.boxwdth - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.hclength)) ;
PATTERN 0 PEN m.looppen STYLE [0] ;
COLOR RGB(m.shader, m.shadeg, m.shadeb, m.shader, m.shadeg, m.shadeb)

** Lower left triangles
DO TRIANGLES WITH m.boxrow + ;
(m.boxhgt - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.vclength)), m.boxcol

** Bottom line
@ m.boxrow + (m.boxhgt - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.vclength)), ;
m.boxcol + (m.looppen / m.hclength) TO ;
m.boxrow + (m.boxhgt - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.vclength)), ;
m.boxcol + (m.boxwdth - (((((2 * m.counter) - 1) * ;
m.prevpen) - (m.prevpen - m.looppen)) / m.hclength)) ;
PATTERN 0 PEN m.looppen STYLE [0] ;
COLOR RGB(m.shader, m.shadeg, m.shadeb, m.shader, m.shadeg, m.shadeb)

RETURN

*******************
PROCEDURE TRIANGLES
*******************

PARAMETERS m.row, m.col

** Line drawing loop
FOR mcounter = 1 TO m.looppen

  @ m.row + ((mcounter - 1) / m.vclength), m.col TO ;
  m.row + ((mcounter - 1) / m.vclength), ;
  m.col + ((m.looppen - mcounter) / m.hclength) ;
  PATTERN 0 PEN 1 STYLE [0] ;
  COLOR RGB(m.sunr, m.sung, m.sunb)
  @ m.row + ((mcounter - 1) / m.vclength), ;
  m.col + ((m.looppen - mcounter) / m.hclength) TO ;
  m.row + ((mcounter - 1) / m.vclength), ;
  m.col + (m.looppen / m.hclength) ;
  PATTERN 0 PEN 1 STYLE [0] ;
  COLOR RGB(m.shader, m.shadeg, m.shadeb)

ENDFOR mcounter = 1 TO m.looppen
** End line drawing loop

RETURN

