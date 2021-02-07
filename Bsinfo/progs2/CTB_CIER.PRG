** FUNCION   : ctb_cier
** Objeto    : cierre de bases de datos contables
IF USED("VMOV")
	SELE VMOV
	USE
ENDIF
*
IF USED("RMOV")
	SELE RMOV
	USE
ENDIF
*
IF USED("OPER")
	SELE OPER
	USE
ENDIF
*
IF USED("ACCT")
	SELE ACCT
	USE
ENDIF
