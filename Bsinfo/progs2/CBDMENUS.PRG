SET TALK OFF
SET RESO OFF
RELEASE ALL LIKE m_op?

DIMENSION m_op0(8,2)
DIMENSION m_op1(5)
DIMENSION m_op2(12)
DIMENSION m_op3(2)
DIMENSION m_op4(14)
DIMENSION m_op5(4)
DIMENSION m_op6(5)
DIMENSION m_op7(8)

m_op0( 1, 1) = "R\<ECEPCION"
m_op0( 2, 1) = "\<MOVIMIENTOS"
m_op0( 3, 1) = "\<REPORTES"
m_op0( 4, 1) = "M\<AESTROS"
m_op0( 5, 1) = "\<PROCESOS"
m_op0( 6, 1) = "MAN\<TENIMIENTO"
m_op0( 7, 1) = "\<UTILITARIOS"
m_op0( 8, 1) = "CON\<FIGURACION"

m_op0( 1, 2) = " Recepci¢n y consulta documentos no provisionados"
m_op0( 2, 2) = " Tablas y Maestros del Sistema"
m_op0( 3, 2) = " Movimientos Contables"
m_op0( 4, 2) = " Consultas y reportes"
m_op0( 5, 2) = " Procesos varios"
m_op0( 6, 2) = " Mantenimiento y regeneraci¢n de archivos"
m_op0( 7, 2) = " Utilitarios del Sistema"
m_op0( 8, 2) = " Cofiguraci¢n de Sistema y Reportes"

m_op1(1)    = "\<Recepci¢n de documentos"

m_op2(1)    = "\<1.Maestro de tablas"
m_op2(2)    = "\<2.Plan de Cuentas"
m_op2(3)    = "\<3.Cuentas Auxiliares"
m_op2(4)    = "\<4.Operaciones Contables"
m_op2(5)    = "\<5.Clasificaci¢n de Auxiliares"
m_op2(6)    = "\<6.Codificaci¢n de Documentos"
m_op2(7)    = "\<7.DocumenTos por operaci¢n"
m_op2(8)    = "\<8.Codigos de balances configurables"
m_op2(9)    = "\<9.Codigos de anexos configurables"
m_op2(10)   = "\<A.Codigos de Estados de Gestion configurables"
m_op2(11)   = "\<B.Codigos de Libros Contables obligatorios"



m_op3(1)    = "\<Diario General"
m_op3(2)    = "\<Asientos Tipo"

m_op4(1)    = "\<1.- Cierre Diario"
m_op4(2)    = "\<2.- Cierre de Mes"
m_op4(3)    = "\<3.- Reapertura del Mes"
m_op4(4)    = "\-"
m_op4(5)    = "\<4.- Asiento x Diferencia de Cambio"
m_op4(6)    = "\<5.- Asiento x Traslaci¢n"
m_op4(7)    = "\-"
m_op4(8)    = "\<6.- Registro de Extracto Bancario"
m_op4(9)    = "\<7.- Generaci¢n Conciliaci¢n Bancaria"
m_op4(10)   = "\<8.- Extracto de Cuenta"
m_op4(11)   = "\<9.- Resumen Mensual de Bancos"
m_op4(12)   = "\<A.- Conciliacion Bancaria"
m_op4(13)   = "\<B.- Consulta"
m_op4(14)   = "\<C.- REGISTRO DE COA"

m_op5(1)    = "\<Mantenimiento de Archivos"
m_op5(2)    = "\<Consistencia de Movimientos"
m_op5(3)    = "\<Regeneraci¢n de Saldos"
m_op5(4)    = "\<Apertura de A¤o Contable"

m_op7(1)    = "Control de \<Impresi¢n"
m_op7(2)    = "\-" &&"\<Formatear Unidades"
m_op7(3)    = "\-" &&"\<Copias de Respaldo"
m_op7(4)    = "\-" &&"\<Restaurar copias"
m_op7(5)    = "\<Usuarios del Sistema"
m_op7(6)    = "\<Configurar el Sistema"
m_op7(7)    = "\<Salir del Sistema"
M_OP7(8)    = "-------------------"

m_op6(1)    = "Configuraci¢n General"
m_op6(2)    = "Configuraci¢n \<Balance General"
m_op6(3)    = "Configuraci¢n \<Anexos al Balance"
m_op6(4)    = "Configuraci¢n \<Estados de Gesti¢n"
m_op6(5)    = "Configuraci¢n Asientos Contables \<Tipos"

Row0 = 1
Col0 = 1
DO WHILE .T.
   SET PROCEDURE TO
   CLEAR
   @  7,9 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
   @  8,9 SAY "|ÄÜÛÛÛÛÜÄÄÄÄÄÄÄÄÄÜÜÜÜÜÜÜÜÜÜÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄv. 7.0 ÄÄÛÛÄ|" COLOR SCHEME 7
   @  9,9 SAY "|ÄÛÛÄÄßßÄÄÄÄÄÄÄÄÄßßßßÛÛßßßßÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÛÛÄ|" COLOR SCHEME 7
   @ 10,9 SAY "|ÄÛÛÄÄÄÄÄÜÛÛÛÜÄÛÜÛÛÜÄÛÛÄÜÛÛÛÜÄÛÛÛÛÜÄÛÛÄÛÛÄÛÛÄÜÛÛÛÛÄÜÛÛÛÜÄÜÛÛÛÛÄ|" COLOR SCHEME 7
   @ 11,9 SAY "|ÄÛÛÄÄÜÜÄÛÛÄÛÛ ÛÛÄÛÛ ÛÛÄÛÛÜÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÜÛÛÄÛÛÄÛÛÄ|" COLOR SCHEME 7
   @ 12,9 SAY "|ÄßÛÛÛÛßÄßÛÛÛßÄÛÛÄÛÛÄÛÛÄÛÛ ÛÛÄßÛÛÛßÄÛÛÄÛÛÄÛÛÄßÛÛÛßÄÛÛ ÛÛÄßÛÛÛßÄ|" COLOR SCHEME 7
   @ 13,9 SAY "|ÜÜÜÜÜÜÜÜÜÜÜ                                        ÜÜÜÜÜÜÜÜÜÜÜ|" COLOR SCHEME 7
   @ 14,9 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
   @ 15,17 SAY LEFT("Compa¤ia "+GsCodCia+" "+GsNomCia+SPACE(46),46)  PICTURE "@I" COLOR SCHEME 11
   @ 16,17 SAY LEFT("Usuario  "+GsUsuario+SPACE(46),46)  PICTURE "@I" COLOR SCHEME 11
   @ 17,17 SAY LEFT("Terminal "+GsTerminal+SPACE(46),46) PICTURE "@I" COLOR SCHEME 11
   @ 18,17 SAY LEFT(MES(_MES,3)+" "+TRANS(_ANO,"9999")+SPACE(46),46) PICTURE "@I" COLOR SCHEME 11
   @ 21,0 TO 21,79
   @ 23,0 TO 23,79

   GsMsgKey = "[Teclas del Cursor] Escoge opci¢n    [Enter] Selecciona    [Esc] Cancela"
   DO LIB_MTEC WITH 99
   SET MESSAGE TO 22
*  DO CASE
*     CASE MASTER
*          MENU BAR m_op0,8
*     CASE !Master AND GsUsuario="RECEPCION"
*          MENU BAR m_op0,1
*     OTHER
*          MENU BAR m_op0,3
*  ENDCASE
*
*  MENU  1,m_op1,1
*  MENU  2,m_op3,2
*  MENU  4,m_op2,6
*  MENU  5,m_op4,14
*  MENU  6,m_op5,3
*  MENU  7,m_op7,8
*  MENU  8,m_op6,4
   CLOSE DATA
   SELE 0
   USE ADMRUSER ORDER RUSE01 ALIAS USU
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
   SEEK GsUsuario+[CBD]
   IF !FOUND()
      GsMsgErr = [USUARIO NO TIENE ACCESO AL SISTEMA]
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
   MENU BAR m_op0,8
   IF  [1] $ USU->MENUS
       MENU  1,m_op1,1
   ENDIF
   IF  [2] $ USU->MENUS
       MENU  2,m_op3,2
   ENDIF
   IF [4] $ USU->MENUS
      MENU  4,m_op2,11
   ENDIF
   IF [5] $ USU->MENUS
      MENU  5,m_op4,14
   ENDIF
   IF [6] $ USU->MENUS
      MENU  6,m_op5,4
   ENDIF
   IF [7] $ USU->MENUS
      MENU  7,m_op7,8
   ENDIF
   IF [8] $ USU->MENUS
      MENU  8,m_op6,5
   ENDIF
   USE
   READ MENU BAR TO Row0, Col0
   DO CASE
      CASE row0 = 0
         RETURN
      CASE row0 = 1
         DO CASE
            CASE col0 = 1
               DO Cbdrecep
         ENDCASE
      CASE row0 = 4
         DO CASE
            CASE col0 = 1
               DO CBDMtabl with "00",.t.
            CASE col0 = 2
               DO CBDMCTAS
            CASE col0 = 3
               DO CBDMAUXI
            CASE col0 = 4
               DO CBDMOPER
            CASE col0 = 5
               DO CBDMTABL WITH "01",.T.
            CASE col0 = 6
               DO CBDMTABL WITH "02",.F.
            CASE col0 = 7
               DO CBDMTOPE
            CASE col0 = 11
               DO CBDMTABL WITH "LC",.F.
         ENDCASE
      CASE row0 = 2
         DO CASE
            CASE col0 = 1
               *set century on
               DO CBDMMOVM
               *set century off
            CASE col0 = 2
               DO CbdAstpo
            CASE col0 = 3
***************DO Cbdmmo01
***************DO Cjac4mov
         ENDCASE
      CASE row0 = 3
         DO CBDMREPO
      CASE row0 = 5
         DO CASE
            CASE col0 = 1
               DO CBDPCDIA
            CASE col0 = 2
               DO CBDPCMES
            CASE col0 = 3
               DO CBDPRMES
            CASE col0 = 5
               DO CBDDFCMB
            CASE col0 = 6
               DO CBDDCMB2
            CASE col0 = 8
               DO CBDEXTRA
            CASE col0 = 9
               DO CBDGCONC
            CASE col0 = 10
                DO CBDLCON1
            CASE col0 = 11
                DO CBDLCON2
            CASE col0 = 12
                DO CBDLCON3
            CASE col0 = 13
               DO CBDCONLI
            CASE col0 = 14
               DO CBDRGCOA
         ENDCASE
      CASE row0 = 6
         DO CASE
            CASE col0 = 1
               DO INDEXA WITH "CBDMARCH","CBDMINDI"
            CASE col0 = 2
               DO CBDGcons
            CASE col0 = 3
               DO CBDGENER
            CASE col0 = 4
               DO CBDANUAL
         ENDCASE
      CASE row0 = 7
         DO CASE
            CASE col0 = 1
               DO ADMUTPRN
            CASE col0 = 2
               DO ADMFORMT
            CASE col0 = 3
               DO ADMCOPIA WITH "CBDLISTA"
            CASE col0 = 4
               DO ADMRESTA WITH "CBDLISTA"
            CASE col0 = 5
               DO ADMGUSER
            CASE col0 = 6
               DO CBDCONFG
            CASE col0 = 7
               QUIT
            CASE col0 = 8
            if INLIST(gsusuario,"VT","MASTER")	
               SUSPEN
            ENDIF   
         ENDCASE
      CASE row0 = 8
         DO CASE
         	CASE COL0 = 1
         		do cbdcnfg0.spr
            CASE col0 = 2
               DO CBDTBALC
            CASE col0 = 3
               DO CBDTANXO
            CASE col0 = 4
               DO CBDTPERN
            CASE col0 = 5
               DO CBDTMDLO
         ENDCASE
   ENDCASE
ENDDO
