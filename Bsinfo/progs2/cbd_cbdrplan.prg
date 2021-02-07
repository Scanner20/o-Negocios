#INCLUDE CONST.H
*** Abrimos Bases ***
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS2','CTAS01','')
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "REVISION DE PLAN DE CTAS"
UltTecla = 0
INC = 0   && SOLES
XiESTADO = 1
XsCta1=SPACE(10)
XsCta2=SPACE(10)
LNMES=1

DO FORM cbd_cbdrplan
RETURN

******************
PROCEDURE Imprimir
******************
DO F0PRINT
IF UltTecla = k_esc
	RETURN
ENDIF

IF XiEstado=1
	Ancho = 99
ELSE
	Ancho = 79
ENDIF
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = Largo - 6
IniImp  = _PRN2
Tit_SIZQ = "  "+PADR(TRIM(GsNomCia),24)
Tit_IIZQ = "  "+SUBSTR(TRIM(GsNomCia),25,24)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
IF XiEstado=1
	Titulo  = "REVISION DE PLAN DE CTAS"
	SubTitulo = ""
	En1 = " "
	En2 = "		HORA : "+TIME()+SPACE(244)
	En3 = "============== ============================== ==================== === ====== === ==== ==== ======="
	En4 = "    CUENTA             DESCRIPCION               RESULTADO         NIV AF.MOV CMB AUXI DOCU DOC.REF"
	En5 = "============== ============================== ==================== === ====== === ==== ==== ======="
		  *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		  *0   12345678   123456789012345678901234567890 12345678901234567890 123 123456 123 1234 1234 12345678   
		  *    4          15                             46                   67  71     78  82   87   92
ELSE
	Titulo  = "CUENTAS AUTOMATICAS "
	SubTitulo = ""
	En1 = " "
	En2 = "		HORA : "+TIME()+SPACE(244)
		En3 ="============= ============================== ============== ===================="
		En4 ="    CUENTA           DESCRIPCION             CTA AUTOMATICA  CTRA CTA AUTOMATICA"
		En5 ="============= ============================== ============== ===================="
		 	 *============= ============================== ============== ===================="
			 *    CUENTA           DESCRIPCION             CTA AUTOMATICA  CTRA CTA AUTOMATICA"
			 *============= ============================== ============== ===================="
			 *01234567890123456789012345678901234567890123456789012345678901234567890123456789
			 *0   12345678  123456789012345678901234567890    12345678 X      12345678 X               61
ENDIF

En6 = ""
En7 = ""
En8 = ""
En9 = ""

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cancelar = .F.
SELECT CTAS
SET DEVICE TO PRINT
SET MARGIN TO 0

XsCTA1 = TRIM(XsCTA1)
XsCTA2 = TRIM(XsCTA2)+CHR(255)


IF XiEstado=2
	SET FILTER TO !EMPTY(AN1CTA)
ELSE 
	SET FILTER TO 	
ENDIF
IF EMPTY(XsCTA1)
	GO TOP
	XsCTA1 = CodCta
ELSE
	SEEK XsCTA1
	IF !FOUND()
		IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
			GO RECNO(0)
			IF DELETED()
				SKIP
			ENDIF
			XsCTA1 = CodCta
		ENDIF
	ENDIF
ENDIF
SEEK XsCTA1
IF !FOUND()
	RETURN
ENDIF
*
STORE RECNO() TO REGINI
PRINTJOB
	GO REGINI
	Inicio = .T.
	NumPag  = 0
	cancela=.f.
	DO WHILE ! EOF() .AND. XsCTA2>=CODCTA .AND.!CANCELA
		DO ResetPag
		NumLin = PROW() + 1
		IF XiEstado=1
			DO LinImp1
		ELSE
			DO LinImp2
		ENDIF
		cancela=(INKEY()=k_esc .OR. CANCELA)
		SKIP
	ENDDO
	NumLin = PROW() + 1
	EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT
RETURN

*****************
PROCEDURE LinImp1
*****************
Separa = 0
@ NumLin,4   SAY CODCTA
@ NumLin,15  SAY LEFT(NOMCTA,30)
IF CODCTA>='60'
	DO CASE
		CASE TPOCTA=1
			@ NumLin,46  SAY "NATURALEZA"
		CASE TPOCTA=2
			@ NumLin,46  SAY "FUNCION"
		CASE TPOCTA=3
			@ NumLin,46  SAY "NATURALEZA Y FUNCION"
		OTHER
			@ NumLin,46  SAY "NINGUNA"
	ENDCASE
ELSE
	DO CASE
		CASE TPOCTA=1
			@ NumLin,46  SAY "ACTIVO CTE"
		CASE TPOCTA=2
			@ NumLin,46  SAY "ACTIVO NO CTE"
		CASE TPOCTA=3
			@ NumLin,46  SAY "PASIVO CTE"
		CASE TPOCTA=4
			@ NumLin,46  SAY "PASIVO NO CTE"
		CASE TPOCTA=5
			@ NumLin,46  SAY "PATRIMONIO"
		OTHER
			@ NumLin,46  SAY "SEGUN SALDO"
	ENDCASE
ENDIF
@ NumLin,67  SAY NIVCTA
@ NumLin,71  SAY AFTMOV
@ NumLin,78  SAY AFTDCB
@ NumLin,82  SAY PIDAUX
@ NumLin,87  SAY PIDDOC
@ NumLin,92  SAY PidGlo
RETURN

*****************
PROCEDURE LinImp2
*****************
Separa = 0
@ NumLin,4   SAY CODCTA
@ NumLin,14  SAY LEFT(NOMCTA,30)
@ NumLin,48  SAY AN1CTA + IIF(SEEK(an1cta,'CTAS2'),""," X")
@ NumLin,64  SAY CC1CTA + IIF(SEEK(cc1cta,'CTAS2'),""," X")
RETURN

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
	Inicio  = .F.
	DO F0MBPRN &&IN ADMPRINT
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
