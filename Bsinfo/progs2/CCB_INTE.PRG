******************
FUNCTION  Ccb_Inte
******************
PARAMETER _ImpTot,_Dias,_PorInt,_TipInt,_TipTas
IF TYPE("RFIntDoc")="U"
   RfIntDoc = 0
ENDIF
IF TYPE("RFImpTot")="U"
   RfImpTot = 0
ENDIF
PRIVATE j,i,P,n,m,V
P = _ImpTot
n = _Dias
i = _PorInt
DO CASE
   CASE _TipInt = [M]     && Mensual
      m = 30
   CASE _TipInt = [A]     && Anual
      m = 360
   CASE _TipInt = [D]     && Diario
      m = 1
ENDCASE

XX = ( ( 1 + i/100 )^(n/m) - 1 )
IF _TipTas = 1
    V = P * XX            && vencida
ELSE
    V = P * XX/(1-XX)     && adelantada
ENDIF
V = ROUND(V,3)
RfIntDoc = RfIntDoc + V
RfImpTot = RfImpTot + _ImpTot
RETURN V
