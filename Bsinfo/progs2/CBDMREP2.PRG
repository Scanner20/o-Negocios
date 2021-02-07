PRIVATE Row1,Col1,x_op0,x_op1,x_opc2,x_opc3,x_opc4,x_opc5

DIMENSION x_op0(6,2)
DIMENSION x_op1(7)
DIMENSION x_op2(7)
DIMENSION x_op3(8)
DIMENSION x_op4(18)
DIMENSION x_op5(7)
DIMENSION x_op6(7)

x_op0( 1, 1) = "CONSULTAS"
x_op0( 2, 1) = "GENERALES"
x_op0( 3, 1) = "LIBROS"
x_op0( 4, 1) = "BALANCES"
x_op0( 5, 1) = "CTA.CTE."
x_op0( 6, 1) = "PRESUPUESTOS"

x_op0( 1, 2) = " Consultas Contables"
x_op0( 2, 2) = " Reportes Varios"
x_op0( 3, 2) = " Reportes Libros y Diarios"
x_op0( 4, 2) = " Estados Contables y/o financieros"
x_op0( 5, 2) = " Estados de cuenta Corriente"
x_op0( 6, 2) = " Reportes en base a presupuestos"

x_op2(1)    = "1.- Plan de Cuentas"
x_op2(2)    = "2.- Revision de Ctas"
x_op2(3)    = "3.- Cuentas Auxiliares"
x_op2(4)    = "4.- Reporte de Auxiliares"

x_op3(1)    = "1.- Diario General"
x_op3(2)    = "\-"
x_op3(3)    = "3.- Libro Mayor Auxiliar"
x_op3(4)    = "4.- Resumen Mayor Auxiliar"
x_op3(5)    = "5.- Libro Mayor An litico"
x_op3(6)    = "6.- Libro Compras"
x_op3(7)    = "7.- Libro Ventas"
*_op3(8)    = "8.- Libro Bancos"
x_op3(8)    = "8.- XXXXX"

x_op4( 1)   = "1 .- Balance Comprobaci¢n Mensual"
x_op4( 2)   = "2 .- Estado Financiero del Balance General"
x_op4( 3)   = "3 .- Balance Comprobaci¢n Acumulado"
x_op4( 4)   = "4 .- Balance de Situaci¢n"
x_op4( 5)   = "5 .- Balance Ajustado    "
x_op4( 6)   = "6 .- Balance de Saldos   "
x_op4( 7)   = "7 .- Anexos"
x_op4( 8)   = "8 .- Estado de Gestion General Ajustado"
x_op4( 9)   = "9 .- Estado de Gesti¢n por Mes"
x_op4(10)   = "A .- Estado de Gesti¢n General"
x_op4(11)   = "B .- An lisis de la Clase 9 por Mes"
x_op4(12)   = "C .- An lisis de la Clase 6 por Mes"
x_op4(13)   = "D .- An lisis de la Clase 9 por Tipo de Gasto."
x_op4(14)   = "E .- An lisis de la Clase 6 por Centro de Costos"
x_op4(15)   = "F .- An lisis de la Clase 9 por Tipo de Gasto. x Mes"
x_op4(16)   = "G .- An lisis de la Clase 9 por Tipo de Gasto x Fechas"
x_op4(17)   = "H .- An lisis de la Clase 9 y 6 por Tipo de Gasto."

x_op5(1)    = "1.- Saldos de Cuenta"
x_op5(2)    = "2.- Cuentas Pendientes x Auxiliar"
x_op5(3)    = "3.- Cuentas Pendientes x Cuenta"
x_op5(4)    = "4.- Balance de Cuentas"
x_op5(5)    = "5.- Cuentas Pendientes x Cuenta II"
x_op5(6)    = "6.- Cuentas Pendientes x Cuenta x FchVto"



x_op6(1)    = "\<1.- Tabla de Presupuestos"
x_op6(2)    = "\<2.- Configuraci¢n de Presupuestos"
x_op6(3)    = "\<3.- Resumenes en base a presupuesto"
x_op6(4)    = "\<4.- Clase 9 por tipo de gasto vs presupuesto"
x_op6(5)    = "\<5.- Tipo de Cambio Mensual"



Row1 = 1
Col1 = 1
DO WHILE .T.
   SET PROCEDURE TO
   CLEAR
   @  7,9 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
   @  8,9 SAY "|ÄÜÛÛÛÛÜÄÄÄÄÄÄÄÄÄÜÜÜÜÜÜÜÜÜÜÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄ       ÄÄÛÛÄ|" COLOR SCHEME 7
   @  9,9 SAY "|ÄÛÛÄÄßßÄÄÄÄÄÄÄÄÄßßßßÛÛßßßßÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÛÛÄ|" COLOR SCHEME 7
   @ 10,9 SAY "|ÄÛÛÄÄÄÄÄÜÛÛÛÜÄÛÜÛÛÜÄÛÛÄÜÛÛÛÜÄÛÛÛÛÜÄÛÛÄÛÛÄÛÛÄÜÛÛÛÛÄÜÛÛÛÜÄÜÛÛÛÛÄ|" COLOR SCHEME 7
   @ 11,9 SAY "|ÄÛÛÄÄÜÜÄÛÛÄÛÛ ÛÛÄÛÛ ÛÛÄÛÛÜÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÄÛÛÜÛÛÄÛÛÄÛÛÄ|" COLOR SCHEME 7
   @ 12,9 SAY "|ÄßÛÛÛÛßÄßÛÛÛßÄÛÛÄÛÛÄÛÛÄÛÛ ÛÛÄßÛÛÛßÄÛÛÄÛÛÄÛÛÄßÛÛÛßÄÛÛ ÛÛÄßÛÛÛßÄ|" COLOR SCHEME 7
   @ 13,9 SAY "|ÜÜÜÜÜÜÜÜÜÜÜ                                        ÜÜÜÜÜÜÜÜÜÜÜ|" COLOR SCHEME 7
   @ 14,9 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
   @ 15,17 SAY PADC("Compa¤ia "+GsCodCia+" "+TRIM(GsNomCia),46) COLOR SCHEME 11
   @ 16,17 SAY PADC("Usuario  "+GsUsuario,46)                   COLOR SCHEME 11
   @ 17,17 SAY PADC("Terminal "+GsTerminal,46)                  COLOR SCHEME 11
   @ 18,17 SAY PADC(MES(_MES,3)+" "+TRANS(_ANO,"9999"),46)     COLOR SCHEME 11
   @ 21,0 TO 21,79
   @ 23,0 TO 23,79

   GsMsgKey = "[Teclas del Cursor] Escoge opci¢n    [Enter] Selecciona    [Esc] Cancela"
   DO LIB_MTEC WITH 99
   SET MESSAGE TO 22
   MENU BAR x_op0,6
   MENU  2,x_op2,4
   MENU  3,x_op3,7
   MENU  4,x_op4,17
   MENU  5,x_op5,6
   MENU  6,x_op6,5
   READ MENU BAR TO Row1, Col1
   DO CASE
      CASE Row1 = 0
         RETURN
      CASE Row1 = 1
         DO CBDCONST
      CASE Row1 = 2
         DO CASE
            CASE Col1 = 1
               DO CBDRV001
            CASE Col1 = 2
               DO CBDRPLAN
            CASE Col1 = 3
               DO CBDRAUX
            CASE Col1 = 4
               DO CBDrauxi
         ENDCASE
      CASE Row1 = 3
         DO CASE
            CASE Col1 = 1
               DO CBDRL001
            CASE Col1 = 2
               DO CBDRL002
            CASE Col1 = 3
               DO CBDRL003
            CASE Col1 = 4
               DO CBDRL004
            CASE Col1 = 5
               DO CBDRL005
            CASE Col1 = 6
               DO CBDRL006
            CASE Col1 = 7
               DO CBDRL06v
            CASE Col1 = 8
               DO CBDR3c00
          *    DO CBDRL008
         ENDCASE
      CASE Row1 = 4
         DO CASE
            CASE Col1 = 1
               DO CBDRB001
            CASE Col1 = 2
               DO CBDRB002
            CASE Col1 = 3
               DO CBDRB003
            CASE Col1 = 4
               DO CBDRB004
            CASE Col1 = 5
               DO AjtRB001
            CASE Col1 = 6
               DO CBDRB006
            CASE Col1 = 7
               DO CBDRB007
            CASE Col1 = 8
               DO AJTRB002
            CASE Col1 = 9
               DO CBDRB009
            CASE Col1 = 10
               DO CBDRBv10
            CASE Col1 = 11
               DO CBDRB011
            CASE Col1 = 12
               DO CBDRB012
            CASE Col1 = 13
               DO CBDRB013
            CASE Col1 = 14
               DO CBDRB014
            CASE Col1 = 15
               DO CBDrb016
            CASE Col1 = 16
                DO CBDRB018
            CASE Col1 = 17
                DO CBDRB017
         ENDCASE
      CASE Row1 = 5
         DO CASE
            CASE Col1 = 1
               DO CBDRC001
            CASE Col1 = 2
               DO CBDRC004
            CASE Col1 = 3
               DO CBDRC002
            CASE Col1 = 4
               DO CBDRC003
            CASE Col1 = 5
               DO CBDRC02a
            CASE Col1 = 6
               DO CBDRC02v


         ENDCASE
      CASE Row1 = 6
         DO CASE
            CASE col1 = 1
               DO CBDMPRES WITH "05 "
            CASE col1 = 2
               DO CBDTPRES
            CASE Col1 = 3
               DO CBDRB020 WITH "05 "
            CASE Col1 = 4
               DO CBDRBp13
            case col1 = 5
               do cbdpcamb
         ENDCASE
   ENDCASE
ENDDO
