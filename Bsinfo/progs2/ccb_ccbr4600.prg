**************************************************************************
*  Nombre       : ccbr4600.prg
*  Proposito    : Analisis de Movimiento por Documento
*  Autor        : VETT
*  Creaci╒n     : 11/04/94
*  Actualizaci╒n: VETT 2006/05/05
* Modifcado por VETT 2008/09/23 15:45:41 
* Modifcado por VETT 2013/11/14 15:45:41 
**************************************************************************
SYS(2700,0)
** pantalla de datos **
DO fondo WITH 'Movimientos por documento',Goentorno.user.login,GsNomCia,GsFecha
STORE '' TO XsPanta01
AnchoBrow1 = 115   && Control ancho rutina aBrowse 
DO xPanta
SAVE SCREEN TO LsPan4600
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')




SELECT CTAS 
SET FILTER TO AftMov = [S]
SET RELA TO [04]+codbco INTO TABLA
SELE GDOC
SET FILTER TO tpovta<>3
SET RELA TO GsClfCli+CodCli INTO CLIE
SET RELA TO CodCta INTO CTAS ADDITIVE
** variables a usar **
PRIVATE XsTpoDoc+XsCodDoc+XsNroDoc
XsTpoDoc = [CARGO]
XsCodDoc = SPACE(LEN(GDOC->CodDoc))
XsNroDoc = SPACE(LEN(GDOC->NroDoc))
XsCodCta = SPACE(LEN(CTAS.CodCta))
PRIVATE AdFcHdoc,AsCodDoc,AsNroDoc,AcTpoDoc,AiCodMon,AfImport,CIMAXELE,AsGloDoc

CIMAXELE = 50
DIMENSION AdFchDoc(CIMAXELE)
DIMENSION AsCodDoc(CIMAXELE)
DIMENSION AsNroDoc(CIMAXELE)
DIMENSION AsCodCli(CIMAXELE)
DIMENSION AcTpoDoc(CIMAXELE)
DIMENSION AiCodMon(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
DIMENSION AnNroReg(CIMAXELE)
DIMENSION AsTabla(CIMAXELE)
DIMENSION AsGloDoc(CIMAXELE)
STORE CTOD(SPACE(10))           TO AdFchDoc
STORE SPACE(LEN(GDOC->CodDoc)) TO AsCodDoc
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroDoc
STORE SPACE(LEN(GDOC->CodCli)) TO AsCodCli
STORE [ ]                      TO AcTpoDoc
STORE 0                        TO AiCodMon
STORE 0                        TO AfImport
STORE 0                        TO AnNroReg
STORE [ ]                      TO AsTabla
STORE SPACE(LEN(GDOC->GloDoc)) TO AsGloDoc

STORE '' TO LsAliasDocs,LsLlave,LsWhile

** Logica Principal **
LlPrimera = .t.
UltTecla = 0
DO WHILE .T.
	IF LlPrimera
	   RESTORE SCREEN FROM LsPan4600
	   DO xInvar
	   LlPrimera = .F.
   endif
   DO xLlave
   IF UltTecla = escape_
      EXIT
   ENDIF
   DO xPoner
ENDDO

IF USED('CTAS')
	USE IN CTAS
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
IF USED('RDOC')
	USE IN RDOC
ENDIF
IF USED('TDOC')
	USE IN TDOC
ENDIF
IF USED('CBDMAUXI')
	USE IN CBDMAUXI
ENDIF

IF USED('SLDO')
	USE IN SLDO
ENDIF
IF USED('TABLA')
	USE IN TABLA
ENDIF
IF USED('VPRO')
	USE IN VPRO
ENDIF
IF USED('RMOV')
	USE IN RMOV
ENDIF

CLEAR MACROS
CLEAR
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,0)
RELEASE LoDatAdm
RETURN
********************************************************************* EOP() *
* Objeto : Pintar Pantalla
*****************************************************************************
PROCEDURE xPanta

*           1         2         3         4         5         6         7
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*1здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*2Ё    Documento   : FACT                       Fecha Emision : 99/99/99         Ё
*3Ё    Nёmero      : 1234567890                 Fecha Vencto. : 99/99/99         Ё
*4Ё    Cliente     : 12345                                                       Ё
*5Ё    Nombre      :                                                             Ё
*6Ё    Estado      : Pendiente                      Moneda    : S/.              Ё
*7Ё    Ubicaci╒n   : En Cartera                     Importe   :                  Ё
*8Ё    Situaci╒n   : Protestada                     Saldo     : 999,999,999.99   Ё
*9Ё    Banco       :                                                             Ё
*0Ё    # de Cuenta :                                                             Ё
*1цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*2Ё   Fecha   Doc.   Nёmero                   Mon      Cargos          Abonos    Ё
*3цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*4Ё 99/99/99  1234  123456789 ............... S/. 999,999,999.99  999,999,999.99 Ё
*5Ё                                                                              Ё
*6Ё                                                                              Ё
*7Ё                                                                              Ё
*8Ё                                                                              Ё
*9Ё                                                                              Ё
*0Ё                                                                              Ё
*1Ё                                                                              Ё
*2юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*
CLEAR
@  1,0  SAY "зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
@  2,0  SAY "Ё    Documento   :                            Fecha Emision :                                                     Ё"
@  3,0  SAY "Ё    Nёmero      :                            Fecha Vencto. :                                                     Ё"
@  4,0  SAY "Ё    Cliente     :                                                                                                Ё"
@  5,0  SAY "Ё    Nombre      :                                                                                                Ё"
@  6,0  SAY "Ё    Estado      :                                Moneda    :                                                     Ё"
@  7,0  SAY "Ё    Ubicaci╒n   :                                Importe   :                                                     Ё"
@  8,0  SAY "Ё    Situaci╒n   :                                Saldo     :                                                     Ё"
@  9,0  SAY "Ё    Banco       :                                Planilla  :                                                     Ё"
@ 10,0  SAY "Ё    # de Cuenta :                                                                                                Ё"
@ 11,0  SAY "Ё    Plaza       :                                Nro.Unico :                                                     Ё"
@ 12,0  SAY "Ё    # Canje     :            Documento(s):                                                                       Ё"
@ 13,0  SAY "цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
@ 14,0  SAY "Ё   Fecha       Doc.   Nёmero      Cod.Cli.     Mon       Cargos          Abonos         ObservaciСn              Ё"
@ 15,0  SAY "цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
@ 16,0  SAY "Ё                                                                                                                 Ё"
@ 17,0  SAY "Ё                                                                                                                 Ё"
@ 18,0  SAY "Ё                                                                                                                 Ё"
@ 19,0  SAY "Ё                                                                                                                 Ё"
@ 20,0  SAY "Ё                                                                                                                 Ё"
@ 21,0  SAY "Ё                                                                                                                 Ё"
@ 22,0  SAY "Ё                                                                                                                 Ё"
@ 23,0  SAY "Ё                                                                                                                 Ё"
@ 24,0  SAY "юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
Titulo = [ ** ANALISIS DE MOVIMIENTOS POR DOCUMENTO ** ]
@  0,(AnchoBrow1-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 14,1 SAY   "   Fecha       Doc.   Nёmero      Cod.Cli.     Mon      Cargos          Abonos         ObservaciСn               " COLOR SCHEME 7
SAVE SCREEN TO XsPanta01
RETURN
********************************************************************* FIN() *
* Objeto : Leer Llave
*****************************************************************************
PROCEDURE xLlave
RESTORE SCREEN FROM XsPanta01
SELE GDOC
SET ORDER TO GDOC01
* * * *
PRIVATE i
UltTecla = 0
i = 1
DO WHILE UltTecla # escape_
   DO CASE
      CASE i = 1
      	 RESTORE SCREEN FROM XsPanta01
         SELE TDOC
         @ 2,19 GET XsCodDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
            IF ! ccbbusca("TDOC")
               LOOP
            ENDIF
            XsCodDoc = CodDoc
         ENDIF
         SEEK XsCodDoc
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         XsTpoDoc = TpoDoc    && << OJO <<
         @ 2,19 SAY XsCodDoc
      CASE i = 2
      	 IF !INLIST(XsCodDoc,'PROF','NCPR','ANPR')
			SELECT GDOC
   			LsAliasDocs = 'GDOC'
			LsLlave = XsTpoDoc+XsCodDoc
			LsWhile = [TpoDoc=XsTpoDoc AND CodDoc=XsCodDoc]
			IF USED('VPRO')			
				 SELECT VPRO
				 SET RELATION TO	
		         SELE GDOC
	           	 SET RELA TO GsClfCli+CodCli INTO CLIE
           	ENDIF
           	 XsPICT='@S'+REPLICATE('!',LEN(GDOC.NroDoc))	
	         @ 3,19 GET XsNroDoc PICT XsPICT && "!!!!!!!!!!"
	         READ
	         UltTecla = LASTKEY()
	         IF INLIST(UltTecla,escape_,Arriba)
	            i = i - 1
	            LOOP
	         ENDIF
	         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
	            IF ! ccbbusca("GDOC")
	               LOOP
	            ENDIF
	            XsNroDoc = NroDoc
	         ENDIF
	         SEEK XsTpoDoc+XsCodDoc+XsNroDoc
	         IF ! FOUND()
	            DO lib_merr WITH 6
	            LOOP
	         ENDIF
         ELSE
			IF !USED('VPRO')			
				goentorno.open_dbf1('ABRIR','VTAVPROF','VPRO','VPRO01','')	
			ENDIF
			LsAliasDocs = 'VPRO'
			IF INLIST(XsCodDoc,'NCPR','ANPR')
				LsLlave = XsTpoDoc+XsCodDoc
				LsWhile = [TpoDoc=XsTpoDoc AND CodDoc=XsCodDoc]
				SET ORDER TO GDOC01 IN VPRO
			ELSE
				LsLlave = ''
				LsWhile = '.T.'
				SET ORDER TO VPRO01 IN VPRO
			ENDIF 

   			 SELECT GDOC
			 SET RELATION TO	
	         SELECT(LsAliasDocs)
           	 SET RELA TO GsClfCli+CodCli INTO CLIE
           	 XsPICT='@S'+REPLICATE('!',LEN(GDOC.NroDoc))	
	         @ 3,19 GET XsNroDoc PICT XsPICT && "!!!!!!!!!!"
	         READ
	         UltTecla = LASTKEY()
	         IF INLIST(UltTecla,escape_,Arriba)
	            i = i - 1
	            LOOP
	         ENDIF
	         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
	            IF ! ccbbusca(XsCodDoc)
	               LOOP
	            ENDIF
	            XsNroDoc = NroDoc
	         ENDIF
	         SEEK LsLlave+PADR(XsNroDoc,LEN(VPRO.NroDoc))
	         IF ! FOUND()
	            DO lib_merr WITH 6
	            LOOP
	         ENDIF
						
						         
         ENDIF
         DO xPoner
      CASE i = 3
      	 SELECT CTAS
      	 @ 10,19 GET XsCodCta PICT "99999999"
      	 READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodCta)
            IF ! ccbbusca("MCTA")
               LOOP
            ENDIF
            XsCodCta = CodCta
         ENDIF
         SELECT GDOC
         IF EMPTY(GDOC.CodCta) AND XsCodDoc ="LETR"
	         DO graba_cta
	     ENDIF
         IF UltTecla = Enter
            EXIT
         ENDIF
         
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>3,3,i)
ENDDO

RETURN
********************************************************************* FIN() *
* Objeto : Inicializa variables
*****************************************************************************
PROCEDURE xInvar

XsTpoDoc = [CARGO]
XsCodDoc = SPACE(LEN(GDOC->CodDoc))
XsNroDoc = SPACE(LEN(GDOC->NroDoc))
XsCodCTa = SPACE(LEN(CTAS->CodCta))
STORE CTOD(SPACE(10))           TO AdFchDoc
STORE SPACE(LEN(GDOC->CodDoc)) TO AsCodDoc
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroDoc
STORE SPACE(LEN(GDOC->CodCli)) TO AsCodCli
STORE [ ]                      TO AcTpoDoc
STORE 0                        TO AiCodMon
STORE 0                        TO AfImport
STORE SPACE(LEN(GDOC->CodDoc)) TO AsGloDoc

RETURN
********************************************************************* FIN() *
* Objeto : Poner Informacion en Pantalla
*****************************************************************************
PROCEDURE xPoner

@  16,0  SAY "Ё                                                                                                                 Ё"
@  2,19 SAY CodDoc
@  2,62 SAY FchDoc
@  3,19 SAY NroDoc
@  3,62 SAY FchVto
@  4,19 SAY CodCli
@  5,19 SAY CLIE->NomAux PICT "@S58"
@  6,62 SAY IIF(CodMon=1,'S/.','US$')
@  7,62 SAY ImpTot PICT "999,999,999.99"
@  8,62 SAY SdoDoc PICT "999,999,999.99"
cFlgEst = []
cFlgUbc = []
cFlgSit = []
IF VARTYPE(FlgEst)='C'
	cFlgEst = ccb_est(FlgEst)
ENDIF
IF VARTYPE(FlgUbc)='C'
	cFlgUbc = ccb_ubc(FlgUbc)
ENDIF
IF VARTYPE(FlgSit)='C'
	cFlgSit = ccb_sit(FlgSit)
ENDIF
@  6,19 SAY cFlgEst
@  7,19 SAY cFlgUbc
@  8,19 SAY cFlgSit
IF VARTYPE(CodCta)='C'
	@  9,19 SAY LEFT(TABLA->Nombre,30)
	@ 10,19 SAY CTAS.CODCTA+' '+CTAS->NroCta
ENDIF
IF VARTYPE(NroPla)='C'
	@ 9,62  SAY NroPla 
ENDIF
IF VARTYPE(Plaza)='C'
	@ 11,19 SAY Plaza
ENDIF
IF VARTYPE(Numero)='C'
	@ 11,62 SAY Numero
ENDIF
IF TpoRef+CodRef='CanjeCANJ'
	@ 12,19 SAY NroRef
ENDIF
LsTpoDoc	= TpoDoc
LsTpoRef = TpoRef
LsCodRef = CodRef
LsNroRef = NroRef
LsDocumentos = ''
** cargamos informacion al arreglo **
PRIVATE i
i = 1
** primero barremos amortizaciones al documento **

IF !INLIST(XsCodDoc,'PROF','NCPR','ANPR')
	SELE VTOS
	IF GDOC->TpoDoc = [CARGO]
	   SET ORDER TO VTOS03
	   SEEK XsCodDoc+XsNroDoc
	   SCAN WHILE CodRef+NroRef=XsCodDoc+XsNroDoc .AND. i <= CIMAXELE
	      AdFchDoc(i) = FchDoc
	      AsCodDoc(i) = CodDoc
	      AsNroDoc(i) = NroDoc
	      AsCodCli(i) = CodCli
	      AcTpoDoc(i) = [A]    && Abono
	      AiCodmon(i) = CodMon
	      AfImport(i) = Import
	      AnNroReg(i) = RECNO()
	      AsTabla(i)  = ALIAS()
	      AsGloDoc(i)	=	GloDoc
	      i = i + 1
	   ENDSCAN
	   ** segundo revisemos si el documento ha sufrido canje por letras **
	   SELE VTOS
	   SEEK XsCodDoc+XsNroDoc
	   SCAN WHILE CodRef+NroRef=XsCodDoc+XsNroDoc .AND. i <= CIMAXELE
	      IF CodDoc = [CANJ]
	         SELE GDOC
	         SET ORDER TO GDOC03
	         SEEK [Canje]+VTOS->CodDoc+VTOS->NroDoc
	         SCAN WHILE TpoRef+CodRef+NroRef=[Canje]+VTOS->CodDoc+VTOS->NroDoc ;
	              .AND. i <= CIMAXELE
	            AdFchDoc(i) = FchDoc
	            AsCodDoc(i) = CodDoc
	            AsNroDoc(i) = NroDoc
				AsCodCli(i) = CodCli            
	            AcTpoDoc(i) = [C]    && CARGO
	            AiCodMon(i) = CodMon
	            AfImport(i) = ImpTot
	            AnNroReg(i) = RECNO()
	            AsTabla(i)  = ALIAS()
	      		AsGloDoc(i)	=	GloDoc
	            i = i + 1
	         ENDSCAN
	         SELE VTOS
	      ENDIF
	   ENDSCAN
	   GiTotItm = i - 1
   	   IF LsTpoRef+LsCodRef='CanjeCANJ'
	   		SELECT VTOS
	   		SET ORDER TO VTOS01
	   		SEEK LsCodRef+LsNroRef
	   		SCAN WHILE CodDoc+NroDoc = LsCodRef+LsNroRef
	   			LsDocumentos = LsDocumentos + LEFT(CodRef,3)+':'+NroRef+'/'
	   		ENDSCAN
	   		SET ORDER TO VTOS03
	   		LsDocumentos = SUBSTR(LsDocumentos,1,LEN(LsDocumentos)-1)
	   		IF !EMPTY(LsDocumentos)
	   			@12,44 SAY PADR(LsDocumentos,33) && FONT 'Foxfont',8
	   		ENDIF
	   ENDIF

	   IF GiTotItm <= 0
	      Titulo = [ ** NO EXISTEN MOVIMIENTOS REGISTRADOS ** ]
	      @ 16,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
	      =INKEY(0)
	      RETURN
	   ENDIF
	   
	   
	ELSE
	   SET ORDER TO VTOS01
	   SEEK XsCodDoc+XsNroDoc
	   SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc .AND. i <= CIMAXELE
	      AdFchDoc(i) = FchDoc
	      AsCodDoc(i) = CodRef
	      AsNroDoc(i) = NroRef
	      AsCodCli(i) = CodCli      
	      AcTpoDoc(i) = [A]    && Abono
	      AiCodmon(i) = CodMon
	      AfImport(i) = Import
	      AnNroReg(i) = RECNO()
	      AsTabla(i)  = ALIAS()      
	      AsGloDoc(i)	=	GloDoc	      
	      i = i + 1
	   ENDSCAN
	   GiTotItm = i - 1
	   IF GiTotItm <= 0
	      Titulo = [ ** NO EXISTEN MOVIMIENTOS REGISTRADOS ** ]
	      @ 15,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
	      =INKEY(0)
	      RETURN
	   ENDIF
	ENDIF
ELSE
	IF LsTpoDoc='CARGO'
		SELE VTOS
		   SET ORDER TO VTOS03
		   SEEK XsCodDoc+XsNroDoc
		   SCAN WHILE CodRef+NroRef=XsCodDoc+XsNroDoc .AND. i <= CIMAXELE
		      AdFchDoc(i) = FchDoc
		      AsCodDoc(i) = CodDoc
		      AsNroDoc(i) = NroDoc
		      AsCodCli(i) = CodCli
		      AcTpoDoc(i) = [A]    && Abono
		      AiCodmon(i) = CodMon
		      AfImport(i) = Import
		      AnNroReg(i) = RECNO()
		      AsTabla(i)  = ALIAS()
		      AsGloDoc(i)	=	GloDoc		      
		      i = i + 1
		   ENDSCAN
	   ELSE
		SELE VTOS
	   	   SET ORDER TO VTOS01
		   SEEK XsCodDoc+XsNroDoc
		   SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc .AND. i <= CIMAXELE
		      AdFchDoc(i) = FchDoc
		      AsCodDoc(i) = CodRef
		      AsNroDoc(i) = NroRef
		      AsCodCli(i) = CodCli      
		      AcTpoDoc(i) = [C]    && Cargo
		      AiCodmon(i) = CodMon
		      AfImport(i) = Import
		      AnNroReg(i) = RECNO()
		      AsTabla(i)  = ALIAS()      
		      AsGloDoc(i)	=	GloDoc
		      i = i + 1
		   ENDSCAN
	ENDIF
	   GiTotItm = i - 1
	   IF GiTotItm <= 0
	      Titulo = [ ** NO EXISTEN MOVIMIENTOS REGISTRADOS ** ]
	      @ 16,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
	      =INKEY(0)
	      RETURN
	   ENDIF
	   
ENDIF	
** pintamos informacion con el browse **
DO xBrowse

RETURN
********************************************************************* FIN() *
* Objetvo : Mostrar el Browse
*****************************************************************************
PROCEDURE xBrowse

EscLin   = "DOCbline"
EdiLin   = "DOCbedit"
BrrLin   = "DOCbborr"
InsLin   = [DOCbInse]
PrgFin   = []
*
Yo       = 15
Xo       = 0
Largo    = 10
Ancho    = AnchoBrow1
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
GsMsgKey = "[PgUp] [PgDn] [Teclas Cursor] [Home] [End] Posicionar [F10] Buscar otro documento"
DO lib_mtec WITH 99
DO aBrowse
*

RETURN
********************************************************************* FIN() *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE DocBLine
PARAMETERS NumEle, NumLin

*           1         2         3         4         5         6         7         8			9		  10 	    11
**0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
*1цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*2Ё   Fecha       Doc.   Nёmero      Cod.Cli.     Mon      Cargos          Abonos         ObservaciСn               Ё
*3цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*4Ё 99/99/9999    1234  123456789   ............  S/. 999,999,999.99  999,999,999.99 1234567890123456789012345678901Ё

@ NumLin,2  SAY AdFchDoc(NumEle) PICT '@d dd/mm/aa' && STRT(DTOC(AdFchDoc(NumEle)),'/20','/') 
@ NumLin,16 SAY AsCodDoc(NumEle)
@ NumLin,22 SAY AsNroDoc(NumEle)
@ Numlin,34 SAY AsCodCli(NumEle)
@ NumLin,48 SAY IIF(AiCodMon(NumEle)=1,'S/.','US$')
IF AcTpoDoc(NumEle) = [C]
   @ NumLin,52 SAY AfImport(NumEle) PICT "999,999,999.99"
ELSE
   @ NumLin,68 SAY AfImport(NumEle) PICT "999,999,999.99"
ENDIF
@ NumLin,83 SAY AsGloDoc(NumEle)	PICT "@S30"

RETURN
************************************************************************ FIN *
*
******************************************************************************
PROCEDURE DOCbedit
PARAMETER NumEle,NumLin

IF f1_ALERT('Se va ha modificar el codigo del cliente y esto puede distorsionar la cuenta corriente!!;'+;
			'Si tiene alguna duda haga click en <NO> o presione <Esc>; ;Desea Continuar ?','SI_O_NO')=2
	UltTecla = Arriba
	RETURN 
ENDIF

UltTecla = 0
*
i = 1
LsCodCli = ASCodCli(NumEle)
DO WHILE  .NOT. INLIST(UltTecla,Escape_,Arriba)
   DO CASE
      CASE i = 1
      	LsArea_Act = SELECT()
      	SELECT CLIE
		@ Numlin,34 GET LsCodCli 
	     READ
         UltTecla = LASTKEY()
         IF UltTecla = F8 .OR. EMPTY(LsCodCli)
            IF !ccbbusca("CLIE")
               SET ORDER TO AUXI01
               LOOP
            ENDIF
            LsCodCli = CLIE.CodAux
            SET ORDER TO AUXI01
            UltTecla = Enter
         ENDIF
         IF !SEEK(GsClfCli+LsCodCLi,'CLIE')
          	UltTecla = 0
            DO lib_merr WITH 6
	        LOOP
         ENDIF
		@ Numlin,34 SAY LsCodCli       		
		SELECT (LsArea_Act)
      CASE i = 2
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         IF INLIST(UltTecla,F10,CTRLw)
            UltTecla = CtrlW
            EXIT
         ENDIF
         i = 1
   ENDCASE
   	
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF( i > 2 , 2, i)
   i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> Escape_
	LsCodCli_Ant=AsCodCli(NumEle)
	AsCodCli(NumEle) = LsCodCli
	*** Grabamos Cambio ***

	IF AnNroReg(NumEle)>0 AND !EMPTY(LsCodCli_Ant)
   	   LsArea_Act = SELECT()
   	   LsTabla = AsTabla(NumEle)
   	   SELECT (LsTabla)

	   GO AnNroReg(NumEle)
   	   IF F1_Rlock(5)
   		   REPLACE CodCli WITH AsCodCli(NumEle)
   		   *** En Contabilidad ***
   		   LsCodCta=CodCta
   		   LsCodDoc=CodRef
   		   LsNroDoc=NroRef
   		   LsAsiento=NroMes+CodOpe+NroAst
   		   LsAno = LEFT(DTOS(FchDoc),4)
   		   LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','','',GsCodCia,LsAno)
   		   SELECT RMOV
   		   SEEK LsAsiento
   		   SCAN WHILE NroMes+CodOpe+NroAst=LsAsiento
   		   		IF CodCta=LsCodCta AND CodDoc+NroDoc=LsCodDoc+LsNroDoc AND ClfAux=GsClfCli AND !CodAux==PADR(AsCodCli(NumEle),LEN(CodAux))
   					=RLOCK() && Esto modifica la cuenta corriente de contabilidad - VETT 2009-07-22
   					REPLACE CodAux WITH AsCodCli(NumEle)					   		 
   		   		ENDIF	
   		   ENDSCAN
   		   *** 
   	   ENDIF
		SELECT (LsArea_Act)
	ENDIF   
ENDIF
LiUTecla = UltTecla

*UltTecla = Arriba

RETURN
************************************************************************ FIN *
*
******************************************************************************
PROCEDURE DOCbborr
PARAMETER NumEle,Estado

Estado = .F.

RETURN

PROCEDURE DOCbInse
PARAMETER NumEle,Estado

Estado = .F.

RETURN

*******************
PROCEDURE graba_cta
*******************
DO WHILE !RLOCK()
ENDDO
REPLACE CodCta WITH XsCodCta
UNLOCK