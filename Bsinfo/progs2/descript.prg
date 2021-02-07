**********************************************************************
*      Procedure: Descriptar                                         *
*                 Parametro1    Variable a Descriptar                *
*                 Parametro2    Variable Numerica de encriptado      *
*!********************************************************************
PARAMETER Parametro1, Parametro2
PRIVATE Len,Retorno,XChar,X,Rotado,Dato,Enc1
set talk off
set echo off
Dato = Parametro1
Enc1 = Parametro2
Len=Len(Dato)
Retorno=[]
X=1
DO WHILE Len>0
	Xchar=ASC(SUBSTR(Dato,Len,1))
	IF Xchar>127
		Xchar=Xchar-127
	ELSE
		Xchar=Xchar+127
	ENDIF
	Xchar=Xchar+32-X
	IF Xchar<0
		Xchar=0
	ENDIF
	Retorno=Retorno+CHR(Xchar)
	Len=Len-1
	X=X+1
ENDDO
Rotado=[]
Len=LEN(Dato)
X=Len-MOD(Enc1,Len)+1
DO WHILE LEN(Rotado)<Len
	IF X>Len
		X=1
	ENDIF
	Xchar=Substr(Retorno,X,1)
	Rotado=Rotado+Xchar
	X=X+1
ENDDO
RETURN Rotado
