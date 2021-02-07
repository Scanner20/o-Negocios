***************************************************************************
*  NOMBRE        : VTAR4100.PRG
*  Sistema       : ventas
*  Proposito     : Registro de Facturas Ordenado por Fechas y por Correlativo
*  Creacion      : 21/02/95
***************************************************************************
CLEAR
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REGISTRO DE VENTAS <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 08,10 CLEAR TO 15,68
@ 08,10 TO 15,68 DOUBLE
CLOSE DATA
WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
@ 10,17 SAY "Tipo Documento : "
@ 11,17 SAY "  Ordenado por : "
STORE DATE() TO XdFch1,XdFch2
STORE SPACE(9) TO XsCod1,XsCod2
xnGuia   = []
XiTpoRep = 1
XiTpoDoc = 1
xTCmb    = 1
nRep     = []
CLOSE DATA
DO xListar
CLOSE DATA
RETURN
*********************************************************************** EOP() *
PROCEDURE xListar
*******************
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 2
USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 3
USE ccbrrdoc ORDER RDOC01 ALIAS RDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 4
USE admmtcmb ORDER tcmb01 ALIAS TCMB
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 5
USE vtaritem ORDER item01 ALIAS ITEM
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape)
	DO CASE
	CASE i = 1
		VecOpc(1) = "FACTURAS"
		VecOpc(2) = "BOLETAS "
		VecOpc(3) = "NOTA DE CARGO"
		VecOpc(4) = "NOTA DE ABONO"
		XiTpoDoc  = Elige(XiTpoDoc,10,35,4)
	CASE i = 2
		VecOpc(1) = "1.Ordenado por Correlativo"
		VecOpc(2) = "2.Ordenado por Fecha      "
		XiTpoRep  = Elige(XiTpoRep,11,35,2)
	CASE i = 3
		@ 12,15 SAY "         Periodo :"
		@ 12,35 GET XdFch1  PICT "@E"
		READ
		ULTTECLA = LASTKEY()
		IF UltTecla = Escape
			EXIT
		ENDIF
   CASE i = 4
		@ 12,49 GET XdFch2  PICT "@E"
		READ
		ULTTECLA = LASTKEY()
		IF UltTecla = Escape
			EXIT
		ENDIF
	CASE i = 5 AND XiTpoRep = 1
		@ 13,15 SAY "Rango de N£meros :"
		@ 13,35 GET XsCod1  PICT "@R 999-999999"
		READ
		IF !EMPTY(XsCod1)
			XsCodd = RIGHT("000"+LEFT(XsCod1,3),3)
			XsCod1 = XsCodd+RIGHT("000000"+ALLTRIM(SUBS(XsCod1,4)),6)
		ENDIF
		@ 13,35 SAY XsCod1  PICT "@R 999-999999"
		IF UltTecla = Escape
			EXIT
		ENDIF
	CASE i = 6 AND XiTpoRep = 1
		@ 13,49 GET XsCod2  PICT "@R 999-999999"
		READ
		IF !EMPTY(XsCod2)
			XsCodd = RIGHT("000"+LEFT(XsCod2,3),3)
			XsCod2 = XsCodd+RIGHT("000000"+ALLTRIM(SUBS(XsCod2,4)),6)
		ENDIF
		@ 13,49 SAY XsCod2  PICT "@R 999-999999"
		IF UltTecla = Escape
			EXIT
		ENDIF
	ENDCASE
	IF UltTecla = Enter AND i=6
		EXIT
	ENDIF
	i = IIF(INLIST(UltTecla,Escape,BackTab,Arriba),i-1,i+1)
	i = IIF(i<1,1,I)
	i = IIF(i>6,6,I)
ENDDO
IF UltTecla = Escape
	CLOSE DATA
	RETURN
ENDIF
***  Filtros  para xGenera ***
XsCod1  = TRIM(XsCod1)
XsCod2  = TRIM(XsCod2)+CHR(255)
xFor1   = "XdFch1<=FchDoc AND XdFch2>=FchDoc"
xWhile1 = "XdFch1<=FchDoc AND XdFch2>=FchDoc"
DO xGENERA
** Variables para report **
xFor   = []
xWhile = []
SELE TEMPO
GO TOP
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
sNomRep = nRep
DO admprint WITH "REPORTS"
RETURN
*********************************************************************** FIN() *
PROCEDURE xGENERA
*****************
Arch = PATHUSER+SYS(3)
SELE 0
CREATE TABLE &Arch. ( TpoDoc C(5), CodDoc C(4), NroAst C(6),NroDoc C(10), FchDoc D, CodCli C(5), NomCli C(40), CodMon N(1), TpoCmb N(10,4), NacBto N(14,2), NacDto N(14,2), NacIgv N(14,2), NacInt N(14,2), NacAdm N(14,2), NacTot N(14,2),;
                    UsaBto N(14,2), UsaDto N(14,2), UsaIgv N(14,2), UsaInt N(14,2), UsaAdm N(14,2), UsaTot N(14,2), noGuia C(40))
USE &Arch.  ALIAS TEMPO EXCLU
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
IF XiTpoRep = 1
	INDEX ON TpoDoc+CodDoc+NroDoc TO &Arch.
	nRep = "vta4100a"
	xWhile1 = "XsCod1<=NroDoc AND XsCod2>=NroDoc"
ELSE
	INDEX ON Dtos(FchDoc)+TpoDoc+CodDoc+NroDoc TO &Arch.
	nRep = "vta4100b"
	xWhile1 = ".T."
ENDIF


SET INDEX TO &Arch.
*
SAVE SCREEN
Titulo = [** GENERANDO REPORTE **]
@ 22,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
SELE GDOC
* barremos FACTURAS *
DO CASE
	CASE XiTpoDoc = 1
		SEEK [Cargo]+[FACT]
		SCAN WHILE TpoDoc=[Cargo] AND CodDoc=[FACT] AND &xWhile1 FOR &xFor1
			DO xCambio
			SELE TEMPO
			APPEND BLANK
			REPLACE TpoDoc WITH [A]
			REPLACE CodDoc WITH GDOC->CodDoc
			REPLACE NroDoc WITH GDOC->NroDoc
			REPLACE FchDoc WITH GDOC->FchDoc
			REPLACE CodCli WITH GDOC->CodCli
			REPLACE NroAst WITH GDOC->NroAst
			DO xGuia
			SELE TEMPO
			REPLACE noGuia WITH XnGuia
			IF GDOC->FlgEst # [A]
				REPLACE NomCli WITH GDOC->NomCli
				REPLACE CodMon WITH GDOC->CodMon
				REPLACE TpoCmb WITH xTCmb
				***SOLES
				REPLACE NacBto WITH IIF(CodMon=1,GDOC->ImpBto,GDOC->ImpBto*TpoCmb)
				REPLACE NacDto WITH IIF(CodMon=1,GDOC->ImpDto,GDOC->ImpDto*TpoCmb)
				REPLACE NacIgv WITH IIF(CodMon=1,GDOC->ImpIgv,GDOC->ImpIgv*TpoCmb)
				REPLACE NacInt WITH IIF(CodMon=1,GDOC->ImpInt,GDOC->ImpInt*TpoCmb)
				REPLACE NacAdm WITH IIF(CodMon=1,GDOC->ImpAdm,GDOC->ImpAdm*TpoCmb)
				REPLACE NacTot WITH IIF(CodMon=1,GDOC->ImpTot,GDOC->ImpTot*TpoCmb)
				***DOLARES
				REPLACE UsaBto WITH IIF(CodMon=2,GDOC->ImpBto,GDOC->ImpBto/TpoCmb)
				REPLACE UsaDto WITH IIF(CodMon=2,GDOC->ImpDto,GDOC->ImpDto/TpoCmb)
				REPLACE UsaIgv WITH IIF(CodMon=2,GDOC->ImpIgv,GDOC->ImpIgv/TpoCmb)
				REPLACE UsaInt WITH IIF(CodMon=2,GDOC->ImpInt,GDOC->ImpInt/TpoCmb)
				REPLACE UsaAdm WITH IIF(CodMon=2,GDOC->ImpAdm,GDOC->ImpAdm/TpoCmb)
				REPLACE UsaTot WITH IIF(CodMon=2,GDOC->ImpTot,GDOC->ImpTot/TpoCmb)
			ELSE
				REPLACE NomCli WITH [ ** A N U L A D O ** ]
			ENDIF
			SELE GDOC
		ENDSCAN
	CASE XiTpoDoc = 2
		SEEK [Cargo]+[BOLE]
		SCAN WHILE TpoDoc=[Cargo] AND CodDoc=[BOLE] AND &xWhile1 FOR &xFor1
			DO xCambio
			SELE TEMPO
			APPEND BLANK
			REPLACE TpoDoc WITH [B]
			REPLACE CodDoc WITH GDOC->CodDoc
			REPLACE NroDoc WITH GDOC->NroDoc
			REPLACE FchDoc WITH GDOC->FchDoc
			REPLACE CodCli WITH GDOC->CodCli
			REPLACE NroAst WITH GDOC->NroAst
			DO xGuia
			SELE TEMPO
			REPLACE noGuia WITH XnGuia
			IF GDOC->FlgEst # [A]
				REPLACE NomCli WITH GDOC->NomCli
				REPLACE CodMon WITH GDOC->CodMon
				REPLACE TpoCmb WITH xTCmb
				*** Nuevos Soles
				REPLACE NacBto WITH IIF(CodMon=1,GDOC->ImpBto,GDOC->ImpBto*TpoCmb)
				REPLACE NacDto WITH IIF(CodMon=1,GDOC->ImpDto,GDOC->ImpDto*TpoCmb)
				REPLACE NacIgv WITH IIF(CodMon=1,GDOC->ImpIgv,GDOC->ImpIgv*TpoCmb)
				REPLACE NacInt WITH IIF(CodMon=1,GDOC->ImpInt,GDOC->ImpInt*TpoCmb)
				REPLACE NacAdm WITH IIF(CodMon=1,GDOC->ImpAdm,GDOC->ImpAdm*TpoCmb)
				REPLACE NacTot WITH IIF(CodMon=1,GDOC->ImpTot,GDOC->ImpTot*TpoCmb)
				*** Dolares Americanos
				REPLACE UsaBto WITH IIF(CodMon=2,GDOC->ImpBto,GDOC->ImpBto/TpoCmb)
				REPLACE UsaDto WITH IIF(CodMon=2,GDOC->ImpDto,GDOC->ImpDto/TpoCmb)
				REPLACE UsaIgv WITH IIF(CodMon=2,GDOC->ImpIgv,GDOC->ImpIgv/TpoCmb)
				REPLACE UsaInt WITH IIF(CodMon=2,GDOC->ImpInt,GDOC->ImpInt/TpoCmb)
				REPLACE UsaAdm WITH IIF(CodMon=2,GDOC->ImpAdm,GDOC->ImpAdm/TpoCmb)
				REPLACE UsaTot WITH IIF(CodMon=2,GDOC->ImpTot,GDOC->ImpTot/TpoCmb)
			ELSE
				REPLACE NomCli WITH [ ** A N U L A D O ** ]
			ENDIF
			SELE GDOC
		ENDSCAN
	CASE XiTpoDoc = 3
		SEEK [Cargo]+[N/C ]
		SCAN WHILE TpoDoc=[Cargo] AND CodDoc=[N/C ] AND &xWhile1 FOR &xFor1
			DO xCambio
			SELE TEMPO
			APPEND BLANK
			REPLACE TpoDoc WITH [C]
			REPLACE CodDoc WITH GDOC->CodDoc
			REPLACE NroDoc WITH GDOC->NroDoc
			REPLACE FchDoc WITH GDOC->FchDoc
			REPLACE CodCli WITH GDOC->CodCli
*			DO xGuia
*			SELE TEMPO
*			REPLACE noGuia WITH XnGuia
			IF GDOC->FlgEst # [A]
				REPLACE NomCli WITH GDOC->NomCli
				REPLACE CodMon WITH GDOC->CodMon
				REPLACE TpoCmb WITH xTCmb
				*** Nuevos Soles
				REPLACE NacBto WITH IIF(CodMon=1,GDOC->ImpBto,GDOC->ImpBto*TpoCmb)
				REPLACE NacDto WITH IIF(CodMon=1,GDOC->ImpDto,GDOC->ImpDto*TpoCmb)
				REPLACE NacIgv WITH IIF(CodMon=1,GDOC->ImpIgv,GDOC->ImpIgv*TpoCmb)
				REPLACE NacInt WITH IIF(CodMon=1,GDOC->ImpInt,GDOC->ImpInt*TpoCmb)
				REPLACE NacAdm WITH IIF(CodMon=1,GDOC->ImpAdm,GDOC->ImpAdm*TpoCmb)
				REPLACE NacTot WITH IIF(CodMon=1,GDOC->ImpTot,GDOC->ImpTot*TpoCmb)
				*** Dolares Americanos
				REPLACE UsaBto WITH IIF(CodMon=2,GDOC->ImpBto,GDOC->ImpBto/TpoCmb)
				REPLACE UsaDto WITH IIF(CodMon=2,GDOC->ImpDto,GDOC->ImpDto/TpoCmb)
				REPLACE UsaIgv WITH IIF(CodMon=2,GDOC->ImpIgv,GDOC->ImpIgv/TpoCmb)
				REPLACE UsaInt WITH IIF(CodMon=2,GDOC->ImpInt,GDOC->ImpInt/TpoCmb)
				REPLACE UsaAdm WITH IIF(CodMon=2,GDOC->ImpAdm,GDOC->ImpAdm/TpoCmb)
				REPLACE UsaTot WITH IIF(CodMon=2,GDOC->ImpTot,GDOC->ImpTot/TpoCmb)
			ELSE
				REPLACE NomCli WITH [ ** A N U L A D O ** ]
			ENDIF
			SELE GDOC
		ENDSCAN
	CASE XiTpoDoc = 4
		SEEK [Abono]+[N/A ]
		SCAN WHILE TpoDoc=[Abono] AND CodDoc=[N/A ] AND &xWhile1 FOR &xFor1
			DO xCambio
			SELE TEMPO
			APPEND BLANK
			REPLACE TpoDoc WITH [D]
			REPLACE CodDoc WITH GDOC->CodDoc
			REPLACE NroDoc WITH GDOC->NroDoc
			REPLACE FchDoc WITH GDOC->FchDoc
			REPLACE CodCli WITH GDOC->CodCli
			DO xGuia
			SELE TEMPO
			REPLACE noGuia WITH XnGuia
			IF GDOC->FlgEst # [A]
				REPLACE NomCli WITH GDOC->NomCli
				REPLACE CodMon WITH GDOC->CodMon
				REPLACE TpoCmb WITH xTCmb
				*** Nuevos Soles
				REPLACE NacBto WITH IIF(CodMon=1,GDOC->ImpBto,GDOC->ImpBto*TpoCmb)
				REPLACE NacDto WITH IIF(CodMon=1,GDOC->ImpDto,GDOC->ImpDto*TpoCmb)
				REPLACE NacIgv WITH IIF(CodMon=1,GDOC->ImpIgv,GDOC->ImpIgv*TpoCmb)
				REPLACE NacInt WITH IIF(CodMon=1,GDOC->ImpInt,GDOC->ImpInt*TpoCmb)
				REPLACE NacAdm WITH IIF(CodMon=1,GDOC->ImpAdm,GDOC->ImpAdm*TpoCmb)
				REPLACE NacTot WITH IIF(CodMon=1,GDOC->ImpTot,GDOC->ImpTot*TpoCmb)
				*** Dolares Americanos
				REPLACE UsaBto WITH IIF(CodMon=2,GDOC->ImpBto,GDOC->ImpBto/TpoCmb)
				REPLACE UsaDto WITH IIF(CodMon=2,GDOC->ImpDto,GDOC->ImpDto/TpoCmb)
				REPLACE UsaIgv WITH IIF(CodMon=2,GDOC->ImpIgv,GDOC->ImpIgv/TpoCmb)
				REPLACE UsaInt WITH IIF(CodMon=2,GDOC->ImpInt,GDOC->ImpInt/TpoCmb)
				REPLACE UsaAdm WITH IIF(CodMon=2,GDOC->ImpAdm,GDOC->ImpAdm/TpoCmb)
				REPLACE UsaTot WITH IIF(CodMon=2,GDOC->ImpTot,GDOC->ImpTot/TpoCmb)
			ELSE
				REPLACE NomCli WITH [ ** A N U L A D O ** ]
			ENDIF
			SELE GDOC
		ENDSCAN
ENDCASE
RESTORE SCREEN
RETURN
*********************************************************************** FIN() *
* Devuelve el documento
*******************************************************************************
FUNCTION _TpoDoc
PARAMETER cTpoDoc
DO CASE
	CASE cTpoDoc = 1
		RETURN [FACTURAS]
	CASE cTpoDoc = 2
		RETURN [BOLETAS DE VENTA]
	CASE cTpoDoc = 3
		RETURN [NOTAS DE CARGO]
	CASE cTpoDoc = 4
		RETURN [NOTAS DE ABONO]
ENDCASE
RETURN 0
*********************************************************************** FIN() *
PROCEDURE xCambio
*****************
SELE TCMB
SEEK DTOS(GDOC->FCHDOC)
IF FOUND()
	xTCmb = IIF(OfiVta>0,OfiVta,GDOC->TpoCmb)
ELSE
	xTCmb = IIF(GDOC->TpoCmb>0,GDOC->TpoCmb,1)
ENDIF
xTCmb = IIF(xTCmb >0,xTCmb ,1)
RETURN
********************************************************************* FIN()
PROCEDURE xGuia
*****************
SELE ITEM
SEEK TEMPO->CodDoc+TEMPO->NroDoc
xnGuia=[]
xsGuia=[]
SCAN WHILE CodDoc+NroDoc=TEMPO->CodDoc+TEMPO->NroDoc
	XsGuia = SUBS(NroRef,4)
	IF !(XsGuia$XnGuia)
		XnGuia = IIF(EMPTY(XnGuia),ALLTRIM(NroRef),XnGuia+'|'+XsGuia)
	ENDIF
ENDSCAN
RETURN
********************************************************************* FIN()
