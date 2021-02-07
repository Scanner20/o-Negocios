*****************************************************************************
* Programa     : vtar4700.prg
* Sistema      : Ventas
* Autor        : VETT
* Proposito    : Reporte de Ventas x Producto Anual
* Parametros   :
* Creacion     : 01/11/94
* Actualizaci¢n: RHC 30/11/94 Mejorar el reporte
*                RHC 19/12/94 Todo en TM
*****************************************************************************
CLEAR
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = ">> VENTAS ANUALES x PRODUCTO <<"
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  5,10 CLEAR TO 20,68
@  5,10 TO 20,68 DOUBLE
@  9,20 SAY "A¤o         :"
@ 11,20 SAY "Condici¢n   :"
CLOSE DATA
WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
DO SDOLista
CLOSE DATA
RETURN
*********************************************************************** EOP() *

PROCEDURE SDOLista
*******************
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
**
SELE 2
USE ccbrgdoc ORDER GDOC08 ALIAS GDOC
IF !USED()
   RETURN
ENDIF
**
SELE 3
USE VTAVGUIA order vgui01 ALIAS GUIA
IF !USED()
   RETURN
ENDIF
**
SELE 4
USE VTARITEM order ITEM01 ALIAS ITEM
IF !USED()
   RETURN
ENDIF
**
SELE 5
USE ALMRMOVM order RMOV06 ALIAS RMOV
IF !USED()
   RETURN
ENDIF
**
SELE 6
USE VTARPEDI order RPED01 ALIAS RPED
IF !USED()
   RETURN
ENDIF
**
SELE 7
USE ALMMMATG ORDER MATG01 ALIAS MATG
IF !USED()
   RETURN
ENDIF
**
** Archivo temporal **
Len1 = SPACE(LEN(MATG->CodMat))
Arch = PATHUSER+SYS(3)
SELE 0
CREATE TABLE &Arch. ( CodCli C(5), NomCli C(50) , NroGui C(9) , FchDoc D , ;
               CodMat C(8),CanDes N(14,2) , ;
               UndVta C(3)   , PreUni N(12,2), ImpLin N(12,2), NroFac C(9) , ;
               Tot01  N(14,2), Tot02  N(14,2), Tot03  N(14,2), Tot04  N(14,2),;
               Tot05  N(14,2), Tot06  N(14,2), Tot07  N(14,2), Tot08  N(14,2),;
               Tot09  N(14,2), Tot10  N(14,2), Tot11  N(14,2), Tot12  N(14,2),;
               Imp01  N(14,2), Imp02  N(14,2), Imp03  N(14,2), Imp04  N(14,2),;
               Imp05  N(14,2), Imp06  N(14,2), Imp07  N(14,2), Imp08  N(14,2),;
               Imp09  N(14,2), Imp10  N(14,2), Imp11  N(14,2), Imp12  N(14,2)  )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON CODMAT TO TEMP01
SET INDEX TO TEMP01
** variables a usar **
DIMENSION X(12)
STORE 0 TO X
XsAno  = LEFT(DTOS(DATE()),4)
XnMes1 = 1
XnMes2 = MONTH(DATE())
XiCondi = 1
** pantalla de datos **
i = 1
UltTecla = 0
DO lib_mtec WITH 8
DO WHILE UltTecla # Escape
   DO CASE
      CASE i = 1
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         @  9,35 GET XsAno PICT "9999"
         READ
         UltTecla = Lastkey()
      CASE i = 2
            @ 11,35 TO 15,49
            @ 12,36 PROMPT " Miles de S/."
            @ 13,36 PROMPT " Miles de US$"
            @ 14,36 PROMPT " TM.         "
            MENU TO XiCondi
            IF XiCondi = 0
               UltTecla = Escape
            ELSE
               UltTecla = Enter
            ENDIF
   ENDCASE
   IF i = 2 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
** Generamos Registro Final **
DO xGENERA
** test de impresion **
XFOR = []
XWHILE = []
** buscamos registro de arranque **
SELE TEMPO
SET RELA TO CodMat INTO MATG
GO TOP
XsTitulo = "VENTAS ANUALES POR PRODUCTO"
XsSubTit = "DEL: "+TRANS(XnMes1,"@L ##")+"  AL: "+TRANS(XnMes2,"@L ##")+" DE "+XsAno
DO CASE
   CASE XiCondi = 1
      XsMensa = PADC([Importes Expresados en Miles de Nuevos Soles],50)
   CASE XiCondi = 2
      XsMensa = [Importes Expresados en Miles de Dolares Americanos]
   OTHER
      XsMensa = PADC([Cantidades en Toneladas M‚tricas],50)
ENDCASE
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
sNomRep = "vtar4700"
KEYBOARD "P"+CHR(CtrlW)
DO admprint WITH "REPORTS"

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

SELE TEMPO
DELE ALL
* Buscamos Facturas y Boletas
SELE GDOC
SEEK XsAno+TRANS(XnMes1,"@L ##")
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
SCAN WHILE LEFT(DTOS(FchDoc),6)<=XsAno+TRANS(XnMes2,"@L ##") ;
     FOR INLIST(GDOC->CodDoc,"FAC","BOL") .AND. FlgEst # [A]
   WAIT "Verificando "+CodDoc+" "+NroDoc WINDOW NOWAIT
   * buscamos detalle de facturas/boletas
   SELE ITEM
   SEEK GDOC->CodDoc+GDOC->NroDoc
   SCAN WHILE ITEM->CodDoc+ITEM->NroDoc=GDOC->CodDoc+GDOC->NroDoc FOR INLIST(CodMat,"004","002")
      SELE TEMPO
      SEEK ITEM->CodMat
      IF !FOUND()
         APPEND BLANK
         REPLACE CodMat WITH ITEM->CodMat
         REPLACE UndVta WITH ITEM->UndVta
      ENDIF
      Campo1 = "Tot"+TRANS(MONTH(GDOC->FchDoc),"@L ##")
      Campo2 = "Imp"+TRANS(MONTH(GDOC->FchDoc),"@L ##")
      REPLACE &Campo1. WITH &Campo1. + ITEM->CanFac*ITEM->FacEqu/1000   && <OJO<
      nFactor = 1
      IF XiConDi = GDOC->CodMon
         nFactor = 1/1000
      ELSE
         IF XiCondi = 1
            nFactor = IIF(GDOC->TpoCmb<=0,1,GDOC->TpoCmb)/1000
         ELSE
            nFactor = IIF(GDOC->TpoCmb<=0,1,1/GDOC->TpoCmb)/1000
         ENDIF
      ENDIF
      REPLACE &Campo2. WITH &Campo2. + ITEM->ImpLin*nFactor
      TnMes  = MONTH(GDOC->FchDoc)
      IF XiCondi=3
         X(TnMes) = X(TnMes) + ITEM->ImpLin*nFactor
      ELSE
         X(TnMes) = X(TnMes) + ITEM->ImpLin*nFactor
      ENDIF
      *
      SELE ITEM
   ENDSCAN
   *
   SELE GDOC
ENDSCAN
* Redondeo antesde imprimir *
SELE TEMPO
REPLACE ALL Imp01 WITH ROUND(Imp01,0)
REPLACE ALL Imp02 WITH ROUND(Imp02,0)
REPLACE ALL Imp03 WITH ROUND(Imp03,0)
REPLACE ALL Imp04 WITH ROUND(Imp04,0)
REPLACE ALL Imp05 WITH ROUND(Imp05,0)
REPLACE ALL Imp06 WITH ROUND(Imp06,0)
REPLACE ALL Imp07 WITH ROUND(Imp07,0)
REPLACE ALL Imp08 WITH ROUND(Imp08,0)
REPLACE ALL Imp09 WITH ROUND(Imp09,0)
REPLACE ALL Imp10 WITH ROUND(Imp10,0)
REPLACE ALL Imp11 WITH ROUND(Imp11,0)
REPLACE ALL Imp12 WITH ROUND(Imp12,0)

WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *
* Devuelve imnporte o cantidad
*******************************************************************************
FUNCTION Sum_Tot
PARAMETER iCondi

DO CASE
   CASE iCondi = 3
      RETURN Tot01+Tot02+Tot03+Tot04+Tot05+Tot06+Tot07+Tot08+Tot09+Tot10+Tot11+Tot12
   OTHER
      RETURN Imp01+Imp02+Imp03+Imp04+Imp05+Imp06+Imp07+Imp08+Imp09+Imp10+Imp11+Imp12
ENDCASE
******************
FUNCTION Tot_Meses
******************
PARAMETER iCondi
TOT = 0
For Ii = 1 TO 12
    TOT = TOT + X(Ii)
ENDFOR
RETURN TOT
