*******************************************************************************
*  Nombre    : CcbLtrB2.PRG                                                   *
*  Autor     : VETT                                                           *
*  Objeto    : Letras por enviar al banco a : Descuento,Cobranza              *
*  Par metros: cFlgSit -> Situacion Final                                     *
*              d : Por Descontar                                              *
*  Creaci¢n  : 28/02/94                                                       *
*  Actualizaci¢n: RHC 17/03/94  Cambio de base de Ctas. Bancarias             *
*                 RHC 03/08/94  Asiento Contable para Descontadas             *
*                 Eduardo Tapia Castillo  / se modif.creaci¢n del Asiento     *
*                 RHC 02/01/95  Pedir Mes y A¤o Contable                      *
*                 RHC 02/03/95  Anular la actualizacion contable por ahora    *
*                 RHC 21/03/95  Modificacion del modulo actual                *
*                 VETT 27/07/95 Control de aprobaci¢n de cobranza o Descuento *
*  Redefinici¢n de Ubicaci¢n y situaci¢n : 27/08/95 VETT                      *
*       FlgUbc                                 FlgSit                         *
*  C--> Cartera                  a --> Por Aceptar     A --> Aceptada         *
*  B--> Banco                    d --> Por descontar   D --> En descuento     *
*  B--> Banco                    c --> Por cobrar      C --> En cobranza      *
*  B--> Banco                    g --> por garantizar  G --> En garant¡a      *
*                 VETT 04/09/95 ingreso con correlativo de planilla bancaria  *
*                 y reporte.                                                  *
*******************************************************************************
PARAMETER cFlgSit
IF VARTYPE(cFlgSit)<>'C'
	cFlgSit = 'c'
ENDIF

IF !verifyvar('GsGasLet','C')
	return
ENDIF

DO CASE 
	CASE INLIST(cFlgSit,'C','c') 
		IF !verifyvar('GsLetCob','C')
			return
		ENDIF
	CASE INLIST(cFlgSit,'D','d') 
	
		IF !verifyvar('GsLetDes','C')
			return
		ENDIF
			
	CASE INLIST(cFlgSit,'G','g') 
		IF !verifyvar('GsLetGar','C')
			return
		ENDIF
		
ENDCASE 

XsCodOpe =  GsLetCob  && [012]
XsCodOpe =  GsLetGar
XsCodOpe =  GsLetDes && [005]

#INCLUDE CONST.H

DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

DO fondo WITH 'Letras',Goentorno.user.login,GsNomCia,GsFecha

sTitulo=[]
XnBanco = []
ScrMov  = []
Crear   = .F.
ZfTotlet = 0
MaxEle1  = 0
STORE '' TO LsNumero,LsPlaza

DO DcbPinta
SAVE SCREEN TO LsScreen
**********************************
* Aperturando Archivos a usar    *
**********************************
LODATADM.ABRIRTABLA('ABRIR','CBDTCNFG','CNFG','CNFG01','')
SELECT CNFG
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
   DO LIB_MERR WITH 99
   USE IN CNFG
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
** VETT:Tope Maximo y Minimo para aplicar Dif.Cambio  - 2015/05/04 12:27:05 ** 
XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.09)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.09)
IF Dif_ME=0 OR Dif_MN=0
	=MESSAGEBOX('Los valores máximos para la generación de ajuste por redondeo de diferencia cambio no estan completos.'+;
				 ' Modificar en la opcion "Configuración de Diferencia de Cambio" en el Menu de Configuración.',0+64,'Aviso importante')
	 
ENDIF
* * * * * *
USE IN CNFG

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
*
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
SELECT CTAS
SET FILTER TO AFTMOV = [S]
*
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC10','')
*
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
*
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
*
LODATADM.ABRIRTABLA('ABRIR','CCBNTASG','TASG','TASG01','')
** BASES DE CONTABILIDAD **
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
** RELACIONES A USAR **
SELECT CTAS
SET RELA TO [04]+codbco INTO TABLA
SELECT GDOC
SET RELA TO GsClfCli+CodCli      INTO AUXI

**********************************
* Inicializando Variables a usar *
**********************************
SELECT GDOC
m.codcta = SPACE(LEN(gdoc->codcta))
m.codbco = SPACE(LEN(GDOC->codbco))
m.nrocta = SPACE(LEN(GDOC->nrocta))
m.tpodoc = "CARGO"
m.coddoc = "LETR"
m.codmon = 1
m.tpocmb = 0
m.flgest = 'P'    && Pendiente
m.flgubc = 'B'    && En Banco
m.NroPla = SPACE(LEN(GDOC->NroPla))
m.TpoPla = [PLET]
* Variables Contables a usar *
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
**XsCodOpe = [005]

DO CASE
   CASE cFlgSit = 'c'
      m.flgsit = 'c'    && Sin movimiento
       xflgsit = 'C'    && Sin movimiento
      m.SitPre = 'A'
      XsCodOpe =  GsLetCob  && [012]
   CASE cFlgSit = 'g'
      m.flgsit = 'g'    && En Garantia
       xflgsit = 'G'    && En Garantia
       XsCodOpe =  GsLetGar
      m.SitPre = 'A'
   CASE cFlgSit = 'd'
      m.flgsit = 'd'    && Por Descontar
      xflgsit  = 'D'    && Descontada
      m.SitPre = 'A'
      XsCodOpe =  GsLetDes && [005]
   ***
   CASE cFlgSit = 'C'
      m.flgsit = 'C'    && Sin movimiento
       xflgsit = 'C'    && Sin movimiento
      m.SitPre = 'c'
      XsCodOpe =  GsLetCob && [005]
   CASE cFlgSit = 'G'
      m.flgsit = 'G'    && En Garantia
       xflgsit = 'G'    && En Garantia
      m.SitPre = 'g'
      XsCodOpe =  GsLetGar
   CASE cFlgSit = 'D'
      m.flgsit = 'D'
      xflgsit  = 'D'    && Descontada
      m.SitPre = 'd'
      XsCodOpe =  GsLetDes && [005]
ENDCASE
** variables a usar en el browse **
m.nrodoc = SPACE(LEN(GDOC->nrodoc))
m.fchubc = DATE()
* Variables del Browse con Arreglo *
CIMAXELE = 20
DIMENSION ANumero(CIMAXELE),APlaza(CIMAXELE),ANuUnico(CIMAXELE)
*
UltTecla = 0
DO WHILE .T.
   DO DcbReadC
   IF UltTecla = Escape_
      EXIT
   ENDIF
   DO DcbCGrba
   RESTORE SCREEN FROM LsScreen
   FLUSH
   UNLOCK ALL
ENDDO

DO CLOSE_FILE IN CCB_CCBAsign
DO ctb_cier
CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)

RETURN
********************************************************************** FIN
* Pintado de Pantalla
***************************************************************************
PROCEDURE DcbPinta

*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*1          Planilla :
*2            Cuenta :
*3             Banco :
*4    Nro. de Cuenta :                             Moneda :

CLEAR
IF _windows OR _mac
	@  0,0 TO 32,110  
ELSE
	@  0,0 TO 22,79  PANEL
endif
DO CASE
   CASE cFlgSit = 'c'
      Titulo = [ ** LETRAS AL BANCO POR ENTRAR A COBRANZA ** ]
   CASE cFlgSit = 'C'
      Titulo = [ ** APROBACION DE LETRAS AL BANCO EN COBRANZA ** ]
   CASE cFlgSit = 'g'
      Titulo = [ ** LETRAS AL BANCO POR ENTRAR EN GARANTIA ** ]
   CASE cFlgSit = 'G'
      Titulo = [ ** APROBACION DE LETRAS AL BANCO EN GARANTIA ** ]
   CASE cFlgSit = 'd'
      Titulo = [ ** LETRAS AL BANCO POR ENTRAR A DESCUENTO ** ]
   CASE cFlgSit = 'D'
      Titulo = [ ** APROBACION DE LETRAS AL BANCO EN DESCUENTO ** ]
ENDCASE
@ 0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "      Planilla : "
@  2,5  SAY "        Cuenta : "
@  3,5  SAY "         Banco : "
@  4,5  SAY "Nro. de Cuenta : "
@  4,50 SAY "Moneda : "
sTitulo = Titulo

RETURN
********************************************************************** FIN
* Editar Datos de Cabecera
***************************************************************************
PROCEDURE DcbReadC
UltTecla = 0
i = 1
Crear = .T.
* buscamos correlativo
IF !SEEK(m.TpoPla,"TDOC")
   WAIT "No existe correlativo" NOWAIT WINDOW
   UltTecla = Escape_
   RETURN
ENDIF
m.NroPla = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(GDOC->NroPla))
m.NroPla1= m.NroPla
**ACTIVATE SCREEN
GsMsgKey = " [Esc] Salir   [F8] Consultar   [Enter] Aceptar  [F6] Listar"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,Escape_)
   DO CASE
      CASE i = 1
         @  1,22 GET m.NroPla PICT "@!"
         READ
         UltTecla = LASTKEY()
         SELE GDOC
         IF UltTecla = F8
            seek M.CODDOC+M.FLGUBC+M.FLGSIT+TRIM(M.NROPLA)
            IF !CcbBusca("0015")
               UltTecla = 0
               LOOP
            ENDIF
            m.NroPla = GDOC.NroPla
            UltTecla = Enter
         ENDIF
         @  1,22 SAY m.NroPla PICT "@!"
         Llave = m.CodDoc+m.FlgUbc+m.FlgSit+m.Nropla
         DO CASE
            CASE UltTecla = Escape_
               EXIT
            CASE UltTecla = 0
               LOOP
            CASE UltTecla = F9
              *IF LLave = m.CodDoc+m.FlgUbc+m.FlgSit+m.Nropla
              *   IF ALRT("Anular planilla")
              *      UltTecla = F9
              *      EXIT
              *   ENDIF
              *ELSE
              *   SEEK LLave
              *   IF ! FOUND()
              *      DO LIB_MERR WITH 9
              *      UltTecla = 0
              *   ELSE
              *      IF ALRT("Anular planilla")
              *         UltTecla = F9
              *         EXIT
              *      ENDIF
              *   ENDIF
              *ENDIF
            CASE UltTecla = F1
            CASE UltTecla = F6
               DO xBANCO
            CASE UltTecla = PgUp                    && Anterior Documento
               IF (m.CodDoc+m.FlgUbc+m.FlgSit)  <> (CodDoc+FlgUbc+FlgSit)
                  SEEK (m.CodDoc+m.FlgUbc+Chr(255))
                  IF RECNO(0) > 0
                     GOTO RECNO(0)
                  ELSE
                     GOTO BOTTOM
                  ENDIF
                  IF (m.CodDoc+m.FlgUbc+m.FlgSit) <> (CodDoc+FlgUbc+FlgSit)
                     SKIP -1
                  ENDIF
               ELSE
                  IF ! BOF()
                     SKIP -1
                  ENDIF
               ENDIF
            CASE UltTecla = PgDn  .AND. ! EOF()     && Siguiente Documento
               SKIP
            CASE UltTecla = Home                    && Primer Documento
               SEEK (m.CodDoc+m.FlgUbc+m.FlgSit)
            CASE UltTecla = End                     && Ultimo Documento
               SEEK (m.CodDoc+m.FlgUbc+m.FlgSit+Chr(255))
               IF RECNO(0) > 0
                  GOTO RECNO(0)
                  SKIP -1
               ELSE
                  GOTO BOTTOM
               ENDIF
            OTHER
               IF m.NroPla < m.NroPla1
                  IF Llave = (CodDoc + FlgUbc + FlgSit + NroPla )
                 *    EXIT
                  ENDIF
                  SEEK LLave
                  IF ! FOUND() .AND. UltTecla = CtrlW
                     ** RESTORE SCREEN FROM ScrMov
                     Crear = .t.
                     EXIT
                  ENDIF
                  IF ! FOUND()
	               	 IF cFlgSit$[CGD]

	               	 	IF SEEK(m.CodDoc+m.FlgUbc+m.SitPre+m.Nropla,'GDOC')
							DO CASE
							   CASE m.SitPre = 'c'
							      GsMsgErr = [ ** ESTA PLANILLA DE LETRAS ESTA POR ENTRAR AL BANCO A COBRANZA ** ]
							   CASE m.SitPre = 'g'
							      GsMsgErr = [ ** ESTA PLANILLA DE LETRAS ESTA POR ENTRAR AL BANCO EN GARANTIA ** ]
							   CASE m.SitPre = 'd'
							      GsMsgErr = [ ** ESTA PLANILLA DE LETRAS ESTA POR ENTRAR AL BANCO A DESCUENTO ** ]
							ENDCASE
	               	 		MESSAGEBOX(GsMsgErr,64,'ATENCION! / WARNING!')
	  	                    UltTecla = 0
	  	                ELSE
		                     DO LIB_MERR WITH 9
		                     
		                     UltTecla = 0
  	                    ENDIF 
                  	 ELSE
	                     DO LIB_MERR WITH 9
	                     
	                     UltTecla = 0
                     ENDIF
                  ELSE
                  ENDIF
               ENDIF
         ENDCASE
         IF (m.CodDoc+m.FlgUbc+m.FLgSit+m.NroPla) <> (CodDoc+FlgUbc+FlgSit+NroPla) .OR. EOF()
            ** RESTORE SCREEN FROM ScrMov
            DO LIB_MTEC WITH 2
            Crear = .t.
         ELSE
            m.NroPla = GDOC->NroPla
            SEEK LLave
            DO DcbPoner
            Crear = .f.
         ENDIF
         @ 1,22 SAY m.NroPla PICT "@!"
         EOF1    = EOF()
         vRegAct = RECNO()
         SEEK LLave
         IF FOUND()
            Crear = .F.
            =SEEK(GDOC.CodCta,"CTAS")
            m.CodCta = GDOC.CodCta
            m.nomcta = CTAS.NomCta
            m.nrocta = CTAS.NroCta
            m.codmon = CTAS.CodMon
            m.codbco = CTAS.CodBco
         ELSE
            IF cFlgSit$[CGD]
               SEEK m.CodDoc+m.FlgUbc+m.SitPre+m.Nropla
               Paso = .F.
               ZfTotLet = 0
               SCAN WHILE CodDoc+FlgUbc+FlgSit+NroPla=m.CodDoc+m.FlgUbc+m.SitPre+m.Nropla
                    IF !Paso
                       =SEEK(GDOC.CodCta,"CTAS")
                        m.CodCta = GDOC.CodCta
                        m.nomcta = CTAS.NomCta
                        m.nrocta = CTAS.NroCta
                        m.codmon = CTAS.CodMon
                        m.codbco = CTAS.CodBco
                        m.FchUbc = GDOC.FchUbc
                        Paso = .T.
                    ENDIF
                    MaxEle1 = MaxEle1 + 1
                    IF ALEN(ANUMERO)<MaxEle1
                    	DIMENSION ANUMERO(MaxEle1 + 5)
                    	DIMENSION APlaza(MaxEle1 + 5)
						DIMENSION ANuUnico(MaxEle1 + 5)                       
                    ENDIF
                    ANumero(MaxEle1)=GDOC.NroDoc
                    APlaza(MaxEle1)=GDOC.Plaza
                    ANuUnico(MaxEle1)=GDOC.Numero
                    ZfTotLet = ZfTotlet + GDOC.ImpTot
               ENDSCAN
               Crear = !Paso
               IF MaxEle1>0
                  @  2,22 SAY codcta+' '+CTAS.nomcta
                  @  3,22 SAY codbco+' '+TABLA->nombre
                  Xnbanco=TABLA->nombre
                  @  4,22 SAY CTAS.nrocta
                  @  4,59 SAY IIF(CTAS.CodMon=1,'S/.','US$')
                  VClave   = m.coddoc+m.flgubc+m.FlgSit+m.NroPla+TRIM(m.CodCta)
                  DO VOUCHER
                  STORE 0 TO ANumero,MaxEle1
                  STORE '' TO APlaza,ANuUnico
               ENDIF
               IF EOF1
                  GO BOTTOM
               ELSE
                  GO vRegAct
               ENDIF
            ELSE
               Crear = .T.
            ENDIF
         ENDIF
      CASE i = 2 AND !Crear
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         EXIT
      CASE i = 2 AND Crear
         SELE CTAS
         @  2,22 GET m.codcta PICT [104]+REPLI('9',LEN(m.codcta)-3)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
            LOOP
         ENDIF
         IF UltTecla = Arriba
            UltTecla = 0
            i = 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(m.CodCta)
            ** ACTIVATE SCREEN
            IF !ccbbusca("MCTA")
               LOOP
            ENDIF
            m.codcta = PADR(CodCta,LEN(GDOC.CodCta))
         ENDIF
         @  2,22 SAY m.codcta
         SEEK m.codcta
         IF !FOUND()
            ** ACTIVATE SCREEN
            GsMsgErr = [ Cuenta Bancaria no Registrada ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF AftMov # [S]
            ** ACTIVATE SCREEN
            GsMsgErr = [ Cuenta no Afecta a Movimientos ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         m.nomcta = CTAS.NomCta
         m.nrocta = CTAS.NroCta
         m.codmon = CTAS.CodMon
         m.codbco = CTAS.CodBco
         @  2,22 SAY m.codcta+' '+m.nomcta
         @  3,22 SAY m.codbco+' '+TABLA->nombre
         Xnbanco=TABLA->nombre
         @  4,22 SAY m.nrocta
         @  4,59 SAY IIF(m.codmon=1,'S/.','US$')
         IF EMPTY(CTAS.Ctades)
            GsMsgErr = "Cuenta de descuento no definida. Avisar a contabilidad"
            DO LIB_MERR WITH 99
           *LOOP
         ENDIF
         IF EMPTY(CTAS.CtaCob)
            GsMsgErr = "Cuenta de Cobranza  no definida. Avisar a contabilidad"
            DO LIB_MERR WITH 99
           *LOOP
         ENDIF
         IF EMPTY(CTAS.CtaCob) .OR. EMPTY(CTAS.CtaDes)
            GsMsgErr = "Actualizar en la opci¢n de Cuentas Bancarias"
            DO LIB_MERR WITH 99
         ENDIF
   ENDCASE
   IF UltTecla = Enter .AND. i = 2
      UltTecla = CtrlW
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO

RETURN
************************************************************************** FIN
* Procedimiento de Grabacion de informacion de Cabezera
******************************************************************************
PROCEDURE DcbCGrba

** Definimos variables a usar en el Browse **
SELECT GDOC
** variables del browse **
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorde
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = ""
EscLin   = ""
GrbLin   = []
EdiLin   = []
Modifica = .F.
IF cFlgSit$'CD'
	EdiLin   = [MOVNEDIT]
	GrbLin   = [MOVNGRAB]			
	Modifica = .T.
ENDIF
BrrLin   = "BROWborr"
InsLin   = ""

Consulta = .F.    && valores iniciales

Adiciona = .F.
Db_Pinta = .F.
MVprgF1  = []
MVprgF2  = [voucher]
MVPrgF3	 = []
MvPrgF4  = []
MVprgF5  = [xListar]
MVprgF6  = [xbanco]
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = "CodDoc+FlgUbc+FlgSit+NroPla+CodCta"
VClave   = m.coddoc+m.flgubc+m.FlgSit+m.NroPla+TRIM(m.CodCta)
HTitle   = 1
Yo       = 7
Xo       = 0
Largo    = 14
Ancho    = 110
TBorde   = Simple
E1 = "    NUMERO        CLIENTE                     FCH. ENVIO     IMPORTE         PLAZA             NRO.UNICO     "
E2 = ""
E3 = ""

*         1         2         3         4         5         6         7			8		  9         1 	      11 
*01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*     NUMERO        CLIENTE                     FCH. ENVIO     IMPORTE         PLAZA             NRO.UNICO     "
*  1234567890   123456789012345678901234567890  99/99/9999  999,999,999.99  12345678901234567  123456789012345
*
LinReg   = [NroDoc+'   '+LEFT(AUXI->nomaux,30)+'  '+;
         DTOC(FchUbc)+'  '+TRANS(Imptot,'999,999,999.99')+ '  '+LEFT(Plaza,17)+'  '+Numero]
Static   = .T.
VSombra  = .F.
SET_ESCAPE=.T.
**

GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso  [F5]Imprimir  [F6]Banco"								
=Pinta_teclas_help()
DO LIB_MTEC WITH 99
DO DBROWSE
**
**
RETURN
******************
PROCEDURE DcbPoner
******************
** Definimos variables a usar en el Browse **
SELECT GDOC
=SEEK(CodCta,"CTAS")
@  2,22 SAY codcta+' '+CTAS.nomcta
@  3,22 SAY codbco+' '+TABLA->nombre
Xnbanco=TABLA->nombre
@  4,22 SAY CTAS.nrocta
@  4,59 SAY IIF(CTAS.CodMon=1,'S/.','US$')

** variables del browse **
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorde
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = ""
EscLin   = ""
EdiLin   = []
BrrLin   = []
InsLin   = ""
GrbLin   = []
Consulta = .T.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
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
NClave   = "CodDoc+FlgUbc+FlgSit+NroPla+CodCta"
VClave   = m.coddoc+m.flgubc+m.FlgSit+m.NroPla+TRIM(m.CodCta)
HTitle   = 1
Yo       = 7
Xo       = 0
Largo    = 14
Ancho    = 110
TBorde   = Simple
E1 = "    NUMERO        CLIENTE                     FCH. ENVIO     IMPORTE         PLAZA             NRO.UNICO     "
E2 = ""
E3 = ""
LinReg   = [NroDoc+'   '+LEFT(AUXI->nomaux,30)+'  '+;
         DTOC(FchUbc)+'  '+TRANS(Imptot,'999,999,999.99')+ '  '+LEFT(Plaza,17)+'  '+Numero]
Static   = .T.
VSombra  = .F.
SET_ESCAPE=.T.
**
** ACTIVATE SCREEN
GsMsgKey = "[Esc] Salir  [Home] [End] [PgUp] [PgDn] Posicionar                 "
DO LIB_MTEC WITH 99
DO DBROWSE
**
**
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE BROWborr

SELE GDOC
IF !RLOCK()
   RETURN
ENDIF
OK = .T.
IF OK
   DO CASE
      CASE cFlgSit$[cgd]
           REPLACE GDOC->flgubc WITH 'C'
           REPLACE GDOC->flgsit WITH 'A'  && Letra Aceptada
           REPLACE GDOC->codcta WITH ' '
           REPLACE GDOC->nrocta WITH ' '
           REPLACE GDOC->codbco WITH ' '
           REPLACE GDOC->fchubc WITH CTOD(SPACE(8))
      CASE cFlgSit$[CGD]
           REPLACE GDOC->flgubc WITH 'B'
           REPLACE GDOC->flgsit WITH LOWER(cFlgSit) && Esperando aprobaci¢n
           IF GDOC.FlgCtb
      			IF !ctb_aper(GDOC.FchUBC)
					SELE GDOC
         			UNLOCK ALL
         			RETURN
      			ENDIF
		   ENDIF
           DO xAnul_CTB
           SELECT GDOC
   ENDCASE
ENDIF
UNLOCK

RETURN
******************************************************************************
************** CAPTA DOCUMENTO DEL BANCO EN UN ARREGLO ***********************
******************************************************************************
PROCEDURE xListar
*****************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "ccbltrb2"
DO F0print WITH "REPORTS"
RETURN
*****************
PROCEDURE xBanco
*****************
** SAVE SCREEN TO BELU
WAIT "Impresi¢n..." NOWAIT WINDOW
PRIVATE m.Codcta
m.CodCta = SPACE(LEN(GDOC.CodCta))
DO LIB_MTEC WITH 11
UltTecla = 0
DO WHILE !INLIST(UltTecla,Escape_,CTRLW)
   SELE CTAS
   @  2,22 GET m.codcta PICT [104]+REPLI('9',LEN(m.codcta)-3)
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F8 .OR. EMPTY(m.CodCta)
      IF !ccbbusca("MCTA")
         LOOP
      ENDIF
      m.CodCta=PADR(CodCta,LEN(GDOC.CodCta))
   ENDIF
   @  2,22 SAY m.codcta
   SEEK m.codcta
   IF !FOUND()
      GsMsgErr = [ Cuenta Bancaria no Registrada ]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   @  2,22 SAY m.codcta+' '+CTAS.nomcta
   @  3,22 SAY CTAS.codbco+' '+TABLA->nombre
   Xnbanco=TABLA->nombre
   @  4,22 SAY CTAS.nrocta
   @  4,59 SAY IIF(CTAS.codmon=1,'S/.','US$')
   IF UltTecla = Enter
      UltTecla = CTRLW
   ENDIF
ENDDO
IF UltTecla = Escape_
   SELE GDOC
   ** REST SCREEN FROM BELU
   UltTecla = 0
   RETURN
ENDIF

SELE GDOC
SET ORDER TO GDOC06
EOF1 = EOF()
bRegAct = RECNO()
SEEK m.CodCta+m.TpoDoc+m.CodDoc+m.FlgEst+m.FlgUbc+m.FlgSit
XFOR   = ".T."
XWHILE = [CodCta+TpoDoc+CodDoc+FlgEst+FlgUbc+FlgSit=;
          m.CodCta+m.TpoDoc+m.CodDoc+m.FlgEst+m.FlgUbc+m.FlgSit]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "ccbltrb3"
DO F0print WITH "REPORTS"
SET ORDER TO GDOC10
IF EOF1
   GO BOTTOM
ELSE
   GO bRegAct
ENDIF
** RESTORE SCREEN FROM BELU
WAIT "Ingreso..." NOWAIT WINDOW
RETURN
*****************
PROCEDURE VOUCHER
*****************
** SAVE SCREEN TO LsPan01

PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "ESCRIBE"
EdiLin   = "LINEAS"
BrrLin   = "BORRA"
InsLin   = "INSERTA"
Yo       = 09
Largo    = 12
Ancho    = 110
Xo       = 0
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
IF Crear
   Tborde   = Nulo
   MaxEle   = 0
   TotEle   = CIMAXELE   && M ximos elementos a usar
   * CARGO EL ARREGLO *
   STORE SPACE(LEN(GDOC.NroDoc)) TO ANumero
   STORE SPACE(LEN(GDOC.Plaza)) TO APlaza
   STORE SPACE(LEN(GDOC.Numero)) TO ANuUnico
ELSE
	EN1 = "    NUMERO        CLIENTE                     FCH. ENVIO     IMPORTE         PLAZA             NRO.UNICO     "
	Tborde   = Simple
   MaxEle   = MaxEle1
   TotEle   = MaxEle1   && M ximos elementos a usar
ENDIF
*
@ 5,40 SAY 'FECHA CONTABLE:'
IF cFlgSit $ [dD]        && Por Descontar
   @ 6,36 SAY 'NETO A ABONAR : '+IIF(m.CodMon=1,'S/.','US$')
ENDIF
UltTecla = 0
PRIVATE nPosi,XnTotLet
nPosi = 1
XnTotLet = ZfTotLet
DO WHILE UltTecla # Escape_
   DO CASE
      CASE nPosi = 1
         @ 5,56 GET m.fchubc PICT "@RD dd/mm/aa"
         READ
         UltTecla = LASTKEY()
      CASE nPosi = 2 .AND. cFlgSit = [D]
         @ 6,56 GET XnTotLet PICT '999,999,999.99' RANGE 0,
         READ
         UltTecla = LASTKEY()
      CASE nPosi = 3
         IF !ctb_aper(m.FchUbc)
            nPosi = 1
            UltTecla = 0
            LOOP
         ENDIF
         m.TpoCmb = 1
         IF SEEK(DTOS(m.FchUbc),"TCMB")
            m.TpoCmb = TCMB.OfiVta
         ENDIF
         DO ABROWSE
         UltTecla=IIF(INLIST(UltTecla,Escape_),Arriba,Enter)
      CASE nPosi = 4
         m.resp = 'N'
         m.resp = aviso(18," Datos Correctos "," Todo bien...Grabamos ",;
              "<S>i o <N>o",3,"SN",0,.F.,.F.,.T.)
         IF m.resp = 'S'
            UltTecla = Enter
            EXIT
         ELSE
            nPosi = 1
            UltTecla = 0
            LOOP
         ENDIF
   ENDCASE
   nPosi = IIF(INLIST(UltTecla,Arriba,BackTab),nPosi-1,nPosi+1)
   nPosi = IIF(nPosi<1,1,nPosi)
   nPosi = IIF(nPosi>4,4,nPosi)
ENDDO
IF UltTecla # Escape_
   cResp = [S]
   cResp = Aviso(12,[ DATOS CORRECTOS (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
   SET STEP ON 
   IF cResp = [S]
      IF Crear
         SELECT TDOC
         SEEK m.TpoPla
         =REC_LOCK(0)
         IF VAL(m.NroPla)>= NroDoc
            REPLACE NroDoc WITH VAL(m.NroPla)+1
         ENDIF
         UNLOCK
      ENDIF
      DO CASE
         CASE cFlgSit$[CGD]
              DO GENERA
         CASE cFlgSit$[cgd]
              DO GENERA2
              DO CASE
                 CASE cFlgSit=[c]
                      LsMsg = [APROBAMOS COBRANZA (S/N) ??]
                 CASE cFlgSit=[g]
                      LsMsg = [APROBAMOS GARANTIA (S/N) ??]
                 CASE cFlgSit=[d]
                      LsMsg = [APROBAMOS DESCUENTO (S/N) ??]
              ENDCASE
              cResp = [S]
              cResp = Aviso(12,LsMsg,[],[],2,'SN',0,.F.,.F.,.T.)
              IF cResp = [S]
                 DO GENERA
              ENDIF
      ENDCASE
   ENDIF
ENDIF
*DO ctb_cier
** Regresamos al browse original **
Listar   = .T.
Refresco = .T.
UltTecla = 0
SELE GDOC
SET ORDER TO GDOC10
SEEK VClave
** RESTORE SCREEN FROM LsPan01
GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F5]Imprimir  [F6]Banco"
=Pinta_teclas_help()
DO LIB_MTEC WITH 99

RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE ESCRIBE
PARAMETERS NumEle, NumLin

@ NumLin,2  SAY ANumero(NumEle)
SELE GDOC
SET ORDER TO GDOC05
SEEK m.flgest+m.tpodoc+m.coddoc+ANumero(NumEle)
*@ NumLin,13 SAY GDOC->codcli
=SEEK(GsClfCli+GDOC->codcli,"AUXI")
@ NumLin,15 SAY AUXI->nomaux PICT "@S30"
@ NumLin,47 SAY m.FchUbc PICT "@RD dd/mm/aa"
@ NumLin,59 SAY GDOC->IMptot PICT "999,999,999.99"
@ NumLin,75 SAY APlaza(NumEle) PICT "@S17" 
@ NumLin,94 SAY ANuUnico(NumeLe) PICT "@S15" 
SET ORDER TO GDOC10

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE BORRA
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   ANumero(i) = ANumero(i+1)
   APlaza(i)  = APlaza(i+1)
   ANuUnico(i) = ANuUnico(i+1)	
   i = i + 1
ENDDO
ANumero(i) = SPACE(LEN(GDOC->NroDoc))
APlaza(i)  = SPACE(15) && SPACE(LEN(GDOC->Plaza))
ANuUnico(i) = SPACE(LEN(GDOC.Numero))

Estado = .T.

RETURN
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE INSERTA
PARAMETERS ElePrv, Estado

PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   ANumero(i) = ANumero(i-1)
   APlaza(i)  = APlaza(i-1)
   ANuUnico(i) = ANuUnico(i-1)	
   
   i = i - 1
ENDDO
i = ElePrv + 1
ANumero(i) = SPACE(LEN(GDOC->NroDoc))
APlaza(i)  = SPACE(15) && SPACE(LEN(GDOC->Plaza))
ANuUnico(i) = SPACE(LEN(GDOC.Numero))
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE LINEAS
PARAMETERS NumEle, NumLin, LiUtecla

PRIVATE i,LinAct
LsNroDoc = ANumero(NumEle)
LsPlaza	 = APlaza(NumEle)
LsNumero = ANuUnico(NumEle)
UltTecla = 0
LinAct = NumLin
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,Escape_)
   DO CASE
      CASE i = 1
         GsMsgKey = " [Esc] Salir   [Enter] Registrar   [F8] Consulta"
         DO lib_mtec WITH 99
         SELE GDOC
         SET ORDER TO GDOC07
         @ LinAct,2  GET LsNroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
            SET ORDER TO GDOC10
            LOOP
         ENDIF
         IF UltTecla = F8

            IF !ccbbusca("0014")
               SET ORDER TO GDOC10
               LOOP
            ENDIF
            LsNroDoc = GDOC->NroDoc
         ENDIF
         @ LinAct,2  SAY LsNroDoc
         ** verificamos que no se repita el dato **
         SET ORDER TO GDOC10
         SEEK m.coddoc+m.flgubc+m.flgsit+m.NroPla+m.codcta+m.tpodoc+m.flgest+LsNroDoc
         IF FOUND()
            WAIT "Dato ya registrado" NOWAIT WINDOW
            LOOP
         ENDIF
         SET ORDER TO GDOC05
         SEEK m.flgest+m.tpodoc+m.coddoc+Lsnrodoc
         IF !FOUND()
            SET ORDER TO GDOC10
            WAIT "Dato Invalido" NOWAIT WINDOW
            LOOP
         ENDIF
         
		 	         
         
         IF INLIST(GsSigCia,'AROMAS','QUMICA') AND cFlgSit$[cgd] AND !(GDOC->FlgUbc =[C] .AND. GDOC->FlgSit=[A]) AND ; 
         				DTOS(GDOC.FCHDOC)<='20060518' AND !(GDOC->FlgUbc =[B] .AND. GDOC->FlgSit=UPPER(cFlgSit))

       		IF MESSAGEBOX('Este documento pertenece al sistema anterior, posiblemente sea necesario'+CRLF+;
       		 		     'cambiar su estado para que el sistema lo pueda procesar, Desea Continuar ?',4+32,'ATENCION !!!') = 6
       				=RLOCK()
       				REPLACE FlgUbC WITH 'C'
       				REPLACE FlgSit WITH 'A'
       				UNLOCK
       		ENDIF
         ENDIF
         
         
         IF cFlgSit$[cgd]
            IF !(GDOC->FlgUbc =[C] .AND. GDOC->FlgSit=[A])
               IF (GDOC->FlgUbc =[B] .AND. GDOC->FlgSit=UPPER(cFlgSit))
                  DO CASE
                     CASE cFlgSit=[c]
                          LsMsg=[cobranza]
                     CASE cFlgSit=[d]
                          LsMsg=[descuento]
                     CASE cFlgSit=[g]
                          LsMsg=[garant¡a]
                  ENDCASE
                  WAIT "Letra ya esta en el banco en "+LsMsg  NOWAIT WINDOW
                  SET ORDER TO GDOC10
                  LOOP
               ENDIF
               WAIT "Letra no esta en cartera" NOWAIT WINDOW
               SET ORDER TO GDOC10
               LOOP
            ENDIF
         ELSE
            IF !(GDOC->FlgUbc =[B] .AND. GDOC->FlgSit=LOWER(cFlgSit))
               DO CASE
                  CASE cFlgSit=[C]
                       LsMsg=[a cobranza]
                  CASE cFlgSit=[D]
                       LsMsg=[a descuento]
                  CASE cFlgSit=[G]
                       LsMsg=[a garant¡a]
               ENDCASE
               WAIT "Letra debe entrar en estado previo "+LsMsg  NOWAIT WINDOW
               SET ORDER TO GDOC10
               LOOP
            ENDIF
         ENDIF
         IF GDOC->codmon # m.codmon
            WAIT "No es posible asignar letra en diferente moneda que el banco" NOWAIT WINDOW
            SET ORDER TO GDOC10
            LOOP
         ENDIF
         m.codcli = GDOC->codcli
         =SEEK(GsClfCli+m.codcli,"AUXI")
         m.nomcli = AUXI->nomaux
         m.imptot = GDOC->IMptot
         STORE RECNO() TO m.nroreg
         SET ORDER TO GDOC10
         GO m.nroreg
         IF !RLOCK()
            LOOP
         ENDIF
         @ LinAct,15 SAY LEFT(m.nomcli,30)
         @ LinAct,59 SAY m.imptot PICT "999,999,999.99"
   CASE i = 2 
   		@ LinAct,75 GET LsPlaza pict "@S17" 
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
            SET ORDER TO GDOC10
            LOOP
         ENDIF

   CASE i = 3
		@ LinAct,94 GET LsNumero pict "@S15" 
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
            SET ORDER TO GDOC10
            LOOP
         ENDIF
     
         IF UltTecla = Enter
            EXIT
         ENDIF
         
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>3,1,i)
ENDDO
IF UltTecla <> Escape_
   ANumero(NumEle)	= LsNroDoc
   APlaza(NumEle)	= LsPlaza
   ANuUnico(NumEle)	= LsNumero
ENDIF
LiUtecla = UltTecla

RETURN
******************************************************************************
* Objeto : GRABAR ARREGLO EN GDOC Y CONTABILIDAD
******************************************************************************
PROCEDURE GENERA
PRIVATE XdFchPed,GlInterface,XsCodDiv,TsCodDiv1,XcAfecto
PRIVATE XsCodCco ,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
PRIVATE XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = ''

dimension vcodcta(10)
STORE {} TO XdFchPed
STORE '' TO XsCodCco ,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
** Valores variables inicializados como NUMERO
STORE 0 TO NumCta

* Actualizamos cabecera *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef,XsClfAux
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa
XiNroItm = 0
XcEliItm = SPACE(LEN(RMOV.EliItm))
nImpNac  = 0
nImpUsa  = 0

IF !xHeader()
   RETURN
ENDIF
* Actualizamos detalles *
FOR U = 1 TO MaxEle
   LsNroDoc = ANumero(U)
   SELE GDOC
   SET ORDER TO GDOC05
   SEEK m.flgest+m.tpodoc+m.coddoc+LsNroDoc
   LlRlock = .F.
   LlRlock = REC_LOCK(0)
   REPLACE GDOC->flgubc WITH m.flgubc
   REPLACE GDOC->flgsit WITH xFlgSit
   REPLACE GDOC->NroPla WITH m.NroPla
   REPLACE GDOC->codcta WITH m.codcta
   REPLACE GDOC->nrocta WITH m.nrocta
   REPLACE GDOC->codbco WITH m.codbco
   REPLACE GDOC->fchubc WITH m.fchubc
   REPLACE GDOC.Plaza	WITH APlaza(U)
   REPLACE GDOC.Numero  WITH ANuUnico(U)
   IF xFlgSit $ [C|D]    && Al banco en Cobranza o Descontada
      DO xBody
   ENDIF
   SELE GDOC
   UNLOCK
NEXT
DO Imprvouc IN Ccb_Ctb

RETURN
********************************************************************** FIN() *
*************** RUTINAS DE ACTUALIZACION DE CONTABILIDAD *********************
******************************************************************************
PROCEDURE GENERA2
*****************
* Actualizamos detalles *
FOR U = 1 TO MaxEle
   LsNroDoc = ANumero(U)
   SELE GDOC
   SET ORDER TO GDOC05
   SEEK m.flgest+m.tpodoc+m.coddoc+LsNroDoc
   LlRlock = .F.
   LlRlock = REC_LOCK(0)
   REPLACE GDOC->NroPla WITH m.NroPla
   REPLACE GDOC->flgubc WITH m.flgubc
   REPLACE GDOC->flgsit WITH m.flgsit
   REPLACE GDOC->codcta WITH m.codcta
   REPLACE GDOC->nrocta WITH m.nrocta
   REPLACE GDOC->codbco WITH m.codbco
   REPLACE GDOC->fchubc WITH m.fchubc
   REPLACE GDOC.Plaza	WITH APlaza(U)
   REPLACE GDOC.Numero  WITH ANuUnico(U)
   SELE GDOC
   UNLOCK
NEXT
RETURN
*****************
PROCEDURE xHeader
*****************
SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN .F.
ENDIF
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = gosvrcbd.NROAST()
SELECT VMOV
SEEK (XsNroMes + XsCodOpe + XsNroAst)
IF FOUND()
   DO LIB_MERR WITH 11
   RETURN .F.
ENDIF
APPEND BLANK
IF ! Rec_Lock(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN .F.          && No pudo bloquear registro
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
REPLACE VMOV->NROMES WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->NroAst WITH XsNroAst
REPLACE VMOV->FLGEST WITH "R"
replace vmov.fchdig  with date()
replace vmov.hordig  with time() 

SELECT OPER
gosvrcbd.NROAST(XsNroAst)
SELECT VMOV
REPLACE VMOV->FchAst  WITH m.FchUbc
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH m.CodMon
REPLACE VMOV->TpoCmb  WITH m.TpoCmb
REPLACE VMOV->NotAst  WITH [LETRA EN ]+IIF(xFlgSit=[D],[DESCUENTO ],[COBRANZA ])+[ AL BANCO ]+XnBanco+" PLANILLA:"+m.NroPla
REPLACE VMOV->Digita  WITH GsUsuario
* Actualizamos la 1ra. cuenta del banco *
ZsGloDoc = []
ZfTotLet = 0
ZsGlodoc = ZsGloDoc + "PLAN:"+m.NroPla
DO CASE
   CASE xFlgSit = "D"
        ZsGlodoc = "L. EN DESCUENTO,"
   CASE xFlgSit = "C"
        ZsGlodoc = "L. EN COBRANZA ,"
   CASE xFlgSit = "G"
        ZsGlodoc = "L. EN GARANTIA ,"
ENDCASE

FOR K = 1 TO MaxEle
    ZsNroDoc = ANumero(K)
    SELE GDOC
    SET ORDER TO GDOC05
    SEEK m.flgest+m.tpodoc+m.coddoc+ZsNroDoc
    ZfTotLet = ZfTotLet + GDOC->Imptot
NEXT
IF xFlgSit = [D]        && Descontada
   * 1er. REGISTRO (Cuenta del Banco) *
   XcEliItm = SPACE(LEN(RMOV.EliItm))
   XdFchAst = VMOV.FchAst
   XsNroVou = VMOV.NroVou
   XiCodMon = VMOV.CodMon
   XfTpoCmb = VMOV.TpoCmb
   XsGloDoc = ZsGloDoc
   XdFchDoc = XdFchAst
   XdFchVto = XdFchAst
   XsCodCta = m.CodCta
   XsCodRef = SPACE(LEN(RMOV.CodRef))
   XsCodAux = SPACE(LEN(RMOV.CodAux))
   XsClfAux = SPACE(LEN(RMOV.ClfAux))
   XcTpoMov = [D]    && << OJO <<
   XfImport = IIF(XnTotLet<=0,ZfTotLet,XnTotLet)
   IF XiCodMon = 1
   	  XfImpNac = XfImport
      IF XfTpoCmb > 0
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
   DO MovbVeri IN ccb_ctb
ENDIF
IF ZfTotLet>XnTotLet AND XnTotLet<>0
   XcEliItm = SPACE(LEN(RMOV.EliItm))
   XdFchAst = VMOV.FchAst
   XsNroVou = VMOV.NroVou
   XiCodMon = VMOV.CodMon
   XfTpoCmb = VMOV.TpoCmb
   XsGloDoc = ZsGloDoc
   XdFchDoc = XdFchAst
   XdFchVto = XdFchAst
   =SEEK("NC"+GsGasLet,"TABLA")
   XsCodCta = TABLA.CodCta
   XsCodRef = SPACE(LEN(RMOV.CodRef))
   XsCodAux = SPACE(LEN(RMOV.CodAux))
   XsClfAux = SPACE(LEN(RMOV.ClfAux))
   XcTpoMov = [D]    && << OJO <<
   XfImport = ABS(ZfTotlet - XnTotLet)
   IF (ZfTotlet - XnTotLet) < 0
      XcTpoMov = "H"
   ENDIF
   IF XiCodMon = 1
		XfImpNac = XfImport   			
      IF XfTpoCmb > 0
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
   DO MovbVeri IN ccb_ctb
ENDIF
RETURN .T.
************************************************************************ FIN *
* Grabamos detalle
************************************************************************ FIN *
PROCEDURE xBody
IF xFlgSit = [D]        && Descuento
   XsCodCta = [124]+SUBST(m.CodCta,4,2)
   =SEEK(m.CodCta,"CTAS")
   XsCodCta = CTAS.CtaDes       && << OJO >>
ELSE                    && Cobranza
   =SEEK(m.CodDoc,"TDOC")
   XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta)) && TDOC.CodCta
ENDIF
** ACTUALIZAR DATOS DE CABECERA **
REPLACE GDOC.NroMes WITH XsNroMes
REPLACE GDOC.CodOpe WITH XsCodOpe
REPLACE GDOC.NroAst WITH XsNroAst
REPLACE GDOC.FlgCtb WITH .T.
* * * * * * * * * * * * * * * * * *
* Barremos el detalle *
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = IIF(xFlgSit=[D],VMOV.TpoCmb,GDOC.TpoCmb)
XsGloDoc = AUXI->NomAux
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
** Grabamos las cuentas de detalle **
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XsCodAux = SPACE(LEN(RMOV.CodAux))
IF CTAS.PidAux=[S]
   XsClfAux = CTAS.ClfAux
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [H]    && << OJO <<
XfImport = GDOC.Imptot
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb > 0
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
IF CTAS.PidDoc=[S]
	XsCodDoc = GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = GDOC.NroDoc
	** VETT:Debe reflejar la fecha de emision y vencimiento de la letra tal como en cuentas x cobrar - 2015/05/04 12:54:29 ** 
	XdFchDoc = GDOC.FchDoc
	XdFchVto = GDOC.FchVto
ENDIF
IF CTAS.AftDcb = [S] .AND. xFLgSit = [D]
   DO DIFCMB
ELSE
   DO MovbVeri IN ccb_ctb
ENDIF
* Generamos la cuenta refleja *
IF xFlgSit = [C]        && Al banco en cobranza
   =SEEK(m.CodCta,"CTAS")
  *XsCodCta = [127]+SUBST(m.CodCta,4,2)
   XsCodCta = CTAS.CtaCob
   XcEliItm = SPACE(LEN(RMOV.EliItm))
   XdFchAst = VMOV.FchAst
   XsNroVou = VMOV.NroVou
   XiCodMon = GDOC.CodMon
   XfTpoCmb = GDOC.TpoCmb
   XsGloDoc = AUXI->NomAux
   ** VETT:Debe reflejar la fecha de emision y vencimiento de la letra tal como en cuentas x cobrar - 2015/05/04 12:54:29 ** 
	XdFchDoc = GDOC.FchDoc
	XdFchVto = GDOC.FchVto
   ** Grabamos las cuentas de detalle **
   XsCodRef = SPACE(LEN(RMOV.CodRef))
   XsClfAux = SPACE(LEN(RMOV.ClfAux))
   XsCodAux = SPACE(LEN(RMOV.CodAux))
   =SEEK(XsCodCta,"CTAS")
   IF CTAS.PidAux=[S]
      XsClfAux = CTAS.ClfAux
      XsCodAux = GDOC.CodCli
   ENDIF
   XcTpoMov = [D]    && << OJO <<
   XfImport = GDOC.Imptot
   IF XiCodMon = 1
   		XfImpNac = XfImport
      IF XfTpoCmb > 0
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
   IF CTAS.PidDoc=[S]
      XsCodDoc = GDOC.CodDoc
      XsNroDoc = GDOC.NroDoc
      XsNroRef = GDOC.NroDoc
   ENDIF
   DO MovbVeri IN ccb_ctb
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB    && yuca metida ay que rico
XsNroMes = GDOC.NroMes
XsCodOpe = GDOC.CodOpe
XsNroAst = GDOC.NroAst
LlReturn = .F.
IF EMPTY(XsNroMes) OR EMPTY(XsCodOpe) OR EMPTY(XsNroAst)
	=MESSAGEBOX('Datos del asiento contable no estan completos',0+64,'AVISO !!!')
	RETURN .F.
ENDIF

SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !REC_LOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
   DO lib_merr WITH 99
   DO ctb_cier
   RETURN .f.
ENDIF
DO MOVBorra IN ccb_ctb
SELE VMOV
**DELETE   && Por Ahora
LlReturn = .T.
DO ctb_cier
RETURN 
************************************************************************ FIN *
* Asiento por diferencia de cambio
******************************************************************************
PROCEDURE DIFCMB

* buscamos saldo actual del documento *
PRIVATE xCodMon,xTpoCmb,LfImport,LfImpUsa
xCodMon = GDOC.CodMon
xTpoCmb = GDOC.TpoCmb
IF GDOC.CodMon = 1
   LfImport = GDOC.IMptot
   IF xTpoCmb>0
      LfImpUsa = ROUND(LfImport/xTpoCmb,2)
   ELSE
      LfImpUsa = 0
   ENDIF
ELSE
   LfImpUsa = GDOC.IMptot
   LfImport = ROUND(LfImpUsa*xTpoCmb,2)
ENDIF
* Verificando la cancelaci¢n del documento *
OK = .T.
IF xCodMon = 1  && Moneda Original
   OK = .F.    && NO GENERA DIF. CAMBIO POR TRASLACION
   IF ABS(LfImport-IIF(XcTpoMov="H",1,-1)*XfImport) > 0.90   && Ajuste y Matar puchos
      oK = .F.
   ENDIF
ELSE
   IF ABS(LfImpUsa-IIF(XcTpoMov="H",1,-1)*XfImpUsa) > 0.10   && Ajuste y Matar puchos
      oK = .F.
   ENDIF
ENDIF
* Grabando el Documento *
IF OK
   XfImpUsa = LfImpUsa
   XfImport = LfImport
ENDIF
DO MovbVeri IN ccb_ctb
IF ! OK
   RETURN
ENDIF
* Calculando REDONDEO y DIFERENCIA DE CAMBIO *
IF XiCodMon = 1
   IF TpoMov = "H"
      LfImport = Import - GDOC.IMptot
      LfImpUsa = ImpUsa - ROUND(GDOC.ImpTot/XfTpoCmb,2)
   ELSE
      LfImport = - Import - GDOC.imptot
      LfImpUsa = - ImpUsa - ROUND(GDOC.Imptot/XfTpoCmb,2)
   ENDIF
ELSE
   IF TpoMov = "H"
      LfImport = Import - ROUND(GDOC.imptot*XfTpoCmb,2)
      LfImpUsa = ImpUsa - GDOC.ImpTot
   ELSE
      LfImport = -Import - ROUND(GDOC.imptot*XfTpoCmb,2)
      LfImpUsa = -ImpUsa - GDOC.ImpTot
   ENDIF
ENDIF
* Grabando el redondeo y el ajuste *
XcEliItm = "ð"
XfImpUsa = LfImpUsa
XfImport = LfImport
**-------------------*** Vett 24/jun/2000
XfDcbUsa = LfImpUsa
XfDcbNac = LfIMport
**-------------------***  Importes de dif.cmb

IF XfDcbNac # 0
   IF XfDcbNac > 0
      XsCodCta = XsCdCta1
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XsCodAux = ""
      XcTpoMov = [D]
      **-------------------***
      XfImport = XfDcbNac
      XfIMpUsa = 0
      **-------------------***
   ELSE
      **-------------------***
      XfImpUsa = 0
      XfImport = -XfDcbNac
      **-------------------***
      XsCodCta = XsCdCta2
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XcTpoMov = [H]
      XsCodAux = XsCdAux2
   ENDIF
   DO MovbVeri IN ccb_ctb
ENDIF
IF XfDcbUsa # 0
   IF XfDcbUsa > 0
      XsCodCta = XsCdCta1
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XsCodAux = ""
      XcTpoMov = [D]
 	  **-------------------***	  
      XfImpUsa = XfDcbUsa
      XfImport = 0
      **-------------------***
   ELSE
 	  **-------------------***	  
      XfImpUsa = -XfDcbUsa
      XfImport = 0
      **-------------------***
      XsCodCta = XsCdCta2
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XcTpoMov = [H]
      XsCodAux = XsCdAux2
   ENDIF
   DO MovbVeri IN ccb_ctb
ENDIF

RETURN
************************************************************************ FIN *
PROCEDURE Listar_QUIMICA
************************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "Liqui_Cobrab2"
DO F0print WITH "REPORTS"
RETURN

***********************
PROCEDURE Listar_Aromas
***********************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "Liqui_Cobrab1"
DO F0print WITH "REPORTS"
return

***************************
PROCEDURE Pinta_teclas_help
***************************
DO CASE
	CASE cFlgSit$'cC'
		DO CASE 
			CASE GsSigCia='QUIMICA'
				MVprgF3  = [Listar_Quimica]
				GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso [F3]Bco."+GsSigCia+" [F5]Imprimir  [F6]Banco"
			CASE GsSigCia='AROMAS'	
				MVprgF3  = [Listar_Aromas]
				GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso [F3]Bco."+GsSigCia+" [F5]Imprimir  [F6]Banco"				
			OTHERWISE
				MVprgF3  = []
				GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso  [F5]Imprimir  [F6]Banco"								
		ENDCASE		
	CASE cFlgSit$'dD'
		DO CASE 
			CASE GsSigCia='QUIMICA'
				MVprgF3  = [BCP_Quimica]
				MvPrgF4  = [Bco_Interbank]
				MvPrgF5  = [Bco_Conti]
				GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso [F3]Bco."+GsSigCia+" [F4]Bco.Interbank  [F5]Bco.Continental  [F6]Banco"
			CASE GsSigCia='AROMAS'	
				MVprgF3  = [BCP_Aromas]
				MvPrgF4  = [Bco_Interbank]
				MvPrgF5  = [Bco_Conti]
				GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso [F3]Bco."+GsSigCia+" [F4]Bco.Interbank  [F5]Bco.Continental  [F6]Banco"				
			OTHERWISE
				MVprgF3  = []
				GsMsgKey = "[Esc]Salir  [Home][End][PgUp][PgDn]Posicionar  [F2]Ingreso  [F5]Imprimir  [F6]Banco"								
		ENDCASE		
	
	
ENDCASE 
*********************
PROCEDURE BCP_QUIMICA
*********************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "liqui_descuentoq"
DO F0print WITH "REPORTS"
RETURN

*********************
PROCEDURE BCP_AROMAS
*********************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "liqui_descuento"
DO F0print WITH "REPORTS"
RETURN

***********************
PROCEDURE Bco_Interbank
***********************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "liqui_descuento2"
DO F0print WITH "REPORTS"
RETURN

***********************
PROCEDURE Bco_Conti
***********************
m.CodCta=PADR(m.CodCta,LEN(GDOC.CodCta))
SEEK VClave
XFOR   = ".T."
XWHILE = [CodDoc+FlgUbc+FlgSit+CodCta+NroPla=;
          m.CodDoc+m.FlgUbc+m.FlgSit+m.CodCta+m.NroPla]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "liqui_descuento3"
DO F0print WITH "REPORTS"
RETURN

*************************************************************************** FIN
* Procedimiento Para Edici¢n
******************************************************************************
PROCEDURE MOVNEDIT
******************
SELECT GDOC
LsNumero   = Numero
LsPlaza  = Plaza
i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
   DO CASE
   CASE i = 2 
   		@ LinAct,75 GET LsPlaza pict "@S17" 
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
            LOOP
         ENDIF

   CASE i = 3
		@ LinAct,94 GET LsNumero pict "@S15" 
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
            LOOP
         ENDIF
   
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5, 5, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT GDOC
DO LIB_MTEC WITH 14
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE MOVNGRAB
******************
IF ! RLOCK()
   RETURN
ENDIF
REPLACE Numero    WITH LsNumero
REPLACE Plaza     WITH LsPlaza
UNLOCK ALL
RETURN
