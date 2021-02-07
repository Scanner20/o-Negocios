*!*	-------------------------------------------------------------------------------
*!*	Titulo			:
*!*	Propósito		:	Configurar el Grid de acuerdo al Estandar de Diseño Interno
*!*
*!*	PARÁMETROS		:	<Ninguno>
*!*	Valor de retorno:	<Ninguno>
*!*	LLAMADAS		:	<Ninguno>
*!*	CLASES HEREDADAS
*!*	Comentarios 	:
*!*
*!*
*!*	ULTIMA MODIFICACIÓN
*!*		Fecha		: 6/6/1999
*!*		Autor		: VETT
*!*		Comentario	:
*!*	-------------------------------------------------------------------------------
LOCAL m.lnCount1 , m.lnCount2

*!*	Recorrer todos las columnas del Grid
*!*	THIS.GRIDLINECOLOR		= RGB(192,192,192)	&& Gris Oscuro en rejilla de Grid
*!*	THIS.ALLOWHEADERSIZING	= .F.				&& No puede alterar altura de cabecera
*!*	THIS.ALLOWROWSIZING		= .F.				&& No puede alterar altura de la fila
FOR m.lnCount1 = 1 TO THIS.COLUMNCOUNT
	*!*	Recorrer todos los objetos de cada columna del Grid
	THIS.COLUMNS(m.lnCount1).RESIZABLE	= .T.	&& No podra alterar el ancho de columna
	THIS.COLUMNS(m.lnCount1).FONTSIZE	= THIS.FONTSIZE
	THIS.COLUMNS(m.lnCount1).MOVABLE	= .F.	&& Para que no pueda mover las columnas
	FOR m.lnCount2 = 1 TO THIS.COLUMNS(m.lnCount1).CONTROLCOUNT
		*!*	Configurar solo las Cabeceras (Header)
		IF THIS.COLUMNS(m.lnCount1).CONTROLS(m.lnCount2).BASECLASS == 'Header'
			WITH THIS.COLUMNS(m.lnCount1).CONTROLS(m.lnCount2)
*!*					IF LEN(.CAPTION) > 1
*!*						.FONTBOLD	= .F.
*!*						*.FONTSIZE	= 8
*!*					ENDIF
				IF !this.usarforbackcolorcolumnas 
					.FORECOLOR	= RGB(128,0,128)	&& Rojo Oscuro
					.BACKCOLOR	= RGB(223,223,223)	&& Gris Claro
				ENDIF
				
*!*					.ALIGNMENT	= 2					&& Centrado
			ENDWITH
		ENDIF
	ENDFOR
ENDFOR
THIS.RECORDSOURCE = ""
THIS.RECORDSOURCETYPE = 4
IF VERSION(5)<700
	THIS.SETALL("DynamicBackColor", "IIF( !EMPTY(ALIAS()) AND RECNO()= THIS.Registro , RGB(0,128,192), RGB(255,255,255))" , "Column")
	THIS.SETALL("DynamicForeColor", "IIF( !EMPTY(ALIAS()) AND RECNO()= THIS.Registro , RGB(255,255,255), RGB(0,0,0))" , "Column")
ENDIF
THIS.REFRESH()