PUBLIC glSalir
glSalir = .f.
SET DEFA TO H:\TDV\ClasesGenerales\Programacion01\Programacion

*!*	Activar los Paths para sus formularios personales.... (xUsuario)
SET PATH TO .\Formularios , ; .\Programas , .\Reportes , .\Menus , .\Clases ,  ;
			H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases , ;
			H:\TDV\ClasesGenerales\Programacion01\Programacion\Formularios
*!*	Las 2 lineas anteriores, apuntan hacia las clases generales

*!*	Activar las Librerias de clases generales
CLOSE DATABASES ALL

DO Migracion.mpr

DO WHILE !glSalir
	READ EVENTS
	IF glSalir
		CLEAR EVENTS
		SET SYSMENU TO DEFAULT
	ENDIF
ENDDO
RETURN
