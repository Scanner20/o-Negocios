*IF ! Master
*   GsMsgErr = "Ingreso no Autorizado"
*   DO LIB_MERR WITH 99
*   RETURN
*ENDIF
**********************************************************************
* Dibujar Pantalla
cTit1 = GsNomCia
cTit2 = "A¥O : "+TRANSF(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION DE PLANILLA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
** RESTORE FROM PLNCONFG ADDI
@  6,3 FILL  to 18,74 COLOR N/W
@  5,4 CLEAR to 17,75 double
@  5,4 to 17,75 double

RESTORE FROM PLNCONFG.MEM addITIVE

XiNroMes = PLNNroMes
XiNroSem = PLNNroSem
XiNroQui = PLNNroQui
XiNroAno = PLNNroAno
XlModCfj = PlnNroCfj

**XsPass01 = IIF(TYPE([PLNPASS01])#[C],SPACE(10),PADR(PLNPASS01,10))
**XsPass02 = IIF(TYPE([PLNPASS02])#[C],SPACE(10),PADR(PLNPASS02,10))
**XsPass03 = IIF(TYPE([PLNPASS03])#[C],SPACE(10),PADR(PLNPASS03,10))

m.control = 1
@  07,13 SAY "    A¤o Actual  : " GET XiNroAno PICT "9,999" RANGE 1993,3000
@  09,13 SAY "    Mes Actual  : " GET XiNroMes PICT "@L ##" RANGE 1,12
@  11,13 SAY "  Semana Actual : " GET XiNroSem PICT "@L ##" RANGE 1,54
IF MASTER 
*	@  13,13 SAY "       Modificar: " GET XlModCfj PICT "@*C Conceptos fijos" when miclave([PLNCFIJO],[XPASSWORD])
ENDIF
**@  13,13 SAY "Password Maestro: " GET XsPass01 PICTURE "@!" when pid_psw(xspass01,13,32,11)

@  15,30 GET M.cONTROL PICT "@*HT \<Aceptar;\<Cancelar"
READ cycle
IF LASTKEY() = 27 OR m.Control=2
   RETURN
ENDIF
PLNNroMes= XiNroMes
PLNNroSem= XiNroSem
PLNNroQui= XiNroQui
PLNNroAno= XiNroAno
PLNNrocFJ= XlModCfj
XsNroMes = TRANSF(PLNNroMes,"@L ##")
XsNroSem = TRANSF(PLNNroSem,"@L ##")
XsNroQui = TRANSF(PLNNroQui,"@L ##")

****     XsNroPer = XsNroMes
_ANO     = PLNNroAno
SAVE TO PLNCONFG ALL LIKE PLNNro???
RETURN
****************
FUNCTION pid_Psw
****************
PARAMETER varX,ff,cc,lon
varx=oculto(ff,cc,lon)
return varx