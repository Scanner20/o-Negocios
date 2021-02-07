******************************************************************************
* Progrma       : CBDRB003.PRG                                                 *
* Objeto        : BALANCE COMPROBACION ACUMULADO                               *
* Autor         : VETT                                                        *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
#INCLUDE CONST.H
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','') 
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
**goentorno.open_dbf1('ABRIR','CBDTAJUS','AJUS','AJUS01','')
EXTERNAL ARRAY VecOpc
EXTERNAL ARRAY XvCalc
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE GENERAL ACUMULADO"
**Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
*** Pantalla de datos  ***
UltTecla = 0
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
INC = 0   && SOLES
XiCodMon = 1
STORE [] TO  XsCtaDes,XsCtaHas,XsCodBal,XsNomCtaD,XsNomCtaH
XnNivCta = 1
XnCodBal = 1
XnSolMov = 1
XnCodDiv = 1+GnDivis
m.Control= 1
Store [] TO XsCodBal,XsCodDiv
** 
XsCtaDes = SPACE(LEN(CTAS.CodCta))
XsCtaHas = SPACE(LEN(CTAS.CodCta))
XnMes = _Mes
XnTipoBal = 1
XsTipRep  = .F.

DO form cbd_cbdrb003

********************
PROCEDURE GEN_REPORT
********************
XsCtaDes = TRIM(XsCtaDes)
XsCtaHas = TRIM(XsCtaHas)+PADR('z',LEN(CTAS.CodCta))
*** Pantalla de datos  ***
SELE CTAS
*!*	DO F0PRINT
*!*	IF UltTecla = 27
*!*	   RETURN
*!*	ENDIF
IF XiCodMon = 2
   INC = 6
ENDIF
Ancho = 200
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = 88 - 8
IF VERSION()='Visual FoxPro'
	IniImp = ''
ELSE
	IniImp  = _PRN4+_PRN8A
ENDIF
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(GdFecha)
Tit_IDER = "HORA :"+TIME() 
Tit_IIZQ2 = "RUC:"+GsRucCia
Titulo    = "BALANCE GENERAL ACUMULADO"
SubTitulo = "AL MES DE "+MES(XnMES,1)+" DE "+TRANS(_ANO,"9999")
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
IF XnCodDiv>0
	En2 = vDivision(XnCodDiv)
ENDIF
En3 = ""
En4 = ""
*!*	En5 = "************** *******************************************   ************************************** *************************************  *************************************  *************************************  "
*!*	En6 = "                                                                      S    U    M    A    S                     S   A   L   D   O   S                    I N V E N T A R I O               RESULTADO POR NATURALEZA      "
*!*	En7 = "CODIGO         DESCRIPCION                                         D E B E            H A B E R           DEUDOR            ACREEDOR             ACTIVO             PASIVO             PERDIDAS           GANANCIA       "
*!*	En8 = "************** *******************************************   ******************* ****************** ****************** ******************  ****************** ******************  ****************** ******************  "
*!*	En5 = En5 + "************************************* "
*!*	En6 = En6 + "          RESULTADO POR FUNCION       "
*!*	En7 = En7 + "     PERDIDAS           GANANCIA      "
*!*	En8 = En8 + "****************** ****************** "
En5 = "************ **************************************** ****************************** ***************************** ***************************** ***************************** "
En6 = "                                                             S  U  M  A  S                  S  A  L  D  O  S            I N V E N T A R I O         RESULTADO POR NATURALEZA   "
En7 = "CODIGO        DESCRIPCION                                 D E B E       H A B E R         DEUDOR        ACREEDOR        ACTIVO         PASIVO         PERDIDAS      GANANCIA   "
En8 = "************ **************************************** *************** ************** ************** ************** ************** ************** ************** ************** "
En5 = En5 + "***************************** "
En6 = En6 + "     RESULTADO POR FUNCION    "
En7 = En7 + "   PERDIDAS         GANANCIA  "
En8 = En8 + "************** ************** "
En9 = []

Cancelar = .F.
Formato = "@Z( "+RIGHT('999,999,999.99',14)
*!*	*!*	*!*	SET DEVICE TO PRINT
*!*	*!*	*!*	SET MARGIN TO 0
NumCol = 10
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),XZ(10),aLinea(NumCol),aTotal(NumCol),aResult(Numcol)
SELECT CTAS
IF XnNivCta = 1
	SET ORDER TO ctas02
   SEEK '1'+TRIM(XsCtaDes)
ELSE
   SET ORDER TO CTAS01
   SEEK TRIM(XsCtaDes)
ENDIF
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",5)
IF ! FOUND()
   RETURN
ENDIF
NumReg = recno()
*!*	PRINTJOB
*!*	   GOTO NumReg
*!*	   Inicio = .T.
*!*	   NumPag  = 0
   STORE 0 TO X,Y,Z,XZ,aResult
   DO BLOQUE WITH "AA"
*!*	   EJECT PAGE
*!*	ENDPRINTJOB
*!*	SET MARGIN TO 0
*!*	SET DEVICE TO SCREEN

*!*	DO f0pRFIN
RETURN

****************
PROCEDURE BLOQUE
****************
PARAMETER TOPE
IF Cancelar
   RETURN
ENDIF
XfDebe   = 0
XfHaber  = 0
NroItm1 = 0
LnItem	= 0
NumLin = PROW()+1                           && Linea Actual
STORE 0 TO X,Y
DO WHILE ! EOF() .and. ! Cancelar .AND. CodCta <=XsCtaHas
	IF xstiprep = .f.
	   IF NivCta > XnNivCta
    	  SKIP
    	  LOOP
   	   ENDIF
   	ELSE
	   IF NivCta > XnNivCta OR aftmov<>"S"
	      SKIP
	      LOOP
	   ENDIF
	ENDIF
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
   Tb=(NivCta-1)
   IF Tb<0 .OR. Tb>5
      Tb=5
   ENDIF
   GoSvrCbd.CBDACUMD(CodCta,0, XnMes)
   STORE 0 TO X
   IF XsCodDiv=[**]  && Consolidado
	   X(1)  = XvCalc(4+INC)
	   X(2)  = XvCalc(5+INC)
	   Saldo = XvCalc(6+INC)
   ELSE
	   X(1)  = XvCalc_D(XnCodDiv,4+INC)
	   X(2)  = XvCalc_D(XnCodDiv,5+INC)
	   Saldo = XvCalc_D(XnCodDiv,6+INC)
   ENDIF
   IF X(1) = 0 .AND. X(2) = 0
      SKIP
      LOOP
   ENDIF
   IF Saldo > 0
      X(3) =  Saldo
   ELSE
      X(4) = -Saldo
   ENDIF
   NroItm1 = NroItm1 + 1
   IF CodCta < "60"
      X(5) = X(3)
      X(6) = X(4)
   ENDIF
   IF CodCta = "69"
      IF Saldo = 0
         X(9)=X(1+INC)
      ENDIF
   ENDIF
   *** Estado de Perdidas por Naturaleza **
   IF (TpoCta = 1 .OR. TpoCta = 3) .AND. CodCta >= '60'
      IF Saldo > 0
         X(7) = X(3)
      ELSE
         X(8) = X(4)
      ENDIF
   ENDIF
   *** Estado de Perdidas por Funcion    **
   IF (TpoCta = 2 .OR. TpoCta = 3)  .AND. CodCta >= '60'
      IF Saldo > 0
         X(9)  = X(3)
      ELSE
         X(10) = X(4)
      ENDIF
   ENDIF
   IF X(1) = 0 .AND. X(2) = 0
      RETURN
   ENDIF
*!*	*!*	*!*	   DO RESETPAG
   NumLin = PROW() + 1
   IF xstiprep=.f.
*!*	*!*	*!*	   @ NumLin,Tb SAY TRIM(CodCta)
   ELSE
*!*	*!*	*!*	   @ NumLin,1 SAY TRIM(CodCta)
   ENDIF
*!*	   @ NumLin,15 SAY SUBSTR(NomCta,1,40)
*!*	*!*	*!*	*!*	   @ NumLin,13 SAY SUBSTR(NomCta,1,32)
   TnJ = 1
    DO WHILE TnJ <= 10
*!*	      @ NumLin,37+20*TnJ SAY X(TnJ) PICTURE Formato
*!*	*!*	*!*			@ NumLin,39+15*TnJ SAY X(TnJ) PICTURE Formato
        IF xstiprep=.f.
			IF NivCta = 1
				XZ(TnJ) = XZ(TnJ) + X(TnJ)
			ENDIF
        ELSE
			XZ(TnJ) = XZ(TnJ) + X(TnJ)
        ENDIF
 		TnJ = TnJ + 1
	ENDDO
    ** VETT  23/03/2018 04:57 PM : Graba registro con los acumulados por cada cuenta 
    LnItem = LnItem + 1
    =SaveTmpItem(LnItem,'CTA',CodCta,NomCta,@X)
    ** VETT  23/03/2018 04:57 PM : 
    ********
    SKIP
    Cancelar = (Inkey()=27)
ENDDO
IF NroItm1 > 0
	DIMENSION ATot(NumCol)
*!*	*!*	*!*	   DO ResetPag
   NumLin = PROW() + 1
*!*	*!*	*!*	   @ NumLin,55 SAY REPLICATE("-",Ancho - 53)
   NumLin = NumLin + 1
   TnJ = 1
   DO WHILE TnJ <= 10
*!*	      @ NumLin , 37+20*TnJ SAY XZ(TnJ) PICTURE Formato
*!*	*!*	*!*	      @ NumLin , 39+15*TnJ SAY XZ(TnJ) PICTURE Formato
      TnJ = TnJ + 1
   ENDDO
    ** VETT  23/03/2018 04:57 PM : Graba registro con los acumulados por cada cuenta 
    LnItem = LnItem + 1
    =SaveTmpItem(LnItem,"LS","","",0,1,10)
    LnItem = LnItem + 1
    =SaveTmpItem(LnItem,"TOT","","TOTAL",@XZ)
    ** VETT  23/03/2018 04:57 PM : 
   NumLin = NumLin + 1

   IF XZ(6) > XZ(5)
      Saldo = XZ(6) - XZ(5)
      XZ(5) = XZ(5) + Saldo
*!*	*!*	*!*      @ NumLin,114 SAY Saldo   PICTURE Formato
      aResult(5) = Saldo
   ELSE
      Saldo = XZ(5) - XZ(6)
      XZ(6) = XZ(6) + Saldo
*!*	*!*	*!*      @ NumLin,129 SAY Saldo   PICTURE Formato
      aResult(6) = Saldo
   ENDIF

   IF XZ(8) > XZ(7)
      Saldo = XZ(8) - XZ(7)
      XZ(7) = XZ(7) + Saldo
*!*	*!*	*!*      @ NumLin,144 SAY Saldo   PICTURE Formato
      aResult(7) = Saldo
   ELSE
      Saldo = XZ(7) - XZ(8)
      XZ(8) = XZ(8) + Saldo
*!*	*!*	*!*      @ NumLin,159 SAY Saldo   PICTURE Formato
      aResult(8) = Saldo
   ENDIF

   IF XZ(10) > XZ(9)
      Saldo = XZ(10) - XZ(9)
      XZ(9) = XZ(9) + Saldo
*!*	*!*	*!*      @ NumLin,174 SAY Saldo   PICTURE Formato
      aResult(9) = Saldo
   ELSE
      Saldo  = XZ(9) - XZ(10)
      XZ(10) = XZ(10) + Saldo
*!*	*!*	*!*	      @ NumLin,189 SAY Saldo   PICTURE Formato
      aResult(10) = Saldo
   ENDIF
    ** VETT  23/03/2018 04:57 PM : Graba registro con los acumulados por cada cuenta 
    LnItem = LnItem + 1
    =SaveTmpItem(LnItem,"LD","","",0,1,10)
    LnItem = LnItem + 1
    =SaveTmpItem(LnItem,"CTA","","TOTAL",@aResult)
    ** VETT  23/03/2018 04:57 PM : 
   SELE CTAS
*!*	*!*	*!*	   NumLin = NumLin + 1

*!*	*!*	*!*	   @ NumLin,114 SAY REPLICATE("-",88)
*!*	*!*	*!*	   NumLin = NumLin + 1

*!*	*!*	*!*	   @ NumLin,114 SAY XZ(5)  PICTURE Formato
*!*	*!*	*!*	   @ NumLin,129 SAY XZ(6)  PICTURE Formato
*!*	*!*	*!*	   @ NumLin,144 SAY XZ(7)  PICTURE Formato
*!*	*!*	*!*	   @ NumLin,159 SAY XZ(8)  PICTURE Formato
*!*	*!*	*!*	   @ NumLin,174 SAY XZ(9)  PICTURE Formato
*!*	*!*	*!*	   @ NumLin,189 SAY XZ(10) PICTURE Formato
   STORE 0 TO XZ
ENDIF
RETURN

******************
PROCEDURE RESETPAG
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio  = .F.
   DO f0MBPRN
   IF UltTecla = 27
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***********************************FIN
*********************
FUNCTION SaveTmpItem
*********************
PARAMETERS PnItem,PsTipo,PsCodCta,PsNomCta,PaColumns,PnCol1,PnCol2
LnSelect=SELECT()
STORE 0 TO ColIni,ColFin
IF VARTYPE(PnCol1)<>'N'
   PnCol1 = 0
ENDIF
IF VARTYPE(PnCol2)<>'N'
   PnCol2 = 0	
ENDIF
ColIni = PnCol1
ColFin = PnCol2
IF !USED('TEMPORAL2')
	=CreateTempo('TEMPORAL2')
ENDIF
SELECT TEMPORAL2
SET ORDER TO ITEM01   && STR(ITEM,6,0)+TIPO+CODCTA
SEEK STR(PnItem,6,0)
IF !FOUND()
	APPEND BLANK
	REPLACE Item	WITH PnItem
	REPLACE Tipo 	WITH PsTipo
ENDIF
*!*	SET STEP ON 
DO CASE 
	CASE INLIST(PsTipo,'CTA','TOT')
		REPLACE Codcta	WITH PsCodCta
		REPLACE NomCta	WITH PsNomCta
		FOR K = 1 TO ALEN(PaColumns)
			LsCmpCol = 'T'+TRANSFORM(K,'@L ##')
			REPLACE &LsCmpCol.	WITH &LsCmpCol. + PaColumns(K)
		ENDFOR
	CASE PsTipo = 'L'
        RAYA = IIF(INLIST(PsTIPO,[LS],[LD]),[-],[=])
        IF ColIni>0
           FOR K = ColIni TO ColFin
               Campo1 = [COL]+TRAN(K,[@L ##])
               nLen   = LEN(&Campo1.)
               REPLACE  &Campo1. WITH REPLI(RAYA,nLen)
           ENDFOR
        ENDIF
	  
ENDCASE
SELECT (LnSelect)
********************
FUNCTION CreateTempo
********************
PARAMETERS LsNomTabla
LsNomArch=goentorno.tmppath+SYS(3)
IF USED(LsNomTabla)
	USE IN (LsNomTabla)
ENDIF
SELECT 0
CREATE TABLE (LsNomArch) FREE  (Item n(6),TIPO C(4),CodCta C(8), NomCta C(50),;
T01 N(14,2),T02 N(14,2),T03 N(14,2),T04 N(14,2),T05 N(14,2),T06 N(14,2),T07 N(14,2),T08 N(14,2),T09 N(14,2),T10 N(14,2),;
COL01 C(14),COL02 C(14),COL03 C(14),COL04 C(14),COL05 C(14),COL06 C(14),COL07 C(14),COL08 C(14),COL09 C(14),COL10 C(14) )  
USE (LsNomArch) ALIAS (LsNomTabla) EXCL
INDEX ON	STR(Item,6,0)+Tipo+CodCta TAG Item01
INDEX ON	TIPO + CodCta	TAG Item02 				 

********************
FUNCTION Cargar_Grid
********************




