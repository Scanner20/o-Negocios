*!*********************************************************************
*      Procedure: Encriptar                                           *
*                 Parametro1    Variable a Encriptar                  *
*                 Parametro2    Variable Numerica de encriptado       *
*!*********************************************************************
PARAMETER Parametro1, Parametro2
PRIVATE Len,Retorno,XChar,X,Rotado,Dato,Enc1
set talk off
set echo off
Dato = Parametro1
Enc1 = Parametro2
Len=LEN(Dato)
Retorno=[]
Rotado =[]
X=MOD(Enc1,Len)+1
DO WHILE LEN(Rotado)<Len
	IF X>Len
		X=1
	ENDIF
	Xchar=SUBSTR(Dato,X,1)
	Rotado=Rotado+Xchar
	X=X+1
ENDDO
DO WHILE Len>0
	Xchar=ASC(SUBSTR(Rotado,Len,1))
	Xchar=Xchar-32+Len
	IF Xchar<0
		Xchar=0
	ENDIF
	IF Xchar>127
		Xchar=Xchar-127
	ELSE
		Xchar=Xchar+127
	ENDIF
	Retorno=Retorno+Chr(Xchar)
	Len=Len-1
ENDDO
RETURN Retorno
