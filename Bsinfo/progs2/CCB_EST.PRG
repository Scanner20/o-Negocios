** Funcion que retorena la descripcion del Estado
** del documento de cargo

PARAMETER _FlgEst
DO CASE
   CASE _FlgEst = [P]
      RETURN [Pendiente]
   CASE _FlgEst = [A]
      RETURN [Anulado  ]
   CASE _FlgEst = [C]
      RETURN [Cancelado]
   CASE _FlgEst = [T]
      RETURN [Transito ]
   OTHER
      RETURN [         ]
ENDCASE
