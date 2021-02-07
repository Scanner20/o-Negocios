*  Nombre    : CbdAcumd.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Acumulador de Cuentas                                     *
*  Creación  : 1999/Enero/15                                             *
*  Par metros:   XsCodCta : Codigo de la Cuenta                          *
*                XnMesIni : Mes de inicio a acumulador                   *
*                XnMesFin : Mes de fin a acumular                        *
*                XsCodRef : Cod. de Referencia                           *
*    ******************* Moneda Nacional ********************            *
*               XvCalc( 1): Importe Debe C lculado del mes fin  ...      *
*               XvCalc( 2): Importe Haber C lculado del mes fin ...      *
*               XvCalc( 3): Importe Saldo C lculado del mes fin ...      *
*               XvCalc( 4): Importe Acumulado Debe C lculado    ...      *
*               XvCalc( 5): Importe Acumulado Haber C lculado   ...      *
*               XvCalc( 6): Saldo Acumulado C lculado   ..........       *
*    ******************* Moneda Extranjera ******************            *
*               XvCalc( 7): Importe Debe C lculado del mes fin           *
*               XvCalc( 8): Importe Haber C lculado del mes fin          *
*               XvCalc( 9): Importe Saldo C lculado del mes fin          *
*               XvCalc(10): Importe Acumulado Debe C lculado             *
*               XvCalc(11): Importe Acumulado Haber C lculado            *
*               XvCalc(12): Saldo Acumulado C lculado                    *
*                                                                        *
*                                                                        *
**************************************************************************
PARAMETERS XsCodCta , XnMesIni , XnMesFin , XsCodRef
PRIVATE TnMes,xLLave,xSelect
xSelect = SELECT()
IF XnMesIni < 0  .OR. XnMesFin < 0
   XnMesIni = ABS( XnMesIni )
   XnMesFin = ABS( XnMesFin )
ENDIF
SELECT ACCT
STORE 0 TO XvCalc
TnMes = XnMesIni
DO WHILE TnMes <= XnMesFin
   IF PARAMETER() < 4
      xLLave = STR(TnMes,2,0)+XsCodCta
   ELSE
      xLLave = STR(TnMes,2,0)+XsCodCta+XsCodRef
   ENDIF
   SEEK xLlave
   DO WHILE (NroMes+CodCta+CodRef = xLLave ) .AND. ! EOF()
      XvCalc( 4) = XvCalc( 4) + DbeNac  && Debe  Acumulado Moneda Nacional
      XvCalc( 5) = XvCalc( 5) + HbeNac  && Haber Acumulado Moneda Nacional
      XvCalc(10) = XvCalc(10) + DbeExt  && Debe  Acumulado Moneda Extranjera
      XvCalc(11) = XvCalc(11) + HbeExt  && Haber Acumulado Moneda Extranjera
      IF TnMes = XnMesFin
         XvCalc( 1) = XvCalc( 1) + DbeNac    && Debe  del Mes Moneda Nacional
         XvCalc( 2) = XvCalc( 2) + HbeNac    && Haber del Mes Moneda Nacional
         XvCalc( 7) = XvCalc( 7) + DbeExt    && Debe  del Mes Moneda Extranjera
         XvCalc( 8) = XvCalc( 8) + HbeExt    && Haber del Mes Moneda Extranjera
      ENDIF
      SKIP
   ENDDO
   TnMes = TnMes + 1
ENDDO
*** Saldos *************************
XvCalc( 3) = XvCalc( 1) - XvCalc( 2)  && Saldo del Mes Moneda Nacional
XvCalc( 6) = XvCalc( 4) - XvCalc( 5)  && Saldo Acumulado Moneda Nacional
XvCalc( 9) = XvCalc( 7) - XvCalc( 8)  && Saldo del Mes Moneda Extranjera
XvCalc(12) = XvCalc(10) - XvCalc(11)  && Saldo Acumulado Moneda Extranjera
SELECT (xSelect)
RETURN
