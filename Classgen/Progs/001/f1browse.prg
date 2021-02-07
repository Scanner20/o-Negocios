*:*****************************************************************************
*:
*: Procedure file: C:\APLICA\LIB\F1BROWSE.PRG
*:         System: BELSOFT
*:         Author: VICTOR E. TORRES TEJADA
*:      Copyright (c) 1995 - 1998, BELCSOFT S.A
*:  Last modified: 21/11/97 at 13:24:40
*:
*:  Procs & Fncts: F1BROWSE()
*:
*:      Documented 16:47:55                                FoxDoc version 3.00a
*:*****************************************************************************
*********************************************************************
*                                                                   *
*          FUNCTION F1BROWSE : VENTANA EXAMINAR (BROWSE)            *
*                                                                   *
*********************************************************************
*!*****************************************************************************
*!
*!       Function: F1BROWSE
*!
*!      Called by: BROWS_TCMB         (procedure in BELSOFT.PRG)
*!               : PBROWSE            (procedure in BELSOFT.PRG)
*!               : BROWS_SEDE         (procedure in BELSOFT.PRG)
*!               : BROWS_TSIS         (procedure in BELSOFT.PRG)
*!
*!          Calls: &PRGBUSCA.PRG
*!               : &PRGPREP.PRG
*!               : BBORRA_REG         (procedure in BELSOFT.PRG)
*!               : BAGREGA_REG        (procedure in BELSOFT.PRG)
*!               : WBRW()             (function in BELSOFT.PRG)
*!               : VBRW()             (function in BELSOFT.PRG)
*!               : &PRGPOST.PRG
*!
*!*****************************************************************************
FUNCTION f1browse
PARAMETERS skey,lmodifica,ladiciona,lborra,lpintar,loCnt
IF PARAMETERS() < 1
   skey = []
ENDIF
lsbrwmensaje =[]
IF PARAMETERS() < 2
   smodifica = []
   lmodifica = .T.
ELSE
   smodifica = IIF(lmodifica,"","NOMODIFY")
ENDIF

IF PARAMETERS() < 3
   sadiciona = []
   ladiciona = .T.
ELSE
   sadiciona = IIF(ladiciona,"","NOAPPEND")
ENDIF
IF ladiciona
   lsbrwmensaje = lsbrwmensaje+[CTRL+INS Agrega ]
ENDIF
IF PARAMETERS() < 4
   sborrar   = []
   lborra    = .T.
ELSE
   sborrar   = IIF(lborra   ,"","NODELETE")
   
ENDIF
IF lborra
   lsbrwmensaje = lsbrwmensaje+[CTRL+DEL Borra ]
ENDIF

IF PARAMETERS() < 5
   lpintar   = .F.
ENDIF
*** Fuente y Tamaño ***
IF TYPE([bFontBrw])#[C]
	bFontBrw=[Ms Sans Serif]
ENDIF
IF EMPTY(bFontBrw)
	bFontBrw=[Ms Sans Serif]
ENDIF
*
IF TYPE([bFontTmn])#[N]
	bFontTmn=8
ENDIF
IF EMPTY(bFontTmn)
	bFontTmn=8
ENDIF
***----------------***



IF TYPE("m.bBorde")#"C"
   sborde = [NONE]
ELSE
   sborde = m.bborde
ENDIF

IF TYPE("m.Area_Sel")#"C"
   m.area_sel = [TEMP]
ENDIF

snoclear = [NOCLEAR]
IF TYPE("M.lStatic")="L"
   IF !m.lstatic
      snoclear = []
   ENDIF
ENDIF
PRIVATE m.area_ant
m.area_ant = ALIAS()

PUSH KEY CLEAR


IF TYPE("m.PrgBusca")=[C]
   IF !EMPTY(m.prgbusca)
      ON KEY LABEL f5 DO &prgbusca.
      lsbrwmensaje = lsbrwmensaje + [F5 Buscar ]
   ENDIF
ENDIF

IF TYPE("m.PrgPrep")=[C]
   IF !EMPTY(m.prgprep)
      DO &prgprep.
   ENDIF
ENDIF
lsvenpadre=[]
lhayvenpadre=.F.
IF TYPE("m.VenPadre")=[C]
   IF !EMPTY(m.venpadre)
      lsvenpadre = [IN WINDOW ]+venpadre
      lhayvenpadre=.T.
   ENDIF
ENDIF

** Redefinici¢n de teclas
IF TYPE([m.bPrgkeyF2])=[C]
   IF !EMPTY(m.bprgkeyf2)
      ON KEY LABEL f2 DO (m.bprgkeyf2)
      IF TYPE([m.bPrgkeyF2])=[C]
         IF EMPTY(m.bdescrif2)
            m.bdescrif2=m.bprgkeyf2
         ENDIF
      ELSE
         m.bdescrif2=m.bprgkeyf2
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F2 ]+TRIm(m.bdescrif2)+[ ]
   ENDIF
ENDIF
*
IF TYPE([m.bPrgkeyF3])=[C]
   IF !EMPTY(m.bprgkeyf3)
      ON KEY LABEL f3 DO (m.bprgkeyf3)
      IF TYPE([m.bPrgkeyF3])=[C]
         IF EMPTY(m.bdescrif3)
            m.bdescrif3=m.bprgkeyf3
         ENDIF
      ELSE
         m.bdescrif3=m.bprgkeyf3
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F3 ]+TRIm(m.bdescrif3)+[ ]
   ENDIF
ENDIF
*
IF TYPE([m.bPrgkeyF4])=[C]
   IF !EMPTY(m.bprgkeyf4)
      ON KEY LABEL f4 DO (m.bprgkeyf4)
      IF TYPE([m.bPrgkeyF4])=[C]
         IF EMPTY(m.bdescrif4)
            m.bdescrif4=m.bprgkeyf4
         ENDIF
      ELSE
         m.bdescrif4=m.bprgkeyf4
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F4 ]+TRIm(m.bdescrif4)+[ ]
   ENDIF
ENDIF
IF TYPE([m.bPrgkeyF5])=[C]
   IF !EMPTY(m.bprgkeyf5)
      ON KEY LABEL f5 DO (m.bprgkeyf5)
      IF TYPE([m.bPrgkeyF5])=[C]
         IF EMPTY(m.bdescrif5)
            m.bdescrif5=m.bprgkeyf5
         ENDIF
      ELSE
         m.bdescrif5=m.bprgkeyf5
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F5 ]+TRIM(m.bdescrif5)+[ ]
   ENDIF
ENDIF
*
IF TYPE([m.bPrgkeyF6])=[C]
   IF !EMPTY(m.bprgkeyf6)
      ON KEY LABEL f6 DO (m.bprgkeyf6)
      IF TYPE([m.bPrgkeyF6])=[C]
         IF EMPTY(m.bdescrif6)
            m.bdescrif6=m.bprgkeyf6
         ENDIF
      ELSE
         m.bdescrif6=m.bprgkeyf6
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F6 ]+TRIM(m.bdescrif6)+[ ]
   ENDIF
ENDIF
*
IF TYPE([m.bPrgkeyF7])=[C]
   IF !EMPTY(m.bprgkeyf7)
      ON KEY LABEL f7 DO (m.bprgkeyf7)
      IF TYPE([m.bPrgkeyF7])=[C]
         IF EMPTY(m.bdescrif7)
            m.bdescrif7=m.bprgkeyf7
         ENDIF
      ELSE
         m.bdescrif7=m.bprgkeyf7
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F7 ]+TRIM(m.bdescrif7)+[ ]
   ENDIF
ENDIF

IF TYPE([m.bPrgkeyF8])=[C]
   IF !EMPTY(m.bprgkeyf8)
      ON KEY LABEL f8 DO (m.bprgkeyf8)
      IF TYPE([m.bPrgkeyF8])=[C]
         IF EMPTY(m.bdescrif8)
            m.bdescrif8=m.bprgkeyf8
         ENDIF
      ELSE
         m.bdescrif8=m.bprgkeyf8
      ENDIF
      lsbrwmensaje = lsbrwmensaje + [F8 ]+Trim(m.bdescrif8)+[ ]
   ENDIF
ENDIF

IF VERSION(5) >= 300
ELSE

	ON KEY LABEL ctrl+pgup GOTO TOP
	ON KEY LABEL ctrl+pgdn GOTO BOTTOM

	ON KEY LABEL ctrl+del  DO bborra_reg
	ON KEY LABEL ctrl+ins  DO bagrega_reg
ENDIF
** Definimos ventana activa **
IF lpintar
   m.venactiv = m.btitulo
   m.vendeact = m.bdeta
ELSE
   m.venactiv = m.bdeta
   m.vendeact = m.btitulo
ENDIF
IF TYPE([bTitBrow])#[C]
   btitbrow = m.venactiv
ELSE
   btitbrow = IIF(EMPTY(btitbrow),m.venactiv,btitbrow)
ENDIF
** Ventana actual **
PRIVATE w_act_tra
w_act_tra=WOUTPUT()
**
blborrar = .F.
lgrb_arch= .F.

*If VERSION(5) >= 300
**	LoCnt.ADDOBJECT("BizDetalle","admnovis.base_Grid") 
*	LoCnt.ADDOBJECT("CntFormula","CntDetalle_Detalle_Detalle") 
*	LoCnt.CntFormula.Visible = .T.
*	LoCnt.CntFormula.GrdDetalle1.Visible = .T.
*	LoCnt.CntFormula.GrdDetalle2.Visible = .F.
*	LoCnt.CntFormula.GrdDetalle3.Visible = .F.
*	LoCnt.CntFormula.GrdDetalle4.Visible = .F.
*	LoCnt.CntFormula.LblDetalle1.Visible = .F.
*	LoCnt.CntFormula.LblDetalle2.Visible = .F.
*	LoCnt.CntFormula.LblDetalle3.Visible = .F.
*	LoCnt.CntFormula.LblDetalle4.Visible = .F.
*	LoCnt.CntFormula.Top = NY0
*	LoCnt.CntFormula.Left= NX0
*	LoCnt.CntFrormula.Height = NY1 - NY0
*	LoCnt.CntFrormula.Width  = NX1 - NX0
*	SET STEP ON 
*ELSE
	** 2.6 Dos y Windows

*IF !EMPTY(m.vendeact) AND m.vendeact<>m.venactiv
*   IF WVISIBLE(m.vendeact)
*      DEACTIVATE WINDOW (m.vendeact)
*      RELEASE WINDOW (m.vendeact)
*   ENDIF
*ENDIF
*DO CASE
*CASE _WINDOWS
*   nx1=nx1 - 1
*ENDCASE
*lcrearwin=.F.
*IF !WEXIST(m.venactiv)
*   DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*      SHADOW NONE COLOR SCHEME 10 &lsvenpadre. ;
*      FONT (bFontBrw),bFontTmn
*   lcrearwin=.T.
*ENDIF

*IF !lpintar
*   lsbrwmensaje = lsbrwmensaje + [ ESC Salir F10 Graba]
*ELSE
*   lsbrwmensaje = lsbrwmensaje + [ ESC Salir ]
*ENDIF
*IF !lpintar
*   STORE WOUTPUT() TO currwind
*   IF SYS(2016) = "" OR SYS(2016) = "*"

*      IF _DOS OR _UNIX
*	      ACTIVATE SCREEN
*         @ 24,0 SAY PADC(lsbrwmensaje,80) COLOR (c_linea)
*      ELSE
*		 IF lHayVenPadre
*		 	ACTIVATE WINDOW (m.VenPadre)
*		 ENDIF			
**    @ 30,0 SAY PADC(lsbrwmensaje,80) COLOR (c_linea) FONT (bFontBrw),bFontTmn STYLE [B]
*		  DO f1_wmsg WITH ;
*		  lsbrwmensaje, WCOLS()-2, WROWS()-1 ,2,[RGB(0,0,0,204,204,204)]
*				  
*     ENDIF
*   ENDIF
*   IF NOT EMPTY(currwind)
*      ACTIVATE WINDOW (currwind) SAME
*   ENDIF
*   SELE (area_sel)
*   DO CASE
*   CASE _DOS
      
*      IF WEXIST(m.venactiv) AND m.venactiv=m.vendeact AND !lhayvenpadre
*         RELEASE WINDOW (m.venactiv)
*         DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*            SHADOW NONE COLOR SCHEME 10 &lsvenpadre.
         
*         ACTIVATE WINDOW (m.venactiv)
*      ENDIF
      
      
      
*      lsenquewin = [WINDOW ]+m.venactiv
*      IF lhayvenpadre
*         lsenquewin = [IN WINDOW ]+m.venactiv
*         IF WOUTPUT()<>m.venactiv
*            ACTIVATE WINDOW (m.venactiv)
*         ENDIF
*      ENDIF
*      **BROWSE FIELD &bCampos. KEY sKEY TITLE (bTitBrow) COLOR SCHEME 10 ;
*      **             FOR EVALUATE(m.bFiltro) &LsEnQueWin. NOWAIT &sNOCLEAR. FONT (bFontBrw),bFontTmn
*      **RELEASE WINDOW (m.VenActiv)
*      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10  ;
*         FOR EVALUATE(m.bfiltro) &snoclear. SAVE WHEN wbrw() VALID vbrw() ;
*         &smodifica. &sadiciona. &sborrar. &lsenquewin. 
*      
*   CASE _WINDOWS
*      *BROWSE FIELD &bCampos. KEY sKEY TITLE (bTitBrow) COLOR SCHEME 10 ;
*      *             FOR EVALUATE(m.bFiltro) WINDOW (m.VenActiv) NOWAIT &sNOCLEAR.
*      lsenquewin = [WINDOW ]+m.venactiv
*      IF lhayvenpadre
*         lsenquewin = [IN WINDOW ]+m.venactiv
*         IF WOUTPUT()<>m.venactiv
*            ACTIVATE WINDOW (m.venactiv)
*         ENDIF
*      ENDIF
*      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10  ;
*         FOR EVALUATE(m.bfiltro) &snoclear. SAVE WHEN wbrw() VALID vbrw() ;
*         &smodifica. &sadiciona. &sborrar. &lsenquewin. FONT (bFontBrw),bFontTmn
*   ENDCASE
*ELSE
*   lsbrwmensaje=[]
*   IF !WVISIBLE(m.venactiv)
*      ACTIVATE WINDOW (m.venactiv)
*   ELSE
*   ENDIF
*   SELE (area_sel)
*   IF lhayvenpadre
*      IF WONTOP()<>m.venactiv
*         IF !WEXIST(m.venactiv)
*            DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT ;
*            GROW ZOOM NOCLOSE;
*            SHADOW NONE COLOR SCHEME 10 &lsvenpadre. ;
*            FONT (bFontBrw),bFontTmn
*
*         ENDIF
*         ACTIVATE WINDOW (m.venactiv)
*      ENDIF
*      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10 ;
*         FOR EVALUATE(m.bfiltro) IN WINDOW (m.venactiv) SAVE NOWAIT ;
*         NOAPPEND NOMODIFY;
*         NODELETE &snoclear. ; 
*         FONT (bFontBrw),bFontTmn
*   ELSE
*      IF WONTOP()<>m.venactiv
*         IF !WEXIST(m.venactiv)
*            DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT ;
*            GROW ZOOM NOCLOSE;
*            SHADOW NONE COLOR SCHEME 10 &lsvenpadre. ;
*            FONT (bFontBrw),bFontTmn
*         ENDIF
*         ACTIVATE WINDOW (m.venactiv)
*         
*      ENDIF
      
*      * ** IF INLIST(M.ESTOY,[PID],[EDIT])
*      **    SET STEP ON
*      DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT ;
*      GROW ZOOM NOCLOSE;
*      SHADOW NONE COLOR SCHEME 10 &lsvenpadre. 
      
*      ACTIVATE WINDOW (m.venactiv)
*      * ** ENDIF
*      ** IF WEXIST(M.VENACTIV) AND !LCrearWin
*      **    brow last save nowait
*      ** ELSE
*      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10 ;
*      FOR EVALUATE(m.bfiltro) WINDOW (m.venactiv) SAVE NOWAIT NOAPPEND ;
*      NOMODIFY NODELETE ;
*      FONT (bFontBrw),bFontTmn

              
*      RELEASE WINDOW (m.venactiv)
*      ** ENDIF
*   ENDIF
*ENDIF
*** Fin 2.6 Dos y 2.6 Windows
*ENDIF

IF TYPE("m.PrgPost")=[C] AND !lpintar
   IF !EMPTY(m.prgpost)
      DO &prgpost.
   ENDIF
ENDIF
xx=WONTOP()
yy=WOUTPUT()
IF WEXIST(m.venactiv) AND m.venactiv==m.vendeact AND !lhayvenpadre
   DO CASE
   CASE TYPE([CVCTRL])#[C]
      IF TYPE([m.lStatic])#[L]
         DEACTIVATE WINDOW (m.venactiv)
      ELSE
         IF !m.lstatic
            DEACTIVATE WINDOW (m.venactiv)
         ENDIF
      ENDIF
   CASE TYPE([CVCTRL])=[C]
      IF TYPE([m.lStatic])#[L]
         DEACTIVATE WINDOW (m.venactiv)
      ELSE
         IF !m.lstatic
            DEACTIVATE WINDOW (m.venactiv)
         ENDIF
      ENDIF
   ENDCASE
ENDIF
SELE (m.area_ant)
IF INLIST(LASTKEY(),k_ctrlw,k_esc,k_f10)
   m.bdefbrow = .T.
ENDIF
POP KEY
IF !EMPTY(w_act_tra)
   ACTIVATE WINDOW (w_act_tra) SAME
ELSE
   IF SYS(2016) = "" OR SYS(2016) = "*"
 		IF _DOS OR _UNIX  
	      ACTIVATE SCREEN
	    ENDIF  
   ENDIF
ENDIF
RETURN

*: EOF: F1BROWSE.PRG
