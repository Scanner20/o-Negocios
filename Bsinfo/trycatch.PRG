TRY
   ? "try"
   * [some code here...]
   if .f.
      * we've decided that we don't want
      * to proceed any further.
      throw 999
   ENDIF
   USE h:\clientes\quimica\cia006\almmmatg ALIAS rrrr
   * [...more code here]
CATCH TO oEx WHEN oEx.UserValue=999
   ? "caught our own exception 999"
CATCH TO oEx
   ? "catch statement for everything else"
   ? oex.message
FINALLY
   ? "finally"
ENDTRY

