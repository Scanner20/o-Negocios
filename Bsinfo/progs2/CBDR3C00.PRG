********************************************************************************
* Programa      : CBDR3C00.PRG                                                 *
* Objeto        : XXXXX                                                        *
* Autor         : CVG                                                          *
* Creaciขn      : 23/04/96                                                     *
* Actualizaciขn :                                                              *
********************************************************************************
PRIVATE XsNroMes
WAIT 'ABRIENDO ARCHIVOS...' NOWAIT WINDOW
SELE 0
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS

SELE 0
USE CBDRMOVM ORDER RMOV01 ALIAS RMOV

SELE 0
USE CBDVMOVM ORDER VMOV01 ALIAS VMOV

SELE 0
USE CBDMTABL ORDER TABL01 ALIAS TABL

SELE 0
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI

SELE 0
USE CBDTOPER ORDER OPER01 ALIAS OPER

SELE 0             && Archivo temporal de selecciขn de cuentas
Arch = PathUser + SYS(3)
CREATE TABLE (Arch) (CodCta C(LEN(CTAS->CodCta)),;
                     PidAux C(LEN(CTAS->PidAux)),;
                     Status C(1)                )
USE (Arch) ALIAS CUENTAS EXCLU
INDEX ON CodCta  TAG CUENTAS
SET ORDER TO CUENTAS
WAIT 'GENERANDO CUENTAS TEMPORALES...'
APPEND FROM CBDMCTAS FOR CodCta = '6' .AND. PidAux = 'S'
REPLACE ALL Status WITH CHR(255)

SELE 0
TEMPO = PathUser + SYS(3)
CREATE TABLE (TEMPO) (CODCTA  C(LEN(CTAS->CODCTA)),;
                      CLFAUX  C(LEN(AUXI->CLFAUX)),;
                      CODAUX  C(LEN(AUXI->CODAUX)),;
                      MES01   N(12,2),             ;
                      MES02   N(12,2),             ;
                      MES03   N(12,2),             ;
                      MES04   N(12,2),             ;
                      MES05   N(12,2),             ;
                      MES06   N(12,2),             ;
                      MES07   N(12,2),             ;
                      MES08   N(12,2),             ;
                      MES09   N(12,2),             ;
                      MES10   N(12,2),             ;
                      MES11   N(12,2),             ;
                      MES12   N(12,2)              )

USE (TEMPO) ALIAS TEMPO EXCLU
INDEX ON CODCTA+CLFAUX+CODAUX TAG TMP01
SET ORDER TO TMP01
WAIT CLEAR

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "XXXX"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

SELE CUENTAS
SET RELATION TO CODCTA INTO CTAS
UltTecla = 0
DO xBrowse
IF UltTecla = Escape
   CLOSE DATA
   ERASE &TEMPO..DBF
   ERASE &TEMPO..CDX
   ERASE &Arch..DBF
   ERASE &Arch..CDX
   RETURN
ENDIF

SELE RMOV
SET RELATION TO CODCTA INTO CUENTAS
SELE VMOV
GO TOP
Cancelar = .F.
DO WHILE !EOF() .AND. !Cancelar
   Cancelar = (INKEY()=Escape)
   XsNroMes = NroMes
   SCAN WHILE NroMes = XsNroMes FOR FlgEst # 'A'
      LsLlave1 = NroMes+CodOpe+NroAst
      SELE RMOV
      SEEK LsLLave1
      SCAN WHILE NroMes+CodOpe+NroAst = LsLlave1
         IF CUENTAS->Status = CHR(251)
            WAIT 'PROCESANDO '+MES(VAL(NROMES),1)+', OPERACION '+CodOpe+', VOUCHER '+NroAst NOWAIT WINDOW
            SELE TEMPO
            IF !SEEK(RMOV->CodCta+RMOV->ClfAux+RMOV->CodAux)
               APPEND BLANK
               REPLACE CodCta WITH RMOV->CodCta,;
                       ClfAux WITH RMOV->ClfAux,;
                       CodAux WITH RMOV->CodAux
            ENDIF
            LsCmpMes = 'MES'+RMOV->NroMes
            LnValMes = &LsCmpMes.
            REPLACE (LsCmpMes) WITH LnValMes + IIF(RMOV->TpoMov="D",RMOV->Import,-RMOV->Import)
         ENDIF
         SELE RMOV
      ENDSCAN
      SELE VMOV
   ENDSCAN
ENDDO
WAIT CLEAR

SELE TEMPO
GO TOP
IF EOF()
   GsMsgErr = [No hay datos]
   DO lib_merr WITH 99
   CLOSE DATA
   ERASE &TEMPO..DBF
   ERASE &TEMPO..CDX
   ERASE &Arch..DBF
   ERASE &Arch..CDX
   RETURN
ENDIF
SELE CUENTAS
SET RELATION TO
SELE RMOV
SET RELATION TO
SELE TEMPO
SET RELATION TO CODCTA        INTO CTAS
SET RELATION TO '01'+CLFAUX   INTO TABL ADDI
SET RELATION TO CLFAUX+CODAUX INTO AUXI ADDI
xFOR = []
xWHILE = []
sNomRep = [cbdr3c00]
IniPrn = [_Prn0+_Prn5a+CHR(66)+_Prn5b+_Prn3]
DO ADMPRINT WITH "REPORTS"

CLOSE DATA
ERASE &TEMPO..DBF
ERASE &TEMPO..CDX
ERASE &Arch..DBF
ERASE &Arch..CDX
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*
PROCEDURE RESETPAG
   IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltoPag
      SaltoPag = .F.
      IF NumPag > 0
         NumLin = LINFIN + 1
         IF NumLin < (PROW() + 1)
            NumLin = (PROW() + 1)
         ENDIF
         @ NumLin,Ancho -12  SAY "Continua.."
      ENDIF
      DO ADMMBPRN &&IN ADMPRINT
      IF InKey() = Escape
         Cancelar = .T.
      ENDIF
   ENDIF
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*
* Selecciขn de movimientos
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*
PROCEDURE xBrowse
   PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
   PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
   PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
   PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorde
   PRIVATE E1,E2,E3,LinReg
   PRIVATE Static,VSombra
   Consulta = .F.
   Modifica = .T.
   Adiciona = .F.
   DB_Pinta = .F.
   Set_Escape=.T.
   UltTecla = 0
   SelLin   = []
   InsLin   = []
   EscLin   = []
   EdiLin   = [xBEdiLin]
   BrrLin   = []
   GrbLin   = []
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
   NClave   = []
   VClave   = []
   HTitle   = 1
   Yo       = 5
   Xo       = 13
   Largo    = 18
   Ancho    = 55
   TBorde   = 1
   E1       = [CUENTA  DESCRIPCION               ]
   E2       = []
   E3       = []
   LinReg   = [CodCta+' '+CTAS->NomCta+' '+Status]
   Static   = .T.
   VSombra  = .F.

   SAVE SCREEN TO LsPan01
   DO lib_mtec WITH "[Esc] Salir   [Enter] Marcar/Desmarcar  [Home] [End] Posicionar  [F10] Aceptar"
   DO DBrowse
   RESTORE SCREEN FROM LsPan01
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*
* Edita lกnea del DBrowse
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*
PROCEDURE xBEdiLin
   IF Status = CHR(255)
      REPLACE Status WITH CHR(251)
   ELSE
      REPLACE Status WITH CHR(255)
   ENDIF
   UltTecla = Enter
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*
