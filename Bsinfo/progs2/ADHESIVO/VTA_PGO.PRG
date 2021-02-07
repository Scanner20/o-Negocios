PARAMETER _FmaPgo
DO CASE
   CASE _FmaPgo = 1
      RETURN ('Contado     ')
   CASE _FmaPgo = 2
      RETURN ('Credito     ')
   CASE _FmaPgo = 3
      RETURN ('Consignacion')
ENDCASE
RETURN ('            ')
