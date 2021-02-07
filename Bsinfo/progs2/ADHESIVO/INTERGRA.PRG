**************************************************************************
*INTERFACE GRAFICA CON FOXGRAPH                                          *
*Requisitos:                                                             *
*- Instalar el foxgraph en el mismo directorio, en el que se ha instalado*
*  el foxpro, foxr, o ejecutable de la aplicaci¢n.                       *
*- Crear una base de datos temporal.                                     *
*  Su primer campo debera ser un campo alfab‚tico y los siguientes       *
*  numericos.                                                            *
*  Se recomienda que el numero m ximo de campos no sea mayor de 15       *
*  El n£mero m ximo de registros ser  de 245                             *
*- Inicializar las siguientes variables:                                 *
*     _Titulo:       Titulo principal del grafico                        *
*     _Subtitulo:    Subtitulo del gr fico                               *
*     _Tipografico :                                                     *
*           *HBARS2D  3GR  *LINES2D  3GR  *MULTIPIE 3GR  *PIECHART 3GR   *
*      	    *PYRAMIDS 3GR  *RIBBON3D 3GR  *SPCTRL2D 3GR  *VBARS2D  3GR   *
*           *ZROFLOAT 3GR  *STDBAR3D 3GR  *SPCTRL3D 3GR  *STAKAREA 3GR   *
*           *STAKBARS 3GR                                                *
*      DECLARE _Vtit(N):                                                 *
*          Arreglo con los titulos de los campos numericos,              *
*          N = n£mero de campos num‚ricos                                *
*            = n£mero total de campos - 1                                *
**************************************************************************

****Ejemplo de llamada a interface gr fica con foxgraph
***con la base de datos grafico.dbf
***Estructura
***Nombre      Tipo       Ancho    Dec    Indice
***CODIGO      Car cter      15           Asc
***SERIE01     Num‚rico      10
***SERIE02     Num‚rico      10
set talk off
set echo off
sele 1
use grafico order codigo   && grafico: base de datos creada
                           && tambi‚n:    use grafico

_Titulo      = "TITULO"
_Subtitulo   = "SUBTITULO"
_TipoGrafico = "HBARS2D.3GR"
_TitFila     = "FILA"           && Titulo campo alfabetico
_TitColumna  = "COLUMNA"
DIMENSION _Vtit(2)
_Vtit[1] = "VALMIESA"
_Vtit[2] = "SOFTWARE"

DO  Interface_Grafica

***************************
PROCEDURE INTERFACE_GRAFICA
***************************
count to _nrec
if (_nrec + 10 > 255)
  wait wind "Solamente se pueden graficar 245 valores por campo" timeout 1
  retu
endif
_Tipografico = sys(2004)+"3DLOOKS\"+_TipoGrafico
store 0 TO m->macstat
store space(50) to m->macro

STORE sys(5)+'\'+sys(3)+".DAT" TO graphfile
page = 1
set console off
set alternate to &graphfile
set alternate on
?? '"%%Upper_Top_Left: 11, 2, 1%%"'
? '"%%Title: 8, 1%%"'
? '"%%Subtitle: 8, 2%%"'
? '"%%Row_Title: 9, 1%%"'
? '"%%Column_Title: 9, 2%%"'
? '"%%Row_Headers: 11, 1%%"'
? '"%%Column_Headers: 10, 2%%"'
? '"'+TRIM(_Titulo)+'" '+'"'+TRIM(_Subtitulo)+'"'
? '"'+TRIM(_Titfila)+'" '+'"'+TRIM(_Titcolumna)+'"'
lines = 9
counter = alen(_Vtit)
COMMAND = ","
for i = 1 to counter
   COMMAND = m->command + [ "] + TRIM(_Vtit[i]) + ["]
next
? m->command
Lines = m->lines + 1

go top
DO WHILE .NOT. EOF()
   _nc1 = field(1)
   command = ["] + TRIM(&_nc1) + ["]
   for i=2 to counter + 1
         thevalue = field(i)
         command = m->command + "," + STR(&thevalue,14,2)
   next
   ? m->command
   Lines = m->lines + 1
   skip
ENDDO
? '"%%Lower_Bottom_Right: '+STR(m->lines);
    +','+STR(m->counter+1)+','+STR(m->page)+'%%"'
CLOSE ALTERNATE
SET CONSOLE ON
command = 'foxgraph '
if len(trim(_Tipografico)) <> 0
   command = m->command + ' ' + trim(_Tipografico)
endif
if m->macstat <> 0
   command = m->command + iff(m->macstat=1,' /r:',' /w:')+trim(m->macro)
endif
command = m->command + ' /q /d:' + graphfile
    dr     = sys(5)
    unidad = "j:"
    a      = GETENV("AUTOLOGIN")
    DO CASE
       CASE a = "PIER"
          ruta   = "cd foxg1"
       CASE a = "BERNARDO"
          ruta   = "cd foxg2"
       CASE a = "JUAN"
          ruta   = "cd foxg3"
       CASE a = "RINALDO"
          ruta   = "cd foxg4"
       CASE a = "CLAUDIO"
          ruta   = "cd foxg5"
       OTHER
          unidad = left(sys(2004),2)
          ruta   = "cd "+ subs(sys(2004),3,len(sys(2004))-2)
    ENDCASE
    run &unidad
    run &ruta
    &command
    delete file  &graphfile
    run cd ..
    run &dr
retu
