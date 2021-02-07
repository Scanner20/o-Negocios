*!*	IF ! Master
*!*	   DO LIB_MERR WITH 3
*!*	   RETURN
*!*	ENDIF
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')


DO TPERN

loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('NPER')
loContab.oDatadm.CloseTable('TPER')
loContab.oDatadm.CloseTable('AUXI')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

PROCEDURE TPERN

PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDNPERN','NPER','NPER01','')
LoDatAdm.abrirtabla('ABRIR','CBDTPERN','TPER','TPER01','')


cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION ESTADOS DE GESTION"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
XsCodBal = SPACE(2)
XsNombre = SPACE(LEN(TABL->NOMBRE))
XsNotaEdt= SPACE(LEN(TPER.Nota))
@ 10,10 CLEAR TO 13,71   color scheme 11
@ 10,10 FILL TO 13,71   color scheme 11
@ 10,10 TO 13,71 DOUBLE color scheme 11
*           1         2         3         4         5         6         7
* 123345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 11,12 SAY "Estado          :"  color scheme 11
@ 12,12 SAY "Descripci¢n     :"  color scheme 11

i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
   DO CASE
      CASE I = 1
         SELECT TABL
         XsTabla = "31"
         @ 11,30 GET XsCodBal  PICT "99"  
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape_
            EXIT
         ENDIF
         SELECT TABL
         IF UltTecla = F8 OR EMPTY(XsCodBal)
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsCodBal = LEFT(CODIGO,2)
         ENDIF
         IF EMPTY(XsCodBal)
            GsMsgErr = "Estado de Balance Erroneo"
            DO Lib_MErr WITH 99
            LOOP
         ENDIF
         @ 11,30 SAY XsCodBal  PICT "99"
         SELECT TPER
         SEEK XsCodBal
         IF ! Found()
            RESP = "S"
            SAVE SCREEN
            @ 17,19 TO 21,55 DOUBLE COLOR SCHEME 7
            @ 18,20 say "   Estado de Gesti¢n No  Existe    " COLOR SCHEME 7
            @ 19,20 say " Desea crearlo como Nuevo Estado   " COLOR SCHEME 7
            @ 20,20 say "          [S/N] ?                  " COLOR SCHEME 7
            @ 20,39 GET RESP PICT "@!" VALID RESP$'NS'
            READ
            RESTORE SCREEN
            IF LASTKEY()=Escape_
               LOOP
            ENDIF
            IF RESP = "N"
               LOOP
            ENDIF
         ENDIF
         SELECT TABL
         SEEK XsTabla+XsCodBal
         IF ! FOUND()
            APPEND BLANK
            REPLACE TABLA WITH Xstabla
            REPLACE Codigo WITH XsCodBal
         ENDIF
         XsNombre = Nombre

      CASE I = 2
         @ 12,30 GET XsNombre PICT "@S40"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape_
            EXIT
         ENDIF
         IF Nombre <> XsNombre
            REPLACE NOMBRE WITH XsNombre
         ENDIF
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2,2, i)
   i = IIF(i<1, 1, i)
ENDDO

IF UltTecla = Escape_
   *CLOSE DATA
   RETURN
ENDIF

Titulo   = ALLTRIM(XsNomBre)
DO TBROWSE
IF LASTKEY() = Escape_
   *CLOSE DATA
   RETURN
ENDIF

*!*	Titulo   = [NOTAS ESTADO]
*!*	NClave   = [Rubro]
*!*	VClave   = XsCodbal
*!*	DO NBROWSE
*CLOSE DATA
RETURN
********************************
PROCEDURE TBROWSE
*****************
SET_ESCAPE = .T.
SELECT TPER
XiNroItm  = NroItm
XsNota    = Nota
XsGloCta  = GloCta
XsGlosa   = Glosa
SelLin   = "MOVbseli"
InsLin   = [MOVbGrab]
EscLin   = ""
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbGrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = "MOVF3"
MVprgF4  = []
MVprgF5  = [NBROWSE]
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = [MOVF9]
PrgFin   = []
HTitle   = 1
NClave   = [Rubro]
VClave   = XsCodBal
Yo       = 1
Largo    = 25
TBorde   = Simple
E1       = []
E2       = []
E3       = []
E3       = [ #    NOTA    *****             D E S C R I P C I O N               *****  ]
LinReg   = [TRANSF(NROITM,"@L ###")+" "+NOTA+" "+GLOCTA+" "+GLOSA]
Ancho    = LEN( &LinReg ) + 4
Xo       = INT((WCOLS() - Ancho)/2)
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .T.
DB_Pinta = .F.
GsMsgKey = " [] [] [PgUp] [PgDw] [Home] [End] Posic. [Ins]erta [Del]Borra [Enter]Edita [F5]Nota [F9]Listar "
DO LIB_MTEC WITH 99
DO DBrowse
RETURN
*************************************************************************** FIN
* Procedimiento Para Edici¢n
******************************************************************************
PROCEDURE MOVBSELI
******************

XsNotaEdt = TPER.Nota
PROCEDURE MOVBEDIT
******************
SELECT TPER
XiNroItm  = NroItm
XsNota    = Nota
XsGloCta  = GloCta
XsGlosa   = Glosa
i = 0
UltTecla = 0
*DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
   DO CASE
      CASE I = 1
         @ LinAct,Xo+2 GET XiNroItm PICT "@L ###"
         READ
         UltTecla = LastKey()
      CASE I = 2
         @ LinAct,Xo+6  GET XsNota  PICT "@!"
         READ
         UltTecla = LastKey()
      CASE I = 3
         @ LinAct,Xo+09 GET XsGloCta
         READ
         UltTecla = LastKey()
      CASE I = 4
         @ LinAct,Xo+25 GET XsGlosa
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>4,4, i)
   i = IIF(i<1, 1, i)
ENDDO
*DO LIB_MTEC WITH 14
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE MOVBGRAB
******************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
REPLACE Rubro     WITH VClave
REPLACE NroItm    WITH XiNroItm
REPLACE Nota      WITH XsNota
REPLACE GloCta    WITH XsGloCta
REPLACE Glosa     WITH XsGlosa
UNLOCK ALL
RETURN
*************************************************************************** FIN
* Procedimiento borrado
******************************************************************************
PROCEDURE MOVBBORR
******************
IF ! RLOCK()
   RETURN
ENDIF
DELETE
UNLOCK ALL
RETURN
**********************************************************************
* Regenerar Items ====================================================
**********************************************************************
PROCEDURE MovF3
*******************
SAVE SCREEN
DO LIB_MSGS WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
@ 11,23 SAY "³    R E C A L C U L A N D O    ³" COLOR SCHEME 7
@ 12,23 SAY "³  Espere un momento por favor  ³" COLOR SCHEME 7
@ 13,23 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
**** Recalculando Importes *************************
T_Itms =0
Chqado =0
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
   T_Itms = T_Itms + 1
   IF T_Itms <> NroItm
      Chqado =Chqado +1
   ENDIF
   IF RLOCK()
      REPLACE ChkItm   WITH T_Itms
   ENDIF
   UNLOCK
   SKIP
ENDDO
**** Chequeo del Nro de Items **********************
IF Chqado > 0
   TnItms = 0
   DO WHILE TnItms < T_Itms
      TnItms =0
      SEEK VCLAVE
      DO WHILE EVALUATE(RegVal) .AND. ! EOF()
         IF NroItm <> ChkItm
            IF RLOCK()
               REPLACE NroItm   WITH ChkItm
            ENDIF
            UNLOCK
         ELSE
            TnItms = TnItms + 1
         ENDIF
         SKIP
      ENDDO
   ENDDO
ENDIF
RESTORE SCREEN
Fin  = .T.
RETURN
*****************
PROCEDURE NBROWSE
*****************
SAVE SCREEN TO _WScreen01
PRIVATE Ancho,Largo,Xo,Yo,Set_Escape,SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9   
PRIVATE PrgFin,HTitle,TBorde,E1,E2,E3,Linreg,Consulta,Modifica,Adiciona,Static 
PRIVATE VSombra,DB_Pinta
PRIVATE Titulo,NCLAVE,VCLAVE,NumRg


SELECT NPER
Titulo   = [NOTAS ESTADO]
NClave   = [Rubro+Nota]
VClave   = XsCodbal+XsNotaEdt


Ancho    = 31
Largo    = 18
Yo       = 05
Xo       = 79-Ancho
SET_ESCAPE = .T.
XsNota    = Nota
XsCodCta  = CodCta
XcSigno   = SPACE(LEN(Signo))
XsCodRef  = SPACE(LEN(CodRef))
XcForma   = SPACE(LEN(Forma))
SelLin   = ""
InsLin   = [MOVnGrab]
EscLin   = ""
EdiLin   = "MOVnedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVnGrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
HTitle   = 1
TBorde   = Simple
E1       = []
E2       = []
E3       = []
E3       = [ NOTA CUENTA   S   DT  REF. ]
LinReg   = [NOTA+"   "+CodCta+" "+Signo+"    "+Forma+'  '+CodRef]
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .T.
DB_Pinta = .F.
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [Enter] Modifica"
DO LIB_MTEC WITH 14
DO DBrowse
RESTORE SCREEN FROM _WScreen01
SELECT TPER
RETURN
*************************************************************************** FIN
* Procedimiento Para Edici¢n
******************************************************************************
PROCEDURE MOVNEDIT
******************
XsNota    = Nota
XsCodCta  = Codcta
XcSigno   = Signo
XsCodRef  = CodRef
XcForma   = Forma
IF Crear
	XsNota = XsNotaEdt
   XsCodCta  = SPACE(LEN(Codcta))
   XcSigno   = SPACE(LEN(Signo))
   XsCodRef  = SPACE(LEN(CodRef))
   XcForma   = SPACE(LEN(Forma))
ENDIF
i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
   DO CASE
      CASE I = 1
         @ LinAct,Xo+2  GET XsNota  PICT "@!"
         READ
         UltTecla = LastKey()
      CASE I = 2
         SELECT CTAS
         @ LinAct,Xo+7 GET XsCodcta
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape_
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCodCta = CTAS->CodCta
         ENDIF
         @ LinAct,Xo+7 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND() .AND. !("X"$XsCodCta OR XsCodCta="VA" OR XsCodCta="VM")
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
      CASE I = 3
         @ LinAct,Xo+16 GET XcSigno
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 4
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Suma                    "
            vOpc(2) = "2 Resta                   "
            vOpc(3) = "3 Suma  (Cuenta de Ajuste)"
            vOpc(4) = "4 Resta (Cuenta de Ajuste)"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc VALID DATO2() COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XcSigno  = STR(oPc,1,0)
         ENDIF
         @ LinAct,Xo+16 SAY XcSigno

      CASE i = 4
         @ LinAct,Xo+21 GET XcForma
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 3
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Saldos Activos"
            vOpc(2) = "2 Saldo Pasivos"
            vOpc(3) = "3 Saldo Total"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc  VALID DATO2() COLOR SCHEME 7 
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XcForma  = STR(oPc,1,0)
         ENDIF
         @ LinAct,Xo+21 SAY XcForma

      CASE I = 5
*!*	      	 LsCodCta=IIF(("X"$XsCodCta OR XsCodCta="VA" OR XsCodCta="VM"),LEFT(XsCodCta,2),TRIM(XsCodCta))	
*!*	      	 =SEEK(LsCodCta,'CTAS','CTAS01')
*!*	 		 XsClfAux=CTAS.ClfAux        
		IF XsCodCta='10'
			LcTablRef ='AUXI'
		   SELECT DISTINCT ClfAux FROM ctas WHERE CodCta=TRIM(XsCodCta) AND AftMOv='S' AND PIDAux='S' AND !EMPTY(ClfAux) INTO ARRAY vCtaRef
			IF _Tally>0
				XsClfAux = IIF(!EMPTY(vCtaref(1)),vCtaRef(1),'')					
			ELSE
				XsClfAux = ''
			ENDIF
			LsCodRef = XsClfAux
		ELSE
			LcTablRef ='TABL'
			XsTabla = '03'	&& Centro de costo
 			LsCodRef = XsTabla
		ENDIF 
         @ LinAct,Xo+24 GET XsCodRef
         READ
         UltTecla = LastKey()
      	 IF EMPTY(XsTabla)
	     ELSE    
	         IF UltTecla = F8
	         	DO CASE
	         	CASE LcTablRef='TABL'
		         	SELECT (LcTablRef)
		            SEEK XsTabla+TRIM(XsCodRef)
		            IF ! CBDBUSCA(LcTablRef)
		               LOOP
		            ENDIF
		            XsCodRef = PADR(TABL.Codigo,LEN(NPER.CodRef))
	         	CASE LcTablRef='AUXI'
		         	SELECT (LcTablRef)
		            SEEK XsClfAux+TRIM(XsCodRef)
		            IF ! CBDBUSCA(LcTablRef)
		               LOOP
		            ENDIF
		            XsCodRef = PADR(AUXI.CodAux,LEN(NPER.CodRef))
				ENDCASE		        
		            
	            @ LinAct,Xo+24 SAY XsCodRef
	            SELECT NPER
	         ENDIF
         ENDIF
         IF !EMPTY(XsCodRef)
         	IF !SEEK(LsCodRef+XsCodRef,LcTablRef)
	            GsMsgErr = "Referencia no Registrada"
	            DO Lib_MErr WITH 99
	            UltTecla = 0
	            LOOP
         	ENDIF
         ENDIF
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5, 5, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT NPER
DO LIB_MTEC WITH 14
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE MOVNGRAB
******************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
REPLACE Rubro     WITH VClave
REPLACE Nota      WITH XsNota
REPLACE CodCta    WITH XsCodCta
REPLACE Signo     WITH XcSigno
REPLACE CodRef    WITH XsCodRef
REPLACE Forma     WITH XcForma
UNLOCK ALL
RETURN
***************
PROCEDURE MOVF9
***************
SELE TPER
LLAVE = RUBRO
    *POSICIONAMOS SOBRE EL PRIMER ELEMENTO
SEEK LLAVE
IF !FOUND()
   GsMsgErr = [ESTADO NO REGISTRADO]
   DO LIB_MTEC WITH 99
   RETURN
ENDIF
_BD = SYS(3)+[.DBF]
DO XGENERA
SELE TEMPO
SAVE SCREEN TO TMP
GOTO TOP
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
xWhile = []
xFor   = []
sNomREP = "CBDTPERN"
DO F0PRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
USE
DELETE FILE &_BD
SELE TPER
RETURN

PROCEDURE XGENERA
CREATE TABLE &_BD FREE (RUBRO C(LEN(TPER.Rubro)), NROITM N(3), NOTA C(LEN(TPER.Nota)), GLOCTA C(15), GLOSA C(50), ;
                   CODCTA C(LEN(CTAS.cODcTA)), SIGNO C(1), FORMA C(1),cODrEF C(LEN(nper.cODrEF)) )
USE
USE &_BD IN 0 ALIAS TEMPO EXCLU
SELECT TEMPO
INDEX ON RuBro+STR(NroItm,3,0) TAG temp01

SELE TPER
DO WHILE LLAVE = RUBRO AND !EOF()
   SELE TEMPO
   APPEND BLANK
   REPLACE  RUBRO    WITH TPER->RUBRO
   REPLACE  NROITM   WITH TPER->NROITM
   REPLACE  NOTA     WITH TPER->NOTA
   REPLACE  GLOCTA   WITH TPER->GLOCTA
   REPLACE  GLOSA    WITH TPER->GLOSA
   LLAVE1 = RUBRO+NOTA

   SELE NPER
   SEEK LLAVE1
   DO WHILE LLAVE1 = RUBRO+NOTA AND !EOF()
      SELE TEMPO
      APPEND BLANK
      REPLACE RUBRO  WITH TPER->RUBRO
      replace NroItm WITH TPER.NroItm
      REPLACE NOTA   WITH TPER->NOTA
      REPLACE CODCTA WITH NPER->CODCTA
      REPLACE SIGNO  WITH NPER->SIGNO
      replace Forma WITH NPER.Forma
      replace CodRef WITH NPER.CodRef
      SELE NPER
      SKIP
   ENDDO
   SELE TPER
   SKIP
ENDDO


RETURN

***************
FUNCTION dato2
***************
UltTecla = Lastkey()
*IF LastKey() = Enter
   OK = 1
*   KEYB CHR(23)
   CLEAR read 
*ENDIF
RETURN .T.

