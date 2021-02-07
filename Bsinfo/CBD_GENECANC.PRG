**
** GeneCanc.Prg
**
** Modificacion : VETT 2008-03-19

CLOSE DATA
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CANCELACION DE VENTAS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
@  7,08 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  8,08 SAY '³                     I M P O R T A N T E                     ³'
@  9,08 SAY '³                                                             ³'
@ 10,08 SAY '³    Este proceso tiene por finalidad Generar los Asientos    ³'
@ 11,08 SAY '³   Contables de cancelaci¢n de Ventas, en el mes en el       ³'
@ 12,08 SAY '³   cual estoy trabajando.                                    ³'
@ 13,08 SAY '³                                                             ³'
@ 14,08 SAY '³      Al transferir, se eliminar n todos los asientos de     ³'
@ 15,08 SAY '³   dicha Operaci¢n, y ser n reemplazadas por ‚ste nuevo      ³'
@ 16,08 SAY '³   traslado, se aconseja hacer todas las modificaciones      ³'
@ 17,08 SAY '³   despu‚s de hacer la transferencia.                        ³'
@ 18,08 SAY '³                                                             ³'
@ 19,08 SAY '³                      < C >  - Continuar                     ³'
@ 20,08 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
*
GsMsgKey = "[Esc] Cancelar Proceso        [C] Iniciar proceso"
DO LIB_Mtec WITH 99
************************************************************************
* Pide Confirmaci¢n de Ingreso ******
************************************************************************
FinTecla = Chr(Escape)+"cC"
UltTecla = 0
Do While ! Chr(UltTecla)$FinTecla
   UltTecla = Inkey(0)
   UltTecla = Iif(UltTecla >0 , UltTecla , 0 )
   If UltTecla = Escape
      Close Data
      Return
   EndIf
EndDo
*//
XsNroMes = TRANS(_MES,"@L ##")
XsAnoAct = TRANS(_Ano,"@L ####")
**XsCodOpe = [050]
XsCodOpe = IIF("CLIENTES\STI"$Pathdef,'060','050')
GsClfAux = [001]
*//
DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
SELE 0
USE CCBMVTOS ALIAS VTOS ORDER VTOS11
IF !USED()
   SELE VTOS
   USE
   RETURN .F.
ENDIF
SELE 0
USE TARJETA  ALIAS TARJ ORDER TARJ02
IF !USED()
   SELE TARJ
   USE
   RETURN .F.
ENDIF
SELE 0
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
IF !Open_File()
   RETURN .F.
ENDIF
*// Eliminando cabecera
Sele Head
Seek XsNroMes+XsCodOpe
Do While !Eof() .And. NroMes+CodOpe=XsNroMes+XsCodOpe
   Wait Window "Eliminado Cabecera "+NroMes+CodOpe+[-]+NroAst NoWait
   If Rec_Lock(5)
      Delete
      Skip
   EndIf
EndDo
*// Eliminando Detalle
Sele Item
Seek XsNroMes+XsCodOpe
Do While !Eof() .And. NroMes+CodOpe=XsNroMes+XsCodOpe
   Wait Window "Eliminado Detalles "+NroMes+CodOpe+[-]+NroAst NoWait
   Select Item
   If !Rec_Lock(5)
      Loop
   EndIf
   If !XsCodOpe = "9"
      DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
   Else
      DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
   EndIf
   Delete
   UnLock
   Skip
EndDo
*// Renumerando Items
XiNroDoc = 1
Sele Oper
Seek XsCodOpe
Do Case
   Case XsNroMES = "00"
        REPLACE   OPER->NDOC00 WITH XiNroDoc
   Case XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH XiNroDoc
   Case XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH XiNroDoc
   Case XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH XiNroDoc
   Case XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH XiNroDoc
   Case XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH XiNroDoc
   Case XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH XiNroDoc
   Case XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH XiNroDoc
   Case XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH XiNroDoc
   Case XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH XiNroDoc
   Case XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH XiNroDoc
   Case XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH XiNroDoc
   Case XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH XiNroDoc
   Case XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH XiNroDoc
   Other
        REPLACE   OPER->NRODOC WITH XiNroDoc
EndCase
UnLock All
*//
SELE VTOS
Seek XsAnoAct+XsNroMes
Do While !Eof() .And. LEFT(DTOS(FchDoc),6)=XsAnoAct+XsNroMes
   XsNrodia = RIGHT(DTOS(FchDoc),2)
   Do While !Eof() .And. DTOS(FchDoc)=XsAnoAct+XsNroMes+XsNrodia
      XsTarjet = ALLTRIM(Tarjet)
      =SEEK(ALLTRIM(VTOS.Tarjet),"TARJ")
      IF YEAR(FchDoc)#_Ano .And. MONTH(FchDoc)#_Mes
         Skip
         Loop
      EndIf
      IF !INLIST(Codref,[FACT],[BOLE],[N/C],[N/A])
         Skip
         Loop
      ENDIF
      IF INLIST(Xstarjet,[CREDITO])
         Skip
         Loop
      ENDIF
      ***WAIT WINDOW "CCBMVTOS "+VTOS.NroDoc NoWait
      PRIVATE XsNroMes,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,XsCodOpe,XsNroAst
      XsNroMes = TRANS(_Mes,"@L ##")
      XdFchAst = VTOS.FchDoc
      IF SEEK(DTOC(XdFchAST,1),"TCMB")
         XfTpocmb= TCMB.Ofivta
      ENDIF
      XsNroVou = []
      XsCtacja = TARJ.Codcta
      =SEEK(XsCtacja,"CTAS")
      XiCodMon = CTAS.Codmon
******XfTpoCmb = VTOS.TpoCmb
      =SEEK(XsCodOpe,"OPER")
      IF !RLOCK("OPER")
         DO Close_File
         RETURN .F.
      ENDIF
      XsNroAst = NROAST()
      WAIT "Generando Asiento "+XsNroAst WINDOW NOWAIT
      SELE Head
      APPEND BLANK
      IF !REC_LOCK(5)
         DO Close_File
         RETURN .F.
      ENDIF
      REPLACE NroMes WITH XsNroMes
      REPLACE CodOpe WITH XsCodOpe
      REPLACE NroAst WITH XsNroAst
      REPLACE FlgEst WITH "R"
      REPLACE CODDOC WITH VTOS.CODref
      REPLACE NRODOC WITH VTOS.NROref
      SELE VTOS
      REPLACE NroMes WITH XsNroMes
      REPLACE CodOpe WITH XsCodOpe
      REPLACE NroAst WITH XsNroAst
      REPLACE FlgCtb WITH .T.
      FLUSH
      IF EMPTY(VTOS.NroAst)
         DO Close_File
         RETURN .F.
      ENDIF
      SELECT OPER
      =NROAST(XsNroAst)
      SELECT Head
      REPLACE FchAst WITH XdFchAst
      REPLACE NroVou WITH XsNroVou
      REPLACE CodMon WITH 1
      REPLACE TpoCmb WITH XfTpoCmb
      REPLACE NotAst WITH "Cancela Documentos: "+Xstarjet
      REPLACE Digita WITH GsUsuario
      TfImpnac = 0
      TfImpusa = 0
      SfImpnac = 0
      SfImpusa = 0
      SELE VTOS
      Do While !Eof() .And. DTOS(FchDoc)+ALLTRIM(Tarjet)=XsAnoAct+XsNroMes+XsNrodia+XsTarjet
         * Grabamos Detalle *
         PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
         PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
         PRIVATE XfImport,XdFchDoc,XdFchVto
         * Cuenta de Factura
         XiNroItm = 1
         XcEliItm = [ ]
         Do Case
            Case VTOS.Codmon = 1
               XsCodCta   = [12101]
            Case VTOS.Codmon = 2
               XsCodCta   = [12101]
         EndCase
         XsCodRef = VTOS.CodDoc
         =SEEK(XsCodCta,"CTAS")
         IF CTAS->PIDAUX="S"
            XsClfAux = GsClfAux
            XsCodAux = VTOS.CodCli
            XsNroRuc = VTOS.Codcli
         ELSE
            XsClfAux = SPACE(LEN(Item->ClfAux))
            XsCodAux = SPACE(LEN(Item->CodAux))
            XsNroRuc = SPACE(LEN(Item->NroRuc))
         ENDIF
         XiCodMon = VTOS.Codmon
         XfTpoCmb = VTOS.TpoCmb
         XdFchDoc = VTOS.FchDoc
         XfImport = VTOS.Import
         IF XiCodMon = 1
            XfImpNac = XfImport
            XfImpUsa = XfImport/XfTpoCmb
         ELSE
            XfImpUsa = XfImport
            XfImpNac = XfImport*XfTpoCmb
         ENDIF
         XsGloDoc = ""
         XsCodDoc = VTOS.Codref
         XsNroDoc = VTOS.Nroref
         XsNroRef = VTOS.Nroref
         XdFchVto = VTOS.Fchdoc
         *//
         Do Case
            Case VTOS.Codref= [FACT]
                 XsCodDoc   = [01]
            Case VTOS.Codref= [BOLE]
                 XsCodDoc   = [03]
            Case VTOS.Codref= [N/A ]
                 XsCodDoc   = [07]
            Case VTOS.Codref= [N/C ]
                 XsCodDoc   = [08]
         EndCase
         XcTpoMov = IIF(XsCodDoc=[07],[D],[H])
         XsSerRef = LEFT(VTOS.NroDoc,3)
         XsNroRef = SUBS(VTOS.NroDoc,4)
         DO MovbVeri In Vtammovm
         *// Que en Asientos Anulados no tome cuentas # 12
         *** Cuenta de caja ***
         =SEEK(ALLTRIM(VTOS.Tarjet),"TARJ")
         IF TARJ.Fmacon = "D"
            XcEliItm = [ ]
            XsCodCta = TARJ.Codcta
            IF XsCodcta = "10101"
               IF XiCodmon = 2
                  XsCodcta = "10102"
               ENDIF
            ENDIF
            XsCodRef = VTOS.CodDoc
            =SEEK(XsCodCta,"CTAS")
            IF CTAS->PIDAUX="S"
               XsClfAux = GsClfAux
               XsCodAux = VTOS.Codcli
               XsNroRuc = VTOS.Codcli
            ELSE
               XsClfAux = SPACE(3)
               XsCodAux = SPACE(11)
               XsNroRuc = SPACE(11)
            ENDIF
            XcTpoMov = IIF(XcTpomov=[H],[D],[H])
            XfImport = VTOS.Import*(100-TARJ.Porcom)/100
            XfTpocmb = VTOS.Tpocmb
            IF XiCodMon = 1
               XfImpNac = XfImport
               XfImpUsa = XfImport/XfTpoCmb
            ELSE
               XfImpUsa = XfImport
               XfImpNac = XfImport*XfTpoCmb
            ENDIF
            XsGloDoc = []
            XsCodDoc = VTOS.Codref
            XsNroDoc = VTOS.Nroref
            XsNroRef = VTOS.Nroref
            XdFchDoc = VTOS.Fchdoc
            XdFchVto = {,,}
            Do Case
               Case VTOS.Codref= [FACT]
                    XsCodDoc   = [01]
               Case VTOS.Codref= [BOLE]
                    XsCodDoc   = [03]
               Case VTOS.Codref= [N/A ]
                    XsCodDoc   = [07]
               Case VTOS.Codref= [N/C ]
                    XsCodDoc   = [08]
            EndCase
            DO MovbVeri IN vtammovm
            IF TARJ.Porcom > 0
               XcEliItm = [ ]
               XsCodCta = TARJ.Ctacom
               XsCodRef = ""
               IF CTAS->PIDAUX="S"
                  XsClfAux = GsClfAux
                  XsCodAux = VTOS.Codcli
                  XsNroRuc = VTOS.Codcli
               ELSE
                  XsClfAux = SPACE(3)
                  XsCodAux = SPACE(11)
                  XsNroRuc = SPACE(11)
               ENDIF
               XfImport = VTOS.Import*(TARJ.Porcom)/100
               IF XiCodMon = 1
                  XfImpNac = XfImport
                  XfImpUsa = XfImport/XfTpoCmb
               ELSE
                  XfImpUsa = XfImport
                  XfImpNac = XfImport*XfTpoCmb
               ENDIF
               XsGloDoc = []
               XsCodDoc = VTOS.Codref
               XsNroDoc = VTOS.Nroref
               XsNroRef = VTOS.Nroref
               XdFchDoc = VTOS.Fchdoc
               XdFchVto = {,,}
               Do Case
                  Case VTOS.Codref= [FACT]
                       XsCodDoc   = [01]
                  Case VTOS.Codref= [BOLE]
                       XsCodDoc   = [03]
                  Case VTOS.Codref= [N/A ]
                       XsCodDoc   = [07]
                  Case VTOS.Codref= [N/C ]
                       XsCodDoc   = [08]
               EndCase
               DO MovbVeri IN vtammovm
            ENDIF
         ELSE
            XiCodmon = VTOS.Codmon
            XfImport = VTOS.Import
            XdFchdoc = VTOS.Fchdoc
            XfTpocmb = VTOS.Tpocmb
            IF XiCodMon = 1
               TfImpnac = TfImpnac + XfImport
               TfImpusa = TfImpusa + (XfImport/XfTpoCmb)
            ELSE
               SfImpusa = SfImpusa + XfImport
               SfImpnac = SfImpnac + (XfImport*XfTpoCmb)
            ENDIF
         ENDIF
         SELE VTOS
         SKIP
      ENDDO
      =SEEK(ALLTRIM(XsTarjet),"TARJ")
      IF TARJ.Fmacon = "T"
         IF TfImpnac <> 0
            XsCodCta = TARJ.Codcta
            =SEEK(XsCodcta,"CTAS")
            XiCodmon = CTAS.Codmon
            XcTpoMov = IIF(XcTpomov=[H],[D],[H])
            XsGloDoc = []
            XsCodDoc = []
            XsNroDoc = []
            XsNroRef = []
            XdFchDoc = {,,}
            XdFchVto = {,,}
            XfImpnac = TfImpnac*(100-TARJ.Porcom)/100
            XfImpusa = TfImpusa*(100-TARJ.Porcom)/100
            DO MovbVeri IN vtammovm
         ENDIF
         IF SfImpusa <> 0
            XsCodCta = "10102"
            =SEEK(XsCodcta,"CTAS")
            XiCodmon = CTAS.Codmon
            XcTpoMov = [D]
            XsGloDoc = []
            XsCodDoc = []
            XsNroDoc = []
            XsNroRef = []
            XdFchDoc = {,,}
            XdFchVto = {,,}
            XfImpnac = SfImpnac*(100-TARJ.Porcom)/100
            XfImpusa = SfImpusa*(100-TARJ.Porcom)/100
            DO MovbVeri IN vtammovm
         ENDIF
         IF TARJ.Porcom > 0
            XsCodCta = TARJ.Ctacom
            XsGloDoc = []
            XsCodDoc = []
            XsNroDoc = []
            XsNroRef = []
            XdFchDoc = {,,}
            XdFchVto = {,,}
            XfImpnac = TfImpnac - XfImpnac
            XfImpusa = TfImpusa - XfImpusa
            DO MovbVeri IN vtammovm
         ENDIF
      ENDIF
   ENDDO
   SELE VTOS
ENDDO
DO Close_File
RETURN
*********************************************************************** FIN() *
* Objeto : Abrir Base de Contabilidad
******************************************************************************
PROCEDURE Open_File
SELE 0
USE cbdmctas ORDER ctas01 ALIAS CTAS
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE &DirCtb.cbdvmovm ORDER vmov01 ALIAS Head
IF !USED()
   SELE CTAS
   USE
   RETURN .F.
ENDIF
SELE 0
USE &DirCtb.cbdrmovm ORDER rmov01 ALIAS Item
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   RETURN .F.
ENDIF
SELE 0
USE &DirCtb.cbdtoper ORDER oper01 ALIAS OPER
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   SELE Item
   USE
   RETURN .F.
ENDIF
SELE 0
USE &DirCtb.cbdacmct ORDER acct01 ALIAS ACCT
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   SELE Item
   USE
   SELE OPER
   USE
   RETURN .F.
ENDIF
RETURN .T.
*********************************************************************** FIN() *
* Objeto : Cerrar Base de Contabilidad
******************************************************************************
PROCEDURE Close_File
SELE CTAS
USE
SELE Head
USE
SELE Item
USE
SELE OPER
USE
SELE ACCT
USE
RETURN
