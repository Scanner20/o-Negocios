*имммммммммммммммяммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╩
*╨ Nombre        Ё almpms1a.prg                                                ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Sistema       Ё Almacenes e Inventarios                                     ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Autor         Ё VETT                   Telf: 4841538                        ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Ciudad        Ё LIMA , PERU                                                 ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Direcci╒n     Ё Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Prop╒sito     Ё Registro de los movimientos de salida                       ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Creaci╒n      Ё 01/12/95                                                    ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Actualizaci╒n Ё 17/09/1999                                                  ╨
*╨               Ё                                                             ╨
*хмммммммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪
CLEAR
CLOSE DATA
=F1QEH("INIC_SIS")
** Definiendo Variables a necesitar **
RESTORE FROM ALMCONFG ADDITIVE
cE1    = ""
cE2    = ""
m.DesMov = ""
m.lPidRf1 = .F.
m.GloRf1 = ""
m.TpoRf1 = ""
m.lPidRf2 = .F.
m.GloRf2 = ""
m.TpoRf2 = ""
m.lPidRf3 = .F.
m.GloRf3 = ""
m.TpoRf3 = ""
XsTpoRef =[]
m.CmpRef =[]
m.VarRef =[]
m.FechVen=[]


m.lPidVen = .F.
m.lPidCli = .F.
m.lPidPro = .F.
m.lPidOdT = .F.
m.lModPre = .F.
m.lUndStk = .T.
m.lUndVta = .F.
m.lUndCmp = .F.
m.lModCsm = .F.
m.lAfeTra = .F.

m.lExtPco = .F.
m.lPidPco = .F.
m.lMonNac = .T.
m.lMonUsa = .F.
m.lMonElg = .F.
m.lStkNeg = .F.
m.GloAux  = []
m.GloAux1 = []   && Ivan 09/09/999
m.GloVen  = []
m.sCodPrd = []
m.FBatch  = 1

m.cTipMov = "S"
m.sCodMov = ""     && << OJO : Filtra los que tienen ModPre ="X" <<
*********************
m.fImpTot = 0.00
m.fImpBrt = 0.00
m.fPorIgv = 0.00
m.fImpIgv = 0.00
*********************
m.sNroDoc = ""
m.dFchDoc = GdFecha
m.sNroRf1 = ""
m.sNroRf2 = ""
m.sNroRf3 = ""
m.sNroOdt = ""
m.sCodVen = ""
m.sCodPro = ""
m.sCodCli = ""  && Ivan 23/08/99
m.sCodZon = ""  && Ivan 10/09/99
m.sObserv = ""
m.sCodAux = ""
m.sCodAux1= ""  && Ivan 23/08/99
m.sClfAux = ""  
m.nCodMon = 0
m.fTpoCmb = 0.00

** datos del transportista **
m.NomTra = []
m.DirTra = []
m.RucTra = []
m.PlaTra = []
m.Brevet = []

m.Motivo = 4

*
spdesm=[@S40]
blPidPro=.F.



_LLAVE = []

*
ScrMov = 1    && Pantalla de Presentaci╒n
Crear  = .t.
XlMate = .F.
GnTotDel = 0
*

** Variables para el control del browse
PRIVATE m.btitulo,m.bcampos,m.bfiltro,m.bClave1,m.bClave2
PRIVATE m.bDefBrow,sModulo
PRIVATE nX0,nY0,nX1,nY1
STORE [] TO m.btitulo,m.bcampos,m.bfiltro,m.bClave1,m.bClave2,m.bDeta
STORE .F.TO m.bDefBrow
STORE 0 TO nX0,nY0,nX1,nY1
sModulo = [SALIDAS]



sTUnd = [STK]
sTMon = [S/.]


** Definimos Movimiento de Trabajo **
CLOSE DATA
** para cierre logico **
PRIVATE XdFchCie
XdFchCie = {,,}         && Fecha de cierre logico de almacenes
**--------------------**
* Bases de datos *
=F1QEH("ABRE_DBF")
USE almCTRAN IN 0 ORDER CTRA01 ALIAS CTRA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
Arch = PATHUSER+SYS(3)
USE almDTRAN IN 0 ORDER DTRA01 ALIAS DTRA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SELE 0
CREATE TABL &Arch. (CodMat C(8)   , DesMat C(40) ,CanDes N(14,4),UndVta C(3),;
                    PreUni N(14,4),ImpCto N(14,4),NroItm N(5),CodAlm C(3),   ;
                    SubAlm C(3)   ,TipMov C(1)   ,CodMov C(3),NroDoc C(10),  ;
                    Factor N(7,4) ,NroReg N(6), CodPro C(6),CodZon C(4),     ;
                    NroRef C(10),TpoRef C(3),FechVen D(8))
USE &arch. ALIAS TEMP EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,5,0) TAG DTRA01
*
USE almCATGE IN 0 ORDER CATG01 ALIAS CATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almCATAL IN 0 ORDER CATA01 ALIAS CALM
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almCdocm IN 0 ORDER CDOC01 ALIAS CDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS AUXI
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE admmtcmb IN 0 ORDER TCMB01 ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almTDIVF IN 0 ORDER DIVF01 ALIAS DIVF
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almESTCM IN 0 ORDER ESTA01 ALIAS ESTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almESTTR IN 0 ORDER ESTR01 ALIAS ESTR
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE ALMEQUNI IN 0 ORDER EQUN01 ALIAS EQUN
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almTGSIS IN 0 ORDER TABL01 ALIAS TABL
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE almCFTRA IN 0 ORDER CFTR01 ALIAS CFTR
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
*
*USE almTALMA IN 0 ORDER ALMA01 ALIAS ALMA
*IF ! USED()
*   CLOSE DATA
*   RETURN
*ENDIF
*
SELE 0
USE SEDES 
SET FILTER TO ACTIVA=[X]
GO TOP
m.Sede_Act=Codigo
m.Nomb_Sed=Nombre
use
***
sele CFTR
SET FILTER TO !Transf

** RELACIONES **
SELE DTRA
SET RELA TO CODMAT INTO CATG


SELE CTRA
SET RELA TO SubAlm+TipMov+CodMOv+NroDoc INTO DTRA

=F1QEH("OK")

** Pintamos pantalla de fondo **
cTit = "ALMACEN:SALIDAS"
cTitSi = PADR(MES(_Mes,1),10)+TRAN(_Ano,"9999")+[  ]+LEFT(SUBS(AlmNombr(GsSubalm),5),24)
=F1_BASE(cTitSi,cTit,GsNomCia,"Usuario:"+GsUsuario)
**********************
** Rutina Principal **
**********************
SELE CFTR
SEEK m.cTipMov
m.sCodMov = CodMov
m.sDesMov = DesMov
DO CapVarCfg
SELE CTRA

UltTecla = 0
_LLAVE   = []
lReclasif = .f.
m.Primera = .T.
m.Estoy   = [MOSTRANDO]
m.salir   = 1
m.CtrlObj = 1




_Llave = GsSubAlm+m.cTipMov+m.sCodMov
=SEEK(_LLave,"CTRA")

DO pVerTodo



**  Parametros para control de cambio de campo de la clave >>
sPicCa1 = "\<Motivo"
sMsgCa1 = "╗Desea modificar el motivo de la salida?"
sNomCa1 = "CODMOV"
**
DO F1_EDIT WITH [pllave],[pVerTodo],[pEditar],[pBorrar],[pEmision],;
              [SubAlm+TipMov+CodMov],_Llave,'CMAR',[],[N╖ D\<ocu.],sPicCa1,sMsgCa1,sNomCa1

**
CLOSE DATA
RETURN
************************************************************************** FIN
* Procedimiento Definir variables de configuraci╒n
******************************************************************************
PROCEDURE CapVarCfg

xAlias = ALIAS()
** Definiendo Variables a necesitar **
m.sDesMov = CFTR->DesMov
m.lPidRf1 = CFTR->PidRf1
m.GloRf1  = CFTR->GloRf1
m.lPidRf2 = CFTR->PidRf2
m.GloRf2  = CFTR->GloRf2
m.lPidRf3 = CFTR->PidRf3
m.GloRf3  = CFTR->GloRf3

m.lPidVen = CFTR->PidVen
m.lPidCli = CFTR->PidCli
m.lPidPro = CFTR->PidPro
m.lPidOdT = CFTR->PidOdT
m.lModPre = CFTR->ModPre
m.lUndStk = CFTR->UndStk .OR. EOF([CFTR])
m.lUndVta = CFTR->UndVta
m.lUndCmp = CFTR->UndCmp
IF ! m.lUndVta .and. ! m.lUndCmp
   m.lUndStk = .t.
ENDIF

m.lModCsm = CFTR->ModCsm
m.lAfeTra = CFTR->AfeTra

m.lExtPco = CFTR->ExtPco
m.lPidPco = CFTR->PidPco
m.lMonNac = CFTR->MonNac
m.lMonUsa = CFTR->MonUsa
m.lMonElg = CFTR->MonElg
m.lStkNeg = CFTR->StkNeg
if ! m.lMonElg .and. ! m.lMonUsa
   m.lMonNac = .t.
   m.lMonElg = .f.
   m.lMonUsa = .f.
ENDIF
m.GloAux = SPACE(15)
m.GloAux = SPACE(15)
m.GloAux1= SPACE(15)  && Ivan 09/09/99
m.GloVen = SPACE(15)
IF m.lPidCli
   m.GloAux = PADR("CLIENTE   :",15)
   IF GsSubalm = [080]                   && Ivan 09/09/99
      m.GloAux1= PADR("AREA/ZONA :",15)  
   ENDIF
ENDIF
IF m.lPidPro
   m.GloAux = PADR("PROVEEDOR :",15)
ENDIF
IF m.lPidVen
   m.GloVen = PADR("VENDEDOR  :",15)
ENDIF

DO CASE
   CASE ! m.lPidPco
      cE1 = "                                                                             "
      cE2 = "ITM  CODIGO Y DESCRIPCI╒N DEL MATERIAL                     CANTIDAD  U.STOCK "
      *       123  XXXXXXXX  123456789-123456789-123456789-123456789 12345678901234   123
   CASE m.lPidPco
      cE1 = "                                          UND         PREC.UNIT.   IMPORTE    "
      cE2 = "ITM CODIGO Y DESCRIPCION               CANTIDAD  STK       S/.          S/.   "
      *      XXX XXXXXXXX 123456789-123456789-12 9999,999.999 123 9999,999.999 9999,999.999
          *           1         2         3         4         5         6         7         8
          **0123456789-123456789-123456789-123456789-123456789-123456789-123456789-1234567890
ENDCASE
DO CASE
   CASE m.lUndStk
        sTUnd = [U.STK]
   CASE m.lUndVta
        sTUnd = [U.VTA]
   CASE m.lUndCmp
        sTUnd = [U.CMP]
ENDCASE
IF m.lPidPco
   IF ! m.lMonUsa
      sTMon ="S/."
   ELSE
      sTMon ="US$"
   ENDIF
ENDIF
IF !m.lPidPco
   spdesm=[@S40]
   blPidPro=.F.
ELSE
   spdesm=[@S25]
   blPidPro=.F.
ENDIF
m.bDefBrow= .T.
=SEEK(GsSubAlm+m.cTipMov+m.sCodMov+CHR(255),"CTRA")
m.sNroDoc = CTRA.NroDoc
m.TpoRf1 = CFTR.TpoRf1
m.TpoRf2 = CFTR.TpoRf2
m.TpoRf3 = CFTR.TpoRf3
XsTpoRef = []
m.CmpRef = []
m.VarRef = []

IF !EMPTY(m.TpoRf1)
   XsTpoRef = m.TpoRf1
   m.CmpRef = [NroRf1]
   m.VarRef = [sNroRf1]
ENDIF
IF !EMPTY(m.TpoRf2)
   XsTpoRef = m.TpoRf2
   m.CmpRef = [NroRf2]
   m.VarRef = [sNroRf2]
ENDIF
IF !EMPTY(m.TpoRf3)
   XsTpoRef = m.TpoRf3
   m.CmpRef = [NroRf3]
   m.VarRef = [sNroRf3]
ENDIF

IF m.lModCsm .or. m.lAfeTra
   IF !USED([DFPRO])
      SELE 0
      USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
      IF !USED()
         sErr = [Tabla de formulas no puede ser abierta]
         DO F1msgErr WITH sErr
      ENDIF
   ENDIF
ELSE
   IF USED([DFPRO])
      SELE DFPRO
      USE
   ENDIF
ENDIF
IF ALIAS()<>xAlias
   SELE (xAlias)
ENDIF
RETURN
************************************************************************* FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE pLlave

* buscamos control de correlativos *
SELE CDOC
SEEK (GsSubAlm+m.cTipMov+m.sCodMov)
IF .NOT. FOUND()
   DO F1MSGERR WITH [Correlativo no existe]
   UltTecla = K_ESC
   RETURN
ENDIF
**m.sNroDoc = RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.sNroDoc))
m.sNroDoc = NROAST()
UltTecla = 0

=SEEK(GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc,"CTRA")

DO almpms1a.spr

SELECT CTRA
SEEK GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc

RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE IniVarBd

m.dFchDoc = GdFecha
m.sNroRf1 = SPACE(LEN(CTRA.NroRf1))
m.sNroRf2 = SPACE(LEN(CTRA.NroRf2))
m.sNroRf3 = SPACE(LEN(CTRA.NroRf3))
m.sNroOdt = SPACE(LEN(CTRA.NroOdt))
m.sCodVen = SPACE(LEN(CTRA.CodVen))
m.sCodPro = SPACE(LEN(CTRA.CodPro))
m.sCodCli = SPACE(LEN(CTRA.CodCli)) && Ivan 23/08/99
IF TYPE([CTRA.CodZon])=[C]
	m.sCodZon = SPACE(LEN(CTRA.CodZon)) && Ivan 10/09/99   
ENDIF
m.sCodPrd = SPACE(LEN(CTRA.CodPrd))
m.FBatch  = 1
m.nCodMon = 1
IF m.lMonUsa
   m.nCodMon = 2
ENDIF
m.fTpoCmb = 1.00
m.sObserv = SPACE(LEN(CTRA.Observ))
IF m.lPidCli
   m.sCodAux = SPACE(LEN(m.sCodCli))
   IF GsSubalm = [080]                && Ivan 10/09/99
     m.sCodAux1= SPACE(LEN(m.sCodZon))  
   ENDIF
ENDIF

IF m.lPidPro
   m.sCodAux = SPACE(LEn(m.sCodPro))
ENDIF

m.fImpBrt = 0.00
m.fImpTot = 0.00
m.fImpIgv = 0.00
m.fPorIgv = 0.00

** datos del transportista **
m.NomTra = SPACE(LEN(CTRA.NomTra))
m.DirTra = SPACE(LEN(CTRA.DirTra))
m.RucTra = SPACE(LEN(CTRA.RucTra))
m.PlaTra = SPACE(LEN(CTRA.PlaTra))
m.Brevet = SPACE(LEN(CTRA.Brevet))
m.Motivo = 4






GnTotDel = 0
STORE 0 TO aRegDel

SELE TEMP
ZAP
SELE CTRA
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE pVerTodo
m.sNroDoc = CTRA.NroDoc
DO CapVarBd
DO almpms1a.spr
DO pRefresco
RETURN
************************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
************************************************************************ FIN *
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE CapVarBd

SELE CTRA
m.sNroDoc = CTRA->NroDoc
m.dFchDoc = CTRA->FchDoc
m.sNroRf1 = CTRA->NroRf1
m.sNroRf2 = CTRA->NroRf2
m.sNroRf3 = CTRA->NroRf3
m.sNroOdt = CTRA->NroOdt
m.sCodVen = CTRA->CodVen
m.sCodPro = CTRA->CodPro
m.sCodCli = CTRA->CodCli  && Ivan 23/08/99
IF TYPE([CTRA.CodZon])=[C]
	m.sCodZon = CTRA->CodZon  && Ivan 10/09/99
ENDIF
m.nCodMon = CTRA->CodMon
m.fTpoCmb = CTRA->TpoCmb
m.sObserv = CTRA->Observ
m.fImpBrt = CTRA->ImpBrt
m.fImpTot = CTRA->ImpTot
m.fImpIgv = CTRA->ImpIgv
m.fPorIgv = CTRA->PorIgv
m.sCodPrd = CTRA->CodPrd
m.FBatch = CTRA.FBatch
m.NomTra = CTRA.NomTra
m.DirTra = CTRA.DirTra
m.RucTra = CTRA.RucTra
m.PlaTra = CTRA.PlaTra
m.Brevet = CTRA.Brevet
m.Motivo = CTRA.Motivo

IF m.lPidCli
   m.sCodAux = m.sCodCli
   IF GsSubAlm = [080]   && Ivan 10/09/99
      m.sCodAux1 = m.sCodZon  
   ENDIF
ENDIF

IF m.lPidPro
   m.sCodAux = m.sCodPro
ENDIF
IF m.Estoy = [EDITANDO]
   SELE TEMP
   ZAP
   SELE DTRA
   SEEK GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
   SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
        m.NroReg = RECNO()
        SCATTER MEMVAR
        SELE TEMP
        APPEND BLANK
        GATHER MEMVAR
        REPLACE NROITM WITH RECNO()
        REPLACE DESMAT WITH CATG.DESMAT
        REPLACE NroReg WITH m.NroReg
        SELE DTRA
   ENDSCAN
ENDIF

GnTotDel = 0
STORE 0 TO aRegDel

SELE CTRA
RETURN
************************************************************************** FIN
* Procedimiento de edita las variables de cabezera
******************************************************************************
PROCEDURE pEditar
SELE CTRA
IF CieDelMes(_MES)
   UltTecla = K_ESC
   RETURN
ENDIF
Crear = .T.
IF (&sEsRgv.)
   IF CieAHoyDia(CTRA.FchDoc)
      UltTecla = K_ESC
      RETURN
   ENDIF
   IF .NOT. F1_RLock(5)
      UltTecla = K_ESC
      RETURN              && No pudo bloquear registro
   ENDIF
   IF CTRA.FlgEst = [A]
      sErr = [Acceso denegado]
      DO F1MSGERR WITH sErr
      UNLOCK
      UltTecla = K_ESC
      RETURN
   ENDIF
   IF !_ChkNro()
      DO F1MSGERR WITH sErr
      UNLOCK
      UltTecla = K_ESC
      RETURN
   ENDIF
   Crear = .F.
   DO CapVarBd
ELSE
   DO IniVarBd
ENDIF
DO almpms1a.spr
IF UltTecla # K_ESC
   DO pGrabar
ELSE
   IF WEXIST(m.bDeta)
      DEACTIVATE WINDOW (m.bDeta)
   ENDIF
   IF WEXIST(m.bTitulo)
      DEACTIVATE WINDOW (m.bTitulo)
      SELE DTRA
      SEEK GsSubAlm+m.sCodMov+m.cTipMov+m.sNroDoc
      SHOW WINDOW (m.bTitulo) REFRESH TOP
   ENDIF
ENDIF
SELECT CTRA
UNLOCK ALL
RETURN
************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE pBorrar

SELE CTRA
IF CieDelMes(_MES)
   UltTecla = K_ESC
   RETURN
ENDIF
IF CieAHoyDia(CTRA.FchDoc)
   UltTecla = K_ESC
   RETURN
ENDIF
IF .NOT. F1_rLock(5)
   UltTecla = k_Esc
   RETURN              && No pudo bloquear registro
ENDIF

=F1QEH("BORR_REG")

IF FlgEst = [A]
   DELETE
   UNLOCK
   RETURN
ENDIF

m.sNroDoc = CTRA->NroDoc
**
SELECT DTRA
SEEK (GsSubALm + m.cTipMov + m.sCodMov + m.sNroDoc )
OK     = .T.
DO WHILE ! EOF() .AND.  OK .AND. ;
   (GsSubALm+m.cTipMov+m.sCodMov+m.sNroDoc) = (SubALm+TipMov+CodMov+NroDoc)
   IF F1_Rlock(5)
      SELE CATG
      SEEK DTRA->CodMat
      SELE CALM
      SEEK GsSubAlm + DTRA->CodMat
      SELECT DTRA
      DELETE
      DO ALMpcsm2 WITH .T.
      UNLOCK
   ELSE
      OK = .F.
   ENDIF
   SKIP
ENDDO
** Actualizamos Cabecera de la ordenes **
SELECT CTRA
IF Ok
   REPLACE CODCLI WITH ""
   REPLACE CODPRO WITH ""
   REPLACE OBSERV WITH ""
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
=F1QEH("OK")
SELE CTRA
SEEK (GsSubALm + m.cTipMov + m.sCodMov + m.sNroDoc )
DO pEmision
SELE CTRA
UNLOCK ALL

RETURN
************************************************************************** FIN
* Procedimiento de Grabaci╒n de informaci╒n
******************************************************************************
PROCEDURE pGrabar
=F1QEH("GRAB_DBFS")
IF m.lPidCli
   m.sCodCli = m.sCodAux
   IF GsSubAlm = [080]   && Ivan 10/09/99
     m.sCodZon = m.sCodAux1  
   ENDIF  
ENDIF
IF m.lPidPro
   m.sCodPro = m.sCodAux
ENDIF





UltTecla = 0
IF Crear                  && Creando
   =F1QEH("GRAB_CABE")
   SELE CDOC
   IF .NOT. F1_RLock(5)
      UltTecla = K_ESC
      RETURN              && No pudo bloquear registro
   ENDIF
   SELECT CTRA
   SEEK (GsSubALm + m.cTipMov + m.sCodMov + m.sNroDoc )
   IF FOUND()
      m.sNroDoc = RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(CDOC->NroDoc)), LEN(m.sNroDoc))
      SEEK (GsSubALm + m.cTipMov + m.sCodMov + m.sNroDoc )
      IF FOUND()
         DO f1msgERR WITH [Registro creado por otro usuario]
         UltTecla = K_ESC
         RETURN
      ENDIF
   ENDIF
   APPEND BLANK
   IF .NOT. F1_RLock(5)
      UltTecla = K_ESC
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE CTRA->CodAlm WITH GsCodAlm
   REPLACE CTRA->SubAlm WITH GsSubAlm
   REPLACE CTRA->TipMov WITH m.cTipMov
   REPLACE CTRA->CodMov WITH m.sCodMov
   REPLACE CTRA->NroDoc WITH m.sNroDoc
   SELECT CDOC
  *IF m.sNroDoc >= RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.sNroDoc))
  *   REPLACE CDOC->NroDoc WITH CDOC->NroDoc + 1
  *ENDIF
  *UNLOCK
   =NROAST(m.sNroDoc)
   SELECT CTRA
ELSE
   =F1QEH("GRAB_CABE")
  *** Rectifica cambios hechos en la cabezera, cambien en el cuerpo del **
  *** documento.                                                        **
   IF CTRA->FchDoc != m.dFchDoc .OR. ;
      CTRA->CodPro != m.sCodPro .OR. ;
      CTRA->CodVen != m.sCodVen .OR. ;
      CTRA->CodCli != m.sCodCli .OR. ;  
      CTRA->NroOdt != m.sNroOdt .OR. ;
      CTRA->CodMon != m.nCodMon .OR. ;
      CTRA->TpoCmb != m.fTpoCmb .OR. ;
      CTRA->CodPrd != m.sCodPrd .OR. ;
      CTRA->FBatch != m.fBatch  .OR. ;
      _ChkRef()

      SELE DTRA
      LsLLave  = GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
      SEEK LsLLave
      DO WHILE LsLLave = (SubAlm+TipMov+CodMov+NroDoc) .AND. ! EOF()
         IF F1_RLOCK(5)
            RegAct = RECNO()
            lAcPre = ( m.dFchDoc <> FchDoc ) .OR. ( m.nCodMon <> CodMon ) ;
             .OR. ( m.fTpoCmb <> TpoCmb )
            lCmFch = m.dFchDoc  > FchDoc  && Barrer desde el principio
            REPLACE FchDoc WITH m.dFchDoc    && OJO ALTERA EL PROMEDIO
            REPLACE CodPro WITH m.sCodPro
        ****REPLACE CodVen WITH m.sCodVen
        ****REPLACE CodCli WITH m.sCodCli
            REPLACE CodMon WITH m.nCodMon    && OJO ALTERA EL PROMEDIO
            REPLACE TpoCmb WITH m.fTpoCmb    && OJO ALTERA EL PROMEDIO
            IF !EMPTY(XsTpoRef)
               REPLACE TpoRef WITH XsTpoRef
               REPLACE NroRef WITH IIF(!EMPTY(m.VarRef),m.&VarRef.,[])
            ENDIF
            *
            lAcCsmo=m.lModCsm AND (CTRA.FBatch<>m.FBatch OR CodPrd<>m.sCodPrd ;
                    OR lAcPre)
            IF lAcCsmo
               REPLACE TpoRef WITH [O_T]
               REPLACE CodPrd WITH m.sCodPrd
               REPLACE NroRef WITH m.sNroOdt
               REPLACE FBatch WITH m.FBatch
               DO ALMPACOM WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
            ENDIF
            *
            lActTra=m.lAfeTra AND (CTRA.FBatch<>m.FBatch OR CodPrd<>m.sCodPrd ;
                    OR lAcPre)
            IF lActTra
               REPLACE CodPrd WITH m.sCodPrd
               REPLACE FBatch WITH m.FBatch
               DO ALMPATRA WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
            ENDIF
            *
            IF lAcPre
               **** Actualizamos a los acumulados mensuales ****
               IF lCmFch
                  * Para Regenerar el precio promedio desde el principio *
                  xCodmm = CodMat
                  SET ORDER TO DTRA03
                  SEEK xCodmm
               ENDIF
               DO Almpcpp1            &&& Calculamos precio promedio
               SET ORDER TO DTRA01
               GOTO RegAct
            ENDIF
            IF lAcCsmo
               DO ALMPACOM WITH CodMat,CodPrd,FchDoc,TipMov,Candes
            ENDIF
            *
            IF lActTra
               DO ALMPATRA WITH CodMat,CodPrd,FchDoc,TipMov,Candes
            ENDIF
            *
         ENDIF
         SKIP
      ENDDO
   ENDIF
   SELECT CTRA
ENDIF
REPLACE CTRA->FchDoc  WITH m.dFchDoc
REPLACE CTRA->NroRf1  WITH m.sNroRf1
REPLACE CTRA->NroRf2  WITH m.sNroRf2
REPLACE CTRA->NroRf3  WITH m.sNroRf3
REPLACE CTRA->NroOdt  WITH m.sNroOdt
REPLACE CTRA->CodVen  WITH m.sCodVen
REPLACE CTRA->CodPro  WITH m.sCodPro
REPLACE CTRA->CodCli  WITH m.sCodCli
IF GsSubAlm = [080]  AND TYPE([CTRA.CodZon])=[C]
	REPLACE CTRA->CodZon  WITH m.sCodZon  && Ivan 10/09/99
ENDIF
REPLACE CTRA->CodMon  WITH m.nCodMon
REPLACE CTRA->TpoCmb  WITH m.fTpoCmb
REPLACE CTRA->Observ  WITH m.sObserv
REPLACE CTRA->CodPrd  WITH m.sCodPrd
REPLACE CTRA->FBatch  WITH m.FBatch
REPLACE CTRA->User    WITH GsUsuario
***
**Grabamos totales
REPLACE CTRA->ImpBrt  WITH m.fImpBrt
REPLACE CTRA->PorIgv  WITH m.fPorIgv
REPLACE CTRA->ImpIgv  WITH m.fImpIgv
REPLACE CTRA->ImpTot  WITH m.fImpTot
***
IF XsTpoRef = [G/R]
   REPLACE CTRA->NomTra  WITH m.NomTra
   REPLACE CTRA->DirTra  WITH m.DirTra
   REPLACE CTRA->RucTra  WITH m.RucTra
   REPLACE CTRA->PlaTra  WITH m.PlaTra
   REPLACE CTRA->Motivo  WITH m.Motivo
ENDIF


=F1QEH("GRAB_DETA")
DO bGrbDeta            && Grabamos detalle
=F1QEH("OK")
SELE CTRA
=F1QEH("IMPRIMIR")
DO pEmision
IF WVISIBLE(m.bDeta)
   DEACTIVATE WINDOW (m.bDeta)
   SELE TEMP
   GO TOP
   SHOW WINDOW (m.bDeta)   bottom refresh
ENDIF
M.ESTOY = [MOSTRANDO]
SELE CTRA
SEEK  GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
=BDEF_bRW()
IF WVISIBLE(m.bTitulo)
   DEACTIVATE WINDOW (m.bTitulo)
   SELE DTRA
   SEEK  GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
   SHOW WINDOW (m.bTitulo) TOP refresh
ENDIF
SELE CTRA
RETURN


*** FUNCIONES DE VALIDACION PARA LOS CAMPOS DEL BROWSE ***
****************
FUNCTION vCodMat   && CodMat VALID
****************
SCATTER MEMVAR
lValido = F1_BUSCA(m.CodMat,"CODMAT","CATG","CATG",GsSubAlm,.f.,"")
lAsig=SEEK(GsSubAlm+m.CodMat,"CALM")
IF !lValido
   GsMsgErr = [Codigo de material inv═lido]
ENDIF
IF !lAsig
   GsMsgErr = [Material no asignado a este almacen]
   lValido  = .F.
ENDIF
IF lValido
   GATHER MEMVAR FIELDS CodMat
   =SEEK(m.CodMat,[CATG])
   DO CASE
      CASE m.lUndStk
         m.UndCmp = CATG->UndStk
         m.Factor = 1
      CASE m.lUndVta
         m.UndCmp = CALM->UndVta
         m.Factor = CALM->FacEqu
      CASE m.lUndCmp
         m.UndCmp = CATG->UndCmp
         m.Factor = CATG->FacEqu
   ENDCASE
   IF m.Factor <= 0
      m.Factor = 1
   ENDIF
   m.UndVta = m.UndCmp
   GATHER MEMVAR FIELDS CodMat,UndVta,Factor
ENDIF
RETURN lValido
****************
FUNCTION vCandes    && Candes VALID
****************
m.fCanEqu = CanDes*Factor
**** Verificamos si existe stock ****
IF ! m.lStkNeg .AND. CALM->StkAct < fCanEqu
   GsMsgErr = "** No Existe Stock ***"
   RETURN .F.
ENDIF
RETURN .T.
****************
FUNCTION vPreUni    && PreUni VALID
****************
GsMsgErr = "Registre el Precio"
RETURN PreUni > 0
****************
FUNCTION wImpCto    && ImpCto WHEN
****************
SCATTER MEMVAR
IF m.CanDes = 0
   m.ImpCto = m.PreUni
ELSE
   m.ImpCto = ROUND(m.CanDes * m.PreUni, 2)
ENDIF
GATHER MEMVAR FIELD ImpCto
RETURN .T.
****************
FUNCTION vImpCto   && ImpCto VALID
****************
SCATTER MEMVAR
IF m.CanDes > 0
   m.PreUni = ROUND(m.ImpCto/m.CanDes,4)
ELSE
   m.PreUni = m.ImpCto
ENDIF
lValido = .T.
IF m.ImpCto <= 0
   GsMsgErr = "Registre el Precio"
   lValido = .F.
ENDIF
IF lValido
   GATHER MEMVAR FIELD ImpCto,PreUni
ENDIF
RETURN lValido

*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                                                                            Ё
*Ё bGrbDeta    Procemiento que graba registros de detalle del archivo temporalЁ
*Ё             al almrmovm , actualiza stock en almmmate y almmmatg , y veri- Ё
*Ё             fica el calculo del precio promedio                            Ё
*юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
******************
PROCEDURE bGrbDeta
******************
*
PRIVATE OK
*
SELE CTRA
SET RELA TO
SELE DTRA
SET RELA TO
*
IF GnTotDel >0
   FOR k = 1 TO GnTotDel
       ** Borramos en el almacen emisor **
       IF aRegDel(k)>0
          SELE DTRA
          GO aRegDel(k)
          DO WHILE !RLOCK()
          ENDDO
          DELETE
          DO ALMpcsm2 WITH .T.
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
OK     = .T.

**
IF OK
   SELE TEMP
   PACK
   GO TOP
   SCAN
        m.Nro_Itm = RECNO()
        SCATTER MEMVAR
        IF NroReg>0
           ** Desactualizar **
           m.Nro_Reg = NroReg
           SELE DTRA
           GO m.Nro_Reg
           DO WHILE !RLOCK()
           ENDDO
          *IF m.CodMat=DTRA.CodMat
          *   DO ALMpcsm2 WITH .F.
          *ELSE
              DO ALMpcsm2 WITH .T.
          *ENDIF
           UNLOCK
        ELSE
           SELE DTRA
           APPEND BLANK
           m.Nro_Reg = RECNO()
        ENDIF
        IF m.Nro_Reg<>RECNO() AND m.Nro_Reg>0
           GO m.Nro_Reg       && Ser═ posible  ??
        ENDIF
        GATHER MEMVAR
        REPLACE CodAlm WITH GsCodAlm
        REPLACE SubAlm WITH GsSubAlm
        REPLACE TipMov WITH m.cTipMov
        REPLACE CodMov WITH m.sCodMov
        REPLACE NroDoc WITH m.sNroDoc
        REPLACE FchDoc WITH m.dFchDoc
        REPLACE NroItm WITH m.Nro_Itm
        REPLACE CodMon WITH m.nCodMon
        REPLACE TpoCmb WITH m.fTpoCmb
        REPLACE CodPro WITH m.sCodPro
    ****REPLACE CodVen WITH m.sCodVen
        REPLACE CodCli WITH m.sCodCli  && Ivan 23/08/99
        IF GsSubAlm = [080]    
	        IF TYPE([CTRA.CodZon])=[C]
		        REPLACE CodZon WITH m.sCodZon  && Ivan 10/09/99
			ENDIF
	        IF TYPE([CTRA.FchVen])=[D]
		        REPLACE FechVen WITH m.FechVen && Ivan 23/08/99
			ENDIF		        
        ENDIF
        REPLACE User   WITH GsUsuario
        IF blPidPro
           REPLACE CodPro WITH m.CodPro
        ENDIF
        IF m.lModCsm
           IF USED([DFPRO])
              =SEEK(CodPrd+SubAlm+CodMat,[DFPRO])
              REPLACE CnFmla WITH DFPRO.CanReq*m.Fbatch
           ENDIF
           REPLACE CodPrd WITH m.sCodPrd
           REPLACE TpoRef WITH [O_T]
           REPLACE NroRef WITH m.sNroOdt
           REPLACE FBatch WITH m.FBatch
        ENDIF
        *
        IF m.lAfeTra
           IF USED([DFPRO])
              if SEEK(CodPrd+SubAlm+CodMat,[DFPRO])
                 REPLACE CnFmla WITH DFPRO.CanReq*m.Fbatch
              endif
           ENDIF
           REPLACE CodPrd WITH m.sCodPrd
           REPLACE FBatch WITH m.FBatch
        ENDIF
        *
        IF !EMPTY(XsTpoRef)
           REPLACE TpoRef WITH XsTpoRef
           REPLACE NroRef WITH IIF(!EMPTY(m.VarRef),m.&VarRef,[])
        ENDIF
        *
        REPLACE CTRA.NroItm WITH CTRA.NroItm + 1
        *
        REPLACE DTRA->CodAjt WITH " "
        * * * * * * * * * * * * * *
        DO Almpdsm1
        UNLOCK
        SELE TEMP
   ENDSCAN
ENDIF
SELE DTRA
SET RELA TO CODMAT INTO CATG
SELE CTRA
SET RELA TO SubAlm+TipMov+CodMOv+NroDoc INTO DTRA
RETURN
************************************************************************ FIN *
* Objeto : Emisi╒n del documento
******************************************************************************
PROCEDURE pEmision
*** Configuraci╒n de las Impresiones ***

IF F1_ALERT([FORMATO PRE-IMPRESO],2)=1
   DO PRE_IMPRESO
   RETURN
ENDIF
DO F0Print
UltTecla = LastKey()
IF UltTecla = K_ESC
   =F1QEH("Impresi╒n cancelada")
   RETURN
ENDIF
SET DEVICE TO PRINTER
DO IMPRIME
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN

*****************
PROCEDURE IMPRIME
*****************
=F1QEH("IMPRIMIR")
private largo
IniImp   = _Prn8a+_Prn2
NroCps   = 1   && (Original , copia1 , copia2)
NumPag   = 0
Largo    = 33
IF m.lPidPco
   Ancho    = 117
ELSE
   Ancho    = 90
ENDIF
VInicio  = .F.
SET MARGIN TO 0
LsLlave = CTRA->SubAlm+CTRA->TipMov+CTRA->CODMOV+CTRA->NRODOC
PRINTJOB
   DO WHILE NroCps>0
      NumPag   = 0
      xTotal   = 0
      DO pMembrete
      SELECT DTRA
      SET ORDER TO DTRA01
      SEEK LsLlave
      IF CTRA->FlgESt <> "A"
         DO WHILE  ! EOF() .AND. SUBALM+TIPMOV+CODMOV+NRODOC = LsLlave
            IF Prow() > (Largo - 4)
               DO pMembrete
            ENDIF
            SELECT DTRA
            NumLin = Prow() + 1
            xTotal = xTotal + ImpCto
            SELE CALM
            SEEK DTRA->SubAlm+DTRA->CodMat
            SELE CATG
            SEEK DTRA->CodMat
            SELE DTRA
            LsUndStk  = UndVta
            @ NumLin,0   SAY NroItm           PICT "###"
           *IF  EMPTY(DesMat)
                @ NumLin,5   SAY CODMAT+' '+LEFT(CATG->DesMat,67)
           *ELSE
           *    @ NumLin,5   SAY CODMAT+' '+LEFT(CATG->DesMat,67)
           *ENDIF
            IF !m.lPidPco
               IF DTRA->CanDes # 0
                  @ NumLin,74  SAY CanDes           PICT "@Z #######.####"
                  @ NumLin,87  SAY LsUndStk
               ENDIF
            ELSE
               IF DTRA->CanDes # 0
                  @ NumLin,74  SAY CanDes           PICT "@Z #######.##"
                  @ NumLin,87  SAY LsUndStk
                  @ NumLin,92  SAY PreUni PICT "#####,###.##"
               ELSE
                  @ NumLin,90  SAY "Revalorizaci╒n"
               ENDIF
               @ NumLin,105 SAY ImpCto PICT "#####,###.##"
            ENDIF
            SKIP
         ENDDO
         IF m.lPidPco
            NumLin = Prow() + 1
            @ NumLin,105 SAY "============"
            NumLin = Prow() + 1
            @ NumLin,89  SAY "SUB_TOTAL "
            @ NumLin,105 SAY xTotal   PICT "#####,###.##"
            NumLin = Prow() + 1
            @ NumLin,89  SAY "IMP. I.G.V "
            @ NumLin,105 SAY CTRA->ImpIgv PICT "#####,###.##"
            NumLin = Prow() + 1
            @ NumLin,89  SAY "TOTAL      "
            @ NumLin,100 SAY IIF(CTRA->CodMon#2, "S/.", "US$")
            @ NumLin,105 SAY CTRA->ImpTot PICT "#####,###.##"
         ENDIF
      ELSE
         @ PROW()+1,11 SAY "     #    #     # #     # #          #    ######  #######  "
         @ PROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
         @ PROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
         @ PROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
         @ PROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
         @ PROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
         @ PROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
      ENDIF
      IF Prow() > (Largo - 6)
         DO pMembrete
      ENDIF
      DO pPie
      NroCps = NroCps - 1
      EJECT PAGE
   ENDDO
ENDPRINTJOB
SELECT CTRA
RETURN
************************************************************************ FIN *
* Objeto : Membrete del documento
******************************************************************************
PROCEDURE pMembrete
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ELSE
   @ Largo-1,Ancho-10 SAY "../Continua"
ENDIF
@ 0,0  SAY IniImp
@ 1,52 SAY "No. DOCUMENTO   :"+_Prn7a+CTRA->NroDoc+_Prn7b
@ 1,1  SAY _Prn6a+GsNomCia+_Prn6b
*@ 2,1  SAY " ALMACEN   :  "+GsCodAlm+" "+GsNomAlm
@ 2,52 SAY "FECHA           :"+DTOC(CTRA->FchDoc)
@ 3,1  SAY " ALMACEN   :"+ALMNOMBR(CTRA.SubAlm)
IF m.lPidRf1
   @ 3, 52 SAY m.GloRf1 +CTRA->NroRf1
ENDIF
@ 4,1 SAY "S A L I D A S    DE     A L M A C E N"
IF m.lPidRf2
   @ 4, 52 SAY m.GloRf2 + CTRA->NroRf2
ENDIF
@ 5,1 SAY " MOVIMIENTO: "+CTRA.CodMov+"  "+m.sDesmov
IF m.lPidOdt
   @ 5, 52 SAY "# DE BATCH :"+CTRA->NroOdt
   =SEEK(CodPrd,[CATG])
   @ 6, 01 SAY " PRODUCTO      :"+CTRA.CodPrd+[ ]+LEFT(CATG.DesMat,40)+[ Factor:]+TRAN(CTRA.FBATCH,"999.9999")
ENDIF
LinAct = PROW()+1
IF m.lPidRf3
   @ LinAct,1 SAY m.GloRf3+CTRA.NroRf3
   LinAct=LinAct + 1
ENDIF
IF m.lPidPro
   SELECT AUXI
   SEEK GsClfPro+CTRA->CodPro
   @ LinAct , 1  SAY " PROVEEDOR     :" + CTRA->CodPro + " " + AUXI->NomAux
   LinAct = LinAct + 1
ENDIF
IF m.lPidCli 
   SELECT AUXI
   SEEK GsClfCli+CTRA->CodCli
   @ LinAct , 1  SAY " CLIENTE       :"+ CTRA->CodCli + " " + AUXI->NomAux
   LinAct = LinAct + 1
   IF GsSubalm = [080]	 && Ivan 13/09/99
   	 =SEEK([09 ]+m.sCodZon,[AUXI])
   	 @ LinAct , 1  SAY " AREA/ZONA     :"+ CTRA->CodZon + " " + AUXI->NomAux
   	 LinAct = LinAct + 1
   ENDIF
ENDIF
IF m.lPidPco .AND. CTRA->FLGEST <> "A"
   @ LinAct , 1  SAY " MONEDA        :"+IIF(CTRA->CodMon#2, "NUEVOS SOLES    ", "DOLAR AMERICANO ")
   LinAct = LinAct + 1
ENDIF
@ LinAct  , 1    SAY " OBSERVACIONES :" + CTRA->Observ
IF m.lPidPco
   @ LinAct+1, 0   SAY _PRN3
   @ LinAct+1, 0   SAY REPLICATE("_",117)
   @ LinAct+2, 0   SAY "      CODIGO                                                                                       PRECIO        VALOR   "
   @ LinAct+3, 0   SAY "ITM   MATERIAL             DESCRIPCION                                      CANTIDAD    UND      UNITARIO        COSTO   "
   *                    ### ##########1234567890 123456789-123456789-123456789 ########## 123  #####,###.## #####,###.##
   @ LinAct+4, 0   SAY REPLICATE("_",117)
ELSE
   @ LinAct+1, 0   SAY _PRN2
   @ LinAct+1, 0   SAY REPLICATE("_",90)
   @ LinAct+2, 0   SAY "      CODIGO                                                                               "
   @ LinAct+3, 0   SAY "ITM   MATERIAL             DESCRIPCION                                      CANTIDAD    UND"
   @ LinAct+4, 0   SAY REPLICATE("_",90)
ENDIF

*LfImpIgv=CTRA->ImpIgv
*LfImpTot=CTRA->ImpTot

NumPag = NumPag + 1
RETURN
**********************************************************************
PROCEDURE pPie
*****************
NumLin = Largo - 5
Pn1 = "*************** *************** *************** **********************************************"
Pn2 = "   PREPARADO        REVISADO         Vo Bo       OBSERVACIONES _______________________________"
Pn3 = "                                                                                              "
Pn4 = "                                                ______________________________________________"
Pn5 = "*************** *************** *************** **********************************************"
DO CASE
   CASE NroCps = 3
      Pn6 = _Prn7a+"O R I G I N A L"+_Prn7b
   CASE NroCps = 2
      Pn6 = _Prn7a+"C O P I A   1"+_Prn7b
   CASE NroCps = 1
      Pn6 = _Prn7a+"C O P I A   2"+_Prn7b
ENDCASE
@ NumLin+1,0    SAY _Prn8a+_Prn2
@ NumLin+1,0    SAY Pn1
@ NumLin+2,0    SAY Pn2
@ NumLin+3,0    SAY Pn3
*@ NumLin+4,0    SAY Pn4
@ NumLin+4,0    SAY Pn5
@ NumLin+5,0    SAY IniImp
RETURN
*********************
PROCEDURE PRE_IMPRESO
*********************
**---------- Impresi╒n ---------**
LsLlave = CTRA->SubAlm+CTRA->TipMov+CTRA->CODMOV+CTRA->NRODOC
SELECT DTRA
SET ORDER TO DTRA01
SEEK LsLlave
xFOR   = []
xWHILE = [SubAlm+TipMov+CodMov+NroDoc=LsLlave]
DO CASE 
	CASE m.sede_act=[003]   && Vulcano
		Largo  = 66       && Largo de pagina
		IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
		IF XsTpoRef=[G/R]
		   sNomRep = "ALMIMS1A"
		ELSE
		   sNomRep = "ALMPMS1A"
		ENDIF
	CASE m.Sede_act=[002] AND GsCodCia=[005]  && Productos Terminados Ivan 23/08/99	
		Largo  = 66       && Largo de pagina
		IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
		IF XsTpoRef=[G/R]
		   sNomRep = "ALMigrpt"
		ELSE
		   sNomRep = "ALMPMS1A"
		ENDIF
	other	
		Largo  = 66       && Largo de pagina
		IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
		IF XsTpoRef=[G/R]
		   sNomRep = "ALMIMS1A"
		ELSE
		   sNomRep = "ALMPMS1A"
		ENDIF
ENDCASE
DO F0print WITH "REPORTS"
SELE CTRA
RETURN
************************************************************************* FIN
PROCEDURE SWAP_RELA
*******************
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
SELE DTRA
SET RELA TO
SELE (m.CurrArea)
SET RELA TO
RETURN
*******************
PROCEDURE pActivate
*******************
IF WVISIBLE(m.bDeta)
   DEACTIVATE WINDOW (m.bDeta)
ENDIF
DO CASE
   CASE m.Estoy=[EDITCLAVE]
       *SHOW GETS DISABLE
        SHOW GET m.sCodMov ENABLE
        SHOW GET m.Salir   ENABLE
   CASE m.Estoy = [EDITANDO] AND !m.Pll_btn
       *SHOW GETS ENABLE
        SHOW GET m.sNrodoc DISABLE
        SHOW GET m.sdesmov DISABLE
   CASE m.Estoy = [EDITANDO] AND m.Pll_btn
       *SHOW GETS ENABLE
        SHOW GET m.sNroDoc DISABLE
        SHOW GET m.sDesmov DISABLE
   CASE m.Estoy = [PIDLLAVE]
       *SHOW GETS DISABLE
        SHOW GET m.sNroDoc ENABLE
        SHOW GET m.Salir
   CASE m.Estoy = [MOSTRANDO]
       *SHOW GETS
        CLEAR READ
ENDCASE
IF m.Estoy = [EDITANDO]
   ON KEY LABEL F2 DO EditDeta
   ON KEY LABEL F7 DO pRclfMov
ENDIF
DO pRefresco
IF lReclasif
   CLEAR READ
   lReclasif = .F.
ENDIF
******************
PROCEDURE pRclfMov
******************
PRIVATE xAlias
DO F1_CAJA WITH 04, 45, "RECLASIF",7,[RECLASIFICACION DE MOTIVO]
ACTIVATE  WINDOW reclasif
TsCodMov = SPACE(LEN(CFTR.CodMov))
xAlias   = ALIAS()
m.Opcr   = 1
@ 00,01 SAY [Reclasificar a:] GET TsCodMov VALID vCodMov()
@ 02,01 GET m.Opcr PICTURE "@*HT \!\<Aceptar;\<Cancelar"  SIZE 1,10,0 DEFAULT 1
READ cycle
UltTecla = LASTKEY()
IF m.Opcr = 2
   UltTecla = K_ESC
ENDIF
IF UltTecla # K_ESC
   SELE CTRA
   TsNroDoc = m.sNroDoc
   m.Reg_Act = RECNO()
   zLlaveAnt = GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
   SEEK GsSubAlm+m.cTipMov+TsCodMov+m.sNroDoc
   IF FOUND()
      SELE CDOC
      SEEK (GsSubAlm+m.cTipMov+TsCodmov)
      IF .NOT. FOUND()
         DO f1msgerr WITH [Correlativo no existe.]
         UltTecla = K_ESC
         RELEASE WINDOW RECLASIF
         SELE (xAlias)
         RETURN
      ENDIF
      DO WHILE !RLOCK()
      ENDDO
      TsNroDoc = NROAST()
      SELE CTRA
      GO m.Reg_Act
      DO WHILE !RLOCK()
      ENDDO
      REPLACE CodMov WITH TsCodMov
      REPLACE NroDoc WITH TsNroDoc
      UNLOCK
      SELECT CDOC
      =NROAST(TsNroDoc)
      SELE CTRA
   ELSE
      SELE CTRA
      GO m.Reg_Act
      DO WHILE !RLOCK()
      ENDDO
      REPLACE CodMov WITH TsCodMov
      REPLACE NroDoc WITH TsNroDoc
      UNLOCK
   ENDIF
   SELE DTRA
   SEEK zLlaveAnt
   DO WHILE FOUND()
      DO WHILE !RLOCK()
      ENDDO
      REPLACE CodMov WITH TsCodMov
      REPLACE NroDoc WITH TsNroDoc
      UNLOCK
      SEEK zLlaveAnt
   ENDDO
ENDIF
RELEASE WINDOW RECLASIF
IF UltTecla#K_ESC
   SEEK zLLaveAnt
   IF !FOUND()
      =F1QEH([Creando])
   ENDIF
   do pVertodo
   lReclasif = .T.
ENDIF
SELE (xAlias)
RETURN
****************
FUNCTION vCodmov     &&  TsCodMov VALID
****************
lValido= f1_busca(Tscodmov,"CODMOV","CFTR","CFTR",m.cTipMov,.F.,"")
IF lValido
   LsDesmov = CFTR.DesMov
   @ 01,21 SAY LsDesMov SIZE 1,20
ENDIF
RETURN lValido
****************
FUNCTION _ChkRef
****************
IF EMPTY(XsTpoRef) OR  EMPTY(m.CmpRef) OR EMPTY(m.VarRef)
   RETURN .F.
ENDIF
RETURN CTRA.&CmpRef.!=m.&VarRef.
***************
FUNCTION vRefer
***************
return .t.
