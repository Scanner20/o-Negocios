CLEAR
*!*	DO def_teclas IN fxgen_2
*!*	SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
STORE '' TO ArcTmp,ArcTmp1,ArcTmp2,ArcTmp3

private m.modo,m.coddoc,m.codcli1,m.codcli2,m.tpodoc,m.fchdoc1,m.fchdoc2,m.fchdoc3,m.fchdoc4
private m.tpodoc,m.flgest,m.flgsit,XsTpoDoc,m.nFlgEst

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CBDMAUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','CCBRGDOC','GDOC01','')
LODATADM.ABRIRTABLA('ABRIR','CCBTBDOC','CCBTBDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS05','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')

Arctmp=lodatadm.oentorno.tmppath+SYS(3)
wait window "Un ..." NOWAIT
wait window "Ok" timeout .25
Arctmp1=lodatadm.oentorno.tmppath+SYS(3)
wait window "Un momento..." NOWAIT
wait window "Ok" timeout .25
Arctmp2=lodatadm.oentorno.tmppath+SYS(3)
wait window "Un momento por..." NOWAIT
wait window "Ok" timeout .25
Arctmp3=lodatadm.oentorno.tmppath+SYS(3)
wait window "Un momento por favor..." NOWAIT
wait window "Ok" timeout .25

SELECT CCBRGDOC
*!*	DO fondo WITH 'Situación de documentos',Goentorno.user.login,GsNomCia,GsFecha
*!*	Declaramos las variables a usarse

m.modo    = 1   && Normal
m.tpodoc  = 1
m.coddoc  = SPACE(LEN(coddoc))
m.codcli1 = SPACE(LEN(codcli))
m.codcli2 = SPACE(LEN(codcli))
m.nflgest = SPACE(LEN(flgest))
m.flgUbc  = SPACE(LEN(flgubc))
m.flgSit  = SPACE(LEN(flgsit))
m.fchdoc1 = DATE()
m.fchdoc2 = DATE()
m.fchdoc3 = DATE()
m.fchdoc4 = DATE()
m.TipRep  = 1

DO FORM ccb_ccbr4300
*!*	DO SitLista

IF USED('TEMPO')
	USE IN TEMPO
ENDIF
IF USED('CCBRGDOC')
	USE IN CCBRGDOC
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('CCBTBDOC')
	USE IN CCBTBDOC
ENDIF
IF USED('CBDMAUXI')
	USE IN CBDMAUXI
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('AUXI1')
	USE IN AUXI1
ENDIF
IF USED('AUXI2')
	USE IN AUXI2
ENDIF
IF USED('AUXI3')
	USE IN AUXI3
ENDIF
IF USED('TABL')
	USE IN TABL
ENDIF

delete file ARCtmp+'.dbf'
delete file ARCtmp+'.cdx'
delete file ARCtmp1+'.dbf'
delete file ARCtmp1+'.cdx'
delete file arctmp2+'.dbf'
delete file arctmp2+'.cdx'
delete file arctmp3+'.dbf'
delete file arctmp3+'.cdx'
CLEAR
CLEAR MACROS 
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
RELEASE LoDatAdm
RETURN

******************
PROCEDURE SitLista
******************
SET STEP ON
*!*	@ 2,0 TO 22,79 PANEL
*!*	@ 2,25  SAY "SITUACION DE DOCUMENTOS"
** variables a usar **
SELECT ccbrgdoc
SET FILTER TO TpoVTa<>3

SET RELA TO GsClfCli+CodCli INTO cbdmauxi
SET RELA TO [04]+CodBco     INTO TABL ADDITIVE
** pantalla de datos **
*!*	@  4,38 say "Ordenado Por:"         COLOR SCHEME 11
*!*	@  4,10 SAY "Tipo de Documento:"    COLOR SCHEME 11
*!*	@  8,10 SAY "C¢digo Documento :"    COLOR SCHEME 11
*!*	@ 10,10 SAY "Del Cliente      :"    COLOR SCHEME 11
*!*	@ 10,38 SAY "Al  Cliente      :"    COLOR SCHEME 11
*!*	@ 12,10 SAY "Condici¢n        :"    COLOR SCHEME 11
*!*	@ 12,45 SAY "Ubicaci¢n :"           COLOR SCHEME 11
*!*	@ 15,10 SAY "Situaci¢n        :"    COLOR SCHEME 11
*!*	@ 18,10 SAY "De la fecha      :"    COLOR SCHEME 11
*!*	@ 18,38 say "  A la fecha     :"    COLOR SCHEME 11
*!*	@ 19,10 SAY "Del Vencimiento  :"    COLOR SCHEME 11
*!*	@ 19,38 say "  Al  Vencimiento:"    COLOR SCHEME 11
*!*	@ 20,10 SAY "Tipo de reporte  :"    COLOR SCHEME 11 
*********************************
*!*	GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	DO LIB_MTEC WITH 99
*!*	UltTecla = 0
*!*	i = 1
*!*	DO WHILE !INLIST(UltTecla,Escape_,CtrlW)
*!*	   DO CASE
*!*	      CASE i=1
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	          DO LIB_MTEC WITH 99
*!*	          @  2,52  get m.modo    Function "^RHT Documento;Codigo de cliente;Mayor a menor monto;Mayor fecha de vcto."
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=2
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	          DO LIB_MTEC WITH 99
*!*	          @  4,28  GET m.tpodoc  FUNCTION "^RHT CARGO;ABONO;TODOS"
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=3
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	          DO LIB_MTEC WITH 99
*!*	          @  8,28  GET m.coddoc  PICT "@!" VALID _coddoc() WHEN m.TpoDoc#3
*!*	          XsTpoDoc=IIF(m.tpodoc=1,'CARGO','ABONO')
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=4
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [F8]Consulta [CTRL-Y]Dato en blanco"
*!*	          DO LIB_MTEC WITH 99
*!*	          @ 10,28  GET m.codcli1 PICT "@!" valid _vlook(@m.codcli1,'codaux')
*!*	          @ 10,56  GET m.codcli2 PICT "@!" valid _vlook(@m.codcli2,'codaux') when _wcodcli(m.codcli1,@m.codcli2)
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=5
*!*	          @23,00
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	          DO LIB_MTEC WITH 99
*!*	          @ 12,28  GET m.nflgest  FUNCTION "^RHT Todos;Pendientes;Cancelados;Anulados;Pendientes por fecha"
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=6
*!*	          @23,00
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	          DO LIB_MTEC WITH 99
*!*	          @ 12,56  GET m.FlgUbc  FUNCTION "^RHT Todos;Cartera;Banco" WHEN m.CodDoc=[LETR]
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=7
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar"
*!*	          DO LIB_MTEC WITH 99
*!*	          DO CASE
*!*	             CASE m.FlgUbc = 1
*!*	                  @ 15,28  GET m.FlgSit  FUNCTION "^RH Todos;Aceptadas;Por aceptar;En descuento;Por descontar;En cobranza;Por cobrar;En garant¡a;Protestadas" WHEN m.CodDoc=[LETR]
*!*	             CASE m.FlgUbc = 2
*!*	                  @ 15,28  GET m.FlgSit  FUNCTION "^RH Todos;Aceptadas;Por aceptar" WHEN m.CodDoc=[LETR]
*!*	             CASE m.FlgUbc = 3
*!*	                  @ 15,28  GET m.FlgSit  FUNCTION "^RH Todos;En descuento;Por descontar;En cobranza;Por cobrar;En garant¡a;Protestadas" WHEN m.CodDoc=[LETR]
*!*	          ENDCASE
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=8
*!*	          @23,00
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar [CTRL-Y]Dato en blanco"
*!*	          DO LIB_MTEC WITH 99
*!*	          @ 18,28  GET m.fchdoc1	PICT "@RD  DD/MM/AA"   
*!*	          @ 18,56  get m.fchdoc2	PICT "@RD  DD/MM/AA"
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	      CASE i=9
*!*	          @23,00
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar [CTRL-Y]Dato en blanco"
*!*	          DO LIB_MTEC WITH 99
*!*	          @ 19,28  GET m.fchdoc3  PICT "@RD  DD/MM/AA"
*!*	          @ 19,56  get m.fchdoc4  PICT "@RD  DD/MM/AA"
*!*	          READ
*!*	          UltTecla = LASTKEY()

*!*	      CASE i=10
*!*	          @23,00
*!*	          GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar [F10] Genera reporte"
*!*	          DO LIB_MTEC WITH 99
*!*	          @ 20,28  GET m.TipRep  FUNCTION "*RH Detallado;Resumen;Ambos"
*!*	          READ
*!*	          UltTecla = LASTKEY()
*!*	          IF INLIST(UltTecla,F10,Enter)
*!*	             UltTecla = CtrlW
*!*	          ENDIF
*!*	          IF INLIST(UltTecla,iZQUIERDA,dERECHA)
*!*	             I=0
*!*	          ENDIF

*!*	      CASE i = 11
*!*	          IF INLIST(UltTecla,Enter,F10)
*!*	             UltTecla = CtrlW
*!*	          ENDIF
*!*	   ENDCASE
*!*	   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
*!*	   i = IIF(i<1,1,i)
*!*	   i = IIF(i>11,11,i)
*!*	ENDDO

*!*	IF LASTKEY() = 27
*!*	   RETURN
*!*	ENDIF

** test de impresion **
DO CASE
	CASE m.nFlgEst = 1
		XFOR1 = ".T."
	CASE m.nFlgEst = 2
		XFOR1 = "FlgEst='P'"
	CASE m.nFlgEst = 3
		XFOR1 = "FlgEst='C'"
	CASE m.nFlgEst = 4
		XFOR1 = "FlgEst='A'"
	CASE m.nFlgEst = 5
		XFOR1 = ".T."
ENDCASE
m.codcli1 = ALLTRIM(m.codcli1)
m.codcli2 = ALLTRIM(m.codcli2)
m.codcli2 = LEFT(m.codcli2+REPLI("z",LEN(codcli)),LEN(codcli))
XFOR2 = "(codcli>=m.codcli1 .AND. codcli<=m.codcli2)"
DO CASE
	CASE EMPTY(m.fchdoc1).and. !empty(m.fchdoc2)
		XFOR3 = "fchdoc<=m.fchdoc2"
		m.titulo1 = [Emitidos hasta el ]+DTOC(m.FchDoc2)+[ ]
	CASE !EMPTY(m.fchdoc1).and. empty(m.fchdoc2)
		XFOR3 = "fchdoc>=m.fchdoc1"
		m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ ]
	CASE !EMPTY(m.fchdoc1).and. !empty(m.fchdoc2)
		XFOR3 = "(fchdoc<=m.fchdoc2.and.fchdoc>=m.fchdoc1)"
		m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ hasta el ]+DTOC(m.FchDoc2)+[ ]
	OTHER
		XFOR3 = ".T."
		m.titulo1 = []
ENDCASE
m.titulo2 = []
DO CASE
	CASE EMPTY(m.fchdoc3).and. !empty(m.fchdoc4)
		XFOR4 = "fchVto<=m.fchdoc4"
        m.Titulo2 = [Vencen hasta el ]+DTOC(m.FchDoc4)
	CASE !EMPTY(m.fchdoc3).and. empty(m.fchdoc4)
		XFOR4 = "fchvto>=m.fchdoc3"
		m.Titulo2 = [Vencen desde el ]+DTOC(m.FchDoc3)
	CASE !EMPTY(m.fchdoc3).and. !empty(m.fchdoc4)
		XFOR4 = "(fchvto<=m.fchdoc4.and.fchvto>=m.fchdoc3)"
		m.Titulo2 = [Vencen desde el ]+DTOC(m.FchDoc3)+[ hasta el ]+DTOC(m.FchDoc4)
	OTHER
		XFOR4 = ".T."
		m.titulo2 = []
ENDCASE
XFOR5 = ".T."
XFOR6 = ".T."
IF m.CodDoc="LETR"
	DO CASE
		CASE m.FlgUbc = 1
			xFor5=[.T.]
			DO CASE
				CASE m.FlgSit=1
					xFor6=[.T.]
				CASE m.FlgSit=2
					xFor6=[FlgSit="A"]
				CASE m.FlgSit=3
					xFor6=[FlgSit="a"]
				CASE m.FlgSit=4
					xFor6=[FlgSit="D"]
				CASE m.FlgSit=5
					xFor6=[FlgSit="d"]
				CASE m.FlgSit=6
					xFor6=[FlgSit="C"]
				CASE m.FlgSit=7
					xFor6=[FlgSit="c"]
				CASE m.FlgSit=8
					xFor6=[FlgSit="G"]
				CASE m.FlgSit=9
					xFor6=[FlgSit="P"]
			ENDCASE
		CASE m.FlgUbc = 2
			xFor5=[FlgUbc="C"]
			DO CASE
				CASE m.FlgSit=1
					xFor6=[.T.]
				CASE m.FlgSit=2
					xFor6=[FlgSit="A"]
				CASE m.FlgSit=3
					xFor6=[FlgSit="a"]
			ENDCASE
		CASE m.FlgUbc = 3
			xFor5=[FlgUbc="B"]
			DO CASE
				CASE m.FlgSit=1
					xFor6=[.T.]
				CASE m.FlgSit=2
					xFor6=[FlgSit="D"]
				CASE m.FlgSit=3
					xFor6=[FlgSit="d"]
				CASE m.FlgSit=4
					xFor6=[FlgSit="C"]
				CASE m.FlgSit=5
					xFor6=[FlgSit="c"]
				CASE m.FlgSit=6
					xFor6=[FlgSit="G"]
				CASE m.FlgSit=7
					xFor6=[FlgSit="P"]
			ENDCASE
	ENDCASE
ENDIF
XFOR = XFOR1+".AND."+XFOR2+".AND."+XFOR3+".AND."+XFOR4+".AND."+XFOR5+".AND."+XFOR6
m.tpodoc = IIF(m.tpodoc=1,'CARGO',IIF(m.TpoDoc=2,'ABONO','     '))
m.Titulo3 = IIF(empty(m.TpoDoc),"TODOS LOS DOCUMENTOS",UPPER([Documentos de ]+m.TpoDoc+[ ]))
IF !empty(m.coddoc)
	=SEEK(m.coddoc,'ccbtbdoc')
	m.Titulo3 = m.Titulo3+[: solo ]+LOWER(ccbtbdoc.desdoc)
	XWHiLE = "tpodoc+coddoc=m.tpodoc+m.coddoc"
ELSE
	IF EMPTY(m.TpoDoc)
		XWHILE = ".T."
	ELSE
		XWHILE = "TpoDoc=m.Tpodoc"
	ENDIF
ENDIF
** buscamos registro de arranque **
SEEK TRIM(m.tpodoc)+TRIM(m.coddoc)
IF !FOUND()
	WAIT "Fin de Archivo, presione barra espaciadora para continuar .." WINDOW
	RETURN
ENDIF
** Archivo temporal de trabajo **
copy structure to &ArcTmp
copy structure to &ArcTmp1
copy structure to &ArcTmp2
copy structure to &ArcTmp3
**
sele 0
use &ArcTmp alias Auxi exclu
if !used()
	return
endif
sele 0
use &ArcTmp1 alias Auxi1 exclu
if !used()
	return
endif
sele 0
use &ArcTmp2 alias Auxi2 exclu
if !used()
	return
endif
sele 0
use &ArcTmp3 alias Auxi3 exclu
if !used()
	return
endif
WAIT "Procesando Informaci¢n..." NOWAIT WINDOW
IF m.modo<>0
	SELE AUXI
	DO CASE
		CASE m.Modo = 1
			INDEX on FlgSitA+TpoDoc+CodDoc+FlgSit+Nrodoc TAG AUXI01
			SET ORDER TO AUXI01
		CASE m.Modo = 2
			INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
			SET ORDER TO AUXI01
			SELE AUXI3
			INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
			SET ORDER TO AUXI01
		CASE m.Modo = 3
			INDEX on FlgSitA+TpoDoc+trans(Imptot,'999,999,999.99')+CodDoc+FlgSit+NroDoc TAG AUXI01 DESCENDING
			SET ORDER TO AUXI01
		CASE m.Modo = 4
			INDEX on FlgSitA+TpoDoc+dtoc(Fchvto,1)+CodDoc+FlgSit TAG AUXI01 DESCENDING
			SET ORDER TO AUXI01
	ENDCASE
	*------- Resumen ------*
	IF m.TipRep>1
		SELE AUXI1
		INDEX ON FlgSitA+TpoDoc+CodDoc+FlgSit TAG AUXI01
		SET ORDER TO AUXI01
	ENDIF
	*---------------------------*
	SELE ccbrgdoc
	DO WHILE (&xwhile) AND !EOF()
		IF !(&xFor)
			SKIP
			LOOP
		ENDIF
		LfSdoDoc = CCb_Sldo(CodCli,TpoDoc,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,xFor3)
		IF Flgest<>'A' AND LfSdoDoc<=.01 AND m.nFlgEst=5
			SKIP
			LOOP
		ENDIF
		IF CCBRGDOC.FlgEst='A'  AND m.nFlgEst=5 
			LfSdoDoc = 0	
			SKIP
			LOOP
		ENDIF
		IF CCBRGDOC.FlgEst='A'  AND m.nFlgEst<>5 AND LfSdoDoc>.01
			LfSdoDoc = 0	
		ENDIF
		SCATTER MEMVAR
		SELE AUXI
		APPEND BLANK
		GATHER MEMVAR
		=SEEK(GsClfCli+ccbrgdoc.codcli,"cbdmauxi")
		REPLACE NomCli  WITH cbdmauxi.NomAux
		cTpoDoc = TpoDoc
		REPLACE TpoDoc  WITH IIF(TpoDoc=[CARGO],[1    ],[2    ])
		REPLACE FlgSitA WITH [D]   && Detallado
		REPLACE FlgEstA WITH [1]
		*!* Calculamos el saldo segun rango de fechas *!*
		REPLACE SdoDoc  WITH IIF(LfSdoDoc<=0.01,0,LfSdoDoc)
		SELE AUXI
		IF CodDoc+FlgSit=[LETR]+[D]
			SELE AUXI2
			APPEND BLANK
			GATHER MEMVAR
			=SEEK(GsClfCli+ccbrgdoc.codcli,"cbdmauxi")
			REPLACE NomCli  WITH cbdmauxi.NomAux
			REPLACE TpoDoc  WITH [2    ]
			REPLACE FlgSitA WITH [D]   && Detallado
			REPLACE FlgEstA WITH [1]
			IF m.Modo=2
				SELE AUXI3
				SEEK AUXI2.FlgSitA+AUXI2.CodCli+AUXI2.TpoDoc+AUXI2.CodDoc+[2]+AUXI2.FlgSit
				IF !FOUND()
					APPEND BLANK
					REPLACE FlgSitA WITH "D",FlgSit WITH AUXI2.FlgSit,FlgEstA WITH [2]
					REPLACE TpoDoc  WITH AUXI2.TpoDoc,CodDoc WITH AUXI2.CodDoc
					REPLACE FchDoc  WITH m.FchDoc2,FchVto WITH m.FchDoc4
					REPLACE FlgEst  WITH AUXI2.FlgEst,CodCli WITH AUXI2.CodCli
					REPLACE NomCli  WITH UPPER(AUXI2.NomCli)
				ENDIF
				REPLACE ImpTot  WITH ImpTot + IIF(AUXI2.CodMon=1,AUXI2.ImpTot,0)
				REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI2.CodMon=1,AUXI2.SdoDoc,0)
				REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI2.CodMon=2,AUXI2.ImpTot,0)
				REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI2.CodMon=2,AUXI2.SdoDoc,0)
				REPLACE ImpNet  WITH ImpNet + 1
				SELE AUXI
			ENDIF
		ENDIF
		IF m.TipRep > 1
			SELE AUXI1
			IF AUXI.CodDoc#"LETR"
				SEEK "T"+AUXI.TpoDoc+AUXI.CodDoc
				IF !FOUND()
					APPEND BLANK
					REPLACE FlgSitA WITH "T",FlgSit WITH []
					REPLACE TpoDoc  WITH AUXI.TpoDoc,CodDoc WITH AUXI.CodDoc
					REPLACE FchDoc  WITH m.FchDoc2,FchVto WITH m.FchDoc4
					REPLACE FlgEst  WITH AUXI.FlgEst,CodCli WITH []
				ENDIF
				REPLACE ImpTot  WITH ImpTot + IIF(AUXI.CodMon=1,AUXI.ImpTot,0)
				REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI.CodMon=2,AUXI.ImpTot,0)
				IF TpoDoc = "1"    && CARGO
					REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)
					REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)
				ELSE
					REPLACE SdoDoc  WITH SdoDoc - IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)
					REPLACE SdoUsa  WITH SdoUsa - IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)
				ENDIF
			ELSE
				LsTpoDoc = AUXI.TpoDoc
				IF AUXI.FlgSit=[D]
					LsTpoDoc = [2    ]
				ENDIF
				SEEK "T"+LsTpoDoc+AUXI.CodDoc+AUXI.FlgSit
				IF !FOUND()
					APPEND BLANK
					REPLACE FlgSitA WITH "T",FlgSit WITH AUXI.FlgSit
					REPLACE TpoDoc  WITH LsTpoDoc,CodDoc WITH AUXI.CodDoc
					REPLACE FchDoc  WITH m.FchDoc2,FchVto WITH m.FchDoc4
					REPLACE FlgEst  WITH AUXI.FlgEst,CodCli WITH []
				ENDIF
				*!*	OJO El descuento se resta del total osea NETO DE DESCUENTO
				zi = IIF(FlgSit=[D],-1,1)
				*!* OJO
				REPLACE ImpTot  WITH ImpTot + IIF(AUXI.CodMon=1,AUXI.ImpTot,0)*zi
				REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)*zi
				REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI.CodMon=2,AUXI.ImpTot,0)*zi
				REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)*zi
				*!* Pero despues lo agregamos al total general *!*
				IF AUXI.FlgSit=[D]
					LsTpoDoc = [1    ]
					SEEK "T"+LsTpoDoc+AUXI.CodDoc+AUXI.FlgSit
					IF !FOUND()
						APPEND BLANK
						REPLACE FlgSitA WITH "T",FlgSit WITH AUXI.FlgSit
						REPLACE TpoDoc  WITH LsTpoDoc ,CodDoc WITH AUXI.CodDoc
						REPLACE FchDoc  WITH m.FchDoc2,FchVto WITH m.FchDoc4
						REPLACE FlgEst  WITH AUXI.FlgEst,CodCli WITH []
					ENDIF
					REPLACE ImpTot  WITH ImpTot + IIF(AUXI.CodMon=1,AUXI.ImpTot,0)
					REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)
					REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI.CodMon=2,AUXI.ImpTot,0)
					REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)
				ENDIF
			ENDIF
		ENDIF
		DO CASE
			CASE m.Modo = 2
				DO Tot_DxC
		ENDCASE
		SELE ccbrgdoc
		SKIP
	ENDDO
	SELE AUXI2
	USE
	SELE AUXI
	APPEND FROM &ArcTmp2.
	IF m.Modo = 2
		SELE AUXI3
		DELE ALL FOR ImpNet<=1
		PACK
		USE
		SELE AUXI
		APPEND FROM &ArcTmp3.
	ENDIF
	IF m.TipRep>1
		IF m.TipRep = 2
			SELE AUXI
			ZAP
		ENDIF
		SELE AUXI1
		USE
		SELE AUXI
		APPEND FROM &ArcTmp1.
	ENDIF
	SELE AUXI
	GOTO TOP
	IF EOF()
		??CHR(7)
		WAIT "No hay datos... presione barra espaciadora para continuar .." WINDOW
		RETURN
	ENDIF
	SET RELA TO GsClfCli+CodCli INTO cbdmauxi
ENDIF
??CHR(7)
??CHR(7)
WAIT "Fin de proceso listo para imprimir..." NOWAIT WINDOW
xWhile=[]
xFOR  =[]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
IF m.Modo=2
	sNomRep = "ccbr430c"
ELSE
	sNomRep = "ccbr4300"
ENDIF
DO f0print WITH "REPORTS"
RETURN
*****************
PROCEDURE Tot_DxC
*****************
IF CodDoc#[LETR]
	SELE AUXI3
	SEEK AUXI.FlgSitA+AUXI.CodCli+AUXI.TPODOC+AUXI.CODDOC+[2]
	IF !FOUND()
		APPEND BLANK
		REPLACE FlgSitA WITH "D",FlgSit WITH [],FlgEstA WITH [2]
		REPLACE TpoDoc  WITH AUXI.TpoDoc,CodDoc WITH AUXI.CodDoc
		REPLACE FchDoc  WITH m.FchDoc2,FchVto WITH m.FchDoc4
		REPLACE FlgEst  WITH AUXI.FlgEst,CodCli WITH AUXI.CodCli
		REPLACE NomCli  WITH UPPER(AUXI.NOMCLI)
	ENDIF
	REPLACE ImpTot  WITH ImpTot + IIF(AUXI.CodMon=1,AUXI.ImpTot,0)
	REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)
	REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI.CodMon=2,AUXI.ImpTot,0)
	REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)
	REPLACE ImpNet  WITH ImpNet + 1
ELSE
	SELE AUXI3
	SEEK AUXI.FlgSitA+AUXI.CodCli+AUXI.TpoDoc+AUXI.CodDoc+"2"
	IF !FOUND()
		APPEND BLANK
		REPLACE FlgSitA WITH "D",FlgSit WITH [],FlgEstA WITH [2]
		REPLACE TpoDoc  WITH AUXI.TpoDoc,CodDoc WITH AUXI.CodDoc
		REPLACE FchDoc  WITH m.FchDoc2,FchVto WITH m.FchDoc4
		REPLACE FlgEst  WITH AUXI.FlgEst,CodCli WITH AUXI.CodCli
		REPLACE NomCli  WITH UPPER(AUXI.NOMCLI)
	ENDIF
	REPLACE ImpTot  WITH ImpTot + IIF(AUXI.CodMon=1,AUXI.ImpTot,0)
	REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)
	REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI.CodMon=2,AUXI.ImpTot,0)
	REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)
	REPLACE ImpNet  WITH ImpNet + 1
ENDIF
******************
FUNCTION _coddocxx
******************
*!*	UltTecla = LAStKEY()
*!*	IF UltTecla = F8
*!*		SELECT ccbtbdoc
*!*		IF ! ccbbusca("TDOC")
*!*			SELECT ccbrgdoc
*!*			RETURN .T.
*!*		ENDIF
*!*		m.CodDoc = CodDoc
*!*		ulttecla = Enter
*!*		SELECT ccbrgdoc
*!*	ENDIF
*!*	IF UltTecla = Enter .or. ulttecla = escape_
*!*		RETURN .t.
*!*	ENDIF
*!*	IF EMPTY(m.coddoc)
*!*		RETURN .T.
*!*	ENDIF
*!*	IF !SEEK(m.coddoc,"ccbtbdoc")
*!*		WAIT "Documento no registrado" NOWAIT WINDOW
*!*		RETURN .F.
*!*	ENDIF
*!*	RETURN .T.

****************
FUNCTION _desest
****************
DO CASE
	CASE flgest = 'P'
		RETURN 'Pendiente'
	CASE flgest = 'A'
		RETURN 'Anulado'
	CASE flgest = 'C'
		RETURN 'Cancelado'
	CASE flgest = 'T'
		RETURN 'Tramite  '
	OTHER
		RETURN '         '
ENDCASE

****************
FUNCTION _desubi
****************
DO CASE
	CASE flgubc = 'C'
		RETURN 'En Cartera'
	CASE flgubc = 'B'
		RETURN 'En Banco  '
	OTHER
		RETURN '          '
ENDCASE

****************
FUNCTION _dessit
****************
DO CASE
	CASE flgsit = 'P'
		RETURN 'Protestada'
	CASE flgsit = 'A'
		RETURN 'Aceptada  '
	CASE flgsit = 'a'
		RETURN 'Por Acept.'
	CASE flgsit = 'D'
		RETURN 'Descontada'
	CASE flgsit = 'd'
		RETURN 'Por Descon'
	CASE flgsit = 'C'
		RETURN 'En Cobranz'
	CASE flgsit = 'c'
		RETURN 'Por Cobrar'
	CASE flgsit = 'R'
		RETURN 'Renovada  '
	CASE flgsit = 'G'
		RETURN 'Garantia  '
	CASE flgsit = 'X'
		RETURN 'Canje     '
	OTHER
		RETURN '          '
ENDCASE

****************
procedure _vlook
****************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
	select cbdmauxi
	IF ! ccbbusca("CLIE")
		SELECT ccbrgdoc
		return .T.
	ENDIF
	var1    = &campo1
	ulttecla= Enter
	SELECT ccbrgdoc
ENDIF
IF UltTecla = escape_ .OR. UltTecla = ENTER
	return .T.
ENDIF
IF EMPTY(VAR1)
	RETURN .T.
ENDIF
IF !SEEK(VAR1,"cbdmauxi")
	RETURN .F.
ENDIF
RETURN .T.
*****************
FUNCTION _wcodcli
*****************
PARAMETERS Cod1,Cod2
IF EMPTY(Cod2)
	Cod2=Cod1
ENDIF
RETURN .t.
