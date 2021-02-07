#INCLUDE CONST.H
*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDTBALC','TBAL','TBAL01','')
goentorno.open_dbf1('ABRIR','CBDNBALC','NBAL','NBAL01','')
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCES"
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1
UltTecla = 0
XsCodbal = "01"
XsNomBal = ALLTRIM(TABL.Nombre)
XsTipRep  = .F.

DO FORM cbd_cbdrb004
RETURN

******************
PROCEDURE Imprimir
******************
DO F0PRINT
IF UltTecla = 27
	RETURN
ENDIF
STORE 0 TO REVS1,REVS2,REVD1,REVD2
SELECT TBAL
SEEK XsCodBal
ArcTmp = goentorno.tmppath+SYS(3)
COPY TO (ArcTmp) WHILE Rubro = XsCodBal
USE (ArcTmp) ALIAS TBAL
INDEX ON RUBRO  TO (ArcTmp)

IF ! CARGA()
	RETURN
ENDIF

IF XsTipRep = .f.
	Ancho = 180
	Cancelar = .F.
	*** VETT 2008-05-30 ----- INI
	LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
	XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
	Largo    = XnLargo
	LinFin   = Largo - 2
	*** VETT 2008-05-30 ----- FIN

*!*		Largo   = 66       && Largo de pagina
*!*		LinFin  = Largo - 8
	IniImp  = _PRN3
	LnLenCia=42
	Tit_SIZQ = SUBSTR(TRIM(GsNomCia),1,LnLenCia)
	Tit_IIZQ = SUBSTR(TRIM(GsNomCia),LnLenCia+1)
	Tit_IIZQ2 = "RUC:"+GsRucCia
	Tit_SDER = "FECHA : "+DTOC(GdFecha)
	Tit_IDER = ""

	IF _Mes < 12
		LdFecha   = CTOD("01/"+STR(_Mes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
	ELSE
		LdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
	ENDIF
	Titulo  = ALLTRIM(XsNomBal)+" al "+STR(DAY(LdFecha),2)+" de "+Mes(_mes,3)+" de "+str(_ano,4)
	IF XiCodMon=1
		SubTitulo = "(EXPRESADO EN SOLES)" &&+TRIM(VECOPC(XiCodMon))+")"
	ELSE
		SubTitulo = "(EXPRESADO EN DOLARES)" &&+TRIM(VECOPC(XiCodMon))+")"
	ENDIF
	**SubTitulo = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
	En1 = " "
	En2 = " "
	En3 = ""
	En4 = "A C T I V O                                                                P A S I V O   Y   P A T R I M O N I O    N E T O"
	En5 = " "
	En6 = ""
	En7 = ""
	En8 = "                                                          A Diciembre           A Noviembre                                                             A Diciembre           A Noviembre"
	En9 = "                                                  -------------------- --------------------                                                     -------------------- --------------------"
	Texto1 = PADC("A "+Mes(_Mes,3),20)
	Texto2 = PADC("A "+Mes(iif(_Mes>0,_mes-1,0),3),20)
	En8 = STUFF(En8,51,LEN(Texto1),Texto1)
	En8 = STUFF(En8,72,LEN(Texto2),Texto2)
	En8 = STUFF(En8,51+95,LEN(Texto1),Texto1)
	En8 = STUFF(En8,72+95,LEN(Texto2),Texto2)
ELSE
	Ancho = 144
	Cancelar = .F.
	*** VETT 2008-05-30 ----- INI
	LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
	XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
	Largo    = XnLargo
	LinFin   = Largo - 2
	*** VETT 2008-05-30 ----- FIN

*!*		Largo   = 66       && Largo de pagina
*!*		LinFin  = Largo - 8
	IniImp  = _PRN3
	Tit_SIZQ = TRIM(GsNomCia)
	Tit_IIZQ = ""
	Tit_SDER = ""
	Tit_IDER = ""

	IF _Mes < 12
		LdFecha   = CTOD("01/"+STR(_Mes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
	ELSE
		LdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
	ENDIF
	Titulo  = ALLTRIM(XsNomBal)+" al "+STR(DAY(LdFecha),2)+" de "+Mes(_mes,3)+" de "+str(_ano,4)
	IF XiCodMon=1
		SubTitulo = "(EXPRESADO EN SOLES)" &&+TRIM(VECOPC(XiCodMon))+")"
	ELSE
		SubTitulo = "(EXPRESADO EN DOLARES)" &&+TRIM(VECOPC(XiCodMon))+")"
	ENDIF
	En1 = " "
	En2 = " "
	En3 = ""
	En4 = "A C T I V O                                                          P A S I V O   Y   P A T R I M O N I O    N E T O"
	En5 = " "
	En6 = ""
	En7 = ""
	En8 = "                                                          A Diciembre                                                             A Diciembre"
	En9 = "                                                 --------------------                                                    --------------------"
	Texto1 = PADC("A "+Mes(_Mes,3),20)
	En8 = STUFF(En8,51,LEN(Texto1),Texto1)
	En8 = STUFF(En8,51+72,LEN(Texto1),Texto1)
ENDIF
Cancelar = .F.
SELECT TBAL
GO TOP
Pos1 = 50
Pos2 = 71

**@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
**@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
**@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
	SEEK XsCodBal+"A"
	RegPas = RECNO()
	EofPas = EOF() .OR. Rubro <> XsCodBal+"A"
	SEEK XsCodBal+" "
	RegAct = RECNO()
	EofAct = EOF() .OR. Rubro <> XsCodBal+" "
	Inicio = .T.
	NumPag  = 0
	STORE 0 TO L1,L2,L3,L4,TG1
	STORE 0 TO M1,M2,M3,M4,TG2
	STORE 0 TO N1,N2,N3,N4,TG3
	STORE 0 TO O1,O2,O3,O4,TG4
	DO WHILE ! EofPas   && .AND. EofAct)
		DO ResetPag
		NumLin = PROW() + 1
		DO LinImp1
		DO LinImp2
		IF ! EofPas
			SKIP
			EofPas = EOF() .OR. Rubro <> XsCodBal+"A"
			RegPas = RECNO()
		ENDIF
		IF ! EofAct
			GOTO RegAct
			SKIP
			EofAct = EOF() .OR. Rubro <> XsCodBal+" "
			RegAct = RECNO()
		ENDIF
	ENDDO
	NumLin = PROW() + 1
	EJECT PAGE
ENDPRINTJOB
UNLOCK ALL
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT
*DELETE FILE &ArcTmp..DBF
*DELETE FILE &ArcTmp..IDX
RETURN

*****************
PROCEDURE LinImp1
*****************
IF EofAct
	RETURN
ENDIF
Separa = 0
DO LinImp
RETURN
*****************
PROCEDURE LinImp2
*****************
IF EofPas
	RETURN
ENDIF
GOTO RegPas
IF XsTipRep = .f.
	Separa = 95
ELSE
	Separa = 72
ENDIF
DO LinImp
RETURN
****************
PROCEDURE LinImp
****************
IF XsTipRep = .f.
	@ NumLin,Separa SAY Glosa
	DO CASE
		CASE NOTA = "R1" .AND. Separa # 0
			N1 = 0
			O1 = 0
		CASE NOTA = "R2" .AND. Separa # 0
			N2 = 0
			O2 = 0
		CASE NOTA = "R3" .AND. Separa # 0
			N3 = 0
			O3 = 0
		CASE NOTA = "R4" .AND. Separa # 0
			N4 = 0
			O4 = 0
		CASE NOTA = "R1" .AND. Separa = 0
			L1 = 0
			M1 = 0
		CASE NOTA = "R2" .AND. Separa = 0
			L2 = 0
			M2 = 0
		CASE NOTA = "R3" .AND. Separa = 0
			L3 = 0
			M3 = 0
		CASE NOTA = "R4" .AND. Separa = 0
			L4 = 0
			M4 = 0
		CASE NOTA = "RS"
			@ NumLin,Pos1+Separa SAY REPLICATE("-",20)
			@ NumLin,Pos2+Separa SAY REPLICATE("-",20)
		CASE NOTA = "RD"
			@ NumLin,Pos1+Separa  SAY REPLICATE("=",20)
			@ NumLin,Pos2+Separa  SAY REPLICATE("=",20)
		CASE NOTA = "L1" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L1)
			@ NumLin,Pos2+Separa  SAY PICNUM(M1)
			L1 = 0
			M1 = 0
		CASE NOTA = "L2" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L2)
			@ NumLin,Pos2+Separa  SAY PICNUM(M2)
			L2 = 0
			M2 = 0
		CASE NOTA = "L3" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L3)
			@ NumLin,Pos2+Separa  SAY PICNUM(M3)
			L3 = 0
			M3 = 0
		CASE NOTA = "L4" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L4)
			@ NumLin,Pos2+Separa  SAY PICNUM(M4)
			L4 = 0
			M4 = 0
		CASE NOTA = "TG" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(TG1)
			@ NumLin,Pos2+Separa  SAY PICNUM(TG2)
		CASE ! EMPTY(Nota) .AND. Separa = 0
			V1=0
			V2=0
			DO CALCULO
			@ NumLin,Pos1+Separa  SAY PICNUM(V1)
			@ NumLin,Pos2+Separa  SAY PICNUM(V2)
			L1 = L1 + V1
			L2 = L2 + V1
			L3 = L3 + V1
			L4 = L4 + V1
			TG1 = TG1 + V1
			M1 = M1 + V2
			M2 = M2 + V2
			M3 = M3 + V2
			M4 = M4 + V2
			TG2 = TG2 + V1
		CASE NOTA = "L1" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N1)
			@ NumLin,Pos2+Separa  SAY PICNUM(O1)
			N1 = 0
			O1 = 0
		CASE NOTA = "L2" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N2)
			@ NumLin,Pos2+Separa  SAY PICNUM(O2)
			N2 = 0
			O2 = 0
		CASE NOTA = "L3" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N3)
			@ NumLin,Pos2+Separa  SAY PICNUM(O3)
			N3 = 0
			O3 = 0
		CASE NOTA = "L4" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N4)
			@ NumLin,Pos2+Separa  SAY PICNUM(O4)
			N4 = 0
			O4 = 0
		CASE NOTA = "TG" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(TG3)
			@ NumLin,Pos2+Separa  SAY PICNUM(TG4)
		CASE ! EMPTY(Nota) .AND. Separa # 0
			V1=0
			V2=0
			DO CALCULO
			@ NumLin,Pos1+Separa  SAY PICNUM(V1)
			@ NumLin,Pos2+Separa  SAY PICNUM(V2)
			N1 = N1 + V1
			N2 = N2 + V1
			N3 = N3 + V1
			N4 = N4 + V1
			TG3 = TG3 + V1
			O1 = O1 + V2
			O2 = O2 + V2
			O3 = O3 + V2
			O4 = O4 + V2
			TG4 = TG4 + V1
	ENDCASE
ELSE
	@ NumLin,Separa SAY Glosa
	DO CASE
		CASE NOTA = "R1" .AND. Separa # 0
			N1 = 0
			O1 = 0
		CASE NOTA = "R2" .AND. Separa # 0
			N2 = 0
			O2 = 0
		CASE NOTA = "R3" .AND. Separa # 0
			N3 = 0
			O3 = 0
		CASE NOTA = "R4" .AND. Separa # 0
			N4 = 0
			O4 = 0
		CASE NOTA = "R1" .AND. Separa = 0
			L1 = 0
			M1 = 0
		CASE NOTA = "R2" .AND. Separa = 0
			L2 = 0
			M2 = 0
		CASE NOTA = "R3" .AND. Separa = 0
			L3 = 0
			M3 = 0
		CASE NOTA = "R4" .AND. Separa = 0
			L4 = 0
			M4 = 0
		CASE NOTA = "RS"
			@ NumLin,Pos1+Separa SAY REPLICATE("-",20)
		CASE NOTA = "RD"
			@ NumLin,Pos1+Separa  SAY REPLICATE("=",20)
		CASE NOTA = "L1" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L1)
			L1 = 0
			M1 = 0
		CASE NOTA = "L2" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L2)
			L2 = 0
			M2 = 0
		CASE NOTA = "L3" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L3)
			L3 = 0
			M3 = 0
		CASE NOTA = "L4" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(L4)
			L4 = 0
			M4 = 0
		CASE NOTA = "TG" .AND. Separa = 0
			@ NumLin,Pos1+Separa  SAY PICNUM(TG1)
		CASE ! EMPTY(Nota) .AND. Separa = 0
			V1=0
			V2=0
			DO CALCULO
			@ NumLin,Pos1+Separa  SAY PICNUM(V1)
			L1 = L1 + V1
			L2 = L2 + V1
			L3 = L3 + V1
			L4 = L4 + V1
			TG1 = TG1 + V1
			M1 = M1 + V2
			M2 = M2 + V2
			M3 = M3 + V2
			M4 = M4 + V2
			TG2 = TG2 + V1
		CASE NOTA = "L1" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N1)
			N1 = 0
			O1 = 0
		CASE NOTA = "L2" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N2)
			N2 = 0
			O2 = 0
		CASE NOTA = "L3" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N3)
			N3 = 0
			O3 = 0
		CASE NOTA = "L4" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(N4)
			N4 = 0
			O4 = 0
		CASE NOTA = "TG" .AND. Separa # 0
			@ NumLin,Pos1+Separa  SAY PICNUM(TG3)
		CASE ! EMPTY(Nota) .AND. Separa # 0
			V1=0
			V2=0
			DO CALCULO
			@ NumLin,Pos1+Separa  SAY PICNUM(V1)
			N1 = N1 + V1
			N2 = N2 + V1
			N3 = N3 + V1
			N4 = N4 + V1
			TG3 = TG3 + V1
			O1 = O1 + V2
			O2 = O2 + V2
			O3 = O3 + V2
			O4 = O4 + V2
			TG4 = TG4 + V1
	ENDCASE
ENDIF
RETURN
*****************
PROCEDURE CALCULO
*****************
VS1 = MESS01
VD1 = MESD01
VS2 = MESS00
VD2 = MESD00
IF XiCodmOn = 1
	V1 = VS1
	V2 = VS2
ELSE
	V1 = VD1
	V2 = VD2
ENDIF
IF Nota = "RE"   && Resultado del Ejercicio
	IF XiCodmOn = 1
		V1 = REVS1
		V2 = REVS2
	ELSE
		V1 = REVD1
		V2 = REVD2
	ENDIF
ENDIF
RETURN
****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
	*RETURN TRANSF(-Valor,"@Z ###,###,###,###.##")+"CR"
	RETURN TRANSF(-Valor,"@Z ###,###,###,###")+"CR"
ELSE
	*RETURN TRANSF( Valor,"@Z ###,###,###,###.##")+"  "
	RETURN TRANSF( Valor,"@Z ###,###,###,###")+"  "
ENDIF
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
***************
PROCEDURE Carga
***************
**@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
**@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
DIMENSION SOLES(2),DOLARES(2)
DIMENSION XSOLES(2),XDOLARES(2)
SELECT TBAL
DO WHILE ! EOF()
	DO CASE
		CASE NOTA = "RS"
		CASE NOTA = "RD"
		CASE NOTA = "L1"
		CASE NOTA = "L2"
		CASE NOTA = "L3"
		CASE NOTA = "L4"
		CASE NOTA = "TG"
		CASE ! EMPTY(Nota)
			DO CAPTURA
	ENDCASE
	SELECT TBAL
	SKIP
ENDDO
RETURN .T.
*****************
PROCEDURE CAPTURA
*****************
STORE 0 TO SOLES,DOLARES
XcRubro = Rubro
XsNota  = Nota
SELECT NBAL
Llave = XcRubro+XsNota
SEEK Llave
DO WHILE ! EOF() .AND. Rubro+Nota = Llave
	DO VALORIZA
	SELECT NBAL
	SKIP
ENDDO
DO GRABA
RETURN
******************
PROCEDURE VALORIZA
******************
XsCodCta = CodCta
IF "X"$CodCta
	XsCodCta = LEFT(CodCta,AT("X",CodCta)-1)
	LEN= LEN(TRIM(CODCTA))
ELSE
	XsCodCta = CodCta
	LEN=0
ENDIF
XcSigno  = Signo
XcForma  = Forma
SELECT ACCT
SET ORDER TO ACCT02
xLLave = XsCodCta
SEEK xLLave
DO WHILE (CodCta = xLLave ) .AND. ! EOF()
	XS=0
	XD=0
	XS1=0
	XD1=0
	LsCodCta = CodCta
	DO WHILE (CodCta = LsCodCta) .AND. ! EOF()
		TnMes =  VAL(NROMES)
		IF TnMes > _MES
			SKIP
			LOOP
		ENDIF
		IF LEN = LEN(TRIM(CODCTA)) .OR. LEN=0
			XS = XS + DbeNac - Hbenac
			XD = XD + DbeExt - HbeExt
			IF TnMes < _MES
				XS1 = XS1 + DbeNac - Hbenac
				XD1 = XD1 + DbeExt - HbeExt
			ENDIF
		ENDIF
		SKIP
	ENDDO
	DO CASE 
		CASE XcForma = '1' &&.AND. XcRubro = XsCodBal+" "
			IF XS < 0
				XS = 0
			ENDIF
			IF XD < 0
				XD = 0
			ENDIF
			IF XS1< 0
				XS1= 0
			ENDIF
			IF XD1< 0
				XD1= 0
			ENDIF
	
		CASE XcForma = '2' && .AND. XcRubro = XsCodBal+"A"
			IF XS > 0
				XS = 0
			ENDIF
			IF XD > 0
				XD = 0
			ENDIF
			IF XS1> 0
				XS1= 0
			ENDIF
			IF XD1> 0
				XD1= 0
			ENDIF
			
	ENDCASE
	IF XcSigno = '2' .or. XcSigno = '4'
		XS = - XS
		XD = - XD
		XS1= - XS1
		XD1= - XD1
	ENDIF
	IF XcRubro=XsCodBal+" "
		SOLES(1)  =SOLES(1)  +XS1
		DOLARES(1)=DOLARES(1)+XD1
		SOLES(2)  =SOLES(2)  +XS
		DOLARES(2)=DOLARES(2)+XD
	ELSE
		SOLES(1)  =SOLES(1)  -XS1
		DOLARES(1)=DOLARES(1)-XD1
		SOLES(2)  =SOLES(2)  -XS
		DOLARES(2)=DOLARES(2)-XD
	ENDIF
	REVS1 = REVS1 + XS
	REVD1 = REVD1 + XD
	REVS2 = REVS2 + XS1
	REVD2 = REVD2 + XD1
ENDDO
RETURN
***************
PROCEDURE GRABA
***************
SELECT TBAL
REPLACE MESS00  WITH Soles(1)
REPLACE MESD00  WITH Dolares(1)
REPLACE MESS01  WITH Soles(2)
REPLACE MESD01  WITH Dolares(2)
RETURN
