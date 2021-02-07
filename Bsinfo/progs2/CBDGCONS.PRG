********************************************************************************
* Programa      : CBDGCONS.PRG                                                 *
* Objeto        : CONSISTENCIA DE REGISTRO                                     *
* Autor         : vett                                                         *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n : 29/05/95  VETT                                   A.G.R.      *
********************************************************************************
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
use cbdrmovm order RMOV01 ALIAS RMOV
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

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONSISTENCIA DE REGISTRO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 15,74      COLOR W/N
@  8,11 CLEAR TO 14,75
@  8,11       TO 14,75

XsCodOpe = "001"
XsNroMes = TRANS(_MES,"@L ##")
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
xOK       = .T.
NumEle   = 0
nNumDis  = 0
XiDevice = 1
@ 10,18 SAY "             Destino   : "
@ 11,18 SAY "             Operaci¢n : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="PANTALLA  "
         VecOpc(2)="IMPRESORA"
         XiDevice= Elige(1,10,44,2)
      CASE i = 2
         @ 11,44 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 2 )

      CASE UltTecla = Enter
         IF  i < 2
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
SELECT VMOV
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
SET ORDER TO VMOV01
xLLave = XsNroMes+TRIM(XsCodOpe)
SEEK xLLave
IF ! FOUND()
   GsMsgErr = "No Existen registros"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

@ 7,9 CLEAR TO 19,69
@ 7,9       TO 19,69

Lineas = 0
GsMsgkey = "[Esc] Cancela Proceso"
DO LIB_MTEC WITH 99
SELECT VMOV
DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
   *** Verificamos si es necesario distribuir ***
   DO VERIFICA
   IF LASTKEY() = Escape
      EXIT
   ENDIF
   SELECT VMOV
   SKIP
   IF INKEY() = Escape
      EXIT
   ENDIF
ENDDO
IF XiDevice = 2
   SET DEVICE TO SCREEN
ENDIF
@ 20,27 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
@ 21,27 SAY "³   PROCESO  COMPLETADO  ³" COLOR SCHEME 7
@ 22,27 SAY "³Presione Cualquier Tecla³" COLOR SCHEME 7
@ 23,27 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 7
=inkey(0)
CLOSE DATA
RETURN
******************
PROCEDURE VERIFICA
******************
Llave   = NroMes+"-"+CodOpe+"-"+NroAst
SET DEVICE TO SCREEN
@ 20,27 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
@ 21,27 SAY "³  ASIENTO "+LLAVE    +" ³" COLOR SCHEME 7
@ 22,27 SAY "³  **** PROCESANDO ****  ³" COLOR SCHEME 7
@ 23,27 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 7
IF XiDevice # 1
  SET DEVICE TO PRINT
ENDIF
Llave   = NroMes+CodOpe+NroAst
Mensge  = "AST:"+CODOPE+"-"+NROAST
nNumDis = 0
nSumDbe = 0
nSumHbe = 0
NumEle  = 0

XiCodMon =VMOV->CodMon
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
UltDebe  =0
UltHber  =0
T_Ctas =0
TfCtas9X = 0
TfCtas6X = 0
TfCtas79 = 0

**** Recalculando Importes *************************
T_Itms =0
Chqado =0
SELECT RMOV
SEEK LLAVE
CtaAut = .F.
NumEleX= 0
LsCodCta = SPACE(LEN(CTAS.CodCta))
LsAn1Cta = SPACE(LEN(CTAS.CodCta))
LsCc1Cta = SPACE(LEN(CTAS.CodCta))
LsAn1Clf = ""
LsAn1Aux = ""

DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
   IF TpoMov = "D"
      UltDebe  = RECNO()
   ELSE
      UltHber  = RECNO()
   ENDIF
   IF TPOMOV = "D"
      LfImport = Import
      LfImpUsa = ImpUsa
   ELSE
      LfImport = -Import
      LfImpUsa = -ImpUsa
   ENDIF

   IF ! SEEK(CodCta,"CTAS")
      GsMsgErr = Mensge+" Cuenta ["+ALLTRIM(CodCta)+"] no registrada"+TRANS(rmov->NroItm,"#####")
      DO MENSAJE1
   ELSE
      IF ! CtaAut
         CtaAut = CTAS->GenAut="S"
         IF CtaAut
             LsCodCta = CODCTA
             LsClfAux = ClfAux
             LsCodAux = CodAux
             LsAn1Cta = CTAS->AN1CTA
             LsCc1Cta = CTAS->CC1CTA
             LsAn1Clf = ""
			 LsAn1Aux = ""
             RecnoCTAS=RECNO("CTAS")
             ** Auxiliares de primera cuenta automatica
             =seek(LsAn1Cta,"CTAS")
             IF CTAS.MayAux="S"
             	LsAn1Clf=CTAS.ClfAux
             	IF LsAn1Clf=LsClfAux
             		LsAn1Aux=LsCodAux
             	ENDIF
             endif
             ** Auxiliares de contra cuenta
             =seek(LsCC1Cta,"CTAS")
             IF CTAS.MayAux="S"
             	LsCC1Clf=CTAS.ClfAux
             	IF LsCC1Clf=LsClfAux
             		LsCC1Aux=LsCodAux
             	ENDIF
             endif
             
             TsClf6x  = []
             TsClf9x  = []
             TsTpoGto = []
             go recnoCTAS IN "CTAS"
             IF EMPTY(LsAn1Cta) AND EMPTY(LsCc1Cta)
                LsAn1Cta = RMOV->CodAux
                LsCc1Cta = "79"+SUBSTR(LsAn1Cta,2,6)
                TsClf6x  = "05"
                TsClf9x  = "04"
                TsTpoGto = CTAS->TpoGto
             ENDIF
             AfImport = LfImport
             AfImpUsa = LfImpUsa
             NumEleX  = 0
         ENDIF
      ENDIF
      IF CTAS->AFTMOV#"S"
         GsMsgErr = Mensge+" Cuenta ["+ALLTRIM(CodCta)+"] no afecta a movimientos "+TRANS(rmov->NroItm,"#####")
         DO MENSAJE1
      ENDIF
   ENDIF
   IF IMPORT < 0 .OR. IMPUSA < 0
      GsMsgErr = Mensge+" Contiene Importe Negativos "+TRANS(rmov->NroItm,"#####")
      DO MENSAJE1
   ENDIF
   ***** VERIFICANDO QUE NO SEA CUENTA QUE SE GENERA AUTOMATICAMENTE ***
  *IF ELIITM <> "ú"
   IF ELIITM <> "*"  
      SELECT CTAS
      SET ORDER TO AN1CTA
      SEEK RMOV->CODCTA
      IF FOUND()
         GsMsgErr = Mensge+" ["+ALLTRIM(RMOV->CodCta)+"] es cuenta autom tica "+TRANS(RMOV->NroItm,"#####")
         DO MENSAJE1
      ENDIF
      SET ORDER TO CTAS01
      SELECT RMOV
   ENDIF
  *IF ELIITM = "ú" .AND. ! CtaAut
   IF ELIITM = "*" .AND. ! CtaAut  
      GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Invalida Cuenta autom tica "+TRANS(RMOV->NroItm,"#####")
      DO MENSAJE1
   ENDIF
  *IF CtaAut .AND. NumEleX= 1 &&.AND. ELIITM <> "ú"
  *IF CtaAut .AND. NumEleX= 1 &&.AND. ELIITM <> "*"  
  *   CtaAut = .F.
  *   GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" no genero cuenta autom tica "+TRANS(rmov->NroItm,"#####")
  *   DO MENSAJE1
  *ENDIF
   IF CtaAut .AND. NumEleX= 1
      IF !EMPTY(TsTpoGto)
         IF CodRef <> TsTpoGto
            DO WHILE !RLOCK('RMOV')
            ENDDO
            REPLACE RMOV.CodRef WITH TsTpoGto
            REPLACE RMOV.CodAux WITH TsTpoGto
            REPLACE RMOV.ClfAux WITH TsClf9x
            UNLOCK IN RMOV
         ENDIF
      ENDIF
      IF !EMPTY(LsAn1Aux)
         IF CodRef <> LsAn1Aux
            DO WHILE !RLOCK('RMOV')
            ENDDO
            REPLACE RMOV.CodRef WITH LsAn1Aux
            REPLACE RMOV.CodAux WITH LsAn1Aux
            REPLACE RMOV.ClfAux WITH LsAn1Aux
            UNLOCK IN RMOV
         ENDIF
      ENDIF

      IF CodCta <> LsAn1Cta
         GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" genero mal la cta.autom tica "+TRANS(rmov->NroItm,"#####")
         DO MENSAJE1
      ELSE
         IF Abs(AfImpUsa-LfImpUsa)>.2 .OR. ABS(AfImport-LfImport)>.2
            GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Importes en cta.autom tica "+TRANS(rmov->NroItm,"#####")
            DO MENSAJE1
         ENDIF
      ENDIF
   ENDIF
   IF CtaAut .AND. NumEleX= 2
      IF CodCta <> LsCc1Cta
        *set step on
         GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" genero mal la cta.autom tica "+TRANS(rmov->NroItm,"#####")
         DO MENSAJE1
      ELSE
         IF Abs(AfImpUsa+LfImpUsa)>.2 .OR. ABS(AfImport+LfImport)>.2
            GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Importes en cta.autom tica "+TRANS(rmov->NroItm,"#####")
            DO MENSAJE1
         ENDIF
      ENDIF
      CtaAut = .F.
   ENDIF
   ***
  *IF INLIST(RMOV->CodCta,'606','607','61','62','63','64','65','67','68','71100106','71100206','72100000','72200000') &&AND EliItm="ú"
   IF INLIST(RMOV->CodCta,'606','607','61','62','63','64','65','67','68','71100106','71100206','72100000','72200000') &&AND EliItm="*"  
      IF CodCta=[61] AND TPOMOV=[H]
      ELSE
          TfCtas6x = TfCtas6x + IIF(TpoMov="D",Import,-Import)
      ENDIF
   ENDIF
   IF INLIST(RMOV->CodCta,'91','92','93','94','95','97') &&AND CTAS->GenAut="S"
      TfCtas9x = TfCtas9x + IIF(TpoMov="D",Import,-Import)
   ENDIF
  *IF INLIST(RMOV->CodCta,'79')   &&AND EliItm="ú"
   IF INLIST(RMOV->CodCta,'79')   &&AND EliItm="*"  
      TfCtas79 = TfCtas79 + IIF(TpoMov="D",Import,-Import)
   ENDIF
   ***
   NumEleX= NumEleX+ 1
   T_Itms = T_Itms + 1
   IF T_Itms <> NroItm
      Chqado =Chqado +1
   ENDIF
   IF RLOCK()
      REPLACE ChkItm   WITH T_Itms
   ENDIF
   UNLOCK
   IF TpoMov  ="D"
      T_DbeNac = T_DbeNac + Import
      T_DbeUsa = T_DbeUsa + ImpUsa
   ELSE
      T_HbeNac = T_HbeNac + Import
      T_HbeUsa = T_HbeUsa + ImpUsa
   ENDIF
   T_Ctas = T_Ctas + VAL(LTRIM(TRIM(CodCta)))
   IF XiCodMon = 1
      nImport = Import
   ELSE
      nImport = ImpUsa
   ENDIF
   IF TPOMOV = "D"
      nSumDbe = nSumDbe + nImport
   ELSE
      nSumHbe = nSumHbe + nImport
   ENDIF
   SKIP
ENDDO
IF (ABS(TfCtas9x)-ABS(TfCtas6x))>.1 or (ABS(TfCtas79)-ABS(TfCtas9x))>.1  or (ABS(TfCtas79)-ABS(TfCtas6x))>.1
   GsMsgErr = Mensge+" Verificar cuentas automaticas"
   DO MENSAJE1
ENDIF
**** Verificamos si existe desbalance *****
Redondeo = .F.
A_DbeNac =0
A_HbeNac =0
A_DbeUsa =0
A_HbeUsa =0
DesBalNac = .F.
DesBalUsa = .F.
MsgDesbal = []
DesBalNac = (ABS(T_DbeNac - T_HbeNac)>.01)
DesBalUsa = (ABS(T_DbeUsa - T_HbeUsa)>.01)
IF DesBalNac .OR. DesbalUsa
   IF DesBalNac
      GsMsgErr = Mensge+" DESBALANCEADO " + trans(ABS(T_DbeNac - T_HbeNac),"999,999,999.99")+" SOLES"
      DO MENSAJE1
   ENDIF
   IF DesBalUsa
      GsMsgErr = Mensge+" DESBALANCEADO " + trans(ABS(T_DbeUsa - T_HbeUsa),"999,999,999.99")+" DOLARES"
      DO MENSAJE1
   ENDIF
ELSE
   *** AJUSTE POR REDONDEO ***
   IF VMOV->TpoCmb > 0
      IF XiCodMon = 1
         A_DbeUsa =ROUND(T_DbeNac/VMOV->TpoCmb,2) - T_DbeUsa
         A_HbeUsa =ROUND(T_HbeNac/VMOV->TpoCmb,2) - T_HbeUsa
      ELSE
         A_DbeNac =ROUND(T_DbeUsa*VMOV->TpoCmb,2) - T_DbeNac
         A_HbeNac =ROUND(T_HbeUsa*VMOV->TpoCmb,2) - T_HbeNac
      ENDIF
   ENDIF
   **** Verificando que el Ajuste a realizar no sobrepase a .05 ***
   zOk = .T.
   IF ABS(A_DbeUsa) > .05
      zOK = .F.
   ENDIF
   IF ABS(A_HbeUsa) > .05
      zOK = .F.
   ENDIF
   IF ABS(A_DbeNac) > .05
      zOK = .F.
   ENDIF
   IF ABS(A_HbeNac) > .05
      zOK = .F.
   ENDIF
   IF ABS(A_DbeUsa) > 0
      Redondeo = .T.
   ENDIF
   IF ABS(A_HbeUsa) > 0
      Redondeo = .T.
   ENDIF
   IF ABS(A_DbeNac) > 0
      Redondeo = .T.
   ENDIF
   IF ABS(A_HbeNac) > 0
      Redondeo = .T.
   ENDIF
ENDIF
****** REDONDEO MALOGRA LOS ASIENTOS ****
*   IF REDONDEO
*      IF XIDEVICE = 1
*         @ 22,27 SAY "³  **** REDONDEANDO ***  ³" COLOR -
*      ENDIF
*      T_DbeNac =0
*      T_HbeNac =0
*      T_DbeUsa =0
*      T_HbeUsa =0
*      SEEK LLAVE
*      DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
*         IF UltDebe  = RECNO()
*            DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
*            REPLACE Import WITH Import + A_DbeNac
*            REPLACE ImpUsa WITH ImpUsa + A_DbeUsa
*            DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov ,  Import ,  ImpUsa
*         ENDIF
*         IF UltHber  = RECNO()
*            DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
*            REPLACE Import WITH Import + A_HbeNac
*            REPLACE ImpUsa WITH ImpUsa + A_HbeUsa
*            DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov ,  Import ,  ImpUsa
*         ENDIF
*         IF TpoMov  ="D"
*            T_DbeNac = T_DbeNac + Import
*            T_DbeUsa = T_DbeUsa + ImpUsa
*         ELSE
*            T_HbeNac = T_HbeNac + Import
*            T_HbeUsa = T_HbeUsa + ImpUsa
*         ENDIF
*         SKIP
*         IF XiDevice = 1
*            @ 22,27 SAY "³  **** REDONDEANDO ***  ³" COLOR SCHEME 7
*         ENDIF
*      ENDDO
*   ENDIF
*         IF XiDevice = 1
*            @ 22,27 SAY "³  **** PROCESANDO ****  ³" COLOR SCHEME 7
*         ENDIF
*DO WHILE Chqado > 0
*   SELECT RMOV
*   SEEK LLAVE
*   DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
*      IF RLOCK()
*         Chqado =Chqado - 1
*         REPLACE NroItm WITH ChkItm
*      ENDIF
*      UNLOCK
*      SKIP
*   ENDDO
*ENDDO
SELECT VMOV
IF REC_LOCK(5)
   REPLACE ChkCta  WITH T_Ctas
   REPLACE DbeNac  WITH T_DbeNac
   REPLACE DbeUsa  WITH T_DbeUsa
   REPLACE HbeNac  WITH T_HbeNac
   REPLACE HbeUsa  WITH T_HbeUsa
   REPLACE NroItm  WITH T_Itms
   UNLOCK
ENDIF
RETURN


******************
PROCEDURE MENSAJE1
******************
SCROLL 8,10,18,68,1
IF XiDevice=1
   @ 18,11 SAY GsMsgErr
ELSE
   @ PROW() + 1,02 SAY GsMsgErr
ENDIF
Lineas = Lineas + 1
IF Lineas = 11  .AND. XiDevice=1
   SAVE SCREEN
   ?? CHR(7)
   @ 20,27 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
   @ 21,27 SAY "³                        ³" COLOR SCHEME 7
   @ 22,27 SAY "³Presione Cualquier Tecla³" COLOR -
   @ 23,27 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 7
   =inkey(0)
   RESTORE SCREEN
   LINEAS = 0
   SCROLL 8,10,18,68,1
ENDIF
RETURN
