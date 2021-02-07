private _mes,_ano
_mes = mont(date())
_ano = year(date())
RELEASE Top, m_file, m_edit, data
DIMENSION Top(7,2)
DIMENSION m_op1(20)
DIMENSION m_op2(20)
DIMENSION m_op3(20)
DIMENSION m_op4(20)
DIMENSION m_op5(20)
DIMENSION m_op6(20)
DIMENSION m_op7(20)
GsFecha  = SPACE(8)

Top( 1, 1) = "MAESTROS"
Top( 2, 1) = "PEDIDOS"
Top( 3, 1) = "FACTURACION"
Top( 4, 1) = "REPORTES"
Top( 5, 1) = "ESTADISTICAS"
Top( 6, 1) = "MANTENIMIENTO"
Top( 7, 1) = "UTILITARIOS"

Top( 1, 2) = " Archivos Maestros"
Top( 2, 2) = " Ingreso de Pedidos"
Top( 3, 2) = " Guias, Facturas y Boletas"
Top( 4, 2) = " Reportes de Ventas"
Top( 5, 2) = " Reportes Estad¡sticos"
Top( 6, 2) = " Mantenimiento y regeneraci¢n de archivos"
Top( 7, 2) = " Procesos varios"

m_op1( 1) = "\<1.- Maestro de Clientes"
m_op1( 2) = "\<2.- Condiciones de Pago"
m_op1( 3) = "\<3.- Correlativo de documentos"
m_op1( 4) = "\<4.- Lista de Precios"
m_op1( 5) = "\<5.- Maestro de Vendedores"
m_op1( 6) = "\<6.- C¢digo Postal"
m_op1( 7) = "\<7.- Tipo de Cambio"
m_op1( 8) = "\<8.- Lista Total de Precios"
m_op1( 9) = "\<9.- Lista Total de Precios -IGV"

m_op2(1)  = "\<1.- Ingreso/Cierre de Pedidos"
m_op2(2)  = "\-"
m_op2(3)  = "\<2.- Revisi¢n de Pedidos"

m_op3(1)  = "\<1.- Guias de Remisi¢n"
m_op3(2)  = "\<2.- Factura"
m_op3(3)  = "\<3.- Boleta de Ventas"
m_op3(4)  = "\-"
m_op3(5)  = "\<4.- Enlazar Guias con Factura"
m_op3(6)  = "\<5.- Apertura Saldos (F)"
m_op3(7)  = "\<6.- Apertura Saldos (B)"
m_op3(8)  = "\-"
m_op3(9)  = "\<7.- Factura IGV Incluido"
m_op3(10) = "\<8.- Boleta IGV Incluido"


m_op4(1)  = "\<1.- Registro de Ventas "
m_op4(2)  = "\<2.- Registro de Pedidos"
m_op4(3)  = "\<3.- Registro de Guias  "
m_op4(4)  = "\<4.- Ventas x Cliente"
m_op4(5)  = "\<5.- Ventas x Articulo"
m_op4(6)  = "\<6.- Diario de Ventas "
m_op4(7)  = "\<7.- Registro General de Ventas"
m_op4(8)  = "\<8.- Programa de Entregas por Producto"
m_op4(9)  = "\<9.- Programa de Entregas Consolidado"

m_op5(1)  = "\<1.- Ventas x Cliente/Art¡culo Anual (Cantidad)"
m_op5(2)  = "\<2.- Ventas x Art¡culo/Cliente Anual (Cantidad)"
m_op5(3)  = "\<3.- Ventas x Cliente/Art¡culo Anual (U.M.)"
m_op5(4)  = "\<4.- Ventas x Art¡culo/Cliente Anual (U.M.)"

m_op6(1)  = "Mantenimiento"
m_op6(2)  = "Utilitarios de Base de Datos"

m_op7(1)  = "Control de \<Impresi¢n"
m_op7(2)  = "\<Formatear Unidades"
m_op7(3)  = "\<Copias de Respaldo"
m_op7(4)  = "\<Restaurar copias"
m_op7(5)  = "\<Usuarios del Sistema"
m_op7(6)  = "\<Configurar el Sistema"
m_op7(7)  = "\<Salir del Sistema"
m_op7(8)  = "\-"
m_op7(9)  = "Asiento por Facturas"
m_op7(10) = "Asiento por Boletas"

Row0 = 1
Col0 = 1
DO WHILE .T.
	SET PROCEDURE TO
	CLEAR
	GsFecha = LTRIM(STR(DAY(GdFecha)))+"-"+MES(GdFecha,3)+;
			  "-"+STR(YEAR(GdFecha),4)
*  @  7,18 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
*  @  8,18 SAY "³ ÛÛ     ÜÛÛß               ÛÛ     ÜÛÛß   ³" COLOR SCHEME 7
*  @  9,18 SAY "³ ÛÛ   ÜÛÛß                 ÛÛ   ÜÛÛß     ³" COLOR SCHEME 7
*  @ 10,18 SAY "³ ÛÛ ÜÛÛß                   ÛÛ ÜÛÛß       ³" COLOR SCHEME 7
*  @ 11,18 SAY "³ ÛÛÛÛß                     ÛÛÛÛß         ³" COLOR SCHEME 7
*  @ 12,18 SAY "³ ÛÛß  E N T A S            ÛÛß   ß  3.3  ³" COLOR SCHEME 7
*  @ 13,18 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 7
*  @ 15,14 SAY "           Modulo : Ventas    V.3.3/1993           " COLOR SCHEME 11
*  @ 16,14 SAY "       Todos los derechos a Valmiesa Software      " COLOR SCHEME 11
   @ 17,14 SAY PADC("Compa¤ia   :"+GsCodCia+" " + TRIM(GsNomCia),51) COLOR SCHEME 11
   @ 18,14 SAY PADC("Fecha : "+GsFecha,51)                           COLOR SCHEME 11
   @ 21,0 TO 21,79
   @ 23,0 TO 23,79
   GsMsgKey = "[Teclas del Cursor] Escoge opci¢n    [Enter] Selecciona    [Esc] Cancela"

   DO LIB_MTEC WITH 99
   SET MESSAGE TO 22
   IF MASTER
      MENU BAR Top,7
   ELSE
      MENU BAR Top,5
   ENDIF
   MENU 1,m_op1,9
   MENU 2,m_op2,3
   MENU 3,m_op3,10
   MENU 4,m_op4,9
   MENU 5,m_op5,4
   MENU 6,m_op6,2
   MENU 7,m_op7,7
   READ MENU BAR TO Row0, Col0
   DO CASE
      CASE row0 = 0
         RETURN
      CASE row0 = 1
         DO CASE
          CASE col0 =1
               DO vtap1100
            CASE col0 =2
               DO vtaMTABL WITH "01",.F.
            CASE col0 =3
               DO vtacdocm
            CASE col0 =4
               DO vtap1500
            CASE col0 =5
               DO vtamtabl WITH '09',.F.
            CASE col0 = 6
               DO vtamtabl with 'CP',.F.
            CASE col0 =7
               DO cjatpcmb
            CASE col0 = 8
               DO vt-list1
            CASE col0 = 9
               DO vt-list2
         ENDCASE
      CASE row0 = 2
         DO CASE
            CASE col0 =1
               DO vtap2100
            CASE col0 =3
               DO vtap2200
         ENDCASE
      CASE row0 = 3
         DO CASE
            CASE col0 =1
               DO vtap3100
            CASE col0 =2
               DO vtap3200 WITH [FACT]
            CASE col0 =3
               DO vtap3200 WITH [BOLE]
            CASE col0 = 5
               DO vtap3900
            CASE col0 = 6
               DO vtap320A WITH [FACT]
            CASE col0 = 7
               DO vtap320A WITH [BOLE]
            CASE col0 = 9
               DO vtap3700 WITH [FACT]
            CASE col0 = 10
               DO vtap3700 WITH [BOLE]
         ENDCASE
      CASE row0 = 4
         DO CASE
            CASE col0 = 1
               DO vtar4100   && Registro de ventas
            CASE col0 = 2
               DO vtar4200   && Registro de Pedidos
            CASE col0 = 3
               DO vtar4250   && Registro de Guias
            CASE col0 = 4
               DO vtar4510   && Ventas x Cliente
            CASE col0 = 5
               DO vtar4520   && Vtas. x Articulo
            CASE col0 = 6
               DO vtar4800   && diario de ventas
            CASE col0 = 7
               DO VTAR410A
            CASE col0 = 8
               DO vtar4300   && Prog. Entreg.x Prod.
            CASE col0 = 9
               DO vtar4400   && Prog. Entreg.Consoli
         ENDCASE

      CASE row0 = 5
         DO CASE
            CASE col0 =1
               DO VTAR5010  && ventas cliente/art. anual (CANTIDAD)
            CASE col0 =2
               DO VTAR5020  && vetas. art./cliente anual (CANTIDAD)
            CASE col0 =3
               DO VTAR5030  && ventas cliente/art. anual (U.M.)
            CASE col0 =4
               DO VTAR5040  && vetas. art./cliente anual (U.M.)
         ENDCASE

      CASE row0 = 6
         DO CASE
            CASE col0 =1
               DO INDEXA WITH "VTAMARCH","VTAMINDI"
            CASE col0 =2
             * DO UTILITAR
               DO YOTA
         ENDCASE
      CASE row0 = 7
         DO CASE
            CASE col0 = 1
               DO yyy
            CASE col0 = 2
               DO ADMFORMT
            CASE col0 = 3
               DO ADMCOPIA WITH "VTALISTA"
            CASE col0 = 4
               DO ADMRESTA WITH "VTALISTA"
            CASE col0 = 5
               DO ADMGUSER
            CASE col0 = 6
               DO VTACONFG
            CASE col0 = 7
               QUIT
            CASE col0 = 9
               DO tras_fac with [FACT]
            CASE col0 = 10
               DO tras_fac with [BOLE]
         ENDCASE
   ENDCASE
ENDDO
