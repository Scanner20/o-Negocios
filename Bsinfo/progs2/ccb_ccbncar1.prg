*****************************************************************************
* Programa     : ccbncar1.prg												*
* Sistema      : Cuentas por Cobrar											*
* Proposito    : Ingreso de Notas de Cargo con actualizacion contable		*	
* Autor		   : VETT														*
* Creacion     : 13/03/95													*
* Parametros   :															*
* Actualizacion: VETT 28/03/00 Adhesivos S.A.								*
*				  VETT 02/09/2003 Adaptacion para VFP 7						*
* Actualizacion: VETT 23/11/2003 CEVA										*
* Actualizacion: VETT 12/11/2021 9:26am - SFS Sunat TXT .NOT .DET .TRI 		*
*****************************************************************************
IF !verifyvar('GsRegirV','C')
	return
ENDIF
SYS(2700,0)
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
#include const.h 	

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoDatAdm.abrirtabla('ABRIR','VTATDOCM','DOCM','DOCM01','')
RELEASE LoDatAdm

RESTORE FROM GoCfgVta.oentorno.tspathcia+'vtaCONFG.MEM' ADDITIVE
** relaciones a usar **
SELECT RDOC
SET RELA TO 'NC'+Codigo INTO TABLA
SELECT GDOC
SET RELATION TO GsClfCli+CodCli INTO AUXI
** pantalla de datos **

*          1         2         3         4         5         6         7
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*1    Documento : 1234567890                                 Fecha : 99/99/9999
*2    Cliente   : 1234567                                  Emision : 99/99/9999
*3    Nombre    : 1234567890123456789012345678901234567890   RUC : 123456789012
*4    Direccion : 1234567890123456789012345678901234567890
*5    Detalle   : 1234567890123456789012345678901234567890
*6                1234567890123456789012345678901234567890
*7                1234567890123456789012345678901234567890
*8    Moneda    : S/.                              Tpo. Cambio : 9,999.9999
*9         ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*0         ³ Codigo       D e s c r i p c i o n                 Importe    ³
*1         ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*2         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*3         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*4         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*5         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*6         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*7         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*8         ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9         ³ Ult. Actualizac. : 99/99/99       TOTAL         999,999,999.99³
*0         ³ Situacion Actual : Pendiente      SALDO ACTUAL  999,999,999.99³
*1         ³                                                               ³
*2         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*          1         2         3         4         5         6         7
DO fondo WITH 'NOTAS DE DEBITO',Goentorno.user.login,GsNomCia,GsFecha
CLEAR
IF _windows OR _mac
	@  0,0 TO 24,100  PANEL
ELSE
	@  0,0 TO 22,79  PANEL
endif

 
Titulo = [ ** NOTAS DE DEBITO ** ]
@  0,(79-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "Documento :                                            Fecha :"
@  2,5  SAY "Cliente   :                                          Emision :"
@  3,5  SAY "Nombre    :                                            RUC :  "
@  4,5  SAY "Direccion :                                        Referencia:"
@  5,5  SAY "Detalle   :                                        Numero    :"
@  8,5  SAY "Moneda    : S/.                              Tpo. Cambio :    "
@  9,10 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 10,10 SAY "³ Codigo       D e s c r i p c i o n                 Importe    ³"
@ 11,10 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 12,10 SAY "³                                                               ³"
@ 13,10 SAY "³                                                               ³"
@ 14,10 SAY "³                                                               ³"
@ 15,10 SAY "³                                                               ³"
@ 16,10 SAY "³                                                               ³"
@ 17,10 SAY "³                                                               ³"
@ 18,10 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 19,10 SAY "³ Ult. Actualizac. :                TOTAL                       ³"
@ 20,10 SAY "³ Situacion Actual :                SALDO ACTUAL                ³"
@ 21,10 SAY "³                                                               ³"
@ 22,10 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 10,11 SAY " Codigo       D e s c r i p c i o n                 Importe    " COLOR SCHEME 7
@ 19,12 SAY "Ult. Actualizac. :" COLOR SCHEME 7
@ 20,12 SAY "Situacion Actual :" COLOR SCHEME 7
@ 19,46 SAY "TOTAL       " COLOR SCHEME 7
@ 20,46 SAY "SALDO ACTUAL" COLOR SCHEME 7
@ 21,12 SAY "ASIENTO:"     COLOR SCHEME 7

SAVE SCREEN TO wPanIni
** variables del sistema **
PRIVATE XsTpoDoc,XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XiCodMon,XfTpoCmb,SFSCodDoc 
PRIVATE XfImpNet,XfImpIgv,XfImpTot,XsGlosa1,XsGlosa2,XsGlosa3,XfSdoDoc,XfImpBto
PRIVATE XcFlgEst,XcFlgSit,XcFlgUbc,XdFchEmi,XsCodRef,XsNroRef,XsTpoRef,XsTipRef
PRIVATE XsNomCli,XsDirCli,XsRucCli
STORE [] TO XsTpoDoc,XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XdFchEmi,SFSCodDoc 
STORE [] TO XsGlosa1,XsGlosa2,XsGlosa3,XsCodRef,XsNroRef,XsTipRef
STORE [] TO XsNomCli,XsDirCli,XsRucCli
STORE 0 TO XfTpoCmb,XfImpNet,XfImpTot,XfSdoDoc,XfImpBto,XfImpIgv
XsTpoRef = [CARGO]
XsTpoDoc = [CARGO]
XsCodDoc = [N/D ]
XiCodMon = 1   && SOLES
XcFlgEst = [P]
XcFlgUbc = [C]
XcFlgSit = [ ]
XsCodRef = 'FACT'
XsNroRef = SPACE(LEN(GDOC.NroRef))
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
** Control de Correlativo **
PRIVATE m.NroDoc
m.NroDoc = []
** Logica Principal **
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99
xTpoDoc = XsTpoDoc
xCodDoc = XsCodDoc
UltTecla = 0

DO F1_edit WITH [xLlave],[xPoner],[xTomar],[xBorrar],[xListar],;
              [TpoDoc+CodDoc],xTpoDoc+XCodDoc,'CMAR'

CLEAR MACROS
CLEAR 
DO close_file IN CCB_Ccbasign
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
************************************************************************ EOP()
* Pedir LLave de Busqueda
******************************************************************************
PROCEDURE xLLave
RESTORE SCREEN FROM wPanIni
SELE GDOC
IF &sesrgv.
   XsNroDoc = GDOC->NroDoc
ELSE
   * buscamos correlativo
   IF !SEEK(XsCodDoc,"TDOC")
      WAIT "No existe correlativo" NOWAIT WINDOW
      UltTecla = escape_
      RETURN
   ENDIF
   IF !RLOCK("TDOC")
      GsMsgErr = [Control de Correlativos bloqueado, repetir la creaci¢n]
      DO lib_merr WITH 99
      UltTecla = escape_
      RETURN
   ENDIF
   XsNroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),10,'0'),LEN(GDOC->NroDoc))
   m.NroDoc = XsNroDoc
   UNLOCK IN "TDOC"
ENDIF
UltTecla = 0
i = 1
GsMsgKey = "[Esc] Salir   [F8] Ayuda   [Enter] Registrar"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,escape_,Enter)
   DO CASE
      CASE i = 1
         @ 1,17 GET XsNroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
            IF !ccbbusca("GDOC")
               LOOP
            ENDIF
            XsNroDoc = GDOC->NroDoc
            KEYBOARD '{ENTER}' 
         ENDIF
         @ 1,17 SAY XsNroDoc
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
RETURN
************************************************************************ FIN()
* Pintar Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

SELE GDOC
@  1,17 SAY NroDoc
@  1,68 SAY FchDoc picture '@RD dd/mm/aa'
@  2,17 SAY CodCli
@  2,68 SAY FchEmi picture '@RD dd/mm/aa'
@  3,17 SAY NomCli PICT "@S35"
@  3,66 SAY RucCli
@  4,17 SAY DirCli PICT "@S35"
@  5,17 SAY Glosa1 PICT "@S35"
@  6,17 SAY Glosa2 PICT "@S35"
@  7,17 SAY Glosa3 PICT "@S35"
@  8,17 SAY IIF(CodMon=2,'US$','S./')
@  4,68 SAY CodRef
@  5,68 SAY NroRef
@  8,64 SAY TpoCmb PICT "9,999.9999"
@ 19,31 SAY FchAct
m.DesEst = _FLGEST(FlgEst)
IF FlgEst = 'A'
	@ 20,31 SAY m.DesEst FONT "Foxfont",12 STYLE 'B'  color r+/n
ELSE
	@ 20,31 clear to 20,41
	@ 20,31 SAY m.DesEst
ENDIF	
@ 19,60 SAY ImpTot PICT "999,999,999.99"
@ 20,60 SAY SdoDoc PICT "999,999,999.99"
@ 21,21 SAY NroMes+'-'+CodOpe+'-'+NroAst
** datos del browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
DO xBrowse
**
SELE GDOC
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
*DO LIB_MTEC WITH 0

RETURN
************************************************************************ FIN()
* Pedir Datos
******************************************************************************
PROCEDURE xTomar

SELE GDOC
** VETT:Vuelve a generar el asiento cuando se intenta imprimir 2021/01/16 02:13:04 ** 
IF &sesrgv
	IF F1_Alert('Desea volver a generar asiento contable??','SI_O_NO') = 1
		** VETT: 2021/11/11 03:40:18 ** 
		DO xMover
		@  1,68 GET XdFchDoc PICT '@D dd/mm/aa'
		@  2,68 GET XdFchEmi PICT '@D dd/mm/aa'
		CLEAR GETS
		UltTecla = 0
		i = 1
		DO WHILE !INLIST(UltTecla,escape_)
		   DO lib_mtec WITH 7
		   DO CASE
		      CASE i = 1
		         @ 1,68 GET XdFchDoc PICT '@D dd/mm/aa'
		         READ
		         UltTecla = LASTKEY()
		      CASE i = 2
		         XdFchEmi = XdFchDoc
		         @ 2,68 GET XdFchEmi PICT '@D dd/mm/aa'
		         READ
		         IF !ctb_aper(XdFchEmi)
		            UltTecla = 0
		            LOOP
		         ENDIF
		         UltTecla = LASTKEY()
		      
		   ENDCASE
		   IF i = 2 .AND. UltTecla = Enter
		      EXIT
		   ENDIF
		   i = IIF(UltTecla=Arriba,i-1,i+1)
		   i = IIF(i<1,1,i)
		   i = IIF(i>2,2,i)
		ENDDO
		IF UltTecla # escape_
			iNumReg = RECNO('GDOC')
		   DO yGraba1
		ENDIF
		IF ctb_aper(GDOC.FchEmi) AND UltTecla # escape_
			DO xAct_ctb
			SELECT GDOC
			GO iNumReg
			DO Gen_SFS_TXT
			SELECT GDOC
			UNLOCK ALL
			return 
		ENDIF	
		** VETT: 2021/11/11 03:40:18 **
	ELSE
		SELECT GDOC
		RETURN			
	ENDIF
ELSE
	DO xInvar
ENDIF

@  1,68 GET XdFchDoc picture '@RD dd/mm/aa'
@  2,68 GET XdFchEmi picture '@RD dd/mm/aa'
@  2,17 GET XsCodCli
@  5,17 GET XsGlosa1 PICT "@!S35"
@  6,17 GET XsGlosa2 PICT "@!S35"
@  7,17 GET XsGlosa3 PICT "@!S35"
@  8,64 GET XfTpoCmb PICT "9,999.9999"
@  4,68 GET XsCodRef 
@  5,68 GET XsNroRef 
CLEAR GETS
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_)
	DO lib_mtec WITH 7
	DO CASE
		CASE i = 1
	         @ 1,68 GET XdFchDoc picture '@RD dd/mm/aa'
	         READ
	         UltTecla = LASTKEY()
		CASE i = 2
	         ** Rutina que apertura las base contables a usar y ademas **
	         ** verifica que el mes contables NO este cerrado **
	         IF !ctb_aper(XdFchDoc)
	            i = i - 1
	            UltTecla = 0
	            LOOP
	         ENDIF
	         XdFchEmi = XdFchDoc
	         @ 2,68 GET XdFchEmi picture '@RD dd/mm/aa'
	         READ
	         UltTecla = LASTKEY()
		CASE i = 3
	         SELE AUXI
	         @ 2,17 GET XsCodCli PICT "@!"
	         READ
	         UltTecla = LASTKEY()
	         IF UltTecla = escape_ .OR. UltTecla = Arriba
	            i = i - 1
	            LOOP
	         ENDIF
	         IF UltTecla = F8 .OR. EMPTY(XsCodCli)
	            IF !ccbbusca("CLIE")
	               SET ORDER TO AUXI01
	               LOOP
	            ENDIF
	            XsCodCli = AUXI->CodAux
	            SET ORDER TO AUXI01
	         ENDIF
	         @ 2,17 SAY XsCodCli
	         IF XsCodCli=[9999]  && Clientes Varios
	            * no pasa nada *
	         ELSE
	            SEEK GsClfCli+XsCodCli
	            IF !FOUND()
	               GsMsgErr = [ Cliente no Existe ]
	               DO lib_merr WITH 99
	               LOOP
	            ENDIF
	            XsNomCli = AUXI->NomAux
	            XsDirCli = AUXI->DirAux
	            XsRucCli = AUXI->RucAux
	            @  3,66 SAY XsRucCli
	            @  3,17 SAY XsNomCli PICT "@S35"
	            @  4,17 SAY XsDirCli PICT "@S35"
	         ENDIF
		CASE i = 4 .AND. XsCodCli=[9999]
	         @  3,66 GET XsRucCli PICT "@!"
	         @  3,17 GET XsNomCli PICT "@!S35"
	         @  4,17 GET XsDirCli PICT "@!S35"
	         READ
	         UltTecla = LASTKEY()
		CASE i = 5
	         @  5,17 GET XsGlosa1 PICT "@!S35"
	         READ
	         UltTecla = LASTKEY()
		CASE i = 6
	         @  6,17 GET XsGlosa2 PICT "@!S35"
	         READ
	         UltTecla = LASTKEY()
		CASE i = 7
	         @  7,17 GET XsGlosa3 PICT "@!S35"
	         READ
	         UltTecla = LASTKEY()
		CASE i = 8
	         DO LIB_MTEC WITH 16
	         VecOpc(1)="S/."
	         VecOpc(2)="US$"
	         XiCodMon= Elige(XiCodMon,8,17,2)
		CASE i = 9
	         SELE TDOC
	         SET FILTER TO TpoDoc = XsTpoDoc
	         @ 4,68 GET XsCodRef PICT "@!"
	         READ
	         UltTecla = LASTKEY()
	         IF INLIST(UltTecla,escape_,Arriba)
	            i = i - 1
	            SET FILTER TO
	            LOOP
	         ENDIF
	         DO CASE
	            CASE UltTecla = F8
	               IF ! ccbbusca("TDOC")
	                  SET FILTER TO
	                  LOOP
	               ENDIF
	               XsCodRef = CodDoc
	            CASE !TRIM(XsCodRef)==[]
	               SEEK XsCodRef
	               IF ! FOUND()
	                  WAIT "C¢digo de Documento no registrado" NOWAIT WINDOW
	                  LOOP
	               ENDIF
	         ENDCASE
	         SET FILTER TO
	         @ 04,68 SAY XsCodRef
		CASE i = 10 .AND. !TRIM(XsCodRef)==[]
	    	**@ 05,68 GET XsNroRef
	    	** OJO >> Se puede superar la asignacion **
			SELE GDOC
			SET ORDER TO GDOC04
			@ 05,68 GET XsNroRef PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF INLIST(UltTecla,escape_,Arriba)
			    SET ORDER TO GDOC01
			    i = i - 1
			    LOOP
			ENDIF
			IF UltTecla = F8 .OR. EMPTY(XsNroRef)
			    IF ! ccbbusca("ASIG")
			       SET ORDER TO GDOC01
			       LOOP
			    ENDIF
			    XsNroRef = NroDoc
			ENDIF
			@ 05,68 SAY XsNroRef
			SET ORDER TO GDOC01
			SEEK XsTpoRef+XsCodRef+XsNroRef
			IF !FOUND()
			    DO lib_merr WITH 6
			    LOOP
			ENDIF
			IF CodCli # XsCodCli
			    GsMsgErr = [El documento no es del Cliente]
			    DO lib_merr WITH 99
			    LOOP
			ENDIF
			IF FlgEst = [C]
			    GsMsgErr = [ Documento Cancelado ]
			    DO lib_merr WITH 99
			    LOOP
			ENDIF
			IF FlgEst = [A]
			    GsMsgErr = [ Documento Anulado ]
			    DO lib_merr WITH 99
			    LOOP
			ENDIF
		 * variables de calculo *
	        PRIVATE m.SdoDoc,m.Import,m.SdoAct
	        m.SdoDoc = GDOC->SdoDoc
	        m.Import = XfImpTot
			SELECT  GDOC
			SET ORDER TO GDOC01
		CASE i = 11
	        SELE TCMB
	        SEEK DTOS(XdFchDoc)
	        =SEEK(XsCodOpe,"OPER")
	        XfTpoCmb = IIF(OPER.TpoCmb=1,OfiCmp,OfiVta)
	        @  8,64 GET XfTpoCmb PICT "9,999.9999" RANGE 0,
	        READ
	        UltTecla = LASTKEY()
	ENDCASE
	IF i = 11 .AND. UltTecla = Enter
    	EXIT
	ENDIF
	i = IIF(UltTecla=Arriba,i-1,i+1)
	i = IIF(i<1,1,i)
	i = IIF(i>11,11,i)
ENDDO
IF UltTecla # escape_
   DO xGraba
   DO xListar
ELSE
   DO ctb_cier
ENDIF
SELE GDOC
UNLOCK ALL

RETURN
************************************************************************ FIN()
* Inicializa variables
******************************************************************************
PROCEDURE xInvar

SELE GDOC
XdFchDoc = DATE()
XdFchEmi = DATE()
XsCodCli = PADR([99999],LEN(GDOC->CodCli))
XsNomCli = SPACE(LEN(GDOC->NomCli))
XsDirCli = SPACE(LEN(GDOC->DirCli))
XsRucCli = SPACE(LEN(GDOC->RucCli))
XsGlosa1 = SPACE(LEN(GDOC->Glosa1))
XsGlosa2 = SPACE(LEN(GDOC->Glosa2))
XsGlosa3 = SPACE(LEN(GDOC->Glosa3))
XcFlgEst = [P]
XcFlgUbc = [C]
XcFlgSit = [ ]
STORE 0 TO XfTpoCmb,XfImpNet,XfImpTot,XfSdoDoc,XfImpBto
XsTpoDoc = [CARGO]
XsCodDoc = [N/D ]
XiCodMon = 1   && SOLES
** VETT: 2021/11/11 02:36:03 **
XsTpoRef = [CARGO]
XsCodRef = SPACE(LEN(GDOC->CodRef))
XsNroRef = SPACE(LEN(GDOC->NroRef))
** VETT: 2021/11/11 02:36:03 **
* Variables Contables *
_MES     = 0
XsNroMes = SPACE(LEN(GDOC.NroMes))
XsNroAst = SPACE(LEN(GDOC.NroAst))
XsCodOpe = GsRegirV && [002]  && << OJO <<

RETURN
************************************************************************ FIN()
* Carga variables
******************************************************************************
PROCEDURE xMover

XsNroDoc = GDOC->NroDoc
XdFchDoc = GDOC->FchDoc
XdFchEmi = GDOC->FchEmi
XsCodCli = GDOC->CodCli
XsNomCli = GDOC->NomCli
XsDirCli = GDOC->DirCli
XsRucCli = GDOC->RucCli
XsGlosa1 = GDOC->Glosa1
XsGlosa2 = GDOC->Glosa2
XsGlosa3 = GDOC->Glosa3
XcFlgEst = GDOC->FlgEst
XcFlgUbc = GDOC->FlgUbc
XcFlgSit = GDOC->FlgSit
XfTpoCmb = GDOC->TpoCmb
XfImpNet = GDOC->ImpNet
XfImpTot = GDOC->ImpTot
XfSdoDoc = GDOC->SdoDoc
XfImpBto = GDOC->ImpBto
XfImpIgv = GDOC->ImpIgv
XiCodMon = GDOC->CodMon
** VETT: 2021/11/11 02:38:03 ** 
XsCodRef = GDOC->CodRef
XsNroRef = GDOC->NroRef
** VETT: 2021/11/11 02:38:03 ** 
* Variables contables
XsNroMes = GDOC.NroMes
XsNroAst = GDOC.NroAst
XsCodOpe = GDOC.CodOpe
_MES     = VAL(XsNroMes)

RETURN
***************
PROCEDURE yGraba1
***************
** VETT:Grabamos fecha documento y emisión para regrabar asiento 2021/10/11 14:36:03 ** 
SELECT GDOC
=RLOCK()
REPLACE FchDoc WITH XdFchDoc
REPLACE FchEmi WITH XdFchEmi

UNLOCK
RETURN 
*******************
FUNCTION Gen_SFS_TXT
*******************
IF !EMPTY(XsCodRef) AND !EMPTY(XsNroRef)	&& XcFlgEst="C"

	SFSNroDoc = LEFT(XsCodRef,1)+LEFT(XsNroDoc,3)+"-"+RIGHT(REPLICATE('0',8)+ALLTRIM(SUBSTR(XsNroDoc,4)),8)
	SFSNroRef =	LEFT(XsCodRef,1)+LEFT(XsNroRef,3)+"-"+RIGHT(REPLICATE('0',8)+ALLTRIM(SUBSTR(XsNroRef,4)),8) 
	do ccb_copynotas_see-sfs with  SFSCodDoc,SFSNroDoc,SFSNroRef
							** "07","F002-00000110" ,"F001-00006199"
ENDIF
RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

** SOLO SE PUEDE CREAR EL DOCUMENTO, NO SE PUEDE MODIFICAR **
** control del correlativo **
SELE GDOC
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
STORE RECNO() TO iNumReg
** aperturamos nuevo cliente **
SELE SLDO
SEEK XsCodCli
IF !FOUND()
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE CodCli WITH XsCodCli
ELSE
   IF !RLOCK()
      RETURN
   ENDIF
ENDIF
** Control de Correlativos **
SELE TDOC
SEEK XsCodDoc
IF ! RLOCK()
   RETURN
ENDIF
IF m.NroDoc # XsNroDoc
   IF SEEK(XsTpoDoc+XsCodDoc+XsNroDoc,"GDOC")
      GsMsgErr = [ Registro Creado por Otro Usuario ]
      DO lib_merr WITH 99
      RETURN
   ENDIF
ELSE
   XsNroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),10,'0'),LEN(GDOC->NroDoc))
ENDIF
IF VAL(XsNroDoc)>=TDOC->NroDoc
   REPLACE TDOC->NroDoc WITH VAL(XsNroDoc)+1
ENDIF
UNLOCK
@  1,17 SAY XsNroDoc
*
SELE GDOC
GO iNumReg
REPLACE TpoDoc WITH XsTpoDoc
REPLACE CodDoc WITH XsCodDoc
REPLACE NroDoc WITH XsNroDoc
REPLACE FchDoc WITH XdFchDoc
REPLACE FchEmi WITH XdFchEmi
REPLACE CodCli WITH XsCodCli
REPLACE NomCli WITH XsNomCli
REPLACE DirCli WITH XsDirCli
REPLACE RucCli WITH XsRucCli
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE Glosa1 WITH XsGlosa1
REPLACE Glosa2 WITH XsGlosa2
REPLACE Glosa3 WITH XsGlosa3
REPLACE TpoRef WITH XsTpoRef
REPLACE CodREf WITH XsCOdRef
REPLACE NroREf WITH XsNroRef
IF cvctrl=[C]
	IF VerifyVar('UserCrea','','CAMPO',"GDOC")
		REPLACE UserCrea WITH GoEntorno.User.Login IN GDOC
	ENDIF
	IF VerifyVar('FchCrea','','CAMPO',"GDOC")
		REPLACE FchCrea WITH DATETIME() IN GDOC
	ENDIF
ELSE

	IF VerifyVar('UserModi','','CAMPO',"GDOC")
		REPLACE UserModi WITH GoEntorno.User.Login IN GDOC
	ENDIF
	IF VerifyVar('FchModi','','CAMPO',"GDOC")
		REPLACE FchModi WITH DATETIME() IN GDOC
	ENDIF
ENDIF

** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
** recalculamos el importe total **
SELE RDOC
STORE 0 TO XfImpTot
SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc=GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
   XfImpTot = XfImpTot + Import
ENDSCAN
DO LIB_MTEC WITH 14
DO xBrowse
**********************
SELE SLDO
IF XiCodMon = 1
   REPLACE CgoNAC WITH CgoNAC + XfImpTot
ELSE
   REPLACE CgoUSA WITH CgoUSA + XfImpTot
ENDIF
UNLOCK
*
SELE GDOC
REPLACE ImpNet WITH XfImpTot
REPLACE ImpTot WITH XfImpTot
REPLACE ImpIgv WITH XfImpIgv           && MAAV IGV ACTUALIZADO
REPLACE ImpBto WITH XfImpTot-XfImpIgv  && MAAV IMPBTO ACTUALIZADO
REPLACE FchVto WITH XdFchDoc
REPLACE SdoDoc WITH XfImpTot
REPLACE FlgEst WITH XcFlgEst
REPLACE FlgUbc WITH XcFlgUbc
REPLACE FlgSit WITH XcFlgSit
IF XfImpTot > 0   && << OJO << Caso error u omisi¢n (burrada)
	DO xACT_CTB
	** VETT:generamos archivo TXT para envio a Sunat 2021/11/11 03:38:09 **  
	SELECT GDOC
	GO iNumReg
	DO Gen_SFS_TXT
	SELECT GDOC
	GO iNumReg
	** VETT:FIN 2021/11/11 03:38:09 ** 
ENDIF

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE GDOC
IF FlgEst = [A] .AND. RLOCK()
   DELETE
   UNLOCK
   SKIP
   RETURN
ENDIF
* * * *
IF FlgEst # 'P'
   GsMsgErr = [ Acceso Denegado ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF ImpTot # SdoDoc
   GsMsgErr = [ Tiene Aplicaciones Realizadas ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF !RLOCK()
   RETURN
ENDIF
* bloqueamos clientes *
SELE SLDO
SEEK GDOC->CodCli
IF !RLOCK()
   UNLOCK ALL
   RETURN
ENDIF
* VEAMOS SI SE PUEDE ANULAR LA CONTABILIDAD *
IF GDOC.FlgCtb
   IF !ctb_aper(GDOC.FchDoc)
      SELE GDOC
      UNLOCK ALL
      RETURN
   ENDIF
ENDIF
* borramos detalles *
OK = .T.
SELE RDOC
SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
    IF !REC_LOCK(5)
    	OK = .F.
    	EXIT
	ENDIF
    DELETE
    UNLOCK
ENDSCAN
IF OK
    * actualizamos clientes *
    SELE SLDO
    IF GDOC->CodMon = 1
    	REPLACE CgoNAC WITH CgoNAC - GDOC->ImpTot
    ELSE
    	REPLACE CgoUSA WITH CgoUSA - GDOC->ImpTot
    ENDIF
    UNLOCK
    *
    IF GDOC.FlgCtb
    	DO xANUL_CTB
    ENDIF
    *
    SELE GDOC
    REPLACE FlgEst WITH [A]
    REPLACE FchAct WITH DATE()
	REPLACE SdoDoc WITH 0
	IF VerifyVar('UserElim','','CAMPO',"GDOC")
		REPLACE UserElim WITH GoEntorno.User.Login IN GDOC
	ENDIF
	IF VerifyVar('FchElim','','CAMPO',"GDOC")
		REPLACE FchElim WITH DATETIME() IN GDOC
	ENDIF
 
 
   SKIP
ENDIF
* por siaca *
DO ctb_cier
* * * * * * *
SELE GDOC
UNLOCK ALL

RETURN
************************************************************************ FIN()
* Browse
******************************************************************************
PROCEDURE xBrowse

PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = []
InsLin   = []
EscLin   = []
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbGrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = [TpoDoc+CodDoc+NroDoc]
VClave   = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
HTitle   = 1
Yo       = 11
Xo       = 10
Largo    = 8
Ancho    = 65
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = [Codigo+'  '+PADR(GLOSA,40)+' '+TRANS(Import,'999,999,999.99')]
Static   = .F.
VSombra  = .F.
SELECT RDOC
*** Variable a Conocer ****
PRIVATE XsCodigo,XfImport,XSGLOSA
STORE [] TO XsCodigo,XfImport,XSGLOSA
**
DO DBrowse
SELECT GDOC
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit

IF ! Crear
   IF !RLOCK()
      RETURN
   ENDIF
   XsCodigo = RDOC->Codigo
   XfImport = RDOC->Import
   XsGlosa  = RDOC.Glosa
ELSE
   XsCodigo = SPACE(LEN(RDOC->Codigo))
   XfImport = 0.00
   XsGlosa  = SPACE(LEN(RDOC.Glosa  ))
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,escape_,CtrlW,F10)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         SELE TABLA
         @ LinAct,12 GET XsCodigo PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodigo)
            SEEK 'NC'
            IF ! ccbbusca("0005")
               LOOP
            ENDIF
            XsCodigo = TABLA->Codigo
         ENDIF
         @ LinAct,12 SAY XsCodigo
         SEEK 'NC'+XsCodigo
         IF ! FOUND()
            GsMsgErr = "Concepto no Registrado"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ LinAct,19 SAY LEFT(TABLA->Nombre,40)
         XsGlosa=LEFT(TABLA->Nombre,40) 
         IF XsCodigo = "IGV"
            XfImpIgv = ROUND(XfImpTot*CfgADMIgv/100,2)
            XfImport = ROUND(XfImpTot*CfgADMIgv/100,2)
         ENDIF
     CASE i = 2
         @ LinAct,19 GET XsGlosa PICT "@S40"
         READ
         UltTecla = LastKey()
         IF UltTecla = escape_
            LOOP
         ENDIF
      CASE i = 3
         @ LinAct,60 GET XfImport PICT "999,999,999.99" RANGE 0,
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3, 3, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT RDOC
IF UltTecla = escape_
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE MOVbgrab

IF Crear
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   XfImpTot = XfImpTot - RDOC->Import
ENDIF
REPLACE Codigo WITH XsCodigo
REPLACE Import WITH XfImport
REPLACE Glosa  WITH XsGlosa
UNLOCK
XfImpTot = XfImpTot + XfImport
@ 19,60 SAY XfImpTot PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE MOVbborr

IF !RLOCK()
   RETURN
ENDIF
XfImpTot = XfImpTot - RDOC->Import
DELETE
UNLOCK
@ 19,60 SAY XfImpTot PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
FUNCTION _flgest
****************
PARAMETER cFlgEst
DO CASE
   CASE cFlgEst = "P"
      RETURN "Pendiente"
   CASE cFlgEst = "A"
      RETURN "Anulado  "
   CASE cFlgEst = "C"
      RETURN "Cancelado"
   CASE cFlgEst = "T"
      RETURN "Transito "
ENDCASE
RETURN "         "
************************************************************************ FIN *
* Objeto : Impresion en Formato Continuo
************************************************************************ FIN *
PROCEDURE xListar
SAVE SCREEN TO xListarScr
* posicionamos punteros *
=SEEK(GsClfCli+GDOC->CodCli,"AUXI")
=SEEK(GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc,"RDOC")
XFOR   = ".T."
XWHILE = "TpoDoc+CodDoc+NroDoc=GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc"
SELE RDOC
Largo  = 45       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
sNomRep = "ccbncarg"
IF .f.
	MODIFY REPORT (sNomrep)
ENDIF

DO f0print WITH "REPORTS"

IF ctb_aper(GDOC.FchDoc)
	STORE 0 TO nImpNac,nImpUSa
	XsNroMes = GDOC.NroMes
	XsCodOpe = GDOC.CodOpe
	XsNroAst = GDOC.NroAst
	DO Imprvouc IN Cbd_DiarioGeneral
	DO ctb_cier
	SELECT GDOC
ENDIF

RESTORE SCREEN FROM xListarScr
RETURN
************************************************************************ FIN *
*************** RUTINAS DE ACTUALIZACION DE CONTABILIDAD *********************
******************************************************************************
PROCEDURE xACT_CTB
** VETT:INI Guardamos el AÑO y MES actual 2021/11/11 04:31:31 **
cur_ANO = _ANO
cur_MES = _MES
** VETT:FIN 2021/11/11 04:31:31 **  
nErrCode = S_OK
PRIVATE DirCtb,UltTecla && _MES,_ANO,
PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef,XsTipRef,XdFchDtr,XsNroDtr
PRIVATE XfImport,XdFchDoc,XdFchVto
PRIVATE XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,TsCodDiv1  &&XsCodOpe,XsNroMes,XsNroAst,
PRIVATE XiNroItm,XsCodDiv,XsCtaPre,XcAfecto,XsCodCco,GlInterface,XsCodDoc,XsNroDoc 
PRIVATE XsNroRef,XsCodFin,XdFchdoc,XdFchVto,XsIniAux,XdFchPed,NumCta,XsNivAdi
PRIVATE XcTipoC,XsTipDoc,XsAn1Cta,XsCc1Cta,XsChkCta, nImpUsa, nImpNac,vCodCta
*!*	PRIVATE RegVal ,NCLAVE,VCLAVE
*!*	RegVal   = "&NClave = VClave"	
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = 'A'
** Valores variables inicializados como STRING
dimension vcodcta(10)
STORE {} TO XdFchDoc,XdFchVto,XdFchPed
STORE '' TO XsCodCco ,XsCodDoc,XsNroDoc,XsNroRef,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta,XsNroRuc
** Valores variables inicializados como NUMERO
STORE 0 TO nImpNac,nImpUsa,NumCta


=SEEK(GDOC.CodDoc,"TDOC")
IF EMPTY(TDOC.CodCta) AND EMPTY(TDOC.CTA12_MN) AND EMPTY(TDOC.CTA12_ME)
	=f1_alert('Actualización contable queda pendiente.;'+;
			'Revise en Cuentas por cobrar/Maestros/Tipo de documentos;'+;
			'y configure las cuentas contables',[MENSAJE])
   RETURN
ENDIF
*********
SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN
ENDIF
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = GOSVRCBD.NROAST()
SELECT VMOV
SEEK (XsNroMes + XsCodOpe + XsNroAst)
IF FOUND()
   DO LIB_MERR WITH 11
   RETURN
ENDIF
APPEND BLANK
IF ! Rec_Lock(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN              && No pudo bloquear registro
ENDIF
SELECT GDOC
IF &sesrgv. AND !EMPTY(GDOC.CodOpe) AND !EMPTY(NroAst) AND !EMPTY(NroMes)
	XsNroMes = GDOC.NroMes
	XsCodOpe = GDOC.CodOpe
	XsNroAst = GDOC.NroAst
	SELECT VMOV
	SEEK (XsNroMes + XsCodOpe + XsNroAst)
	IF FOUND()
		GOSVRCBD.Crear = .f.
		GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst,.T.)
	ELSE
		GOSVRCBD.Crear = .T.
	ENDIF
	** VETT:INI Aqui reasignamos el nuevo _ANO , _mes segun fecha emisión, ** 
	** para regrabar asiento - beta 2021/11/11 04:23:08 ** 
	IF MONTH(GDOC.FchAct)<>MONTH(GDOC.FchEmi) OR YEAR(GDOC.FchAct)<>YEAR(GDOC.FchEmi)
		XsNroMes = TRANSFORM(MONTH(GDOC.FchEmi),"@L ##")
		_MES = VAL(XsNroMes)
		_ANO = YEAR(GDOC.FchEmi)
		=RLOCK("GDOC")
		REPLACE NroMes WITH XsNroMes IN GDOC
		UNLOCK IN GDOC
		XsNroAst = GOSVRCBD.NROAST()
		GOSVRCBD.Crear = .T.
	ENDIF
	** VETT:FIN 2021/11/11 04:23:08 **
ELSE
	SELECT OPER
	XsNroMes = TRANSF(_MES,"@L ##")
	XsNroAst = GOSVRCBD.NROAST()
	GOSVRCBD.Crear = .T.
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
XdFchAst = GDOC.FchEmi  && GDOC.FchDOC  
XsNroVou = ''
XiCodMon = GDOC.CodMon
XfTpoCmb = GDOC.TpoCmb
XsNotAst = GDOC.CodDoc+[ ]+GDOC.NroDoc+[ ]+GDOC.NomCli
m.Err= GOSVRCBD.MovGraba(XsNroMes,XsCodOpe,@XsNroAst)
IF m.Err>=0 
** ACTUALIZAR DATOS DE CABECERA **
	REPLACE GDOC.NroMes WITH XsNroMes
	REPLACE GDOC.CodOpe WITH XsCodOpe
	REPLACE GDOC.NroAst WITH XsNroAst
	REPLACE GDOC.FlgCtb WITH .T.
	** VETT: 2021/11/11 11:17:39 **
	IF GoCfgVta.crear AND !EMPTY(GDOC.CodOpe) AND !EMPTY(NroAst) AND !EMPTY(NroMes)
		IF VerifyVar('UserModi','','CAMPO',"GDOC")
			REPLACE UserModi WITH GoEntorno.User.Login  IN GDOC
		ENDIF
		IF VerifyVar('FchModi','','CAMPO',"GDOC")
			REPLACE FchModi WITH DATETIME()  IN GDOC
		ENDIF
	ELSE
		IF VerifyVar('UserCrea','','CAMPO',"GDOC")
			REPLACE UserCrea WITH GoEntorno.User.Login IN GDOC
		ENDIF
		IF VerifyVar('FchCrea','','CAMPO',"GDOC")
			REPLACE FchCrea WITH DATETIME() IN GDOC
		ENDIF
	ENDIF
	** VETT: FIN 2021/11/11 11:17:39 **
ELSE
	REPLACE GDOC.FlgCtb WITH .F.
	GoSvrCbd.MensajeErr(m.Err)
	RETURN
ENDIF
LiRecActGDOC_Act = RECNO('GDOC')
* * * * * * * * * * * * * * * * * *
* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef,XsTipRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa,LsLLaveRef1,LiRecActGDOC
STORE [] TO XsTipRef,XsNroDtr,LsLLaveRef1
STORE {} TO XdFchRef,XdFchDtr
XiNroItm = 1
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsGloDoc = SPACE(LEN(RMOV.GloDoc))
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
nImpNac  = 0
nImpUsa  = 0

** Grabamos las cuentas de detalle **
SELE RDOC
SEEK GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
DO WHILE !EOF() .AND. TpoDoc+CodDoc+NroDoc = GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
   =SEEK([NC]+RDOC.Codigo,"TABLA")
   XsCodCta = TABLA.CodCta
   XsCodRef = SPACE(LEN(RMOV.CodRef))
   =SEEK(XsCodCta,"CTAS")
   XsCodAux = SPACE(LEN(RMOV.CodAux))
   XsClfAux = ''
   IF CTAS.PidAux=[S]
   	   	XsClfAux = CTAS.ClfAux
		XsCodAux = GDOC.CodCli
		XsNroRuc = GDOC.RucCli
   ENDIF
   XcTpoMov = [H]    && << OJO <<
   XfImport = RDOC.Import
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
   XsCodDoc = SPACE(LEN(RMOV.CodDoc))
   XsNroDoc = SPACE(LEN(RMOV.NroDoc))
   XsNroRef = SPACE(LEN(RMOV.NroDoc))
   XsTipRef = SPACE(LEN(RMOV.TipRef))
   STORE {} TO XdFchRef
   XdFchDoc = {}
   XdFchRef = {}
   IF CTAS.PidDoc=[S]
      XsCodDoc = IIF(SEEK(GsCodSed+GDOC.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'')
      
      XsNroDoc = GDOC.NroDoc
      XdFchDoc = GDOC.FchDoc
      *XsNroRef = GDOC.NroRef
      
   ENDIF
   IF CTAS.PidGlo=[S]
		XsTipRef = 	IIF(SEEK(GDOC.CodRef,'TDOC'),TDOC.TpoDocSN,'')	
		XsNroRef =   GDOC.NroRef
		** VETT  15/03/2018 05:06 PM : Obtenemos fecha de documento de referencia 
		LiRecActGDOC = RECNO('GDOC')
		LsLLaveRef1=GDOC.TpoRef+GDOC.CodRef+GDOC.NroRef
	    IF SEEK(LsLLaveRef1,'GDOC')
	    	XdFchRef = GDOC.FchDOc
	    ENDIF
	    GO LiRecActGDOC  IN GDOC
   ENDIF
   GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
   XiNroItm = XiNroItm + 1
   *
   SELE RDOC
   SKIP
ENDDO
** Grabamos la cuenta de Cargo **
=SEEK(GDOC.CodDoc,"TDOC")
*XsCodCta = LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
IF CTAS.PidAux=[S]
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [D]    && << OJO <<
XfImport = GDOC.ImpTot
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
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
XsClfAux = ''
XdFchDoc = {}
XdFchRef = {}

IF CTAS.PidDoc=[S]
	XsClfAux = 	CTAS.ClfAux
	XsCodDoc = IIF(SEEK(GsCodSed+GDOC.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'')
	SFSCodDoc = LEFT(XsCodDoc,2)
	XsNroDoc = GDOC.NroDoc
	XdFchDoc = GDOC.FchDoc
ENDIF
IF CTAS.PidGlo=[S]
	XsTipRef = 	IIF(SEEK(GDOC.CodRef,'TDOC'),TDOC.TpoDocSN,'')	
	XsNroRef =  GDOC.NroRef
	LiRecActGDOC = RECNO('GDOC')
	LsLLaveRef1=GDOC.TpoRef+GDOC.CodRef+GDOC.NroRef
    IF SEEK(LsLLaveRef1,'GDOC')
    	XdFchRef = GDOC.FchDOc
    ENDIF
    GO LiRecActGDOC IN GDOC
ENDIF

GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
** Cerramos bases de datos **
WAIT [Fin de Generacion] WINDOW NOWAIT
*DO Imprvouc IN Ccb_Ctb
DO ctb_cier
_ANO = CUR_ANO
_MES = CUR_MES
nErrCode = S_OK
RETURN nErrCode

************************************************************************ FIN *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB

XsNroMes = GDOC.NroMes
XsCodOpe = GDOC.CodOpe
XsNroAst = GDOC.NroAst
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !REC_LOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
   DO lib_merr WITH 99
   DO ctb_cier
   RETURN
ENDIF
if flgest="A"
	dele
else
	GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst)
endif
SELE VMOV
DO ctb_cier
RETURN
************************************************************************ FIN *
