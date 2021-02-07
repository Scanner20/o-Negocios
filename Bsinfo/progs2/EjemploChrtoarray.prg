
** Well when you get the values separated by some character eg. , 
** you can create an array and then use this array to assign every of
** it's elements to any variable that you want.

cTextboxValues = 'Group1,Group2,Group3,Group4'

DIMENSION aGroup(1)
ChrToArray( cTextBoxValues, "," , @aGroup )
FOR K = 1 TO ALEN(aGroup)
	?aGroup(K)
ENDFOR
******************************
FUNCTION CHRTOARRAY
******************************
*!*	Convertir una cadena en una matriz según sus separadores.
*!* Convert string delimited with a character (eg. "," "." ":" ";" ) to an array
LPARAMETERS  cCadena , cDelimitador , aMatrizSalida
LOCAL N , aArray
DIMENSION aArray[1]
STORE SPACE(0) TO aArray
EXTERNAL ARRAY aMatrizSalida

cDelimitador  	= IIF( TYPE("cDelimitador")=="L" , "," , cDelimitador )
cCadena 		= IIF( TYPE("cCadena")=="L", "", cCadena )
cCadena 		= cCadena + cDelimitador

DO WHILE .T.
	IF EMPTY( cCadena )
		EXIT
	ENDIF
	N = AT( cDelimitador, cCadena )
	IF N=1
		nLen = ALEN( aArray )
		DIMENSION aArray[nLen+1]
		aArray[nLen+1] = ""
	ELSE
		nLen = ALEN( aArray )
		DIMENSION aArray[nLen+1]
		aArray[nLen+1] = ALLTRIM(UPPER(LEFT( cCadena, N - 1 )))
	ENDIF
	cCadena = ALLTRIM(RIGHT( cCadena, LEN(cCadena) - N ))
ENDDO
IF ALEN(aArray)>1
	=ADEL(aArray,1)
	DIMENSION aArray( ALEN(aArray)-1 )
	DIMENSION aMatrizSalida( ALEN(aArray) )
	=ACOPY( aArray, aMatrizSalida )
ENDIF
RETURN
