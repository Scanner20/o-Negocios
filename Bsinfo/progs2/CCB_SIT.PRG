** Funcion que retorna la descripcion de la situacion
** del documento de cargo

PARAMETER _FlgSit
DO CASE
   CASE _flgsit = 'P'
      RETURN 'Protestada'
   CASE _flgsit = 'A'
      RETURN 'Aceptada  '
   CASE _flgsit = 'a'
      RETURN 'Por Acept.'
   CASE _flgsit = 'D'
      RETURN 'Descontada'
   CASE _flgsit = 'd'
      RETURN 'Por Descon'
   CASE _flgsit = 'C'
      RETURN 'En Cobranz'
   CASE _flgsit = 'c'
      RETURN 'Por Cobrar'
   CASE _flgsit = 'R'
      RETURN 'Renovada  '
   CASE _flgsit = 'G'
      RETURN 'Garantia  '
   CASE _flgsit = 'X'
      RETURN 'Canje     '
   OTHER
      RETURN '          '
ENDCASE
