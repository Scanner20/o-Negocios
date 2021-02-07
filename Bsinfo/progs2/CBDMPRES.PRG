***************************************************************************
*  Nombre       : CBDMpres.PRG                                            *
*  Proposito    : TABLA DE PRESUPUESTOS               - TELE2000          *
*  Creaci¢n     : 20/06/94                                                *
*  Autor        : VETT                                                    *
*  Actualizaci¢n: 03/05/97  VETT - Para que funcione en AESA              *
***************************************************************************
PARAMETER _ClfAux
SELE 6
*USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
use cbdpcamb order tcmb01 alias tcmb
IF ! USED(6)
   CLOSE DATA
   RETURN
ENDIF
SELE 5
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF
SELE 4
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE CBDMPRES ORDER PRES01 ALIAS PRES
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE CBDMPREM ORDER PREM01 ALIAS PREM
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
***
CLEAR
cTit1 = GsNomCia
cTit2 = MES(_Mes,3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "TABLA DE PRESUPUESTOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
***
DiMension vCodRef(20)
DiMension vImport(12)
DiMension vImpusa(12)
XsCodRef =[]
XsCodCta =[]
XsCodAux =[]
XsNroMes = TRANS(_Mes,"@L ##")
XiTipo   = 1
XSelect  = SELECT()
Nclave   = []
Vclave   = []
XsTabla = [04] && Tipo de gasto
** Capturamos el tipo de cambio a la fecha del sistema **
_TpoCmb = 1
*lFound=SEEK(DTOS(GdFecha),[TCMB])
lFound=SEEK((trans(year(GdFecha),[@L 9999])+trans(month(GdFecha),[@L 99])),[TCMB])
IF !lFound OR EMPTY(TCMB.OfiVta)
   IF RECNO(0)>0
      GO RECNO(0)
      _TpoCmb=TCMB.OfiVta
   ENDIF
ENDIF

i=1
UltTecla = 0
Do while .t.
   DO LeeClave
   IF UltTecla = Escape
      EXIT
   ENDIF
   DO XBrowse
   UltTecla = Lastkey()
   IF ULTTECLA=Ctrlw .or. UltTecla = F10
      EXIT
   ENDIF
   ULTTECLA=0
  *DO PANTA
ENDDO
IF XiTipo = 1 and UltTecla <> Escape
   IF ALRT("Actualizamos acumulados por mes ?")
      DO AcmPreMes
   ENDIF
ENDIF
CLOSE DATA
PUSH KEY CLEAR
RETURN
******************
PROCEDURE LeeCLAVE
******************
@ 5,10 CLEAR TO 9,70
@ 5,10       TO 9,70
GsMsgKey = "[Esc] Salir  [->] [<-] Selecciona  [Enter] Aceptar"
DO LIB_MTEC WITH 99
nLonTit=LEN("[ Mensual x Cuenta,C/Costo,Tpo.Gto. ]")
VecOpc(1)="[ Mensual x Cuenta,C/Costo,Tpo.Gto. ]"
VecOpc(2)="[          Mensual x Cuenta         ]"
nPosTit = 10 + (60 - nLonTit)/2
XiTipo = Elige(XiTipo,05,nPosTit,2)
IF UltTecla = Escape
   RETURN
ENDIF
ON KEY LABEL F12 DO xTpoCmb
GsMsgKey = "[Esc] Salir  [->] [<-] Selecciona  [Enter] Aceptar [F12] T.C. [F9]Imprimir"
DO LIB_MTEC WITH 99
IF XiTipo = 1
   SELE PRES
   GOTO TOP
   XsCodAux = CodAux
   XsCodCta = CodCta
   @ 6,12 SAY "Cuenta :"
   @ 7,12 SAY "C/Costo:"
   @ 8,12 SAY "Mes    :"
   XSelect = SELECT()
   ON KEY LABEL f7  DO AcmPreMes
   ON KEY LABEL F9  DO PrintPresu
ELSE
   SELE PREM
   GO TOP
   XSelect = SELECT()
   ON KEY LABEL f7
ENDIF
IF XiTipo = 1
    i= 1
    UltTecla = 0
    DO WHILE !INLIST(UltTecla,F10,Ctrlw,Escape) AND XiTipo = 1
       DO CASE
          CASE i = 1
              SELE CTAS
              @ 6,20 GET XsCodCta PICT "@!"
              READ
              UltTecla = LASTKEY()
              IF UltTecla = F8
                 SEEK TRIM(XsCodCta)
                 IF CBDBUSCA("CTAS")
                    XsCodCta = LEFT(CTAS->CodCta,LEN(PRES->CodCta))
                    UltTecla = Enter
                 ELSE
                    UltTecla = 0
                    LOOP
                 ENDIF
              ENDIF
              IF UltTecla = Escape
                 EXIT
              ENDIF
              SEEK XsCodCta
              IF !FOUND()
                 GsMsgErr = "Código inválido"
                 DO LIB_MERR WITH 99
                 UltTecla = 0
                 LOOP
              ENDIF
              @ 6,20 SAY XsCodCta+' '+LEFT(CTAS.NomCta,30)
              SELE PRES
          CASE i = 2
              IF CTAS.PidAux=[S] AND XsCodCta<>[9]
	              SELE AUXI
	              XsClfAux = _ClfAux
	              @ 7,20 GET XsCodAux PICT "@!"
	              READ
	              UltTecla = LASTKEY()
	              IF UltTecla = F8
	                 IF CBDBUSCA("AUXI")
	                    XsCodAux = LEFT(AUXI->CodAux,LEN(PRES->CodAux))
	                    UltTecla = Enter
	                 ELSE
	                    UltTecla = 0
	                    LOOP
	                 ENDIF
	              ENDIF
	              IF UltTecla = Escape
	                 EXIT
	              ENDIF
	              SEEK XsClfAux+XsCodAux
	              IF !FOUND()
	                 GsMsgErr = "C¢digo inv lido"
	                 DO LIB_MERR WITH 99
	                 UltTecla = 0
	                 LOOP
	              ENDIF
	              @ 7,20 SAY XsCodAux+' '+LEFT(AUXI.NomAux,30)
	              SELE PRES
	          ELSE
	              XsCodAux= SPACE(LEN(PRES.CodAux))
	          ENDIF
          CASE i = 3
              @ 8,20 GET XsNroMes PICT "@L ##" VALID VAL(XsNroMes)<=12 .AND. VAL(XsNroMes)>=1
              READ
              UltTecla = LASTKEY()
              cMes = MES(VAL(XsNroMes),3)
              XsNroMes= RIGHT("00"+TRIM(XsNroMes),2)
              @ 8,20 SAY XsNroMes +' '+cMes
              IF UltTecla = Enter
                 UltTecla = CtrlW
              ENDIF
       ENDCASE
       I = IIF(UltTecla = Arriba,I-1,I+1)
       I = IIF(I>3,3,I)
       I = IIF(I<1,1,I)
    ENDDO
    SELE PRES
    IF UltTecla <> Escape
       SEEK XsCodCta+XsCodAux
    ENDIF
ENDIF
RETURN
*****************
PROCEDURE XBROWSE
*****************
SELECT (xSelect)
UltTecla = 0
SelLin   = "COMPLE"
InsLin   = "GRABA"
EscLin   = ""
EdiLin   = "EDITA"
BrrLin   = "BORRA"
GrbLin   = "GRABA"
HTitle   = 3
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
IF XiTipo=2
   MVprgF9  = [PrintPresu]
ENDIF
Largo    = 11
Yo       = 10
Titulo   = ""
TBorde   = Simple
E1       = ' F CUENTA   ***       DESCRIPCION      ***  IMPORTE(S/.) IMPORTE(US$)'
     ***     99999999 123456789012345678901234567890 9,999,999,999 9,999,999,99
E2       = []
E3       = []
IF XiTipo = 1
   E1       = [ F TIPO                                                           ]
   E2       = [   GTO. ***       DESCRIPCION      ***   IMPORTE(S/.) IMPORTE(US$)]
         ***    999  123456789012345678901234567890  9,999,999,999 9,999,999,99
   XsTabla = [04]
   XnDigitos=IIF(SEEK([01]+XsTabla,[TABL]),TABL.Digitos,LEN(CodRef))
   SET RELA TO PADR(XsTabla,LEN(AUXI.ClfAux))+CodRef INTO AUXI
   NClave   = [CodCta+CodAux]
   VClave   = XsCodCta+XsCodAux
   LinReg   = [filtro+' '+LEFT(CodRef,XnDigitos)+'  '+LEFT(AUXI.NomAux,30)+'  '+TRANS(&Campo,"9,999,999,999")+' '+TRANS(&CampoD,"9,999,999,999")]
ELSE
   SET RELA TO CodCta INTO CTAS
   NClave   = []
   VClave   = []
   LinReg   = [filtro+' '+CodCta+' '+LEFT(CTAS->NomCta,30)+' '+TRANS(&Campo,"9,999,999,999")+' '+TRANS(&CampoD,"9,999,999,999")]
   XsCodCta = SPACE(LEN(PRES->CodCta))
ENDIF
Campo    = "IMPS"+XsNroMes
CampoD   = "IMPD"+XsNroMes
Ancho    = LEN( &LinReg ) + 4
Xo       = (80-Ancho)/2
SET_ESCAPE = .T.
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
db_pinta = .F.
PrgFin   = ""
*** Variables a usar ****
XfImport = 0
XfImpUsa = 0
XcFiltro =[ ]
SELE (XSelect)
GsMsgKey = "[  PGDN PGUP HOME END]Posicionar [Esc]Salir [F10]Grabar [Enter]Editar [F12]T.C."
DO LIB_MTEC WITH 99
@ 21,1 CLEAR TO 22,78
@ 21,1  SAY "TOTAL ANUAL US$:" COLOR SCHEME 11
@ 22,1  SAY "TOTAL ANUAL S/ :" COLOR SCHEME 11
@ 21,45 SAY "ACUMULADO US$:" COLOR SCHEME 11
@ 22,45 SAY "ACUMULADO S/.:" COLOR SCHEME 11
DO DBrowse
RETURN
****************
PROCEDURE COMPLE
****************
STORE 0 TO nPtotS,nPtotD,nPacmS,nPacmD
FOR nMes = 1 TO 12
    Campo3="ImpS"+TRANSF(nMes,"@L ##")
    Campo4="ImpD"+TRANSF(nMes,"@L ##")
   nPTOTS =nPTOTS + &Campo3
   nPTOTD =nPTOTD + &Campo4
ENDFOR
FOR nMes = 1 TO _Mes
    Campo3="ImpS"+TRANSF(nMes,"@L ##")
    Campo4="ImpD"+TRANSF(nMes,"@L ##")
   nPacmS =nPacmS + &Campo3
   nPacmD =nPacmD + &Campo4
ENDFOR
@ 21,20 SAY nPtotD PICT "999,999,999.99"  COLOR SCHEME 7
@ 22,20 SAY nPtotS PICT "999,999,999.99"  COLOR SCHEME 7
@ 21,60 SAY nPacmD PICT "999,999,999.99"  COLOR SCHEME 7
@ 22,60 SAY nPacmS PICT "999,999,999.99"  COLOR SCHEME 7
RETURN
***************
PROCEDURE EDITA
***************
IF Crear
   IF XiTipo#1
      XsCodCta = SPACE(LEN(PRES->CodCta))
   ELSE
      XsCodRef = SPACE(LEN(PRES->CodRef))
      XsCodRef = LEFT(XsCodRef,XnDigitos)
   ENDIF
   XfImport = 0
   Store 0 to vImport,vImpusa
   XcFiltro =[ ]
ELSE
  IF XiTipo = 1
     XsCodRef = PRES->CodRef
  ELSE
     XsCodCta = PREM->CodCta
  ENDIF
  XcFiltro  = Filtro
  XfImport = &Campo
  vImport(01) = IMPS01
  vImport(02) = IMPS02
  vImport(03) = IMPS03
  vImport(04) = IMPS04
  vImport(05) = IMPS05
  vImport(06) = IMPS06
  vImport(07) = IMPS07
  vImport(08) = IMPS08
  vImport(09) = IMPS09
  vImport(10) = IMPS10
  vImport(11) = IMPS11
  vImport(12) = IMPS12
  **
  XfImpUsa = &CampoD
  vImpusa(01) = IMPD01
  vImpusa(02) = IMPD02
  vImpusa(03) = IMPD03
  vImpusa(04) = IMPD04
  vImpusa(05) = IMPD05
  vImpusa(06) = IMPD06
  vImpusa(07) = IMPD07
  vImpusa(08) = IMPD08
  vImpusa(09) = IMPD09
  vImpusa(10) = IMPD10
  vImpusa(11) = IMPD11
  vImpusa(12) = IMPD12
ENDIF
I        = 1
DO LIB_MTEC WITH 7
UltTecla = 0
DO WHILE !INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
             @ LinAct,Xo+2 GET XcFiltro PICT "@!" VALID XcFiltro$[N ]
             READ
             UltTecla = LASTKEY()
             IF UltTecla = Escape
                LOOP
             ENDIF
             @ LinAct,Xo+2 SAY XcFiltro PICT "@!"
      CASE i = 2
         IF Xitipo#1
	         SELE CTAS
	         @ LinAct,Xo+4  GET XsCodCta PICT "@!"
	         READ
	         UltTecla = LastKey()
	         IF UltTecla = Escape
	            LOOP
	         ENDIF
	         IF UltTecla = F8
	            IF ! CBDBUSCA("CTAS")
	               LOOP
	            ENDIF
	            XsCodCta = CTAS->CodCta
	            UltTecla = Enter
	         ENDIF
	         @ LinAct,Xo+04 SAY XsCodCta
	         SEEK XsCodCta
	         IF !FOUND()
	            GsMsgErr = "C¢digo de cuenta inv lida"
	            DO Lib_MErr WITH 99
	            UltTecla = 0
	            LOOP
	         ENDIF
	        *IF CTAS->AftMov<>"S"
	        *   GsMsgErr = "Cuenta no afecta a movimientos"
	        *   DO Lib_MErr WITH 99
	        *   UltTecla = 0
	        *   LOOP
	        *ENDIF
	         @ LinAct,Xo+4 SAY XsCodCta+'  '+LEFT(CTAS->NomCta,30)
	     ELSE
	         SELE AUXI
	         XsClfAux=PADR(XsTabla,LEN(AUXI.ClfAux))
	         XsCodRef=LEFT(XsCodRef,XnDigitos)
	         @ LinAct,Xo+4  GET XsCodRef PICT "@!"
	         READ
	         UltTecla = LastKey()
	         IF UltTecla = Escape
	            LOOP
	         ENDIF
	         IF UltTecla = F8
	            IF ! CBDBUSCA("AUXI")
	               LOOP
	            ENDIF
	            XsCodRef = LEFT(AUXI.CodAux,XnDigitos)
	            UltTecla = Enter
	         ENDIF
	         @ LinAct,Xo+4 SAY XsCodRef
	         SEEK XsClfAux+XsCodRef
	
	         IF !FOUND()
	            GsMsgErr = "Código de tipo de gasto invalido"
	            DO Lib_MErr WITH 99
	            UltTecla = 0
	            LOOP
	         ENDIF
	         @ LinAct,Xo+4 SAY XsCodRef+'  '+LEFT(AUXI.NomAUX,30)
	     ENDIF
	     SELE (xSelect)
      CASE I = 3
         @ LinAct ,Xo+43 SAY XfImport PICT "9,999,999,999"
         SAVE Screen To Xtmp1
         DO MesBrows
         REST SCREEN FROM Xtmp1
         XfImport = vImport(VAL(XsNroMes))
         @ LinAct ,Xo+43 SAY XfImport PICT "9,999,999,999"
         @ LinAct ,Xo+56 SAY XfImpusa PICT "9,999,999,999"
         IF Lastkey() = Escape
            UltTecla = Arriba
         ELSE
           UltTecla = Enter
         ENDIF
      CASE i =4
         IF UltTecla=Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   I = IIF(UltTecla = Arriba,I-1,I+1)
   I = IIF(I>4,4,I)
   I = IIF(I<1,1,I)
ENDDO
SELE (xSelect)
IF UltTecla = Escape
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
***************
PROCEDURE BORRA
***************
UltTecla = 0
IF RLOCK()
   DELETE
   UNLOCK
   UltTecla = F10
ELSE
   UltTecla = Escape
ENDIF
RETURN
***************
PROCEDURE GRABA
***************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   UltTecla = Escape
   RETURN
ENDIF
IF XiTipo = 1
   REPLACE PRES.CodRef WITH  XsCodRef
   REPLACE PRES.CodCta WITH  XsCodCta
   REPLACE PRES.CodAux WITH  XsCodAux
ELSE
   REPLACE PREM.CodCta WITH  XsCodCta
ENDIF
REPLACE &Campo      WITH  XfImport
** Soles
REPLACE  IMPS01 WITH vImport(01)
REPLACE  IMPS02 WITH vImport(02)
REPLACE  IMPS03 WITH vImport(03)
REPLACE  IMPS04 WITH vImport(04)
REPLACE  IMPS05 WITH vImport(05)
REPLACE  IMPS06 WITH vImport(06)
REPLACE  IMPS07 WITH vImport(07)
REPLACE  IMPS08 WITH vImport(08)
REPLACE  IMPS09 WITH vImport(09)
REPLACE  IMPS10 WITH vImport(10)
REPLACE  IMPS11 WITH vImport(11)
REPLACE  IMPS12 WITH vImport(12)
** Dolares
REPLACE  IMPD01 WITH vImpusa(01)
REPLACE  IMPD02 WITH vImpusa(02)
REPLACE  IMPD03 WITH vImpusa(03)
REPLACE  IMPD04 WITH vImpusa(04)
REPLACE  IMPD05 WITH vImpusa(05)
REPLACE  IMPD06 WITH vImpusa(06)
REPLACE  IMPD07 WITH vImpusa(07)
REPLACE  IMPD08 WITH vImpusa(08)
REPLACE  IMPD09 WITH vImpusa(09)
REPLACE  IMPD10 WITH vImpusa(10)
REPLACE  IMPD11 WITH vImpusa(11)
REPLACE  IMPD12 WITH vImpusa(12)
*
REPLACE Filtro WITH XcFiltro
UNLOCK
RETURN
******************
PROCEDURE MULTIMES
******************
PRIVATE i
LiTotItm= 0
DO CAPDIVIS
IF UltTecla = Escape
   RETURN
ENDIF
SELE PRES
FOR i = 1 TO LiTotItm
   LsCodRef = vCodRef(i)
   IF XiTipo = 1
      zLlave = XsCodRef
      SEEK zllave
      DO WHILE !EOF() AND CodRef = zLlave
         cCodCta  = CodCta
         LiRegAct = RECNO()
         SEEK LsCodRef+CodCta
         IF !FOUND()
            APPEND BLANK
         ENDIF
         =RLOCK()
         REPLACE CodRef WITH LsCodRef
         REPLACE CodCta WITH cCodCta
         GO LiRegAct
         SKIP
      ENDDO
   ELSE
   ENDIF
ENDFOR
SELE (xSelect)
RETURN
****************************************
*  Capturamos divisionarias a duplicar *
****************************************
PROCEDURE CAPDivis
UltTecla = 0
EscLin   = "CAPbline"
EdiLin   = "CAPbedit"
BrrLin   = "CAPbborr"
InsLin   = "CAPbinse"
*
yo       = 12
xo       = 2
Largo    = 8
Ancho    = 30
TBorde   = Simple
Titulo   = ""

En1 = " Cod.Div.     NomBre        "
En2 = ""
En3 = ""

CiMaxEle = 20
MaxEle   = LiTotItm
TotEle   = 20
Static = .F.
*
DO aBrowse
IF Lastkey() <> Escape
   UltTecla = F10
ENDIF
*
LiTotItm = MaxEle
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE CAPbline
PARAMETERS NumEle, NumLin
*
=SEEK("010"+vCodRef(NumEle),"AUXI")
@ NumLin,Xo+2 SAY vCodRef(NumEle)
@ Numlin,Xo+8 SAY LEFT(AUXI->NomAux,15)
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE CAPbedit
PARAMETERS NumEle, NumLin ,LiUtecla
PRIVATE i,LsSalBrow
i = 1
LsCodRef = vCodref(NumEle)
DO WHILE !INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
          XsClfAux = _ClfAux
          SELE AUXI
          @ NumLin,Xo+2 GET LsCodRef PICT "@!"
          READ
          UltTecla = LASTKEY()
          IF UltTecla = F8
             IF CbdBusca("AUXI")
                LsCodRef = LEFT(AUXi->CodAux,5)
                UltTecla = Enter
             ELSE
                UltTecla = 0
             ENDIF
          ENDIF
          IF UltTecla = Escape
             EXIT
          ENDIF
          SEEK XsClfAux+LsCodRef
          IF !FOUND()
             GsMsgErr = "Divisionaria inv lida"
             Do LIB_MERR WITH 99
             UltTecla  = 0
             LOOP
          ENDIF
          @ Numlin,Xo+8 SAY LEFT(AUXI->NomAux,15)
          IF XiTipo = 1 AND LsCodRef = XsCodRef
             GsMsgErr = "Divisionaria inv lida"
             Do LIB_MERR WITH 99
             UltTecla  = 0
             LOOP
          ENDIF
          SELE (xSelect)
      CASE I = 2
         IF UltTecla = Enter
            EXIT
         ENDIF
         IF INLIST(UltTecla,F10,CTRLw)
            UltTecla = CtrlW
            EXIT
         ENDIF
         i = 1
   ENDCASE
   I = IIF(UltTecla = Arriba,I-1,I+1)
   I = IIF(I>2,2,I)
   I = IIF(I<1,1,I)
ENDDO
IF UltTecla <> Escape
   vCodRef(NumEle) = LsCodRef
ENDIF
LiUtecla = UltTecla
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE CAPbborr
PARAMETERS ElePrv, Estado
i = ElePrv + 1
DO WHILE i <  MaxEle
   vCodRef(i) = vCodRef(i+1)
   i = i + 1
ENDDO
STORE SPACE(LEN(PRES->CodRef)) TO vCodRef(i)
Estado = .T.
RETURN
******************
PROCEDURE CAPbinse
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   vCodRef(i) = vCodRef(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(PRES->CodRef)) TO vCodRef(i)
Estado = .T.
RETURN
****************************************
*  Capturamos monto por meses          *
****************************************
PROCEDURE MesBrows
PRIVATE NumLin,NumEle,EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde
PRIVATE Titulo,En1,En2,En3,Static,MaxEle
UltTecla = 0
EscLin   = "MESbline"
EdiLin   = "MESbedit"
BrrLin   = "MESbborr"
InsLin   = "MESbinse"
*
*
yo       = 3
xo       = 79-40
Largo    = 17
Ancho    = 40
TBorde   = Simple
Titulo   = ""
     *0123456789-123456789-123456789-1234567890
    *** Noviembre  9,999,999.99  9,999,999.99
En1 = " MES           IMPORTE       IMPORTE   "
En2 = "                  US$           S/.    "
En3 = ""

LiTotItm = 12
CiMaxEle = 12
MaxEle   = 12
TotEle   = 12
IF LiTotItm > 12 .OR. LiTotItm = 0
   UltTecla = Enter
   RETURN
ENDIF
Static = .F.


*
STORE 0 TO WfImpUSa,WfImport
DO aBrowse
*
LiTotItm = MaxEle
IF LiTotItm > 12 .OR. LiTotItm = 0
   UltTecla = Enter
ENDIF
IF LASTKEY() = Escape
   RETURN
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MESbline
PARAMETERS NumEle, NumLin
*
IF NumEle >12
   LiUTecla = Enter
   RETURN
ENDIF
cNomMes = MES(NumEle, 3)
@ NumLin,Xo + 2   SAY LEFT(cNomMes,10)
@ NumLin,Xo + 13  SAY vImpusa( NumEle )    PICT "9,999,999.99"
@ NumLin,Xo + 27  SAY vImport( NumEle )    PICT "9,999,999.99"
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MESbedit
PARAMETERS NumEle, NumLin ,LiUTecla
PRIVATE i,LsSalBrow
IF NumEle > 12
   UltTecla = Enter
   RETURN
ENDIF
LfImport = vImport( NumEle )
LfImpUsa = vImpUsa( NumEle )
@ NumLin,Xo+13 GET LfImpUsa PICT "9,999,999.99"  VALID _ImpUsa()
@ NumLin,Xo+27 GET LfImport PICT "9,999,999.99"  VALID _Import()
READ
UltTecla = LASTKEY()
IF UltTecla <> Escape
   vImport( NumEle ) = LfImport
   vImpUsa( NumEle ) = LfImpUsa
ENDIF
UltTecla = Enter
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MESbborr
PARAMETERS ElePrv, Estado
Estado = .f.
RETURN
************************************************************************ FIN *
* Objeto : Inserta   linea
******************************************************************************
PROCEDURE MESbinse
PARAMETERS ElePrv, Estado
Estado = .f.
RETURN
****************
FUNCTION wImport
****************
WfImport = LfImport
****************
FUNCTION _Import
****************
*IF LfImport<0
*   RETURN .F.
*ENDIF
IF LfImport#WfImport
   LfImpUsa = ROUND(LfImport/_TpoCmb,2)
   WfImpUsa = LfImpusa
   @ NumLin,Xo+13 SAY LfImpUsa PICT "9,999,999.99"
ENDIF
RETURN .T.
****************
FUNCTION wImpUsa
****************
WfImpUsa = LfImpUsa
****************
FUNCTION _ImpUsa
****************
*IF LfImpUsa<0
*   RETURN .F.
*ENDIF
*
_TpoCmb = 1
lFound=SEEK((trans(year(GdFecha),[@L 9999])+trans(numele,[@L 99])),[TCMB])
if lfound .and. !empty(tcmb.ofivta)
   _tpocmb=tcmb.ofivta
endif
*
IF _TpoCmb>0 AND LfImpUsa#WFImpUsa
   LfImport = ROUND(LfImpUsa*_TpoCmb,2)
   WfImport = LfImport
   @ NumLin,Xo+27 SAY LfImport PICT "9,999,999.99"
ENDIF
RETURN .T.
*****************
PROCEDURE xTpoCmb
*****************
DEFINE WINDOW Tpo_Cmb FROM 10,30 TO 15,60 TITLE "TIPO DE CAMBIO" DOUBLE NOZOOM
ACTIVATE WINDOW Tpo_Cmb
UltTecla  = 0
m.Control = 1
@ 01,01 SAY "T.C.:" GET _TpoCmb PICT "9,999.9999" VALID _TpoCmb>0
@ 03,03 GET m.control PICT "@*HT \<Aceptar;\<Cancelar" SIZE 1,10,2
READ CYCLE
UltTecla = LASTKEY()
IF m.Control = 2
   UltTecla = Escape
ENDIF

RELEASE WINDOW Tpo_Cmb
RETURN
*******************
PROCEDURE AcmPreMes
*******************
PRIVATE K,L,m.CodCtaD,m.COdCtaH,nMesIni,nMesFin
STORE [] TO m.CodCtaD,m.CodCtaH
nMesIni = _MES
nMesFin = _MES
UltTecla = 0
Cancelar = .f.
*** Pantalla de datos
DO CbdMpres.Spr
***
IF UltTecla = Escape
   RETURN

ENDIF
Dimension vSoles(12),VDolares(12)
STORE 0 TO vSoles,vDolares
m.CodCtaD = TRIM(m.CodCtaD)
m.CodCtaH = TRIM(m.CodCtaH)+CHR(255)
SELE PRES
xRecno = RECNO()

DO GrbCtaAut
SEEK m.CodCtaD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
DO WHILE !EOF() AND CodCta<=m.CodCtaH  AND !Cancelar
   
   WAIT WINDOW [Acumulando totales mensuales:]+COdcta+[ ]+IIF(Seek(COdCTa,[CTAS]),CTAS.NomCta,[]) NOWAIT
   CtaAut=CTAS.GenAut=[S]
   TsCodCta=CodCTa
   STORE 0 TO vSoles,VDolares
   SCAN WHILE CodCta=TsCodCta  AND !Cancelar
        FOR L = nMesINi to nMesFin
            Campo1=[IMPS]+TRAN(L,[@L ##])
            Campo2=[IMPD]+TRAN(L,[@L ##])
            vSoles(L)   = vSoles(L)   + &Campo1.
            vDolares(L) = vDolares(L) + &Campo2.
        ENDFOR
        Cancelar  = (INKEY()=Escape)
   ENDSCAN
   SELE PREM
   SEEK TsCodCta
   IF !FOUND()
       APPEND BLANK
       DO WHILE !RLOCK()
       ENDDO
       REPLACE CodCta  WITH TsCodCta
   ELSE
       DO WHILE !RLOCK()
       ENDDO
       FOR K = nMesIni TO nMesFin
           Campo1=[IMPS]+TRAN(K,[@L ##])
           Campo2=[IMPD]+TRAN(K,[@L ##])
           REPLACE &Campo1. WITH 0
           REPLACE &Campo2. WITH 0
       ENDFOR
   ENDIF
   FOR KK = nMesIni TO nMesFin
       Campo1=[IMPS]+TRAN(KK,[@L ##])
       Campo2=[IMPD]+TRAN(KK,[@L ##])
       REPLACE &Campo1. WITH vSoles(KK)
       REPLACE &Campo2. WITH vDolares(KK)
   ENDFOR
   UNLOCK
   SELE PRES
   Cancelar  = (INKEY()=Escape)
ENDDO
GO XRecno
WAIT WINDOW [OK] NOWAIT
RETURN
*******************
PROCEDURE GrbCtaAut
*******************
PRIVATE J,K,L,vPreDol,VPreSol
DIMENSION vPreDol(12),vPreSol(12)
WAIT WINDOW [Calculando la clase 9] NOWAIT
SET ORDER TO PRES03
*** Primero borramos información antes generada ***
SEEK [9]
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE CodCta = [9]
    DO WHILE !RLOCK()
    ENDDO
    REPLACE CodAux WITH []
    FOR J=nMesINi TO nMesFin
        Campo1=[IMPS]+TRAN(J,[@L ##])
        Campo2=[IMPD]+TRAN(J,[@L ##])
        REPLACE &Campo1. WITH 0
        REPLACE &Campo2. WITH 0
    ENDFOR
    UNLOCK
ENDSCAN
SET ORDER TO PRES04    && CodAux+COdRef+CodCta
SEEK [9]
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
DO WHILE CodAux=[9]  AND !Cancelar AND !EOF()
   IF !INLIST(CODCTA,[6],[72])
      SKIP
      LOOP
   ENDIF
   WAIT WINDOW [Procesando C/Costo:]+COdAux+CODREF+[ ]+IIF(Seek(_ClfAux+COdAux,[AUXI]),AUXI.NomAux,[]) NOWAIT
   XsCodCta=CodCTa
   XsCodAux=CodAux
   XsCodRef=CodRef
   STORE 0 TO vPreSol,vPreDol
   SCAN WHILE CodAux+CodRef=XsCodAux+XsCodref
        FOR K = nMesINi TO nMesFin
            Campo1=[IMPS]+TRAN(K,[@L ##])
            Campo2=[IMPD]+TRAN(K,[@L ##])
            vPreSol(K) = vPreSol(K) + &Campo1.
            vPreDol(K) = vPreDol(k) + &Campo2.
        ENDFOR
   ENDSCAN
   XReg_Act=RECNO()
   FIN_ARCH=EOF() OR CodAux<>[9]
   SET ORDER TO PRES03
   SEEK XsCodAux+XsCodRef
   IF !FOUND()
	  APPEND BLANK
	  DO WHILE !RLOCK()
	  ENDDO
	  REPLACE CodCta WITH XsCodAux
	  REPLACE CodREf WITH XsCodRef
   ELSE
   	  DO WHILE !RLOCK()
	  ENDDO
   ENDIF
   FOR L=nMesIni TO nMesFin
        Campo1=[IMPS]+TRAN(L,[@L ##])
        Campo2=[IMPD]+TRAN(L,[@L ##])
        REPLACE &Campo1. WITH vPreSol(L)
        REPLACE &Campo2. WITH vPreDol(L)
   ENDFOR
   UNLOCK
   SET ORDER TO PRES04
   IF FIn_Arch
      EXIT
   ENDIF
   IF RECNO()<>XReg_Act
      GO XReg_Act
   ENDIF
   Cancelar  = (INKEY()=Escape)
ENDDO
SET ORDER TO PRES01
GO XRecno
WAIT WINDOW [OK] NOWAIT
RETURN
********************
PROCEDURE PrintPresu
********************
DO CbdRpres.spr
return
