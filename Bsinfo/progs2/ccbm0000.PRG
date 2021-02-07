SET TALK OFF
set century on
set date to brit
PUBLIC cfgtasadia,XsClfAux,GsClfAux
XsClfAux = [CLI]     && OJO >> gran parche
GsClfAux = [CLI]     && OJO >> gran parche
GdFecha = date()
GsFecha = LTRIM(STR(DAY(GdFecha)))+"-"+MES(GdFecha,3)+;
             "-"+STR(YEAR(GdFecha),4)
RESTORE FROM VTACONFG ADDITIVE
**------------------**            
GsClfCli=XsClfAux
GsBusca =[CCBSELEC]
GsSistema=[CTA.COB]
IF _windows 
	SET DISPLAY TO VGA25
	
ENDIF
* * * *
RELEASE ALL LIKE m_op?
DIMENSION m_op0(6,2)
DIMENSION m_op1(20)
DIMENSION m_op2(30)
DIMENSION m_op3(20)
DIMENSION m_op4(20)
DIMENSION m_op5(20)
DIMENSION m_op6(20)

m_op0( 1, 1) = "MAESTROS"
m_op0( 2, 1) = "DOCUMENTOS"
m_op0( 3, 1) = "REPORTES"
m_op0( 4, 1) = "MANTENIMIENTO"
m_op0( 5, 1) = "COBRANZAS"
m_op0( 6, 1) = "LETRAS"
*m_op0( 7, 1) = "TERMINAR"

m_op0( 1, 2) = " Actualizaciones a maestros"
m_op0( 2, 2) = " Registro de Documentos"
m_op0( 3, 2) = " Consultas y Reportes varios"
m_op0( 4, 2) = " Mantenimiento y regeneraci¢n de archivos"
m_op0( 5, 2) = " Cancelaci¢n de Documentos"
m_op0( 6, 2) = " Control de Letras"
*m_op0( 7, 2) = " Salir del Sistema"


m_op1(1)    = "\<Clientes"
m_op1(2)    = "C\<uentas Bancarias"
m_op1(3)    = "Tabla de \<Bancos"
m_op1(4)    = "Tabla de \<Documentos"
m_op1(5)    = "Conceptos de Car\<go"
m_op1(6)    = "Conceptos de \<Abono"

m_op2(1)    = "Documentos de \<Cargo"
m_op2(2)    = "Notas de \<Credito"
m_op2(3)    = "Notas de \<Debito"
m_op2(4)    = "Asi\<gnaciones"
m_op2(5)    = "Co\<nsultas"
m_op2(6)    = "Car\<Tas"

m_op3(1)    = "\<Saldos Por Cliente"
m_op3(2)    = "\<Documentos Pend. x Cliente"
m_op3(3)    = "Si\<Tuaci¢n de Documentos"
m_op3(4)    = "\<Antiguedad de Documentos"
m_op3(5)    = "A\<N lisis de Movimientos x Cliente"
m_op3(6)    = "An lisis de \<Movimiento x Documento"
m_op3(7)    = "Impresion de \<Letras formato continuo"
m_op3(8)    = "\<Consolidado C.C. de Clientes"
m_op3(9)    = "\<Informaci¢n de Cr‚dito del Cliente"
m_op3(10)   = "Intereses por Canje - Proformas"
m_op3(11)   = "Proformas pendientes de generar canje"
m_op3(12)   = "Canjes pendientes de aprobaci¢n"

*m_op3(6)    = "documentos Pend. x C\<Obrador"
*m_op3(7)    = "doc. Pend. x \<Cliente (Moneda)"
*m_op3(8)    = "doc. Pend. x Co\<Brador (Moneda)"
*m_op3(6)    = "\<Relaci¢n General de Cobranzas"
*m_op3(7)   = "\<Posici¢n consolidada de deuda"
*m_op3(8)   = "\<Sit. de Documentos Consolidado"


m_op4(1)    = "\<Mantenimiento de Archivos"
m_op4(2)    = "\<Regeneraci¢n de Saldos"
m_op4(3)    = "\<Cierre del Periodo"
m_op4(4)    = "\<Usuarios del Sistema"
m_op4(5)    = "Utilitarios de \<Impresi¢n"
m_op4(6)    = "--------------------------"

m_op5(1)    = "\<Notas Bancarias"

m_op6(01)   = "\<1.- Canje por Letras"
m_op6(02)   = "\<2.- Aprobaci¢n del Canje por Letras"
m_op6(03)   = "\-"
m_op6(04)   = "\<3.- Letras al banco por entrar a cobranza"
m_op6(05)   = "\<4.- Aprobaci¢n de letra al banco en cobranza"
m_op6(06)   = "\<5.- Letras al banco en garant¡a"
m_op6(07)   = "\<6.- Letras al banco por descontar"
m_op6(08)   = "\<7.- Aprobaci¢n de descuento de letras"
m_op6(09)   = "\-"
m_op6(10)   = "\<8.- Renovaci¢n de letras"
m_op6(11)   = "\<9.- Protesto de letras"
m_op6(12)   = "\<A.- Proformas"
m_op6(13)   = "\<B.- Canje por letras (Base Proforma)"
m_op6(14)   = "\<C.- Refinanciaci¢n"
m_op6(15)   = "\<D.- Canje por letras (Base Refinanciaci¢n)"

*m_op6(1)    = "Notas de Abono"
*m_op6(2)    = "Notas de Cargo"
*m_op6(3)    = "Canje por Letras"
*m_op6(4)    = "Asignacion de N/A y ADEL"



TsPathCia = "cia"+GsCodCia
TsPathDbf  = PathOrg+";"+PathDef+"\"+TsPathCia+";"+PathDef+"\"+TsPathCia+"\C"+LTRIM(STR(YEAR(DATE())))
SET PATH TO (TsPathDbf)





Row = 1
Col = 1
DO WHILE .T.
   SET PROCEDURE TO
   CLEAR
   @  6,18 SAY "                                          " COLOR SCHEME 7
   @  7,18 SAY "                                          " COLOR SCHEME 7
   @  8,18 SAY "                                          " COLOR SCHEME 7
   @  9,18 SAY "                                          " COLOR SCHEME 7
   @ 10,18 SAY "                                          " COLOR SCHEME 7
   @ 11,18 SAY "                                          " COLOR SCHEME 7
   @ 12,18 SAY "                                          " COLOR SCHEME 7
   @ 13,18 SAY "                                          " COLOR SCHEME 7
   @ 14,21 SAY "                                      "  PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 15,21 SAY "                                      "  PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 16,17 SAY LEFT("Compa¤ia "+GsCodCia+" "+GsNomCia+SPACE(46),46)  PICTURE "@I" COLOR SCHEME 11
  *@ 17,21 SAY LEFT("Usuario  "+GsUsuario+SPACE(38),38)  PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
  *@ 18,21 SAY LEFT("Terminal "+GsTerminal+SPACE(38),38) PICTURE "@I" SIZE 1,38 COLOR SCHEME 11
   @ 21,0 TO 21,79
   @ 23,0 TO 23,79

   GsMsgKey = "[Teclas del Cursor] Escoge opci¢n    [Enter] Selecciona    [Esc] Cancela"
   DO LIB_MTEC WITH 99
   SET MESSAGE TO 22
   MENU BAR m_op0,6
   MENU  1,m_op1,6
   MENU  2,m_op2,6
   MENU  3,m_op3,12
   MENU  4,m_op4,6
   MENU  5,m_op5,1
   MENU  6,m_op6,15
   READ MENU BAR TO Row, Col
   DO CASE
      CASE row = 0
         RETURN
      CASE row = 1
         DO CASE
            CASE col = 1
               DO admmclie
            CASE col = 2
              *DO admminst
              *DO ccbbanco
               DO cjamctas
            CASE col = 3
               _MES = MONTH(DATE())
               _ANO = YEAR(DATE())
               DO cbdmtabl WITH '04'
            CASE col = 4
               DO ccbtbdoc
            CASE col = 5
               DO ccbtconc WITH 'NC'
            CASE col = 6
               DO ccbtconc WITH 'NA'
         ENDCASE
      CASE row = 2
         DO CASE
            CASE col = 1
               DO CCBCARGO
            CASE col = 2
              *DO CCBABON1
               DO ccbnabo1
            CASE col = 3
              *DO ccbncarg
               DO ccbncar1
            CASE col = 4
               DO CCBASIGN
            CASE col = 5
               DO CCBCONST
            CASE col = 6
               DO CCBCARTA
         ENDCASE
      CASE ROW= 3
         DO CASE
            CASE COL=1
                DO ccbr4100
            CASE COL=2
                DO ccbr4200
            CASE COL=3
                DO ccbr4300
            CASE COL=4
                DO ccbr4400
            CASE COL=5
                DO ccbr4500
            CASE COL=6
                DO ccbr4600
            CASE COL=7
                DO ccbr4700
            CASE COL=8
                DO ccbr4800
            CASE COL=9
                DO ccbr4900
            CASE COL=10
                DO ccbr4int
            CASE COL=11
                DO ccbr4ppc
            CASE COL=12
                DO ccbr4cpa
           *CASE COL=6
           *    DO ccbr4210
           *CASE COL=7
           *    DO ccbr4201
           *CASE COL=8
           *    DO ccbr4211
           *CASE col=6
           *    DO ccbr4212
           *CASE col=7
           *    DO ccbr4213
           *CASE col=8
           *    DO ccbr4301
         ENDCASE
      CASE row = 4
         DO CASE
            CASE COL=1
                DO INDEXA WITH "CCBMARCH","CCBMINDI"
            CASE COL=2
                DO ccbregen
            CASE COL=3
                DO ccbp5300
            CASE col = 4
               DO ADMGUSER
            CASE COL=5
                DO ADMUTPRN
            CASE COL=6
            if INLIST(GsUSuario,"MASTER","MIGUEL")
                suspen
            endif    
         ENDCASE
      CASE row = 5
         DO CASE
            CASE col = 1
               DO ccbnban2
         ENDCASE
        *DO CASE
        *   CASE col = 1
        *      DO ADMUTPRN
        *   CASE col = 2
        *      DO ADMFORMT
        *   CASE col = 3
        *      DO ADMCOPIA WITH "CCBLISTA"
        *   CASE col = 4
        *      DO ADMRESTA WITH "CCBLISTA"
        *   CASE col = 5
        *      DO CCBCONFG
        *   CASE col = 6
        *      DO ADMGUSER
        *ENDCASE
      CASE row = 6
         DO CASE
            CASE col = 1
              *DO CCBCJLTR
               DO CCBCJLT1
            CASE col = 2
              *DO CCBCJAPR
               DO CCBCJAP1
            CASE col = 3
            CASE col = 4
               DO ccbltrb2 WITH 'c'
            CASE col = 5
               DO ccbltrb2 WITH 'C'
            CASE col = 6
               DO ccbltrbc WITH 'G'
            CASE col = 7
               DO ccbltrb2 WITH 'd'    && Actualiza contabilidad
            CASE col = 8
               DO ccbltrb2 WITH 'D'    && Actualiza contabilidad
            CASE col = 9
            CASE col = 10
              *DO ccbrnltr
               DO ccbltrrn
            CASE col = 11
               DO ccbltrpr
            CASE col = 12
               DO Ccbprof1
            CASE col = 13
              *DO ccbcjaut
               DO ccbcjau1
            CASE col = 14
               DO ccbrefin
            CASE col = 15
               DO ccbcjref
         ENDCASE
        *DO CASE
        *   CASE col = 1
        *      DO ccbp6100
        *   CASE col = 2
        *      DO ccbp6200
        *   CASE col = 3
        *      DO ccbp6300
        *   CASE col = 4
        *      DO ccbp6400
        *ENDCASE
   ENDCASE
ENDDO
RETURN



*  @  6,18 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
*  @  7,18 SAY "³  ÛÛÛÛÛ T A.               ÛÛ     ÜÛÛß   ³" COLOR SCHEME 7
*  @  8,18 SAY "³  ÛÛ           P O R       ÛÛ   ÜÛÛß     ³" COLOR SCHEME 7
*  @  9,18 SAY "³  ÛÛÛÛÛ ÛÛÛÛÛ              ÛÛ ÜÛÛß       ³" COLOR SCHEME 7
*  @ 10,18 SAY "³        ÛÛ                 ÛÛÛÛß    4.0  ³" COLOR SCHEME 7
*  @ 11,18 SAY "³        ÛÛÛÛÛ O B R A R    ÛÛß   ß       ³" COLOR SCHEME 7
*  @ 12,18 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 7

