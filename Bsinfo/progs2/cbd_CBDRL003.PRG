********************************************************************************
* Programa      : CBDRL003.PRG                                                 *
* Objeto        : LIBRO MAYOR AUXILIAR                                         *
*                                                                              *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
sele 2
use cbdacmct order acct01 alias ACCT
if !used(2)
    close data
    return
endif
***
sele 3
use cbdmctas order ctas01 alias CTAS
if !used(3)
    close data
    return
endif
sele 4
use cbdrmovm order RMOV03 ALIAS RMOV
if !used(4)
    close data
    return
endif
sele 5
use cbdvmovm order VMOV01 ALIAS VMOV
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(7)
    close data
    return
ENDIF

SELECT ACCT
SET FILTER TO NROMES <= STR(_MES,2,0)

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"

******
store [] to xynromes, xycodope, xynroast, xycodban
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO MAYOR AUXILIAR"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

XiCodMon = 1
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XsCodOpe = SPACE(LEN(RMOV->CodOpe))
XsCodAUX = SPACE(LEN(RMOV->CodAux))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XdFchEmi = DATE()
LcTpoMov = [T]
@ 09,18 SAY "                     Moneda : "
@ 10,18 SAY "               Cuenta Desde : "
@ 11,18 SAY "               Cuenta Hasta : "
@ 12,18 SAY "                  Operaci¢n : "
@ 13,18 SAY "              C¢d. Auxiliar : "
@ 14,18 say "           Fecha de emisi¢n : "
@ 15,18 say "     Tipo movimiento  D/H/T : "

DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(XiCodMon,09,48,2)
         En1 = TRIM(VECOPC(XiCodMon))
      CASE i = 2
         @ 10,48 GET XsCtaDes PICTURE REPLICATE("9",LEN(CTAS->CODCTA))
         @ 11,48 GET XsCtaHas PICTURE REPLICATE("9",LEN(CTAS->CODCTA))
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,48 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         @ 13,48 GET XsCodAux PICTURE "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 5
         @ 14,48 GET XdFchEmi PICTURE "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 6
         @ 15,48 GET LcTpoMov PICTURE "@!" VALID LcTpoMOv$[HDT]
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 6 , i + 1, 6 )

      CASE UltTecla = Enter
         IF  i < 6
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
SELECT RMOV
*** FILTROS **
DO CASE
   CASE !EMPTY(XsCodOpe) .and.  EMPTY(XsCodAux)
      SET FILTER TO CodOpe = XsCodOpe
   CASE  EMPTY(XsCodOpe) .and. !EMPTY(XsCodAux)
      SET FILTER TO CodAux = XsCodAux
   CASE !EMPTY(XsCodOpe) .and. !EMPTY(XsCodAux)
      SET FILTER TO CodAux = XsCodAux .and. CodOpe = XsCodOpe
ENDCASE

XsFor1 = IIF(LcTpoMov=[T],[.t.],[Tpomov=LcTpoMOv])
SELECT CTAS
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",LEN(CODCTA))

DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 172
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 6
IniImp  = _PRN8A+_PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(XdFchEmi)
Tit_IDER = ""
Titulo   = "M A Y O R    A U X I L I A R"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En2 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En3 = " "
En4 = IIF(LcTpoMov=[T],[Debe y Haber],IIF(LcTpoMOv=[H],[Solo Haber],[Solo Debe]))
En5 = ""
*En6 = "***** ****** *** ****** ********** ******* ********* **************************************** ************* *************************** *****************************"
*En7 = "      COMPRO LI  FECHA     Nro.    VENCTO.                                                        SALDO          M O V I M I E N T O       S A L D O  A C T U A L    "
*En8 = "FECHA BANTE  BRO  DOC.  DOCUMENTO  CHEQUE REFERENCIA       GLOSA                                ANTERIOR        CARGOS       ABONOS        DEUDOR        ACREEDOR    "
*En9 = "***** ****** *** ****** ********** ****** ********** **************************************** ************* ************* ************* ************** **************"
*
*En6 = "***** ******** *** ****** ************** ******* ********** ******** ******************************* ************* *************************** *****************************"
*En7 = "       COMPRO  LI  FECHA     Nro.        VENCTO.            CUENTA                                       SALDO         M O V I M I E N T O       S A L D O     A C T U A L  "
*En8 = "FECHA  BANTE   BRO  DOC.  DOCUMENTO      CHEQUE  REFERENCIA BANCARIA GLOSA                              ANTERIOR       CARGOS       ABONOS        DEUDOR        ACREEDOR    "
*En9 = "***** ******** *** ****** ************** ******* ********** ******** ******************************* ************* ************* ************* ************** **************"
*      0**** 6******* 15* 19**** 26************ 41***** 49******** 60****** 69***************************** 101********** 115********** 129********** 143*********** 158***********"
*      12-12 123456 123 123456 123456789- 123456 123456789- 123456789-123456789-123456789-123456789- 123456789-123 123456789-123 123456789-123 123456789-1234 123456789-1234
*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*      0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170
*
En6 = "***** ******** *** ******** ************** ******** ********** ******** **************************** ************* *************************** *****************************"
En7 = "       COMPRO  LI  FECHA       Nro.        VENCTO.             CUENTA                                    SALDO         M O V I M I E N T O       S A L D O     A C T U A L  "
En8 = "FECHA  BANTE   BRO  DOC.    DOCUMENTO      CHEQUE   REFERENCIA BANCARIA GLOSA                           ANTERIOR       CARGOS       ABONOS        DEUDOR        ACREEDOR    "
En9 = "***** ******** *** ******** ************** ******** ********** ******** **************************** ************* ************* ************* ************** **************"
*      0**** 6******* 15* 19****** 28************ 43****** 52******** 63****** 72************************** 101********** 115********** 129********** 143*********** 158***********"
*      12-12 12345678 123 12345678 12345678901234 12345678 1234567890 12345678 123456789-123456789-12345678 123456789-123 123456789-123 123456789-123 123456789-1234 123456789-1234
*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*      0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170
*
NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
LsCodRef = ""
PRINTJOB
   NumPag  = 0
   SEEK TRIM(XsCtaDes)
   STORE 0 TO W
   DO WHILE CodCta<=XsCtaHas .AND. ! EOF() .AND. ! Cancelar
      CodCta1 = LEFT(CodCta,2)
      NomCta1 = ""
      NumItm1 = 0
      STORE 0 TO Z
      SaltaPag = .T.
      DO WHILE CodCta=CodCta1 .AND. ! EOF() .AND. ! Cancelar
         IF CODCTA = PADR(CodCta1,LEN(CODCTA))
            NomCta1 = NomCta
         ENDIF
         IF AftMov = "S"
            DO LinImp
         ENDIF
         SELECT CTAS
         SKIP
         Cancelar = Cancelar .OR. (INKEY() = Escape)
         IF CodCta>XsCtaHas
            EXIT
         ENDIF
      ENDDO
      IF NumItm1 > 0 .AND. ! Cancelar
         DO ResetPag
         NumLin = PROW() + 1
         @ NumLin,000 SAY "* TOTAL CUENTA * "+CodCta1
         @ NumLin,044 SAY NomCta1
         FOR I=1 TO 5
             Col = (i-1)*14 + 101
             IF Z(I) >= 0
                @ NumLin,Col SAY Z(i) PICT "@Z 99999,999.99"
             ELSE
                @ NumLin,Col SAY -Z(i) PICT "@Z 99999,999.99-"
             ENDIF
             W(I) = W(I) + Z(I)
         ENDFOR
      ENDIF
   ENDDO
   IF ! CANCELAR
      DO ResetPag
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("*",Ancho)
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL   GENERAL **"
      FOR I=1 TO 5
          ColA = 0
          IF I=5
             ColA=1
          ENDIF
          Col = (i-1)*14 + 101
          IF W(I) >= 0
             IF i<=3
                @ NumLin,Col SAY W(i) PICT "@Z 99999,999.99"
             ELSE
                @ NumLin,Col+ColA SAY W(i) PICT "@Z 999999,999.99"
             ENDIF
          ELSE
             IF i<=3
                @ NumLin,Col SAY -W(i) PICT "@Z 99999,999.99-"
             ELSE
                @ NumLin,Col+ColA SAY -W(i) PICT "@Z 999999,999.99-"
             ENDIF
          ENDIF
      ENDFOR
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

****************
PROCEDURE LinImp
****************
PRIVATE NumLin
XsNroMes = transf(_MES,"@L ##")
SELECT ACCT
SET ORDER TO ACCT02
SEEK CTAS->CodCta
IF ! FOUND()
   RETURN
ENDIF
STORE 0 TO Y
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. ! Cancelar
   STORE 0 TO X
   LsCodRef = CodRef
   *** Saldo al mes Anterior ***
   DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. CodRef = LsCodRef
      IF NroMes <  STR(_MES,2,0)
         IF XiCodMon = 1
            X(1) = X(1) + DbeNac - HbeNac
         ELSE
            X(1) = X(1) + DbeExt - HbeExt
         ENDIF
      ENDIF
      SKIP
   ENDDO
   DO ImpRMOV
   SELECT ACCT
ENDDO
DO ResetPag
NumLin = PROW() + 1
@ NumLin,000 SAY "TOTAL SUBCTA    "+CTAS->CodCta
@ NumLin,044 SAY CTAS->NomCta
FOR I=1 TO 5
    Col = (i-1)*14 + 101
    IF Y(I) >= 0
       @ NumLin,Col SAY Y(i) PICT "@Z 99999,999.99"
    ELSE
       @ NumLin,Col SAY -Y(i) PICT "@Z 99999,999.99-"
    ENDIF
    Z(I) = Z(I) + Y(I)
ENDFOR
NumLin = PROW() + 1
@ Numlin,000 SAY REPLICATE("=",Ancho)
RETURN
******************
PROCEDURE ImpRMOV
******************
DO ResetPag
NumItm1 = NumItm1 + 1
NumItm2 = 0
NumLin = PROW() + 1
SELECT AUXI
IF ! EMPTY(CTAS->CLFAUX) .AND. CTAS->CodRef = REPLICATE("0",LEN(CTAS->CodRef))
   SEEK CTAS->ClfAux+LEFT(LsCodRef,LEN(AUXI->CODAUX))
ELSE
   SEEK CTAS->CLFAUX+LEFT(LsCodRef,LEN(AUXI->CODAUX))
ENDIF
SELECT RMOV
SEEK XsNroMes+CTAS->CodCta+LsCodRef
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. CodRef = LsCodRef .AND. ! Cancelar .AND. NroMes = XsNroMes
	IF !EVAL(Xsfor1)
		SKIP
		LOOP
	ENDIF
   *
   xynromes = nromes
   xycodope = codope
   xynroast = nroast
   xycodban = []
   *
   =SEEK(NroMes+CodOpe+NroAst,"VMOV")
  *IF VMOV->CodMon = 1 AND EliItm = "ø"
   IF VMOV->CodMon = 1 AND EliItm = ":"  
      SKIP
      LOOP
   ENDIF
   *
   do ctaban
   *
   DO ResetPag
   IF NumItm2 = 0
      @ NumLin,005 SAY CTAS->CodCta
      @ NumLin,032 SAY LsCodRef
      IF ! ( EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)) )
         @ NumLin,044 SAY AUXI->NomAux
      ELSE
         @ NumLin,044 SAY CTAS->NomCta
      ENDIF
      IF X(1) > 0
         @ NumLin,101    SAY  X(1) PICT "@Z 99999,999.99"
      ELSE
         @ NumLin,101    SAY -X(1) PICT "@Z 99999,999.99-"
      ENDIF
   ENDIF
   =SEEK(NROMES+CODOPE+NROAST,"VMOV")
   NumItm2 = NumItm2 + 1
   NumLin = PROW() + 1
   @ NumLin,000   SAY TRANSF(DAY(VMOV->FCHAST),"@L ##")+"-"+TRANSF(MONTH(VMOV->FCHAST),"@L ##")
   @ NumLin,006   SAY NroAst
   @ NumLin,015   SAY CodOpe
   IF ! EMPTY(FCHDOC)
      @ NumLin,019 SAY TRANSF(DAY(FCHDOC),"@L ##")+TRANSF(MONTH(FCHDOC),"@L ##")+STR(YEAR(FCHDOC),4,0)
   ENDIF
   @ NumLin,028   SAY NRODOC
   IF ! EMPTY(FCHVTO)
      @ NumLin,43 SAY TRANSF(DAY(FCHVTO),"@L ##")+TRANSF(MONTH(FCHVTO),"@L ##")+STR(YEAR(FCHVTO),4,0)
   ENDIF
   @ NumLin,052   SAY NROREF
   LsImport = ""
   IF RMOV->CodMon <> 1 .AND. XiCodMon = 1
      LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
      IF RIGHT(LsImport,3)=".00)"
         LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
      ENDIF
   ENDIF
   IF CTAS->CodMon = 2  .AND. XiCodMon = 1
      LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,2))+")"
      IF RIGHT(LsImport,3)=".00"
         LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
      ENDIF
   ENDIF
   DO CASE
      CASE ! EMPTY(RMOV->Glodoc)
         LsGloDoc = LEFT(GloDoc,40-LEN(LsImport))+LsImport
      CASE ! EMPTY(AUXI->NomAux)
         LsGloDoc = LEFT(AUXI->NomAux,40-LEN(LsImport))+LsImport
      OTHER
         LsGloDoc = LEFT(VMOV->NotAst,40-LEN(LsImport))+LsImport
   ENDCASE
   if tpomov = [D]
      @ NumLin,063 say xycodban
   endif
   @ NumLin,072   SAY LsGloDoc PICT "@S28"
   DO CalImp
   IF TPOMOV = "D"
      @ NumLin,115   SAY nImport PICT "@Z 99999,999.99"
      X(2) = X(2) + nImport
   ELSE
      @ NumLin,129   SAY nImport PICT "@Z 99999,999.99"
      X(3) = X(3) + nImport
   ENDIF
   @ NumLin+1,0   SAY ""
   SKIP
   Cancelar = Cancelar .OR. (INKEY() = Escape)
ENDDO
IF NumItm2 = 0  .AND. X(1) = 0
   RETURN
ENDIF
IF NumItm2 = 0
   DO ResetPag
   @ NumLin,005 SAY CTAS->CodCta
   @ NumLin,032 SAY LsCodRef
   IF ! ( EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)) )
      @ NumLin,049 SAY AUXI->NomAux
   ELSE
      @ NumLin,049 SAY CTAS->NomCta
   ENDIF
   IF X(1) > 0
      @ NumLin,101    SAY  X(1) PICT "@Z 99999,999.99"
   ELSE
      @ NumLin,101    SAY -X(1) PICT "@Z 99999,999.99-"
   ENDIF
ENDIF
LfSaldo = X(1)+X(2)-X(3)
IF LfSaldo > 0
   X(4) =  LfSaldo
ELSE
   X(5) = -LfSaldo
ENDIF
FOR I=1 TO 5
   Y(I) = Y(I) + X(I)
ENDFOR
IF ! (EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)))
   DO ResetPag
   NumLin = PROW() + 1
   FOR I=1 TO 5
       Col = (i-1)*14 + 101
       @ Numlin,Col SAY "-------------"
   ENDFOR
   NumLin = PROW() + 1
   @ NumLin,000 SAY "TOTAL AUXILIAR  "+CTAS->CodCta
   @ NumLin,032 SAY LsCodRef
   @ NumLin,044 SAY AUXI->NomAux
   FOR I=1 TO 5
       Col = (i-1)*14 + 101
       IF X(I) >= 0
          @ NumLin,Col SAY X(i) PICT "@Z 99999,999.99"
       ELSE
          @ NumLin,Col SAY -X(i) PICT "@Z 99999,999.99-"
       ENDIF
   ENDFOR
ENDIF
NumLin = PROW() + 1
@ Numlin,000 SAY REPLICATE("-",Ancho)
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltaPag
   IF NumPag > 0 .AND. ! SaltaPag
      NumLin =  LinFin+2
      IF NumLin < PROW()+ 1
         NumLin =  PROW()+1
      ENDIF
      @ NumLin,10 SAY "VAN ......"
   ENDIF
   SaltaPag = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
   IF NumPag > 1
      @ PROW()+1,10 SAY "VIENEN ......"
      NumLin = PROW() + 1
      @ NumLin,005 SAY CTAS->CodCta
      @ NumLin,032 SAY LsCodRef
      IF ! EMPTY(LsCodRef)
         @ NumLin,044 SAY TRIM(AUXI->NomAux)+"     CONT..."
      ELSE
         @ NumLin,044 SAY TRIM(CTAS->NomCta)+"     CONT..."
      ENDIF
   ENDIF
ENDIF
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
****************
PROCEDURE CTABAN
****************
sele rmov
vreg_act = recno()
set order to rmov01
xyllave = xynromes + xycodope + xynroast
seek xyllave
scan while nromes+codope+nroast = xyllave for codcta=[104]
     xycodban = codcta
endscan
set order to rmov03
go vreg_act
return
