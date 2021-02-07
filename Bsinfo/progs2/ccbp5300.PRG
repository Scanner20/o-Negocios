**************************************************************************
*  Nombre    : CCBP5300.PRG                                              *
*  Autor     : Luis Cruz T.                                              *
*  Objeto    : Cierre del Periodo                                        *
*  Creeado   : 24/05/93                                                  *
**************************************************************************
CLEAR
CLOSE DATA
DO BCOPanta
DO BCOTomar
CLOSE DATA
RETURN
**

PROCEDURE BCOPanta
******************
CLEAR
@ 1,1 TO 23,76 PANEL
@ 1,30 SAY "PROCESO DE CIERRE"
TEXT
       Este proceso permite borrar los movimientos efectuados hasta  la
       fecha solicitada por el usuario que ejecuta la presente  opci¢n.
       De esta manera existir  una mejor performance de  respuesta  del
       sistema al haber menos informaci¢n y se optimizar  el espacio en
       disco.

       NOTA :
           - Antes de realizar este proceso asegurese  de  tener  una
             copia de respaldo en diskette.

           - Despues de ejecutar la  opci¢n  el  n£mero  de  registro
             tomara un nuevo correlativo que corresponda al  registro
             siguiente.

           - Es recomendable que la fecha de  cierre  sea  dos  meses
             antes a la fecha actual, esto debido a que es importante
             que se tenga una mimim  informaci¢n historica para poder
             analizar.
ENDTEXT
@ 1,1 TO 23,1 PANEL
RETURN

PROCEDURE BCOTomar
******************
m.resp = 1  && No
@ 21,20 SAY "Continuamos  ?" GET m.resp PICT "@*H No;Si"
READ
IF m.resp = 1 .or. LASTKEY() = 27
   RETURN
ENDIF
m.FchCie = DATE()-60
@ 21,20 SAY "Fecha de Cierre :" GET m.fchCie PICT "@E"
READ
IF LASTKEY() = 27
   RETURN
ENDIF
select 1
USE CCBRGDOC  ALIAS GDOC EXCL
IF ! USED(1)
   RETURN
ENDIF
SET ORDER TO GDOC01
select 2
USE CCBMVTOS ALIAS VTOS EXCL
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SET ORDER TO VTOS01

WAIT "Espere un momento por favor ..." NOWAIT WINDOW
SELECT GDOC
SCAN FOR FCHDOC <= m.FchCie .AND.  FLGEST="C"
   WAIT CodDoc+" "+NroDoc WINDOW NOWAIT
   XsTpodoc=Tpodoc
   XsCodcli=Codcli
   LLAVE= CODDOC+NRODOC
   DELETE
   SELECT VTOS
   IF Xstpodoc = "CARGO"
      set order to vtos05
      SEEK Xscodcli+"CARGO"+LLAVE
      DO WHILE (!EOF() .AND. Xscodcli+"CARGO"+LLAVE = VTOS->CODCLI+VTOS->TPOREF+VTOS->CODREF+VTOS->NROREF )
         DELETE
         SKIP +1
      ENDDO
   ELSE
      set order to vtos01
      SEEK LLAVE
      DO WHILE (!EOF() )
         IF ( "A"+LLAVE = VTOS->TPODOC+VTOS->CODDOC+VTOS->NRODOC )
            DELETE
         ENDIF
         SKIP +1
      ENDDO
   ENDIF
   SELECT GDOC
ENDSCAN
SELECT GDOC
PACK
SELECT VTOS
PACK
************* COMPLETAR *****
WAIT "Proceso completado ..." NOWAIT WINDOW
CLOSE DATA
RETURN
