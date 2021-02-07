********************************************************************************
* Progrma       : CBDRB011.PRG                                                 *
* Objeto        : An lisis de la clase 6 por mes                               *
* Autor         : VETT                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n : 10/05/95 VETT                                 A.G.R          *
********************************************************************************
DIMENSION SAC(6,12)
DIMENSION vIMP(12),vTot(12)
STORE 0 to vImp,vTot
sele 1
use cbdmctas order ctas01 alias CTAS
if !used(1)
    close data
    return
endif
sele 2
use cbdacmct order acct02 alias ACCT
if !used(2)
    close data
    return
endif
*
sele 0
use cbdcnfg1 order nivcta alias cnfg1
if !used()
	close data
	return
endif

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANALISIS DE LA CLASE 6 POR MES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
XiMesIni = 1
XiMesFin = _Mes
XiNroDig = 1
LiNroDig = 3
nd = 0
@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE MES  : "
@ 12,24 SAY "HASTA MES  : "
@ 13,24 SAY "DIGITOS    : "
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
         @ 11,38 GET XiMesIni PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,38 GET XiMesFin PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
       	 IF nd=0	
			 sele cnfg1
			 scan 
			 	nd=nd+1
			 	If ALEN(VecOpc)<nd
			 		dimension VecOpc(nd+1)
			 	endif
			 	VecOpc(nd)=TRAN(NroDig,"9")
			 endscan
			 IF nd#0
				 dimension VecOpc(nd)
			 endif
		 ENDIF
        ** VecOpc(1)="4"
        ** VecOpc(2)="8"

         XiNroDig= Elige(1,13,38,ND)
         LiNroDig=VAL(VecOpc(XiNroDig))
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
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"

@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
ArcTmp = Pathuser+SYS(3)
SELECT ACCT
SEEK "6"
SET TALK ON
SET TALK WINDOW
IF XiCodMon = 1
   COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=LiNroDig  .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBENAC - HBENAC)#0 WHILE CODCTA="6"
ELSE
   COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=LiNroDig  .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBEEXT - HBEEXT)#0 WHILE CODCTA="6"
ENDIF
SET TALK OFF
SELECT 0
USE &ArcTmp
INDEX ON CODCTA+CODREF TO  &ArcTmp
SET INDEX TO &ArcTmp
DO IMP_X
CLOSE DATA
DELETE FILE &ArcTmp..dbf
DELETE FILE &ArcTmp..idx
***************
PROCEDURE IMP_X
***************
Ancho = 252
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88    - 6
IniImp  = _PRN4+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "ANALISIS DE LA CLASE 6"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)

En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = ""
En7 = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En8 = "     CUENTAS - CONCEPTOS             ENERO          FEBRERO             MARZO           ABRIL              MAYO            JUNIO           JULIO          AGOSTO         SETIEMBRE          OCTUBRE         NOVIEMBRE    "
En9 = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En7 =En7+"-----------------------------------"
En8 =En8+"   DICIEMBRE       ACUMULADO       "
En9 =En9+"-----------------------------------"

*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
*     CUENTAS - CONCEPTOS             ENERO           FEBRERO              MARZO            ABRIL               MAYO             JUNIO            JULIO           AGOSTO          SETIEMBRE           OCTUBRE          NOVIEMBRE    "
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
*12345678901234567890123456789 ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR ###,###,###.## CR
*                              30                48                66                84                102               120               138               156               174               192               210
*-------------------------------------"
*    DICIEMBRE        ACUMULADO       "
*-------------------------------------"
* ###,###,###.## CR ###,###,###.## CR


*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Texto1 = PADL("A "+Mes(_Mes,3),20)
Texto2 = PADL("A "+Mes(iif(_Mes>0,_mes-1,0),3),20)
Cancelar = .F.
Pos1 = 50
Pos2 = 71
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   Inicio = .T.
   NumPag  = 0
   STORE 0 TO vTot
   DO WHILE ! EOF()
      LsCodCta = CodCta
      vImp = 0
      DO Calculo
      DO LinImp
     *SKIP
   ENDDO
   NumLin = PROW() + 1
   DO TOTIMP
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
RETURN
*****************
PROCEDURE Calculo
*****************
DO WHILE !EOF() AND CodCta=LsCodCta
   xmes = VAL(NroMes)
   IF XiCodMon = 1
      vImp(xMes) = vImp(xMes) + (DbeNac - HbeNac)
   ELSE
      vImp(xMes) = vImp(xMes) + (DbeExt - HbeExt)
   ENDIF
   SKIP
ENDDO
RETURN
****************
PROCEDURE LinImp
****************
DO RESETPAG
Numlin = PROW() + 1
TOT    = 0
=SEEK(LsCodCta,"CTAS")
@ NumLin,0 SAY LsCodCta+" "+CTAS->nomCta PICT "@S30"
FOR i = 1 to 12
  @ NumLin,30-17+I*17   SAY PICNUM(vImp[I])
  TOT      = TOT + vImp[i]
  vTot(i)     = vTot(i) + vImp[i]
  vImp[i] = 0
NEXT
@ NumLin,235  SAY PICNUM(TOT)
RETURN
****************
PROCEDURE TotImp
****************
DO RESETPAG
Numlin = PROW() + 1
@NumLin ,00 SAY REPLI("=",ANCHO)
Numlin = PROW() + 1
TOT    = 0
@ NumLin,0 SAY "TOTAL GENERAL"
FOR i = 1 to 12
  @ NumLin,30-17+I*17   SAY PICNUM(vTot[I])
  TOT      = TOT + vTot[i]
NEXT
@ NumLin,235  SAY PICNUM(TOT)
RETURN

****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
   RETURN TRANSF(-Valor,"@Z ####,###,###.##")+"-"
ELSE
   RETURN TRANSF( Valor,"@Z ####,###,###.##")+" "
ENDIF
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio  = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
