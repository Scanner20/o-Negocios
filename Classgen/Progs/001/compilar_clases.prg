CLEAR ALL
CLOSE ALL
CLEAR PROGRAM
CLEAR MEMORY

WAIT WINDOW "Compilando Clases...." NOWAIT
*COMPILE CLASS H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases\ADMFORMS
COMPILE CLASS H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases\ADMVRS
COMPILE CLASS H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases\ADMGRAL
*COMPILE CLASS H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases\ADMNOVIS
COMPILE CLASS H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases\ADMTBAR

WAIT WINDOW "Compilando Formularios...." NOWAIT
*COMPILE FORM H:\TDV\ClasesGenerales\Programacion01\Programacion\Formularios\*.scx
WAIT CLEAR