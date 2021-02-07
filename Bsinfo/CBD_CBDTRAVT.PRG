**********************************************************************
*  Nombre        : cbdTRAVT.prg
*  Sistema       : Contabilidad
*  Proposito     : Regenera Acumulados
*  Modificacion  : VETT 2008-03-19
***************************************************************************
CLOSE DATA
Private xArchivo,xMes
xArchivo = Space(20)
xMes = Space(2)
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "Tranferencia de Ventas de Gimnasios"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
NroDec   = 2
XsNroMes = TRANSF(_MES,"@L ##")
STORE 0 TO nImpNac,nImpUsa
** Abrimos areas a usar **
@  7,09 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  8,09 SAY '³                    I M P O R T A N T E                    ³'
@  9,09 SAY '³                                                           ³'
@ 10,09 SAY '³ Este proceso tiene por finalidad de Trasladar las ventas  ³'
@ 11,09 SAY '³ de los gimnasios al sistema de facturaci¢n.               ³'
@ 12,09 SAY '³                                                           ³'
@ 13,09 SAY '³ La apertura de archivos sera en forma exclusiva y deber   ³'
@ 14,09 SAY '³ ser la unica TAREA que se efectue en el sistema           ³'
@ 15,09 SAY '³                                                           ³'
@ 16,09 SAY '³          Presione <<Enter>> para Continuar                ³'
@ 17,09 SAY '³                                                           ³'
@ 18,09 SAY '³            Presione <<Esc>> para Cancelar                 ³'
@ 19,09 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
@ 16,31 SAY 'Enter' COLOR SCHEME 13
@ 18,33 SAY 'Esc'   COLOR SCHEME 13
* Pide respuesta
UltTecla = 0
DO WHILE ! (UltTecla=Enter .OR. UltTecla=Escape)
   UltTecla=INKEY(0)
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
@ 9,10 CLEAR TO 18,67
GsMsgKey = "[Aperturando archivos]"
DO LIB_MTEC WITH 99
SELE 1
USE ccbrgdoc ORDER gdoc01 ALIAS gdoc excl
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE vtaritem ORDER item01 ALIAS item excl
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE CCBMVTOS ORDER VTOS01 ALIAS VTOS excl
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 4
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF
SELE 5
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF
SELE 6
USE ALMRMOVM ORDER RMOV01 ALIAS RMOV excl
IF ! USED(6)
   CLOSE DATA
   RETURN
ENDIF
SELE 7
USE ALMMMATG ORDER MATG01 ALIAS MATG
IF ! USED(7)
   CLOSE DATA
   RETURN
ENDIF
SELE 8
USE ALMMMATE ORDER MATE01 ALIAS MATE
IF ! USED(8)
   CLOSE DATA
   RETURN
ENDIF
@ 13,13 say "Archivo a procesar  : " GET xArchivo
READ
IF LASTKEY()=Escape
   close data
   RETURN
ENDIF
@ 15,13 say "Mes a Procesar      : " GET Xmes
READ
IF LASTKEY()=Escape
   close data
   RETURN
ENDIF
*** Elimina Movimientos Anteriores ***
SELE GDOC
SET ORDER TO GDOC15
SEEK ALLTRIM(STR(_Ano))+RIGHT("00"+ALLTRIM(STR(_Mes)),2)
DO WHILE !EOF() .and. SUBSTR(DTOS(Fchdoc),1,6) = ALLTRIM(STR(_Ano))+RIGHT("00"+ALLTRIM(STR(_Mes)),2)
   DELETE
   SKIP
ENDDO
SET ORDER TO GDOC01
***
SELE ITEM
SET ORDER TO ITEM05
SEEK ALLTRIM(STR(_Ano))+RIGHT("00"+ALLTRIM(STR(_Mes)),2)
DO WHILE !EOF() .and. SUBSTR(DTOS(Fchdoc),1,6) = ALLTRIM(STR(_Ano))+RIGHT("00"+ALLTRIM(STR(_Mes)),2)
   DELETE
   SKIP
ENDDO
SET ORDER TO ITEM01
***
SELE RMOV
SET ORDER TO RMOV15
SEEK ALLTRIM(STR(_Ano))+Xmes+"S"
DO WHILE !EOF() .and. SUBSTR(DTOS(Fchdoc),1,6)+"S" = ALLTRIM(STR(_Ano))+Xmes+"S"
   IF INLIST(CODMOV,"F","B","N")
      DELETE
   ENDIF
   SKIP
ENDDO
SET ORDER TO rmov01
***
SELE VTOS
SET ORDER TO VTOS10
SEEK ALLTRIM(STR(_Ano))+RIGHT("00"+ALLTRIM(STR(_Mes)),2)
DO WHILE !EOF() .and. SUBSTR(DTOS(Fchdoc),1,6) = ALLTRIM(STR(_Ano))+RIGHT("00"+ALLTRIM(STR(_Mes)),2)
   DELETE
   SKIP
ENDDO
SET ORDER TO VTOS01
*** Procesa Informaci¢n ***
IF FILE(xArchivo)                             && ¨Existe el archivo?
   archerr = FOPEN(xArchivo,0)                && Si abrir lectura
ELSE
   RETURN
ENDIF
STORE FSEEK(archerr, 0, 2) TO pa_size      && Mueve el puntero a EOF
STORE FSEEK(archerr, 0)    TO pa_arriba       && Mueve el puntero a BOF
IF pa_size<= 0                             && ¨El archivo est  vac¡o?
   WAIT WINDOW '­Este archivo est  vac¡o!' NOWAIT
ENDIF
DO WHILE !FEOF(archerr)
   WAIT WINDOWS "Espere un momento... Procesando..!!!" NOWAIT
   cadena = FREAD(archerr,240)
   XfTpocmb = 1
   XsNomcli = ""
   XsDircli = ""
   XsTporeg = Substr(Cadena,1,1)
   XsCodgim = Substr(Cadena,3,3)
   XsTipodo = Substr(Cadena,7,4)
   DO CASE
      CASE XsTipodo = "FACT"
        XsCoddoc = XsTipodo
        XsTpodoc = "Cargo"
      CASE XsTipodo = "BOLE"
        XsCoddoc = XsTipodo
        XsTpodoc = "Cargo"
      CASE XsTipodo = "NCRE"
        XsCoddoc = "N/A"
        XsTpodoc = "Abono"
   ENDCASE
   XsNrodoc = Substr(Cadena,12,3)+Substr(Cadena,16,7)
  * If XsNroDoc="0010085551"
  * 	set step on
  * endif
   IF XsTporeg = "C"
      XdFchdoc = CTOD(Substr(Cadena,24,10))
      IF SEEK(DTOC(XdFchdoc,1),"TCMB")
         XfTpocmb= TCMB.Ofivta
      ENDIF
   ENDIF
   XsCodcli = ALLTRIM(Substr(Cadena,35,11))
   IF SEEK("001"+XsCodcli,"AUXI")
      XsNomcli = AUXI.Nomaux
      XsDircli = AUXI.Diraux
   ENDIF
   XsFlgest = Substr(Cadena,47,1)
   XfImpnet = VAL(Substr(Cadena,49,10))
   XfImpdsc = VAL(Substr(Cadena,60,8))
   XfImpval = VAL(Substr(Cadena,69,9))
   XfImpigv = VAL(Substr(Cadena,79,8))
   XfImptot = VAL(Substr(Cadena,88,10))
   XsCodcta = Substr(Cadena,99,10)
   XsCodmon = Substr(Cadena,110,2)
   XsGratui = Substr(Cadena,113,1)
   XsTarjet = Substr(Cadena,115,22)
   XfImppag = VAL(Substr(Cadena,138,9))
   XsCodref = Substr(Cadena,148,4)
   XsNroref = Substr(Cadena,153,3)+Substr(Cadena,157,7)
   IF XsTporeg = "F"
      XfTpocmb = VAL(Substr(Cadena,165,8))
   ENDIF
   XsTpomat = Substr(Cadena,174,1)                          && Tipo de Producto
   XsCodmat = Substr(Cadena,176,8)
   XfCanfac = VAL(Substr(Cadena,185,3))
   XsDesmat = Substr(Cadena,189,50)
   DO CASE
      CASE SYS(2003)="\CLIENTES\STI" .and. GsCodcia = "001" .and. XsCodgim <> "004"              && San Isidro
         LOOP
      CASE SYS(2003)="\CLIENTES\STI" .and. GsCodcia = "002" .and. XsCodgim <> "005"              && Miraflores
         LOOP
      CASE SYS(2003)="\CLIENTES\GIMNASIO" .and. GsCodcia = "001" .and. XsCodgim <> "003"         && Chacarilla
         LOOP
   ENDCASE
   DO CASE
      CASE XsTporeg = "C"
         SELE GDOC
         APPEND BLANK
         IF !RLOCK()
            LOOP
         ENDIF
         REPLACE Coddoc WITH XsCoddoc
         REPLACE Tpodoc WITH XsTpodoc
         REPLACE Nrodoc WITH XsNrodoc
         REPLACE Fchdoc WITH XdFchdoc
         REPLACE Codcli WITH XsCodcli
         REPLACE Nomcli WITH XsNomcli
         REPLACE Dircli WITH XsDircli
         IF XsFlgest <> "A"
            REPLACE Codmon WITH IIF(XsCodmon="01",1,2)
            REPLACE Tpocmb WITH XfTpocmb
            REPLACE Impbto WITH XfImpnet+XfImpdsc
            REPLACE Impnet WITH XfImpnet
            REPLACE Impigv WITH XfImpigv
            REPLACE Imptot WITH XfImptot
            REPLACE Sdodoc WITH XfImptot
            REPLACE Codref WITH IIF(Coddoc="N/A",XsCodref,"")
            REPLACE Nroref WITH IIF(Coddoc="N/A",XsNroref,"")
            REPLACE Flgest WITH "P"
            REPLACE Gratui WITH XsGratui
         ELSE
            REPLACE Flgest WITH XsFlgest
            REPLACE Impnet WITH 0
            REPLACE Impigv WITH 0
            REPLACE Imptot WITH 0
            REPLACE Sdodoc WITH 0
         ENDIF
      CASE XsTporeg = "D"
         IF XfImpnet > 0
            SELE ITEM
            APPEND BLANK
            IF !RLOCK()
               LOOP
            ENDIF
            REPLACE Coddoc WITH XsCoddoc
            REPLACE Nrodoc WITH XsNrodoc
            IF SEEK(XsTpodoc+XsCoddoc+XsNrodoc,"GDOC")
               REPLACE Fchdoc WITH GDOC.Fchdoc
            ENDIF
            REPLACE Codmat WITH XsCodmat
            REPLACE Desmat WITH XsDesmat
            REPLACE Preuni WITH ROUND(XfImpnet/XfCanfac,2)
            REPLACE Canfac WITH XfCanfac
            REPLACE Candes WITH XfCanfac
            REPLACE Implin WITH XfImpnet
            REPLACE Codcta WITH XsCodcta
         ENDIF
         *** Actualiza Inventarios ***
         IF XsTpomat = "I" .and. XfCanfac > 0
            IF INLIST(XsCodMat,"0057","0081","0236","0334")
               LOOP
            ENDIF
            IF INLIST(XsCodMat,"0623","0665","0682","0685","0686","0688")
              LOOP
            ENDIF
            IF INLIST(XsCodMat,"0715","0717","0718","0720","0722","0723")
               LOOP
            ENDIF
            IF INLIST(XsCodMat,"0900","0902","0992","0993","0998","0999")
               LOOP
            ENDIF
            IF INLIST(XsCodMat,"1000","1005","1008","1010","1011","1025","1029","1039","1049","1062","1081","1110")
               LOOP
            ENDIF
            SELE RMOV
            APPEND BLANK
            IF !RLOCK()
               LOOP
            ENDIF
            REPLACE Subalm WITH "001"
            REPLACE Tipmov WITH "S"
            REPLACE Codmov WITH LEFT(XsCoddoc,1)+SUBSTR(XsNrodoc,2,2)
            REPLACE Nrodoc WITH SUBSTR(XsNrodoc,4,7)
            IF SEEK(XsTpodoc+XsCoddoc+XsNrodoc,"GDOC")
               REPLACE Fchdoc WITH GDOC.Fchdoc
               REPLACE Codcli WITH GDOC.Codcli
            ENDIF
            REPLACE Codmat WITH XsCodmat
            REPLACE Desmat WITH XsDesmat
            REPLACE Candes WITH XfCanfac
            REPLACE Factor WITH 1
            REPLACE Undvta WITH "UND"
            REPLACE Tpocmb WITH 1
            REPLACE Codmon WITH 1
            IF !SEEK(XsCodmat,"MATG")
               SELE MATG
               APPEND BLANK
               IF !RLOCK()
                  LOOP
               ENDIF
               REPLACE Codmat WITH XsCodmat
               REPLACE Desmat WITH XsDesmat
               REPLACE Facequ WITH 1
               REPLACE Undcmp WITH "UND"
            ENDIF
            IF !SEEK("001"+XsCodmat,"MATE")
               SELE MATE
               APPEND BLANK
               IF !RLOCK()
                  LOOP
               ENDIF
               REPLACE subalm WITH "001"
               REPLACE Codmat WITH XsCodmat
               REPLACE Desmat WITH XsDesmat
               REPLACE Facequ WITH 1
               REPLACE Undvta WITH "UND"
            ENDIF
         ENDIF
      CASE XsTporeg = "F"
         IF SEEK(XsCoddoc+XsNrodoc,"ITEM")
            SELE VTOS
            APPEND BLANK
            IF !RLOCK()
               LOOP
            ENDIF
            REPLACE Coddoc WITH "I"
            REPLACE Nrodoc WITH "000001"
            IF SEEK(XsTpodoc+XsCoddoc+XsNrodoc,"GDOC")
               REPLACE Fchdoc WITH GDOC.Fchdoc
               REPLACE Codcli WITH GDOC.Codcli
            ENDIF
            REPLACE Codmon WITH IIF(XsCodmon="01",1,2)
            IF Codmon = 2
               REPLACE Tpocmb WITH XfTpocmb
            ELSE
               IF SEEK(DTOC(Fchdoc,1),"TCMB")
                  XfTpocmb = TCMB.Ofivta
               ENDIF
               REPLACE Tpocmb WITH XfTpocmb
            ENDIF
            REPLACE Codref WITH XsCoddoc
            REPLACE Nroref WITH XsNrodoc
            REPLACE Import WITH XfImppag
            IF SEEK(XsTpodoc+XsCoddoc+XsNrodoc,"GDOC")
               REPLACE GDOC.Sdodoc WITH Gdoc.Sdodoc-XfImppag
               REPLACE GDOC.Flgest WITH IIF(GDOC.Sdodoc=0,"C","P")
            ENDIF
            REPLACE Tarjet WITH XsTarjet
         ENDIF
   ENDCASE
ENDDO
=FCLOSE(archerr)                                     && Cerrar archivo
CLOSE DATA

PROCEDURE Migrar_Cobranzas_Isla 
PARAMETERS LcRutaTxtVMOV,LcRutaTxtRMOV
LcRutaArcTxtVMOV = 'd:\o-negocios\CISLA\Local\Intf_VMOV.DBF'
LcRutaFileVmov = 'd:\o-negocios\CISLA\Local\Intf_VMOV.DBF'
LcRutaFileRmov = 'd:\o-negocios\CISLA\Local\Intf_RMOV.DBF'
IF !FILE(LcRutaFileVMOV)
	SELECT 0
	CREATE TABLE  (LcRutaFileVMOV)  FREE ( GLO_MES C(2), ;
															      GLO_TIPO C(2), ;
															      GLO_OPER C(2), ;
															      GLO_NUMERO C(6), ;
															      GLO_FECHA D, ;
															      GLO_DESCRI C(40), ;
															      GLO_CAMBIO N(1),  ;
															      GLO_MONEDA  c(1), ;
															      GLO_LINEAS n(3), ;
															      GLO_MONDEB n(9,2), ;
															      GLO_MONHAB n(9,2), ;
															      GLO_DOLDEB n(9,2), ;
															      GLO_DOLHAB n(9,2), ;
															      GLO_USUARI C(6), ;
															      GLO_DELETE c(6), ;
															      GLO_CODIGO C(2), ;
															      GLO_TIPDOC  C(2), ;
															      GLO_NROSER C(4),  ;
															      GLO_NRODOC C(10) ,  ;
															      GLO_IMPORT  N(8,2), ;
															      GLO_AFAVOR C(2), ;
															      GLO_BANCO C(3), ;
															      GLO_DIFER C(2),;
															      GLO_DATE	 D, ;
															      GLO_TIME  C(8), ;
															      GLO_USUA C(6) )
     USE	(LcRutaFileVMOV)  ALIAS I_VMOV EXCLUSIVE														      
									      
ELSE
	SELECT 0
	USE (LcRutaFileVMOV)  ALIAS I_VMOV EXCLUSIVE
	ZAP
ENDIF
APPEND FROM (LcRutaTxtVMOV) TYPE DELIMITED WITH CHARACTER ','				


IF !FILE(LcRutaFileRMOV)
	SELECT 0
	CREATE TABLE  (LcRutaFileRMOV)  FREE (                       VOU_MES C(2), ;
															     VOU_TIPO C(2), ;
															      VOU_OPER C(2), ;
															      VOU_NUMERO C(6), ;
															      VOU_LINEA n(3),  ;
															      VOU_CUENTA C(6), ;
															      VOU_CODIGO C(3), ;
															      VOU_TIPDOC C(2), ;
															      VOU_SERIE    C(3), ;
															      VOU_NRODOC C(6), ;
															      VOU_FECDOC D, ;
															      VOU_FECVEN D, ;
															      VOU_MONTO N(9,2), ;
															      VOU_DOLAR  N(9,2), ;
															      VOU_DH          C(1),  ;
															      VOU_TRANSF C(1) ,  ;
															      VOU_FECHA D, ;
															      VOU_COSTO C(5), ;
															      VOU_CONCI C(5), ;
															      VOU_NRORE C(5) , ;
															      VOU_DESCRI C(10)	, ;
															      VOU_MONEDA C(1), ;
															      VOU_CAMBIO  N(1),  ;
															     VOU_COMBO C(1), ;
															     VOU_CC C(1), ;
															     VOU_CAJA C(1) , ;
															     VOU_DATE D, ;
															     VOU_TIME C(8), ;
															      VOU_USUA C(6),;
															      VOU_PARTID C(6) )
	
	USE (LcRutaFileRMOV)  ALIAS I_RMOV EXCLUSIVE															      
ELSE
	SELECT 0
	USE (LcRutaFileRMOV)  ALIAS I_RMOV EXCLUSIVE
	ZAP
ENDIF
APPEND FROM (LcRutaTxtRMOV) TYPE DELIMITED WITH CHARACTER ','												      