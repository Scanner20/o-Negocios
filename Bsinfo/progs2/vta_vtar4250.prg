m.TipoView = 1
m.CodMon = 2

DO FORM funvta_vtar4250

RETURN 
*****************
FUNCTION _dMotivo
*****************
PARAMETER cMotivo
DO CASE
   CASE cMotivo = 9
      RETURN [TODOS LOS MOTIVOS]
   CASE cMotivo = 1
      RETURN [VENTAS           ]
   CASE cMotivo = 2
      RETURN [COMPRA   ]
   CASE cMotivo = 3
      RETURN [TRANSFORMACIÓN ]
   CASE cMotivo = 4
      RETURN [CONSIGNACIÓN     ]
   CASE cMotivo = 5
      RETURN [DEVOLUCIÓN     ]
   CASE cMotivo = 6
      RETURN [TRASL. ENTRE ESTABLEC. DE UNA MISMA EMPRESA]
   CASE cMotivo = 7
      RETURN [TRASL. POR EMISOR ITINERANTE DE COMPROB. DE PAGO]
   CASE cMotivo = 8
      RETURN [OTROS     ]
ENDCASE
RETURN ''
****************
FUNCTION _Motivo
****************
PARAMETER cMotivo
DO CASE
   CASE cMotivo = 1
      RETURN [VENTAS           ]
   CASE cMotivo = 2
      RETURN [COMPRA   ]
   CASE cMotivo = 3
      RETURN [TRANSFORMACIÓN ]
   CASE cMotivo = 4
      RETURN [CONSIGNACIÓN     ]
   CASE cMotivo = 5
      RETURN [DEVOLUCIÓN     ]
   CASE cMotivo = 6
      RETURN [TRASL. ENTRE ESTABLEC. DE UNA MISMA EMPRESA]
   CASE cMotivo = 7
      RETURN [TRASL. POR EMISOR ITINERANTE DE COMPROB. DE PAGO]
   CASE cMotivo = 8
      RETURN [OTROS     ]
ENDCASE
RETURN ''
****************
FUNCTION _Status
****************
PARAMETER cStatus
DO CASE
   CASE cStatus = 1
      RETURN [Todos]
   CASE cStatus = 2
      RETURN [Pendientes       ]
   CASE cStatus = 3
      RETURN [Facturados       ]
   CASE cStatus = 4
      RETURN [Anulados         ]
ENDCASE

RETURN 0
