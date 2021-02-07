********************************************************************************
* Progrma       : CBDRB007.PRG                                                 *
* Objeto        : Anexos Contables                                             *
* Autor         : VETT                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
* Actualizaci¢n : 16/09/2003  VETT                                 VFP7        *
********************************************************************************
#INCLUDE CONST.H
*** Abrimos Bases ****
LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
LOCAL LReturOk


LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','') 
LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDTANXO','ANXO','ANXO01','') 

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANEXOS CONTABLES"
*Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1
XsNroAxo = SPACE(LEN(ANXO->NroAxo))
XnMes = _Mes
XnCodDiv = 1+GnDivis
XsCodDiv = ''

EXTERNAL ARRAY XvCalc
EXTERNAL ARRAY XvCalc_D
*!*	@  9,10 FILL  TO 15,68      COLOR W/N
*!*	@  8,11 CLEAR TO 14,69
*!*	@  8,11       TO 14,69

*!*	@ 10,26 SAY "MONEDA : "
*!*	@ 12,26 SAY "ANEXO  : "
*!*	DO LIB_MTEC WITH 16
*!*	i = 1
*!*	UltTecla = 0
*!*	DO WHILE UltTecla <> Escape
*!*	   DO CASE
*!*	      CASE i = 1
*!*	         VecOpc(1)="NUEVOS SOLES      "
*!*	         VecOpc(2)="DOLARES AMERICANOS"
*!*	         XiCodMon= Elige(1,10,36,2)
*!*	      CASE i = 2
*!*	         @ 12,36 GET XsNroAxo PICT "@!"
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	   ENDCASE
*!*	   DO CASE
*!*	      CASE UltTecla = Arriba
*!*	         i = IIF( i > 1 , i - 1 , 1)

*!*	      CASE UltTecla = Abajo
*!*	         i = IIF( i< 2 , i + 1, 2 )

*!*	      CASE UltTecla = Enter
*!*	         IF  i < 2
*!*	           i = i + 1
*!*	         ELSE
*!*	           EXIT
*!*	         ENDIF
*!*	   ENDCASE
*!*	ENDDO
*!*	IF UltTecla = Escape
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	IF LASTKEY() = Escape
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*** Pantalla de datos  ***

DO FORM cbd_cbdrb007

LoDatAdm.Closetable('ACCT') 


RELEASE LoDatAdm
RETURN 
********************
PROCEDURE GEN_REPORT
********************
DO F0print
IF UltTecla = K_ESC
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ENDIF
Ancho = 95
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN

*!*	Largo    = 66       && Largo de pagina
*!*	LinFin   = 88 - 8
IniImp   = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = "RUC:"+GsRucCia
Tit_IIZQ2 = cTit2
Tit_SDER = ""
Tit_IDER = ""
Titulo  = ""
SubTitulo = ""
En1 = " "
En2 = "Cuenta contable  "
En3 = ""
En4 = ""
En5 = ""
En6 = ""
En7 = ""
En8 = ""
En9 = ""
IF XnCodDiv>0
	En2 = vDivision(XnCodDiv)
ENDIF
XsNroAxo = TRIM(XsNroAxo)
SET DEVICE TO PRINT
SET MARGIN TO 20
PRINTJOB
   SELECT ANXO
   SEEK XsNroAXO
   NumPag   = 0
   DO WHILE ! EOF() .AND. NroAxo = XsNroAxo .AND. ! Cancelar
      LsNroAxo = NroAxo
      Tit_SDER = "ANEXO "+LsNroAxo
      Inicio   = .T.
      Total1   = 0
      Total3   = 0
      LiFormat = Format
      DO CASE
         CASE LiFormat = 3
            En3=""
            En4="                                                                             ACUMULADO    "
            En5="                                                   -----------------     -----------------"
            xMes = PADC(MES(XnMES,1)+" "+RIGHT(STR(_ANO,4),2),17)
            En4 = STUFF(En4,52,LEN(xMes),xMes)
         OTHER
            En3=""
            En4=""
            En5=""
      ENDCASE
      DO WHILE NroAxo = LsNroAxo .AND. ! EOF()
         LsRefAxo1 = LEFT(RefAxo,1)
         lQuiebre  = Quieb#"N"
         Tit       = .F.
         Titulo1   = ""
         Titulo2   = ""
         NroItm1   = 0
         Total2    = 0
         Total4    = 0
         DO WHILE NroAxo+RefAxo = LsNroAxo+LsRefAxo1 .AND. ! EOF()
            LsRefAxo  = RefAxo
            NroItm2   = 0
            Tit       = .T.
            Titulo1   = ""
            Titulo2   = ""
            lRaya     = " "
            lMenos    = " "
            DO WHILE NroAxo+RefAxo = LsNroAxo+LsRefAxo .AND. ! EOF()
               lRaya     = Rayas
               lMenos    = Menos
               DO LinCal
               SELECT ANXO
               SKIP
            ENDDO
            Do LinTot2
         ENDDO
         IF lQuiebre
            Do LinTot1
         ENDIF
      ENDDO
      Cancelar = ( INKEY() = K_ESC )
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO f0pRFIN
RETURN


****************
PROCEDURE LinCal
****************
IF INLIST(LEN(TRIM(CodCta)),0,2,3)
   IF LEN(TRIM(CODCTA))=0
      DO ResetPag
      NumLin = PROW() + 3
      @ NumLin,34 SAY GloAxo
      RETURN
   ENDIF
   xTit = .F.
   LsCodCta = TRIM(CodCta)
   ** Verificando titulo ***
   SKIP
   IF NroAxo+RefAxo = LsNroAxo+LsRefAxo .AND. ! EOF()  .AND. CodCta = LsCodCta
      xTit = .T.
      TIT  = .T.
   ENDIF
   SKIP -1
   IF xTit
      =SEEK(CodCta,"CTAS")
      IF LEN(TRIM(CodCta)) = 2
         Titulo1 = TRIM(CodCta)+"- "+TRIM(IIF(EMPTY(GloAxo),CTAS->NomCta,GloAxo))
      ELSE
         Titulo2 = TRIM(CodCta)+"- "+TRIM(IIF(EMPTY(GloAxo),CTAS->NomCta,GloAxo))
      ENDIF
      RETURN
   ENDIF
ENDIF


IF "X"$CodCta
   XsCodCta = LEFT(CodCta,AT("X",CodCta)-1)
   LEN= LEN(TRIM(CODCTA))
ELSE
   XsCodCta = CodCta
   LEN=0
ENDIF

** Verificamos si despues de esto existe quiebre **
SELE ANXO
SKIP
Quiebre = ! (NroAxo+RefAxo = LsNroAxo+LsRefAxo .AND. ! EOF())
SKIP -1
**** Imprimiendo solo positivos ***
SELECT CTAS
SEEK XsCodCta
Modo = .F.
Negativo = .F.
IF  ANXO->ModAxo = 2
   Negativo = .T.
   Quiebre  = .F.
   GOTO BOTTOM
   IF ! EOF()
      SKIP
   ENDIF
ENDIF
DO WHILE CodCta = XsCodCta .AND. ! EOF()
	** VETT  01/05/2018 11:57 PM : Validar la divisionaria en el plan de cuentas - IDUPD: _56W00FFP5
	IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
	ELSE
		IF CodCta_B=XsCodDiv
		ELSE
			SELECT CTAS
			SKIP
			LOOP	
		ENDIF
	ENDIF
	** VETT  02/05/2018 12:12 AM :  - IDUPD: _56W00FFP5 


   IF LEN= LEN(TRIM(CODCTA)) .OR. LEN=0
      GoSvrCbd.CBDACUMD(CodCta,0, XnMes)
      IF XsCodDiv=[**]  && Consolidado
	      nImport = XvCalc(6+INC)
	      nImpMes = XvCalc(3+INC)
      ELSE
	      nImport = XvCalc_D(XnCodDiv,6+INC)
	      nImpMes = XvCalc_D(XnCodDiv,3+INC)
      ENDIF
      IF ANXO->Signo  = "2"
         nImport = -nImport
         nImpMes = -nImpMes
      ENDIF


      Imprime = .f.
      DO CASE
         CASE nImport = 0 .AND. nImpMes = 0
         CASE ANXO->ModAxo = 1
            Imprime = ( nImport > 0 )
         CASE ANXO->ModAxo = 2
            Imprime = ( nImport < 0 )
            IF nImport < 0
               Negativo = .T.
            ENDIF
         OTHER
            IF nImport < 0  .AND. lMenos <> "N"
               Negativo = .T.
            ELSE
               Imprime = .T.
            ENDIF
      ENDCASE
      IF Imprime
         DO LinImp
      ENDIF
   ENDIF
   SELECT CTAS
   SKIP
ENDDO

**** Imprimiendo solo negativos ***
IF ! Negativo
   Tit = .F.
   SELECT ANXO
   RETURN
ENDIF
*IF Quiebre
*   Do LinTot2
*ENDIF

SELECT CTAS
SEEK XsCodCta
Modo = .T.
IF  ANXO->ModAxo = 2
   Modo = .F.
ENDIF
IF  ANXO->Menos  = "N"
   Modo = .F.
ENDIF
DO WHILE CodCta = XsCodCta .AND. ! EOF()
	** VETT  01/05/2018 11:57 PM : Validar la divisionaria en el plan de cuentas - IDUPD: _56W00FFP5
	IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
	ELSE
		IF CodCta_B=XsCodDiv
		ELSE
			SELECT CTAS
			SKIP
			LOOP	
		ENDIF
	ENDIF
	** VETT  02/05/2018 12:12 AM :  - IDUPD: _56W00FFP5 

   IF LEN= LEN(TRIM(CODCTA)) .OR. LEN=0
      GoSvrCbd.CBDACUMD(CodCta,0, XnMes)
      IF XsCodDiv=[**]  && Consolidado
	      nImport = XvCalc(6+INC)
	      nImpMes = XvCalc(3+INC)
      ELSE
	      nImport = XvCalc_D(XnCodDiv,6+INC)
	      nImpMes = XvCalc_D(XnCodDiv,3+INC)
    	  
      ENDIF
      IF ANXO->Signo  = "2"
         nImport = -nImport
         nImpMes = -nImpMes
      ENDIF
      Imprime = .f.
      DO CASE
         CASE nImport = 0 .AND. nImpMes = 0
         CASE ANXO->ModAxo = 1
            Imprime = ( nImport > 0 )
         CASE ANXO->ModAxo = 2
            Imprime = ( nImport < 0 )
         OTHER
            Imprime = ( nImport < 0 )
      ENDCASE
      IF Imprime
         DO LinImp
      ENDIF
   ENDIF
   SELECT CTAS
   SKIP
ENDDO
Tit = .F.
SELECT ANXO
RETURN

*****************
PROCEDURE LinImp
****************
DO ResetPag
IF Tit
   IF ! Empty(Titulo1)
      NumLin = PROW() + 3
      @ NumLin,34 SAY Titulo1
      Titulo1 = ""
   ENDIF
   IF ! Empty(Titulo2)
      NumLin = PROW() + 3
      @ NumLin,34 SAY Titulo2
      Titulo2 = ""
   ENDIF
endif

IF Modo
   Modo = .F.
   DO ResetPag
   NumLin = PROW() + 2
   Tit = .F.
   @ NumLin,8  SAY "MENOS"
ENDIF
NroItm2 = NroItm2 + 1

IF Tit
   NumLin = PROW() + 2
   Tit = .F.
ELSE
   NumLin = PROW() + 1
ENDIF
@ NumLin,0  SAY CodCta+"- "+NomCta PICT "@S50"
DO CASE
   CASE LiFormat = 3
      @ NumLin,51 SAY ABS(nImpMes)       PICT "9999,999,999"
      IF nImpMes < 0
         @ NumLin,66 SAY "CR"
      ENDIF
      @ NumLin,73 SAY ABS(nImport)       PICT "9999,999,999"
      IF nImport < 0
         @ NumLin,88 SAY "CR"
      ENDIF
   OTHER
      @ NumLin,51 SAY ABS(nImport)       PICT "9999,999,999"
      IF nImport < 0
         @ NumLin,66 SAY "CR"
      ENDIF
ENDCASE
Total1 = Total1 + nImport
Total2 = Total2 + nImport
Total3 = Total3 + nImpMes
Total4 = Total4 + nImpMes
RETURN

*****************
PROCEDURE LinTot2
*****************
IF NroItm2 = 0
   RETURN
ENDIF
NroItm1 = NroItm1 + 1
DO CASE
   CASE LiFormat = 3
      NumLin = PROW() + 1
      @ NumLin,51 SAY "-----------------"
      @ NumLin,73 SAY "-----------------"
      NumLin = PROW()+1
      @ NumLin,51 SAY ABS(Total4)  PICT "9999,999,999"
      IF Total4 < 0
         @ NumLin,66 SAY "CR"
      ENDIF
      @ NumLin,73 SAY ABS(Total2)  PICT "9999,999,999"
      IF Total2 < 0
         @ NumLin,88 SAY "CR"
      ENDIF
   OTHER
      NumLin = PROW()
      @ NumLin,73 SAY ABS(Total2)  PICT "9999,999,999"
      IF Total2 < 0
         @ NumLin,88 SAY "CR"
      ENDIF
      NumLin = PROW() + 1
      @ NumLin,51 SAY "-----------------"
      IF lRAYA = "S"
         @ NumLin,73 SAY "-----------------"
      ENDIF
      IF lRAYA = "D"
         @ NumLin,73 SAY "================="
      ENDIF
ENDCASE
Total2 = 0
Total4 = 0
RETURN
*****************
PROCEDURE LinTot1
*****************
IF NroItm1 = 0
   RETURN
ENDIF
DO CASE
   CASE LiFormat = 3
      NumLin = PROW() + 1
      @ NumLin,51 SAY "================="
      @ NumLin,73 SAY "================="
      NumLin = PROW()+1
      @ NumLin,51 SAY ABS(Total3)  PICT "9999,999,999"
      IF Total3 < 0
         @ NumLin,66 SAY "CR"
      ENDIF
      @ NumLin,73 SAY ABS(Total1)  PICT "9999,999,999"
      IF Total1 < 0
         @ NumLin,88 SAY "CR"
      ENDIF
   OTHER
      NumLin = PROW()
      @ NumLin,73 SAY "-----------------"
      NumLin = PROW() + 2

      @ NumLin,27 SAY "TOTAL AL "+DTOC(GdFecha)
      @ NumLin,73 SAY ABS(Total1)  PICT "9999,999,999"
      IF Total1 < 0
         @ NumLin,88 SAY "CR"
      ENDIF

      NumLin = PROW() + 1
      @ NumLin,73 SAY "================="
ENDCASE
Total1 = 0
Total3 = 0
RETURN

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio = .F.
   DO f0MBPRN
   IF UltTecla = K_Esc
      Cancelar = .T.
   ENDIF
ENDIF
