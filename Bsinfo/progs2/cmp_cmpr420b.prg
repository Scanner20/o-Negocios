**************************************************************************
*  Nombre        : cmpp420b.PRG
*  Sistema       : Logistica de Compras
*  Objeto        : Ordenes de Compra (Consulta/Reporte)
*  Creaci¢n      : 25/10/96
**************************************************************************

* abrimos areas a usar *
LoDatAdm.abrirtabla('ABRIR','cmpco_cg','vord','co_c01','')
*
LoDatAdm.abrirtabla('ABRIR','cmpdo_cg','rord','do_c01','')


* Variables de Orden *
XsNroOrd1=SPAC(LEN(VORD.NroOrd))
XsNroOrd2=SPAC(LEN(VORD.NroOrd))
XsCodAux1=SPAC(LEN(VORD.CodAux))
XsCodAux2=SPAC(LEN(VORD.CodAux))
*STORE {,,} TO XdFecha1,XdFecha2
STORE date() TO XdFecha1,XdFecha2
Xopcion  = 1
XsFlgEst = 1
XOrder   = ORDE()
* pantalla de datos *
CLEAR
GcTit4 = [CONSULTA DE ORDENES DE COMPRA]
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
@10,14 FILL TO 19,78 COLOR W/N
@ 9,13 TO 18,70 CLEA
@ 9,13 TO 18,70 DOUBLE
DO Lib_mtec with 4
*
UltTecla = 0
GiuTecla = 0
*!*	i = 1
*!*	@ 11,20 SAY "           N£meros : "
*!*	@ 12,20 SAY "            Fechas : "
*!*	@ 13,20 SAY "         Proveedor : "
*!*	@ 15,20 SAY "         Situaci¢n : "
*!*	@ 16,20 SAY "      Ordenado por : "
*!*	DO WHILE UltTecla <> Escape
*!*	   DO CASE
*!*	      CASE i = 1
*!*	         @ 11,42 GET XsNroOrd1 PICT "@!"
*!*	         @ 11,52 GET XsNroOrd2 PICT "@!"
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	      CASE i = 2
*!*	         @ 12,42 GET XdFecha1 PICT "@d"
*!*	         @ 12,54 GET XdFecha2 PICT "@d"
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	      CASE i = 3
*!*	         @ 13,42 GET XsCodAux1 PICT "@!"
*!*	         @ 13,52 GET XsCodAux2 PICT "@!"
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	      CASE i = 4
*!*	         Vecopc(1) = 'Pendientes ' &&  E
*!*	         Vecopc(2) = 'Atendido   ' &&  C
*!*	         Vecopc(3) = 'Anulados   ' &&  A
*!*	         Vecopc(4) = 'Todos      ' &&
*!*	         XsFlgEst= ELIGE(XsFlgEst, 15,42, 4)
*!*	         UltTecla = LASTKEY()
*!*	      CASE i = 5
*!*	         Vecopc(1) = 'Cronol¢gico'
*!*	         Vecopc(2) = 'Proveedor  '
*!*	         Xopcion = ELIGE(Xopcion, 16,42, 2)
*!*	         UltTecla = LASTKEY()
*!*	      CASE i = 6
*!*	         IF UltTecla = Enter
*!*	            EXIT
*!*	         ENDIF
*!*	   ENDCASE
*!*	   i = IIF(UltTecla = Arriba, i-1, i+1)
*!*	   i = IIF(i < 1, 1, i)
*!*	   i = IIF(i > 6, 6, i)
*!*	ENDDO
*!*	IF UltTecla <> Escape
   ** ARMAR LOS TEST DE IMPRESION **
DO FORM CMP_CMPR420B   
PROCEDURE Listar   
   XsNroOrd1= TRIM(XsNroOrd1)
   XsNroOrd2= TRIM(XsNroOrd2)
   XsCodAux1= TRIM(XsCodAux1)
   XsCodAux2= TRIM(XsCodAux2)
   SELE VORD
   IF EMPTY(XsNroOrd2)
      XsNroOrd2 = [ZZZZZZZZZZ]
   ENDI
   IF EMPTY(XsCodAux2)
      XsCodAux2 = [ZZZZZZZZZZ]
   ENDI
   * Condiciones de Filtro
   Xfiltro = []
   IF !EMPTY(XsNroOrd1) OR !EMPTY(XsNroOrd2)
      Xfiltro = [(NROORD>=XsNroOrd1.AND.NROORD<=XsNroOrd2)]
   ELSE
      Xfiltro = []
   ENDI
   IF !EMPTY(XdFecha1) OR !EMPTY(XdFecha2)
      Xfiltro = Xfiltro + [ AND (FCHORD>=XdFecha1.AND.FCHORD<=XdFecha2)]
   ENDI
   IF !EMPTY(XsCodAux1) OR !EMPTY(XsCodAux2)
      Xfiltro = Xfiltro + [ AND (CODAUX>=XsCodAux1.AND.CODAUX<=XsCodAux2)]
   ENDI
   DO CASE
      CASE XsFlgEst = 1
         Xfiltro = Xfiltro + [ AND (FlgEst='E'))]
      CASE XsFlgEst = 2
         Xfiltro = Xfiltro + [ AND (FlgEst='C'))]
      CASE XsFlgEst = 3
         Xfiltro = Xfiltro + [ AND (FlgEst='A'))]
   ENDC
   SET FILT TO &Xfiltro
   *
   DO CASE
      CASE Xopcion = 1
        *SET ORDE TO VORD01
         set orde to co_c01
      CASE Xopcion = 2
        *SET ORDE TO VORD01
         set orde to co_c05
         
      CASE Xopcion = 3
        *SET ORDE TO VORD06
         set orde to co_c06
   ENDC
   GO TOP
   IF EOF()
      DO lib_merr WITH 7   && fin de archivo
   ELSE
      Largo  = 66       && Largo de pagina
      IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
      sNomRep = "CMPR420B"
      DO f0print WITH "REPORTS"
   ENDIF
*!*	ENDIF
SELE VORD
SET FILT TO
RETURN
************************************************************************ FIN *
