CLEAR
SELECT 1
USE ccbntasg IN 1 ORDER TASG03 ALIAS TASG
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbmvtos IN 2 ORDER VTOS01 ALIAS VTOS
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbrgdoc IN 3 ORDER GDOC01 ALIAS GDOC
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbrrdoc IN 4 ORDER RDOC01 ALIAS RDOC
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
**
USE cbdmauxi IN 5 ORDER AUXI01 ALIAS AUXI
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF
*
USE ccbnrasg IN 7 ORDER RASG01 ALIAS RASG
IF !USED(7)
   CLOSE DATA
   RETURN
ENDIF
m.codref = [PROF]
m.CodDoc = [CANJ]
UltTecla = 0
DESDE = SPACE(LEN(VTOS.NroDoc))
HASTA = SPACE(LEN(VTOS.NroDoc))

@ 2,0 TO 20,79 PANEL
@ 2,25  SAY "PROFORMAS PENDIENTES DE GENERAR CANJES"
GsMsgKey = " [Enter] Aceptar [Esc] Salir "
DO LIB_MTEC WITH 99
XdFch1 = DATE()
XdFch2 = DATE()
XsTpoDoc = "CARGO"
XsCodDoc = "N/C "
XnAno    = YEAR(DATE())
XnMes    = MONTH(DATE())

@ 14,10 SAY "Fecha     Desde  :"    COLOR SCHEME 11
@ 15,10 SAY "Fecha     Hasta  :"    COLOR SCHEME 11
UltTecla = 0
i = 1
DO LIB_MTEC WITH 11
DO WHILE !INLIST(UltTecla,Escape,CtrlW)
   DO CASE
      CASE i = 1
           @ 14,28 GET XdFch1  PICT "@!" &&VALID MONTH(XdFch1)=XnMes AND YEAR(XdFch1)=XnAno
           @ 15,28 GET XdFch2  PICT "@!" &&VALID MONTH(XdFch2)=XnMes AND YEAR(XdFch2)=XnAno
           READ
           UltTecla = LASTKEY()
           IF UltTecla = Enter
              UltTecla = CtrlW
           ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>1 ,1 ,i)
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
*
SELE TASG
SEEK "PROFP"
IF !FOUND()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
WAIT "Procesando informacion..." NOWAIT WINDOW

** Archivo temporal **
ArcTmp = PathUser + SYS(3)
COPY STRU TO &ArcTmp
SELE 0
USE &ArcTmp ALIAS TEMPO EXCL
IF USED()
   INDEX ON Glosa2+NroDoc TAG TASG01
   SET ORDER TO TASG01
   *
   SELE TASG
   SCAN WHILE CODDOC+FlgEst="PROFP" FOR FchDoc<=XdFch2 AND FchDoc>=XdFch1
        vRegAct = RECNO()
        ZsNroDoc = []
        LsGloLet = []
        XsCodDoc = CodDoc
        XsNroDoc = NroDoc
        SCATTER MEMVAR
        SET ORDER TO TASG05
        SEEK XsCodDoc+XsNroDoc
        SCAN WHILE CodRef+NroRef = XsCodDoc+XsNroDoc
             IF CodDoc = "CANJ" AND FlgEst#"A"
                ZsNroDoc = NroDoc
                SELE GDOC
                SET ORDER TO GDOC03
                SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
                SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc="Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
                     LsGloLet = LsGloLet+TRIM(NroDoc)+","
                ENDSCAN
                SELE TASG
                EXIT
             ENDIF
        ENDSCAN
        SET ORDER TO TASG03
        GO vRegAct
        IF  EMPTY(ZsNroDoc)
            SELE TEMPO
            APPEND BLANK
            GATHER MEMVAR
            =SEEK(GsClfAux+CodCli,"AUXI")
            REPLACE Glosa2 WITH AUXI.NomAux
            SELE TASG
        ENDIF
   ENDSCAN
   *
   SELE TEMPO
   GO TOP
   IF EOF()
      GsMsgErr = "No existen registros a listar"
      DO LIB_MERR WITH 99
   ELSE
      xWHILE = []
      xFOR   = []
      WAIT "Impresi¢n..." NOWAIT WINDOW
      ** Impresion **
      Largo   = 66       && Largo de pagina
      LinFin  = 88 - 6
      IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3]
      IniImp =_PRN4+_PRN8A
      sNomREP = "Ccbr4ppc"
      DO ADMPRINT WITH "REPORTS"
   ENDIF
ENDIF
CLOSE DATA
DELE FILE &ArcTmp..DBF
DELE FILE &ArcTmp..CDX
RETURN
