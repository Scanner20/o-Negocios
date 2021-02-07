* Devuelve la descripcion de la forma de pago **
* Parametro : Flag de Estado
PARAMETER _FmaPgo
DO CASE
   CASE _FmaPgo = 1
      RETURN "Efectivo"
   CASE _FmaPgo = 2
      RETURN "Cheque  "
   CASE _FmaPgo = 3
      RETURN "Deposito"
   OTHER
      RETURN "        "
ENDCASE

