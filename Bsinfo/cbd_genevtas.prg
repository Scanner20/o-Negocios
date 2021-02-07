**
** GeneVtas.Prg
**
** Modificacion : VETT 2008-03-19
CLOSE DATA
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "GENERACION DE VENTAS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
@  7,08 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  8,08 SAY '³                     I M P O R T A N T E                     ³'
@  9,08 SAY '³                                                             ³'
@ 10,08 SAY '³    Este proceso tiene por finalidad Generar los Asientos    ³'
@ 11,08 SAY '³   Contables para el Registro de Ventas, en el mes en el     ³'
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
XsCodOpe = [004]
GsClfAux = [001]
*//
DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
SELE 0
USE CCBRGDOC   ALIAS GDOC   ORDER GDOC08
IF !USED()
   SELE GDOC
   USE
   RETURN .F.
ENDIF
SELE 0
USE vtaritem ALIAS deta ORDER item01
IF !USED()
   SELE GDOC
   USE
   RETURN .F.
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
SELE GDOC
Seek XsAnoAct+XsNroMes
Do While !Eof() .And. LEFT(DTOS(FchDoc),6)=XsAnoAct+XsNroMes
   If YEAR(FchDoc)#_Ano .And. MONTH(FchDoc)#_Mes
      Skip
      Loop
   EndIf
   IF CodDoc#[FACT] .AND. CodDoc#[BOLE] .And. CodDoc#[N/C] .And. CodDoc#[N/A]
      Skip
      Loop
   ENDIF
   WAIT WINDOW "CCBRGDOC "+Gdoc.NroDoc NoWait
   PRIVATE XsNroMes,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,XsCodOpe,XsNroAst
   XsNroMes = TRANS(_Mes,"@L ##")
   XdFchAst = GDOC->FchDoc
   XsNroVou = []
   XiCodMon = GDOC->CodMon
   XfTpoCmb = GDOC->TpoCmb
   If Gdoc.FlgEst=[A]   && Anulado
      XsNotAst = [ANULADA.]+GDOC->CodDoc+[-]+GDOC.NRODOC+[.]+GDOC->NomCli
   Else
      XsNotAst = [PROV. ]+GDOC->CodDoc+[-]+GDOC.NRODOC+[. ]+GDOC->NomCli
   EndIf
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
   REPLACE CODDOC WITH GDOC.CODDOC
   REPLACE NRODOC WITH GDOC.NRODOC
   SELE GDOC
   REPLACE NroMes WITH XsNroMes
   REPLACE CodOpe WITH XsCodOpe
   REPLACE NroAst WITH XsNroAst
   REPLACE FlgCtb WITH .T.
   FLUSH
   IF EMPTY(GDOC.NroAst)
      DO Close_File
      RETURN .F.
   ENDIF
   SELECT OPER
   =NROAST(XsNroAst)
   SELECT Head
   REPLACE FchAst WITH XdFchAst
   REPLACE NroVou WITH XsNroVou
   REPLACE CodMon WITH XiCodMon
   REPLACE TpoCmb WITH XfTpoCmb
   REPLACE NotAst WITH XsNotAst
   REPLACE Digita WITH GsUsuario
   * Grabamos Detalle *
   PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
   PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
   PRIVATE XfImport,XdFchDoc,XdFchVto
   * Cuenta de Factura
  *=SEEK(GDOC->CodDoc,"TDOC")
   XiNroItm = 1
   XcEliItm = [ ]
   Do Case
      Case GDOC.Codmon = 1
         XsCodCta   = [12101]
      Case GDOC.Codmon = 2
         XsCodCta   = [12102]
      other 
      	 XsCodCta   = [XXXXX]   
   EndCase
   XsCodRef = GDOC->CodDoc
   =SEEK(XsCodCta,"CTAS")
   IF CTAS->PIDAUX="S"
      XsClfAux = GsClfAux
      XsCodAux = GDOC->CodCli
      XsNroRuc = GDOC->RucCli
   ELSE
      XsClfAux = SPACE(LEN(Item->ClfAux))
      XsCodAux = SPACE(LEN(Item->CodAux))
      XsNroRuc = SPACE(LEN(Item->NroRuc))
   ENDIF
   XcTpoMov = [D]
   XfImport = GDOC->ImpTot
   IF XiCodMon = 1
      XfImpNac = XfImport
      XfImpUsa = IIF(XfTpoCmb>0,XfImport/XfTpoCmb,0)
   ELSE
      XfImpUsa = XfImport
      XfImpNac = XfImport*XfTpoCmb
   ENDIF
   XsGloDoc = GDOC->NomCli
   XsCodDoc = GDOC->CodDoc
   XsNroDoc = GDOC->NroDoc
   XsNroRef = GDOC->NroDoc
   XdFchDoc = GDOC->FchDoc
   XdFchVto = GDOC->FchVto
   *//
   Do Case
      Case GDOC.CodDoc= [FACT]
           XsCodDoc   = [01]
      Case GDOC.CodDoc= [BOLE]
           XsCodDoc   = [03]
      Case GDOC.CodDoc= [N/A ]
           XsCodDoc   = [07]
      Case GDOC.CodDoc= [N/C ]
           XsCodDoc   = [08]
   EndCase
   XcTpoMov = IIF(XsCodDoc=[07],[H],[D])
   XsSerRef = LEFT(GDOC->NroDoc,3)
   XsNroRef = SUBS(GDOC->NroDoc,4)
   IF GDOC.FlgEst=[A]   && Anulado
      XsGloDoc = [>>>>  A N U L A D A <<<<]
      XfImport = 0
      XfImpUsa = 0
   EndIf
   DO MovbVeri In Vtammovm
   *// Que en Asientos Anulados no tome cuentas # 12
   If GDOC.FlgEst=[A]   && Anulado
      SELE GDOC
      SKIP
      LOOP
   EndIf
   * Cuenta de Impuestos
   IF GDOC.FlgEst <> [A]   && Anulado
      XcEliItm = [ ]
      XsCodCta = [40111]
      XsCodRef = GDOC->CodDoc
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = GsClfAux
         XsCodAux = GDOC->CodCli
         XsNroRuc = GDOC->RucCli
      ELSE
         XsClfAux = SPACE(3)
         XsCodAux = SPACE(11)
         XsNroRuc = SPACE(11)
      ENDIF
      XcTpoMov = IIF(GDOC.CodDoc=[N/A ],[D],[H])
      XfImport = GDOC->ImpIgv
      IF XiCodMon = 1
         XfImpNac = XfImport
         XfImpUsa = IIF(XfTpoCmb>0,XfImport/XfTpoCmb,0)
      ELSE
         XfImpUsa = XfImport
         XfImpNac = XfImport*XfTpoCmb
      ENDIF
      XsGloDoc = []
      XsCodDoc = GDOC->CodDoc
      XsNroDoc = GDOC->NroDoc
      XsNroRef = GDOC->NroDoc
      XdFchDoc = {}
      XdFchVto = {}
      Do Case
         Case GDOC.CodDoc= [FACT]
              XsCodDoc   = [01]
         Case GDOC.CodDoc= [BOLE]
              XsCodDoc   = [03]
         Case GDOC.CodDoc= [N/A ]
              XsCodDoc   = [07]
         Case GDOC.CodDoc= [N/C ]
              XsCodDoc   = [08]
      EndCase
      DO MovbVeri IN vtammovm
      *** Actualiza Cuenta de Ingresos (70) ***
      SELE DETA
      SEEK GDOC.CodDoc+GDOC.NroDoc
      DO WHILE !EOF() .AND. Coddoc+Nrodoc = GDOC.CodDoc+GDOC.NroDoc
         XcEliItm = [ ]
         XsCodCta = IIF(GDOC.Gratui="N",Codcta,"66901")
         XsCodRef = GDOC.CodDoc
         =SEEK(XsCodCta,"CTAS")
         IF CTAS->PIDAUX="S"
            XsClfAux = GsClfAux
            XsCodAux = GDOC.CodCli
            XsNroRuc = GDOC.RucCli
         ELSE
            XsClfAux = SPACE(3)
            XsCodAux = SPACE(11)
            XsNroRuc = SPACE(11)
         ENDIF
         XcTpoMov = IIF(GDOC.CodDoc=[N/A ],[D],[H])
         XfImport = Implin
         IF XiCodMon = 1
            XfImpNac = XfImport
            XfImpUsa = IIF(XfTpoCmb>0,XfImport/XfTpoCmb,0)
         ELSE
            XfImpUsa = XfImport
            XfImpNac = XfImport*XfTpoCmb
         ENDIF
         XsGloDoc = []
         XsCodDoc = GDOC.CodDoc
         XsNroDoc = GDOC.NroDoc
         XsNroRef = GDOC.NroDoc
         XdFchDoc = {}
         XdFchVto = {}
         Do Case
            Case GDOC.CodDoc= [FACT]
                 XsCodDoc   = [01]
            Case GDOC.CodDoc= [BOLE]
                 XsCodDoc   = [03]
            Case GDOC.CodDoc= [N/A ]
                 XsCodDoc   = [07]
            Case GDOC.CodDoc= [N/C ]
                 XsCodDoc   = [08]
         EndCase
         DO MovbVeri IN vtammovm
         SELE DETA
         SKIP
      ENDDO
   ENDIF
   SELE GDOC
   SKIP
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