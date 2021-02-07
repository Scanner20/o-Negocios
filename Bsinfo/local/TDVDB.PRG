* *********************************************************
* *
* * 13/06/2003              TDVDB.DBC              07:51:10
* *
* *********************************************************
* *
* * Descripción:
* * Este programa lo ha generado automáticamente GENDBC
* * Versión 2.26.67
* *
* *********************************************************


DisplayStatus([Creando base de datos...])
CLOSE DATA ALL
CREATE DATABASE 'TDVDB.DBC'
DisplayStatus([Creando tabla GATRIBUTOS...])
MakeTable_GATRIBUTOS()
DisplayStatus([Creando tabla GTABLAS...])
MakeTable_GTABLAS()
DisplayStatus([Creando tabla GTABLAS_DETALLE...])
MakeTable_GTABLAS_DETALLE()
DisplayStatus([Creando tabla MRUTASARCHIVOS...])
MakeTable_MRUTASARCHIVOS()
DisplayStatus([Creando tabla PERFIL_USUARIO...])
MakeTable_PERFIL_USUARIO()
DisplayStatus([Creando tabla PERFIL_BOTONES...])
MakeTable_PERFIL_BOTONES()
DisplayStatus([Creando tabla GENTIDADES...])
MakeTable_GENTIDADES()
DisplayStatus([Creando tabla GENTIDADES_DETALLE...])
MakeTable_GENTIDADES_DETALLE()
DisplayStatus([Terminado.])


********* Volver a crear el procedimiento *********
IF !FILE([TDVDB.krt])
    ? [¡Advertencia! No se ha encontrado ningún archivo de procedimientos.]
ELSE
	CLOSE DATABASE
	USE 'TDVDB.DBC'
	g_SetSafety = SET('SAFETY')
	SET SAFETY OFF
	LOCATE FOR Objectname = 'StoredProceduresSource'
	IF FOUND()
        APPEND MEMO Code FROM [TDVDB.krt] OVERWRITE
	    REPLACE Code WITH SUBSTR(Code, 87, 565)
	ENDIF
	LOCATE FOR Objectname = 'StoredProceduresObject'
	IF FOUND()
        APPEND MEMO Code FROM [TDVDB.krt] OVERWRITE
        REPLACE Code WITH SUBSTR(Code, 652)
	ENDIF
    SET SAFETY &g_SetSafety
	USE
	OPEN DATABASE [TDVDB.DBC]
ENDIF

FUNCTION MakeTable_GATRIBUTOS
***** Configuración de tabla para GATRIBUTOS *****
CREATE TABLE 'GATRIBUTOS.DBF' NAME 'GATRIBUTOS' (CODIGOATRIBUTO C(5) NOT NULL, ;
                         DESCRIPCIONLARGAATRIBUTO C(60) NULL, ;
                         NOMBREATRIBUTO C(40) NULL, ;
                         FLAGCAMPO L NOT NULL, ;
                         DESCRIPCIONCORTAATRIBUTO C(40) NULL, ;
                         TIPODATO C(1) NULL, ;
                         LONGITUDDATO I NULL, ;
                         MASCARADATO C(20) NULL, ;
                         SECUENCIAATRIBUTOS C(100) NULL, ;
                         CODIGOTABLA C(5) NULL, ;
                         LONGITUDCABECERA I NULL, ;
                         FORMULACONVERSION C(100) NULL, ;
                         CODIGOENTIDAD C(4) NULL, ;
                         FHCREACION T NULL, ;
                         USUARIOCREACION C(15) NULL, ;
                         ESTACIONCREACION C(15) NULL, ;
                         FHMODIFICACION T NULL, ;
                         USUARIOMODIFICACION C(15) NULL, ;
                         ESTACIONMODIFICACION C(15) NULL, ;
                         FLAGELIMINADO L NULL)

***** Crear cada índice para GATRIBUTOS *****
SET COLLATE TO 'MACHINE'
ALTER TABLE 'GATRIBUTOS' ADD PRIMARY KEY CODIGOATRIBUTO TAG CODIGO

***** Cambiar propiedades para GATRIBUTOS *****
ENDFUNC

FUNCTION MakeTable_GTABLAS
***** Configuración de tabla para GTABLAS *****
CREATE TABLE 'GTABLAS.DBF' NAME 'GTABLAS' (CODIGOTABLA C(5) NOT NULL, ;
                      DESCRIPCIONTABLA C(50) NULL, ;
                      ANCHOARGUMENTO I NULL, ;
                      ESTADOTABLA L NOT NULL, ;
                      MASCARAARGUMENTO C(30) NULL, ;
                      TIPOARGUMENTO C(1) NULL, ;
                      FHCREACION T NULL, ;
                      USUARIOCREACION C(15) NULL, ;
                      ESTACIONCREACION C(15) NULL, ;
                      FHMODIFICACION T NULL, ;
                      USUARIOMODIFICACION C(15) NULL, ;
                      ESTACIONMODIFICACION C(15) NULL, ;
                      FLAGELIMINADO L NULL)

***** Crear cada índice para GTABLAS *****

***** Cambiar propiedades para GTABLAS *****
ENDFUNC

FUNCTION MakeTable_GTABLAS_DETALLE
***** Configuración de tabla para GTABLAS_DETALLE *****
CREATE TABLE 'GTABLAS_DETALLE.DBF' NAME 'GTABLAS_DETALLE' (CODIGOTABLA C(5) NOT NULL, ;
                              DESCRIPCIONCORTAARGUMENTO C(30) NOT NULL, ;
                              ELEMENTOTABLA C(5) NOT NULL, ;
                              DESCRIPCIONLARGAARGUMENTO C(60) NOT NULL, ;
                              VALOR1ARGUMENTO N(17, 3) NOT NULL, ;
                              VALOR2ARGUMENTO N(17, 3) NOT NULL, ;
                              FLAGDEFAULT L NOT NULL, ;
                              FHCREACION T NULL, ;
                              USUARIOCREACION C(15) NULL, ;
                              ESTACIONCREACION C(15) NULL, ;
                              FHMODIFICACION T NULL, ;
                              USUARIOMODIFICACION C(15) NULL, ;
                              ESTACIONMODIFICACION C(15) NULL, ;
                              FLAGELIMINADO L NULL)

***** Crear cada índice para GTABLAS_DETALLE *****

***** Cambiar propiedades para GTABLAS_DETALLE *****
ENDFUNC

FUNCTION MakeTable_MRUTASARCHIVOS
***** Configuración de tabla para MRUTASARCHIVOS *****
CREATE TABLE 'MRUTASARCHIVOS.DBF' NAME 'MRUTASARCHIVOS' (CODIGORUTA C(3) NOT NULL, ;
                             DESCRIPCIONRUTA C(40) NULL, ;
                             NOMBREENTIDAD C(40) NULL, ;
                             CODIGOENTIDAD C(4) NULL, ;
                             NOMBRECOLUMNA C(40) NULL, ;
                             RUTA C(120) NULL, ;
                             SERVIDORORIGEN C(20) NULL, ;
                             SERVIDORDESTINO C(20) NULL, ;
                             FLAGELIMINADO L NULL)

***** Crear cada índice para MRUTASARCHIVOS *****

***** Cambiar propiedades para MRUTASARCHIVOS *****
ENDFUNC

FUNCTION MakeTable_PERFIL_USUARIO
***** Configuración de tabla para PERFIL_USUARIO *****
CREATE TABLE 'PERFIL_USUARIO.DBF' NAME 'PERFIL_USUARIO' (CODIGOPERFIL C(3) NOT NULL, ;
                             CODIGOOPCION C(3) NOT NULL, ;
                             CODIGOFORMULARIO C(4) NOT NULL, ;
                             NOMBREFORMULARIO C(60) NOT NULL, ;
                             CODIGOSISTEMA C(3) NULL, ;
                             CODIGOMODULO C(3) NULL, ;
                             LOGINUSUARIO C(12) NOT NULL)

***** Crear cada índice para PERFIL_USUARIO *****

***** Cambiar propiedades para PERFIL_USUARIO *****
ENDFUNC

FUNCTION MakeTable_PERFIL_BOTONES
***** Configuración de tabla para PERFIL_BOTONES *****
CREATE TABLE 'PERFIL_BOTONES.DBF' NAME 'PERFIL_BOTONES' (LOGINUSUARIO C(12) NOT NULL, ;
                             CODIGOFORMULARIO C(4) NOT NULL, ;
                             CODIGOBOTON C(8) NOT NULL)

***** Crear cada índice para PERFIL_BOTONES *****

***** Cambiar propiedades para PERFIL_BOTONES *****
ENDFUNC

FUNCTION MakeTable_GENTIDADES
***** Configuración de tabla para GENTIDADES *****
CREATE TABLE 'GENTIDADES.DBF' NAME 'GENTIDADES' (CODIGOENTIDAD C(4) NOT NULL, ;
                         NOMBREENTIDAD C(50) NULL, ;
                         DESCRIPCIONENTIDAD C(80) NULL, ;
                         TIPOOBJETO C(1) NULL, ;
                         CODIGOFORMULARIO C(4) NULL, ;
                         FLAGTABLALOCAL L NOT NULL, ;
                         FLAGTABLALIBRE L NOT NULL, ;
                         CODIGOCATEGORIA C(2) NULL, ;
                         NOMBRESERVIDOR C(20) NULL, ;
                         NOMBREBASEDATOS C(20) NULL, ;
                         CODIGOENTIDAD_DETALLE C(4) NULL, ;
                         CODIGOENTIDAD_ATRIBUTO C(4) NULL, ;
                         NOMBREREPORTE C(40) NULL, ;
                         CODIGOSERVIDOR C(2) NULL, ;
                         CODIGOBASEDATOS C(2) NULL, ;
                         NOMBRETABLALOCAL C(50) NULL, ;
                         FLAGBUSQUEDA L NOT NULL)

***** Crear cada índice para GENTIDADES *****

***** Cambiar propiedades para GENTIDADES *****
ENDFUNC

FUNCTION MakeTable_GENTIDADES_DETALLE
***** Configuración de tabla para GENTIDADES_DETALLE *****
CREATE TABLE 'GENTIDADES_DETALLE.DBF' NAME 'GENTIDADES_DETALLE' (CODIGOENTIDAD C(4) NOT NULL, ;
                                 CODIGOATRIBUTO C(5) NOT NULL DEFAULT nuevoatributo(), ;
                                 NOMBRECAMPO C(40) NULL, ;
                                 DESCRIPCIONCAMPO C(60) NULL, ;
                                 TIPODATOCAMPO C(1) NULL, ;
                                 MODOOBTENERDATOS C(1) NULL DEFAULT "V", ;
                                 FLAGCRITERIO L NOT NULL DEFAULT .T., ;
                                 FLAGMUESTRAGRID L NOT NULL DEFAULT .T., ;
                                 FLAGREPORTE L NOT NULL DEFAULT .F., ;
                                 ORDENCOLUMNA C(4) NULL, ;
                                 DESCRIPCIONCABECERA C(40) NULL CHECK descripcion(), ;
                                 LONGITUDCABECERA I NULL CHECK longitud(), ;
                                 FLAGAYUDA L NOT NULL DEFAULT .F., ;
                                 LONGITUDDATO I NULL, ;
                                 MASCARADATO C(20) NULL, ;
                                 SECUENCIACAMPOS C(100) NULL, ;
                                 CODIGOENTIDADCAMPO C(4) NULL, ;
                                 CODIGOTABLA C(5) NULL, ;
                                 FLAGCONSULTADO L NOT NULL DEFAULT .F., ;
                                 FLAGEXTRAEDESCRIPCION L NOT NULL DEFAULT .F., ;
                                 FLAGBUSQUEDA L NULL DEFAULT .F., ;
                                 FLAGPRIMARYKEY L NOT NULL DEFAULT .F., ;
                                 FLAGRETORNO L NOT NULL DEFAULT .F., ;
                                 FLAGVISUALIZACION L NOT NULL DEFAULT .T., ;
                                 FLAGPLANTILLA L NOT NULL DEFAULT .F., ;
                                 CAMPOVISUALIZACION C(40) NULL, ;
                                 CAMPORETORNO C(40) NULL, ;
                                 NOMBREENTIDADCAMPO C(50) NULL, ;
                                 DESCCABECERAVISUALIZACION C(40) NULL, ;
                                 LONGITUDCABECERAVISUALIZACION I NULL, ;
                                 FLAGELIMINADO L NULL DEFAULT .F.)

***** Crear cada índice para GENTIDADES_DETALLE *****
SET COLLATE TO 'MACHINE'
ALTER TABLE 'GENTIDADES_DETALLE' ADD PRIMARY KEY CODIGOENTIDAD+CODIGOATRIBUTO TAG ENTATRY

***** Cambiar propiedades para GENTIDADES_DETALLE *****
ENDFUNC


FUNCTION DisplayStatus(lcMessage)
WAIT WINDOW NOWAIT lcMessage
ENDFUNC
