***************************************************************************
*  Nombre    : CcbCjLtr.PRG                                               *
*  Autor     : VETT                                                       *
*  Objeto    : Canje por Letras                                           *
*  Par metros:            : Ninguno                                       *
*  Creaci¢n     : 24/02/94                                                *
*  Actualizaci¢n: VETT 21/04/94 Verificar que exista la letra y aceptarla *
*                 VETT 06/05/94 Archivo Temporal de Canje                 *
*                 MAV 02/05/00 Archivo Temporal de Canje                  *
*				  VETT 02/09/2003 Adaptacion para VFP 7					  *										
***************************************************************************
IF !verifyvar('GsLetCje','C')
	return
ENDIF
RESTORE FROM GoCfgVta.oentorno.tspathcia+'VTACONFG.MEM' ADDITIVE
m.PorRet  = IIF(VARTYPE(CFGADMRET)<>'N',0,CFGADMRET)
m.MinRet  = IIF(VARTYPE(CFGADMMINRET)<>'N',0,CFGADMMINRET)
#DEFINE CRLF 			CHR(13)+CHR(10)
IF m.PorRet = 0 
	MESSAGEBOX('Porcentaje de retencion no esta configurado.'+CRLF+;
			'Ir a la opcion de ->Tablas Generales/Igv-ISC-Retencion'+CRLF+;
			'e ingresar el valor correspondiente',64,'AVISO IMPORTANTE!!!' ) 	

	RETURN
	
ENDIF
IF m.MinRet = 0 
	MESSAGEBOX('El monto minimo de retencion no esta configurado.'+CRLF+;
			'Ir a la opcion de ->Tablas Generales/Igv-ISC-Retencion'+CRLF+;
			'e ingresar el valor correspondiente',64,'AVISO IMPORTANTE!!!' ) 	

	RETURN
	
ENDIF


DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO fondo WITH 'Canjes',Goentorno.user.login,GsNomCia,GsFecha
DO xPanta
SAVE SCREEN TO LsScreen
**********************************
* Aperturando Archivos a usar    *
**********************************


LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
LoDatAdm.abrirtabla('ABRIR','CCTCDIRE','DIRE','DIRE02','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC04','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LODATADM.ABRIRTABLA('ABRIR','CCBNTASG','TASG','TASG01','')
LODATADM.ABRIRTABLA('ABRIR','CCBNRASG','RASG','RASG01','')
LODATADM.ABRIRTABLA('ABRIR','CJATPROV','PROV','PROV01','')
LODATADM.ABRIRTABLA('ABRIR','CBDTCNFG','CNFG','CNFG01','')
LoDatAdm.abrirtabla('ABRIR','VTATDOCM','DOCM','DOCM01','')
RELEASE LoDatAdm

** ARCHIVO TEMPORAL DE CANJES **
SELECT cnfg
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
   DO LIB_MERR WITH 99
   DO CLOSE_FILE IN CCB_CCBAsign
   SYS(2700,1)
   RETURN
ENDIF
XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdCta3 = CodCta3
XsCdCta4 = CodCta4
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4
** VETT:Tope Maximo y Minimo para aplicar Dif.Cambio  - 2015/05/04 12:25:54 ** 
XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.09)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.09)
IF Dif_ME=0 OR Dif_MN=0
	=MESSAGEBOX('Los valores máximos para la generación de ajuste por redondeo de diferencia cambio no estan completos.'+;
				 ' Modificar en la opcion "Configuración de Diferencia de Cambio" en el Menu de Configuración.',0+64,'Aviso importante')
	 
ENDIF

USE
** RELACIONES A USAR **
SELE TASG
SET RELA TO GsClfCli+CodCli INTO AUXI
**********************************
* Inicializando Variables a usar *
**********************************
** variables de la cabecera **
SELECT TASG
m.coddoc = "CANJ"
m.nrodoc = SPACE(LEN(NroDoc))
m.fchdoc = DATE()
m.codcli = SPACE(LEN(CodCli))
m.glodoc = SPACE(LEN(GloDoc))
m.codmon = 1
m.tpocmb = 0.00
m.impdoc = 0
m.flgest = [P]
** variables de control de datos intermedios **
m.import  = 0.00     && importe de documentos
m.impdoc  = 0.00     && importe de letras (= importe del canje)
m.nrolet  = 0        && Cantidad de letras a generar
m.letini  = 0        && Nro. de letra de arranque
m.plazo   = 0        && Dias de vencimiento a partir de la fchdoc

m.crear   = .T.
** Datos del Browse de Documentos **
CIMAXELE = 40
DIMENSION AsCodRef(CIMAXELE)
DIMENSION AsNroRef(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
DIMENSION AfImpRet(CIMAXELE)
DIMENSION AfImpBRT(CIMAXELE)
DIMENSION AfSdoDoc(CIMAXELE)
GiTotDoc = 0
** Datos del Browse de Letras **
DIMENSION AsNroDoc(CIMAXELE)
DIMENSION AdFchDoc(CIMAXELE)
DIMENSION AnDiaVto(CIMAXELE)
DIMENSION AdFchVto(CIMAXELE)
DIMENSION AfImpTot(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)  && Nuevo
GiTotLet = 0
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
XsCodOpe =  GsLetCje    && [012]  && << OJO <<
** Logica Principal **
*************************************************
** OJO >> Solo de va a permitir CREAR y ANULAR **
*************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
*DO LIB_MTEC WITH 99
cCodDoc = m.CodDoc
DO F1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],'xImprime',;
              [CodDoc],cCodDoc,'CMAR'

DO CLOSE_FILE IN CCB_CCBAsign
CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
************************************************************************ EOP()
* Pintado de Pantalla
***************************************************************************
PROCEDURE xPanta

*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678
*1    Canje #      :                                     Fecha : 99/99/99
*2    Cod.Cliente  : 123456789012345678901234567890123
*3    Observaciones:
*4    Moneda       :                               Tipo Cambio : 99,999.9999
*5    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6    ³ Doc.   Documento            Importe       Rentencion      Total     ³
*7    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*8	  ³ FACT  1234567890  999,999,999.99 999,999,999.99 999,999,999.99      ³
*9	  ³                                                                     ³
*0	  ³                                                                     ³
*1	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*2    ------------------------>  Importe Total :  999,999,999.99
*3    Cant. Letras : ###  Letra Inicial : 123456     Plazo : 123 dias
*4                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*5                ³ No.Letra   Emision    Dias  Vencto.    Imp.Letra.   ³
*6                ³-----------------------------------------------------³
*7                ³ 1234567890 99/99/9999 999 99/99/9999 999,999,999.99 ³
*8                ³                                                     ³
*9                ³                                                     ³
*0                ³                                                     ³
*1                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*2    ------------------------> Importe Total :     999,999,999.99
*          1         2         3         4         5         6         7         8         9
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
CLEAR
IF _windows OR _mac
	@  0,0 TO 32,100  
ELSE
	@  0,0 TO 22,79  PANEL
endif
Titulo = "** CANJE POR LETRAS **"
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "Canje #      :                                     Fecha :  "
@  2,5  SAY "Cod.Cliente  :                                              "
@  3,5  SAY "Observaciones:                                              "
@  5,5  SAY "Moneda       :                               Tipo Cambio :  "
@  6,5  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ "
@  7,5  SAY "³ Doc.   Documento            Importe       Rentencion      Total      ³ "
@  8,5  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ "
@  9,5  SAY "³                                                                      ³ "
@ 10,5  SAY "³                                                                      ³ "
@ 11,5  SAY "³                                                                      ³ "
@ 12,5  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ "
@ 13,5  SAY "------------------------>  Importe Total :                               "
@ 14,5  SAY "Cant. Letras :      Letra Inicial :            Plazo :     dias          "
@ 15,5  SAY "           ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 16,5  SAY "           ³ No.Letra        Emision    Dias  Vencto.    Imp.Letra.     ³"
@ 17,5  SAY "           ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 18,5  SAY "           ³                                                            ³"
@ 19,5  SAY "           ³                                                            ³"
@ 20,5  SAY "           ³                                                            ³"
@ 21,5  SAY "           ³                                                            ³"
@ 22,5  SAY "           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 23,5  SAY "------------------------> Importe Total :                                "


@  7,6  SAY " Doc.   Documento            Importe       Rentencion      Total      " COLOR SCHEME 7
@ 16,17 SAY " No.Letra        Emision    Dias  Vencto.    Imp.Letra.     " COLOR SCHEME 7

RETURN
********************************************************************** FIN
* Llave de Acceso
******************************************************************************
PROCEDURE xLlave

* buscamos correlativo
IF !SEEK(m.coddoc,"TDOC")
	WAIT "No existe correlativo" NOWAIT WINDOW
	UltTecla = escape_
	RETURN
ENDIF
RESTORE SCREEN FROM LsScreen
m.NroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),7,'0'),LEN(m.NroDoc))
*
SELE TASG
m.crear  = .T.
UltTecla = 0
i = 1
DO lib_mtec WITH 7
DO WHILE !INLIST(UltTecla,escape_,Enter)
	DO CASE
		CASE i = 1
			@ 1,20 GET m.NroDoc PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = F8
				SET ORDER TO TASG04	
				xCodDoc = m.CodDoc
				IF !ccbbusca("0013")
					LOOP
				ENDIF
				m.NroDoc = TASG->NroDoc
				SET ORDER TO TASG01
	            KEYBOARD '{ENTER}' 
			ENDIF
	ENDCASE
	i = IIF(UltTecla=Arriba,i-1,i+1)
	i = IIF(i<1,1,i)
	i = IIF(i>1,1,i)
ENDDO
SEEK m.CodDoc+m.Nrodoc
DO lib_mtec WITH 0
RETURN
************************************************************************ FIN *
* Poner Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

@ 1,20 SAY NroDoc
@ 1,64 SAY FchDoc pict '@d dd/mm/aa'
@ 2,20 SAY CodCli
@ 2,35 SAY AUXI->NomAux PICT '@S35'
@ 3,20 SAY GloDoc SIZE 1,40 PICT "@!"
@ 5,20 SAY IIF(CodMon=1,'S/.','US$')
@ 5,64 SAY TpoCmb PICT "99,999.9999"
@ 13,49 SAY impDoc PICT "999,999,999.99"
@ 23,48 SAY impDoc PICT "999,999,999.99"

@ 26,12 clear to 26,WCOLS()-2
DO CASE
CASE FLgEst='A'
	@ 26,12 SAY "DOCUMENTO: ANULADO"  FONT "Foxfont",12 STYLE 'B'  color r+/n
CASE FLgEst='E'
	@ 26,12 SAY "DOCUMENTO: APROBADO"  FONT "Foxfont",12 STYLE 'B'  color G+/n
CASE FLgEst='P'
	@ 26,12 SAY "DOCUMENTO: PENDIENTE DE APROBACION"  FONT "Foxfont",12 STYLE 'B'  color RGB(255,128,64,0,0,0)
ENDCASE

** Pintamos el Browse de Documentos origen **
** Definimos variables a usar en el Browse **
PRIVATE SelLin,EdiLin,BrrLin,InsLin,GrbLin,EscLin
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
SelLin   = ""
EscLin   = ""
EdiLin   = ""
BrrLin   = ""
InsLin   = ""
GrbLin   = ""
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
*
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8
PRIVATE MVprgF9,NClave,VClave,LinReg,Titulo,VTitle,HTitle
PRIVATE Yo,Xo,Largo,Ancho,TBorde
PRIVATE BBVerti,Static,VSombra,E1,E2,E3
MVprgF1  = ""
MVprgF2  = ""
MVprgF3  = ""
MVprgF4  = ""
MVprgF5  = ""
MVprgF6  = ""
MVprgF7  = ""
MVprgF8  = ""
MVprgF9  = ""
NClave   = "CodDoc+NroDoc"
VClave   = TASG->CodDoc+TASG->NroDoc
Titulo   = ""
VTitle   = 0
HTitle   = 0
Yo       = 8
Xo       = 5
Largo    = 5
Ancho    = 72
Tborde   = Nulo
BBverti  = .T.
Static   = .T.
VSombra  = .F.
E1 = ""
E2 = ""
E3 = ""
LinReg   = [' '+CodRef+'  '+NroRef+'  '+TRANS(Import+Rete,'999,999,999.99')+' '+TRANS(Rete,'999,999,999.99') +' '+ TRANS(Import,'999,999,999.99')+' ']
** SELECCION DE LA BASE A IMPRIMIR **
IF TASG->FlgEst = [P]   && Pendiente de Aprobacion
	SELE RASG
ELSE
	SELE VTOS
ENDIF
DO dbrowse
** Pintamos el Browse de Documento Letras **
SELE GDOC
SET ORDER TO GDOC03
NClave   = "TpoRef+CodRef+NroRef+TpoDoc+CodDoc"
VClave   = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
Yo       = 17
Xo       = 17
Largo    = 6
Ancho    = 61
LinReg   = [NroDoc+' '+DTOC(FchEmi)+' '+TRANSFORM(FchVto-FchEmi,'999')+' '+DTOC(FchVto)+' '+TRANS(ImpTot,'999,999,999.99')+' ']
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
DO dbrowse
SET ORDER TO GDOC04
SELE TASG

RETURN
************************************************************************ FIN *
* Inicializa valores de las variables
***************************************************************************
PROCEDURE xInvar

m.fchdoc = DATE()
m.codcli = SPACE(LEN(CodCli))
m.glodoc = SPACE(LEN(GloDoc))
m.codmon = 1
m.tpocmb = 0.00
m.impdoc = 0
m.flgest = 'P'
** variables de control de datos intermedios **
m.import  = 0.00     && importe de documentos
m.impdoc  = 0.00     && importe de letras (= importe del canje)
m.nrolet  = 0        && Cantidad de letras a generar
m.letini  = 0        && Nro. de letra de arranque
m.plazo   = 0        && Dias de vencimiento a partir de la fchdoc
m.crear   = .T.
** Datos del Browse de Documentos **
STORE SPACE(LEN(GDOC->coddoc)) TO AsCodRef
STORE SPACE(LEN(GDOC->nrodoc)) TO AsNroRef
STORE 0.00                        TO AfImpRet
STORE 0.00                        TO AfImpBRT
STORE 0.00                        TO AfImport
STORE 0.00 				   TO AfSdoDoc	
GiTotDoc = 0
** Datos del Browse de Letras **
STORE SPACE(LEN(GDOC->nrodoc))	TO AsNroDoc
STORE CTOD(SPACE(10))           TO AdFchDoc
STORE 0 						TO AnDiaVto
STORE CTOD(SPACE(10))           TO AdFchVto
STORE 0.00                      TO AfImpTot
STORE 0                         TO AiNumReg

GiTotLet = 0
* Variables Contables *
_MES     = 0
XsNroMes = SPACE(LEN(GDOC.NroMes))
XsNroAst = SPACE(LEN(GDOC.NroAst))
XsCodOpe = GsLetCje &&[012]  && << OJO <<

RETURN
************************************************************************ FIN *
* Editar Datos de Cabezera
***************************************************************************
PROCEDURE xTomar

** OJO >> Siempre es Crear **
SELE TASG
IF cvctrl=[C]
	m.Crear  = .T.
	DO xInvar
ELSE
	DO xPoner
	m.FchDoc = TASG.FchDoc
	m.CodCli = TASG.CodCli
	m.Crear = .f.
	** Pintamos el Browse de Documento Letras **
	PRIVATE SelLin,EdiLin,BrrLin,InsLin,GrbLin,EscLin
	PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
	SelLin   = ""
	EscLin   = ""
	EdiLin   = ""
	BrrLin   = ""
	InsLin   = ""
	GrbLin   = ""
	Consulta = .F.    && valores iniciales
	Modifica = .F.
	Adiciona = .F.
	Db_Pinta = .T.
	*
	PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8
	PRIVATE MVprgF9,NClave,VClave,LinReg,Titulo,VTitle,HTitle
	PRIVATE Yo,Xo,Largo,Ancho,TBorde
	PRIVATE BBVerti,Static,VSombra,E1,E2,E3
	MVprgF1  = ""
	MVprgF2  = ""
	MVprgF3  = ""
	MVprgF4  = ""
	MVprgF5  = "Imprime_Letra"
	MVprgF6  = ""
	MVprgF7  = ""
	MVprgF8  = ""
	MVprgF9  = ""
	Tborde   = Nulo
	BBverti  = .T.
	Static   = .T.
	VSombra  = .F.
	E1 = ""
	E2 = ""
	E3 = ""
	Titulo   = ""
	VTitle   = 0
	HTitle   = 0

	SELE GDOC
	SET ORDER TO GDOC03
	NClave   = "TpoRef+CodRef+NroRef+TpoDoc+CodDoc"
	VClave   = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
	Yo       = 17
	Xo       = 17
	Largo    = 6
	Ancho    = 61
	LinReg   = [NroDoc+' '+DTOC(FchEmi)+' '+TRANSFORM(FchVto-FchEmi,'999')+' '+DTOC(FchVto)+' '+TRANS(ImpTot,'999,999,999.99')+' ']
	Consulta = .T.    && valores iniciales
	Modifica = .F.
	Adiciona = .F.
	Db_Pinta = .F.
	
	GsMsgKey = "[] [] [PgUp] [PgDw] [Home] [End] Posiciona [Esc] Cancelar [F5] Imprime Letra [F10] Salir"
	DO Lib_MTEC WITH 99
	DO dbrowse
	SET ORDER TO GDOC04
	SELE TASG
*	DO xImprime
	DO Lib_MTEC WITH 0
	return
ENDIF
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1
      
         @  1,64 GET m.FchDoc pict '@d dd/mm/aa'
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELE AUXI
         @ 2,20 GET m.CodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("CLIE")
               LOOP
            ENDIF
            m.CodCli = AUXI->CodAux
         ENDIF
         @ 2,20 SAY m.CodCli
         SEEK GsClfCli+m.CodCli
         IF !FOUND()
            GsMsgErr = [ Cliente no Registrado ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         @ 2,35 SAY AUXI->NomAux PICT "@S35"
      CASE i = 3
         @ 3,20 GET m.GloDoc PICT "@!S40"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
*         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         m.CodMon= Elige(m.CodMon,5,20,2)
      CASE i = 5
         =SEEK(DTOS(m.FchDoc),"TCMB")
         m.TpoCmb = TCMB.OfiVta
         @ 5,64 GET m.TpoCmb PICT "99,999.9999" VALID m.tpocmb>0
         READ
         UltTecla = LASTKEY()
      CASE i = 6
         DO DocBrows    && Browse de Documentos de Cargo
      CASE i = 7
         DO LetBrows    && Browse de Letras a Generar
      CASE i = 8
         ** preguntar grabacion **
         cResp = [S]
         cResp = Aviso(12,[ Datos Correctos (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
         IF cResp = "N"
            UltTecla = 0
            i = 1
            LOOP
         ENDIF
         ** preguntar aprobacion de letras **
         cResp = [S]
         cResp = Aviso(12,[ Letras Aprobadas (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
         IF cResp = "S"
            m.FlgEst = "E"    && Aprobado
            ** Rutina que apertura las base contables a usar y ademas **
            ** verifica que el mes contables NO este cerrado **
            IF !ctb_aper(m.FchDoc)
               i = 1
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         UltTecla = Enter
   ENDCASE
   IF i = 8 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>8,8,i)
ENDDO
IF UltTecla # escape_
   DO xGraba
ENDIF
SELE TASG
UNLOCK ALL
DO lib_mtec WITH 0
RETURN
************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE DocBrows

GiTotItm = GiTotDoc
**
EscLin   = "Docbline"
EdiLin   = "Docbedit"
BrrLin   = "Docbborr"
InsLin   = "Docbinse"
PrgFin   = []
*
Yo       = 8
Xo       = 5
Largo    = 5
Ancho    = 72
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
DO aBrowse
*
GiTotDoc = GiTotItm
*
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE DocBLine
PARAMETERS NumEle, NumLin
@ NumLin,07 SAY AsCodRef(NumEle)
@ NumLin,13 SAY AsNroRef(NumEle)
@ NumLin,30 SAY AfImpBrt(NumEle) PICT "999,999,999.99"
@ NumLin,45 SAy AfImpRET(NumEle) PICT "999,999,999.99"
@ NumLin,60 SAY AfImport(NumEle) PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE DocBEdit
PARAMETERS NumEle, NumLin

i        = 1
UltTecla = 0
*
LsCodRef = AsCodRef(NumEle)
LsNroRef = AsNroRef(NumEle)
LfImport = AfImport(NumEle)
LfImpRET = AfImpRET(NumEle)
LfImpBRT = AfImpBRT(NumEle)
LfSdoDoc = AfSdoDoc(NumEle)
m.sdodoc = 0   && Control del saldo
DO WHILE !INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1
         SELE TDOC
         @ NumLin,07 GET LsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_)
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("TDOC")
               LOOP
            ENDIF
            LsCodRef = TDOC->CodDoc
         ENDIF
         @ NumLin,07 SAY LsCodRef
         SEEK LsCodRef
         IF !FOUND()
            GsMsgErr = [Documento no Existe]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF TpoDoc # "CARGO"
            GsMsgErr = "No es un documento de Cargo"
            DO lib_merr WITH 99
            LOOP
         ENDIF

      CASE i = 2
         SELE GDOC
         @ NumLin,13 GET LsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            PRIVATE XsCodCli,XsTpoRef,XsCodRef
            XsCodCli = m.CodCli
            XsTpoRef = "CARGO"
            XsCodRef = LsCodRef
            IF !ccbbusca("ASIG")
               LOOP
            ENDIF
            LsNroRef = GDOC->NroDoc
         ENDIF
         @ NumLin,13 SAY LsNroRef
         SEEK m.codcli+"P"+"CARGO"+LsCodRef+LsNroRef
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         ** verificamos que no se repita **
         LlYaRegistrado = .F.
         PRIVATE j
         j = 1
         DO WHILE j <= GiTotDoc
            IF j <> NumEle
               IF AsCodRef(j)+AsNroRef(j) = LsCodRef+LsNroRef
                  WAIT "Dato ya Registrado" NOWAIT WINDOW
                  LlYaRegistrado = .t.
                  EXIT
               ENDIF
            ENDIF
            j = j + 1
         ENDDO
         IF LlYaregistrado
         	Loop
         ENDIF
         IF !RLOCK()
            LOOP
         ENDIF
         LfImport = GDOC->SdoDoc
         IF GDOC->CodMon # m.codmon
            IF GDOC->CodMon = 1
               LfImport = LfImport/m.tpocmb
            ELSE
               LfImport = LfImport*m.tpocmb
            ENDIF
         ENDIF
         *** Verificamos retencion *** 
*!*				SET STEP ON
		 IF Valida_Agente_ret(m.codCli,GDOC->SdoDoc,GDOC->CodMon,m.TpoCmb)
		 	 
		 	DIMENSION vImporte(3)
		 	STORE 0 TO vImporte
		 	LfSdoVtos = CCb_Sldo(m.codCli,GDOC.TpoDoc,GDOC.CodDoc,GDOC.NroDoc,GDOC.CodMon,GDOC.TpoCmb,GDOC.Imptot,'.T.',@vImporte)
		 	IF vImporte(2)<=0  && No se ha procesado su retencion 
				LfImpRet=Calcula_Monto_ret(m.codCli,LfImport,m.CodMon,m.TpoCmb) 		            	
				LfImpBrt=GDOC.Imptot
				LfImport=IIF(LfSdoVtos=GDOC.Imptot,LfImpBrt - LfImpRet,GDOC.SdoDoc) 
			ELSE
				LfImpRet= vImporte(2)
				LfImpBrt=GDOC.Imptot
				LfImport=IIF(LfSdoVtos=GDOC.Imptot,LfImpBrt - LfImpRet,GDOC.SdoDoc)        	
			ENDIF
		 ELSE 	
			LfImpBrt = LfImport
			LfImpRet = 0
         ENDIF 
		 @ NumLin,30 SAY LfImpBrt PICT "999,999,999.99"
		 @ NumLin,45 SAY LfImpRET PICT "999,999,999.99"
         ***
         m.sdodoc = LfImport
		
      CASE i = 3
         @ NumLin,60 GET LfImport PICT "999,999,999.99" VALID LfImport>0 .AND. LfImport <= m.sdodoc
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 3 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>3,3,i)
ENDDO
IF UltTecla # escape_
   AsCodRef(NumEle) = LsCodRef
   AsNroRef(NumEle) = LsNroRef
   AfImport(NumEle) = LfImport
   AfImpBrt(NumEle) = LfImpBrt
   AfImpRET(NumEle) = LfImpRet
  AfSdoDoc(NumEle)  = LfImport
   DO DocRegen
ELSE
   UNLOCK IN GDOC
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE DocRegen
PRIVATE j
j = 1
STORE 0 TO m.import,m.impBrt,m.ImpRet
DO WHILE j <= GiTotItm
   m.impBrt = m.ImpBrt + AfImpBrt(j)
   m.impRET = m.ImpRET + AfImpRET(j)
   m.import = m.import + AfImport(j)
   j = j + 1
ENDDO

** Verifcamos retenciones ** 
IF Valida_Agente_ret(m.codCli,m.Import,m.CodMon,m.TpoCmb) AND ( m.ImpRet=0 OR (GiTotItm>1 AND m.ImpRet>0) )
	j = 1
	STORE 0 TO m.import,m.impBrt,m.ImpRet
	DO WHILE j <= GiTotItm
		IF AfImpRet(j)=0
			AfImpRet(j) = Calcula_Monto_ret(m.codCli,AfImport(j),m.CodMon,m.TpoCmb) 		   
			AfImpBrt(j) = AfImport(j)
		 	AfImport(j) = AfImpBrt(j)  - AfImpRet(j)	   
		ENDIF   
	   	m.ImpBrt = m.impbrt + AfImpBrt(j)
	       m.ImpRet = m.ImpRet + AfImpRet(j)
		m.import = m.import + AfImport(j)
	 	j = j + 1
	ENDDO
**	m.Import = m.ImpBrt - m.ImpRet
ENDIF
@ 12,49 SAY m.import PICT "999,999,999.99"
RETURN

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE DocbBorr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1

DO WHILE i <  GiTotItm
   AsCodRef(i) = AsCodRef(i+1)
   AsNroRef(i) = AsNroRef(i+1)
   AfImport(i) = AfImport(i+1)
   i = i + 1
ENDDO
AsCodRef(i) = SPACE(LEN(GDOC->coddoc))
AsNroRef(i) = SPACE(LEN(GDOC->nrodoc))
AfImport(i) = 0.00
AfImpBrt(i) = 0.00
AfImpRET(i) = 0.00
GiTotItm = GiTotItm - 1
Estado = .T.
DO DocRegen    && recalcula importe
RETURN
************************************************************************ FIN *
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE DocbInse

PARAMETERS ElePrv, Estado
PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
	AsCodRef(i) = AsCodRef(i-1)
	AsNroRef(i) = AsNroRef(i-1)
	AfImport(i) = AfImport(i-1)
	AfImpBrt(i) = AfImpBrt(i-1)
	AfImpRET(i) = AfImpRET(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
AsCodRef(i) = SPACE(LEN(GDOC->coddoc))
AsNroRef(i) = SPACE(LEN(GDOC->nrodoc))
AfImport(i) = 0.00
AfImpBrt(i) = 0.00
AfImpRET(i) = 0.00
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE LetBrows

*IF GiTotLet = 0
=SEEK([LETR],[TDOC])
m.letini = TDOC->NroDoc
@ 14,20 GET m.nrolet   PICT "999"     VALID m.nrolet > 0
@ 14,41 GET m.letini   PICT "9999999"
@ 14,60 GET m.plazo    PICT "999"    VALID m.plazo > 0
READ
IF LASTKEY() = escape_
	UltTecla = Arriba
	RETURN
ENDIF
*ENDIF
*LiMaxEle = MAX(m.nrolet,GiTotLet)
LiMaxEle = m.nrolet
**
EscLin   = "Letbline"
EdiLin   = "Letbedit"
BrrLin   = "Letbborr"
InsLin   = "Letbinse"
PrgFin   = []
*
Yo       = 17
Xo       = 17
Largo    = 6
Ancho    = 61
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
DO Letbiniv    && Inicializa el arreglo
IF GiTotLet = 0
   GsMsgErr = [No se puede cargar informacion]
   DO lib_merr WITH 99
   UltTecla = Arriba
   RETURN
ENDIF
GiTotItm = GiTotLet
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
DO WHILE .t.
   DO aBrowse
   IF INLIST(UltTecla,escape_) .OR. (m.ImpDoc = m.Import)
      EXIT
   ELSE
      GsMsgErr = [ Los montos deben ser exactos ]
      DO lib_merr WITH 99
   ENDIF
ENDDO
*
GiTotLet = GiTotItm
*
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Inicializar el arreglo
******************************************************************************
PROCEDURE Letbiniv

** solo se genera 1 vez **
*IF GiTotLet > 0
*   RETURN
*ENDIF
**
PRIVATE i
i = 1
XiVtoAct    = 0
*LfImpRef    = INT(m.import/m.nrolet)
LfImpRef    = ROUND(m.import/m.nrolet,2)
LfSdoDoc    = m.import
FOR i = 1 TO LiMaxEle
   XiVtoAct    = XiVtoAct    + m.plazo
   LfImpLet    = LfImpRef
  *AsNroDoc(i) = Right("000000"+LTRIM(STR(m.letini,6,0)),6) + SPACE(5)
   AsNroDoc(i) = PADR(PADL(LTRIM(STR(m.LetIni)),7,'0'),LEN(GDOC->NroDoc))
   AiNumReg(i) = 0
   ** verificamos si existen letras en el archivo **
   SELECT GDOC
   SET ORDER TO GDOC01
   SEEK "CARGO"+"LETR"+TRIM(AsNroDoc(i))
   IF FOUND()
      ** Cargamos datos al arreglo **
     *AdFchDoc(i) = FchDoc
      AdFchDoc(i) = FchEmi    && << OJO <<
      AnDiaVto(i) = FchVto-FchEmi
      AdFchVto(i) = FchVto
      AfImpTot(i) = ImpTot
      AiNumReg(i) = RECNO()
      LfImpRef    = ImpTot    && << OJO <<
      * * * * * * * * * * * * * * * *
      SET ORDER TO GDOC04
      IF FlgEst = [A]
         WAIT "LETRA : "+TRIM(AsNroDoc(i))+" esta Anulada" NOWAIT WINDOW
         i = 1
         EXIT
      ENDIF
      IF CodMon # m.CodMon
         WAIT "LETRA : "+TRIM(AsNroDoc(i))+" no corresponde la Moneda" NOWAIT WINDOW
         i = 1
         EXIT
      ENDIF
   ELSE
      SET ORDER TO GDOC04
      AdFchDoc(i) = m.fchdoc
      AnDiaVto(i) = XiVtoAct
      AdFchVto(i) = m.fchdoc + XiVtoAct
      AfImpTot(i) = LfImpRef
   ENDIF
   m.letini    = m.letini + 1
   LfSdoDoc    = LfSdoDoc  - LfImpRef
ENDFOR
GiTotLet = i - 1
GiTotItm = GiTotLet
IF LfSdoDoc <> 0
   ** buscamos primera letra VALIDA donde asignar la diferencia **
   FOR i = 1 TO GiTotItm
      IF AiNumReg(i)=0
         AfImpTot(i) = AfImpTot(i) + LfSdoDoc
         EXIT
      ENDIF
   ENDFOR
ENDIF
DO LetRegen
RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE LetRegen

PRIVATE j
j = 1
STORE 0 TO m.impdoc
DO WHILE j <= GiTotItm
   m.impdoc = m.impdoc + AfImpTot(j)
   j = j + 1
ENDDO
@ 23,48 SAY m.impdoc PICT "999,999,999.99"

RETURN
********************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE LetBLine

PARAMETERS NumEle, NumLin
@ NumLin,19 SAY AsNroDoc(NumEle)
@ NumLin,35 SAY AdFchDoc(NumEle) pict "@D dd/mm/aa"
@ NumLin,46 SAY AnDiaVto(NumEle) Pict "999"
@ NumLin,50 SAY AdFchVto(NumEle) pict "@D dd/mm/aa"
@ NumLin,61 SAY AfImpTot(NumEle) PICT "999,999,999.99"

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE LetBEdit
PARAMETERS NumEle, NumLin

** NO se puede modificar si la letra YA EXISTIA antes del canje **
IF AiNumReg(NumEle)>0
	GsMsgErr = [Letra no puede ser modificada]
	DO lib_merr WITH 99
	UltTecla = Arriba
	RETURN
ENDIF
******************************************************************
i        = 1
UltTecla = 0
*
LsNroDoc = AsNroDoc(NumEle)
LdFchDoc = AdFchDoc(NumEle)
LnDiaVto = AnDiaVto(NumEle)	
LdFchVto = AdFchVto(NumEle)
LfImpTot = AfImpTot(NumEle)
DO WHILE UltTecla # escape_
	DO CASE
		CASE i = 1
			@ NumLin,19 GET LsNroDoc PICT "!!!!!!!!!" VALID _lsnrodoc()
			READ
			UltTecla = LASTKEY()
		CASE i = 2
			@ NumLin,35 GET LdFchDoc pict "@D dd/mm/aa"
			READ
			UltTecla = LASTKEY()
		CASE i = 3
			@ NumLin,46 GET LnDiaVto pict "999" VALID (LdFchDoc<=LdFchDoc + LnDiaVto) Error 'Aumentar dias'
			READ
			UltTecla = LASTKEY()
			LdFchVto = LdFchDoc + LnDiaVto
			@ NumLin,50 SAY LdFchVto
		CASE i = 4
*!*				LdFchVto = NumEle*m.PLazo + LdFchDoc

			@ NumLin,50 GET LdFchVto VALID(LdFchVto>=LdFchDoc) pict "@D dd/mm/aa"
			READ
			UltTecla = LASTKEY()
		CASE i = 5
			@ NumLin,61 GET LfImpTot PICT "999,999,999.99" VALID LfImpTot>0
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Enter
				EXIT
			ENDIF
	ENDCASE
	i = IIF(UltTecla=Arriba,i-1,i+1)
	i = IIF(i<1,1,i)
	i = IIF(i>5,5,i)
ENDDO
IF UltTecla # escape_
   AsNroDoc(NumEle) = LsNroDoc
   AdFchDoc(NumEle) = LdFchDoc
   AnDiaVto(NumEle) = LnDiaVto
   AdFchVto(NumEle) = LdFchVto
   AfImpTot(NumEle) = LfImpTot
   DO LetRegen
ENDIF
RETURN

FUNCTION _lsnrodoc
******************
IF LASTKEY() = escape_
   RETURN .T.
ENDIF
IF EMPTY(LsNroDoc)
   RETURN 0
ENDIF
**
SELECT GDOC
SET ORDER TO GDOC01
SEEK TRIM("CARGO"+"LETR"+LsNroDoc)
IF FOUND()
   SET ORDER TO GDOC04
   WAIT "Dato ya Registrado" NOWAIT WINDOW
   RETURN 0
ENDIF
SET ORDER TO GDOC04
RETURN .T.

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE LetbBorr
PARAMETERS ElePrv, Estado
Estado = .F.
RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE LetbInse
PARAMETERS ElePrv, Estado
PRIVATE i
Estado = .F.
RETURN

************************************************************************ FIN *
* Procedimiento de Grabacion de informacion de Cabezera
******************************************************************************
PROCEDURE xGraba
*!*	SET STEP ON 
**
WAIT "GRABANDO" NOWAIT WINDOW
** grabamos cabezera **
SELECT TDOC
SEEK m.coddoc
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TASG
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TDOC
IF VAL(m.nrodoc)>= NroDoc
   REPLACE NroDoc WITH VAL(m.nrodoc)+1
ENDIF
UNLOCK
**
SELECT TASG
REPLACE CodDoc WITH m.coddoc
REPLACE NroDoc WITH m.nrodoc
REPLACE FchDoc WITH m.fchdoc
REPLACE CodCli WITH m.codcli
REPLACE GloDoc WITH m.glodoc
REPLACE CodMon WITH m.codmon
REPLACE TpoCmb WITH m.tpocmb
REPLACE ImpDoc WITH m.impdoc
REPLACE FlgEst WITH m.flgest
** generamos detalles **
j = 1
DO WHILE j <= GiTotDoc
	Do CjLActDoc WITH AsCodRef(j),AsNroRef(j),AfImport(j),AfImpRet(j)
	j = j + 1
ENDDO
**
j = 1
DO WHILE j <= GiTotLet
   LsNroDoc = AsNroDoc(j)
   LdFchDoc = AdFchDoc(j)
   LdFchVto = AdFchVto(j)
   LfImpTot = AfImpTot(j)
   Do CjLActLet
   j = j + 1
ENDDO
** ACTUALIZACION CONTABLE **
IF TASG.FlgEst = [E]
   DO xACT_CTB IN CCB_ccbcjap1   && para contab ..................
ENDIF
* * * * * * * * * * * * * * *
DO xImprime
WAIT "LISTO" NOWAIT WINDOW
RETURN
************************************************************************** FIN
* Cancelando Documentos
***************************************************************************
PROCEDURE CjLActDoc
PARAMETER cCodDoc,cNroDoc,nImpTot,nImpRet

PRIVATE LfImpDoc
SELECT GDOC
SEEK m.codcli+"P"+"CARGO"+cCodDoc+cNroDoc
IF !RLOCK()
	RETURN
ENDIF
************************************************************************
** SI ESTA APROBADO SE GRABA EN VTOS, SI NO LO ESTA, SE GRABA EN RASG **
************************************************************************
IF TASG->FlgEst = [E]
	SELECT VTOS
	APPEND BLANK
	IF ! RLOCK()
		RETURN
	ENDIF
ELSE
	SELECT RASG
	APPEND BLANK
	IF ! RLOCK()
		RETURN
	ENDIF
ENDIF
LsAlias = ALIAS()
******************************************************
* SOLO ACTUALIZAMOS SALDOS SI EL CANJE ESTA APROBADO *
******************************************************
IF TASG->FlgEst = "E"   && Canje Aprobado
	** actualizamos documento origen **
	SELECT GDOC
	LfImpDoc = nImpTot
	IF CodMon <> m.codmon
		IF m.codmon = 1
			LfImpDoc = nImpTot / m.tpocmb
		ELSE
			LfImpDoc = nImpTot * m.tpocmb
		ENDIF
	ENDIF
	REPLACE SdoDoc WITH SdoDoc - LfImpDoc
	IF SdoDoc <= 0.01
		REPLACE FlgEst WITH 'C'
		REPLACE FchAct WITH m.fchdoc
	ELSE
		REPLACE FlgEst WITH 'P'
	ENDIF
	REPLACE FchAct WITH DATE()
	REPLACE FlgSit WITH 'X'
	UNLOCK
ENDIF
**** Actualiza el movimiento realizado ****
SELECT (LsAlias)
REPLACE CodDoc WITH m.coddoc
REPLACE NroDoc WITH m.nrodoc
REPLACE TpoDoc WITH "Canje"
REPLACE FchDoc WITH m.fchdoc
REPLACE CodCli WITH m.codcli
REPLACE CodMon WITH m.codmon
REPLACE TpoCmb WITH m.tpocmb
REPLACE TpoRef WITH [CARGO]
REPLACE CodRef WITH cCodDoc
REPLACE NroRef WITH cNroDoc
Replace rete   WITH nImpRet
REPLACE Import WITH nImpTot
UNLOCK

RETURN
************************************************************************** FIN
* Grabando Letras
***************************************************************************
PROCEDURE CjLActLet

SELECT TDOC
SEEK [LETR]
DO WHILE !RLOCK()
ENDDO
** buscamos si ya existe la letra **
SELECT GDOC
SET ORDER TO GDOC01
SEEK [CARGO]+[LETR]+TRIM(LsNroDoc)
IF FOUND()     && Letra YA registrada
	IF !RLOCK()
		SET ORDER TO GDOC04
		RETURN
	ENDIF
	REPLACE TpoRef WITH 'Canje'
	REPLACE CodRef WITH m.coddoc
	REPLACE NroRef WITH m.nrodoc
ELSE
	APPEND BLANK
	IF !RLOCK()
		SET ORDER TO GDOC04
		RETURN
	ENDIF
	REPLACE CodDoc WITH "LETR"
	REPLACE NroDoc WITH LsNroDoc
	REPLACE TpoDoc WITH "CARGO"
	REPLACE FchEmi WITH LdFchDoc
	REPLACE FchDoc WITH m.FchDoc     && << OJO : con la fecha del CANJE
	REPLACE CodCli WITH m.codcli
	REPLACE CodMon WITH m.codmon
	REPLACE TpoCmb WITH m.tpocmb
	REPLACE ImpNet WITH LfImpTot
	REPLACE ImpTot WITH LfImpTot
	REPLACE FchVto WITH LdFchVto
	REPLACE SdoDoc WITH LfImpTot
	REPLACE TpoRef WITH 'Canje'
	REPLACE CodRef WITH m.coddoc
	REPLACE NroRef WITH m.nrodoc
	REPLACE FlgEst WITH 'T'    && Tramite de Aprobacion
	REPLACE FlgUbc WITH 'C'
	REPLACE FlgSit WITH "a"
	** actualizamos control correlativo **
	SELE TDOC
	IF VAL(LsNroDoc)>=NroDoc
		REPLACE NroDoc WITH VAL(LsNroDoc)+1
	ENDIF
	******************************************************
	* SOLO ACTUALIZAMOS SALDOS SI EL CANJE ESTA APROBADO *
	******************************************************
	IF TASG->FlgEst = "E"   && Canje Aprobado
		SELE GDOC
		REPLACE FlgEst WITH 'P'    && Pendiente de Pago
		REPLACE FlgSit WITH "A"
		
	ENDIF
	replace TASG.Glosa1 WITH TRIM(TASG.GLOSA1)+iif(EMPTY(TASG.Glosa1),'',',')+LsNrodoc

ENDIF
SELE GDOC
SET ORDER TO GDOC04

RETURN
*********************************************************************** FIN() *
* Borrando Informacion
***************************************************************************
PROCEDURE xBorrar

IF TASG.FlgCtb
	IF !ctb_aper(TASG.FchDoc)
		SELE TASG
		UNLOCK ALL
		RETURN
	ENDIF
ENDIF
** Verificamos si alguna LETRA presenta problemas al anularla **
OK = .T.
SELECT GDOC
SET ORDER TO GDOC03
SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
	IF FlgEst # [T]   && Letras fuera de transito
		IF ! (FlgEst=[P] .AND. ImpTot=SdoDoc)
			GsMsgErr = [La Letra : ]+NroDoc+[ NO puede ser anulada]
			DO lib_merr WITH 99
			OK = .F.
			EXIT
		ENDIF
	ENDIF
ENDSCAN
SET ORDER TO GDOC04
IF !OK
	RETURN
ENDIF
** FIN DE VERIFICACION DE CONSISTENCIA DE LETRAS **
WAIT "BORRANDO" NOWAIT WINDOW
SELECT TASG
IF !RLOCK()
	RETURN
ENDIF
** DIVIDIMOS LA ANULACION DE ACUERDO A SI HA SIDO APROBADO O NO LOS DOCUMENTOS **
IF TASG->FlgEst <> [A]

	IF TASG->FlgEst = [P]   && Aun no estan aprobadas
		SELECT RASG
		SEEK TASG->coddoc+TASG->nrodoc
		DO WHILE CodDoc+NroDoc = TASG->coddoc+TASG->nrodoc .AND. !EOF()
			IF !RLOCK()
				LOOP
			ENDIF
			DELETE
			UNLOCK
			SKIP
		ENDDO
	ELSE
		SELECT VTOS
		SEEK TASG->coddoc+TASG->nrodoc
		DO WHILE CodDoc+NroDoc = TASG->coddoc+TASG->nrodoc .AND. ! EOF()
			
			IF !RLOCK()
				LOOP
			ENDIF
			SELECT GDOC
			SET ORDER TO GDOC01
			SEEK "CARGO"+VTOS->codref+VTOS->nroref
			IF !RLOCK()
				SELE VTOS
				LOOP
			ENDIF
			LfImpDoc = VTOS->Import
			IF CodMon <> TASG->codmon
				IF TASG->codmon = 1
					LfImpDoc = LfImpDoc / TASG->tpocmb
				ELSE
					LfImpDoc = LfImpDoc * TASG->tpocmb
				ENDIF
			ENDIF
			REPLACE SdoDoc WITH SdoDoc + LfImpDoc
			IF SdoDoc <= 0.01
				REPLACE FlgEst WITH 'C'
			ELSE
				REPLACE FlgEst WITH 'P'
			ENDIF
			REPLACE FlgSit WITH ' '
			UNLOCK
			SELECT GDOC
			SET ORDER TO GDOC04
			* * * *
			SELECT VTOS
			DELETE
			UNLOCK
			SKIP
		ENDDO
	ENDIF


	**
	SELECT GDOC
	SET ORDER TO GDOC03
	SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
	DO WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = ;
	         "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR" .AND. !EOF()
	   ** borramos informacion **
	   IF !RLOCK()
	      LOOP
	   ENDIF
	   SELECT GDOC
	   DELETE
	   UNLOCK
	   SKIP
	ENDDO
	SET ORDER TO GDOC04
	** ANULACION DEL ASIENTO CONTABLE **
	IF TASG.FlgCtb
	   DO xANUL_CTB
	ENDIF
	**
	SELECT TASG
	REPLACE FlgEst WITH 'A'
	REPLACE ImpDoc WITH 0
ELSE
	IF TASG.FlgCtb
	   DO xANUL_CTB
	ENDIF
	SELECT TASG
	DELETE
	IF !EOF()
		SKIP 
	ENDIF
ENDIF

UNLOCK ALL
DO xpanta
RETURN
*********************************************************************** FIN() *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB

XsNroMes = TASG.NroMes
XsCodOpe = TASG.CodOpe
XsNroAst = TASG.NroAst
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !F1_RLOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
*!*	   DO lib_merr WITH 99	VETT 2015-03-04
	=MESSAGEBOX("ERROR : "+gsmsgerr,48,'ATENCION !! / WARNING !!')
   DO ctb_cier
   RETURN
ENDIF
GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst)
SELE VMOV
*DELETE   && Por Ahora
DO ctb_cier

RETURN
******************
PROCEDURE xImprime
******************
=MESSAGEBOX('Prepare la impresora para imprimir letras',0+64,'AVISO !!!' )

SET PROCEDURE TO ccb_ccbr4700 additive

DO imprime IN ccb_ccbr4700 WITH "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"

SET PROCEDURE TO 
SET PROCEDURE TO janesoft,fxgen_2

IF TASG.FlgCtb
    =MESSAGEBOX('Prepare la impresora para imprimir voucher contable',0+64,'AVISO !!!' )
	STORE 0 TO  nimpnac,nimpusa
	IF !ctb_aper(TASG.FchDoc)
		SELE TASG
		UNLOCK ALL
		RETURN
	ENDIF
	XsNroMes = TASG.NroMes
	XsCodOpe = TASG.CodOpe
	XsNroAst = TASG.NroAst
	SELE VMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	DO imprVouc IN Cbd_DiarioGeneral
	DO ctb_cier
ENDIF
SELECT tasg

************************
PROCEDURE Imprime_Letra
************************
** impresion **
SET PROCEDURE TO ccb_ccbr4700 additive
LsLetra=GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
XFOR = ".T."
XWHILE  = "TpoDoc+CodDoc+NroDoc=LsLetra"
Largo  = 27       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "ccbr4700_"+GsSigCia

DO F0print WITH "REPORTS"

SET PROCEDURE TO 
SET PROCEDURE TO janesoft,fxgen_2

