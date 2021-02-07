Do Form cbd_cbdrecep
return
PROCEDURE cbdrecep_dos
*    嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*    �  Nombre        : cjap5100.prg                             額�
*    �  Sistema       : CAJA BANCOS                              額�
*    �  Autor         : VETT  25/05/95                           額�
*    �  Prop�sito     : Recepci�n de Documentos de Proveedores   額�
*    �  Actualizaci�n : VETT  25/05/95                           額�
*    �  Actualizaci�n : VETT  19/01/2004  VFP7                   額�
*    塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詔�
*      栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩栩�
*
* VARIABLES DE CONTROL *
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
LOCAL LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')


SET step on

DO Recep 

CLEAR MACROS 
CLEAR
loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('NPER')
loContab.oDatadm.CloseTable('TPER')
loContab.oDatadm.CloseTable('AUXI')
RELEASE LoContab

IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
RETURN


PROCEDURE Recep

PRIVATE XsNroMes
PRIVATE XsClfAux,XsTabla
XsClfAux = GsClfPro     && Proveedores/Clientes
XsTabla  = [02]      && Codigo de Documentos
XsNroMes = TRANSF(_MES,"@L ##")
XsAno    = RIGHT(STR(_ANO,4),2)
TsCodDiv1= [01]  && Divisionaria por defecto

* pantalla de datos *
DO xPanta
SAVE SCREEN TO LsPanta1

LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')

Modificar  = LoContab.mescerrado(_mes) && VERIFICAR CIERRE DEL MES
IF ! Modificar
   GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
   DO LIB_MERR WITH 99
   RETURN
ENDIF

lreturnok=LoDatAdm.abrirtabla('ABRIR','CJADPROV','DPRO','DPRO06','')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')

RELEASE LoDatAdm

SELECT PROV
SET FILTER TO TipReg="R"
LOCATE
* relaciones a usar *
SELE DPRO
SET RELA TO XsClfAux+CodAux INTO AUXI

* variables del sistema *
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XdFchVto,XsCodAux,XfImport,XiCodMon,XfTpoCmb,XsFchPol
PRIVATE XdFchRec,XsNomRec,XsNomEnv,XcFlgEst,XfSdoDoc,XsObserv,XsNroO_C,XsNroGui
PRIVATE XiDiaVto,XfImpBrt,XfImpIgv,XsRucAux,XsNomAux,XsCodOpe
Private XdFchPed

XsCodDoc = SPACE(LEN(DPRO->CodDoc))
XsNroDoc = SPACE(LEN(DPRO->NroDoc))
XsNroRef = SPACE(LEN(DPRO->NroRef))
XdFchDoc = CTOD(SPACE(8))
XdFchVto = CTOD(SPACE(8))
XdFchPol = CTOD(SPACE(8))
XiDiaVto = 0
XsCodAux = SPACE(LEN(DPRO->CodAux))
XsRucAux = SPACE(LEN(DPRO->RucAux))
XsNomAux = SPACE(LEN(DPRO->NomAux))
XfImport = 0.00
XfImpBrt = 0.00
XfImpIgv = 0.00
XiCodMon = 1
XfTpoCmb = 0.00
XdFchRec = DATE()
XdFchPed = Date() + 45
XsNomRec = SPACE(LEN(DPRO->NomRec))
XsNomEnv = SPACE(LEN(DPRO->NomEnv))
XcFlgEst = [P]       && Provisionado, Cancelado , Anulado
XfSdoDoc = 0.00
XsObserv = []
XsNroO_C = SPACE(LEN(DPRO->NroO_C))
XsNroGui = SPACE(LEN(DPRO->NroGui))
** Variables de Contabilidad **
XsCodOpe = SPACE(LEN(DPRO->CodOpe))
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = SPACE(LEN(DPRO->NroAst))
XsNroVou = SPACE(LEN(DPRO->NroVou))
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*

** Logica principal **
SELE DPRO
GO TOP
UltTecla = 0
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C�digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99

xCodDoc = XsCodDoc
VCLAVE=XsNroMes
DO F1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],[xReporte],'NROMES',VCLAVE,'CMAR',[]

RETURN


* 嬪様様様様様様様様様様様様様様様様様様�
* � Objetivo : Pantalla de Datos        �
* 塒様様様様様様様様様様様様様様様様様様�
PROCEDURE xPanta
*           1         2         3         4         5         6         7         8
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*1   敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
*2   � Nro.Ingreso: 123456789             Fecha de Recepcion : 99/99/99      �
*3   �  Proveedor : 12345  1234567890123456789012345678901234567890          �
*4   �        RUC : 1234567890      Documento del Proveedor : 123 1234567890 �
*5   �                                        Fecha Emision : 99/99/99       �
*6   � No. O/C.  : 123456                     Dias de Vcmto.: 9999 Dias      �
*7   � No. Guia  : 123456                    Fecha de Vcmto.: 99/99/99       �
*8   楽陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�  敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳審
*9   崖  Mes Contable   : Diciembre  �  �          Moneda : S/.             崖
*0   崖  No. de Asiento : 123456     �  �  Tipo de Cambio : 9,999.9999      崖
*1   崖       Operacion : 123        �  �     Importe IGV : 999,999,999.99  崖
*2   垣陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�  �   Importe Total : 999,999,999.99  崖
*3   � Situacion     : Provisionado     青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳抒
*4   � Nro.Poliza Imp: 123456789012345                 Pago Aduana: 99/99/99 �
*5   � Enviado a     : 123456789012345678901234567890                        �
*6   青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
*7   敖Observaciones陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
*8   �                                                                       �
*9   �                                                                       �
*0   �                                                                       �
*1   青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
        **012345678901234567890123456789012345678901234567890123456789012345678901234567890
        *           1         2         3         4         5         6         7         8

CLEAR
@ 0,0,24,79 BOX '臆臆臆臆�'
@  1,3  SAY "敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�"
@  2,3  SAY "� Tipo Doc. :                       Fecha de Recepci�n :                �"
@  3,3  SAY "� Correlat. :                                                           �"
@  4,3  SAY "� Prov.:                                         # Doc :                �"
@  5,3  SAY "� RUC  :                                 Fecha Emisi�n :                �"
@  6,3  SAY "� No. O/C.  :                            Dias de Vcmto.:      Dias      �"
@  7,3  SAY "� No. Guia  :                           Fecha de Vcmto.:                �"
@  8,3  SAY "楽陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�       Fecha de Pago  :                �"
@  9,3  SAY "崖  Mes Contable   :            �  敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳審" 
@ 10,3  SAY "崖  No. de Asiento :            �  �          Moneda :                 崖"
@ 11,3  SAY "崖       Operaci�n :            �  �  Tipo de Cambio :                 崖"
@ 12,3  SAY "垣陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�  �     Importe IGV :                 崖"
@ 13,3  SAY "� Sit. Registro :                  �   Importe Total :                 崖"
@ 14,3  SAY "� Poliza Nro    :                  青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳抒"
@ 15,3  SAY "� Enviado a     :                               Pago Aduana :           �"
@ 16,3  SAY "青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�"
@ 17,3  SAY "敖Observaciones陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕"
@ 18,3  SAY "�                                                                       �"
@ 19,3  SAY "�                                                                       �"
@ 20,3  SAY "�                                                                       �"
@ 21,3  SAY "青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�"
Titulo = [ ** RECEPCION DE DOCUMENTOS ** ]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  9,24 SAY PADR(MES(VAL(XsNroMes),1),10,' ')
RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


* 嬪様様様様様様様様様様様様様様様様様様様様様邑
* � Objetivo : Inicializa variables            �
* 塒様様様様様様様様様様様様様様様様様様様様様余
PROCEDURE xInvar
XsNroRef = SPACE(LEN(DPRO->NroRef))
XsRucAux = SPACE(LEN(DPRO->RucAux))
XsCodAux = SPACE(LEN(DPRO->CodAux))
*XsCodDoc = SPACE(LEN(DPRO->CodDoc))
XdFchDoc = CTOD(SPACE(8))
XdFchVto = CTOD(SPACE(8))
XiDiaVto = 0
XfImport = 0.00
XfImpBrt = 0.00
XfImpIgv = 0.00
XiCodMon = 1
XfTpoCmb = 0.00
XdFchRec = DATE()
XdFchPed = Date() + 45
XsNomRec = SPACE(LEN(DPRO->NomRec))
XsNomEnv = SPACE(LEN(DPRO->NomEnv))
XcFlgEst = [P]       && Provisionado, Cancelado, Anulado
XfSdoDoc = 0.00
XsObserv = []
XsNroO_C = SPACE(LEN(DPRO->NroO_C))
XsNroGui = SPACE(LEN(DPRO->NroGui))
** Variables de Contabilidad **
XsCodOpe = SPACE(LEN(DPRO->CodOpe))
*XsNroMes = SPACE(LEN(DPRO->NroMes))
XsNroAst = SPACE(LEN(DPRO->NroAst))
XsNroVou = SPACE(LEN(DPRO->NroVou))
RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


* 嬪様様様様様様様様様様様様様様様様様様様�
* � Objetivo : Pedir Llave de Acceso      �
* 塒様様様様様様様様様様様様様様様様様様様�
PROCEDURE xLlave
SELE DPRO
IF &sesrgv
   XsCodDoc = CodDoc
   XsNroDoc = NroDoc
   XsCodOpe = CodOpe
ELSE
   XsCodDoc = SPACE(LEN(CodDoc))
   XsNroDoc = SPACE(LEN(NroDoc))
   XsCodOpe = SPACE(LEN(CodOpe))
ENDIF

UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,Escape_)
   DO CASE
      CASE i = 1
         SELE PROV
         @  2,18 GET XsCodDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape_
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
            IF ! CBDBUSCA("PROV")
               LOOP
            ENDIF
            XsCodDoc = TpoDoc
         ENDIF
         @  2,18 SAY XsCodDoc
         SEEK XsCodDoc
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         @  2,18 SAY XsCodDoc
         IF !(TIPO$"CN")
            XsCodOpe = CodOpe
            =SEEK(CodOpe,"OPER")
            LsNroAst = LoContab.NroAst()
            XsNroDoc = LsNroAst+SPACE(LEN(XsNroDoc)-LEN(LsNroAst))
         ENDIF
         SELE DPRO
      CASE i = 2 .AND. cVctrl = [C]
         SELE DPRO
         IF PROV->TIPO="A" .AND. EMPTY(SUBSTR(XsNroDoc,10,2))
            XsNroDoc = SUBSTR(XsNroDoc,1,8)+"-"+RIGHT(STR(_ANO,4),2)
         ENDIF
         IF PROV.Tipo=[A]
			LsNroDoc=LEFT(XsNroDoc,2)+[-]+SUBS(XsNroDoc,3,2)+[-]+SUBS(XsNroDoc,5)         		
	         @ 3,18 SAY LsNroDoc
         ELSE
	         @ 3,18 SAY XsNroDoc
         ENDIF
         UltTecla = Enter
      CASE i = 2 .AND. !( cVctrl = [C] )
         SELE DPRO
         IF PROV->TIPO="A" .AND. EMPTY(SUBSTR(XsNroDoc,10,2))
            XsNroDoc = SUBSTR(XsNroDoc,1,8)+"-"+RIGHT(STR(_ANO,4),2)
         ENDIF
         IF PROV->TIPO="A"
			LsNroDoc=LEFT(XsNroDoc,2)+[-]+SUBS(XsNroDoc,3,2)+[-]+SUBS(XsNroDoc,5)         		
            @ 3,18 SAY LsNroDoc
            
            DATO=SPACE(4)
            @ 3,24 GET DATO PICT "9999" VALID LEN(ALLTRIM(DATO))=4 .AND. ! EMPTY(DATO)
            READ
            XsNroDoc = TsCodDiv1+XsNroMes+DATO+'-'+XsAno
         ELSE
            @ 3,18  GET XsNroDoc PICT "@!"
            READ
         ENDIF
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Arriba,Escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
            IF ! cbdbusca("DPRO")
               LOOP
            ENDIF
            XsNroDoc = NroDoc
         ENDIF
         IF PROV.Tipo=[A]
	         @  3,18 SAY XsNroDoc 
         ELSE
	         @  3,18 SAY XsNroDoc
         ENDIF
   ENDCASE
   IF i = 2 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,1-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE DPRO
LsLlave = XsNroMes + XsCodOPE + XsNroDoc
SEEK LsLlave
RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


*  嬪様様様様様様様様様様様様様様様様様様様様邑
*  �  Objetivo : Poner datos en pantalla      �
*  塒様様様様様様様様様様様様様様様様様様様様余
PROCEDURE xPoner
SELE DPRO
@  2,18 SAY CodDoc
IF PROV.tipo=[A]
	LsNroDoc=LEFT(NroDoc,2)+[-]+SUBS(NroDoc,3,2)+[-]+SUBS(NroDoc,5)         		
	@  3,18 SAY LsNroDoc
ELSE
	@  3,18 SAY NroDoc 
ENDIF
@  2,60 SAY FchRec PICT '@d dd/mm/aa'
@  4,11 SAY CodAux
@  4,18 SAY NomAux PICT "@S33"
@  5,11 SAY RucAux
@  4,60 SAY NroRef
@  5,60 SAY FchDoc PICT '@d dd/mm/aa'
@  6,17 SAY NroO_C
@  6,60 SAY DiaVto PICT "9999"
@  7,17 SAY NroGui
@  7,60 SAY FchVto PICT '@d dd/mm/aa'
@  8,60 say fchped PICT '@d dd/mm/aa'
@  9,24 SAY PADR(MES(VAL(NroMes),1),10,' ')
@ 10,24 SAY NroAst
@ 11,24 SAY CodOpe
DO CASE
   CASE FlgEst = "G"
        @13,21 SAY "ASIENTO GENERADO "
   CASE FlgEst = "P"
        @13,21 SAY "REGISTRADO       "
   CASE FlgEst = "X"
        @13,21 SAY "ASTO. DESCUADRADO"
   CASE FlgEst = "A"
        @13,21 SAY "ANULADO          "
   OTHER
        @13,21 SAY "                 "
ENDCASE
@ 14,21 SAY NomRec
@ 14,21 SAY fchPol
@ 15,21 SAY NomEnv

@ 10,58 SAY IIF(CodMon=1,'S/.','US$')
@ 11,58 SAY TpoCmb PICT "9,999.9999"
@ 12,58 SAY ImpIgv PICT "999,999,999.99"
@ 13,58 SAY Import PICT "999,999,999.99"
@ 18,4  EDIT Observ SIZE 3,71 DISABLE
RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


* 嬪様様様様様様様様様様様様様様様様様様様様様様�
* � Objetivo : Tomar datos adicionales          �
* 塒様様様様様様様様様様様様様様様様様様様様様様�
PROCEDURE xTomar
Crear = .T.
IF &sesrgv
   Crear = .F.
   IF FlgEst $ [G|X]
      GsMsgErr = [ NO PUEDE MODIFICAR ESTE REGISTRO  < CONSULTE EN CONTABILIDAD > ]
      DO lib_merr WITH 99
      UltTecla = Escape_
      RETURN
   ENDIF
   IF FlgEst = [A]
      GsMsgErr = [ ASIENTO ANULADO ]
      DO lib_merr WITH 99
      UltTecla = Escape_
      RETURN
   ENDIF
   IF ! RLOCK()
      UltTecla = Escape_
      RETURN
   ENDIF
   DO xMover
ELSE
   DO xInvar
ENDIF
* * * *
PRIVATE i
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape_)
   i = IIF(!Crear.AND.i<2,2,i)
   GsMsgKey = "[Esc] Salir  [Arriba] [Abajo] [Tab] [S-Tab] Mover "
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1 .AND. Crear
         @  2,60 GET XdFchRec PICT '@d dd/mm/aa'
         READ
         @  2,60 SAY XdFchRec PICT '@d dd/mm/aa'
         XdFchPed = XdFchRec + 45
         UltTecla = LASTKEY()

      CASE i = 2
         SELE AUXI
         @  4,11 GET XsCodAux PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape_
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodAux)
            IF ! cjabusca("AUXI")
               LOOP
            ENDIF
            XsCodAux = CodAux
         ENDIF
         SEEK XsClfAux+XsCodAux
         IF ! FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         XsRucAux = AUXI->RucAux
         XsNomAux = AUXI->NomAux
         @  4,11 SAY XsCodAux
         @  4,18 SAY XsNomAux PICT "@S33"

      CASE i = 3
         @  4,18 GET XsNomAux PICT "@S33"
         READ
         @  4,18 SAY XsNomAux PICT "@S33"
         UltTecla = LASTKEY()

      CASE i = 4
        *@  4,17 GET XsRucAux PICT '########' VALID  LEN(ALLTRIM(XsRucAux))=8 .and. ! EMPTY(XsRucAux)
         @  5,11 GET XsRucAux PICT '########' VALID  LEN(ALLTRIM(XsRucAux))=8 .OR. EMPTY(XsRucAux)
         READ
         @  5,11 SAY XsRucAux
         UltTecla = LASTKEY()

     *CASE i = 4
     *   SELE PROV
     *   @  4,60 GET XsCodDoc PICT "@!"
     *   READ
     *   UltTecla = LASTKEY()
     *   IF UltTecla = Escape_
     *      EXIT
     *   ENDIF
     *   IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
     *      IF ! CBDBUSCA("PROV")
     *         LOOP
     *      ENDIF
     *      XsCodDoc = TpoDoc
     *   ENDIF
     *   @  4,60 SAY XsCodDoc
     *   SEEK XsCodDoc
     *   IF !FOUND()
     *      DO lib_merr WITH 6
     *      LOOP
     *   ENDIF
         @  4,60 SAY XsCodDoc
     *   SELE DPRO
         UltTecla = Enter
      CASE i = 5
         if val(xscoddoc)<=7  &&& FACTURAS, N/D, N/C
            @04,60 GET XsNroRef PICT "@R 999-9999999"  VALID  ! EMPTY(XsNroRef)
            READ
            if XsNroRef <> space(10)
               XsNroRef = tran(val(left(xsnroref,3)),[@L 999])+;
                          tran(val(subs(xsnroref,4)),[@L 9999999])
            endif
            @04,60 SAY XsNroRef pict '@R 999-9999999'
         else
            @04,60 GET XsNroRef PICT "@!"  VALID  ! EMPTY(XsNroRef)
            READ
         endif
         UltTecla = LASTKEY()
         IF CREAR
           IF ! VERIFICA()
              GsMsgErr = [DOCUMENTO DE PROVEEDOR DUPLICADO < CONSULTE EN CONTABILIDAD >]
              DO lib_merr WITH 99
              GsMsgErr = [Prov:]+DPRO.NroAst+[ ]+DPRO.CodAux+[ ]+DPRO.NomAux+[ ]+DPRO.RucAux
              DO lib_merr WITH 99
              i = 1
              RETURN
           ENDIF
         ENDIF


      CASE i = 6
         @  5,60 GET XdFchDoc PICT '@d dd/mm/aa'
         READ
         @  5,60 SAY XdFchDoc PICT '@d dd/mm/aa'
         UltTecla = LASTKEY()

      CASE i = 7
         @  6,60 GET XiDiaVto PICT "9999" RANGE 0,
         READ
         @  6,60 SAY XiDiaVto PICT "9999"
         UltTecla = LASTKEY()
         XdFchVto = XdFchRec + XiDiaVto
         @  7,60 GET XdFchVto PICT '@d dd/mm/aa'
         READ
         @  7,60 SAY XdFchVto PICT '@d dd/mm/aa'
         UltTecla = LASTKEY()
         
      CASE i = 8
         @  8,60 GET XdFchPed PICT '@d dd/mm/aa'
         READ
         @  8,60 SAY XdFchPed PICT '@d dd/mm/aa'
         UltTecla = LASTKEY()

      CASE i = 9
         @  6,17 GET XsNroO_C PICT "@!"
         READ
         @  6,17 SAY XsNroO_C
         UltTecla = LASTKEY()

      CASE i = 10
         @  7,17 GET XsNroGui PICT "@!"
         READ
         @  7,17 SAY XsNroGui
         UltTecla = LASTKEY()

      CASE i = 11 .AND. Crear
         XsCodOpe = PROV->CodOpe
         XsNroAst = LEFT(XsNroDoc,8)
         @ 10,24 SAY XsNroAst
         @ 11,24 SAY XsCodOpe

      CASE i = 12
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,58,2)

      CASE i = 13
         SELE TCMB
         SEEK DTOS(XdFchDoc)
         XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
         @ 11,58 SAY XfTpoCmb PICT "9,999.9999"
         IF XfTpoCmb <= 0
            GsMsgErr = [ Tipo de Cambio NO ESTA AL DIA]
            DO lib_merr WITH 99
            i = 1
            UltTecla = 0
            LOOP
         ENDIF

      CASE i = 14
         @ 12,58 GET XfImpIgv PICT "999,999,999.999" RANGE 0,
         READ
         @ 12,58 SAY XfImpIgv PICT "999,999,999.999"
         UltTecla = LASTKEY()

      CASE i = 15
         @ 13,58 GET XfImport PICT "999,999,999.999" RANGE 0,
         READ
         @ 13,58 SAY XfImport PICT "999,999,999.999"
         UltTecla = LASTKEY()

      CASE i = 16
         @ 14,21 GET XsNomRec
         READ
         @ 14,21 SAY XsNomRec
         UltTecla = LASTKEY()
                 *******
      CASE i = 17
         @ 15,65 GET XdFchPol PICT '@d dd/mm/aa'
         READ
         @ 15,65 SAY XdFchPol PICT '@d dd/mm/aa'
         UltTecla = LASTKEY()

      CASE i = 18
         @ 15,21 GET XsNomEnv
         READ
         @ 15,21 SAY XsNomEnv
         UltTecla = LASTKEY()

      CASE i = 19
         GsMsgKey = "[Shift+Tab] Anterior  [F10] Grabar  [Esc] Cancelar"
         DO lib_mtec WITH 99
         @ 18,4  EDIT XsObserv SIZE 3,71 COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,F10,CtrlW)
            EXIT
         ENDIF
   ENDCASE
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>19,19,i)
ENDDO
IF UltTecla # Escape_
   DO xGrabar
ENDIF
SELE DPRO
UNLOCK ALL
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C�digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99

RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


*  嬪様様様様様様様様様様様様様様様様様様様�
*  � VERIFICA   DUPLICIDAD DE DOCUMENTOS   �
*  塒様様様様様様様様様様様様様様様様様様様�
   FUNCTION VERIFICA
   SELE DPRO
   SET ORDE TO DPRO07
   SEEK XsCodAux+XsCodDoc+XsNroRef
   IF FOUND() .AND. ( XsRucAux = RucAux )
      SET ORDE TO DPRO06
      RETURN .F.
   ENDIF
   SET ORDE TO DPRO06
   RETURN .T.
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


* 嬪様様様様様様様様様様様様様様様様様様様邑
* � Objetivo : Cargar variables            �
* 塒様様様様様様様様様様様様様様様様様様様余
PROCEDURE xMover
SELE DPRO
XsCodDoc = DPRO->CodDoc
XsNroDoc = DPRO->NroDoc
XsNroRef = DPRO->NroRef
**
XsCodAux = DPRO->CodAux
XsNomAux = DPRO->NomAux
XsRucAux = DPRO->RucAux
XdFchDoc = DPRO->FchDoc
XdFchVto = DPRO->FchVto
XiDiaVto = DPRO->DiaVto
XfImport = DPRO->Import
XfImpBrt = DPRO->ImpBrt
XfImpIgv = DPRO->ImpIgv
XiCodMon = DPRO->CodMon
XfTpoCmb = DPRO->TpoCmb
XdFchRec = DPRO->FchRec
XdFchPed = dpro->fchped
XsNomRec = DPRO->NomRec
XsFchPol = DPRO->FchPol
XsNomEnv = DPRO->NomEnv
XcFlgEst = DPRO->FlgEst
XsObserv = DPRO->Observ
XsNroO_C = DPRO->NroO_C
XsNroGui = DPRO->NroGui
** Variables de Contabilidad **
XsCodOpe = DPRO->CodOpe
XsNroAst = DPRO->NroAst
XsNroVou = DPRO->NroVou
RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


* 嬪様様様様様様様様様様様様様様様邑
* � Objetivo : Grabar informaci�n  �
* 塒様様様様様様様様様様様様様様様余
PROCEDURE xGrabar
SELE DPRO
IF Crear
   ** Siempre se toma el control correlativo **
   SELE OPER
   SEEK XsCodOpe
   IF ! REC_LOCK(5)
      RETURN
   ENDIF
   XsNroAst = LoContab.NroAst()          && << OJO >>
   IF EMPTY(XsNroDoc)
	   XsNroDoc = XsNroAst+SPACE(LEN(XsNroDoc)-LEN(XsNroAst))
	   IF PROV->TIPO="A"
	      XsNroDoc = SUBSTR(XsNroDoc,1,8)+"-"+RIGHT(STR(_ANO,4),2)
	   ENDIF
   ENDIF
   WAIT [Correlativo Generado >>> ]+XsNroDoc WINDOW NOWAIT
   * * * *
   SELE DPRO
   LsLlave = XsNroMes+XsNroDoc
   SEEK LsLlave
   IF FOUND()
      GsMsgErr = [Registro creado por otro usuario]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   APPEND BLANK
   IF ! REC_LOCK(5)
      RETURN
   ENDIF
   REPLACE NroDoc WITH XsNroDoc
   **
   SELE OPER
   =NroAst(XsNroAst)    && << Actualiza # de asiento en el correlativo >>
   UNLOCK
ENDIF
SELE DPRO
REPLACE CodDoc WITH XsCodDoc
REPLACE NroRef WITH XsNroRef
REPLACE ClfAux WITH XsClfAux
REPLACE CodAux WITH XsCodAux
REPLACE NomAux WITH ALLTRIM(XsNomAux)
REPLACE RucAux WITH XsRucAux
REPLACE FchDoc WITH XdFchDoc
REPLACE FchVto WITH XdFchVto
REPLACE DiaVto WITH XiDiaVto
REPLACE ImpBrt WITH XfImpBrt
REPLACE ImpIgv WITH XfImpIgv
REPLACE Import WITH XfImport
REPLACE SdoDoc WITH XfImport
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE FchRec WITH XdFchRec
repla   FchPed with XdFchPed
REPLACE NomRec WITH XsNomRec
REPLACE FchPol WITH XdFchPol
REPLACE NomEnv WITH XsNomEnv
REPLACE FlgEst WITH XcFlgEst
REPLACE Observ WITH XsObserv
REPLACE NroO_C WITH XsNroO_C
REPLACE NroGui WITH XsNroGui
REPLACE CodOpe WITH XsCodOpe
REPLACE NroMes WITH XsNroMes
REPLACE NroAst WITH LEFT(XsNroDoc,8)
REPLACE NroVou WITH XsNroDoc
REPLACE FchAst WITH XdFchRec
REPLACE CodCta WITH PROV->CodCta

RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


*嬪様様様様様様様様様様様様様様様様様様様邑
*� Objetivo : Borrar informaci�n          �
*塒様様様様様様様様様様様様様様様様様様様余
PROCEDURE xBorrar

SELE DPRO
IF FlgEst = [G]
   GsMsgErr = [NO PUEDE ANULAR ESTE REGISTRO]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = [X]
   GsMsgErr = [NO PUEDE ANULAR ESTE REGISTRO]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = [C]
   GsMsgErr = [Documento Cancelado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = [A]
   GsMsgErr = [Documento Anulado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
SELE DPRO
DELETE
UNLOCK ALL
SKIP
RETURN
*様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�*


* 嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
* �  Reporte de Documentos digitados por dia de recepci�n   �
* 塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
PROCEDURE XREPORTE
SAVE SCREEN TO  PANT
CLEAR
@ 2,0 TO 20,79 PANEL
@ 2,20  SAY "LISTADO DE DOCUMENTOS RECEPCIONADOS DE PROVEEDORES"
** variables a usar **
PRIVATE XdFchRec
XcFlgEst = " "
XdFchRe1 = DATE()
XdFchRe2 = DATE()
** pantalla de datos **
@ 10,20 SAY "F.Recepcion Desde :" GET XdFchRe1 PICT '@d dd/mm/aa'
@ 11,20 SAY "F.Recepcion Hasta :" GET XdFchRe2 PICT '@d dd/mm/aa'
@ 12,20 SAY "Situaci�n         :" GET XcFlgEst VALID FlgEst$"GPAX "
READ
IF LASTKEY() = Escape_
   RESTORE  SCREEN FROM  PANT
   RETURN
ENDIF
** test de impresi�n **
XFOR1 = [.T.]
IF !EMPTY(XcFlgEst)
   XFOR1=[FlgEst=XcFlgEst]
ENDIF
XFOR   = "FchRec>=XdFchRe1 .AND. FchRec<=XdFchRe2 .AND."+XFOR1
XWHILE = "NroMes=XsNroMes"
** buscamos registro de arranque **
SELE DPRO
SET ORDER TO DPRO06
SEEK XsNroMes
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
*IniPrn = ''
sNomRep = "cjar5100"
DO F0print WITH "REPORTS"
RESTORE  SCREEN FROM PANT
SET ORDER TO DPRO06
RETURN


********************************************************************** FIN() *
* Objetivo : Localizar el documento por el No. de Asiento
******************************************************************************
PROCEDURE xLocalizar

GsMsgKey = "[Esc] Salir  [Enter] Registrar"
DO LIB_MTEC WITH 99
SELE DPRO
PRIVATE XsNroAst
XsNroDoc = SPACE(LEN(DPRO->NroAst))
@ 10,18 GET XsNroAst PICT "@!"
READ
IF LASTKEY() # Escape_ .AND. !EMPTY(XsNroAst+XsNroO_C)
   DO CASE
      CASE !EMPTY(XsNroAst) .AND. EMPTY(XsNroO_C)
         LOCATE FOR TRIM(XsNroAst)$NroAst
      CASE EMPTY(XsNroAst) .AND. !EMPTY(XsNroO_C)
         LOCATE FOR TRIM(XsNroO_C)$NroO_C
      OTHER
         LOCATE FOR TRIM(XsNroO_C)$NroO_C .AND. TRIM(XsNroAst)$NroAst
   ENDCASE
   DO WHILE FOUND()
      DO xPoner
		nResp=f1_alert('Continua la busqueda','SI_O_NO')              
      IF nResp = 2
         EXIT
      ENDIF
      CONTINUE
   ENDDO
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C�digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99
RETURN

***************
FUNCTION NROAST
***************

PARAMETER XsNroAst
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = OPER->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = OPER->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = OPER->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = OPER->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = OPER->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = OPER->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = OPER->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = OPER->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = OPER->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = OPER->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = OPER->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = OPER->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = OPER->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = OPER->NDOC13
   OTHER
     iNroDoc = OPER->NRODOC
ENDCASE

IF OPER->ORIGEN
   ZZ      = TsCOdDiv1+XsNroMes + RIGHT("00000000" + LTRIM(STR(iNroDoc)), 4)
   iNroDoc = VAL(ZZ)
ENDIF

IF PARAMETER() = 1
   IF VAL(XsNroAst) > iNroDoc
     iNroDoc = VAL(XsNroAst) + 1
   ELSE
     iNroDoc = iNroDoc + 1
   ENDIF

   DO CASE
      CASE XsNroMES = "00"
        REPLACE   OPER->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   OPER->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN OPER
ENDIF
RETURN  RIGHT("00000000" + LTRIM(STR(iNroDoc)), 8)
