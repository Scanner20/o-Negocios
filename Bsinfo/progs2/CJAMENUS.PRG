RELEASE ALL LIKE m_op?
DIMENSION m_op0(5,2)
DIMENSION m_op1(10)
DIMENSION m_op2(10)
DIMENSION m_op3(10)
DIMENSION m_op4(10)
DIMENSION m_op5(10)
**DIMENSION m_op6(10)

m_op0( 1, 1) = "MAESTROS"
m_op0( 2, 1) = "MOVIMIENTOS"
m_op0( 3, 1) = "REPORTES"
m_op0( 4, 1) = "UTILITARIOS"
m_op0( 5, 1) = "MANTENIMIENTO"

m_op0( 1, 2) = " Tablas y Maestros del Sistema"
m_op0( 2, 2) = " Movimientos Contables"
m_op0( 3, 2) = " Consultas y reportes"
m_op0( 4, 2) = " Mantenimiento de Archivos"
m_op0( 5, 2) = " Utilitarios del Sistema"

m_op1(1)    = "\<1.- Nro. de Relaci¢n"
m_op1(2)    = "\<2.- Tipo de Cambio"
m_op1(3)    = "\<3.- Cuentas Bancarias"
m_op1(4)    = "\<4.- Codificaci¢n de Bancos"
m_op1(5)    = "\<5.- Tipo de Programaci¢n "
m_op1(6)    = "\<6.- Operaciones Financieras"

m_op2(1)    = "\<1.- Voucher de Ingreso"
m_op2(2)    = "\<2.- Voucher de Egreso"
m_op2(3)    = "\<3.- Voucher de Transferencia"
m_op2(4)    = "\<4.- Canje de documentos por pagar"
m_op2(5)    = "\<5.- Contables"
m_op2(6)    = "\<6.- Consistencia de movimientos"
m_op2(7)    = "\<7.- Egreso y Renovaci¢n de Letra"

m_op3(1)    = "\<1.- Relaci¢n de Cheques Emitidos"
m_op3(2)    = "\<2.- Documentos Emitidos"
m_op3(3)    = "\<3.- Consultas Bancos"
m_op3(4)    = "\-"  &&<4.- Consultas Cuentas Pagar"
m_op3(5)    = "\<5.- Libro de Bancos"
m_op3(6)    = "\<6.- Estado de Liquidez"
m_op3(7)    = "\<7.- Consulta de finanzas"
m_op3(8)    = "\<8.- Conciliacion Bancaria"

m_op4(1)    = "\<1.- Control de Impresi¢n"
m_op4(2)    = "\<2.- Usuarios del Sistema"
m_op4(3)    = "\<3.- Clave de Modificaci¢n"
m_op4(4)    = "----------------------------"



m_op5(1)    = "\<1.- Mantenimiento de Archivos"

Row = 1
Col = 1
DO WHILE .T.
   SET PROCEDURE TO
   CLEAR
   @  7,9 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
   @  8,9 SAY "|ÄÜÛÛÛÛÜÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÜÛÛÛÛÜÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|" COLOR SCHEME 7
   @  9,9 SAY "|ÄÛÛÄÄßßÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÛÛÄÄÛÛÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|" COLOR SCHEME 7
   @ 10,9 SAY "|ÄÛÛÄÄÄÄÄÜÛÛÛÜÄÜÛ ÛÛÄÜÛÛÛÜÄÄÄÄÛÛÛÛÛÛÜÄÜÛÛÛÜÄÛÜÛÛÜÄÜÛÛßÛÄÜÛÛÛÜÄÄ|" COLOR SCHEME 7
   @ 11,9 SAY "|ÄÛÛÄÄÜÜÄÛÛÜÛÛÄÛÛÄÛÛÄÛÛÜÛÛÄÄÄÄÛÛÄÄÄÛÛÄÛÛÜÛÛ ÛÛÄÛÛÄÛÛÄÄÜÄÛÛÄÛÛÄÄ|" COLOR SCHEME 7
   @ 12,9 SAY "|ÄßÛÛÛÛßÄÛÛ ÛÛÄßÛÛÛßÄÛÛ ÛÛÄÄÄÄßÛÛÛÛÛßÄÛÛ ÛÛÄÛÛÄÛÛÄßÛÛÜÛÄßÛÛÛßÄÄ|" COLOR SCHEME 7
   @ 13,9 SAY "|ÜÜÜÜÜÜÜÜÜÜÜ                                        ÜÜÜÜÜÜÜÜÜÜÜ|" COLOR SCHEME 7
   @ 14,9 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
   @ 15,21 SAY LEFT(GsCodCia+" "+GsNomCia+SPACE(38),38) PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 16,21 SAY LEFT("Usuario  "+GsUsuario+SPACE(38),38)  PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 17,21 SAY LEFT("Terminal "+GsTerminal+SPACE(38),38) PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 18,21 SAY LEFT(MES(_MES,3)+" "+TRANS(_ANO,"9,999")+SPACE(38),38) PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 21,0 TO 21,79
   @ 23,0 TO 23,79

   GsMsgKey = "[Teclas del Cursor] Escoge opci¢n    [Enter] Selecciona    [Esc] Cancela"
   DO LIB_MTEC WITH 99
   SET MESSAGE TO 22
   CLOSE DATA
   SELE 0
   USE ADMRUSER ORDER RUSE01 ALIAS USU
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
   SEEK GsUsuario+[CJA]
   IF !FOUND()
      GsMsgErr = [USUARIO NO TIENE ACCESO AL SISTEMA]
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
   MENU BAR m_op0,5
   IF  [1] $ USU->MENUS
       MENU  1,m_op1,6
   ENDIF
   IF  [2] $ USU->MENUS
       MENU  2,m_op2,5
   ENDIF
   IF [3] $ USU->MENUS
      MENU  3,m_op3,6
   ENDIF
   IF [4] $ USU->MENUS
      MENU  4,m_op4,4
   ENDIF
   IF [5] $ USU->MENUS
     MENU  5,m_op5,1
   ENDIF
   USE
   READ MENU BAR TO Row, Col
   DO CASE
      CASE row = 0
         RETURN
      CASE row = 1
         DO CASE
            CASE col = 1
               DO CJANoREL
            CASE col = 2
              *DO CJATPCMB
               do admmtcmb_x
            CASE col = 3
               DO CJAMCTAS
            CASE col = 4
               DO CBDMTABL WITH "04"
            CASE col = 5
               DO CBDMTABL WITH "TP"
            CASE col = 6
               DO CJATFNZA
         ENDCASE

      CASE row = 2
         DO CASE
            CASE col = 1
               DO CJAC1MOV
            CASE col = 2
               DO CJAC2MOV
            CASE col = 3
               DO CJAC3mov
             CASE col = 4
               DO CJACjle1
             CASE col = 5
               DO cbdmmovm
             CASE col = 6
               DO cbdgcons
             CASE col = 7
               DO cjaegrle
         ENDCASE

      CASE row = 3
         DO CASE
            CASE col = 1
               DO CJARG001
            CASE col = 2
               DO CJARG002
            CASE col = 3
               DO CJACONST
            CASE col = 4
               DO CJACCPAG
            CASE col = 5
              * DO CJACDOCM
                DO CJALIBRO
            CASE col = 6
               DO cjarg005
            CASE col = 7
               DO cjaCFNZA
            CASE col = 8
               DO cjarg006
         ENDCASE
      CASE row = 4
         DO CASE
            CASE col = 1
               DO ADMUTPRN
            CASE col = 2
               DO ADMGUSER
            CASE col = 3
               DO CJACONFG
            CASE col = 4
            if INLIST(gsusuario,"VT","MASTER")	
               SUSPEN
            ENDIF   
         ENDCASE
      CASE row = 5
         DO CASE
            CASE Col = 1
               DO INDEXA WITH "CJAMARCH","CJAMINDI"
         ENDCASE
    * CASE row = 5
    *    DO CASE
    *       CASE col = 1
    *          DO CJAFLUJO
    *       CASE col = 2
    *          DO CJARF001
    *       CASE col = 3
    *          DO CJARF002
    *       CASE col = 4
    **         DO CJARF003
    *    ENDCASE
   ENDCASE
ENDDO
