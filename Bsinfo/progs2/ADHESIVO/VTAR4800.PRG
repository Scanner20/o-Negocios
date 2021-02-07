*******************************************************************************
*  NOMBRE        : Vtar4800.prg
*  Sistema       : Ventas
*  Proposito     : Diario de Ventas
*  Creacion      : 29/03/95
*******************************************************************************
PRIVATE XSCODVEN
CLEAR
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REGISTRO DE VENTAS <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 5,10 CLEAR TO 20,68
@ 5,10 TO 20,68 DOUBLE
CLOSE DATA
WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
DO SDOLista
CLOSE DATA
RETURN
*********************************************************************** EOP() *
PROCEDURE SDOLista
*******************
SELE 0
USE almtabla ORDER TABL01 ALIAS TABL
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 0
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 0
USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 0
USE ccbrrdoc ORDER RDOC01 ALIAS RDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE 0
USE admmtcmb ORDER tcmb01 ALIAS TCMB
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE GDOC
Arch = PATHUSER+SYS(3)
SELE 0
CREATE TABLE &Arch. ( TpoDoc C(5), CodDoc C(4), NroDoc C(9), FchDoc D, CodCli C(5), NomCli C(40), CodMon N(1), TpoCmb N(10,4), NacBto N(14,2), NacDto N(14,2), NacIgv N(14,2), NacInt N(14,2), NacAdm N(14,2), NacTot N(14,2),;
                    UsaBto N(14,2), UsaDto N(14,2), UsaIgv N(14,2), UsaInt N(14,2), UsaAdm N(14,2), NroAst C(6),UsaTot N(14,2))
USE &Arch.  ALIAS TEMPO EXCLU
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
INDEX ON DTOS(FchDoc)+TpoDoc+CodDoc+NroDoc TO &Arch.
SET INDEX TO &Arch.
** variables a usar **
XSCODVEN = space(4)
STORE DATE() TO XdFch1,XdFch2
xTCmb    = 1
XiTpoDoc = 1
DO LIB_MTEC WITH 16
@ 10,15 SAY "Tipo Documento :"
@ 11,15 SAY "       Del Dia :"
@ 12,15 SAY "        Al Dia :"
@ 13,15 SAY "      Vendedor :"
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape)
	DO CASE
		CASE i = 1
			VecOpc(1) = "FACTURAS"
			VecOpc(2) = "BOLETAS "
			XiTpoDoc  = Elige(XiTpoDoc,10,35,2)
		CASE i = 2
			@ 11,35 GET XdFch1  PICT "@E"
			READ
			ULTTECLA = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
		CASE i = 3
			@ 12,35 GET XdFch2  PICT "@E"
			READ
			ULTTECLA = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
		CASE i = 4
			SELECT TABL
			XsTabla = "09"
			@ 13,35 GET XsCodVen
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			IF UltTecla = F8
				IF !vtabusca("TABL")
					UltTecla = 0
					LOOP
				ENDIF
				XsCodVen = TABL->Codigo
			ENDIF
			IF EMPTY(XSCODVEN)
				@ 13,40 SAY "AREQUIPA Y LIMA"
			ELSE
				@ 13,40 SAY TABL.Nombre PICT "@S15"
			ENDIF
	ENDCASE
	IF UltTecla = Enter AND i=4
		EXIT
	ENDIF
	i = IIF(INLIST(UltTecla,Escape,BackTab,Arriba),i-1,i+1)
	i = IIF(i<1,1,I)
	i = IIF(i>4,4,I)
ENDDO
IF UltTecla = Escape
	CLOSE DATA
	RETURN
ENDIF
** Generamos Registro Final **
DO xGENERA
** test de impresion **
XFOR   = []
XWHILE = []
** buscamos registro de arranque **
SELE TEMPO
SET RELA TO DTOS(FchDoc) INTO TCMB
GO TOP
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "VTAR4800"
DO admprint WITH "REPORTS"

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

SAVE SCREEN
Titulo = [** GENERANDO REPORTE **]
@ 22,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
SELE GDOC
IF !EMPTY(XSCODVEN)
	SET FILTER TO CODVEN=XsCodVen
ENDIF
* barremos FACTURAS *
IF XiTpoDoc = 1
	SEEK [Cargo]+[FACT]
	SCAN WHILE TpoDoc=[Cargo] .AND. CodDoc=[FACT] FOR ;
		XdFch1<=FchDoc .AND. XdFch2>=FchDoc
		DO xCambio
		SELE TEMPO
		APPEND BLANK
		REPLACE TpoDoc WITH [A]
		REPLACE CodDoc WITH GDOC->CodDoc
		REPLACE NroDoc WITH GDOC->NroDoc
		REPLACE FchDoc WITH GDOC->FchDoc
		REPLACE CodCli WITH GDOC->CodCli
		REPLACE NroAst WITH GDOC->NroAst
		IF GDOC->FlgEst # [A]
			REPLACE NomCli WITH GDOC->NomCli
			REPLACE CodMon WITH GDOC->CodMon
			REPLACE TpoCmb WITH xTCmb
			** OJO >> Se va a reportear al tipo cambio de la tabla **
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
		* * * *
		SELE GDOC
	ENDSCAN
ELSE
	SEEK [Cargo]+[BOLE]
	SCAN WHILE TpoDoc=[Cargo] .AND. CodDoc=[BOLE] FOR ;
		XdFch1<=FchDoc .AND. XdFch2>=FchDoc
		DO xCambio
		SELE TEMPO
		APPEND BLANK
		REPLACE TpoDoc WITH [B]
		REPLACE CodDoc WITH GDOC->CodDoc
		REPLACE NroDoc WITH GDOC->NroDoc
		REPLACE FchDoc WITH GDOC->FchDoc
		REPLACE CodCli WITH GDOC->CodCli
		REPLACE NroAst WITH GDOC->NroAst
		IF GDOC->FlgEst # [A]
			REPLACE NomCli WITH GDOC->NomCli
			REPLACE CodMon WITH GDOC->CodMon
			REPLACE TpoCmb WITH xTCmb
			** OJO >> Se va a reportear al tipo cambio de la tabla **
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
			*****
		ELSE
			REPLACE NomCli WITH [ ** A N U L A D O ** ]
		ENDIF
		* * * *
		SELE GDOC
	ENDSCAN
ENDIF
**************************
*Prueba
**************************
*SEEK [Cargo]+[N/C]
*SCAN WHILE TpoDoc=[Cargo] .AND. CodDoc=[N/C] FOR ;
*     XdFecha1<=FchDoc .AND. XdFecha2>=FchDoc
*   DO xCambio
*   SELE TEMPO
*   APPEND BLANK
*   REPLACE TpoDoc WITH [C]
*   REPLACE CodDoc WITH GDOC->CodDoc
*   REPLACE NroDoc WITH GDOC->NroDoc
*   REPLACE FchDoc WITH GDOC->FchDoc
*   REPLACE CodCli WITH GDOC->CodCli
*   IF GDOC->FlgEst # [A]
*      REPLACE NomCli WITH GDOC->NomCli
*      REPLACE CodMon WITH GDOC->CodMon
*      REPLACE TpoCmb WITH xTCmb
*      ** OJO >> Se va a reportear al tipo cambio de la tabla **
*      *** Nuevos Soles
*      REPLACE NacBto WITH IIF(CodMon=1,GDOC->ImpBto,GDOC->ImpBto*TpoCmb)
*      REPLACE NacDto WITH IIF(CodMon=1,GDOC->ImpDto,GDOC->ImpDto*TpoCmb)
*      *** Dolares
*      REPLACE UsaBto WITH IIF(CodMon=2,GDOC->ImpBto,GDOC->ImpBto/TpoCmb)
*      REPLACE UsaDto WITH IIF(CodMon=2,GDOC->ImpDto,GDOC->ImpDto/TpoCmb)
*      SELE RDOC
*      SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
*      SCAN WHILE TpoDoc+CodDoc+NroDoc = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc ;
*           FOR Codigo = [IGV]
*           *** Nuevos Soles
*           REPLACE TEMPO->NacIgv WITH IIF(GDOC->CodMon=1,RDOC->Import,RDOC->Import*TEMPO->TpoCmb)
*           *** Dolares
*           REPLACE TEMPO->UsaIgv WITH IIF(GDOC->CodMon=2,RDOC->Import,RDOC->Import/TEMPO->TpoCmb)
*      ENDSCAN
*      SELE TEMPO
*      *** Nuevos Soles
*         REPLACE NacInt WITH IIF(CodMon=1,GDOC->ImpInt,GDOC->ImpInt*TpoCmb)
*         REPLACE NacAdm WITH IIF(CodMon=1,GDOC->ImpAdm,GDOC->ImpAdm*TpoCmb)
*         REPLACE NacTot WITH IIF(CodMon=1,GDOC->ImpTot,GDOC->ImpTot*TpoCmb)
*      *** Dolares
*         REPLACE UsaInt WITH IIF(CodMon=2,GDOC->ImpInt,GDOC->ImpInt/TpoCmb)
*         REPLACE UsaAdm WITH IIF(CodMon=2,GDOC->ImpAdm,GDOC->ImpAdm/TpoCmb)
*         REPLACE UsaTot WITH IIF(CodMon=2,GDOC->ImpTot,GDOC->ImpTot/TpoCmb)
*   ELSE
*      REPLACE NomCli WITH [ ** A N U L A D O ** ]
*   ENDIF
*   * * * *
*   SELE GDOC
*ENDSCAN
*
*SEEK [Abono]+[N/A]
*SCAN WHILE TpoDoc=[Abono] .AND. CodDoc=[N/A] FOR ;
*     XdFecha1<=FchDoc .AND. XdFecha2>=FchDoc
*   DO xCambio
*   SELE TEMPO
*   APPEND BLANK
*   REPLACE TpoDoc WITH [D]
*   REPLACE CodDoc WITH GDOC->CodDoc
*   REPLACE NroDoc WITH GDOC->NroDoc
*   REPLACE FchDoc WITH GDOC->FchDoc
*   REPLACE CodCli WITH GDOC->CodCli
*   IF GDOC->FlgEst # [A]
*      REPLACE NomCli WITH GDOC->NomCli
*      REPLACE CodMon WITH GDOC->CodMon
*      REPLACE TpoCmb WITH xTCmb
*      ** OJO >> Se va a reportear al tipo de cambio del dia **
*      *** Nuevos Soles
*         REPLACE NacBto WITH IIF(CodMon=1,GDOC->ImpBto,GDOC->ImpBto*TpoCmb)
*         REPLACE NacDto WITH IIF(CodMon=1,GDOC->ImpDto,GDOC->ImpDto*TpoCmb)
*      *** Dolares
*         REPLACE UsaBto WITH IIF(CodMon=2,GDOC->ImpBto,GDOC->ImpBto/TpoCmb)
*         REPLACE UsaDto WITH IIF(CodMon=2,GDOC->ImpDto,GDOC->ImpDto/TpoCmb)
*      SELE RDOC
*      SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
*      SCAN WHILE TpoDoc+CodDoc+NroDoc = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc ;
*           FOR Codigo = [IGV]
*           REPLACE TEMPO->NacIgv WITH IIF(GDOC->CodMon=1,RDOC->Import,RDOC->Import*TEMPO->TpoCmb)
*           REPLACE TEMPO->UsaIgv WITH IIF(GDOC->CodMon=2,RDOC->Import,RDOC->Import/TEMPO->TpoCmb)
*      ENDSCAN
*      SELE TEMPO
*      *** Nuevos Soles
*         REPLACE NacInt WITH IIF(CodMon=1,GDOC->ImpInt,GDOC->ImpInt*TpoCmb)
*         REPLACE NacAdm WITH IIF(CodMon=1,GDOC->ImpAdm,GDOC->ImpAdm*TpoCmb)
*         REPLACE NacTot WITH IIF(CodMon=1,GDOC->ImpTot,GDOC->ImpTot*TpoCmb)
*      *** Dolares
*         REPLACE UsaInt WITH IIF(CodMon=2,GDOC->ImpInt,GDOC->ImpInt/TpoCmb)
*         REPLACE UsaAdm WITH IIF(CodMon=2,GDOC->ImpAdm,GDOC->ImpAdm/TpoCmb)
*         REPLACE UsaTot WITH IIF(CodMon=2,GDOC->ImpTot,GDOC->ImpTot/TpoCmb)
*   ELSE
*      REPLACE NomCli WITH [ ** A N U L A D O ** ]
*   ENDIF
*   * * * *
*   SELE GDOC
*ENDSCAN
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
ENDCASE
*RETURN [NOTAS DE CARGO]
*RETURN [NOTAS DE ABONO]
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
