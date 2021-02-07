DO openfiles
DO LIB_MTEC WITH 0
DO pantalla
DEFINE WINDOW ctasxpagar FROM 06,06 TO 18,73 SHADOW TITLE " Pagos No Sustentatorios " FOOTER " <ESC> Salir "
ACTIVATE WINDOW ctasxpagar
DO actkeys
BROWSE FIELDS;
	nproyecto  :h='Proy.'    :p='9999' :r,;
	ndocumento :h='Nro_Doc.' :10 :r,;
	fdocumento :h='Fec_Doc.' :p='@E' :r,;
	fproceso   :h='Fec_Proc.':p='@E' :r,;
	fpago      :h='Fec_Pago' :p='@E' :r,;
	dprovedor  :h='Provedor' :31 :r,;
	dconcepto  :h='Concepto' :32 :r,;
	dmoneda    :h='Moneda'   :03 :r,;
	qimporte   :h='Importe'  :p='##,###,##9.99' :r,;
	qsaldoreal :h='Saldo'    :p='##,###,##9.99' :r,;
	qretencion :h='Retenciones' :p='##,###,##9.99' :r,;
	sdocumento :h='Status' :r;
	FOR sdocumento = 'P' NOMENU NOAPPEND NODELETE IN WINDOW ctasxpagar
DO noactkeys
DEACTIVATE WINDOW ctasxpagar
CLOSE DATABASES
RETURN

*******************
PROCEDURE openfiles
*******************
SELECT 1
USE paralelo.dbf ORDER ctaxpag00 ALIAS paralelo
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELECT 2
USE detapara.dbf ORDER fcancela ALIAS detalle
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELECT 3
USE cbdmauxi ORDER auxi01 ALIAS AUXI
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELECT auxi
SET FILTER TO clfaux="DIV"
SELECT paralelo
RETURN

*****************
PROCEDURE actkeys
*****************
ON KEY LABEL F2 DO adiciona
ON KEY LABEL F3 DO modifica
ON KEY LABEL F4 DO elimina
ON KEY LABEL F5 DO ordena
ON KEY LABEL F6 DO cancela
ON KEY LABEL F7 DO pagar
ON KEY LABEL F8 DO reporte
RETURN

*******************
PROCEDURE noactkeys
*******************
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
ON KEY LABEL F5
ON KEY LABEL F6
ON KEY LABEL F7
ON KEY LABEL F8
RETURN

******************
PROCEDURE adiciona
******************
HIDE WINDOW ctasxpagar
DO noactkeys
DEFINE WINDOW adiciona FROM 06,11 TO 18,67 SHADOW TITLE ' Ingreso de Datos ' FOOTER ' <F1> Ayuda '
ACTIVATE WINDOW adiciona
STORE SPACE(04) TO xproyecto,xtipomon
STORE SPACE(15) TO xndocum
STORE DATE()    TO xfdocum,xfproceso,xfpago
STORE SPACE(50) TO xprovedor,xconcepto
STORE SPACE(01) TO xsdocum
STORE 0.00      TO ximporte,xretencion
STORE 1         TO xsino
ON KEY LABEL F1 DO ayudaproy WITH VARREAD()
@ 01,03 SAY 'Proyecto  :' GET xproyecto  PICTURE '9999' VALID (SEEK("DIV"+xproyecto,3)) ERROR 'Proyecto no existe y/o esta vacio...'
@ 02,03 SAY 'Documento :' GET xndocum    PICTURE '@!'
@ 02,32 SAY 'Fch Doc.  :' GET xfdocum    FUNCTION '@E'
@ 03,03 SAY 'Fch Pago  :' GET xfpago     FUNCTION '@E'
@ 03,32 SAY 'Fch Proc. :' GET xfproceso  FUNCTION '@E'
@ 04,03 SAY 'Proveedor :' GET xprovedor  FUNCTION '!S37'
@ 05,03 SAY 'Concepto  :' GET xconcepto  FUNCTION '!S37'
@ 06,03 SAY 'Moneda    :' GET xtipomon   FUNCTION 'M S/.,US$'
@ 06,23 SAY 'Importe :'   GET ximporte   PICTURE '#,###,##9.99' VALID (ximporte>0) ERROR 'Importe debe ser mayor que cero...'
@ 07,03 SAY 'Retencion :' GET xretencion PICTURE '#,###,##9.99' 
@ 09,31 GET xsino FUNCTION "*H \<Aceptar;\<Cancelar"
READ CYCLE
ON KEY LABEL F1
IF (LASTKEY()<>27) AND (xsino=1)
	APPEND BLANK
	REPLACE ncodigo    WITH padl(ltrim(str(recc())),4,'000')
	REPLACE nproyecto  WITH xproyecto
	REPLACE ndocumento WITH xndocum
	REPLACE fdocumento WITH xfdocum
	REPLACE fproceso   WITH xfproceso
	REPLACE fpago      WITH xfpago
	REPLACE dprovedor  WITH xprovedor
	REPLACE dconcepto  WITH xconcepto
	REPLACE dmoneda    WITH xtipomon
	REPLACE qimporte   WITH ximporte
	REPLACE qsaldoreal WITH ximporte
	REPLACE qsaldo     WITH ximporte
	REPLACE qretencion WITH xretencion
	REPLACE sdocumento WITH 'P'
	DO pausa WITH 2,21,'Adicionado un nuevo documento...'
ENDIF
DEACTIVATE WINDOW adiciona
DO actkeys
SHOW WINDOW ctasxpagar
RETURN

******************
PROCEDURE modifica
******************
HIDE WINDOW ctasxpagar
DO noactkeys
DEFINE WINDOW modifica FROM 06,11 TO 18,67 SHADOW TITLE ' Modificacion de Datos ' FOOTER ' <ESC> Salir '
ACTIVATE WINDOW modifica
STORE ncodigo    TO xcodigo
STORE nproyecto  TO xproyecto
STORE ndocumento TO xndocum
STORE fdocumento TO xfdocum
STORE fproceso   TO xfproceso
STORE fpago      TO xfpago
STORE dprovedor  TO xprovedor
STORE dconcepto  TO xconcepto
STORE dmoneda    TO xtipomon
STORE qimporte   TO ximporte,ximpo2
STORE qsaldo	  TO xsaldo
STORE qsaldoreal TO xsaldoreal
STORE qretencion TO xretencion
STORE 1 TO xsino
ON KEY LABEL F1 DO ayudaproy WITH VARREAD()
@ 01,03 SAY 'Proyecto  :' GET xproyecto  PICTURE '9999' VALID (SEEK("DIV"+xproyecto,3)) ERROR 'Proyecto no existe y/o esta vacio...'
@ 02,03 SAY 'Documento :' GET xndocum    PICTURE '@!' 
@ 02,32 SAY 'Fch Doc.  :' GET xfdocum    FUNCTION '@E'
@ 03,03 SAY 'Fch Pago  :' GET xfpago     FUNCTION '@E'
@ 03,32 SAY 'Fch Proc. :' GET xfproceso  FUNCTION '@E'
@ 04,03 SAY 'Proveedor :' GET xprovedor  FUNCTION '!S37'
@ 05,03 SAY 'Concepto  :' GET xconcepto  FUNCTION '!S37'
@ 06,03 SAY 'Moneda    :' GET xtipomon   FUNCTION 'M S/.,US$'
@ 06,23 SAY 'Importe :'   GET ximporte   PICTURE '#,###,##9.99' VALID valimport() ERROR 'No puede modificarse, Verifique si ha realizado pagos...'
@ 07,03 SAY 'Retencion :' GET xretencion PICTURE '#,###,##9.99' 
@ 09,31 GET xsino FUNCTION "*H \<Aceptar;\<Cancelar"
READ CYCLE
ON KEY LABEL F1
IF (LASTKEY()<>27) AND (xsino=1)
	REPLACE nproyecto  WITH xproyecto
	REPLACE ndocumento WITH xndocum
	REPLACE fdocumento WITH xfdocum
	REPLACE fproceso   WITH xfproceso
	REPLACE fpago      WITH xfpago
	REPLACE dprovedor  WITH xprovedor
	REPLACE dconcepto  WITH xconcepto
	REPLACE dmoneda    WITH xtipomon
	REPLACE qretencion WITH xretencion
	IF ximporte <> ximpo2
		REPLACE qimporte   WITH ximporte
		REPLACE qsaldo     WITH ximporte
		REPLACE qsaldoreal WITH ximporte
	ENDIF
	DO pausa WITH 2,21,'Modificando el documento actual...'
ENDIF
DEACTIVATE WINDOW modifica
DO actkeys
SHOW WINDOW ctasxpagar
RETURN

******************
FUNCTION valimport
******************
SELECT detalle
GO TOP
LOCATE FOR (detalle.ncodigo=xcodigo)AND(scancela='P' OR scancela='C')
xflag = FOUND()
SELECT paralelo
RETURN !xflag

*******************
PROCEDURE ayudaproy
*******************
PARAMETER xread
IF INLIST(xread,"XPROYECTO")
	DO CASE
		CASE xread = "XPROYECTO"
			SELECT auxi
			DEFINE POPUP ayuda FROM 04,20 TO 15,65 PROMPT FIELD codaux+" "+nomaux SCROLL TITLE " Proyectos "
			ON SELECTION POPUP ayuda DO opcion
			ACTIVATE POPUP ayuda
			SELECT paralelo
	ENDCASE
ENDIF
RETURN

****************
PROCEDURE opcion
****************
xproyecto = auxi.codaux
DEACTIVATE POPUP ayuda
RETURN

*****************
PROCEDURE elimina
*****************
DO noactkeys
IF desea('Esta Seguro de Eliminar Documento ?')
	REPLACE sdocumento WITH 'E'
	DO pausa WITH 2,21,'Eliminando el documento actual...'
ENDIF
DO actkeys
RETURN

****************
PROCEDURE ordena
****************
DO noactkeys
HIDE WINDOW ctasxpagar
DEFINE WINDOW ordena FROM 08,17 TO 15,60 SHADOW TITLE ' Ordenar - Buscar '
ACTIVATE WINDOW ordena
SET NEAR ON
xnorden = 1
@ 02,03 SAY 'Elige Orden :'
@ 04,03 SAY 'Buscar      :'
@ 01,18 GET xnorden FUNC "^ Proyecto;Documento;Fecha Proceso;Fecha Pago;Proveedor;Importe"
READ
IF LASTKEY()<>27
	DO CASE
		CASE xnorden = 1
			SET ORDER TO ctaxpag01
			STORE SPACE(03) TO xproyecto
			@ 04,18 GET xproyecto PICTURE '999'
			READ
			IF LASTKEY()<>27
				SEEK xproyecto
			ENDIF
		CASE xnorden = 2
			SET ORDER TO ctaxpag02
			STORE SPACE(15) TO xdocumento
			@ 04,18 GET xdocumento 
			READ
			IF LASTKEY()<>27
				SEEK xdocumento
			ENDIF			
		CASE xnorden = 3
			SET ORDER TO ctaxpag03
			STORE {} TO xfproceso
			@ 04,18 GET xfproceso FUNCTION '@E'
			READ
			IF LASTKEY()<>27
				SEEK xfproceso
			ENDIF			
		CASE xnorden = 4
			SET ORDER TO ctaxpag04
			STORE {} TO xfpago
			@ 04,18 GET xfpago FUNCTION '@E'
			READ
			IF LASTKEY()<>27
				SEEK xfpago
			ENDIF	
		CASE xnorden = 5
			SET ORDER TO ctaxpag05
			STORE SPACE(50) TO xprovedor
			@ 04,18 GET xprovedor FUNCTION 'S20'
			READ
			IF LASTKEY()<>27
				SEEK xprovedor
			ENDIF
		CASE xnorden = 6
			SET ORDER TO ctaxpag06
			STORE 0.0 TO ximporte
			@ 04,18 GET ximporte PICTURE '#,###,###.##'
			READ
			IF LASTKEY()<>27
				SEEK ximporte
			ENDIF
	ENDCASE
ENDIF	 
RELEASE WINDOW ordena
SHOW WINDOW ctasxpagar
DO actkeys
RETURN

*****************
PROCEDURE cancela
*****************
HIDE WINDOW ctasxpagar
DO noactkeys
DEFINE WINDOW cancela FROM 06,10 TO 18,68 SHADOW TITLE ' Programacion de Pagos ' FOOTER ' <ESC> Salir '
ACTIVATE WINDOW cancela	
xcodigo   = paralelo.ncodigo
xmoneda   = paralelo.dmoneda
ximporte  = paralelo.qimporte
xsaldo    = paralelo.qsaldo
xpago     = paralelo.qsaldo
xregistro = RECNO()
xfpago    = DATE()
xsino     = 1
xpagopend = 0
xpagocanc = 0
DO printpagos WITH 1
@ 00,25 TO 09,54
@ 00,02 TO 02,23
@ 03,02 TO 05,23
@ 06,02 TO 09,23
@ 00,27 SAY ' Pagos Prog. / Canc. '
@ 00,04 SAY ' Importe '
@ 03,04 SAY ' Saldo ' 
@ 06,04 SAY ' Pago a Programar '
@ 01,04 SAY xmoneda COLOR N/W
@ 04,04 SAY xmoneda COLOR N/W
@ 01,10 SAY ximporte PICTURE '#,###,##9.99' COLOR N/W
@ 04,10 SAY xsaldo PICTURE '#,###,##9.99' COLOR N/W
IF xpagopend + xpagocanc = ximporte
	@ 10,10 SAY ' Pagos pendientes ya cubren el importe ' COLOR GR+*/B
	=INKEY(30,'H')
ELSE
	@ 07,04 SAY xmoneda COLOR N/W
	@ 08,04 SAY 'Fecha'
	@ 07,10 GET xpago  PICTURE '#,###,##9.99' COLOR N/W VALID (xpago>0)AND(xpago<=xsaldo) ERROR 'Monto debe ser mayor que cero y menor que saldo...'
	@ 08,14 GET xfpago FUNCTION '@E' VALID (!EMPTY(xfpago)) ERROR 'Fecha no puede estar vacia...'
	@ 10,31 GET xsino func "*H \<Aceptar;\<Cancelar"
	READ CYCLE
	IF LASTKEY()<>27 AND xsino<>2
		GO xregistro
		SELECT paralelo
		REPLACE qsaldo   WITH xsaldo - xpago
		SELECT detalle
		APPEND BLANK
		REPLACE ncodigo  WITH xcodigo
		REPLACE qcancela WITH xpago
		REPLACE fcancela WITH xfpago
		REPLACE dmoneda  WITH xmoneda
		REPLACE scancela WITH 'P'
		SELECT paralelo
	ENDIF
ENDIF
GO xregistro
RELEASE WINDOW cancela
DO actkeys
SHOW WINDOW ctasxpagar
RETURN

********************
PROCEDURE printpagos
********************
PARAMETER mopc
SELECT detalle
GO TOP
xfila = 2
LOCATE FOR ncodigo = xcodigo
DO WHILE FOUND()
	IF scancela = "P" 
		IF mopc = 1
			@ xfila,28 SAY fcancela FUNCTION '@E'
			@ xfila,37 SAY qcancela PICTURE '#,###,##9.99'
			@ xfila,51 SAY scancela
			xfila = xfila + 1
		ENDIF
		xpagopend = xpagopend + qcancela
	ENDIF	
	IF scancela = "C"
		IF mopc = 1
			@ xfila,28 SAY fcancela FUNCTION '@E'
			@ xfila,37 SAY qcancela PICTURE '#,###,##9.99'
			@ xfila,51 SAY scancela
			xfila = xfila + 1
		ENDIF
		xpagocanc = xpagocanc + qcancela
	ENDIF	
	CONTINUE
ENDDO
SELECT paralelo
RETURN 

***************
PROCEDURE pagar
***************
DO noactkeys
HIDE WINDOW ctasxpagar
DEFINE WINDOW fecha FROM 10,20 TO 14,58 SHADOW FOOTER ' <ESC> Salir ' 
ACTIVATE WINDOW fecha 
xfecpago = {}
@ 01,06 SAY 'Fecha de Pago :' GET xfecpago FUNCTION 'E'
READ
RELEASE WINDOW fecha
IF LASTKEY()<>27
	SET ORDER TO ctaxpag00
	SELECT detalle
	COUNT TO mcuenta FOR (xfecpago=fcancela) AND (scancela="P")
	IF mcuenta > 0
		DO pantpagos
		DEFINE WINDOW pagar FROM 06,07 TO 18,71 SHADOW TITLE ' Relacion de Pagos Programados ' FOOTER ' <ESC> Salir '
		ACTIVATE WINDOW pagar
		DO keypagos
		SET FILTER TO (fcancela=xfecpago)AND(scancela='P') 
		BROWSE FIELDS;
			Provedor = IIF(SEEK(detalle.ncodigo,1),paralelo.dprovedor," "):30 :w=.f.,;
			fcancela :h='Fecha',;
			dmoneda  :h='Moneda':r,;
			qcancela :h='Monto' :p='##,###,##9.99':r;
			NOAPPEND NODELETE IN WINDOW pagar
		SET FILTER TO 
		DO nokeypagos
		RELEASE WINDOW pagar	
	ELSE
		DO pausa WITH 3,16,'No existen pagos en la fecha ingresada'
	ENDIF
	SELECT paralelo
ENDIF
SHOW WINDOW ctasxpagar
DO actkeys
DO pantalla
RETURN

*******************
PROCEDURE pantpagos
*******************
@ 21,00 CLEAR TO 24,78
@ 21,01 TO 23,78
@ 22,13 SAY '<CTRL+E>' COLOR w+/bg
@ 22,21 SAY 'Eliminar'
@ 22,32 SAY '<CTRL+C>' COLOR w+/bg
@ 22,40 SAY 'Cancelar'
@ 22,51 SAY '<CTRL+R>' COLOR w+/bg
@ 22,59 SAY 'Reporte'
RETURN

******************
PROCEDURE keypagos
******************
ON KEY LABEL CTRL+E DO delpago
ON KEY LABEL CTRL+C DO canpago
ON KEY LABEL CTRL+R DO rptpago
RETURN

********************
PROCEDURE nokeypagos
********************
ON KEY LABEL CTRL+E
ON KEY LABEL CTRL+C
ON KEY LABEL CTRL+R
RETURN

*****************
PROCEDURE delpago
*****************
DO nokeypagos
IF DESEA('Esta Seguro de Eliminar Pago ?')
	REPLACE scancela WITH 'E'
	xcancela = qcancela
	xcodigo  = ncodigo
	SELECT paralelo
	SEEK xcodigo
	REPLACE qsaldo WITH qsaldo + xcancela
	SELECT detalle
ENDIF
DO keypagos
COUNT TO mcuenta FOR (xfecpago=fcancela) AND (scancela="P")
IF mcuenta = 0
	DEACTIVATE WINDOW pagar
ENDIF
RETURN

*****************
PROCEDURE canpago
*****************
DO nokeypagos
IF DESEA('Seguro de Cancelar Todos los Pagos ?')
	LOCATE FOR (fcancela=xfecpago) AND (scancela='P')
	DO WHILE FOUND()
		REPLACE scancela WITH 'C'
		xcancela = qcancela
		xcodigo  = ncodigo
		SELECT paralelo
		SEEK xcodigo
		REPLACE qsaldoreal WITH qsaldoreal - xcancela
		IF qsaldoreal = 0
			REPLACE sdocumento WITH 'C'
			REPLACE fpago      WITH xfecpago
		ENDIF
		SELECT detalle	
		CONTINUE
	ENDDO
	DEACTIVATE WINDOW pagar
ENDIF
DO keypagos
RETURN

*****************
PROCEDURE rptpago
*****************
DO nokeypagos
HIDE WINDOW pagar 
SEEK xfecpago
xWhile = [fcancela=xfecpago]
xFor   = [scancela="P"]
sNomRep = "RPTCTXP1"
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3]
DO ADMPRINT WITH "REPORTS"
@ 16,00 CLEAR TO 24,78
DO pantpagos
SHOW WINDOW pagar
DO keypagos
RETURN

*****************
PROCEDURE reporte
*****************
DO noactkeys
HIDE WINDOW ctasxpagar
STORE 1 TO xforma,xmoneda,xsino
STORE {} TO xfecha
DEFINE WINDOW reporte FROM 06,11 TO 18,67 SHADOW TITLE ' Reporte ' FOOTER ' <ESC> Salir '
ACTIVATE WINDOW reporte
@ 03,11 TO 03,42
@ 07,11 TO 07,42
@ 00,11 TO 09,42
@ 01,14 GET xforma  PICTURE "@*RNV Documentos Pendientes;Documentos Cancelados"
@ 04,22 GET xmoneda PICTURE "@*RNV 	Ambas;Soles;Dolares"
@ 08,19 SAY 'Fecha :' GET xfecha FUNCTION 'E'
@ 10,29 GET xsino func "*H \<Aceptar;\<Cancelar"
READ CYCLE
IF LASTKEY()<>27 AND xsino<>2
	GO TOP
	DO imprime
ENDIF
DEACTIVATE WINDOW reporte
SHOW WINDOW ctasxpagar
DO pantalla
DO actkeys
RETURN

*****************
PROCEDURE imprime
*****************
HIDE WINDOW reporte
DO CASE
	CASE xforma = 1
		xWhile = [.t.]
		IF xmoneda = 1
			IF EMPTY(xfecha)
				xFor = [(sdocumento = 'P')]
			ELSE
				xFor = [(sdocumento = 'P')AND(fpago=xfecha)]
			ENDIF
		ENDIF
		IF xmoneda = 2
			IF EMPTY(xfecha)
				xFor = [(sdocumento='P')AND(dmoneda='S/.')]
			ELSE
				xFor = [(sdocumento='P')AND(dmoneda='S/.')AND(fpago=xfecha)]
			ENDIF
		ENDIF
		IF xmoneda = 3
			IF EMPTY(xfecha)
				xFor = [(sdocumento='P')AND(dmoneda='US$')]
			ELSE
				xFor = [(sdocumento='P')AND(dmoneda='US$')AND(fpago=xfecha)]
			ENDIF
		ENDIF
	CASE xforma = 2
		xWhile = [.t.]
		IF xmoneda = 1
			IF EMPTY(xfecha)
				xFor = [(sdocumento = 'C')]
			ELSE
				xFor = [(sdocumento = 'C')AND(fpago=xfecha)]
			ENDIF
		ENDIF
		IF xmoneda = 2
			IF EMPTY(xfecha)
				xFor = [(sdocumento='C')AND(dmoneda='S/.')]
			ELSE
				xFor = [(sdocumento='C')AND(dmoneda='S/.')AND(fpago=xfecha)]
			ENDIF
		ENDIF
		IF xmoneda = 3
			IF EMPTY(xfecha)
				xFor = [(sdocumento='C')AND(dmoneda='US$')]
			ELSE
				xFor = [(sdocumento='C')AND(dmoneda='US$')AND(fpago=xfecha)]
			ENDIF
		ENDIF
ENDCASE
sNomRep = "RPTCTXPG"
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3]
DO ADMPRINT WITH "REPORTS"
RETURN

***************
PROCEDURE pausa
***************
PARAMETER xdelay,xfila,mensaje
DEFINE WINDOW pausa FROM xfila,10 TO xfila+2,70 SHADOW
ACTIVATE WINDOW pausa
@ 00,30-(INT(LEN(mensaje))/2) SAY mensaje color w+*/b
=INKEY(xdelay,'H')
DEACTIVATE WINDOW pausa
RETURN

**************
FUNCTION desea
**************
PARAMETER mensa
DEFINE WINDOW pregunta FROM 17,16 TO 21,62 DOUBLE COLOR SCHEME 7 SHADOW
ACTIVATE WINDOW pregunta
@ 00,23-(INT(LEN(mensa))/2) SAY mensa
@ 02,02 GET mchoice FUNCTION '*NHT \<OK;\<Cancel' SIZE 1,8,25 DEFAULT 1
READ CYCLE
RELEASE WINDOW pregunta
RETURN IIF(LASTKEY()=27,.F.,IIF(mchoice=1,.T.,.F.))

******************
PROCEDURE pantalla
******************
CLEAR 
dias  = 'Domingo  Lunes    Martes   MiercolesJueves   Viernes  Sabado   '
meses = 'Enero    Febrero  Marzo    Abril    Mayo     Junio    Julio    Agosto   SetiembreOctubre  NoviembreDiciembre'
fecha = rtrim(substr(dias,(dow(date())-1)*9+1,9))+', '+padl(day(date()),2,'0')+' '+rtrim(substr(meses,(month(date())-1)*9+1,9))+' '+str(year(date()),4)
@ 02,03 SAY fecha
@ 01,01 TO 04,78
@ 21,01 TO 24,78
@ 22,04 SAY 'F2' COLOR w+/bg
@ 22,06 SAY 'Adicionar'
@ 22,17 SAY 'F3' COLOR w+/bg
@ 22,19 SAY 'Modificar'
@ 22,30 SAY 'F4' COLOR w+/bg
@ 22,32 SAY 'Eliminar'
@ 22,42 SAY 'F5' COLOR w+/bg
@ 22,44 SAY 'Ordenar'
@ 22,53 SAY 'F6' COLOR w+/bg
@ 22,55 SAY 'Programacion de Pagos'
@ 23,20 SAY 'F7' COLOR w+/bg
@ 23,22 SAY 'Cancelar Pagos Programados'
@ 23,50 SAY 'F8' COLOR w+/bg
@ 23,52 SAY 'Reporte'
RETURN