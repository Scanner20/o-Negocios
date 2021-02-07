*

SELECT 1
USE CBDACMCT ORDER ACCT01 ALIAS ACCT
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF

SELE 2
USE CBDMCTAS order CTAS01 ALIAS CTAS
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF

SELECT 4
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF

SELECT 5
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF


SELECT 6
USE CBDTCIER ALIAS CIERRA
IF !used(1)
    close data
    return
ENDIF


******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTA POR TIPO DE GASTO MENSUAL"

Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

XiMesIni = 1
XiMesFin = _Mes
XiNroDig = 3
XsCodCta = SPACE(LEN(CTAS->CodCta))

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "CUENTA     : "
@ 12,24 SAY "DESDE MES  : "
@ 13,24 SAY "HASTA MES  : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,38,2)
      CASE i = 2
         SELE CTAS
         @ 11,38 GET XsCodCta PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF !CBDBUSCA("CTAS")
                UltTecla = 0
                LOOP
            ELSE
                XsCodCta = CTAS->CodCta
                UltTecla = Enter
            ENDIF
         ENDIF
         SEEK XsCodCta
         IF !FOUND()
            GsMsgErr = "Cuenta no registrada"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
      CASE i = 3
         @ 12,38 GET XiMesIni PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         @ 13,38 GET XiMesFin PICTURE "99"
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 4 , i + 1, 4 )

      CASE UltTecla = Enter
         IF  i < 4
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
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
ArcTmp = PathUser+SYS(3)
SELECT ACCT
SET ORDER TO ACCT02
SET TALK ON
SET TALK WINDOW
SEEK TRIM(XsCodCta)
IF XiCodMOn = 1
   COPY REST TO &ArcTmp FOR (LEN(TRIM(CodCta))=LEN(ACCT.COdCta) .AND.  (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. !(DBENAC=0 .AND. HBENAC=0) WHILE INLIST(CodCta,TRIM(XsCodCta))
ELSE
   COPY REST TO &ArcTmp FOR (LEN(TRIM(CodCta))=LEN(ACCT.COdCta) .AND.  (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. !(DBEEXT=0 .AND. HBEEXT=0) WHILE INLIST(CodCta,TRIM(XsCodCta))
ENDIF
SET TALK OFF
USE &ArcTmp ALIAS ACCT
**** Actualizando cuentas por Grupo ****
INDEX ON LEFT(CODCTA,XiNroDig)+CODREF TO  &ArcTmp
SET RELATION TO CODCTA INTO CTAS
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

Ancho   = 238
Cancelar= .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN4+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo    = "ANALISIS DE LA CUENTA "+TRIM(XsCodCta)
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "<HORA : "+TIME()
En2 = ""
En3 =""
En4 ="(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En5 = ""
En6 = ""
En7 = "***************************** *************** *************** *************** *************** *************** *************** *************** *************** *************** *************** *************** *************** ***************"
En8 = "  TIPO DE GASTO                    Enero          Febrero          Marzo            Abril           Mayo            Junio          Julio           Agosto        Setiembre        Octubre        Noviembre       Diciembre        TOTAL      "
En9 = "***************************** *************** *************** *************** *************** *************** *************** *************** *************** *************** *************** *************** *************** ***************"
       *                             123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345


@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7

Cancelar = .F.
SET DEVICE TO PRINT
SET MARGIN TO 0
DIMENSION X(14),Y(14),V(14),Z(14),vTot(14)

PRINTJOB
   NumPag = 0
   SELECT ACCT
   INICIO = .T.
   GOTO TOP
   STORE 0 TO Y
   DO WHILE ! EOF() .AND. ! Cancelar
      XsCGrupo = LEFT(CodCta,XiNroDig)
      En3 = "** "+XsCGrupo+' '+TRIM(CTAS->NOMCTA)+"  **"
      INICIO = .T.
      STORE 0 TO V
      NroLin1 = 0
      DO WHILE ! EOF() .AND. CodCta = XsCGrupo .AND. ! Cancelar
         Quiebre = .T.
         STORE 0 TO Z
         NroLin1 = 0
         XsCodAgp = LEFT(CodRef,1)
         DO WHILE ! EOF() .AND. CodCta = XsCGrupo .AND. XsCodAgp = LEFT(CodRef,1) .AND. ! Cancelar
           *XsTpoGto = LEFT(CodRef,2)
            XsTpoGto = LEFT(CodRef,3)
            =SEEK("04 "+XsTpoGto,"AUXI")
            STORE 0 TO X
            DO LINIMP
            Cancelar = INKEY() = Escape
            SELECT ACCT
         ENDDO
         DO TOTAL1
      ENDDO
      DO TOTAL2
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

****************
PROCEDURE LINIMP
****************
SELECT ACCT
DO WHILE ! EOF() .AND. CodRef = XsTpoGto .AND. CodCta = XsCGrupo
   XfValor = - HbeNac + DbeNac
   I =  VAL(NroMes)
   IF XiCodMon = 2
     SELE CIERRA
     GO I+1
     XfValor = XfValor/OFIVTA
     SELE ACCT
   ENDIF
   X(I) = X(I) + XfValor
   SKIP
ENDDO
DO ResetPag
NumLin = PROW() + 1
NroLin1 = NroLin1 + 1
@ Numlin,01 SAY XsTpoGto
@ Numlin,05 SAY AUXI->NomAux         PICT "@S23"

Tot = 0
FOR i=1 to 12
  Col = (i-1)*16 + 30
  IF X(i) >= 0
     @ Numlin,Col SAY X(i)    PICT "999,999,999.99"
  ELSE
     @ Numlin,Col SAY -X(i)    PICT "999,999,999.99-"
  ENDIF
  Z(i) = Z(i) + X(i)
  Tot = Tot + X(i)
ENDFOR
Col = (i-1)*16 + 30
IF Tot  >= 0
   @ Numlin,Col SAY Tot     PICT "999,999,999.99"
ELSE
   @ Numlin,Col SAY -Tot     PICT "999,999,999.99-"
ENDIF
RETURN

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. Inicio
   Inicio = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***********************************FIN

****************
PROCEDURE TOTAL1
****************
IF NroLin1 <= 0
   RETURN
ENDIF
DO ResetPag
NumLin = PROW() + 1
FOR i=1 to 13
  Col = (i-1)*16 + 30
  @ Numlin,Col SAY "---------------"
ENDFOR
NumLin = PROW() + 1
Tot = 0
FOR i=1 to 12
  Col = (i-1)*16 + 30
  IF Z(i) >= 0
     @ Numlin,Col SAY Z(i)    PICT "999,999,999.99"
  ELSE
     @ Numlin,Col SAY -Z(i)    PICT "999,999,999.99-"
  ENDIF
  V(i) = V(i) + Z(i)
  Tot = Tot + Z(i)
ENDFOR
Col = (i-1)*16 + 30
IF Tot  >= 0
   @ Numlin,Col SAY Tot     PICT "999,999,999.99"
ELSE
   @ Numlin,Col SAY -Tot     PICT "999,999,999.99-"
ENDIF
NumLin = PROW() + 1
@ Numlin,Col SAY ""
RETURN

****************
PROCEDURE TOTAL2
****************
IF NroLin1 <= 0
   RETURN
ENDIF
DO ResetPag
NumLin = PROW() + 1
FOR i=1 to 13
  Col = (i-1)*16 + 30
  @ Numlin,Col SAY "***************"
ENDFOR
NumLin = PROW() + 1
Tot = 0
FOR i=1 to 12
  Col = (i-1)*16 + 30
  IF V(i) >= 0
     @ Numlin,Col SAY V(i)    PICT "999,999,999.99"
  ELSE
     @ Numlin,Col SAY -V(i)    PICT "999,999,999.99-"
  ENDIF
  Tot = Tot + V(i)
ENDFOR
Col = (i-1)*16 + 30
IF Tot  >= 0
   @ Numlin,Col SAY Tot     PICT "999,999,999.99"
ELSE
   @ Numlin,Col SAY -Tot     PICT "999,999,999.99-"
ENDIF
RETURN
