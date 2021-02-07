*имммммммммммммммяммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╩
*╨ Nombre        Ё CBDPCAMB.prg                                                ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Sistema       Ё SISTEMA DE INFORMACION INTEGRAL                             ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Autor         Ё VETT                   Telf: 4841538                        ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Ciudad        Ё LIMA , PERU                                                 ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Direcci╒n     Ё Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Prop╒sito     Ё Tabla Tipo de Cambio Mensual                                ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Creaci╒n      Ё 18/12/95                                                    ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Actualizaci╒n Ё                                                             ╨
*╨               Ё                                                             ╨
*хмммммммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪

PROCEDURE CBDPCAMB
** Variables que dan problemas en otros sistemas mas piojos **
IF TYPE([K_ESC])=[U]
   PUBLIC k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,k_f_der,;
          k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,k_f4,k_f5,k_f6,k_f7,;
          k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,k_sf6,k_sf7,k_sf8,k_sf9,;
          k_ctrlw,k_lookup,k_borrar,k_esc


   STORE 0 TO k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,;
              k_f_der,k_f_der,k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,;
              k_f4,k_f5,k_f6,k_f7,k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,;
              k_sf6,k_sf7,k_sf8,k_sf9,k_ctrlw,k_lookup,k_borrar,k_esc

   do def_teclas in belcsoft
   
  *PUBLIC GsClfPro,GsBusca
  *GsClfPro = [01 ] &&& Clasificaci╒n de los proveedores
  *GsBusca  = [Cmpselec]
   sErr     = []
ENDIF
set library to belcsoft
IF TYPE([C_LINEA])=[U]
   STORE "" TO C_Fondo,C_Linea,C_Say,C_Get,C_Sayr
   do def_color  in belcsoft
ENDIF
SAVE SCREEN
sTit = [TABLA TIPO DE CAMBIO]
=F1_BASE(GsNomCia,[ADMINISTRADOR:]+sTit,"USUARIO:"+GsUsuario,"FECHA:"+DTOC(DATE()))

PRIVATE nX0,nY0,nX1,nY1,sModulo
PRIVATE m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
PRIVATE m.PrgPrep,m.PrgPost,m.PrgBusca,m.Area_sel
STORE [] TO m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
STORE [] TO m.PrgPrep,m.PrgPost,m.PrgBusca,m.Area_sel
PRIVATE xAliasACT
xAliasACT= ALIAS()
sModulo = [TPO_CMB]
lCierraTCMB = .F.
ArcTmp = PATHUSER+SYS(3)
IF !ABrirDbfs()
   **CLOSE DATA
   RETURN
ENDIF

* Variables del Browse *

UltTecla  = 0
m.Primera = .T.
m.Estoy   = [MOSTRANDO]
m.salir   = 1
SELE TCMB
GO TOP
DO BROWS_tcmb with .f.,[TCMB]
CLOSE DATA
IF lCierraTCMB
   USE
ENDIF
if !empty(xAliasAct)
    SELE (xAliasACT)
ENDIF
KEYBOARD '{DNARROW}' clear
RESTORE SCREEN
RETURN
*******************
PROCEDURE ABRIRDBFS
*******************
=F1QEH([ABRE_DBF])
**CLOSE DATA

IF !USED([TCMB])
   use cbdpcamb in 0 order tcmb01 alias tcmb
   IF !USED()
     **CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
=F1QEH([OK])
RETURN
********************
PROCEDURE Brows_Tcmb
********************
PARAMETER lMostrar,m.Area

m.bTitulo = [TPO_CMB]
m.bDeta   = [TPO_CMB]
m.bTitBrow= [Tipo de Cambio Mensual]
IF lmostrar
   m.bClave1 = []
   m.bClave2 = []
ELSE
   m.bClave1 = []
   m.bClave2 = []
ENDIF
m.bFiltro = [.T.]
m.bCampos = bDef_TCMB(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.PrgPrep = []
m.PrgPost = []
nX0 = 04
nY0 = 22
nX1 = 20
nY1 = 58

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .T.
   lBorr_Reg = .T.
ENDIF

DO f1browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
******************
FUNCTION bDef_TCMB
******************
PARAMETERS sModulo
IF PARAMETERS() = 0
   WAIT "Falta definir campos a examinar(Browse)" WINDOW NOWAIT
   RETURN TO MASTER
ENDIF
PRIVATE sCmp
DO CASE
 CASE INLIST(sModulo,[TPO_CMB])
      sCmp = [ano:H='A╓o ':P='9999':v=vano(),]
      sCmp = sCmp + [mes:H='Mes':P='99':v=vmes():F,]
      sCmp = sCmp + [ofivta:H='T/C Venta':P='99,999.9999':v=vventa():F,]
      sCmp = sCmp + [oficmp:H='T/C Compra':P='99,999.9999':v=vcompra():F]
 OTHER
    WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
    RETURN TO MASTER
ENDCASE
RETURN sCmp

Function vFchCmb
PRIVATE iRecno
IF DELETED()
   RETURN .T.
ENDIF
SCATTER MEMVAR
iRecno = RECNO()
Eof1 = EOF()
lValido = .t.
SEEK DTOS(m.FchCmb)
IF FOUND() AND !EMPTY(m.FchCmb)
   IF Recno()<>iRecno
      sErr = [Fecha ya registrada]
      lValido = .F.
   ENDIF
ENDIF
IF EOF1
   GO BOTTOM
ELSE
   GO iRecno
ENDIF
RETURN lValido
Function vOfIVTa
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN OfIVta>=0

Function vOfICmp
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN OfICmp>=0

Function vBcoCmp
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN BcoCmp>=0

Function vBcoVta
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN BcoVta>=0

Function vDolCan
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN DolCan>=0

Function vMarAle
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN MarAle>=0

Function vFraSui
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN FraSui>=0

Function vLibEst
sErr=[Tipo de cambio debe ser mayor o igual a cero]
RETURN LibEst>=0

********************
PROCEDURE bBorra_Reg
********************
IF !lBorra
   =F1QEH("No es posible borrar registro")
   RETURN
ENDIF
m.RegAct = RECNO()
DELE
SKIP +1
blBorrar = .T.
DEACTIVATE WINDOW (m.bDeta)
SHOW WINDOW (m.bDeta) REFRESH TOP

*********************
PROCEDURE bAgrega_Reg
*********************
PRIVATE EOF1
IF !lAdiciona
   =F1QEH("No es posible a╓adir registro")
   RETURN
ENDIF
EOF1 = EOF()
APPEND BLANK
DO CASE
   CASE INLIST(sModulo,[FORMPROD])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE CodPro WITH m.CodPro
        UNLOCK
   CASE INLIST(sModulo,[GEN_O/T])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE NroDoc WITH sNroO_T
        REPLACE TipPro WITH [P/T]
        UNLOCK
ENDCASE
IF EOF1
   GO TOP
   DEACTIVATE WINDOW (m.bDeta)
   SHOW WINDOW (m.bDeta) REFRESH TOP
ENDIF
RETURN

*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                                                                            Ё
*Ё vBrw      VALID      del browse a nivel de registro                        Ё
*Ё                                                                            Ё
*Ё                                                                            Ё
*юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

FUNCTION vBrw

DO CASE
   CASE INLIST(sModulo,[INGRESOS],[SALIDAS])
       IF TYPE("NroItm")="N"
          IF NroItm<>RECNO()
             REPLACE NroItm WITH RECNO()
          ENDIF
       ENDIF
   CASE INLIST(sModulo,[APERTURA])
      IF lGrb_Arch
         DO Brw_Grab
         lGrb_Arch = .F.
      ENDIF
      *@ 22,14 SAY CATG.DESMAT PICT "@S40"
ENDCASE

*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                                                                            Ё
*Ё wBrw      WHEN       del browse a nivel de registro                        Ё
*Ё                                                                            Ё
*Ё                                                                            Ё
*юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

FUNCTION wBrw

IF DELETED()
   RETURN .F.
ENDIF
DO CASE
   CASE INLIST(sModulo,[INGRESOS],[SALIDAS])
        IF TYPE("NroItm")="N"
           IF NroItm<>RECNO()
              REPLACE NroItm WITH RECNO()
           ENDIF
        ENDIF
   CASE INLIST(sModulo,[APERTURA])
       =SEEK(CODMAT,"CATG")
       @ 22,14 SAY CATG.DESMAT PICT "@S40"
       lGrb_Arch = .F.
ENDCASE
RETURN .T.

*************
function vano
*************
scatter memvar
if empty(m.ano) .or. val(m.ano)<year(date())-1
    return .f.
endif
return .t.

*************
function vmes
*************
priva irecno
if deleted()
   return .t.
endif
scatter memvar
irecno = recno()
eof1 = eof()
lvalido = .t.
if empty(m.mes) .or. val(m.mes)>13
    lvalido = .f.
endif
m.mes = tran(val(m.mes),[@l 99])
seek m.ano + m.mes
if found()
   if recno()<>irecno
      wait window [ERROR : Periodo ya Registrado ....]
      lvalido = .f.
   endif
endif
if eof1
   go bottom
else
   go irecno
endif
if lvalido
   do while !rlock([tcmb])
   enddo
   repla tcmb.mes with tran(val(m.mes),[@l 99])
   unlock
endif
return lvalido

***************
function vventa
***************
return ofivta>0

****************
function vcompra
****************
return oficmp>0

