
** Cosntantes Globales independientes de que modulo se este ejecutando
#include const.h 	
*!*	Las 2 lineas anteriores, apuntan hacia las clases generales

*!*	Activar las Librerias de clases generales
SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR, o-N,registry
CLOSE DATABASES ALL
SET PROCEDURE TO JANESOFT,FXGEN_2
SET LIBRARY TO VFPEncryption71.FLL
DO def_v_publicas
DO def_color
*!*	SET PROCEDURE TO ALMPLIBF ADDITIVE

