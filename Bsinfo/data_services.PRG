***********************************************************************
** AUTOR :  Victor E. Torres T.
** 
** Programa que genera rutinas de carga de variables de memoria y grabacion de campos en la tabla 
** pasada como parametro
** MODO DE USO :
** do data_services WITH 'CRMCPROSPE','CPROS1','CPROS'
** -------------------------------------------------------------------------------------**

PARAMETERS PcTabla,PcCursor,PcAlias
#include CONST.H
IF Vartype(PcTabla)<>'C'
	PcTabla = ''
ENDIF
IF Vartype(PcCursor)<>'C'
	PcCursor = ''
ENDIF
IF Vartype(PcAlias)<>'C'
	PcAlias = ''
ENDIF
ASSERT !EMPTY(PcTabla) MESSAGE 'No ha indicado el nombre de la Tabla o Entidad de la base de datos'
ASSERT !EMPTY(PcCursor) MESSAGE 'No ha indicado el nombre del cursor a asignar a la Tabla o Entidad de la base de datos'
ASSERT !EMPTY(PcAlias) MESSAGE 'No ha indicado el nombre del Alias a asignar a la Tabla o Entidad de la base de datos'

LsFile=SYS(5)+'\aplvfp\bsinfo\progs\'+UPPER(PcTabla)+'_DS.prg'
IF FILE(LsFile)
	DELETE FILE  (LsFile)
ENDIF
=Prg_VarMem_Publicas( PcCursor,PcAlias,PcTabla,LsFile)
=Prg_VarMem_Campos( PcCursor,PcAlias,PcTabla,LsFile)
=Prg_VarMem_Limpiar(  PcCursor,PcAlias,PcTabla,LsFile)
=Prg_VarMem_Sql_Upd(PcCursor,PcAlias,PcTabla,LsFile)
*!*	DO CASE 
*!*		CASE UPPER(PcTabla)='CRMCSEGUI'
*!*			
*!*			=Prg_VarMem_Publicas( 'CSEGUI1','CSEG','CRMCSEGUI','d:\aplvfp\bsinfo\progs\CRMCSEGUI_DS.prg')
*!*			=Prg_VarMem_Campos( 'CSEGUI1','CSEG','CRMCSEGUI','d:\aplvfp\bsinfo\progs\CRMCSEGUI_DS.prg')
*!*			=Prg_VarMem_Limpiar(  'CSEGUI1','CSEG','CRMCSEGUI','d:\aplvfp\bsinfo\progs\CRMCSEGUI_DS.prg')
*!*			=Prg_VarMem_Sql_Upd('CSEGUI1','CSEG','CRMCSEGUI','d:\aplvfp\bsinfo\progs\CRMCSEGUI_DS.prg')
*!*		CASE UPPER(PcTabla)='CRMDSEGUI'
*!*			=Prg_VarMem_Publicas( 'CDSEG1','DSEG','CRMDSEGUI','d:\aplvfp\bsinfo\progs\CRMDSEGUI_DS.prg')
*!*			=Prg_VarMem_Campos( 'CDSEG1','DSEG','CRMDSEGUI','d:\aplvfp\bsinfo\progs\CRMDSEGUI_DS.prg')
*!*			=Prg_VarMem_Limpiar(  'CDSEG1','DSEG','CRMDSEGUI','d:\aplvfp\bsinfo\progs\CRMDSEGUI_DS.prg')
*!*			=Prg_VarMem_Sql_Upd('CDSEG1','DSEG','CRMDSEGUI','d:\aplvfp\bsinfo\progs\CRMDSEGUI_DS.prg')
*!*		CASE UPPER(PcTabla)='CRMCPROSPE'
*!*			=Prg_VarMem_Publicas( 'CPROS1','CPROS','CRMCPROSPE','d:\aplvfp\bsinfo\progs\CRMCPROSPE_DS.prg')
*!*			=Prg_VarMem_Campos( 'CPROS1','CPROS','CRMCPROSPE','d:\aplvfp\bsinfo\progs\CRMCPROSPE_DS.prg')
*!*			=Prg_VarMem_Limpiar(  'CPROS1','CPROS','CRMCPROSPE','d:\aplvfp\bsinfo\progs\CRMCPROSPE_DS.prg')
*!*			=Prg_VarMem_Sql_Upd('CPROS1','CPROS','CRMCPROSPE','d:\aplvfp\bsinfo\progs\CRMCPROSPE_DS.prg')
*!*	ENDCASE

*!*	IF USED('CSEGUI1')
*!*		USE IN CSEGUI1
*!*	ENDIF
*!*	IF USED('CSEG')
*!*		USE IN CSEG
*!*	ENDIF	
*!*	IF USED('CRMCSEGUI')
*!*		USE IN CRMCSEGUI
*!*	ENDIF
*!*	IF USED('CDSEG1')
*!*		USE IN CDSEG1
*!*	ENDIF
*!*	IF USED('DSEG')
*!*		USE IN DSEG
*!*	ENDIF	
*!*	IF USED('CRMDSEGUI')
*!*		USE IN CRMDSEGUI
*!*	ENDIF

*!*	IF USED('CPROS1')
*!*		USE IN CPROS1
*!*	ENDIF
*!*	IF USED('CPROS')
*!*		USE IN CPROS
*!*	ENDIF	
*!*	IF USED('CRMCPROSPE')
*!*		USE IN CRMCPROSPE
*!*	ENDIF

IF USED(PcAlias)
	USE IN (PcAlias)
ENDIF
IF USED(PcCursor)
	USE IN (PcCursor)
ENDIF
IF USED(PcTabla)
	USE IN (PcTabla)
ENDIF


RETURN
************************
FUNCTION Prg_VarMem_Publicas
************************
PARAMETERS PsCursor,PsAlias,PsTabla,PsRutaNom_Prg
IF !USED(PsAlias)
	GoEntorno.open_dbf1 ('ABRIR',PsTabla,PsAlias,'','')
ENDIF
STRTOFILE('**********************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('FUNCTION Public_VarMen'+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('**********************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***  Declaramos variables de memoria publicas   '+TTOC(DATETIME())+'  ***'+ CRLF+ CRLF,PsRutaNom_Prg,.t.)
SELECT (PsAlias)
FOR k=1 TO Fcount()
	LsVarMem='Public m.'+FIELD(k)+ CRLF
	STRTOFILE(LsVarMem,PsRutaNom_Prg,.t.)
ENDFOR


************************
FUNCTION Prg_VarMem_Campos
************************
PARAMETERS PsCursor,PsAlias,PsTabla,PsRutaNom_Prg
IF !USED(PsAlias)
	GoEntorno.open_dbf1 ('ABRIR',PsTabla,PsAlias,'','')
ENDIF
STRTOFILE('*********************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('FUNCTION Carga_VarMen'+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('*********************'+CRLF,PsRutaNom_Prg,.t.)

STRTOFILE('***  Variables de Memoria '+TTOC(DATETIME())+'  ***'+ CRLF+ CRLF,PsRutaNom_Prg,.t.)
SELECT (PsAlias)
FOR k=1 TO Fcount()
	LsVarMem='m.'+FIELD(k)+SPACE(20-LEN(FIELD(k)) )+ '  =  ' + PsCursor+'.'+FIELD(k)+ CRLF
	STRTOFILE(LsVarMem,PsRutaNom_Prg,.t.)
ENDFOR

************************
FUNCTION Prg_VarMem_Limpiar
************************
PARAMETERS PsCursor,PsAlias,PsTabla,PsRutaNom_Prg
IF !USED(PsAlias)
	GoEntorno.open_dbf1 ('ABRIR',PsTabla,PsAlias,'','')
ENDIF
STRTOFILE('*********************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('FUNCTION Release_VarMem'+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('*********************'+CRLF,PsRutaNom_Prg,.t.)

STRTOFILE('***  Variables de Memoria '+TTOC(DATETIME())+'  ***'+ CRLF+ CRLF,PsRutaNom_Prg,.t.)
SELECT (PsAlias)
FOR k=1 TO Fcount()
	LsVarMem='RELEASE m.'+FIELD(k)+ CRLF
	STRTOFILE(LsVarMem,PsRutaNom_Prg,.t.)
ENDFOR

*************************
FUNCTION Prg_VarMem_SQL_UPD
*************************
PARAMETERS PsCursor,PsAlias,PsTabla,PsRutaNom_Prg
IF !USED(PsAlias)
	GoEntorno.open_dbf1 ('ABRIR',PsTabla,PsAlias,'','')
ENDIF
STRTOFILE('***************************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('FUNCTION Sql_VarMem_Upd_Tabla'+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***************************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***  Generamos Sql Update en base a campos en variables de memoria '+TTOC(DATETIME())+'  ***'+ CRLF+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('UPDATE '+ PsTabla+' SET ;'+CRLF,PsRutaNom_Prg,.t.)
SELECT (PsAlias)
FOR k=1 TO Fcount()
	DO CASE 
		CASE K=FCOUNT() - 1
			LsFinStr =' ; '
			LsVarMem=FIELD(k)+ ' = m.'+FIELD(k)+LsFinStr+ CRLF
		CASE K=FCOUNT()
			LsFinStr = '  '
			LsVarMem=" WHERE  "+FIELD(k)+ ' = m.'+FIELD(k)+LsFinStr+ CRLF
		OTHERWISE 	
			LsFinStr = ', ; '
			LsVarMem=FIELD(k)+ ' = m.'+FIELD(k)+LsFinStr+ CRLF
	ENDCASE 
	STRTOFILE(LsVarMem,PsRutaNom_Prg,.t.)
ENDFOR
STRTOFILE('*** Fin :  Sql_VarMem_Upd_Tabla ***'+ CRLF,PsRutaNom_Prg,.t.)

STRTOFILE('***************************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('FUNCTION Sql_VarMem_Upd_Alias'+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***************************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***  Generamos Sql Update en base a campos en variables de memoria '+TTOC(DATETIME())+'  ***'+ CRLF+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('UPDATE '+ PsAlias+' SET ;'+CRLF,PsRutaNom_Prg,.t.)
SELECT (PsAlias)
FOR k=1 TO Fcount()
	DO CASE 
		CASE K=FCOUNT() - 1
			LsFinStr =' ; '
			LsVarMem=FIELD(k)+ ' = m.'+FIELD(k)+LsFinStr+ CRLF
		CASE K=FCOUNT()
			LsFinStr = '  '
			LsVarMem=" WHERE  "+FIELD(k)+ ' = m.'+FIELD(k)+LsFinStr+ CRLF
		OTHERWISE 	
			LsFinStr = ', ; '
			LsVarMem=FIELD(k)+ ' = m.'+FIELD(k)+LsFinStr+ CRLF
	ENDCASE 
	STRTOFILE(LsVarMem,PsRutaNom_Prg,.t.)
ENDFOR
STRTOFILE('*** Fin :  Sql_VarMem_Upd_Alias ***'+ CRLF,PsRutaNom_Prg,.t.)

STRTOFILE('***************************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('FUNCTION Sql_Query_Alias'+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***************************'+CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('***  Generamos Sql Query en base a campos de la tabla o cursor '+TTOC(DATETIME())+'  ***'+ CRLF+ CRLF,PsRutaNom_Prg,.t.)
STRTOFILE('SELECT  ;'+CRLF,PsRutaNom_Prg,.t.)
SELECT (PsAlias)
FOR k=1 TO Fcount()
	DO CASE 
		CASE K=FCOUNT() - 1
			LsFinStr =' ; '
			LsVarMem=FIELD(k)+LsFinStr+ CRLF
		CASE K=FCOUNT()
			LsFinStr = '  '
			LsVarMem= FIELD(k)+ ' FROM '+PsAlias+LsFinStr+ CRLF
		OTHERWISE 	
			LsFinStr = ', ; '
			LsVarMem=FIELD(k)+LsFinStr+ CRLF
	ENDCASE 
	STRTOFILE(LsVarMem,PsRutaNom_Prg,.t.)
ENDFOR
STRTOFILE('*** Fin :  Sql_VarMem_Upd_Alias ***'+ CRLF,PsRutaNom_Prg,.t.)