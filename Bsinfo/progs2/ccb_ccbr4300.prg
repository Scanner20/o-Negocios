CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25 
#include const.h
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
STORE '' TO ArcTmp,ArcTmp1,ArcTmp2,ArcTmp3

RESTORE FROM GoCfgVta.oentorno.tspathcia+'VTACONFG.MEM' ADDITIVE
m.PorRet  = IIF(VARTYPE(CFGADMRET)<>'N',0,CFGADMRET)
m.MinRet  = IIF(VARTYPE(CFGADMMINRET)<>'N',0,CFGADMMINRET)

private m.modo,m.coddoc,m.codcli1,m.codcli2,m.tpodoc,m.fchdoc1,m.fchdoc2,m.fchdoc3,m.fchdoc4
private m.tpodoc,m.flgest,m.flgsit,XsTpoDoc,m.nFlgEst

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

*DO fondo WITH 'Situación de documentos',Goentorno.user.login,GsNomCia,GsFecha

DO SITLista

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
IF USED('RMOV')
	USE IN RMOV
ENDIF

IF USED('VMOV')
	USE IN VMOV
ENDIF
IF USED('CTAS')
	USE IN CTAS
ENDIF
IF USED('ACCT')
	USE IN ACCT
ENDIF
IF USED('VPRO')
	USE IN VPRO
ENDIF
IF USED('TCMB')
	USE IN TCMB
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

PROCEDURE SITLista
*******************
**
LoDatAdm.abrirtabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CBDMAUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','CCBRGDOC','GDOC01','')
LODATADM.ABRIRTABLA('ABRIR','CCBTBDOC','CCBTBDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS05','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoDatAdm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')

**
**
*!*	@ 2,0 TO 22,79 PANEL
*!*	@ 2,25  SAY "SITUACION DE DOCUMENTOS"
** variables a usar **
SELECT ccbrgdoc
SET FILTER TO TpoVTa<>3

SET RELA TO GsClfCli+CodCli INTO cbdmauxi
SET RELA TO [04]+CodBco     INTO TABL ADDITIVE
SET RELA TO GsClfCli+CodCli INTO CLIE ADDITIVE
XsTpoDoc  = SPACE(LEN(TpoDoc))
m.modo    =1   && Normal
m.Cbotpodoc  = 1
m.coddoc  = SPACE(LEN(coddoc))
m.codcli1 = SPACE(LEN(codcli))
m.codcli2 = SPACE(LEN(codcli))
m.nflgest  = 1
m.flgUbc  = 1
m.flgSit  = 1
m.fchdoc1 = CTOD('  /  /  ')
m.fchdoc2 = date()
m.fchdoc3 = date()
m.fchdoc4 = date()
m.TipRep  = 1
m.NetoDescuento = .t.
LsDesEst = ''
LsDesDoc = ''
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
*!*	*********************************
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

DO FORM ccb_ccbr4300

RETURN 
******************
PROCEDURE PENLISTA
******************
** test de impresion **

SELECT Ccbrgdoc
DO CASE
   CASE m.nFlgEst = 1
      XFOR1 = ".T."
      XFOR1_P = ".T."
      
   CASE m.nFlgEst = 2
      XFOR1 = "FlgEst='P'"
      XFOR1_P = "INLIST(FlgEst,'P','E')"
   CASE m.nFlgEst = 3
      XFOR1 = "FlgEst='C'"
      XFOR1_P = "FlgEst='C'"
   CASE m.nFlgEst = 4
      XFOR1 = "FlgEst='A'"
      XFOR1_P = "FlgEst='A'"      
   CASE m.nFlgEst = 5
      XFOR1 = ".T."
      XFOR1_P = ".T."            
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
XFOR7 = '.T.'
IF m.NetoDescuento
	XFOR7 = 'FlgUbc+FlgSit <>"BD"'
ENDIF
XFOR = XFOR1+".AND."+XFOR2+".AND."+XFOR3+".AND."+XFOR4+".AND."+XFOR5+".AND."+XFOR6+".AND."+XFOR7
XFOR_P = XFOR1_P+".AND."+XFOR2+".AND."+XFOR3+".AND."+XFOR4
**
m.CodDoc=IIF(m.CodDoc='XXXX',SPACE(LEN(coddoc)),m.CodDoc)
XsTpodoc = IIF(m.CboTpodoc=1,'CARGO',IIF(m.CboTpoDoc=2,'ABONO','     '))
m.Titulo3 = IIF(empty(XsTpoDoc),"TODOS LOS DOCUMENTOS",UPPER([Documentos de ]+XsTpoDoc+[ ]+IIF(EMPTY(LsDesDoc),'',':'+LsDesDoc) ))
IF !empty(m.coddoc)
   =SEEK(m.coddoc,'ccbtbdoc')
   m.Titulo3 = m.Titulo3+[: solo ]+LOWER(ccbtbdoc.desdoc)
   XWHiLE = "tpodoc+coddoc=Xstpodoc+m.coddoc"
ELSE
   IF EMPTY(XsTpoDoc)
      XWHILE = ".T."
   ELSE
      XWHILE = "TpoDoc=XsTpodoc"
   ENDIF
ENDIF
m.ListarProformas = .F.
IF m.CodDoc='PROF' OR EMPTY(m.CodDoc)
	m.ListarProformas = .T.	
ENDIF
** buscamos registro de arranque **
SEEK TRIM(Xstpodoc)+TRIM(m.coddoc)
IF !FOUND() AND !m.ListarProformas
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
**
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
**
WAIT "Procesando Informaci¢n..." NOWAIT WINDOW
lPrimeraContado= .f.   		    
lPrimeraCobrar= .f.
DIMENSION vLiq_Cobr(10),vLiq_Cont(10)
DIMENSION vImporte(3)
IF m.modo<>0
   SELE AUXI
   DO CASE
      CASE m.Modo = 1
         INDEX on FlgSitA+TpoDoc+CodDoc+FlgSit+Nrodoc TAG AUXI01
         SET ORDER TO AUXI01
         SELE AUXI3
         INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
         SET ORDER TO AUXI01

      CASE m.Modo = 2
         INDEX on FlgSitA+Nomcli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
         SET ORDER TO AUXI01
         SELE AUXI3
         INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
         SET ORDER TO AUXI01
      CASE m.Modo = 3
         INDEX on FlgSitA+TpoDoc+trans(Imptot,'999,999,999.99')+CodDoc+FlgSit+NroDoc TAG AUXI01 DESCENDING
         SET ORDER TO AUXI01
         SELE AUXI3
         INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
         SET ORDER TO AUXI01

      CASE m.Modo = 4
         INDEX on FlgSitA+TpoDoc+dtoc(Fchvto,1)+CodDoc+FlgSit TAG AUXI01 DESCENDING
         SET ORDER TO AUXI01
         SELE AUXI3
         INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
         SET ORDER TO AUXI01

      CASE m.Modo = 5
         INDEX on FlgSitA+NomCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
         SET ORDER TO AUXI01
         SELE AUXI3
         INDEX on FlgSitA+CodCli+TpoDoc+CodDoc+FLgEstA+FlgSit+NroDoc TAG AUXI01
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
      IF CodDoc='LETR' AND Nrodoc='0009962'
*!*		      	SET STEP ON 
      ENDIF
      IF INLIST(NroDoc,'000000138')
*!*			      SET STEP ON 
      ENDIF

      IF !(&xFor)
         SKIP
         LOOP
      ENDIF
		IF SET("Development")='ON' 
*!*		      IF INLIST(CodDoc+NroDoc,'FACT0200004731','FACT0200004766','FACT0200005043','FACT0200005057','FACT0200005071',;
*!*		      						  'FACT0200002798','FACT0200002829','FACT0200004195','FACT0200004243')
*!*			      SET STEP ON 
*!*		      ENDIF

		ENDIF
      LnRecGDOC=RECNO()
      IF CodDoc='LETR' AND Nrodoc='0007700'
*!*	      	SET STEP ON 
      ENDIF
      IF GsSigCia='AROMAS' AND DTOS(ccbrGDOC.FchDoc)<='20060517' AND DTOS(ccbrGDOC.FchVto)<='20060517'
      		LfSdoDoc = SdoDoc
   		    LfSdoVtos = CCb_Sldo(CodCli,TpoDoc,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,xFor3,@vImporte)
   		    LfSdoVtos = vImporte(1)
   		    ** Caso 1 : El documento tiene su cancelacion total en el Vtos y en CCBRGDOC esta pendiente FlgEst='P'
   		    *** Caso 2 : El documento tiene su cancelacion total en el Vtos y en CCBRGDOC esta pendiente FlgEst='P'
   			STORE 0 TO vLiq_Cobr,vLiq_Cont
   		    =check_saldo_retencion()
   		    =Pendiente_Con_LiqCaja()
			SELECT ccbrgdoc
			GO LnRecGDOC
      		LfSdoDoc = SdoDoc
      		IF Imptot<>0
	      		IF ABS(round(LfSdoVtos/Imptot,2)*100)<=3 AND FlgEst='P' AND TpoDoc='CARGO' && AND INLIST(CodDoc,'FACT','BOLE')
	   		    	SELECT ccbrgdoc
	   		    	replace FlgEst WITH 'C'
					replace FchAct WITH DATE()+365   		    	
					replace SdoDoc WITH 0
	   		    ENDIF
			ENDIF
      		
		    IF !(&xFor)
	    		SKIP
		        LOOP
			ENDIF
      ELSE
   		    
   		    LfSdoVtos = CCb_Sldo(CodCli,TpoDoc,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,xFor3,@vImporte)
   		    LfSdoVtos = vImporte(1)
   		    ** Caso 1 : El documento tiene su cancelacion total en el Vtos y en CCBRGDOC esta pendiente FlgEst='P'
   		    *** Caso 2 : El documento tiene su cancelacion total en el Vtos y en CCBRGDOC esta pendiente FlgEst='P'
			STORE 0 TO vLiq_Cobr,vLiq_Cont
   		    =check_saldo_retencion()
   		    
   		    =Pendiente_Con_LiqCaja()
			SELECT ccbrgdoc
			GO LnRecGDOC
			IF INLIST(GsSigCia,'AROMAS')
				IF ABS(round(LfSdoVtos/Imptot,2)*100)<=3 AND FlgEst='P' AND TpoDoc='CARGO' && AND INLIST(CodDoc,'FACT','BOLE')
	   		    	SELECT ccbrgdoc
	   		    	replace FlgEst WITH 'C'
					replace FchAct WITH DATE()+365   		    	
					replace SdoDoc WITH 0
	   		    ENDIF
			ENDIF
			
			
		    IF !(&xFor)
	    		SKIP
		        LOOP
			ENDIF
			IF CODDOC='ANTI' AND NroDoc='000000125'
				SET STEP ON 
			ENDIF
			LfSdoDoc = CCb_Sldo(CodCli,TpoDoc,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,xFor3,@vImporte)
			LfSdoVtos = vImporte(1)
      ENDIF
       
      IF Flgest<>'A' AND LfSdoDoc<=.9 AND m.nFlgEst=5 
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
      *** Calculamos el saldo segun rango de fechas  ****
      IF Nrodoc='0010000182' AND coddoc='FACT'
*      		SET STEP ON 
      ENDIF
      REPLACE SdoDoc  WITH IIF(LfSdoDoc<=0.01,0,LfSdoDoc)
      ***
      SELE AUXI
      IF CodDoc+FlgSit=[LETR]+[D] AND !m.NetoDescuento
         SELE AUXI2
         APPEND BLANK
         GATHER MEMVAR
         =SEEK(GsClfCli+ccbrgdoc.codcli,"cbdmauxi")
         REPLACE NomCli  WITH cbdmauxi.NomAux
         REPLACE TpoDoc  WITH [2    ]
         REPLACE FlgSitA WITH [D]   && Detallado
         REPLACE FlgEstA WITH [1]
         IF !m.NetoDescuento
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
      IF auxi.flgsit='D'
*      	SET STEP ON 
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
            **  OJO  El descuento se resta del total osea NETO DE DESCUENTO
            zi = IIF(FlgSit=[D],-1,1)
            **  OJO 
            REPLACE ImpTot  WITH ImpTot + IIF(AUXI.CodMon=1,AUXI.ImpTot,0)*zi
            REPLACE SdoDoc  WITH SdoDoc + IIF(AUXI.CodMon=1,AUXI.SdoDoc,0)*zi
            REPLACE ImpUsa  WITH ImpUsa + IIF(AUXI.CodMon=2,AUXI.ImpTot,0)*zi
            REPLACE SdoUsa  WITH SdoUsa + IIF(AUXI.CodMon=2,AUXI.SdoDoc,0)*zi
            *** Pero despues lo agregamos al total general !!!!
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
         CASE !m.NetoDescuento
	              DO Tot_DxC
      ENDCASE
      SELE ccbrgdoc
      SKIP
   ENDDO
   SELE AUXI2
   USE
   SELE AUXI
   APPEND FROM &ArcTmp2.
   IF !m.NetoDescuento 
      SELE AUXI3
      DELE ALL FOR ImpNet<=1
      PACK
      USE
      SELE AUXI
      APPEND FROM &ArcTmp3.
   ENDIF
   *** Agregamos las proformas ***
   DO Cargar_Proformas
   ***-------------------------*** 
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
*****
??CHR(7)
??CHR(7)
WAIT "Fin de proceso listo para imprimir..." NOWAIT WINDOW
xWhile=[]
xFOR  =[]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
IF m.Modo=2
   sNomRep = "ccbr430c_"+GsSigCia
ELSE
   sNomRep = "ccbr4300_"+GsSigCia
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
****************
FUNCTION _coddoc
****************
UltTecla = LAStKEY()
IF UltTecla = F8
   select ccbtbdoc
   IF ! ccbbusca("TDOC")
      SELECT ccbrgdoc
      return .T.
   ENDIF
   m.CodDoc = CodDOC
   ulttecla = Enter
   SELECT ccbrgdoc
ENDIF
if ulttecla = Enter .or. ulttecla = escape_
   return .t.
endif
IF EMPTY(m.coddoc)
   RETURN .T.
ENDIF
IF !SEEK(m.coddoc,"ccbtbdoc")
   WAIT "Documento no registrado" NOWAIT WINDOW
   RETURN .F.
ENDIF
RETURN .T.
*********************************************

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
****************************
procedure _vlook
****************************
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
*******************
FUNCTION _wcodcli
******************
PARAMETERS Cod1,Cod2
IF EMPTY(Cod2)
	Cod2=Cod1
ENDIF
RETURN .t.
******************************
FUNCTION check_saldo_retencion
******************************
** VETT  14/02/2018 02:38 PM : Suspendemos hasta nuevo aviso 
RETURN && 
IF  INLIST(ccbrgdoc.coddoc+ccbrgdoc.nrodoc,'FACT0200006573','FACT0200005255')  	
*!*			SET STEP ON    	   	
ELSE 
*return	
ENDIF

IF !Valida_Agente_ret(CCBRGDOC.codCli,CCBRGDOC.ImpTot,CCBRGDOC.CodMon,CCbrgdoc.TpoCmb)
	RETURN
ENDIF
IF LfSdoVtos>0 AND FlgEst='P' AND TpoDoc='CARGO' AND INLIST(CodDoc,'FACT','BOLE') AND vImporte(2)=0 
	LfImpRet=Calcula_Monto_ret(CCBRGDOC.codCli,CCBRGDOC.ImpTot,CCBRGDOC.CodMon,CCbrgdoc.TpoCmb)		
**   	   	AND ( ROUND(SdoDoc/ImpTot,2)*100>=5 AND ROUND(SdoDoc/ImpTot,2)*100<=7 AND LfSdoVtos=SdoDoc ) 
   	   	*** Actualizamos retencion en cuentas por cobrar Ccbmvtos 
   	SELECT ccbtbdoc
   	SEEK 'RETC'
  	IF ! RLOCK()
		RETURN
	ENDIF
	LsNroRet = PADR(PADL(ALLTRIM(STR(ccbtbdoc->NroDoc)),9,'0'),LEN(ccbrGDOC->NroDoc))
    IF SEEK('ABONO'+'RETC'+LsNroRet,"ccbrgDOC")
    	  SELECT ccbrgdoc
		  GO LnRecGDOC
	      GsMsgErr = [ Registro Creado por Otro Usuario ]
	      DO lib_merr WITH 99
	      RETURN
	ENDIF
	IF VAL(LsNroRet)>=CCBTBDOC->NroDoc
	   REPLACE CCBTBDOC->NroDoc WITH VAL(LsNroRet)+1
	ENDIF
	UNLOCK
	FLUSH IN CCBTBDOC
	SELECT ccbrgdoc
	GO LnRecGDOC
	SELECT VTOS
	APPEND BLANK
	replace Tpodoc  WITH 'ABONO'
	replace CodDoc	WITH 'RETC' 		  
	replace NroDoc	WITH LsNroRet
	REPLACE FchDoc  WITH ccbrgdoc.FchDoc
	replace CodCli	WITH ccbrgdoc.CodCli
	replace CodMon  WITH ccbrgdoc.CodMon	
	replace Tpocmb  WITH ccbrgdoc.TpoCmb
	replace TpoRef  WITH ccbrgdoc.TpoDoc
	replace CodRef  WITH ccbrgdoc.CodDoc
	replace NroRef  WITH ccbrgdoc.NroDoc
	replace import  WITH LfImpRet
	replace FchIng	WITH DATE()
	**
	SELECT ccbrgdoc
	replace FchAct WITH DATE()+730   		    	
	replace SdoDoc WITH LfSdoVtos-LfImpRet
	IF FLGEST='A'
	ELSE
		IF SdoDoc<=0
			replace FlgEst WITH 'C'	
		ELSE
			replace FlgEst WITH 'P'	
		ENDIF
	ENDIF
	*** Actualizamos asiento contable por retencion ***
	IF !EMPTY(CCBRGDOC.NroAst) AND !EMPTY(CCBRGDOC.NroMes) AND !EMPTY(CCBRGDOC.CodOpe)
	
		*** Metodo Amaro Infante Ruiz 
		=AbrirCTB(CCBRGDOC.FchDoc)
		
	    XfImport = LfImpRet
	    XFTpoCmb = Ccbrgdoc.TpoCmb
	    XiCodMon = Ccbrgdoc.Codmon
		XsCodOpe = Ccbrgdoc.CodOpe
		XsNroAst=IIF(LEN(TRIM(CCBRGDOC.NroAst))=LEN(RMOV.NroAst),CCBRGDOC.NroAst,'01'+CCBRGDOC.NroAst)
		SELECT rmov
		APPEND BLANK 
		replace coddiv WITH '01'
		replace NroMes WITH  CCBRGDOC.NroMes
		replace CodOpe WITH  CCBRGDOC.CodOpe
		replace NroAst WITH  XsNroAst
		REPLACE FchAst  WITH ccbrgdoc.FchDoc
		replace Codaux WITH  CCBRGDOC.CodCli
		replace Clfaux WITH  GsClfCli
		REPLACE FchDoc  WITH ccbrgdoc.FchDoc
		replace NroDoc WITH  LsNroRet
*					replace codDoc WITH  ccbrgdoc.CodDoc 
*!*						replace TipDoc WITH  IIF(CodDoc='FACT','01','03')
		replace GloDoc WITH  'Retencion: '+LsNroRet+' '+ TRIM(ccbrGDOC.NomCli)
		Replace CodMon WITH CCbrgdoc.CodMon
		replace TpoCmb WITH Ccbrgdoc.TpoCmb
		replace CodCta WITH  '40113' && IIF(CodMon=2,'12102','12101')
		replace TpoMov WITH 'D'
	    IF XiCodMon = 1
			XfImpNac = XfImport   		
	    	IF XfTpoCmb>0
	        	XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	       	ELSE
	        	XfImpUsa = 0
	        ENDIF
	    ELSE
	        XfImpUsa = XfImport
	        XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
	    ENDIF
		replace Import WITH XfImpNac
		replace ImpUsa WITH XfImpUsa
		replace FchDig WITH DATE()
		replace HorDig WITH TIME()	
		IF ! XsCodOpe = "9"
		   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
		ELSE  && EXTRA CONTABLE
		   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
		ENDIF
		SELECT rmov
		APPEND BLANK 
		replace coddiv WITH '01'
		replace NroMes WITH  CCBRGDOC.NroMes
		replace CodOpe WITH  CCBRGDOC.CodOpe
		replace NroAst WITH  XsNroAst
		REPLACE FchAst  WITH ccbrgdoc.FchDoc
*!*						replace Codaux WITH  CCBRGDOC.CodCli
*!*						replace Clfaux WITH  GsClfCli

		REPLACE FchDoc  WITH ccbrgdoc.FchDoc
		replace NroDoc WITH  CCBRGDOC.NroDoc
		replace NroRef WITH  LsNroRet
		replace codDoc WITH  ccbrgdoc.CodDoc 
		replace TipDoc WITH  IIF(CodDoc='FACT','01','03')
		replace GloDoc WITH  'Retencion: '+LsNroRet+' '+ TRIM(ccbrGDOC.NomCli)
		Replace CodMon WITH CCbrgdoc.CodMon
		replace TpoCmb WITH Ccbrgdoc.TpoCmb
		replace CodCta WITH  IIF(CodMon=2,'12102','12101')
		replace TpoMov WITH 'H'
		replace Import WITH XfImpNac
		replace ImpUsa WITH XfImpUsa
		replace FchDig WITH DATE()
		replace HorDig WITH TIME()	

		IF ! XsCodOpe = "9"
		   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
		ELSE  && EXTRA CONTABLE
		   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
		ENDIF
	ENDIF
	FLUSH IN VTOS
	FLUSH IN RMOV
	FLUSH IN CCBRGDOC
	LfSdoVtos = CCBRGDOC.SdoDoc	 && El saldo actual despues de aplicar retencion
ENDIF
SELECT ccbrgdoc

******************************
FUNCTION Pendiente_Con_LiqCaja
******************************
** VETT  14/02/2018 02:38 PM : Suspendemos hasta nuevo aviso 
return
IF CodDoc+NroDoc='LETR0009962'
*!*		SET STEP ON 
ENDIF
IF LfSdoVtos>0 AND FlgEst='P' AND TpoDoc='CARGO' AND INLIST(CodDoc,'FACT','BOLE','LETR','N/D') AND ;
( ( FchVto<DATE() AND !INLIST(CodDoc,'LETR') ) OR ( FchVto+8<DATE() AND INLIST(CodDoc,'LETR') ) )
			
	IF !USED('L_D_Cont')
		SELECT 0
		USE Liqui_Ventas order coddoc ALIAS L_D_Cont	&& CODDOC+NRODOC+LIQUI
	ENDIF
	*
	IF !USED('L_C_Cont')
		SELECT 0
		USE Liqui_Cab order LIQUI_CAB ALIAS L_C_Cont	&& LIQUI
	ENDIF
	*
	IF !USED('L_C_Cobr')
		SELECT 0
		USE Liq_Cob order LIQ_COB ALIAS L_C_Cobr	&& LIQUI
	ENDIF
	*
	IF !USED('L_D_Cobr')
		SELECT 0
		USE Liq_Det order CodDoc ALIAS L_D_Cobr	&& LIQUI
	ENDIF
	*
	STORE 0 TO LfPorSdoGdoc,LfPorSdoVtos
	IF CCbrgdoc.Imptot<>0
		LfPorSdoGdoc = ROUND(ccbrgdoc.Sdodoc/CCbrgdoc.Imptot,2)*100
		LfPorSdoVtos = ROUND(LfSdoVtos/CCbrgdoc.Imptot,2)*100
	ENDIF
	** Buscamos en Ingreso por Liquidacion de ventas contado
	IF  ccbrgdoc.CodDoc+ccbrgdoc.Nrodoc='FACT0200005625'
*!*			SET STEP ON 
	ENDIF
	LcFile=ADDBS(SYS(2023))+'LogCcb.txt' 
	STORE 0 TO vLiq_Cobr,vLiq_Cont	
	=Chk_Liq_Cont()
	=Chk_Liq_Cobr()
	IF (vLiq_Cont(6)<>0  AND (vLiq_Cont(1)<>0 OR vLiq_Cont(2)<>0) AND vLiq_Cont(3)=0 )  OR ( LfPorSdoVTOS<=3 AND vLiq_Cont(3)=1 )
		IF (vLiq_Cont(6)<>0  AND (vLiq_Cont(1)<>0 OR vLiq_Cont(2)<>0) AND vLiq_Cont(3)=0 ) && AND .f.
			SELECT L_C_Cont
			LokTCMB = .F.
			IF L_C_CONT.TpoCmb=0
				SELECT TCMB
				SEEK(DTOS(L_C_CONT.FECHA))
				IF FOUND() AND OfiVta>0
					IF RLOCK('L_C_CONT')
						replace L_C_CONT.TpoCmb WITH TCMB.OfiVta
						UNLOCK IN 'L_C_CONT'
						LokTCMB = .t.
					ENDIF
				ENDIF
			ELSE
				LokTCMB = .T.
			ENDIF
			IF !LokTCMB
				IF RLOCK('L_C_CONT')
					replace L_C_CONT.TpoCmb WITH 1
					UNLOCK IN 'L_C_CONT'
					LokTCMB = .t.
				ENDIF
			ENDIF

			*** Generamos la Cancelación		
			SELECT VTOS
			APPEND BLANK
			replace Tpodoc  WITH 'CARGO'
			replace CodDoc	WITH 'I/C' 		  
			replace NroDoc	WITH SubStr(L_C_Cont.CodOpe,2)+L_C_Cont.Asiento
			REPLACE FchDoc  WITH L_C_Cont.Fecha
			replace CodCli	WITH ccbrgdoc.CodCli
			replace CodMon  WITH L_D_Cont.CodMon
			replace Tpocmb  WITH L_C_Cont.TpoCmb
			replace TpoRef  WITH ccbrgdoc.TpoDoc
			replace CodRef  WITH ccbrgdoc.CodDoc
			replace NroRef  WITH ccbrgdoc.NroDoc
			XfImport = vLiq_Cont(1) + ROUND(vLiq_Cont(2)*L_C_Cont.TpoCmb,2)
			IF !LOkTcmb
				XfImpUsa = 0	
			ELSE
				XfImpUsa = ROUND(vLiq_Cont(1)/L_C_Cont.TpoCmb,2) +	vLiq_Cont(2)
			ENDIF
			LfImpRet = IIF(L_D_Cont.CodMon = 1,XfImport,XfImpUSa)
			replace import  WITH LfImpRet
			replace FchIng	WITH DATE()
			**
			SELECT ccbrgdoc
			replace FchAct WITH DATE()+730   		    	
			replace SdoDoc WITH LfSdoVtos-LfImpRet
			IF FLGEST='A'
			ELSE
				IF SdoDoc<=0
					replace FlgEst WITH 'C'	
				ELSE
					replace FlgEst WITH 'P'	
				ENDIF
			ENDIF
		*** Genramos Asiento contable en base al generado en la liquidacion ***
			IF !EMPTY(L_C_Cont.Asiento) AND !EMPTY(L_C_Cont.Fecha) AND !EMPTY(L_C_Cont.CodOpe)
			    XfImport = LfImpRet
			    XfImpNac = XfImport  && Viene calculado de la liquidacion
			    XfImpUsa = XfImpUsa  && Viene calculado de la liquidacion
			    XFTpoCmb = L_C_Cont.TpoCmb
			    XiCodMon = L_D_Cont.CodMon
				XsCodOpe = L_C_Cont.CodOpe
				LsAsiento = IIF(LEN(TRIM(L_C_CONT.Asiento))=LEN(RMOV.NroAst),L_C_CONT.Asiento,'01'+L_C_CONT.Asiento)
				SELECT rmov
				APPEND BLANK 
				replace coddiv WITH '01'
				replace NroMes WITH  TRANSFORM(MONTH(L_C_Cont.Fecha),'@L 99')
				replace CodOpe WITH  L_C_Cont.CodOpe
				replace NroAst WITH  LsAsiento
				REPLACE FchAst  WITH L_C_Cont.Fecha
				replace Codaux WITH  CCBRGDOC.CodCli
				replace Clfaux WITH  GsClfCli
				REPLACE FchDoc  WITH ccbrgdoc.FchDoc
				replace NroDoc WITH  ccbrgdoc.NroDoc
				replace codDoc WITH  ccbrgdoc.CodDoc 
				replace TipDoc WITH  IIF(CodDoc='FACT','01','03')
				replace GloDoc WITH  'I/Caja Liq/Contado '+L_C_Cont.Liqui
				Replace CodMon WITH XiCodMon
				replace TpoCmb WITH XfTpoCmb
				replace CodCta WITH IIF(CodMon=2,'12102','12101')
				replace TpoMov WITH 'H'
				XcEliItm = CHR(43)
				replace EliItm WITH XcEliItm
				replace Import WITH XfImpNac
				replace ImpUsa WITH XfImpUsa
				replace FchDig WITH DATE()
				replace HorDig WITH TIME()	
				IF ! XsCodOpe = "9"
				   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ELSE  && EXTRA CONTABLE
				   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ENDIF
				** CUENTA DE CAJA ** 
				SELECT rmov
				APPEND BLANK 
				replace coddiv WITH '01'
				replace NroMes WITH  TRANSFORM(MONTH(L_C_Cont.Fecha),'@L 99')
				replace CodOpe WITH  L_C_Cont.CodOpe
				replace NroAst WITH  LsAsiento
				REPLACE FchAst  WITH L_C_Cont.Fecha
		*!*						replace Codaux WITH  CCBRGDOC.CodCli
		*!*						replace Clfaux WITH  GsClfCli

				REPLACE FchDoc  WITH L_C_Cont.Fecha
				replace NroDoc WITH  ''
				replace NroRef WITH  ''
				replace codDoc WITH  ''
				replace TipDoc WITH  ''
				replace GloDoc WITH  'I/Caja liq. contado:'+L_C_Cont.Liqui
				replace TpoCmb WITH XfTpoCmb
				Replace CodMon WITH IIF(EMPTY(vLiq_CONT(9)),XiCodMon,vLiq_CONT(9))
				replace CodCta WITH IIF(VARTYPE(vLiq_CONT(8))='C' AND !EMPTY(vLiq_CONT(8)),vLiq_CONT(8),IIF(XiCodMon=1,'10101','10102'))
				replace TpoMov WITH 'D'
				replace Import WITH XfImpNac
				replace ImpUsa WITH XfImpUsa
				replace FchDig WITH DATE()
				replace HorDig WITH TIME()	

				IF ! XsCodOpe = "9"
				   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ELSE  && EXTRA CONTABLE
				   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ENDIF
			ENDIF
			FLUSH IN VTOS
			FLUSH IN RMOV
			FLUSH IN CCBRGDOC
			LfSdoVtos = CCBRGDOC.SdoDoc	 && El saldo actual despues de aplicar retencion
		ENDIF
				
		

		IF !lPrimeraContado
			=STRTOFILE('***** INGRESOS POR LIQUIDACIONES QUE NO TIENEN CANCELACIÓN AL '+TTOC(DATETIME())+' *****  '+CRLF,LcFile,.T.)	
			=STRTOFILE('Liquidacion       Documento     Fecha     Vcto     Mon.  Importe     Saldo   Amort Cont.     Liq S/.   Liq US$     % GDOC  % VTOS    CTA.CJA'+CRLF,LcFile,.T.)	
			lPrimeraContado= .T.
		ENDIF
		
		=STRTOFILE('MELVA '+L_C_Cont.Liqui+' '+CCBRGDOC.CodDoc+CCBRGDOC.NroDoc+' '+DTOC(CCBRGDOC.FchDoc)+' '+DTOC(CCBRGDOC.FchVto)+' '+;
		STR(Ccbrgdoc.CodMon,1,0)+' '+TRANSFORM(CCBRGDOC.imptot,'999,999.99')+' '+TRANSFORM(CCBRGDOC.SdoDoc,'999,999.999')+;
		IIF(vLiq_Cont(3)=1,TRANSFORM(vLiq_Cont(7),'999,999.99'),'  No Tiene   ')+;
		' '+TRANSFORM(vLiq_Cont(1),'999,999.99') + ' '+TRANSFORM(vLiq_Cont(2),'999,999.99')+ ' ' + ;
		'%'+TRANSFORM(LfPorSdoGDOC,'999.99')+' '+ ;
		'%'+TRANSFORM(LfPorSdoVTOS,'999.99')+' '+ IIF(VARTYPE(vLiq_CONT(8))='C',vLiq_CONT(8),'NO TIENE')+CRLF,LcFile,.T.)	
	
	ENDIF
	
	**** LIQUIDACION DE COBRANZA 
	IF ( vLiq_COBR(6)<>0 AND (vLiq_COBR(1)<>0 OR vLiq_COBR(2)<>0) AND vLiq_COBR(3)=0 ) OR ( LfPorSdoVTOS<=3 AND vLiq_COBR(3)=1 )

		IF (vLiq_COBR(6)<>0  AND (vLiq_COBR(1)<>0 OR vLiq_COBR(2)<>0) AND vLiq_COBR(3)=0 ) && AND .f.
			SELECT L_C_COBR
			LokTCMB = .F.
			IF L_C_COBR.TpoCmb=0
				SELECT TCMB
				SEEK(DTOS(L_C_COBR.FECHA))
				IF FOUND() AND OfiVta>0
					IF RLOCK('L_C_COBR')
						replace L_C_COBR.TpoCmb WITH TCMB.OfiVta
						UNLOCK IN 'L_C_COBR'
						LokTCMB = .t.
					ENDIF
				ENDIF
			ELSE
				LokTCMB = .T.	
			ENDIF
			IF !LokTCMB
				IF RLOCK('L_C_COBR')
					replace L_C_COBR.TpoCmb WITH 1
					UNLOCK IN 'L_C_COBR'
					LokTCMB = .t.
				ENDIF
			ENDIF
			SELECT L_C_COBR
			*** Generamos la Cancelación		
			SELECT VTOS
			APPEND BLANK
			replace Tpodoc  WITH 'CARGO'
			replace CodDoc	WITH 'I/C' 		  
			replace NroDoc	WITH SubStr(L_C_COBR.CodOpe,2)+L_C_COBR.Asiento
			REPLACE FchDoc  WITH L_C_COBR.Fecha
			replace CodCli	WITH ccbrgdoc.CodCli
			replace CodMon  WITH L_D_COBR.CodMon
			replace Tpocmb  WITH L_C_COBR.TpoCmb
			replace TpoRef  WITH ccbrgdoc.TpoDoc
			replace CodRef  WITH ccbrgdoc.CodDoc
			replace NroRef  WITH ccbrgdoc.NroDoc
			
			
			XfImport = vLiq_COBR(1) + ROUND(vLiq_COBR(2)*L_C_COBR.TpoCmb,2)
			IF !LOkTcmb
				XfImpUsa = 0	
			ELSE
				XfImpUsa = ROUND(vLiq_COBR(1)/L_C_COBR.TpoCmb,2) +	vLiq_COBR(2)
			ENDIF
			LfImpRet = IIF(L_D_COBR.CodMon = 1,XfImport,XfImpUSa)
			replace import  WITH LfImpRet
			replace FchIng	WITH DATE()
			**
			SELECT ccbrgdoc
			replace FchAct WITH DATE()+730   		    	
			replace SdoDoc WITH LfSdoVtos-LfImpRet
			IF FLGEST='A'
			ELSE
				IF SdoDoc<=0
					replace FlgEst WITH 'C'	
				ELSE
					replace FlgEst WITH 'P'	
				ENDIF
			ENDIF
		*** Genramos Asiento contable en base al generado en la liquidacion ***
			IF !EMPTY(L_C_COBR.Asiento) AND !EMPTY(L_C_COBR.Fecha) AND !EMPTY(L_C_COBR.CodOpe)
			    XfImport = LfImpRet
			    XfImpNac = XfImport  && Viene calculado de la liquidacion
			    XfImpUsa = XfImpUsa  && Viene calculado de la liquidacion
			    XFTpoCmb = L_C_COBR.TpoCmb
			    XiCodMon = L_D_COBR.CodMon
				XsCodOpe = L_C_COBR.CodOpe
				LsAsiento = IIF(LEN(TRIM(L_C_COBR.Asiento))=LEN(RMOV.NroAst),L_C_COBR.Asiento,'01'+L_C_COBR.Asiento)
				SELECT rmov
				APPEND BLANK 
				replace coddiv WITH '01'
				replace NroMes WITH  TRANSFORM(MONTH(L_C_COBR.Fecha),'@L 99')
				replace CodOpe WITH  L_C_COBR.CodOpe
				replace NroAst WITH  LsAsiento
				REPLACE FchAst  WITH L_C_COBR.Fecha
				replace Codaux WITH  CCBRGDOC.CodCli
				replace Clfaux WITH  GsClfCli
				REPLACE FchDoc  WITH ccbrgdoc.FchDoc
				replace NroDoc WITH  ccbrgdoc.NroDoc
				replace codDoc WITH  ccbrgdoc.CodDoc 
				replace TipDoc WITH  IIF(CodDoc='FACT','01','03')
				replace GloDoc WITH  'I/Caja Liq/Cobranza:'+L_C_COBR.Liqui
				Replace CodMon WITH XiCodMon
				replace TpoCmb WITH XfTpoCmb
				replace CodCta WITH IIF(CodMon=2,'12102','12101')
				replace TpoMov WITH 'H'
				XcEliItm = CHR(43)
				replace EliItm WITH XcEliItm
				replace Import WITH XfImpNac
				replace ImpUsa WITH XfImpUsa
				replace FchDig WITH DATE()
				replace HorDig WITH TIME()	
				IF ! XsCodOpe = "9"
				   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ELSE  && EXTRA CONTABLE
				   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ENDIF
				** CUENTA DE CAJA ** 
				SELECT rmov
				APPEND BLANK 
				replace coddiv WITH '01'
				replace NroMes WITH  TRANSFORM(MONTH(L_C_COBR.Fecha),'@L 99')
				replace CodOpe WITH  L_C_COBR.CodOpe
				replace NroAst WITH  LsAsiento
				REPLACE FchAst  WITH L_C_COBR.Fecha
		*!*						replace Codaux WITH  CCBRGDOC.CodCli
		*!*						replace Clfaux WITH  GsClfCli

				REPLACE FchDoc  WITH L_C_COBR.Fecha
				replace NroDoc WITH  ''
				replace NroRef WITH  ''
				replace codDoc WITH  ''
				replace TipDoc WITH  ''
				replace GloDoc WITH  'I/Caja liq.Cobranza:'+L_C_COBR.Liqui
				replace TpoCmb WITH XfTpoCmb
				Replace CodMon WITH IIF(EMPTY(vLiq_COBR(9)),XiCodMon,vLiq_COBR(9))
				replace CodCta WITH IIF(VARTYPE(vLiq_COBR(8))='C' AND !EMPTY(vLiq_COBR(8)),vLiq_COBR(8),IIF(XiCodMon=1,'10101','10102'))
				replace TpoMov WITH 'D'
				replace Import WITH XfImpNac
				replace ImpUsa WITH XfImpUsa
				replace FchDig WITH DATE()
				replace HorDig WITH TIME()	

				IF ! XsCodOpe = "9"
				   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ELSE  && EXTRA CONTABLE
				   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa,CodDiv
				ENDIF
			ENDIF
			FLUSH IN VTOS
			FLUSH IN RMOV
			FLUSH IN CCBRGDOC
			LfSdoVtos = CCBRGDOC.SdoDoc	 && El saldo actual despues de aplicar retencion
		ENDIF


	
		IF !lPrimeraContado
			=STRTOFILE('****  INGRESOS POR LIQUIDACIONES DE QUE NO TIENEN CANCELACION AL '+TTOC(DATETIME())+' *****  '+CRLF,LcFile,.T.)	
			=STRTOFILE('Liquidacion       Documento     Fecha     Vcto     Mon.  Importe     Saldo   Amort Cont.     Liq S/.   Liq US$     % GDOC  % VTOS    CTA.CJA'+CRLF,LcFile,.T.)	
			lPrimeraContado= .T.
		ENDIF
		=STRTOFILE('ROCIO '+L_C_Cobr.Liqui+' '+CCBRGDOC.CodDoc+CCBRGDOC.NroDoc+' '+DTOC(CCBRGDOC.FchDoc)+' '+DTOC(CCBRGDOC.FchVto)+' '+;
		STR(Ccbrgdoc.CodMon,1,0)+' '+TRANSFORM(CCBRGDOC.imptot,'999,999.99')+' '+TRANSFORM(CCBRGDOC.SdoDoc,'999,999.999')+;
		IIF(vLiq_COBR(3)=1,TRANSFORM(vLiq_COBR(7),'999,999.99'),'  No Tiene   ') + ;
		' '+TRANSFORM(vLiq_COBR(1),'999,999.99') + ' '+TRANSFORM(vLiq_COBR(2),'999,999.99')  +' '+ ;
		'%'+TRANSFORM(LfPorSdoGDOC,'999.99')+' '+ ;
	 	'%'+TRANSFORM(LfPorSdoVTOS,'999.99') +' '+ IIF(VARTYPE(vLiq_COBR(8))='C',vLiq_COBR(8),'NO TIENE') +CRLF,LcFile,.T.)	
	 ENDIF	
	
	
	*
ENDIF
**********************
PROCEDURE CHK_LIQ_CONT
**********************
SELECT L_D_Cont
SEEK CCBRGDOC.CodDoc+CCBRGDOC.NroDoc 	
IF FOUND() && AND (ImpSol<>0 AND ImpDol<>0)
	*** Verificamos si tiene asiento de ingreso de caja
	SELECT L_C_Cont
	SEEK L_D_Cont.Liqui	
	IF FOUND() AND L_C_Cont.Liqui==L_D_Cont.Liqui AND L_C_Cont.Flag1 AND L_C_Cont.Flag2 AND !EMPTY(L_C_Cont.Asiento) AND !EMPTY(L_C_Cont.CodOpe)
		STORE 0 TO LfImpCBD2,LfImpCBD1,LfAmortCBD
		STORE .f. TO LlAmortiza
		LsAsiento = IIF(LEN(TRIM(L_C_CONT.Asiento))=LEN(RMOV.NroAst),L_C_CONT.Asiento,'01'+L_C_CONT.Asiento)

		*** Abrimos el RMOV y VMOV del año correspondiente : OJO
		=AbrirCTB(L_C_Cont.Fecha)
		
		SELECT RMOV
		SEEK TRANSFORM(MONTH(L_C_Cont.Fecha),'@L 99')+L_C_Cont.CodOpe+PADR(LsAsiento,LEN(RMOV.Nroast))
		SCAN WHILE NroMes+codOpe+NroAst=TRANSFORM(MONTH(L_C_Cont.Fecha),'@L 99')+L_C_Cont.CodOpe+PADR(LsAsiento,LEN(rmov.Nroast))
			IF CodDoc+NroDoc=PADR(Ccbrgdoc.CodDoc,LEN(rmov.CodDoc))+PADR(Ccbrgdoc.NroDoc,LEN(rmov.nrodoc))
				LfImpCBD1=Import
				LfImpCBD2=ImpUsa
				LlAmortiza=.t.
			ENDIF
			IF CodCta='10' AND TpoMov='D'
				vLiq_Cont(8) = CodCta
				vLiq_Cont(9) = CodMon 	
			ENDIF
		ENDSCAN  		
		LfAmortCBD=IIF(ccbrgdoc.CodMon=2,LfImpCBD2,LfImpCBD1)	
		LfImpSol = L_D_Cont.ImpSol
		LfImpDol = L_D_Cont.ImpDol
		SELECT L_C_Cont
		vLiq_cont(1)=LfImpSol
		vLiq_cont(2)=LfImpDol
		vLiq_cont(3)=IIF(LlAmortiza,1,0)
		vLiq_Cont(4)=LfPorSdoGDOC
		vLiq_Cont(5)=LfPorSdoVTOS
		vLiq_Cont(7)=IIF(ccbrgdoc.CodMon=2,LfImpCBD2,LfImpCBD1)	
	ENDIF
	vLiq_Cont(6)	= 1
ENDIF && Si no en Ingreso por liquidacion de cobranza

**********************
PROCEDURE CHK_LIQ_COBR
**********************
SELECT L_D_Cobr
SEEK CCBRGDOC.CodDoc+CCBRGDOC.NroDoc 	
IF FOUND()
	SELECT L_C_Cobr
	SEEK L_D_Cobr.Liqui	
	IF FOUND() AND L_C_Cobr.Liqui==L_D_Cobr.Liqui AND L_C_Cobr.Flag1 AND L_C_Cobr.Flag2 AND !EMPTY(L_C_Cobr.Asiento) AND !EMPTY(L_C_Cobr.CodOpe)
		STORE 0 TO LfImpCBD2,LfImpCBD1,LfAmortCBD
		STORE .f. TO LlAmortiza
		LsAsiento = IIF(LEN(TRIM(L_C_Cobr.Asiento))=LEN(RMOV.NroAst),L_C_Cobr.Asiento,'01'+L_C_Cobr.Asiento)
		
		*** Abrimos el RMOV y VMOV del año correspondiente : OJO
		=AbrirCTB(L_C_Cobr.Fecha)
		
		SELECT RMOV
		SEEK TRANSFORM(MONTH(L_C_Cobr.Fecha),'@L 99')+L_C_Cobr.CodOpe+PADR(LsAsiento,LEN(RMOV.NroAst))
		SCAN WHILE NroMes+codOpe+NroAst=TRANSFORM(MONTH(L_C_Cobr.Fecha),'@L 99')+L_C_Cobr.CodOpe+PADR(LsAsiento,LEN(rmov.Nroast))
			IF CodDoc+NroDoc=PADR(Ccbrgdoc.CodDoc,LEN(rmov.CodDoc))+PADR(Ccbrgdoc.NroDoc,LEN(rmov.nrodoc))
				LfImpCBD1=Import
				LfImpCBD2=ImpUsa
				LlAmortiza=.t.
			ENDIF
			IF CodCta='10' AND TpoMov='D'
				vLiq_COBR(8) = CodCta
				vLiq_COBR(9) = CodMon 	
			ENDIF

		ENDSCAN  		
		LfAmortCBD=IIF(ccbrgdoc.CodMon=2,LfImpCBD2,LfImpCBD1)	
		LfImpSol = L_D_Cobr.ImpSol
		LfImpDol = L_D_Cobr.ImpDol
		SELECT L_C_Cobr
		vLiq_COBR(1)=LfImpSol
		vLiq_COBR(2)=LfImpDol
		vLiq_COBR(3)=IIF(LlAmortiza,1,0)
		vLiq_COBR(4)=LfPorSdoGDOC
		vLiq_COBR(5)=LfPorSdoVTOS
		vLiq_COBR(7)=IIF(ccbrgdoc.CodMon=2,LfImpCBD2,LfImpCBD1)	
		*** Generamos la Cancelación		
		*** Genramos Asiento contable en base al generado en la liquidacion
	ENDIF
	vLiq_COBR(6)	= 1
ENDIF

*************************
FUNCTION Cargar_Proformas
*************************
IF !m.ListarProformas
	RETURN
ENDIF
LnAreaAct = SELECT()
SELE VPRO
SEEK ''
DO WHILE !EOF()
	IF !(&xFor_P)
	    SKIP
	    LOOP
	ENDIF
	LnRecGDOC=RECNO()
	IF coddoc='ANPR' AND INLIST(nrodoc,'00000050','00000051')
		SET STEP ON 
	ENDIF
	LfSdoDoc	= CCb_Sldo(CodCli,VPRO.TPODOC,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,xFor3,@vImporte)
	LfSdoVtos	= vImporte(1)
	** Caso 1 : El documento tiene su cancelacion total en el Vtos y en CCBRGDOC esta pendiente FlgEst='P'
	*** Caso 2 : El documento tiene su cancelacion total en el Vtos y en CCBRGDOC esta pendiente FlgEst='P'

	SELECT VPRO
	GO LnRecGDOC
*!*		IF ABS(round(LfSdoVtos/Imptot,2)*100)<=3 AND INLIST(FlgEst,'P','E') &&AND TpoDoc='CARGO' && AND INLIST(CodDoc,'FACT','BOLE')
*!*	    	SELECT VPRO
*!*	    	replace FlgEst WITH 'C'
*!*			replace FchAct WITH DATE()+365   		    	
*!*			replace SdoDoc WITH 0
*!*	    ENDIF
	IF NroDoc='00206806'
		SET STEP ON 
	ENDIF
    	IF !(&xFor_P)
   		SKIP
       	 LOOP
	ENDIF

*!*		LfSdoDoc = CCb_Sldo(CodCli,'CARGO',CodDoc,NroDoc,CodMon,TpoCmb,Imptot,xFor3,@vImporte)
*!*		LfSdoVtos = vImporte(1)
	IF Flgest<>'A' AND LfSdoDoc<=.9 AND m.nFlgEst=5 
	    SKIP
	    LOOP
	ENDIF
	IF VPRO.FlgEst='A'  AND m.nFlgEst=5 
	 	  LfSdoDoc = 0	
	    SKIP
	    LOOP
	ENDIF
	IF VPRO.FlgEst='A'  AND m.nFlgEst<>5 AND LfSdoDoc>.01
	 	  LfSdoDoc = 0	
	ENDIF
    
	SCATTER MEMVAR
	SELE AUXI
	APPEND BLANK
	m.TpoDoc = IIF(EMPTY(m.TpoDoc),'CARGO',m.TpoDoc)  && Si no viene en la proforma
	GATHER MEMVAR
	=SEEK(GsClfCli+VPRO.codcli,"cbdmauxi")
	REPLACE NomCli  WITH cbdmauxi.NomAux
	cTpoDoc = TpoDoc
	REPLACE TpoDoc  WITH IIF(TpoDoc=[CARGO],[1    ],[2    ])
	REPLACE FlgSitA WITH [D]   && Detallado
	REPLACE FlgEstA WITH [1]
	*** Calculamos el saldo segun rango de fechas  ****
	REPLACE SdoDoc  WITH IIF(LfSdoDoc<=0.01,0,LfSdoDoc)
	  ***
	SELE AUXI
	IF m.TipRep > 1
		SELE AUXI1
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
	ENDIF
	DO CASE
	   	CASE !m.NetoDescuento  && Separa las letras en descuento en otro grupo: FACT+BOLE+LETR + LETR (FlgSit=C,D) - LETR (FlgSit=D) = Total Por cobrar
	    				DO Tot_DxC
	ENDCASE
	SELE VPRO
	SKIP
ENDDO
SELECT (LnAreaAct)

*****************
FUNCTION AbrirCTB
*****************
PARAMETERS PdFchDoc

LsAnoCtb= LEFT(DTOS(PdFchDoc),4)
LsAnoAct = ''
IF USED('RMOV')
	LsPathAno=DBF('RMOV')
	LsPath=Justpath(LsPathAno)
	LsAnoAct = RIGHT(JustFname(LsPath),4)
ENDIF
IF LsAnoAct<>LsAnoCtb
	IF USED('RMOV')
		USE IN RMOV
	ENDIF
	IF USED('VMOV')
		USE IN VMOV
	ENDIF
	LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','','',GsCodCia,LsAnoCtb)
	LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','','',GsCodCia,LsAnoCtb)
ENDIF	


