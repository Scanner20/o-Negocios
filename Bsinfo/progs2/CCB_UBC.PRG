** Funcion que retorena la descripcion de la ubicacion
** del documento de cargo

PARAMETER _FlgUbc
DO CASE
   CASE _FlgUbc = [C]
      RETURN [En Cartera]
   CASE _FlgUbc = [B]
      RETURN [En Banco  ]
   OTHER
      RETURN [En Cartera]
ENDCASE
