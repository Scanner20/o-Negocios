******************************
***  APERTURA DE ARCHIVOS  ***
******************************
Private XFCANDES,XSCODMAT,XPRECIO
SELE 1
USE almmmatg ORDER MATG01 ALIAS MATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE almrmovm ORDER RMOV03 ALIAS RMOV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
**************************
***  INGRESO DE DATOS  ***
**************************
CLEAR
@  0,0 TO  2,79 DOUBLE
@  1,2 SAY GSNOMCIA
TITULO = " PROCESO DE PRODUCCION DIA ANTERIOR "
@  1,(80-LEN(TITULO))/2 SAY TITULO
@  1,70 SAY DATE()
DO LIB_MSGS with 0
XsDIAPRO = DATE()-1
*******************************************************
@  4,1 CLEAR TO 23,78
@ 09,18 TO 13,59 DOUBLE
@ 12,20 SAY "FECHA DE PROCESO      : "

ULTTECLA = 0
i        = 1
DO WHILE ULTTECLA <> Escape
   DO CASE
      CASE i = 1
         @ 12,42 GET XSDIAPRO Valid !Empty(DtoS(xSDiaPro))
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Enter)
            Exit
         ENDIF
   ENDCASE
   i = IIF(ULTTECLA = ARRIBA, i-1, i+1)
   i = IIF(i < 1, 1, i)
   i = IIF(i > 1, 1, i)
ENDDO
IF ULTTECLA = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
XFILE = 'PROD'+SUBSTR(DTOS(XSDIAPRO),5,2)+SUBSTR(DTOS(XSDIAPRO),3,2)
SELE 4
USE &XFILE ALIAS PROD
SET ORDER TO 1
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
DO PROD_DIA
CLOSE DATA
RETURN

PROCEDURE PROD_DIA
SELE MATG
GO TOP
DO WHILE !EOF()
   SELE MATG
   XSCODMAT = CODMAT
   @20,30 say 'Procesando '+xscodmat
   Sele Rmov
   SEEK XSCODMAT+DTOC(XSDIAPRO,1)
   IF !FOUND()
      SELE MATG
      SKIP
      LOOP
   ENDIF
   *xPrecio=Matg->Preve1
   DO WHILE .T.
      XFCANDES = 0
      Sele Rmov
      Do While Codmat = xScodmat .AND. Fchdoc >= xSdiaPro
         XFCANDES = XFCANDES + CANDES
         SKIP
      Enddo
      Sele Prod
      SEEK XSCODMAT+SUBSTR(DTOS(XSDIAPRO),7,2)
      IF !FOUND()
         APPEND BLANK
      ENDIF
      SW1 = 0
      DO WHILE SW1 = 0
         IF RLOCK()
            REPLACE CODMAT WITH XSCODMAT
            REPLACE DIA   WITH SUBSTR(DTOS(XSDIAPRO),7,2)
            REPLACE CANTIDAD WITH XFCANDES
            *REPLACE VALOR    WITH XFCANDES*XPRECIO
            UNLOCK
            SW1 = 1
         ENDIF
      ENDDO
      Exit
   ENDDO
   SELE MATG
   SKIP
ENDDO
@ 20,0
RETURN
