**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\dosvr.vcx
**************************************************


**************************************************
*-- Class:        contabilidad (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   02/11/06 03:16:06 AM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS contabilidad AS custom OLEPUBLIC


	Height = 15
	Width = 100
	*-- Descripcion del error
	serr = ([])
	*-- Campos que conforman la clave
	nclave = ([])
	*-- Valor de la clave
	vclave = .F.
	*-- Vinculo  a la clase de entorno general del sistema
	oentorno = .NULL.
	Name = "contabilidad"

	*-- Raferencia administrador de acceso a datos.
	odatadm = .F.
	lpinta = .F.
	crear = .F.

	*-- Numero de decimales
	nrodec = .F.

	*-- modificar si no esta cerrado el mes contable
	modificar = .F.
	cabecera = .F.
	tot_imp = .F.

	*-- Nro. de asiento global
	tsnroast = .F.

	*-- Objeto que contiene atributos de la cabecera del asiento
	ocabecera = .F.

	*-- Arreglo que contiene los registros del detalle del asiento
	adetalle = .F.

	*-- Objeto que referencia  a un registro del detalle
	oitem = .F.
	xfporigv = .F.
	DIMENSION v_imp[1]


	*-- Recalculo los saldos contables
	PROCEDURE regeneracion
		PARAMETERS XiElige,_Mes,XsCodCta
		LOCAL nMesIni,nMesFin,LsMsgProc
		SELE CTAS
		locate
		IF EOF()
			this.serr='Te has percatado de que el plan de cuentas esta vacio?,  no seria mejor que lo cargues primero?...'
			return
		ENDIF
		SELE RMOV
		SET ORDE TO RMOV03
		SELE ACCT
		SET ORDE TO ACCT01
		*

		cNroMes = STR(_MES,2,0)
		LsMsgProc=[Anulando acumulandos anteriores ....]
		DO CASE
		   CASE  xielige=1
		      SELE ACCT
		      nMesIni = 0
		      nMesFin = 13
		      ZAP
		      *
		   CASE  xielige=2
		      nMesIni = _Mes
		      nMesFin = _Mes
		      SEEK cNroMes
		      SCAN WHILE NroMes=cNroMes
		         DO WHILE !RLOCK()
		         ENDDO
		         REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
		         UNLOCK
		      ENDSCAN
		      *
		   CASE  xielige=3
		      nMesIni = 0
		      nMesFin = 13
		      FOR I= nMesIni TO nMesFin
		          cNroMes = str(i,2,0)
		          SEEK cNroMes+xscodcta
		          SCAN WHILE NroMes=cNroMes .AND. CodCta = xscodcta
		             DO WHILE !RLOCK()
		             ENDDO
		             REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
		             UNLOCK
		          ENDSCAN
		      NEXT
		      *
		   CASE  xielige=4
		      nMesIni = _Mes
		      nMesFin = _Mes
		      SEEK cNroMes+xscodcta
		      SCAN WHILE NroMes=cNroMes .AND. CodCta = xscodcta
		         DO WHILE !RLOCK()
		         ENDDO
		         REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
		         UNLOCK
		      ENDSCAN
		ENDCASE
		IF xirpta = [S] or xielige=1
		   INDEX ON NROMES+CODCTA+CODREF TAG ACCT01
		ENDIF
		*
		LsMsgProc=[Acumulando Saldos .....]
		SELECT RMOV
		FOR I= nMesIni TO nMesFin
		    cNroMes = TRANSF(i,"@L ##")
		    **@ 18,19 SAY PADC(MES(i,1),43)
		    SEEK cNroMes+TRIM(xscodcta)
		    DO WHILE ! EOF() AND NroMes = cNroMes AND CodCta = TRIM(xscodcta)
		       LsCodCta = CodCta
		       =SEEK(LsCodCta,"CTAS")
		       XX = " "
		       LsMsgProc =MES(VAL(cNroMes),1)+[ Procesando cuenta : ]+LsCodCta+XX+PADC(TRIM(CTAS.NomCta),40)
		       DO WHILE !EOF() AND NroMes+CodCta=cNroMes+LsCodCta
		          **@ 19,46 SAY XX
		          XX = IIF(XX=" ",":"," ")
		          IF !CodOpe = "9"
			   IF   !GoCfgCbd.Tipo_Conso=2 
				DO cbdactct with CodCta, CodRef, i, TpoMov , Import, ImpUsa
		             ELSE
		         		DO cbdactct with CodCta, CodRef, i, TpoMov , Import, ImpUsa, CodDiv	    
		             ENDIF
		          ELSE
			   IF   !GoCfgCbd.Tipo_Conso=2 
				DO cbdactec with CodCta, CodRef, i, TpoMov , Import, ImpUsa
		             ELSE
		         		DO cbdactec with CodCta, CodRef, i, TpoMov , Import, ImpUsa, CodDiv	    
		             ENDIF

		          ENDIF
		          SELECT RMOV
		          SKIP
		       ENDDO
		       LsMsgProc =MES(VAL(cNroMes),1)+[ Procesando cuenta : ]+LsCodCta+XX+PADC(TRIM(CTAS.NomCta),40)

		    ENDDO
		ENDFOR
		LsMsgProc = [Proceso terminado]
		RETURN
	ENDPROC


	*-- Carga Vector con divisiones del sistema
	PROCEDURE cap_divis
		*!*	******************
		*!*	FUNCTION Cap_Divis
		*!*	******************
		private nd
		nd=0
		IF !USED([AUXI])
			lReturnOk=THIS.Odatadm.AbrirTabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
			IF !lReturnOk
				this.serr='Imposible acceder a la tabla de auxiliares CBDMAUXI.DBF'
				RETURN lReturnOk
			ENDIF
		ENDIF
		SELE AUXI
		SEEK [DV]
		SCAN WHILE ClfAux=[DV]
			nd=nd+1
			IF ALEN(vDivision)<nd
				DIMENSION vdivision(nd+1)
			ENDIF
			vDivision(nd)=CodAux+[ ]+LEFT(NomAux,20)
		ENDSCAN
		IF nd<=0
			vDivision(1)=[*** No hay divisiones registradas	***]
		ELSE
			GnDivis=nd
			Dimension vDivision(nd+1)
			vDivision(nd+1) = [*** Total Consolidado ***] 
		ENDIF
		USE
		RETURN .T.
	ENDPROC


	PROCEDURE cbdacumd
		*!*	******************
		*!*	PROCEDURE CBDACUMD
		*!*	******************
		*  Nombre    : CbdAcumd.PRG                                              *
		*  Autor     : VETT                                                      *
		*  Objeto    : Acumulador de Cuentas                                     *
		*  Creaci_n  : 1999/Enero/15                                             *
		*  Par�metros:   XsCodCta : Codigo de la Cuenta                          *
		*                XnMesIni : Mes de inicio a acumulador                   *
		*                XnMesFin : Mes de fin a acumular                        *
		*                XsCodRef : Cod. de Referencia                           *
		*    ******************* Moneda Nacional ********************            *
		*               XvCalc( 1): Importe Debe C�lculado del mes fin  ...      *
		*               XvCalc( 2): Importe Haber C�lculado del mes fin ...      *
		*               XvCalc( 3): Importe Saldo C�lculado del mes fin ...      *
		*               XvCalc( 4): Importe Acumulado Debe C�lculado    ...      *
		*               XvCalc( 5): Importe Acumulado Haber C�lculado   ...      *
		*               XvCalc( 6): Saldo Acumulado C�lculado   ..........       *
		*    ******************* Moneda Extranjera ******************            *
		*               XvCalc( 7): Importe Debe C�lculado del mes fin           *
		*               XvCalc( 8): Importe Haber C�lculado del mes fin          *
		*               XvCalc( 9): Importe Saldo C�lculado del mes fin          *
		*               XvCalc(10): Importe Acumulado Debe C�lculado             *
		*               XvCalc(11): Importe Acumulado Haber C�lculado            *
		*               XvCalc(12): Saldo Acumulado C�lculado                    *
		*                                                                        *
		*                                                                        *
		**************************************************************************
		PARAMETERS XsCodCta , XnMesIni , XnMesFin , XsCodRef
		PRIVATE TnMes,xLLave,xSelect,KK
		xSelect = SELECT()
		IF XnMesIni < 0  .OR. XnMesFin < 0
		   XnMesIni = ABS( XnMesIni )
		   XnMesFin = ABS( XnMesFin )
		ENDIF
		SELECT ACCT
		STORE 0 TO XvCalc,XvCalc_D
		TnMes = XnMesIni
		DO WHILE TnMes <= XnMesFin
		   IF PARAMETER() < 4
		      xLLave = STR(TnMes,2,0)+XsCodCta
		   ELSE
		      xLLave = STR(TnMes,2,0)+XsCodCta+XsCodRef
		   ENDIF
		   SEEK xLlave
		   DO WHILE (NroMes+CodCta+CodRef = xLLave ) .AND. ! EOF()
		      XvCalc( 4) = XvCalc( 4) + DbeNac  && Debe  Acumulado Moneda Nacional
		      XvCalc( 5) = XvCalc( 5) + HbeNac  && Haber Acumulado Moneda Nacional
		      XvCalc(10) = XvCalc(10) + DbeExt  && Debe  Acumulado Moneda Extranjera
		      XvCalc(11) = XvCalc(11) + HbeExt  && Haber Acumulado Moneda Extranjera
		      ** Acumulando  por Division **
		      FOR KK=1 to GnDivis
			  		XsCmpDbe1= [DBENAC]+LEFT(vDivision(kk),2)
			  		XsCmpHbe1= [HBENAC]+LEFT(vDivision(kk),2)
			  		XsCmpDbe2= [DBEEXT]+LEFT(vDivision(kk),2)
			  		XsCmpHbe2= [HBEEXT]+LEFT(vDivision(kk),2)
					XvCalc_D(kk,04) = XvCalc_D(kk,04) + EVAL(XsCmpDbe1)
					XvCalc_D(kk,05) = XvCalc_D(kk,05) + EVAL(XsCmpHbe1)
					XvCalc_D(kk,10) = XvCalc_D(kk,10) + EVAL(XsCmpDbe2)
					XvCalc_D(kk,11) = XvCalc_D(kk,11) + EVAL(XsCmpHbe2)
					IF TnMes=XnMesFin
						XvCalc_D(KK,01) = XvCalc_D(KK,01) + EVAL(XsCmpDbe1)
						XvCalc_D(KK,02) = XvCalc_D(KK,02) + EVAL(XsCmpHbe1)
						XvCalc_D(kk,07) = XvCalc_D(kk,07) + EVAL(XsCmpDbe2)
						XvCalc_D(kk,08) = XvCalc_D(kk,08) + EVAL(XsCmpHbe2)
					ENDIF
		      ENDFOR
		      RELEASE KK
		      IF TnMes = XnMesFin
		         XvCalc( 1) = XvCalc( 1) + DbeNac    && Debe  del Mes Moneda Nacional
		         XvCalc( 2) = XvCalc( 2) + HbeNac    && Haber del Mes Moneda Nacional
		         XvCalc( 7) = XvCalc( 7) + DbeExt    && Debe  del Mes Moneda Extranjera
		         XvCalc( 8) = XvCalc( 8) + HbeExt    && Haber del Mes Moneda Extranjera
		      ENDIF
		      SKIP
		   ENDDO
		   TnMes = TnMes + 1
		ENDDO
		*** Saldos *************************
		XvCalc( 3) = XvCalc( 1) - XvCalc( 2)  && Saldo del Mes Moneda Nacional
		XvCalc( 6) = XvCalc( 4) - XvCalc( 5)  && Saldo Acumulado Moneda Nacional
		XvCalc( 9) = XvCalc( 7) - XvCalc( 8)  && Saldo del Mes Moneda Extranjera
		XvCalc(12) = XvCalc(10) - XvCalc(11)  && Saldo Acumulado Moneda Extranjera
		FOR kk= 1 TO GnDivis
			XvCalc_D(kk, 3) = XvCalc_D(kk, 1) - XvCalc_D(kk, 2)  && Saldo del Mes Moneda Nacional
			XvCalc_D(kk, 6) = XvCalc_D(kk, 4) - XvCalc_D(kk, 5)  && Saldo Acumulado Moneda Nacional
			XvCalc_D(kk, 9) = XvCalc_D(kk, 7) - XvCalc_D(kk, 8)  && Saldo del Mes Moneda Extranjera
			XvCalc_D(kk,12) = XvCalc_D(kk,10) - XvCalc_D(kk,11)  && Saldo Acumulado Moneda Extranjera
		ENDFOR
		RELEASE KK
		SELECT (xSelect)
		RETURN
	ENDPROC


	*-- Define variables publicas de contabilidad
	PROCEDURE setvarpublic
		Public GsAnoMes,GsPeriodo,GsNroMes
		Public _Mes, _Ano, XsNroMes
		*!*	PUBLIC GsClfCli ,GsClfPro,GnDivis ,GsClfVen ,GfgTasaDia
		PUBLIC GnDivis ,GfgTasaDia
		PUBLIC Nulo,Simple ,Doble,Bloque  
		_Mes = Month(Date())
		_Ano = Year(Date())
		LsAAAAMM=this.Cap_aaaamm()
		_ANO=VAL(LEFT(LsAAAAMM,4))
		_MES=VAL(RIGHT(LsAAAAMM,2))
		this.oentorno.GsPeriodo=LsAAAAMM  
		THis.odatadm.oEntorno.GsPeriodo=LsAAAAMM 
		Nulo       = 0
		Simple     = 1
		Doble      = 2
		Bloque     = 3
		XsNroMes = TRAN(_MES,"@L 99")
		*** OJO : Falta configurar para que tome estos valores segun configuracion VETT 07-06-2002
		lreturnok=this.odatadm.abrirTabla('ABRIR','ADMTCNFG','TCNFG','','')
		IF lreturnok
			SELECT TCNFG
			SCAN FOR CodCfg='CFG'
				LsVar = Variable
				PUBLIC &LsVar
				&LsVar = ClfAux
			*!*		GsClfCli = 'CLI'   && Debe de cogerlos de una tabla de configuracion
			*!*		GsClfPro = 'PRO'   && Debe de cogerlos de una tabla de configuracion
			*!*		GsClfVen = 'VEN'
			ENDSCAN 
			USE IN TCNFG
		ENDIF

		PUBLIC vDivision,XvCalc,XvCalc_D,VecOpc
		GnDivis=0
		DIMENSION vDivision(1)
		this.Cap_divis()
		DIMENSION XvCalc(12),VecOpc(3),XvCalc_D(GnDivis+1,12)
		STORE 0 TO XvCalc,XvCalc_D


		** Variables para impresion con libreria antigua y @ Say
		PUBLIC _prn0,_prn1,_prn2,_prn3,_prn4,_prn5a,_prn5b,_prn6a,_prn6b,_prn7a,_prn7b,;
		   _prn8a,_prn8b,_prn9a,_prn9b,_prn10a,_prn10b
		STORE "" TO _prn0,_prn1,_prn2,_prn3,_prn4,_prn5a,_prn5b,_prn6a,_prn6b,;
		   _prn7a,_prn7b,_prn8a,_prn8b,_prn9a,_prn9b,_prn10a,_prn10b

		PUBLIC EN1,EN2,EN3,EN4,EN5,EN6,EN7,EN8,EN9
		STORE '' TO EN1,EN2,EN3,EN4,EN5,EN6,EN7,EN8,EN9
		PUBLIC _Nombre,_Interface,_Comando,_Driver,_Archivo,_Destino,_FontName,_FontSize,_FonStyle
		_nombre    = SET('PRINTER',3)
		_interface = ""
		_comando   = ""
		_driver    = "Epson.pdt"   && Erase una vez el DOS 
		_archivo   = ""
		_destino   = 1

		PUBLIC GoCfgCbd
		lreturnok=this.odatadm.abrirTabla('ABRIR','CBDCNFG0','CNFG0','','')
		LOCATE
		IF EOF()
			this.sErr='No existe configuraci�n general del sistema'
			RETURN .f.
		ENDIF
		SCATTER name GoCfgCbd
		USE in CNFG0
		RESTORE FROM THIS.oentorno.tspathcia+'vtaCONFG.MEM' ADDITIVE
		this.XfPorIgv = CFGADMIGV
		RETURN .t.
	ENDPROC


	*-- Se posiciona en registro a grabar
	PROCEDURE lineaactiva
		PARAMETERS _Alias,_llaveTabla,_Numreg,_lBloquea
		IF PCOUNT()<1
			ASSERT .F. MESSAGE 'Chochera son 3 parametros'
			RETURN -1
		ENDIF
		IF !VARTYPE(_llaveTabla)='C'
			ASSERT  .f. message 'Chochera la llave de la tabla es tipo character'
			RETURN -1
		ENDIF
		IF EMPTY(_NumReg)
			_NumReg = -1
		ENDIF
		IF EMPTY(_alias)
			_Alias = ALIAS()
		ENDIF
		IF EMPTY(_Alias)
			RETURN -1
		ENDIF
		LOCAL lExiste
		lExiste=.f.
		DO CASE
			CASE GoEntorno.SqlEntorno		&& Servidor Remoto
				**  usar ADO para traer la llave del registro a actualizar
			CASE NOT GoEntorno.SqlEntorno   && Estamos con tablas nativas de VFP .DBC o DBFs Libres
				SELECT (_Alias)
				IF _Numreg > 0
					GO _Numreg
					lExiste = (RECNO()=_NumReg)
				ELSE
					lExiste=SEEK(_LlaveTabla,_Alias)
				ENDIF


		ENDCASE
		RETURN IIF(lExiste,1,2)
	ENDPROC


	*-- Actualiza saldos contables
	PROCEDURE cbdactct
		*** Actualiza el acumulado contable con divisionaria VETT 15/JUN/1999 ***
		PARAMETERS cCodCta , cCodRef , nNroMes , cTpoMov , nImport , nImpUsa , cDivision
		PRIVATE TnLen1 , TnLen2 , TnCont , TsCodCta , TnImpNac , TnImpExt, xSelect
		xSelect = SELECT()
		LsCodRef = cCodREf
		TnImpNac = nImport
		TnImpExt = nImpUsa
		TnLen1   = LEN(cCodCta)
		TnLen2   = LEN(TRIM(cCodCta))
		TnCont   = TnLen2
		** Control de la divisionaria **
		STORE .F. TO lActCmpDivH1,lActCmpDivD1,lActCmpDivH2,lActCmpDivD2
		IF PARAMETERS()>6
		    SELE ACCT
			LsCmpDivH1 = [HbeNac]+cDivision
			LsCmpDivD1 = [DbeNac]+cDivision
			LsCmpDivH2 = [HbeExt]+cDivision
			LsCmpDivD2 = [DbeExt]+cDivision
			STORE .t. TO lActCmpDivH1,lActCmpDivD1,lActCmpDivH2,lActCmpDivD2
			IF TYPE(LsCmpDivH1)#[N]
				lActCmpDivH1=.f.
			ENDIF
			IF TYPE(LsCmpDivD1)#[N]
				lActCmpDivD1=.f.
			ENDIF
			IF TYPE(LsCmpDivH2)#[N]
				lActCmpDivH2=.f.
			ENDIF
			IF TYPE(LsCmpDivD2)#[N]
				lActCmpDivD2=.f.
			ENDIF
		ELSE
			STORE [] TO LsCmpDivH1,LsCmpDivD1,LsCmpDivH2,LsCmpDivD2
		ENDIF
		**
		DO WHILE TnCont > 0
		   TsCodCta = LEFT(cCodCta,TnCont)+SPACE(TnLen1-TnCont)
		   SELECT CTAS
		   SET ORDER TO CTAS01
		   SEEK TsCodCta
		   IF FOUND()
		      SELECT ACCT
		      SEEK STR(nNroMes,2,0) + TsCodCta + LsCodRef
		      IF ! FOUND()
		         APPEND BLANK
		      ENDIF

		      IF RLOCK()
		         REPLACE CodCta WITH TsCodCta
		         REPLACE CodRef WITH LsCodRef
		         REPLACE NroMes WITH STR(nNroMes,2,0)
		         IF cTpoMov = 'D'
		            REPLACE DbeNac WITH DbeNac+TnImpNac
		            REPLACE DbeExt WITH DbeExt+TnImpExt
		            ** Divisi�n **
		            IF lActCmpDivD1
			            REPLACE (LsCmpDivD1) WITH EVAL(LsCmpDivD1) + TnImpNac
		            ENDIF
		            IF lActCmpDivD2
			            REPLACE (LsCmpDivD2) WITH EVAL(LsCmpDivD2) + TnImpExt
		            ENDIF
		         ELSE
		            REPLACE HbeNac WITH HbeNac+TnImpNac
		            REPLACE HbeExt WITH HbeExt+TnImpExt
		            ** Divisi�n **
		            IF lActCmpDivH1
			            REPLACE (LsCmpDivH1) WITH EVAL(LsCmpDivH1) + TnImpNac
		            ENDIF
		            IF lActCmpDivH2
			            REPLACE (LsCmpDivH2) WITH EVAL(LsCmpDivH2) + TnImpExt
		            ENDIF
		         ENDIF
		      ENDIF
		      LsCodRef = SPACE(LEN(LsCodRef))
		      UNLOCK
		   ENDIF
		   TnCont = TnCont - 1
		ENDDO
		SELECT (xSelect)
		RETURN
	ENDPROC


	*-- Trae el tipo de cuenta
	PROCEDURE cap_tpocta
		PARAMETERS _cTabla,_cCodcta
		IF VARTYPE(_cTabla) != 'C'
			assert .f. MESSAGE 'El par�metro debe ser un codigo de cuenta tipo caracter'
		endif
		IF VARTYPE(_cCodcta) != 'C'
			assert .f. MESSAGE 'El par�metro debe ser un codigo de cuenta tipo caracter'
		endif
		LOCAL LsTipoCuenta,lsCierraArea,LsAreaActual
		STORE '' TO LsTipoCuenta,lsCierraArea1,LsAreaActual,lsCierraArea2
		LsAreaActual = ALIAS()
		IF !USED('CTAS')
			=goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
			LsCierraArea1 =  ALIAS()
		ENDIF
		IF !(LsAreaActual == 'CTAS' )
			=SEEK(_cCodCta,'CTAS','CTAS01')
		ENDIF
		LnTpoCta = CTAS.TpoCta
		IF !USED('TABL')
			=goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
			LsCierraArea2 = ALIAS()
		ENDIF

		SELECT Nombre FROM TABL WHERE  _cCodCta>=Trim(codcta) and _cCodCta<=Trim(CodAdd);
						 AND Digitos=LnTpoCta ;
						 AND Tabla = _cTabla ;
				INTO CURSOR xtmp

		LsNombre = xTmp.Nombre
		USE IN XTMP
		IF isnull(LsNomBre)
			LsNombre = 'No definido en la tabla' 
		ENDIF
		IF EMPTY(LsNomBre)
			LsNombre = 'Tipo de cuenta mal definido en la tabla'
		ENDIF
		IF !EMPTY(LsCierraArea1)
			USE IN (LsCierraArea1)
		ENDIF
		IF !EMPTY(LsCierraArea2)
			USE IN (LsCierraArea2)
		ENDIF
		IF !EMPTY(LsAreaActual)
			SELECT (LsAreaActual)
		ENDIF

		RETURN LsNombre
		** OJO se supone que debemos estar en la tabla cbdmctas , alias CTAS
		*!*	IF _cCodCta >= '60'
		*!*	   DO CASE
		*!*	      CASE TpoCta = 1
		*!*	         @ 12,55 SAY "Naturaleza          "
		*!*	      CASE TpoCta = 2
		*!*	         @ 12,55 SAY "Funcion             "
		*!*	      CASE TpoCta = 3
		*!*	         @ 12,55 SAY "Naturaleza y Funcion"
		*!*	      OTHER
		*!*	         @ 12,55 SAY "Ninguna             "
		*!*	   ENDCASE
		*!*	ELSE
		*!*	   DO CASE
		*!*	      CASE TpoCta = 1
		*!*	         @ 12,55 SAY "Activo Corriente    "
		*!*	      CASE TpoCta = 2
		*!*	         @ 12,55 SAY "Activo no Corriente "
		*!*	      CASE TpoCta = 3
		*!*	         @ 12,55 SAY "Pasivo Corriente    "
		*!*	      CASE TpoCta = 4
		*!*	         @ 12,55 SAY "Pasivo no Corriente "
		*!*	      CASE TpoCta = 5
		*!*	         @ 12,55 SAY "Patrimonio          "
		*!*	      OTHER
		*!*	         @ 12,55 SAY "Seg�n Saldo         "
		*!*	   ENDCASE
		*!*	ENDIF
	ENDPROC


	*-- Obtiene el periodo de proceso actual a�o y mes -> aaaamm
	PROCEDURE cap_aaaamm
		PARAMETERS _cModulo
		IF PARAMETERS() = 0
			_cModulo = ''
		ENDIF
		LOCAL LsAAAAMM
		IF !VARTYPE(_cmodulo)='C'
			ASSERT .f. message 'Debe de pasar el modulo como parametro tipo caracter'
			RETURN ''
		ENDIF

		_cModulo = UPPER(_cModulo)
		GOENTORNO.OPEN_DBF1('ABRIR','CBDTANOS','TANO','','')


		SELECT TANO
		LOCATE FOR !Cierre
		IF FOUND()
			GoEntorno.GsPeriodo = STR(Periodo,4,0)
			GsPeriodo = GoEntorno.GsPeriodo
			_ANO = Periodo
			DO CASE 
				CASE _cModulo= 'CBD'
					_MES = MesCont
				CASE _cModulo= 'ALM'
					_MES = MesCont
				CASE _cModulo= 'VTA'
					_MES = MesCont
				CASE _cMODULO= 'CPI'
					_MES = MesCont
				CASE _cModulo= 'CJA'
					_MES = MesCont
				OTHERWISE 
					_MES = MesCont
			ENDCASE 
			LsAAAAMM = TRANSFORM(_ANO,'9999')+TRANSFORM(_MES,'@L 99')
		ENDIF
		USE IN TANO
		RETURN LsAAAAMM
	ENDPROC


	*-- Metodo principal que inicia la actualizacion de asientos contables
	PROCEDURE actualiza_contabilidad
		PARAMETERS _que_transaccion,cParm1
		**PROCEDURE xAct_Ctb
		** Por ahora este componente es STATEFULL 
		** Requerira analisis adicional para hacerlo STATELESS - VETT 05-09-2003 02:24pm
		_Que_Transaccion=UPPER(_Que_Transaccion)
		nErrCode = S_OK
		DO CASE 
			CASE _Que_transaccion='VENTAS'
				* Abrimos Base de Datos *
				PRIVATE _MES,_ANO,DirCtb,UltTecla
				PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
				PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
				PRIVATE XfImport,XdFchDoc,XdFchVto
				PRIVATE XsNroMes,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,XsCodOpe,XsNroAst,TsCodDiv1
				PRIVATE XiNroItm,XsCodDiv,XsCtaPre,XcAfecto,XsCodCco,GlInterface,XsCodDoc,XsNroDoc 
				PRIVATE XsNroRef,XsCodFin,XdFchdoc,XdFchVto,XsIniAux,XdFchPed,NumCta,XsNivAdi
				PRIVATE XcTipoC,XsTipDoc,XsAn1Cta,XsCc1Cta,XsChkCta, nImpUsa, nImpNac,vCodCta
				PRIVATE RegVal ,NCLAVE,VCLAVE
				RegVal   = "&NClave = VClave"
				UltTecla = 0

				_MES = MONTH(GDOC->FchDoc)
				_ANO = YEAR(GDOC->FchDoc)
		        this.oDatAdm.oentorno.GsPeriodo=TRANSFORM(_ANO,'9999')+TRANSFORM(_MES,'@L 99')
		        this.oEntorno.GsPeriodo=TRANSFORM(_ANO,'9999')+TRANSFORM(_MES,'@L 99')
				IF _MES<=5 AND INLIST(UPPER(GsNomCia),'CEVA','ARAUCARIA') AND _ANO=2003
					RETURN  
				ENDIF
				*DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
		*		SET STEP ON 
				IF !this.oDatAdm.Open_File('CTB')   
				   RETURN
				ENDIF
				XsNroMes = GDOC->NroMes
				XsCodOpe = GDOC->CodOpe
				XsNroAst = GDOC->NroAst
				NClave   = [NroMes+CodOpe+NroAst]
				VClave   = XsNroMes+XsCodOpe+XsNroAst

				IF EMPTY(GDOC.CodOpe) AND EMPTY(GDOC.NroAst) AND EMPTY(GDOC.NroMes)
					THIS.Crear = .T.
				ELSE
					IF !EMPTY(GDOC.CodOpe) AND !EMPTY(GDOC.NroAst) AND !EMPTY(GDOC.NroMes)
						THIS.Crear = .F.
					ELSE
						THIS.Crear = .T.
					ENDIF
				ENDIF
				IF GDOC.FlgEst='A'
					_Que_transaccion = 'VENTAS_ANULAR'
					XsNotAst = [ANULADA:]+[PROV. ]+GDOC->CodDoc+[. ]+GDOC->NomCli
					XsNroVou = GDOC.NroDoc
				ENDIF
				IF _Que_transaccion = 'VENTAS_ANULAR'
					this.MovBorra(XsNroMes,XsCodOpe,XsNroAst)
					this.oDatAdm.Close_File('CTB')
					RETURN
				ENDIF
				* Grabamos Cabecera *
				** Valores Fijos
				GlInterface = .f.
				TsCodDiv1= '01'
				XsCodDiv=TsCodDiv1
				XcAfecto = 'A'
				** Valores variables inicializados como STRING
				dimension vcodcta(10)
				STORE {} TO XdFchDoc,XdFchVto,XdFchPed
				STORE '' TO XsCodCco ,XsCodDoc,XsNroDoc,XsNroRef,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
				STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
				** Valores variables inicializados como NUMERO
				STORE 0 TO nImpNac,nImpUsa,NumCta

				**
				XsNroMes = IIF(THIS.Crear,TRANS(_MES,"@L ##"),XsNroMes)
				XdFchAst = GDOC->FchDoc
				XsNroVou = []
				XiCodMon = GDOC->CodMon
				XfTpoCmb = GDOC->TpoCmb
				XsNotAst = [PROV. ]+GDOC->CodDoc+[. ]+GDOC->NomCli

		        =seek(gdoc.coddoc,"TDOC")
				XsCodOpe = IIF(THIS.Crear,TDOC.CodOpe,XsCodOpe)
				IF this.MOVGRABA(XsNroMes,XsCodOpe,@XsNroAst) = 0
					REPLACE GDOC->NroMes WITH XsNroMes
					REPLACE GDOC->CodOpe WITH XsCodOpe
					REPLACE GDOC->NroAst WITH XsNroAst
					REPLACE GDOC->FlgCtb WITH .T.
					NClave   = [NroMes+CodOpe+NroAst]
					VClave   = XsNroMes+XsCodOpe+XsNroAst
				ELSE
					this.oDatAdm.Close_File('CTB')
					RETURN AST_CABECERA_NO_GRABO
				ENDIF
				*

				* Grabamos Detalle *
					* Cuenta de Factura
					=SEEK(GDOC->CodDoc,"TDOC")
					XiNroItm = 1
					XcEliItm = [ ]
					XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
					XsCodRef = GDOC->CodDoc
					=SEEK(XsCodCta,"CTAS")
					IF CTAS->PIDAUX="S"
					   XsClfAux = CTAS.ClfAux
					   XsCodAux = GDOC->CodCli
					   XsNroRuc = GDOC->RucCli
					ELSE
					   XsClfAux = SPACE(LEN(RMOV.ClfAux))
					   XsCodAux = SPACE(LEN(RMOV.CodAux))
					   XsNroRuc = SPACE(LEN(RMOV.NroRuc))
					ENDIF
					XcTpoMov = [D]
					XfImport = GDOC->ImpTot
					IF XiCodMon = 1
					   XfImpNac = XfImport
					   XfImpUsa = XfImport/XfTpoCmb
					ELSE
					   XfImpUsa = XfImport
					   XfImpNac = XfImport*XfTpoCmb
					ENDIF
					XsGloDoc = GDOC->NomCli

					IF ctas.PidDoc='S'
						XsCodDoc = IIF(SEEK(cParm1,'DOCM'),DOCM.TpoDocSN,'')    &&GDOC->CodDoc
						XsNroDoc = GDOC->NroDoc
						XsNroRef = GDOC->NroRef
						XdFchDoc = GDOC->FchDoc
						XdFchVto = GDOC->FchVto
					ELSE
						XsCodDoc = []
						XsNroDoc = []
						XsNroRef = []
						XdFchDoc = {}
						XdFchVto = {}
					ENDIF
					this.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
					**=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(C_RMOV.NroItm,5),0,'','')
					* Cuenta de Impuestos
					XcEliItm = [ ]
					XsCodCta = PADR(TDOC.CTA40,LEN(CTAS.CodCta))      && Del plan de cuentas
					XsCodRef = []
					=SEEK(XsCodCta,"CTAS")
					IF CTAS->PIDAUX="S"
					   XsClfAux = CTAS.ClfAux
					   XsCodAux = GDOC->CodCli
					   XsNroRuc = GDOC->RucCli
					ELSE
					   XsClfAux = SPACE(LEN(RMOV.ClfAux))
					   XsCodAux = SPACE(LEN(RMOV.CodAux))
					   XsNroRuc = SPACE(LEN(RMOV.NroRuc))
					ENDIF
					XcTpoMov = [H]
					XfImport = GDOC->ImpIgv
					IF XiCodMon = 1
					   XfImpNac = XfImport
					   XfImpUsa = XfImport/XfTpoCmb
					ELSE
					   XfImpUsa = XfImport
					   XfImpNac = XfImport*XfTpoCmb
					ENDIF
					XsGloDoc = []
					IF CTAS.PidDoc='S'
						XsCodDoc = IIF(SEEK(GsCodSed+XsCodDoc,'DOCM'),DOCM.TpoDocSN,'')    &&GDOC->CodDoc
						XsNroDoc = GDOC->NroDoc
						XsNroRef = GDOC->NroRef
						XdFchDoc = GDOC.FchDoc
						XdFchVto = GDOC.FchVto
					ELSE
						XsCodDoc = []
						XsNroDoc = []
						XsNroRef = []
						XdFchDoc = {}
						XdFchVto = {}
					ENDIF
					XiNroItm = XiNroItm + 1
					this.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','') 
					* Cuenta 7
					**>> =SEEK(GDOC->CodDoc+GDOC->NroDoc,"DETA")
					**>> =SEEK(LEFT(DETA->CodMat,LEN(FAMI->CodFam)),"FAMI")
					XcEliItm = [ ]
					XsCodCta = PADR(TDOC.Cta70,LEN(CTAS.CodCta))

					XsCodRef = GDOC->CodDoc
					=SEEK(XsCodCta,"CTAS")
					IF CTAS->PIDAUX="S"
					   XsClfAux = CTAS.ClfAux
					   XsCodAux = GDOC->CodCli
					   XsNroRuc = GDOC->RucCli
					ELSE
					   XsClfAux = SPACE(LEN(RMOV.ClfAux))
					   XsCodAux = SPACE(LEN(RMOV.CodAux))
					   XsNroRuc = SPACE(LEN(RMOV.NroRuc))
					ENDIF
					XcTpoMov = [H]
					XfImport = GDOC->ImpBto-GDOC->ImpDto &&-GDOC->ImpInt-GDOC->ImpAdm
					IF XiCodMon = 1
					   XfImpNac = XfImport
					   XfImpUsa = XfImport/XfTpoCmb
					ELSE
					   XfImpUsa = XfImport
					   XfImpNac = XfImport*XfTpoCmb
					ENDIF
					XsGloDoc = []
			*		XsCodDoc = GDOC->CodDoc
					IF CTAS.PidDoc='S'
						XsCodDoc = IIF(SEEK(XsCodDoc,'DOCM'),DOCM.TpoDocSN,'')    &&GDOC->CodDoc
						XsNroDoc = GDOC->NroDoc
						XsNroRef = GDOC->NroRef
						XdFchDoc = GDOC.FchDoc
						XdFchVto = GDOC.FchVto
					ELSE
						XsCodDoc = []
						XsNroDoc = []
						XsNroRef = []
						XdFchDoc = {}
						XdFchVto = {}
					ENDIF
					XiNroItm = XiNroItm + 1
					this.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
					* * * *
				SELE VMOV
				*cResp = []
				*cResp = AVISO(10,[>>>>>>>>>>>>************<<<<<<<<<<<<<<],;
				*              [>>>>  coloque formato de VOUCHER en su impresora  <<<<],[Presione barra espaciadora para continuar],;
				*              3,[ ],0,.T.,.F.,.T.)
				*DO ImprVouc IN VTAMMOVM
		   	   this.oDatAdm.Close_File('CTB')

			RETURN nErrCode
		ENDCASE
	ENDPROC


	PROCEDURE cap_nroitm
		PARAMETERS _Llave,_Tabla_alias,_CmpLLave,_CmpNroItm,_Filter
		LOCAL LsArea_act
		LsArea_act=SELECT() 
		LnParms=PARAMETERS()

		IF LnParms<4
			_CmpNroItm = 'NroItm'
		ENDIF
		LsValCmpNroItm = _Tabla_alias+'.'+_CmpNroItm
		Cur_Temp = SYS(2015)
		IF INLIST(VARTYPE(&LsValCmpNroItm),'U','D','T','L')
			RETURN -1
		ENDIF 
		IF !VARTYPE(&LsValCmpNroItm)='N'
			LcSql1 = "SELECT TRANSFORM(VAL(IIF(ISNULL(MAX("+_CmpNroItm+")),'',max("+_CmpNroItm+")))+1) AS "
		ELSE
			LcSql1 = "SELECT IIF(ISNULL(MAX("+_CmpNroItm+")),0,max("+_CmpNroItm+")) + 1 AS " 
		ENDIF

		LcSql=LcSql1+_CmpNroItm + " FROM "+_tabla_alias+" WHERE "+;
				 _CmpLlave + " = '" +_LLAve+ "' INTO CURSOR " + CUR_TEMP
				 
		&LCSQL		 


		VarNroItm = 'm.'+_CmpNroItm
		CampoCursor = Cur_temp+'.'+_CmpNroItm
		*select max(nroitm)+1 as nroitm from (_Tabla_alias) where &_CmpLLave=_Llave into cursor cur_temp
		IF _TALLY  = 0	&& Creando registro por primera vez

			&VarNroItm = 1

		ELSE
			&VarNroItm = EVALUATE(CampoCursor) 
		ENDIF
		use in (cur_temp)
		SELECT (LsArea_act)
		RETURN EVALUATE(VarNroItm)
	ENDPROC


	*-- Genera asiento segun modelo (Tipo)
	PROCEDURE gen_ast
		PARAMETERS Modelo,Cabecera,aImp ,Visualiza
		IF PARAMETER()<=1
		   DO F1MsgErr WITH "Error en env�o de parametros"
		   RETURN
		ENDIF
		****  Inicio de conversi�n de datos ****
		IF PARAMETERS()<7
			this.lpinta = .f.
		ELSE
			this.lPinta=Visualiza
		ENDIF

		this.NroDec   = 4
		this.Crear    = .T.
		OK = .T.
		ScrMov   = ""
		XsNroMes = TRANSF(_MES,"@L ##")
		lDesBal = .T.
		lTpoCorr = 1
		this.Modificar= .T.
		DO CASE
		   CASE this.Cabecera AND EMPTY(This.TsNroAst)
		        LinIni    = Yo
		        LinAct    = LinIni + 1
		   CASE !Cabecera
		        LinIni    = Yo
		        LinAct    = LinIni + 1
		ENDCASE
		STORE "" TO XsNroAst,XsNotAst,XiCodMon,XsNroVou,XsCodOpe
		STORE "" TO nImpNac,nImpUsa,Ngl,XsCodMod
		DIMENSION vNroAst(10),vCodCta(10),vCodAux(10),vNroDoc(10),vFchVto(10),vTotCta(10)
		DIMENSION vCodMon(10),vCodDoc(10),vImport(10),vNroRef(10),vNroItm(10),vFchDoc(10)
		DIMENSION vTpoMov(10),vCodRef(10),vGloDoc(10),vClfAux(10),sImport(10),vCodDo1(10)
		DIMENSION vImp(4)

		*!*	STORE [] TO V1,V2,V3,V4
		*STORE 0 TO L1,L2,L3,L4
		DIMENSION  THIS.V_IMP(ALEN(AIMP))


		FOR K= 1 TO ALEN(this.v_imp)
			this.v_imp(K) = aImp(K)
			LsVar= 'V'+TRANSFORM(K,'@L 9')
			this.AddProperty(LsVar,this.v_imp(K))
		ENDFOR 

		STORE [] TO vNroAst,vCodCta,vCodAux,vNroDoc,vFchVto,vNroCaj
		STORE [] TO vCodMon,vCodDoc,vImport,vNroRef,vNroItm,vFchDoc
		STORE [] TO vTpoMov,vCodRef,vGloDoc,vClfAux,sImport,vcoddo1
		sFmt = "9,999,999.99"
		MaxEle1 = 0

		STORE 0 TO vImp
		iDigitos=0
		**********************
		** Rutina Principal **
		**********************
		XsCodMod = Modelo
		UltTecla = 0
		DO WHILE UltTecla <> K_Esc
		   SELE VMDL
		   SEEK XsCodMod
		   IF !FOUND()
		       UltTecla = 0
		       RETURN AST_TIPO_NO_EXISTE
		   ENDIF
		   IF this.lPinta
				&& Colocar rutina para visualizar item del asiento mientras se genera 
		      DO CASE
		         CASE THIS.Cabecera AND EMPTY(THIS.TsNroAst)
		**              DO cbdprmov.spr  
		         CASE !THIS.Cabecera
		**              DO cbdprmov.spr
		      ENDCASE
		   ENDIF
		   THIS.Tot_Imp = 0
		   this.MOVEImpG       && Pide importe de seg�n # de glosas del modelo
		   IF UltTecla = K_Esc
		      EXIT
		   ENDIF
		   this.MOVSlMov    && Pide el c�digo de operaci�n a ingresar
		   **** Correlativo Mensual ****
		   SELECT RMOV
		   SET ORDER TO RMOV01
		   SELECT VMOV
		   SET ORDER TO VMOV01
		   THIS.MOVNoDoc
		   SELECT VMOV
		   IF this.CREAR         && TOMAMOS DATOS DEL MODELO
		      THIS.MovInvar
		   ELSE
		      THIS.MovMover
		   ENDIF
		   THIS.Movedita
		   ** Tomamos datos de modelo
		   THIS.MovGeRmov             && GENERAMOS DETALLE DEL ASIENTO SEG�N MODELO
		   THIS.MovBrowM
		   THIS.MovGrabM
		   SELE VMOV
		   UNLOCK ALL
		   EXIT
		ENDDO
		RETURN
	ENDPROC


	*-- Configura los importes  que intervienen en el modelo
	PROCEDURE moveimpg
		*!*	******************
		*!*	PROCEDURE MOVEimpG
		*!*	******************
		PRIVATE i
		Ngl = 0
		STORE 0 TO V1,V2,V3,V4
		FOR kk = 1 TO 4
		    LsGlosa = "GIMPO"+TRANS(kk,"9")
		    IF !EMPTY(&LsGlosa)
		       Ngl = Ngl + 1
		    ENDIF
		ENDFOR
		LinImp = 3
		IF !EMPTY(VMDL->GImpo1)
		   LinImp = LinImp + 1
		ENDIF
		IF !EMPTY(VMDL->GImpo2)
		   LinImp = LinImp + 1
		ENDIF
		IF !EMPTY(VMDL->GImpo3)
		   LinImp = LinImp + 1
		ENDIF
		IF !EMPTY(VMDL->GImpo4)
		   LinImp = LinImp + 1
		ENDIF
		IF LinIMp<4
		   GsMsgErr = "Asiento tipo/modelo no esta bien definido"

		   UltTecla = K_Esc
		   RETURN TIPO_ASIENTO_NE
		ENDIF
		ColImp = LEN(Gimpo1) + 1
		FOR kk = 1 TO 4
		    Campo = "L"+TRANS(kk,"9")
		    Campo2= "V"+TRANS(kk,"9")
		   *IF &Campo<>0
		       &Campo2 = TRANS(&Campo ,"9999999.99")
		   *ENDIF
		    this.Tot_Imp = this.Tot_Imp +  &Campo
		ENDFOR
		RETURN
	ENDPROC


	PROCEDURE movinvar
		*!*	PROCEDURE MOVInVar
		XsNroVou = SPACE(LEN(VMOV.NROVOU))
		XiCodMon = 1
		XsNotAst = SPACE(LEN(VMOV.NOTAST))
		XsDigita = GsUsuario
		RETURN
	ENDPROC


	PROCEDURE movmover
		**>>PROCEDURE MOVMover
		XdFchAst = VMOV.FchAst
		XsNroVou = VMOV.NroVou
		XiCodMon = VMOV.CodMon
		XfTpoCmb = VMOV.TpoCmb
		XsNotAst = VMOV.NOTAST
		XsDigita = VMOV.Digita
	ENDPROC


	PROCEDURE movedita
		*!*	PROCEDURE MOVEdita
		UltTecla = 0
		IF ! this.Crear
		   IF !F1_RLock(5)
		      *DO F1MsgErr WITH "Asiento usado por otro usuario"
		      UltTecla = k_Esc
		      RETURN REGISTRO_BLOQUEADO              && No pudo bloquear registro
		   ENDIF
		ENDIF
		SELECT TCMB
		SEEK DTOC(XdFChAst,1)
		IF ! FOUND()
		   OK = .F.
		   ?? chr(7)
		   WAIT "T/Cambio no registrado" NOWAIT WINDOW
		   GOTO BOTTOM
		ENDIF
		IF Crear
		   XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
		ENDIF
		IF ! OK
		   APPEND BLANK
		   REPLACE FCHCMB WITH XdFchast
		ENDIF
		IF OPER->TpoCmb=1
		   IF OFICMP = 0
		      REPLACE OFICMP WITH XfTpoCmb
		   ENDIF
		ELSE
		   IF OFIVTA = 0
		      REPLACE OFIVTA WITH XfTpoCmb
		   ENDIF
		ENDIF
		SELECT VMOV
		RETURN
	ENDPROC


	PROCEDURE movnodoc
		**>> PROCEDURE MOVNoDoc
		XsNroAst = NROAST()
		this.Crear = .t.
		** Posicionamos en el ultimo registro + 1 **
		SELECT VMOV
		IF OPER->TPOCOR = 1
		   SEEK (XsNroMes+XsCodOpe+Chr(255))
		ELSE
		   SEEK (XsCodOpe+Chr(255))
		ENDIF
		IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
		   GOTO RECNO(0)
		ELSE
		   GOTO BOTTOM
		   IF ! EOF()
		      SKIP
		   ENDIF
		ENDIF
		IF this.Cabecera AND !EMPTY(this.TsNroAst)
		   XsNroAst = THIS.TsNroAst
		ENDIF
		SELE VMOV
		SEEK XsNroMes+XsCodOpe+XsNroAst
		IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
		   XsNroAst = NROAST()
		   this.Crear = .t.
		   IF this.Cabecera
		      this.TsNroAst = XsNroAst
		      SELE VMOV
		   ENDIF
		ELSE
		   XsNroAst = VMOV->NroAst
		  *DO MovPinta
		   IF !this.Cabecera
		      this.MovBorra
		   ENDIF
		   this.Crear = .f.
		ENDIF
		SELECT VMOV
		RETURN
	ENDPROC


	*-- Graba cabecera del asiento
	PROCEDURE movgraba
		**>>PROCEDURE MOVGraba
		PARAMETERS __XsNroMes , __XsCodOpe , __XsNroAst
		nErrCode = S_OK
		UltTecla = 0
		IF this.Crear                  && Creando
		   SELE OPER
		   SEEK XsCodOpe
		   IF !FOUND()
				UltTecla = k_Esc
				RETURN AST_OPERACION_NO_EXISTE
		   ENDIF
		   IF ! F1_RLock(5)
		      UltTecla = k_Esc
		      RETURN REGISTRO_BLOQUEADO           
		   ENDIF
		   SELECT VMOV
		   SEEK (__XsNroMes + __XsCodOpe + __XsNroAst)
		   IF FOUND() OR EMPTY(__XsNroAst)
		      __XsNroAst = this.NROAST()
		      SEEK (__XsNroMes + __XsCodOpe + __XsNroAst)
		      IF FOUND()
		         UltTecla = K_Esc
		         RETURN REGISTRO_YA_EXISTE
		      ENDIF
		   ENDIF
		   APPEND BLANK
		   REPLACE VMOV->NROMES WITH __XsNroMes
		   REPLACE VMOV->CodOpe WITH __XsCodOpe
		   REPLACE VMOV->NroAst WITH __XsNroAst
		   IF THIS.Crear
		     REPLACE VMOV->FLGEST  WITH "R"   && Asiento Tipo ??
		   ELSE
		     REPLACE VMOV->FLGEST  WITH "R"
		   ENDIF
		   replace vmov.fchdig with date()
		   replace vmov.hordig with time()
		   SELECT OPER
		   this.NROAST(__XsNroAst)
		   SELECT VMOV
		ELSE
		   *** ACTUALIZA CAMBIOS DE LA CABECERA EN EL CUERPO ***
		   IF VMOV->FchAst <> XdFchAst .OR. VMOV->NroVou <> XsNroVou
		      SELECT RMOV
		      Llave = (__XsNroMes + __XsCodOpe +__XsNroAst )
		      SEEK Llave
		      DO WHILE ! EOF() .AND. Llave = (NroMes + CodOpe + NroAst )
		         IF Rlock()
		            REPLACE RMOV->FchAst  WITH XdFchAst
		            IF VARTYPE(NroVou)='C'
			            REPLACE RMOV.NroVou  WITH XsNroVou
			        ENDIF    
		            UNLOCK
		         ENDIF
		         SKIP
		      ENDDO
		   ENDIF
		   SELECT VMOV
		ENDIF
		REPLACE VMOV->FchAst  WITH XdFchAst
		REPLACE VMOV->NroVou  WITH XsNroVou
		REPLACE VMOV->CodMon  WITH XiCodMon
		REPLACE VMOV->TpoCmb  WITH XfTpoCmb
		REPLACE VMOV->NotAst  WITH XsNotAst
		REPLACE VMOV->Digita  WITH GsUsuario
		IF VARTYPE(GlAsientoTipo)='L'
			IF this.Tot_Imp = 0 AND !This.Cabecera
			   REPLACE VMOV->NotAst  WITH " A N U L A D O "
			   REPLACE FLGEST WITH "R"
			   REPLACE VMOV->DbeNac  WITH 0
			   REPLACE VMOV->DbeUsa  WITH 0
			   REPLACE VMOV->HbeNac  WITH 0
			   REPLACE VMOV->HbeUsa  WITH 0
			ENDIF
		ENDIF
		THIS.Crear = .F.
		RETURN nErrCode
	ENDPROC


	*-- Genera o captura el numero de asiento
	PROCEDURE nroast
		**FUNCTION NROAST
		PARAMETER XsNroAst
		LOCAL LnLen_ID
		DO CASE
		   CASE XsNroMES = "00"
		     iNroDoc = OPER.NDOC00
		   CASE XsNroMES = "01"
		     iNroDoc = OPER.NDOC01
		   CASE XsNroMES = "02"
		     iNroDoc = OPER.NDOC02
		   CASE XsNroMES = "03"
		     iNroDoc = OPER.NDOC03
		   CASE XsNroMES = "04"
		     iNroDoc = OPER.NDOC04
		   CASE XsNroMES = "05"
		     iNroDoc = OPER.NDOC05
		   CASE XsNroMES = "06"
		     iNroDoc = OPER.NDOC06
		   CASE XsNroMES = "07"
		     iNroDoc = OPER.NDOC07
		   CASE XsNroMES = "08"
		     iNroDoc = OPER.NDOC08
		   CASE XsNroMES = "09"
		     iNroDoc = OPER.NDOC09
		   CASE XsNroMES = "10"
		     iNroDoc = OPER.NDOC10
		   CASE XsNroMES = "11"
		     iNroDoc = OPER.NDOC11
		   CASE XsNroMES = "12"
		     iNroDoc = OPER.NDOC12
		   CASE XsNroMES = "13"
		     iNroDoc = OPER.NDOC13
		   OTHER
		     iNroDoc = OPER.NRODOC
		ENDCASE
		LnLen_ID = OPER.Len_ID
		IF OPER.ORIGEN
		   iNroDoc = VAL(TsCodDiv1+XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ########"),4))
		ENDIF
		IF PARAMETER() = 1
		   IF VAL(XsNroAst) > iNroDoc
		     iNroDoc = VAL(XsNroAst) + 1
		   ELSE
		     iNroDoc = iNroDoc + 1
		   ENDIF
		   DO CASE
		      CASE XsNroMES = "00"
		        REPLACE   OPER.NDOC00 WITH iNroDoc
		      CASE XsNroMES = "01"
		        REPLACE   OPER.NDOC01 WITH iNroDoc
		      CASE XsNroMES = "02"
		        REPLACE   OPER.NDOC02 WITH iNroDoc
		      CASE XsNroMES = "03"
		        REPLACE   OPER.NDOC03 WITH iNroDoc
		      CASE XsNroMES = "04"
		        REPLACE   OPER.NDOC04 WITH iNroDoc
		      CASE XsNroMES = "05"
		        REPLACE   OPER.NDOC05 WITH iNroDoc
		      CASE XsNroMES = "06"
		        REPLACE   OPER.NDOC06 WITH iNroDoc
		      CASE XsNroMES = "07"
		        REPLACE   OPER.NDOC07 WITH iNroDoc
		      CASE XsNroMES = "08"
		        REPLACE   OPER.NDOC08 WITH iNroDoc
		      CASE XsNroMES = "09"
		        REPLACE   OPER.NDOC09 WITH iNroDoc
		      CASE XsNroMES = "10"
		        REPLACE   OPER.NDOC10 WITH iNroDoc
		      CASE XsNroMES = "11"
		        REPLACE   OPER.NDOC11 WITH iNroDoc
		      CASE XsNroMES = "12"
		        REPLACE   OPER.NDOC12 WITH iNroDoc
		      CASE XsNroMES = "13"
		        REPLACE   OPER.NDOC13 WITH iNroDoc
		      OTHER
		        REPLACE   OPER.NRODOC WITH iNroDoc
		   ENDCASE
		   UNLOCK IN OPER
		ENDIF
		RETURN  RIGHT(repli("0",LnLen_ID) + LTRIM(STR(iNroDoc)), LnLen_ID)
	ENDPROC


	*-- Borra asiento contable
	PROCEDURE movborra
		PARAMETERS __Nromes,__CodOpe,__NroAst,__SoloDet


		IF PARAMETERS()=0
			__NroMes=XsNroMes
			__CodOpe=XsCodOpe
			__NroAst=XsNroAst
		ENDIF
		IF PARAMETERS()<4
			__SoloDet = .f.
		ENDIF
		nErrCode = S_OK
		Llave = (__NroMes + __CodOpe + __NroAst )
		SELECT VMOV
		SEEK Llave
		IF .NOT. F1_RLock(5)
		*!*	   GsMsgErr = "Asiento usado por otro usuario"
		*!*	   =MESSAGEBOX(GsMsgErr,16,'Atenci�n')
		   UltTecla = K_esc
		   RETURN REGISTRO_BLOQUEADO 
		ENDIF
		***> Enviar mensaje de estado   WITH 10
		SELECT RMOV
		Llave = (__NroMes + __CodOpe + __NroAst )
		SEEK Llave
		ok     = .t.
		DO WHILE ! EOF() .AND.  ok .AND. ;
		   Llave = (NroMes + CodOpe + NroAst )
		   IF Rlock()
		      SELECT RMOV
		      IF ! XsCodOpe = "9"
		         this.CBDACTCT(CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv)
		      ELSE
		         this.CBDACTEC(CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv)
		      ENDIF
		      ** Anulamos Provisi�n del Proveedor **
		     *IF RMOV.CodCta=[421] .AND. RMOV.TpoMov=[H]
		         ** Buscamos documento Provisionado
		         IF USED('DPRO')
			         IF SEEK(__NroMes+__CodOpe+VMOV.NroVou,"DPRO")
			            IF RLOCK("DPRO")
			               SELE DPRO
			               REPLACE FLGEST WITH 'A'
			               UNLOCK IN "DPRO"
			               SELE RMOV
			            ENDIF
			         ENDIF
		         ENDIF
		     *ENDIF
		      SELE RMOV
		      DELETE
		      UNLOCK
		   ELSE
		      ok = .f.
		   ENDIF
		   SKIP
		ENDDO
		SELECT VMOV
		LnTotItm=goSvrCbd.Cap_NroItm(__NroMes + __CodOpe + __NroAst,'RMOV','NroMes+CodOpe+NroAst')
		REPLACE VMOV.NroItm WITH IIF(LnTotItm>0,LnTotItm -1,0)
		IF OK AND !__SoloDet
		   REPLACE FlgEst WITH "A"    && Marca de anulado
		   REPLACE Notast WITH 'A~N~U�L�A�D�O'
		ENDIF
		IF VARTYPE(UltTecla)<>'N'
			UltTecla = 0
		ENDIF
		IF UltTecla = F1 AND __SoloDet
		   DELETE
		ENDIF
		UNLOCK ALL

		RETURN nErrCode 
	ENDPROC


	*-- Actualizacion extracontable
	PROCEDURE cbdactec
		*** Actualiza el acumulado contable ***
		PARAMETERS cCodCta , cCodRef , nNroMes , cTpoMov , nImport , nImpUsa
		PRIVATE TnLen1 , TnLen2 , TnCont , TsCodCta , TnImpNac , TnImpExt, xSelect
		xSelect = SELECT()
		LsCodRef = cCodREf
		TnImpNac = nImport
		TnImpExt = nImpUsa
		TnLen1   = LEN(cCodCta)
		TnLen2   = LEN(TRIM(cCodCta))
		TnCont   = TnLen2
		DO WHILE TnCont > 0
		   TsCodCta = LEFT(cCodCta,TnCont)+SPACE(TnLen1-TnCont)
		   SELECT CTAS
		   SET ORDER TO CTAS01
		   SEEK TsCodCta
		   IF FOUND()
		      SELECT ACCT
		      SEEK STR(nNroMes,2,0) + TsCodCta + LsCodRef
		      IF ! FOUND()
		         APPEND BLANK
		      ENDIF

		      IF RLOCK()
		         REPLACE CodCta WITH TsCodCta
		         REPLACE CodRef WITH LsCodRef
		         REPLACE NroMes WITH STR(nNroMes,2,0)
		         IF cTpoMov = 'D'
		            REPLACE Db2Nac WITH Db2Nac+TnImpNac
		            REPLACE Db2Ext WITH Db2Ext+TnImpExt
		         ELSE
		            REPLACE Hb2Nac WITH Hb2Nac+TnImpNac
		            REPLACE Hb2Ext WITH Hb2Ext+TnImpExt
		         ENDIF
		      ENDIF
		      LsCodRef = SPACE(LEN(LsCodRef))
		      UNLOCK
		   ENDIF
		   TnCont = TnCont - 1
		ENDDO
		SELECT (xSelect)
		RETURN
	ENDPROC


	PROCEDURE movbveri
		************************************************************************ FIN *
		* Objeto : Verificar si debe generar cuentas autom�ticas
		******************************************************************************
		**PROCEDURE MovbVeri
		PARAMETERS PsKeyRegAct,PnNroReg,PsAn1Cta,PsCc1Cta
		IF !VARTYPE(PsKeyRegAct)=='C'
			=MESSAGEBOX('Imposible actualizar detalle de registro ')
			RETURN AST_DETALLE_NO_GRABO_PARM

		ENDIF

		IF !VARTYPE(PnNroReg)=='N'
			PnNroReg = 0
		ENDIF
		*** Debo posicionarme en el registro a grabar 
		*!*	LsKeyRegAct=C_RMOV.NroMes+C_RMOV.CodOPe+C_RMOV.NroAst+STR(C_RMOV.NroItm,5)
		LnReturn=this.LineaActiva('RMOV',PsKeyRegAct,PnNroReg)

		IF LnReturn<0
		**	=MESSAGEBOX('No se puede actualizar',16)
			RETURN AST_DETALLE_NO_GRABO
		ENDIF
		LlCreaDeta=IIF(LnReturn=1,.f.,.t.)
		**** Grabando la linea activa ****
		XcEliItm = " "
		IF TYPE("YcEliItm")= "C"
			XcEliItm=YcEliItm
		ENDIF
		XsAn1Cta=PsAn1Cta
		XsCc1Cta=PsCc1Cta
		this.MOVbGrab(LlCreaDeta)
		RegAct = RECNO('RMOV')
		*** Requiere crear cuentas automaticas ***
		=SEEK(XsCodCta,"CTAS")
		IF CTAS.GenAut <> "S"
		   IF ! LlCreaDeta
		      *** anulando cuentas autom�ticas anteriores ***
		      SELECT RMOV
		      SKIP 
		      Listar = .f.
		      XinroItm = NroItm
		**    DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "�"
		      DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"
		         Listar   = .T.
		         Refresco = .T.
		         DO BORRLIN IN Cbd_DiarioGeneral
		         REPLACE VMOV.NroItm  WITH VMOV.NroItm-1
		         SELECT RMOV
		         SKIP
		      ENDDO
		      IF Listar
		          DO RenumItms WITH XiNroItm IN Cbd_DiarioGeneral
		          ***!!!! GOTO NumRg(1)
		      ELSE
		         GOTO RegAct
		      ENDIF
		   ENDIF
		   RETURN
		ENDIF

		IF GlInterface 
			RETURN 1
		ENDIF
		**** Actualizando Cuentas Autom�ticas ****
		**XcEliItm = "�"
		** Validar generacion de cuentas automaticas
		XcEliItm = "*"
		TsClfAux = []
		TsCodAux = []
		IF EMPTY(PsAn1Cta)
			TsAn1Cta = CTAS.An1Cta
		ELSE
			TsAn1Cta = PsAn1Cta
		ENDIF
		IF EMPTY(PsCC1Cta)
			TsCC1Cta = CTAS.CC1Cta
		ELSE
			TsCC1Cta = PsCC1Cta
		ENDIF
		XsAn1Cta = ''
		XsCC1Cta = ''


		*** ATENCION: EL Codigo siguiente sera redefinido como un componente de negocio, por ahora nos valdremos
		*** de un case para usar el harcode que nos permita identificar claramente los casos que se dan en las empresas.
		*** VETT : 18/10/2002
		DO CASE
			*** CASO 1 : La cuentas automaticas no estan en predefinidas en el maestro de cuentas
			CASE EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
				*** Variante 1 : Utiliza la cuenta automatica para acumular otro auxiliar: EJEM; el tipo de gasto
			   TsClfAux = "04 "
			   TsCodAux = CTAS.TpoGto
			   TsAn1Cta = RMOV.CodAux
			   TsCC1Cta = CTAS.CC1Cta
			   TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
			   ** Verificamos su existencia **
			   IF ! SEEK("05 "+TsAn1Cta,"AUXI")
			      GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
			      =MESSAGEBOX(GsMsgErr,16,'Atenci�n')
			      RETURN 2
			   ENDIF
			   
			*** CASO 2 : La cuenta automatica no esta definida pero la contracuenta si.
			CASE EMPTY(TsAn1Cta) AND !EMPTY(TsCC1Cta)
				*** VAriante 1: La cuenta automatica es en base al centro de costo 
				*** Centro de costo pertenece a una tabla
				IF CTAS.PidCco="S" AND EMPTY(CTAS.AN1CTA)
				   TsAn1Cta = ALLT(XsCodCCo) + SUBS(CTAS.CodCta,2,2) + RIGHT(ALLT(CTAS.CodCta),1)
				   TsCC1Cta = IIF(EMPTY(CTAS.CC1Cta),gocfgcbd.cc1cta,CTAS.CC1Cta)
				ENDIF
				*** VAriante 2: La cuenta automatica es segun el auxiliar de la cuenta origen
				*** Centro de costo pertenece a una tabla
				IF ! SEEK(TsAn1Cta,"ctas")
					=SEEK(RMOV.COdCta,'CTAS')
					IF CTAS.ClfAux=RMOV.ClfAux		&& vett 18/10/2002
						TsAn1Cta = PADR(RMOV.CodAux,LEN(CTAS.COdCta))
					ENDIF
					IF ! SEEK(TsAn1Cta,"ctas")
						GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
				        =MESSAGEBOX(GsMsgErr,16,'Atenci�n')
						RETURN 2
					ENDIF
				ENDIF


		ENDCASE
		*** Direccionamos el auxiliar de las cuenta automatica generada por compra de existencias 60 vs clase 2
		   IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
		      IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
		         TsClfAux = XSCLFAUX
		         TsCodAux = XSCODAUX
		      ENDIF
		   ENDIF
		   IF ! SEEK(TsAn1Cta,"CTAS")
		      GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
		      =MESSAGEBOX(GsMsgErr,16,'Atenci�n')
		      RETURN
		   else
			   IF CTAS.CodCta==TsAn1Cta and ctas.mayaux="S"
			   		 IF CTAS.ClfAux=XsClfAux
				         TsClfAux = XSCLFAUX
				         TsCodAux = XSCODAUX
		    	     endif
			   endif
		   endif	   
		IF ! SEEK(TsCC1Cta,"CTAS")
		   GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
		   =MESSAGEBOX(GsMsgErr,16,'Atenci�n')
		   RETURN 2
		ENDIF
		*****
		DO CompBrows WITH .F. IN Cbd_DiarioGeneral
		SKIP
		LlCrearDeta = .T.
		**IF EliItm = "�" .AND. &RegVal
		IF EliItm = "*" .AND. &RegVal
		   LlCrearDeta  = .F.
		ENDIF
		** Grabando la primera cuenta autom�tica **
		IF LlCrearDeta 
		   XiNroItm = XiNroItm + 1
		ELSE
		   XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
		   DO  RenumItms WITH XiNroItm + 1 IN Cbd_DiarioGeneral
		ENDIF
		XsCodCta = TsAn1Cta
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux
		this.MOVbGrab(LlCrearDeta)
		DO CompBrows WITH LlCrearDeta IN Cbd_DiarioGeneral
		SKIP
		LlCrearDeta  = .T.
		**IF EliItm = "�" .AND. &RegVal
		IF EliItm = "*" .AND. &RegVal
		   LlCrearDeta  = .F.
		ENDIF
		** Grabando la segunda cuenta autom�tica **
		IF LlCrearDeta 
		   XiNroItm = XiNroItm + 1
		ELSE
		   XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
		   DO  RenumItms WITH XiNroItm + 1 IN Cbd_DiarioGeneral
		ENDIF
		XsCodCta = TsCC1Cta
		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = SPACE(LEN(RMOV.ClfAux))
		XsCodAux = SPACE(LEN(RMOV.CodAux))
		this.MOVbGrab(LlCrearDeta)
		RETURN 1
	ENDPROC


	PROCEDURE movbgrab
		**PROCEDURE MOVbgrab
		PARAMETERS Crear
		***> Enviar mensaje de estado   WITH 4
		LLReturnOk = .F.
		SELE RMOV
		IF Crear
		   APPEND BLANK
		ENDIF
		IF ! F1_RLock(5)
		   RETURN LLReturnOk
		ENDIF
		XsCodRef = ""
		IF SEEK(XsCodCta,"CTAS")
			&& Ojo esto es excluyente si mayoriza por auxiliar no lo hara por centro de costo y viceversa
			IF CTAS.MAYAUX = "S"    
				XsCodRef = PADR(XsCodAux,LEN(RMOV.CodRef))
			ELSE 
				IF CTAS.MAYCco = "S"
			   		XsCodRef = PADR(XsCodCCo,LEN(RMOV.CodRef))
				ENDIF
			ENDIF
		ENDIF
		IF Crear
		   REPLACE RMOV.NroMes WITH XsNroMes
		   REPLACE RMOV.CodOpe WITH XsCodOpe
		   REPLACE RMOV.NroAst WITH XsNroAst
		   REPLACE RMOV.NroItm WITH XiNroItm
		   REPLACE VMOV.NroItm WITH VMOV.NroItm + 1
		   replace rmov.fchdig  with date()
		   replace rmov.hordig  with time()
		ELSE
		   IF ! XsCodOpe = "9"
		      this.CBDACTCT(CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv)
		   ELSE
		      this.CBDACTEC(CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , COdDiv)
		   ENDIF
		   REPLACE VMOV.ChkCta  WITH VMOV.ChkCta-VAL(TRIM(RMOV.CodCta))
		   DO CalImp IN Cbd_DiarioGeneral
		   IF RMOV.TpoMov = 'D'
		      REPLACE VMOV.DbeNac  WITH VMOV.DbeNac-nImpNac
		      REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa-nImpUsa
		   ELSE
		      REPLACE VMOV.HbeNac  WITH VMOV.HbeNac-nImpNac
		      REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa-nImpUsa
		   ENDIF
		   ** anulamos Provision del Proveedor **
		  *IF LEFT(RMOV.CodCta,4)=[4211] .AND. RMOV.TpoMov=[D]
		      ** Buscamos documento Provisionado
		      IF USED('DPRO')
			      IF SEEK(RMOV.CodAux+[P]+RMOV.NroDoc,"DPRO")
			         IF RLOCK("DPRO")
			            REPLACE DPRO.NroAst WITH []
			           *REPLACE DPRO.FchAst WITH {,,}
			            REPLACE DPRO.FchAst WITH {  ,  ,    }           
			            REPLACE DPRO.FlgEst WITH [R]   && Recepcionado
			            UNLOCK IN "DPRO"
			         ENDIF
			      ENDIF
		      ENDIF
		   *ENDIF
		ENDIF
		*
		REPLACE RMOV.CodDiv WITH XsCodDiv
		*
		REPLACE RMOV.EliItm WITH XcEliItm
		REPLACE RMOV.FchAst WITH XdFchAst
		*** REPLACE RMOV.NroVou WITH XsNroVou && Esto va en la cabecera no jodan!
		REPLACE RMOV.CodMon WITH XiCodMon
		REPLACE RMOV.TpoCmb WITH XfTpoCmb
		REPLACE RMOV.FchDoc WITH XdFchAst
		REPLACE RMOV.CodCta WITH XsCodCta

		REPLACE RMOV.CodRef WITH XsCodRef
		REPLACE RMOV.ClfAux WITH XsClfAux
		REPLACE RMOV.CodAux WITH XsCodAux
		REPLACE RMOV.TpoMov WITH XcTpoMov
		replace RMOV.CtaPre WITH XsCtaPre
		replace RMOV.Afecto WITH XcAfecto
		replace RMOV.CodCCo WITH XsCodCCo


		IF GlInterface
			IF Oper.Siglas='RV'
				REPLACE Afecto WITH CTAS.Tip_Afe_RV
			ENDIF
			IF 	Oper.Siglas='RC'
				REPLACE Afecto WITH CTAS.Tip_Afe_RC
			ENDIF
		   REPLACE RMOV.Import WITH XfImpNac
		   REPLACE RMOV.ImpUsa WITH XfImpUsa
		ELSE
			IF OPER.CodMon = 4
			   REPLACE RMOV.Import WITH XfImpNac
			   REPLACE RMOV.ImpUsa WITH XfImpUsa
			ELSE
			   IF CodMon = 1
			      REPLACE RMOV.Import WITH XfImport
			      IF TpoCmb = 0
			         REPLACE RMOV.ImpUsa WITH 0
			       ELSE
			         REPLACE RMOV.ImpUsa WITH round(XfImport/TpoCmb,2)
			      ENDIF
			   ELSE
			      REPLACE RMOV.Import WITH round(XfImport*TpoCmb,2)
			      REPLACE RMOV.ImpUsa WITH XfImport
			   ENDIF
			ENDIF
		ENDIF
		REPLACE RMOV.GloDoc WITH XsGloDoc
		REPLACE RMOV.CodDoc WITH XsCodDoc
		REPLACE RMOV.NroDoc WITH XsNroDoc
		REPLACE RMOV.NroRef WITH XsNroRef
		REPLACE RMOV.CODFIN WITH XSCODFIN
		REPLACE RMOV.FchDoc WITH XdFchDoc
		REPLACE RMOV.FchVto WITH XdFchVto
		REPLACE RMOV.IniAux WITH XsIniAux
		IF VARTYPE(XsNroRuc)='C'
			REPLACE RMOV.NroRuc WITH XsNroRuc
		ENDIF
		REPLACE VMOV.ChkCta  WITH VMOV.ChkCta+VAL(TRIM(XsCodCta))
		IF CodCta=[10]
		   REPLACE RMOV.FchPed   WITH XdFchPed
		ENDIF
		IF TYPE([GenDifCmb])=[L]
		   IF GenDifCmb
		      REPLACE RMOV.FchPed WITH RMOV.FchAst
		   ENDIF
		ENDIF
		if empty(rmov.fchped)
		   *
		   if rmov.codcta=[40]
		      repla rmov.fchped with rmov.fchvto
		   else
		      do case
		         case this.chkcta(rmov.codcta)
		              repla rmov.fchped with rmov.fchvto
		         other
		              repla rmov.fchped with rmov.fchast
		      endcase
		   endif
		   *
		endif
		*
		if rmov.tpomov = [H]
		   if empty(xdfchped)     
		      repla rmov.fchped with rmov.fchvto
		   else
		      repla rmov.fchped with xdfchped
		   endif
		endif        
		*
		if rmov.codcta=[46] .and. inlist(rmov.codope,[016],[231],[241],[030],[031]) .and. rmov.tpomov=[H]
		   repla rmov.fchped with rmov.fchvto
		endif
		*
		if !empty(rmov.fchped) AND USED('DIAF')
		   repla rmov.fchped with iif(seek(dtos(rmov.fchped),[diaf]),diaf.fchven,rmov.fchped)
		endif
		*
		replace rmov.tpoo_c with xsnivadi
		*
		REPLACE RMOV.TipoC  WITH XcTipoC
		REPLACE RMOV.Tipdoc WITH Xstipdoc
		REPLACE RMOV.An1Cta WITH XsAn1Cta
		REPLACE RMOV.CC1Cta WITH XsCc1Cta
		REPLACE RMOV.ChkCta WITH XsChkCta
		*
		IF ! XsCodOpe = "9"
		   this.CBDACTCT(CodCta , CodRef , _MES , TpoMov , Import , ImpUsa , CodDiv)
		ELSE  && EXTRA CONTABLE
		   this.CBDACTEC(CodCta , CodRef , _MES , TpoMov , Import , ImpUsa , CodDiv)
		ENDIF
		SELECT RMOV
		DO CalImp IN CBD_DiarioGeneral

		IF RMOV.TpoMov = 'D'
		   REPLACE VMOV.DbeNac  WITH VMOV.DbeNac+nImpNac
		   REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa+nImpUsa
		ELSE
		   REPLACE VMOV.HbeNac  WITH VMOV.HbeNac+nImpNac
		   REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa+nImpUsa
		ENDIF
		*DO MovPImp
		** actualizamos Provision del Proveedor **
		IF LEFT(RMOV.CodCta,4)=[4211] .AND. RMOV.TpoMov=[D]
		   ** Buscamos documento
		   IF USED('DPRO')
			   IF SEEK(RMOV.CodAux+[R]+RMOV.NroDoc,"DPRO") 
			      IF RLOCK("DPRO")
			         REPLACE DPRO.NroAst WITH XsNroAst
			         REPLACE DPRO.FchAst WITH XdFchAst
			         REPLACE DPRO.FlgEst WITH [P]   && Provisionado
			         UNLOCK IN "DPRO"
			      ENDIF
			   ENDIF
		   ENDIF
		ENDIF
		*
		** ACTUALIZACION INFORMACION SUNAT
		*
		if inlist(xscodope,[065],[070],[072])
		   sele drmov
		   llave = [SUNAT]+xsnromes+xscodope+xsnroast+xscodcta1+xstipdoc1+xsnroref1
		   seek llave
		   if found()
		      IF ! F1_RLock(5)
		      		RETURN 
		      ENDIF
		      if xstipdoc = [NO]
		         delete
		      else
		         repla drmov.codcta   with xscodcta
		         repla drmov.tipdoc   with xstipdoc
		         repla drmov.nroref   with xsnroref
		         repla drmov.vctori   with xsfecori
		         repla drmov.impori   with xsimpori
		         repla drmov.tipori   with xstipori
		         repla drmov.numori   with xsnumori
		         repla drmov.n_poliza with xsnumpol
		         repla drmov.impnac1  with xsimpnac1
		         repla drmov.impnac2  with xsimpnac2
		      endif
		      unlock
		   else
		      if !inlist(xstipdoc,[NO],[  ])
		         llave = [SUNAT]+xsnromes+xscodope+xsnroast+xscodcta+xstipdoc+xsnroref
		         seek llave
		         if .not. found()
		             append blank
		         endif
		         **do registro
		         repla drmov.modulo   with [SUNAT]
		         repla drmov.nromes   with xsnromes
		         repla drmov.codope   with xscodope
		         repla drmov.nroast   with xsnroast
		         repla drmov.codcta   with xscodcta
		         repla drmov.tipdoc   with xstipdoc
		         repla drmov.nroref   with xsnroref
		         repla drmov.vctori   with xsfecori
		         repla drmov.impori   with xsimpori
		         repla drmov.tipori   with xstipori
		         repla drmov.numori   with xsnumori
		         repla drmov.n_poliza with xsnumpol
		         repla drmov.impnac1  with xsimpnac1
		         repla drmov.impnac2  with xsimpnac2
		         unlock
		      endif
		   endif
		endif
		*
		SELE RMOV
		UNLOCK
		LLReturnOk = .T.
		*
		GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recalculo"
		** Borrar los lib_mtec de el programa
		***> do lib_mtec WITH 99
		RETURN LLReturnOk
	ENDPROC


	PROCEDURE chkcta
		parameter _cta
		FOR KK = 1 TO NumCta - 1
		    IF vCodCta(kk)=_Cta
		       RETURN .T.
		    ENDIF
		ENDFOR
		RETURN .F.
	ENDPROC


	*-- Apertura de archivos
	PROCEDURE movapert
		** Abrimos areas a usar **
		LOCAL LReturOk

		LReturnOk=This.oDatAdm.abrirtabla('ABRIR','CBDTCIER','','')
		IF lReturnOk
			SELECT CBDTCIER
			RegAct = _Mes + 1
			THIS.Modificar = ! Cierre
			IF RegAct <= RECCOUNT()
			   GOTO RegAct
			   THIS.Modificar = ! Cierre
			ENDIF
			USE
		ENDIF

		LReturnOk=This.oDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
		LReturnOk=This.oDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')

		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
		** Archivo de Control de Documentos del Proveedor **
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CJADPROV','DPRO','DPRO06','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV02','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDDRMOV','DRMOV','DRMO01','')
		lopCTA2=.f.
		lopDIAF=.f.
		*
		lexiste=.t.
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','FLCJTBDF','DIAF','DIAF01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDMCTA2','CTA2','CTA201','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDTCNFG','CNFG','CNFG01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','CBDPPRES','PPRE','PPRE01','')
		lreturnok=This.oDatAdm.abrirtabla('ABRIR','ADMTCNFG','CNFG2','CNFG01','')
		RETURN lReturnOk
	ENDPROC


	PROCEDURE mensajeerr
		PARAMETERS TnId_Error
		IF TnId_error = 0
			RETURN 0
		ENDIF
		SELECT * from admin!sistlerr WHERE id_err = TnId_error INTO ARRAY aMensaje
		IF _TALLY>0
			RETURN MESSAGEBOX(amensaje(1,2),amensaje(1,4)+amensaje(1,5),aMensaje(1,6))
		ELSE
			RETURN MESSAGEBOX('Se ha producido un error no identificado',0+16,'Atenci�n!!/Atention!!')
		ENDIF
	ENDPROC


	PROCEDURE mescerrado
		PARAMETER _FchAst
		IF VARTYPE(_FchAst)='U'
			_FchAst = _MES
		ENDIF

		IF !INLIST(VARTYPE(_FCHAST),'N','T','D')
			ASSERT .f. MESSAGE 'El valor del parametro debe ser n�merico,fecha o fecha_hora'
			RETURN .F.
		ENDIF
		IF INLIST(VARTYPE(_FchAst),'T','D')
			PRIVATE LsDirCtb,TsPathDbf,TsPathCia,_ANO
			_MES       = MONTH(_FchAst)
			_ANO       = YEAR(_FchAst)
		ELSE
			_MES		= _FchAst
		ENDIF
		PRIVATE Modificar
		this.odatAdm.abrirtabla('ABRIR','CBDTCIER','CBDTCIER','','')
		IF !USED('CBDTCIER')
		   RETURN .F.
		ENDIF
		SELECT CBDTCIER  
		RegAct = _Mes + 1
		Modificar = ! Cierre
		IF RegAct <= RECCOUNT()
		   GOTO RegAct
		   Modificar = ! Cierre
		ENDIF
		USE   && << OJO <<
		*LoDatAdm.Close_file('CCB_CTB') 
		this.serr = ''
		IF !Modificar
		   GsMsgErr = [Mes Cerrado, no puede ser modificado]
		   this.serr = [Mes Cerrado, no puede ser modificado]
		   RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE Init
		this.oentorno=CREATEOBJECT('Dosvr.Env') 
		this.odatadm=CREATEOBJECT('Dosvr.DataAdmin')
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF SET("Development")='ON' 
			LnRpta=MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')


			DO CASE
				CASE  LnRpta =3
					SUSPEND 
				CASE  LnRpta =4 
					SET STEP ON 
				CASE  LnRpta =5
					retry
			ENDCASE

			RETURN CONTEXT_E_ABORTED
		ELSE

			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
			RETURN CONTEXT_E_ABORTED

		ENDIF
	ENDPROC


	*-- Verifica operaci�n contable
	PROCEDURE movslmov
	ENDPROC


	*-- Genera detalle del asiento segun modelo
	PROCEDURE movgermov
	ENDPROC


	PROCEDURE movbrowm
	ENDPROC


	*-- Graba asiento
	PROCEDURE movgrabm
	ENDPROC


	*-- Definicion de teclas pra compatibilizar programas antiguos
	PROCEDURE def_teclas_dos
	ENDPROC


ENDDEFINE
*
*-- EndDefine: contabilidad
**************************************************


**************************************************
*-- Class:        cpiplibf (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   02/16/03 06:47:10 PM
*
DEFINE CLASS cpiplibf AS custom OLEPUBLIC


	entidadcorrelativo = "CPICDOCM"
	tpo_pro = ""
	lsmovpro = ""
	smovsal = ""
	smoving = ""
	smovdev = ""
	snroo_t = ""
	tippro = ""
	zstporef = ""
	scodprd = ""
	fcanfin = 0
	fcanobj = 0
	srespon = ""
	scdarea = ""
	tipbat = 1
	ffactor = 1
	facant = 1
	salmsal = ""
	salming = ""
	salmdev = ""
	gntotdel = 0
	lpidodt = .T.
	lundstk = .T.
	lmonnac = .T.
	ncodmon = ""
	ftpocmb = 0
	sobserv = ""
	snrorf1 = ""
	snrorf2 = ""
	snroodt = ""
	scodcli = ""
	scodpro = ""
	scodven = ""
	scodaux = ""
	fimpbrt = 0
	fimptot = 0
	fimpigv = 0
	fporigv = 0
	sdesmov = ""
	glorf1 = ""
	glorf2 = ""
	glorf3 = ""
	lnohaystock = .T.
	codsed = ""
	nnumitmi = 0
	ntotmov = 0
	*-- Descripcion del error
	serr = ([])
	Name = "cpiplibf"
	lstkneg = .F.
	dfchdoc = .F.
	dfchfin = .F.
	cflgest = .F.
	haysalid1 = .F.
	haysalid2 = .F.
	haydevol1 = .F.
	haydevol2 = .F.
	hayingp_t = .F.
	hayingp_i = .F.
	lpidrf1 = .F.
	lpidrf2 = .F.
	lpidrf3 = .F.
	lpidven = .F.
	lpidcli = .F.
	lpidpro = .F.
	lmodpre = .F.
	lundvta = .F.
	lundcmp = .F.
	lmodcsm = .F.
	lafetra = .F.
	lextpco = .F.
	lpidpco = .F.
	lmonusa = .F.
	lmonelg = .F.
	lcapconfig = .F.
	nroo_t = .F.
	lactalm = .F.
	stit = .F.
	crear = .F.
	DIMENSION atipmov[1]
	DIMENSION acodmov[1]
	DIMENSION acmpeva[1]
	DIMENSION aevalua[1]
	DIMENSION aporp_t[1]
	DIMENSION acmpact1[1]
	DIMENSION acmpact2[1]
	DIMENSION adesmov[1]
	DIMENSION ahaymov[1]
	DIMENSION aimprimir[1]
	DIMENSION asubalm[1]
	DIMENSION aconfig[1,2]
	DIMENSION aregdel[1]


	PROCEDURE abrir_dbfs_cpi
		* Bases de datos **
		=F1QEH("ABRE_DBF")
		LlRetVal =  .T.
		SELE 0
		USE ALMCFTRA ORDER CFTR02 ALIAS CFTR
		IF !USED()
		    LlRetVal =  .F.
		ENDIF
		SELE CFTR
		SET FILTER TO EVAL(This.lsMovPro) AND UPPER(CMPEVA)=[CANFOR]

		GO TOP
		THIS.lStkNeg = CFTR.StkNeg
		USE
		*
		SELE 0
		USE ALMTALMA ORDER ALMA01 ALIAS ALMA AGAIN
		IF !USED()
		    LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
		IF !USED()
		    LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE ALMCATGE ORDER CATG01 ALIAS CATG AGAIN
		IF !USED()
		    LlRetVal =  .F.
		ENDIF
		SELE CATG
		SET RELA TO LEFT(codmat,4) INTO DIVF
		*
		ArcSql = GoEntorno.TmpPath+SYS(3)
		sele 0
		IF This.tpo_pro = [O_T ]     &&& O/T
		   select catg.codmat,catg.desmat,catg.undstk;
		          from almcatge catg, almtdivf divf;
		          where divf.clfdiv=[02] .and. divf.tipfam#1 .and. catg.codmat=divf.codfam;
		          group by catg.codmat;
		          order by catg.codmat;
		          into table &ArcSql.
		ELSE                     &&& TRANSFORMACION
		   select catg.codmat,catg.desmat,catg.undstk;
		          from almcatge catg, almtdivf divf;
		          where divf.clfdiv=[02] .and. inlist(catg.tipmat,[11],[20]) .and. catg.codmat=divf.codfam;
		          group by catg.codmat;
		          order by catg.codmat;
		          into table &ArcSql.
		ENDIF
		USE &ArcSql. alias form exclu
		if !used()
		   LlRetVal =  .F.
		endif
		index on codmat tag form01
		index on upper(desmat) tag form02
		set order to form01
		*
		SELE 0
		USE ALMCATAL ORDER CATA01 ALIAS CALM
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE CPICO_TB ORDER CO_T01 ALIAS CO_T
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE CPIDO_TB ORDER DO_T01 ALIAS DO_T
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE CPIPO_TB ORDER PO_T01 ALIAS PO_T
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE ALMCDOCM ORDER CDOC01 ALIAS CDOC
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE CPICFPRO ORDER cfpr01 ALIAS CFPRO
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		*
		SELE 0
		USE ALMTGSIS ORDER TABL01 ALIAS TABL
		IF !USED()
		   LlRetVal =  .F.   
		ENDIF
		*
		SELE 0
		USE ALMDTRAN ORDER DTRA01 ALIAS DTRA
		IF !USED()
		   LlRetVal =  .F.   
		ENDIF
		*
		*!*	ArcTmp = GoEntorno.TmpPath+SYS(3) &&& Este archivo vendria ser el Cursor Cpido_tb
		*!*	SELE 0
		*!*	CREAT TABL &ArcTmp. FREE (NroDoc  C(8),CodPro  C(8),TipPro  C(3),SubAlm C(3),;
		*!*		  CodMat C(8),DesMat C(40),UndPro C(3),FacEqu N(14,4),NroReg N(9),RegGrb N(9),;
		*!*		  CanSal N(14,4),CanSalA N(14,4),StkSal L(1),FlgSal L(1),CodSal C(14),;
		*!*		  CanFor N(14,4),CanForA N(14,4),StkFor L(1),FlgFor L(1),CodFor C(14),;
		*!*		  CanAdi N(14,4),CanAdiA N(14,4),StkAdi L(1),FlgAdi L(1),CodAdi C(14),;
		*!*		  CanDev N(14,4),CanDevA N(14,4),FlgDev L(1),CodDev C(14),CnFmla N(14,4) )

		*!*	USE &ArcTmp. ALIAS TEMPO EXCLU
		*!*	IF !USED()
		*!*	   LlRetVal =  .F.
		*!*	ENDIF
		*!*	INDEX ON NroDoc+TipPro+SubAlm+CodMat TAG DO_T01
		*
		ArcExt = GoEntorno.TmpPath+SYS(3)
		CREAT TABL &ArcExt. FREE (NroDoc  C(8),CodPro  C(8),TipPro  C(3),SubAlm C(3),;
			  CodMat C(8),DesMat C(40),UndPro C(3),FacEqu N(14,4),NroReg N(9),RegGrb N(9),;
			  CanSal N(14,4),CanSalA N(14,4),StkSal L(1),FlgSal L(1),CodSal C(14),;
			  CanFor N(14,4),CanForA N(14,4),StkFor L(1),FlgFor L(1),CodFor C(14),;
			  CanAdi N(14,4),CanAdiA N(14,4),StkAdi L(1),FlgAdi L(1),CodAdi C(14),;
			  CanDev N(14,4),CanDevA N(14,4),FlgDev L(1),CodDev C(14),CnFmla N(14,4) )

		USE (ArcExt) ALIAS EXTORNO EXCLU
		IF !USED()
		   LlRetVal =  .F.
		ENDIF
		INDEX ON NroDoc+TipPro+SubAlm+CodMat TAG DO_T01
		*
		IF !LlRetVal 
			this.serr=[Fall� apertura de archivos]
		ELSE
			*=F1QEH("Listo")
		ENDIF
		return LlRetVal
	ENDPROC


	PROCEDURE inicializavariablescfg


		This.lStkNeg = .F.
		*
		This.sMovSal = []
		This.sMovIng = []
		This.sMovDev = []
		*
		This.TipPro   = [P/T]      && Producto Terminado
		This.ZsTpoRef = This.tpo_pro  && Ordenes de trabajo automaticas ---> O J O
		This.sNroO_T  = []
		This.dFchDoc  = ttod(GdFecha)
		This.dFchFIn  = ttod(GdFecha)
		This.sCodPrd  = []
		This.fCanFin  = 0.000
		This.fCanObj  = 0.000
		This.sRespon  = []
		This.sCdArea  = []
		This.cFlgEst  = [P]     && Pendiente , Terminada, Anulada,
		This.tipbat   = 1      && 1 -> Normal , 2 -> Regularizaci�n no afecta
		*
		This.fFactor  = 1.00
		This.FacAnt   = 1.00
		This.sAlmSal  = []
		This.sAlmIng  = []
		This.sAlmDev  = []
		*
		* Variables de Control General
		*
		This.GnTotDel  = 0
		*
		* Control de Correlativo Multi-Usuario *
		*
		This.NroO_T = []
		*
		* Control de Actualizaci�n de Almacen
		*
		This.HAYSALID1 = .F.
		This.HAYSALID2 = .F.
		This.HAYDEVOL1 = .F.
		This.HAYDEVOL2 = .F.
		This.HAYINGP_T = .F.
		This.HAYINGP_I = .F.
		*
		* Variables de Configuraci�n de Transacciones de Almacen 
		*
		This.lPidRf1 = .F.
		This.lPidRf2 = .F.
		This.lPidRf3 = .F.
		This.lPidVen = .F.
		This.lPidCli = .F.
		This.lPidPro = .F.
		This.lPidOdT = .T.
		This.lModPre = .F.
		This.lUndStk = .T.
		This.lUndVta = .F.
		This.lUndCmp = .F.
		This.lModCsm = .F.
		*
		This.lAfeTra = .F.
		*
		This.lExtPco = .F.
		This.lPidPco = .F.
		This.lMonNac = .T.
		This.lMonUsa = .F.
		This.lMonElg = .F.
		*
		* Variables para Registros en Almacen
		*
		STORE [] TO This.nCodMon, This.fTpoCmb, This.sObserv, This.sNroRf1, This.sNroRf2, This.sNroOdt
		STORE [] TO This.sCodCli, This.sCodPro, This.sCodVen, This.sCodAux
		STORE [] TO This.sDesMov, This.GloRf1,  This.GloRf2,  This.GloRf3
		STORE 0  TO This.fImpIgv, This.fPorIgv, This.fImpBrt, This.fImpTot
		*
		* Variable de Control de Stock *
		*
		This.lNoHayStock = .T.
		*
		* Arreglos para Capturar Configuracion de Actualizaciones de Almacen 
		*
		DIME  This.aTipmov(1), This.aCodMov(1), This.aCmpEva(1),This.aEvalua(1),This.aPorP_T(1),;
		      This.aCmpAct1(1),This.aCmpAct2(1),This.aDesMov(1),This.aHayMov(1),This.aImprimir(1),;
		      This.aSubAlm(1)
		DIME  This.aConFig(1,2)
		STORE [] TO This.aTipmov,This.aCodMov,This.aCmpEva,This.aEvalua,This.aPorP_T,This.aCmpAct1,;
		            This.aCmpAct2,This.aHayMov,This.aImprimir,This.aSubAlm,This.aConFig

		THIS.nNumItmI= 0 && Numero de items a imprimir
		THIS.nTotMov = 0 && Numero de movimientos de almacen afectados por produccion
		IF THIS.nTotMov <=0
		   IF !This.ArrConfig()
		      this.serr="No existe configuraci�n para actualizar almacen"
		      =This.AbreDbfPro()
		      This.lActAlm = .F.
		   ENDIF
		ENDIF
		*
		This.lCapConfig = .F.
		*
	ENDPROC


	PROCEDURE arrconfig
		PRIVATE K
		IF !USED([CFTR])
		   USE ALMCFTRA ORDER CFTR02 ALIAS CFTR IN 0
		   IF !USED([CFTR])
		      this.serr=[No es posible abrir archivo de configuraci�n, ALMCFTRA]
		      RETURN .F.
		   ENDIF
		ENDIF
		*
		SELE CFTR
		GO TOP
		K = 0
		SCAN FOR eval(This.lsmovpro)
		     K=K+1
		     IF ALEN(This.aTipMov)<K
		        DIME This.aTipmov(K+5),This.aCodMov(K+5),This.aCmpEva(K+5),This.aEvalua(K+5),;
		             This.aPorP_T(K+5),This.aCmpAct1(K+5),This.aCmpAct2(K+5),This.aDesMov(K+5),;
		             This.aHayMov(K+5),This.aConFig(K+5,2)
		     ENDIF
		     This.aTipMov(K)  = TipMov
		     This.aCodMov(K)  = CodMov
		     This.aDesMov(K)  = DesMov
		     This.aCmpEva(K)  = CmpEva
		     This.aEvalua(K)  = Evalua
		     This.aPorP_T(K)  = PorP_T
		     This.aCmpAct1(K) = CmpAct1
		     This.aCmpAct2(K) = CmpAct2
		     This.aHayMov(K)  = .F.
		     This.aConfig(K,1)= .F.
		     This.aConfig(K,2)= .F.
		ENDSCAN
		USE
		*
		IF K>0
		   DIME This.aTipmov(K),This.aCodMov(K),This.aCmpEva(K),This.aEvalua(K),This.aPorP_T(K),;
		        This.aCmpAct1(K),This.aCmpAct2(K),This.adesMov(K),This.aHayMov(K),This.aConfig(K,2)
		   This.nTotMov = K
		   RETURN .T.
		ELSE
		   RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE abredbfpro
		=F1QEH("ABRE_DBF")
		LlRetVal =  .T.
		IF !USED('CFPRO')
			SELE 0
			USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
			IF !USED()
			    LlRetVal =  .F.      
			ENDIF
		ENDIF
		*
		IF !USED('DFPRO')
			SELE 0
			USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
			IF !USED()
			    LlRetVal =  .F.      
			ENDIF
		ENDIF
		*
		IF !LlRetVal 
			this.serr=[Fall� apertura de archivos]
		ELSE
			*=F1QEH("Listo")
		ENDIF
		RETURN LlRetVal
	ENDPROC


	PROCEDURE configtipoo_t

		do case
		   case this.tpo_pro = [O_T ]
		        this.sTit = [GENERACION DE ORDEN DE TRABAJO]
		        this.LsMovPro=[MovPro=1]
		   case this.tpo_pro = [TRB ]
		        this.sTit = [TRANSFORMACION]
		        LsMovPro=[MovPro=2]
		   case this.tpo_pro = [FRU ]
		        this.sTit = [PROCESO DE FRUTA]
		        this.LsMovPro=[MovPro=3]
		   case this.tpo_pro = [PRB ]
		        this.sTit = [PRODUCCION DE BOTELLAS]
		        this.LsMovPro=[MovPro=4]
		endcase
	ENDPROC


	PROCEDURE borra_registro_local_detalle
		*!*	IF !lBorra
		*!*	   =F1QEH("No es posible borrar registro")
		*!*	   RETURN
		*!*	ENDIF
		LOCAL m.RegAct
		m.RegAct = RECNO()
		IF TYPE([NroReg])=[N]
		   this.GnTotDel = this.GnTotDel + 1
		   IF ALEN(this.aRegDel)<this.GnTotDel
		      DIMENSION this.aRegDel(this.GnTotDel + 5)
		   ENDIF
		   this.aRegDel(this.GnTotDel) = NroReg
		ENDIF
		DELE
		SKIP +1
		*!*	blBorrar = .T.
	ENDPROC


	PROCEDURE cierdbfpro
		IF USED([CFPRO])
		   SELE CFPRO
		   USE
		ENDIF
		*
		IF USED([DFPRO])
		   SELE DFPRO
		   USE
		ENDIF
	ENDPROC


	PROCEDURE abredbfalm
		=F1QEH("ABRE_DBF")
		LlRetVal =  .T.
		IF !USED([CTRA])
		   SELE 0
		   USE ALMCTRAN ORDER CTRA01 ALIAS CTRA
		   IF !USED()
		      this.serr=[Error en apertura de archivo de almacen : ALMCTRAN]
		      
		      LlRetVal = .F.
		   ENDIF
		ENDIF
		*
		IF !USED([DTRA])
		   SELE 0
		   USE ALMDTRAN ORDER DTRA01 ALIAS DTRA
		   IF !USED()
		      this.serr=[Error en apertura de archivo de almacen : ALMDTRAN]
		      LlRetVal = .F.      
		   ENDIF
		ENDIF
		*
		IF !USED([ESTA])
		   SELE 0
		   USE ALMESTCM ORDER ESTA01 ALIAS ESTA
		   IF !USED()
		      this.serr=[Error en apertura de archivo de almacen : ALMESTCM]
		      LlRetVal = .F.      
		   ENDIF
		ENDIF
		*
		IF !USED([ESTR])
		   SELE 0
		   USE ALMESTTR ORDER ESTR01 ALIAS ESTR 
		   IF !USED()
		      this.serr=[Error en apertura de archivo de almacen : ALMESTTR]
		      LlRetVal = .F.      
		   ENDIF
		ENDIF
		*
		RETURN LlretVal
	ENDPROC


	PROCEDURE cierdbfalm
		IF USED([CTRA])
		   SELE CTRA
		   USE
		ENDIF
		*
		*IF USED([DTRA])
		*   SELE DTRA
		*   USE
		*ENDIF
		*
		IF USED([ESTA])
		   SELE ESTA
		   USE
		ENDIF
		*
		IF USED([ESTR])
		   SELE ESTR
		   USE
		ENDIF
	ENDPROC


	PROCEDURE chkmovact
		PARAMETER Campo
		PRIVATE K
		FOR K=1 TO GoCfgCpi.nTotMov
		    IF UPPER(GoCfgCpi.aCmpEva(K))=UPPER(Campo)
		       LsEvalua            = GoCfgCpi.aEvalua(K)
		       GoCfgCpi.aHayMov(K) = IIF(!GoCfgCpi.aHayMov(K),EVAL(LsEvalua),.T.)
		       EXIT
		    ENDIF
		ENDFOR
		RELEASE K
		RETURN
	ENDPROC


	PROCEDURE correlativo
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cpiplibf
**************************************************


**************************************************
*-- Class:        dataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   01/28/06 10:00:09 AM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS dataadmin AS custom OLEPUBLIC


	*-- Tabla o vista  con la que se va a trabajar
	ctabla = ([])
	*-- Campo(s) que pertenecen a la llave primaria (PK) de la tabla maestra
	ccampospk = ([])
	*-- Indice de la clave primaria  (PK) con el que se accesa a la tabla maestra
	cindicepk = ([])
	*-- Alias a asignar a la tabla maestra
	calias = ([])
	*-- Valor(es) de la clave primaria , si es mas de uno se pasa concatenado
	cvalorpk = ([])
	*-- Propiedad que vincula al objeto de entorno del sistema
	oentorno = .NULL.
	Name = "dataadmin"

	*-- Nombre de el cursor asignado al conjunto de datos resultante
	ccursor = .F.
	ccampos = .F.

	*-- Lista de valores  a actua�izar
	cvalores = .F.

	*-- Filtro adicional para la clausula where en la sentencia select que se genera
	cwhere = .F.

	*-- Mensaje de error
	serror = .F.

	*-- Campo por el que se ordena el cursor generado
	corder = .F.
	DIMENSION acampos[1]

	*-- Arreglo con los valores a actuallizar en la tabla
	DIMENSION avalores[1]


	*-- Trae un objecto cuyas propiedades son los campo de la tabla
	PROCEDURE genobjdatos
		LPARAMETERS _ctabla as String, _cIndice  as String , _cCamposPK as String ,_cValoresPK as String as Object
		 
		THIS.cTabla		= _ctabla
		THIS.cindicePK	= _cIndice
		this.cCamposPK	= _cCamposPK
		this.cValorPK 	= _cValoresPK
		this.calias		= IIF(EMPTY(this.calias),GoEntorno.TmpPath+SYS(3),this.cAlias)
		LOCAL LcRutaTabla
		LcRutaTabla=this.RutaTabla(THIS.Ctablamaestra)

		IF !USED(_CTABLA)

		*		THIS.Abrirtabla('ABRIR',_ctabla)
		ELSE
			DO CASE 
				CASE goentorno.VfpDbcEntorno
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE !deleted and "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias
					  
				CASE goentorno.AdoEntorno 
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias 
				CASE goentorno.SqlEntorno 
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE FlagEliminado=1 and "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias
			ENDCASE
		ENDIF
	ENDPROC


	*-- Trae un conjunto de registro de la tabla maestra (RecordSet)
	PROCEDURE gencursor
		LPARAMETERS _cAlias as String, _ctabla as String, _cIndice  as String , _cCamposPK as String ,_cValoresPK as String, _cWhere as String, _cOrder as String  

		LOCAL LsSql,LsSql1,LsWhere,LnNumReg

		THIS.Ctabla			= IIF(vartype(_ctabla)='U' or ISNULL(_ctabla) or EMPTY(_ctabla),'',_ctabla )
		THIS.cindicePK		= IIF(vartype(_cIndice)='U' or ISNULL(_cIndice) or EMPTY(_cIndice),'',_cIndice )
		this.cCamposPK		= IIF(vartype(_cCamposPK)='U' or ISNULL(_cCamposPK) or EMPTY(_cCamposPK),'',_cCamposPK )
		this.cValorPK 		= IIF(vartype(_cValoresPK)='U' or ISNULL(_cValoresPK) or EMPTY(_cValoresPK),'',_cValoresPK ) 
		this.calias			= IIF(EMPTY(_calias),SYS(2015) ,_cAlias)
		this.cWhere			= IIF(vartype(_cWhere)='U' or ISNULL(_cWhere) or EMPTY(_cWhere),'',_cWhere )
		this.corder			= IIF(vartype(_cOrder)='U' or ISNULL(_cOrder) or EMPTY(_cOrder),'',_cOrder )
		LOCAL LcRutaTabla
		* Si ya existe el cursor o alias abierto asuminos que es de ahi de donde debmos tomar los datos
		IF USED(this.cTabla)
			LcRutaTabla=this.cTabla
		ELSE
			LcRutaTabla=this.RutaTabla(THIS.cTabla)
		ENDIF

		IF EMPTY(LcRutaTabla)
			RETURN -1
		ENDIF
		LnNumReg = 0
		LsSql1	=	''
		LsSql	=	''
		LsWhere	=	''
		LlPrmView = .F.
		*IF !USED(_CTABLA)
		*	THIS.Abrirtabla()
		*ELSE
		** Esto es para las vistas recibimos los parametros y valores separados por :
		** Definimos las variables filtros de la vista recibidas en _cCamposPK
		** Y le asignamos los valores recibidos en _cValorPK
		** En _cCamposPK , deben venir los nombres de los parametros definidas en las vistas
		IF AT(":",this.cValorPK)>0 AND AT(":",this.cCamposPK)>0
			STORE '' TO LaValorPK,LaCamposPK
			this.chrtoarray( THIS.cCamposPK , ":" , @LaCamposPK )
			this.chrtoarray( THIS.cValorPK , ":" , @laValorPK )
			FOR LnNumCmp = 1 TO ALEN(LaCamposPK)
				LsCmpEva 	=	LaCamposPK(LnNumCmp)
				LsCampo		=   LaValorPK(LnNumCmp)
				&LsCmpEva.	=  LsCampo
			ENDFOR
			** Ahora ponemos en blanco los campos y valores 
			this.ccampospk = ''
			this.cvalorpk  = ''
		ENDIF

			DO CASE 
				CASE goentorno.VfpDbcEntorno
					LsSql1	=	"SELECT *,RECNO() as nroreg from " + (LcRutaTabla) 
					IF !EMPTY(this.cCamposPK ) AND !EMPTY(this.cValorPK)
						LsWhere =  " WHERE !DELETED() and "+ _cCamposPK +" = '"+ _cValoresPK + "' " 
					ENDIF
					IF !EMPTY(this.cWhere )
						IF EMPTY(LsWhere)
							LsWhere	=	" WHERE !DELETED() and " + this.cWhere
						ELSE
							LsWhere = LsWhere	+" AND " +	this.cWhere
						ENDIF
					ENDIF
					LsOrder = IIF(!EMPTY(this.cOrder),' ORDER BY '+this.cOrder+' ','')

					LsSql	=	LsSql1	+	LsWhere	+ LsOrder +  " INTO Cursor " + this.cAlias + " READWRITE"

					  
				CASE goentorno.AdoEntorno 
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias 
				CASE goentorno.SqlEntorno 
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE FlagEliminado=1 and "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias
			ENDCASE
		*ENDIF
		LnNumReg = -1
		SELECT 0
		&LsSql.
		LnNumReg = RECCOUNT()
		RETURN LnNumReg 
	ENDPROC


	*-- Ruta de acceso a tabla remota
	PROCEDURE rutatabla
		LPARAMETERS tcNombreEntidad as String  , tnRemoteLocal as Integer , tlFlagBusqueda as Boolean  as String
		*!*	Retorna el nombre de la Entidad con la ruta completa del servidor


		LOCAL lcRemotePathEntidad, lcSrvDB , lcArea

		tnRemoteLocal	= IIF( VARTYPE(tnRemoteLocal) = "N" , tnRemoteLocal , 0 )
		tcNombreEntidad = ALLTRIM(tcNombreEntidad)
		lcArea 			= ALIAS()

		lcRemotePathEntidad = ''

		m.NombreEntidad	= tcNombreEntidad
		*lcSrvDB = ALLTRIM(.Servidor) + "." + ALLTRIM(.BaseDatos) + ".dbo."
		*lcSrvDB	= ""

		IF tnRemoteLocal = 1   && Remoto acceso a servidor de base de datos
			goConexion.cSQL = "SELECT  CodigoEntidad ,  " + ;
				" NombreEntidad ,  " + ;
				" NombreServidor , " + ;
				" NombreBasedatos, " + ;
				" FlagBusqueda     " + ;
				" FROM CLAGEN_GEntidades " + ;
				" WHERE NombreEntidad = ?m.NombreEntidad "
			goConexion.cCursor = "Cursor_SQL"
			goConexion.DoSQL()

			_TALLY = IIF(goConexion.FOUND,1,0)

		ELSE

			SELECT	CodigoEntidad ,  ;
				NombreEntidad ,  ;
				NombreServidor,  ;
				NombreBasedatos, ;
				FlagBusqueda ;
				FROM goEntorno.LocPath+"GEntidades" ;
				WHERE UPPER(ALLTRIM(NombreEntidad)) == UPPER(tcNombreEntidad) ;
				INTO CURSOR Cursor_SQL

		ENDIF

		IF EMPTY(_TALLY)
			IF NOT GoEntorno.SqlEntorno	&& NO estoy accediendo a un servidor de base de datos
				LcRemotePathEntidad = ALLTRIM(this.abrirtabla('RUTA',tcNombreEntidad,'','',''))
			ELSE
				lcRemotePathEntidad = tcNombreEntidad
			endif
			tlFlagBusqueda		= .F.
		ELSE
			IF NOT GoEntorno.SqlEntorno	&& NO estoy accediendo a un servidor de base de datos
		*!*			LcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreEntidad)
				LcRemotePathEntidad = THIS.abrirtabla('RUTA',Cursor_SQL.NombreEntidad,'','','')
										 
			ELSE
				DO CASE
						*!*	El servidor por defecto es diferente al que se obtuvo
					CASE UPPER(ALLTRIM(goConexion.Servidor)) <> UPPER(ALLTRIM(Cursor_SQL.NombreServidor))
						*!*	Retorna	: Servidor.BaseDatos.dbo.Tabla
						lcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreServidor)+"."+ALLTRIM(Cursor_SQL.NombreBaseDatos)+".dbo."+ALLTRIM(Cursor_SQL.NombreEntidad)
						*!*	El servidor por defecto es igual al que se obtuvo, pero la Base de Datos es Diferente
					CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(Cursor_SQL.NombreServidor)) AND ;
							UPPER(ALLTRIM(goConexion.BaseDatos))<> UPPER(ALLTRIM(Cursor_SQL.NombreBaseDatos))
						*!*	Retorna	: BaseDatos.dbo.Tabla
						lcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreBaseDatos)+".dbo."+ALLTRIM(Cursor_SQL.NombreEntidad)
						*!*	El servidor por defecto es igual al que se obtuvo, y la Base de Datos tambien
					CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(Cursor_SQL.NombreServidor)) AND ;
							UPPER(ALLTRIM(goConexion.BaseDatos))== UPPER(ALLTRIM(Cursor_SQL.NombreBaseDatos))
						*!*	Retorna	: Tabla
						lcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreEntidad)
				ENDCASE
			ENDIF
			tlFlagBusqueda		= Cursor_SQL.FlagBusqueda
		ENDIF

		USE IN Cursor_SQL

		IF USED("GEntidades")
			USE IN GEntidades
		ENDIF

		IF !EMPTY(lcArea)
			SELECT (lcArea)
		ENDIF

		RETURN lcRemotePathEntidad
	ENDPROC


	*-- Apertura de tablas
	PROCEDURE abrirtabla
		LPARAMETERS cAccion as String ,;
		cArchivo as String ,;
		cAlias as String ,;
		cTag as String ,;
		cExclu as String ,;
		cPk as String ,;
		cCodCia AS String ,;
		cPer	AS String ;
		 as Boolean

		*SET DATASESSION TO 1

		 
		LOCAL LsRutaTabla,LsArea_Act,LcArcTmp
		IF PARAMETERS()<2
			RETURN -1
		ENDIF
		LsArea_Act=SELECT()
		IF PARAMETERS()<8
			cCodCia = THIS.oEntorno.GsCodCia
		ENDIF
		IF PARAMETERS()<7
			cPer = LEFT(THIS.oEntorno.GsPeriodo,4)
		ENDIF


		IF UPPER(cAccion) ='TEMP'
			DO CASE 
				CASE UPPER(cAccion) ='TEMP_STR'
					IF EMPTY(cArchivo) or ISNULL(cArchivo)
						RETURN .f.
					ENDIF
					IF !USED(cArchivo)
						RETURN .f.
					ENDIF

					LcArcTmp = this.tmppath +SYS(3)
					SELECT (cArchivo)
					COPY STRUCTURE TO (LcArcTmp) with cdx
					SELECT 0
					use (LcArcTmp) ALIAS (cAlias) EXCLU  
				CASE UPPER(cAccion) ='TEMP_SQL'
					IF EMPTY(cArchivo) or ISNULL(cArchivo)
						RETURN .f.
					ENDIF
					IF !USED(cArchivo)
						RETURN .f.
					ENDIF
					LcArcTmp = this.tmppath +SYS(3)
					IF VERSION(5) < 700    
						select * from (cArchivo) where 0>1 into Cursor temporal
						SELE Temporal
						COPY TO (LcArcTmp)
						USE IN TEMPORAL
						SELE 0
						USE (LcArcTmp) ALIAS (cAlias) EXCLUSIVE
					ELSE
						SELECT * from (cArchivo) where 0>1 into cursor (cAlias) readwrite 
					ENDIF

			ENDCASE
			IF !EMPTY(LsArea_act)
				SELE (LsArea_Act)
			ENDIF
			RETURN .t.
		ENDIF

		*STRTOFILE("PATH:"+SET("Path" )+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
		*STRTOFILE("DATASESSION:"+STR(SET("Datasession"))+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
		*STRTOFILE("CURDIR:"+CURDIR()+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)

			IF USED('DBFS')
				SELECT DBFS
			ELSE
				SELECT 0
				use ADMIN!sistdbfs ORDER archivo ALIAS dbfs
			ENDIF
			**SEEK PADR(UPPER(cSistema),LEN(DBFS.SISTEMA))+UPPER(cArchivo)
			SEEK TRIM(UPPER(cArchivo))
			IF !FOUND()
				this.serror = 'No esta definida la tabla '+cArchivo+ ' en el registro de entidades SISTDBFS'
				RETURN .f.
			ENDIF
			*** Ubico la base de datos a la que pertenece la tabla ***
			DO CASE
				CASE dbfs.connect = 'FOXPRO.DBC'
					DO CASE
						CASE 	!(EMPTY(DBFS.Basedatos) OR ISNULL(DBFS.Basedatos))	 
							LsRutaTabla=TRIM(Basedatos)+'!'+cArchivo 
						CASE	EMPTY(DBFS.Basedatos) OR ISNULL(DBFS.Basedatos)
							DO CASE
								CASE DBFS.Ubicacion='INI'
									LsRutaTabla='ADMIN!'+cArchivo 
								CASE DBFS.Ubicacion='CIA'
									LsRutaTabla=TRIM(DBFS.Ubicacion)+cCodCia+'!'+cArchivo
								CASE DBFS.Ubicacion='PER'
									LsRutaTabla=LEFT(TRIM(DBFS.Ubicacion),1)+cCodCia+cPer+'!'+cArchivo
							ENDCASE
					ENDCASE
				CASE dbfs.CONNECT = 'FOXPRO'
							LsRutaTabla=TRIM(PATH_001+cArchivo)
			ENDCASE
			***
			IF UPPER(cAccion)='RUTA' 
				IF !EMPTY(LsArea_act)
					SELE (LsArea_Act)
				ENDIF
				RETURN LsRutaTabla	 
			ENDIF

			SELE 0
			DO CASE
				CASE !EMPTY(cArchivo) AND !EMPTY(cAlias) AND !EMPTY(cExclu)
					USE (LsRutaTabla) ALIAS (cAlias) EXCLU
				CASE !EMPTY(cArchivo) AND !EMPTY(cAlias) AND EMPTY(cExclu)
					IF !USED(cAlias)
						USE (LsRutaTabla) ALIAS (cAlias) SHARED AGAIN
					ELSE
						SELECT  (cAlias)
					ENDIF

				CASE !EMPTY(cArchivo) AND EMPTY(cAlias) AND !EMPTY(cExclu)
					USE (LsRutaTabla) EXCLU
				CASE !EMPTY(cArchivo) AND EMPTY(cAlias) AND EMPTY(cExclu)
					USE (LsRutaTabla) SHARED AGAIN

				OTHER 
					IF !EMPTY(LsArea_act)
						SELE (LsArea_Act)
					ENDIF
					RETURN .F.
			ENDCASE
			IF !USED()
				IF !EMPTY(LsArea_act)
					SELE (LsArea_Act)
				ENDIF
				RETURN .F.
			ENDIF
			IF !EMPTY(cTag)
				SET ORDER TO (cTag)
			ENDIF

		RETURN .t.
	ENDPROC


	*-- Actualiza tabla segun lista de campos
	PROCEDURE actualizatabla
		LPARAMETERS _cAlias as String, ;
		 _ctabla as String, ;
		 _cIndice  as String , ;
		 _cCamposPK as String , ; 
		 _cValoresPK as String, ;
		 _cCampos As String , _cValores as String


		LOCAL LcRutaTabla,LsSql,LlCierraTabl
		IF !USED(_CTABLA)
			LlCierraTabl = .T.
		ENDIF

		THIS.Ctabla	= _ctabla
		THIS.cindicePK	= _cIndice
		this.cCamposPK		= _cCamposPK
		this.cValorPK 		= _cValoresPK
		this.calias			= IIF(EMPTY(_calias),GoEntorno.TmpPath+SYS(3),_cAlias)

		LcRutaTabla=this.RutaTabla(THIS.cTabla)

		* Obtengo la estructura para conversion de tipo de dato
		LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE 0>1 INTO CURSOR C_STR"
		&LsSql
		SELECT C_STR 


		DIMENSION laValores[1]
		STORE "" TO laValores


		this.Listacampos(_cCampos,'cCampos','aCampos')
		this.Listacampos(_cValores,'cValores','aValores')

				lcSQL_Update = ""
				lnVacio = 0
				FOR I=1 TO ALEN(THIS.aCampos)
					LcCampos	= ALLTRIM(THIS.aCampos[I])
					LcVariable				= "m.xx_" + ALLTRIM(STR(I)) + "_" +lcCampos
					FOR k = 1 TO FCOUNT('C_STR')
						IF FIELD(K,'C_STR')=LcCampos
							IF VARTYPE(EVALUATE(fields(k))) == VARTYPE(THIS.aValores[I])
								LxValor = this.aValores[I]
							ELSE

								LcTipoDato = VARTYPE(EVALUATE(fields(k)))
								DO CASE 
									CASE LcTipoDato = 'N' 
										LxValor = VAL(this.aValores[I])
									CASE LcTipoDato = 'Y' 
										LxValor = VAL(this.aValores[I])
									CASE LcTipoDato = 'D'
										LxValor = CTOD(this.aValores[I])
									CASE LcTipoDato = 'T'
										LxValor = CTOT(this.aValores[I])
									CASE LcTipoDato = 'L'
										LxValor = EVALUATE(this.aValores[I])
									OTHERWISE
										LxValor = this.aValores[I]
								ENDCASE 

							ENDIF

						ENDIF
					ENDFOR

					PUBLIC &lcVariable
					&lcVariable				= LxValor          &&EVAL(lcCampos)
					lcSQL_Update = lcSQL_Update + ;
						lcCampos + " = " + lcVariable + " , "
					*	lcCampoEdicionDestino + " = '" + ALLTRIM(&lcCampoEdicionDestino) + "' , "

					IF EMPTY(THIS.aValores[I])
						lnVacio = lnVacio + 1
					ENDIF
				ENDFOR

				lcSQL_Update = LEFT(lcSQL_Update,LEN(lcSQL_Update)-3)


		USE IN C_STR


		*IF !USED(_CTABLA)
		*	THIS.Abrirtabla()
		*ELSE
			DO CASE 
				CASE goentorno.VfpDbcEntorno
					LsSql = "UPDATE " + (LcRutaTabla) + " SET " +; 
						lcSQL_Update + ;
					 " WHERE "+ _cCamposPK +" = '"+ _cValoresPK + "'"
					  
				CASE goentorno.AdoEntorno 
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias 
				CASE goentorno.SqlEntorno 
					LsSql = "SELECT * from " + (LcRutaTabla) + " WHERE FlagEliminado=1 and "+ _cCamposPK +" = '"+ _cValoresPK +"' INTO Cursor " + this.cAlias
			ENDCASE
		*ENDIF


		SELECT 0
		&LsSql.

		IF LlCierraTabl
			IF USED(_cTabla)
				USE IN (_cTabla)
			ENDIF
		ENDIF
	ENDPROC


	*-- Campos que se van a actualizar
	PROCEDURE listacampos
		LPARAMETERS tcCampos,TcValor,TaValor

		*!*	Inicializar Matriz temporal
		LOCAL laCampos
		DIMENSION laCampos[1]
		STORE SPACE(0) TO laCampos

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCampos)=="C"
			tcCampos	= ALLTRIM(tcCampos)
			tcCampos	= CHRTRAN(tcCampos,SPACE(1),SPACE(0))
			LcPropiedad = 'THIS.'+TcValor
			*THIS.cCampos = tcCampos
			&LcPropiedad  = tcCampos
			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCampos , ";" , @laCampos )

		ENDIF
		nLen = ALEN(laCampos)
		LaPropiedad = 'THIS.'+TaValor+'('+STR(nlen)+')'


		*DIMENSION THIS.aCampos(nLen)
		DIMENSION (LaPropiedad)
		LaPropiedad = 'THIS.'+TaValor
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCampos,&LaPropiedad)
	ENDPROC


	*-- Convierte la  cadena delimitada por un separador a un arreglo
	PROCEDURE chrtoarray
		*!*	Convertir una cadena en una matriz seg�n sus separadores.
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
	ENDPROC


	*-- Modifica estructura de una tabla o cursor
	PROCEDURE mod_str_tabla
		PARAMETERS _cAliasNombre,_cAccion,_cCampo,_cTipo,_nLongitud,_nPrecision

		** Por mejorar para todos los casos de modificacion de estrucuturas de tablas por ahora solo Agrega campos
		** Tipo C,N ,L,D,T


		IF PCOUNT()<4
			RETURN -1
		ENDIF
		IF EMPTY(_cAliasNombre) OR ISNULL(_cAliasNombre)
			IF !EMPTY(ALIAS())
				_CAliasNombre = ALIAS()
			ELSE
				_CAliasNombre = ''
			ENDIF
		ENDIF

		IF EMPTY(_cAliasNombre)
			RETURN -1
		ENDIF
		_cAccion = UPPER(_cAccion)
		LOCAL LsTipoLonPrec
		DO CASE
			CASE _cTipo='C'
				LsTipoLonPrec=' C('+TRANSFORM(_nLongitud,"@L 99")+')'
			CASE INLIST(_cTipo,'N','F')
				IF _nPrecision<=0
					LsTipoLonPrec=' N('+TRANSFORM(_nLongitud,"@L 99")+')'
				ELSE
					LsTipoLonPrec=' N('+TRANSFORM(_nLongitud,"@L 99")+','+TRANSFORM(_nPrecision,"@L 99")+')'
				ENDIF
			CASE _cTipo='L'
				LsTipoLonPrec=' L '
			CASE INLIST(_cTipo,'D','T')
				LsTipoLonPrec=' '+_cTipo+' '
			OTHERWISE

		ENDCASE

		DO CASE
			CASE	_cAccion = 'AGREGAR' 
				ALTER TABLE (_cAliasNombre) ADD COLUMN &_cCampo &LsTipoLonPrec
			CASE	_cAccion = 'BORRAR'

			CASE	_cAccion = 'MODIFICA'
		ENDCASE

		RETURN 1
	ENDPROC


	*-- Abrir_archivos segun tipo de transacci�n
	PROCEDURE open_file
		parameter _CodDoc

		LlRetVal =  .T.	   && Siempre optimistas
		DO CASE 
			CASE _CODDOC = [G/R ]

				IF !THIS.AbrirTabla('ABRIR','cbdmauxi','CLIE','AUXI01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtavpedi','VPED','VPED01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtarpedi','RPED','RPED02','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtatdocm','DOCM','DOCM01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtavguia','VMOV','VGUI01','')
				   LlRetVal =  .f.
				ENDIF
					* ARCHIVOS DE ALMACEN *
				IF !THIS.AbrirTabla('ABRIR','almCatgE','CATG','CATG01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','almCATAL','CALM','CATA01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','almDTRAN','DTRA','DTRA04','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','almtalma','ALMA','ALMA01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','almEQUNI','UVTA','EQUN01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','almtgsis','TABL','TABL01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !LlRetVal
					IF USED('CATG')
						USE IN CATG
					ENDIF

					IF USED('DIVF')
						USE IN DIVF
					ENDIF
					IF USED('ALMA')
						USE IN ALMA
					ENDIF
					IF USED('UVTA')
						USE IN UVTA
					ENDIF
					IF USED('TABL')
						USE IN TABL
					ENDIF
					IF USED('DTRA')
						USE IN DTRA
					ENDIF
					IF USED('DETA')
						USE IN DETA
					ENDIF
					IF USED('TCMB')
						USE IN TCMB
					ENDIF
					IF USED('GUIA')
						USE IN GUIA
					ENDIF
					IF USED('CLIE')
						USE IN CLIE
					ENDIF
					IF USED('VPED')
						USE IN VPED
					ENDIF
					IF USED('RPED')
						USE IN RPED
					ENDIF
					IF USED('DOCM')
						USE IN DOCM
					ENDIF
					IF USED('GDOC')
						USE IN GDOC
					ENDIF
					RETURN LlRetVal
				ENDIF

			CASE _CodDoc $ [FACT|BOLE|N/C|NC|N\C]
				*
				IF !THIS.AbrirTabla('ABRIR','cbdmauxi','CLIE','AUXI01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','vtavpedi','VPED','VPED01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtarpedi','RPED','RPED02','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtatdocm','DOCM','DOCM01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtavguia','GUIA','VGUI01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almCatgE','CATG','CATG01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almCATAL','CALM','CATA01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','vtaritem','DETA','ITEM01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almDTRAN','DTRA','DTRA04','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','admmtcmb','TCMB','TCMB01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almtgsis','TABL','TABL01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almEQUNI','UVTA','EQUN01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almtDIVF','DIVF','DIVF01','')
				   LlRetVal =  .f.
				ENDIF
				** Archivo Auxiliar **
				IF USED('AUXI')
					SELECT auxi
					zap
				ELSE

					Arch = SYS(2023)+'\'+SYS(3)
					SELE 0
					CREATE TABLE (Arch) FREE ( CodDoc C(4), NroDoc C(LEN(GDOC.NroDoc)), FchDoc D, Selec L(1), FlgEst C(1), NroPed C(LEN(GDOC.NroPed)) )
					USE (Arch) ALIAS AUXI EXCLU
					IF !USED()
					   LlRetVal =  .f.
					ENDIF
				ENDIF
				IF !LlRetVal
					IF USED('CATG')
						USE IN CATG
					ENDIF

					IF USED('DIVF')
						USE IN DIVF
					ENDIF
					IF USED('TDOC')
						USE IN TDOC
					ENDIF
					IF USED('UVTA')
						USE IN UVTA
					ENDIF
					IF USED('TABL')
						USE IN TABL
					ENDIF
					IF USED('DTRA')
						USE IN DTRA
					ENDIF
					IF USED('DETA')
						USE IN DETA
					ENDIF
					IF USED('TCMB')
						USE IN TCMB
					ENDIF
					IF USED('GUIA')
						USE IN GUIA
					ENDIF
					IF USED('CLIE')
						USE IN CLIE
					ENDIF
					IF USED('VPED')
						USE IN VPED
					ENDIF
					IF USED('RPED')
						USE IN RPED
					ENDIF
					IF USED('DOCM')
						USE IN DOCM
					ENDIF
					IF USED('GDOC')
						USE IN GDOC
					ENDIF
					IF USED('AUXI')
						USE IN AUXI
					ENDIF

					RETURN LlRetVal
				ENDIF

				** relaciones a usar **
				SELECT GDOC
				RETURN LlRetVal
			CASE INLIST(_CodDoc ,[N/D],[N\D],[ND])
				*
				IF !THIS.AbrirTabla('ABRIR','cbdmauxi','CLIE','AUXI01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','vtarpedi','RPED','RPED02','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','vtatdocm','DOCM','DOCM01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.AbrirTabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','admmtcmb','TCMB','TCMB01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','almtgsis','TABL','TABL01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				** Archivo Auxiliar **
				IF USED('AUXI')
					SELECT auxi
					zap
				ELSE

					Arch = SYS(2023)+'\'+SYS(3)
					SELE 0
					CREATE TABLE (Arch) FREE ( CodDoc C(4), NroDoc C(LEN(GDOC.NroDoc)), FchDoc D, Selec L(1), FlgEst C(1), NroPed C(LEN(GDOC.NroPed)) )
					USE (Arch) ALIAS AUXI EXCLU
					IF !USED()
					   LlRetVal =  .f.
					ENDIF
				ENDIF
				IF !LlRetVal
					IF USED('CATG')
						USE IN CATG
					ENDIF

					IF USED('DIVF')
						USE IN DIVF
					ENDIF
					IF USED('TDOC')
						USE IN TDOC
					ENDIF
					IF USED('UVTA')
						USE IN UVTA
					ENDIF
					IF USED('TABL')
						USE IN TABL
					ENDIF
					IF USED('DTRA')
						USE IN DTRA
					ENDIF
					IF USED('DETA')
						USE IN DETA
					ENDIF
					IF USED('TCMB')
						USE IN TCMB
					ENDIF
					IF USED('GUIA')
						USE IN GUIA
					ENDIF
					IF USED('CLIE')
						USE IN CLIE
					ENDIF
					IF USED('VPED')
						USE IN VPED
					ENDIF
					IF USED('RPED')
						USE IN RPED
					ENDIF
					IF USED('DOCM')
						USE IN DOCM
					ENDIF
					IF USED('GDOC')
						USE IN GDOC
					ENDIF
					IF USED('AUXI')
						USE IN AUXI
					ENDIF

					RETURN LlRetVal
				ENDIF

				** relaciones a usar **
				SELECT GDOC
				RETURN LlRetVal

			CASE _coddoc = 'CTB'
					*********************************************************************** FIN() *
				* Objeto : Abrir Base de Contabilidad
				******************************************************************************
				IF !THIS.AbrirTabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
					this.close_File('VTA_CTB')
				   RETURN .F.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','cbdvmovm','VMOV','vmov01','')
					this.close_File('VTA_CTB')
				   RETURN .F.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','cbdrmovm','RMOV','rmov01','')
					this.close_File('VTA_CTB')
				   RETURN .F.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','cbdtoper','oper','oper01','')
					this.close_File('VTA_CTB')
				   RETURN .F.
				ENDIF
				*
				IF !THIS.AbrirTabla('ABRIR','cbdacmct','acct','acct01','')
					this.close_File('VTA_CTB')
				   RETURN .F.
				ENDIF

				*
				RETURN .T.

		ENDCASE 
	ENDPROC


	PROCEDURE close_file
		PARAMETERS cQueTransaccion
		DO CASE 
			CASE cQueTransaccion=='CTB'
				this.closetable('CNFG2')
				this.closetable('CNFG')
				this.closetable('CTA2')
				this.closetable('DIAF')
				this.closetable('DRMOV')
				this.closetable('PROV')
				this.closetable('DPRO')
		*!*			this.closetable('TCMB')
				this.closetable('ACCT')
				this.closetable('OPER')
		*!*			this.closetable('TABL')
				this.closetable('RMOV')
				this.closetable('VMOV')
		*!*			this.closetable('AUXI')
				this.closetable('CTAS')
				this.closetable('DBFS')
				this.closetable('C_RMOV')
				this.closetable('PPRE')
			CASE cQueTransaccion=='CCB_CTB'
				this.closetable('ACCT')
				this.closetable('OPER')
				this.closetable('RMOV')
				this.closetable('VMOV')
			CASE cQueTransaccion=='CCB_CJA'
				this.closetable('GDOC')
				this.closetable('CMOV')
				this.closetable('SLDO')
				this.closetable('TDOC')

			CASE cQueTransaccion=='VTA_CTB'
				this.closetable('ACCT')
				this.closetable('OPER')
				this.closetable('RMOV')
				this.closetable('VMOV')
				this.closetable('CTAS')
			CASE cQueTransaccion=='CJA'
				this.closetable('CNFG2')
				this.closetable('CNFG')
				this.closetable('CTA2')
				this.closetable('DIAF')
				this.closetable('DRMOV')
				this.closetable('PROV')
				this.closetable('DPRO')
				this.closetable('TCMB')
				this.closetable('ACCT')
				this.closetable('OPER')
				this.closetable('TABL')
				this.closetable('RMOV')
				this.closetable('VMOV')
				this.closetable('AUXI')
				this.closetable('CTAS')
				this.closetable('DBFS')
				this.closetable('C_RMOV')
				this.closetable('PPRE')
		ENDCASE
	ENDPROC


	PROCEDURE closetable
		LPARAMETERS lcTable
		IF USED(lcTable)
			USE IN (lcTable)
		ENDIF
	ENDPROC


	*-- captura el nro de  id de un correlativo segun llave
	PROCEDURE cap_nroitm
		PARAMETERS _Llave as String ,_Tabla_alias AS String ,_CmpLLave AS String,_CmpNroItm as String,_Filter AS String,_nLen_id as Integer 
		LOCAL LsArea_act
		LsArea_act=SELECT() 
		LnParms=PARAMETERS()

		IF LnParms<4
			_CmpNroItm = 'NroItm'
		ENDIF
		LsValCmpNroItm = _Tabla_alias+'.'+_CmpNroItm
		Cur_Temp = SYS(2015)
		IF INLIST(VARTYPE(&LsValCmpNroItm),'U','D','T','L')
			RETURN -1
		ENDIF 
		IF !VARTYPE(&LsValCmpNroItm)='N'
			IF _nLen_ID>0
				X_CmpNroItm = 'SUBSTR('+_CmpNroItm+','+STR(_nLen_ID+1,1,0)+')'
			ELSE
			    X_CmpNroItm = _CmpNroItm
			ENDIF

			m.x   =  &LsValCmpNroItm 
			LsPict = "@L "+REPLICATE('9',LEN(m.x))
			LcSql1 = "SELECT TRANSFORM(VAL(IIF(ISNULL(MAX("+X_CmpNroItm+")),'',max("+X_CmpNroItm+")))+1,LsPict) AS "
		ELSE
			LcSql1 = "SELECT IIF(ISNULL(MAX("+_CmpNroItm+")),0,max("+_CmpNroItm+")) + 1 AS " 
		ENDIF

		IF EMPTY(_LLave) OR EMPTY(_CmpLlave)
			LcSql=LcSql1+_CmpNroItm + " FROM "+_tabla_alias +" INTO CURSOR " + CUR_TEMP + " READWRITE"
		ELSE
			LcSql=LcSql1+_CmpNroItm + " FROM "+_tabla_alias+" WHERE "+;
				 _CmpLlave + " = '" +_LLAve+ "' INTO CURSOR " + CUR_TEMP + " READWRITE"
		ENDIF		 


				 
		&LCSQL		 

		IF _nLen_id>0 AND !VARTYPE(&LsValCmpNroItm)='N'

		ENDIF

		VarNroItm = 'm.'+_CmpNroItm
		CampoCursor = Cur_temp+'.'+_CmpNroItm
		*select max(nroitm)+1 as nroitm from (_Tabla_alias) where &_CmpLLave=_Llave into cursor cur_temp
		IF _TALLY  = 0	&& Creando registro por primera vez

			IF !VARTYPE(&LsValCmpNroItm)='N'
				m.x=IIF(ISNULL(&LsValCmpNroItm),1,&LsValCmpNroItm)
				IF _nLen_id >0 
					replace (CampoCursor) WITH _LLAve+SUBSTR(&CampoCursor.,_nLen_id+1) IN (Cur_temp)
					&VarNroItm = RIGHT(_Llave+REPLICATE('0',LEN(m.x) - _nLen_id -1)+'1',LEN(m.x)) 
				ELSE
					&VarNroItm = RIGHT(REPLICATE('0',LEN(m.X))+'1',LEN(m.x)) 
				ENDIF
			else
				&VarNroItm = 1
			endif
		ELSE
			IF _nLen_id >0  AND !VARTYPE(&LsValCmpNroItm)='N'
				replace (CampoCursor) WITH _LLAve+SUBSTR(&CampoCursor.,_nLen_id+1) IN (Cur_temp)
				**&VarNroItm = RIGHT(_Llave+REPLICATE('0',_nLen_id)+'1',LEN(m.x)) 
				m.x=IIF(ISNULL(&LsValCmpNroItm),IIF(!VARTYPE(&LsValCmpNroItm)='N','1',1),&LsValCmpNroItm)
				&VarNroItm = IIF(empty(EVALUATE(CampoCursor) ) OR ISNULL(EVALUATE(CampoCursor)),RIGHT(_Llave+REPLICATE('0', LEN(m.X) - _nLen_ID - 1)+'1',LEN(m.x)),evaluate(CampoCursor)) &&EVALUATE(CampoCursor) 

			ELSE
				m.x=IIF(ISNULL(&LsValCmpNroItm),IIF(!VARTYPE(&LsValCmpNroItm)='N','1',1),&LsValCmpNroItm)
				&VarNroItm = IIF(empty(EVALUATE(CampoCursor) ) OR ISNULL(EVALUATE(CampoCursor)),RIGHT(REPLICATE('0',LEN(m.X))+'1',LEN(m.x)),evaluate(CampoCursor)) &&EVALUATE(CampoCursor) 
			ENDIF
		ENDIF
		use in (cur_temp)
		SELECT (LsArea_act)
		RETURN EVALUATE(VarNroItm)
	ENDPROC


	PROCEDURE Init
		THIS.oEntorno=CREATEOBJECT('DOSVR.ENV')
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF SET("Development")='ON' 
			LnRpta=MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')


			DO CASE
				CASE  LnRpta =3
					SUSPEND 
				CASE  LnRpta =4 
					SET STEP ON 
				CASE  LnRpta =5
					retry
			ENDCASE

			RETURN CONTEXT_E_ABORTED
		ELSE

			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
			RETURN CONTEXT_E_ABORTED

		ENDIF

	ENDPROC


	*-- Ejecuta consulta
	PROCEDURE ejecutaconsulta
	ENDPROC


	*-- Graba en la tabla maestra el contenido del objeto de datos
	PROCEDURE grabarobjetodatos
	ENDPROC


	*-- Cierra tabla
	PROCEDURE cerrartabla
	ENDPROC


	*-- Captura el correlativo segun clave
	PROCEDURE correlativo
	ENDPROC


	*-- Valor de los campos a actualizar
	PROCEDURE valorescampos
	ENDPROC


ENDDEFINE
*
*-- EndDefine: dataadmin
**************************************************


**************************************************
*-- Class:        aadodataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  dataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   02/20/03 08:50:08 PM
*
DEFINE CLASS aadodataadmin AS dataadmin OLEPUBLIC


	Name = "aadodataadmin"


ENDDEFINE
*
*-- EndDefine: aadodataadmin
**************************************************


**************************************************
*-- Class:        aodbcdataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  dataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   02/20/03 08:51:13 PM
*
DEFINE CLASS aodbcdataadmin AS dataadmin OLEPUBLIC


	Name = "aodbcdataadmin"


ENDDEFINE
*
*-- EndDefine: aodbcdataadmin
**************************************************


**************************************************
*-- Class:        avfpdataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  dataadmin (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   02/24/03 11:44:12 PM
*
DEFINE CLASS avfpdataadmin AS dataadmin OLEPUBLIC


	Name = "avfpdataadmin"


	PROCEDURE Init
		this.herramientas=CREATEOBJECT('dosvr.datautils')
	ENDPROC


ENDDEFINE
*
*-- EndDefine: avfpdataadmin
**************************************************


**************************************************
*-- Class:        dataejecutor (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   06/22/03 07:19:13 AM
*
DEFINE CLASS dataejecutor AS custom


	Height = 28
	Width = 88
	*-- Contiene la referencia de la Grid a la cual va ha configurar
	ogrid = ""
	*-- Contiene el Codigo de Entidad de la cual va a construir dinamicamente el oGrid
	ccodigoentidad = ""
	*-- Contiene el Nombre de la entidad de la cual se basa la Grid Dinamica
	cnombreentidad = ""
	*-- Nombre del cursor que retorna la sentencia SELECT
	caliascursor = ""
	*-- Contiene el nombre del cursor de las columnas a mostrar en la Grid
	caliascolumnas = ""
	*-- Guarda la sentencia SQL generada
	csql = ""
	*-- Contiene la Sentencia Where generada para criterios de busqueda
	HIDDEN cwhere
	cwhere = ""
	*-- Contiene el objeto cmdHelp que invoca una ayuda
	ohelp = ""
	*-- Contiene los valores de las claves de la plantilla desde donde se cargaran los atributos para el Grid (ATRIBUTO-VALOR)
	cclaveplantilla = ""
	*-- Indica la entidad de donde se extrae los valores de los atributos segun plantilla. (ATRIBUTO-VALOR)
	centidadorigenatributos = ""
	*-- Indica la entidad a la cual se enviaran los valore de los atributos ingresados. (ATRIBUTO-VALOR)
	centidaddestinoatributos = ""
	*-- Arreglo de Campos clave de la entidad Origen (ATRIBUTO-VALOR)
	ccamposclaveorigen = ""
	*-- Cadena de campos clave destino de la entidad destino (ATRIBUTO-VALOR)
	ccamposclavedestino = ""
	*-- Cadena de valores de los campos claves de la entidad Origen (ATRIBUTO-VALOR)
	cvaloresclaveorigen = ""
	*-- Cadena de valores de los campos claves de la entidad destino (ATRIBUTO-VALOR)
	cvaloresclavedestino = ""
	*-- Es el alias del cursor generado para mostrar los Atributos y sus valores (ATRIBUTO-VALOR)
	caliasatributos = ""
	*-- Nombres de los campos que contienen los valores en una tabla ATRIBUTO-VALOR
	ccamposedicionorigen = ""
	*-- Es una cadena de campos que los cuales contienen los valores para obtener
	ccamposediciondestino = ""
	*-- Indica que los metodos Assign no se ejecutar�n en su totalidad
	HIDDEN lflag_assign
	lflag_assign = .T.
	*-- Se ingresa sentencia para la Clausua WHERE en lenguaje SQL (incluir operador AND,OR)
	cwheresql = ""
	*-- Configura para que la Grid de Ayuda de Codigos permita selecci�n multiple de c�digos
	lmultiselect = .F.
	*-- Retorna el Num. de los Atributos que contienen Valores (ATRIBUTO-VALOR)
	nregistros = 0
	*-- Retorna el Nro. de Criterios de Selecci�n definidos
	ncriterios = 0
	*-- Contiene una cadena literal de los criterios de selecci�n por ATRIBUTO-VALOR
	cliteralatributos = ""
	cliteralcriterios = ""
	*-- Indica los valores por defecto de cada campo de edici�n. (CRITERIOS SELECCION)
	cvaloresdefault = ""
	*-- Indica los nombres de los atributos que se llenaran con los valores por defecto. (CRITERIOS DE SELECCION)
	catributosdefault = ""
	*-- Son los tipos de datos de los campos de edicion, si se omite se asume CHAR
	ctipodatocamposedicion = ""
	Name = "dataejecutor"

	*-- Indica que se debe de respetar la configuraci�n de la Grilla hecha en tiempo de Dise�o para la Grilla de Consulta
	ldinamicgrid = .F.

	*-- Indica que la Consulta debe tener la clausula DISTINCT
	ldistinct = .F.

	*-- Indica el numero del ultimo error ocurrido
	nerror = .F.

	*-- Indica el Tipo del Ultimo Error Ocurrido
	ntipoerror = .F.

	*-- Contiene el mensaje del ultimo error generado
	cmensajeerror = .F.

	*-- Es una matriz con los campos de Edicion para la tabla de Destno ATRIBUTO-VALOR
	HIDDEN acamposediciondestino[1]

	*-- Una matriz con los campo Clave de la tabla de Origen [ATRIBUTO-VALOR]
	HIDDEN acamposclaveorigen[1]

	*-- Una matriz que contiene los campos Clave de la tabla de Destino [ATRIBUTO-VALOR]
	HIDDEN acamposclavedestino[1]

	*-- Contiene los valores de los campos clave de la tabla de Destino para ATRIBUTO-VALOR
	HIDDEN avaloresclavedestino[1]

	*-- Es una matriz con los campos de Edicion para la tabla de Origen ATRIBUTO-VALOR
	HIDDEN acamposedicionorigen[1]

	*-- Contiene los valores de los campos clave de la tabla de Origen para ATRIBUTO-VALOR
	HIDDEN avaloresclaveorigen[1]

	*-- Es una matriz que genera a partir de cValoresDefault
	HIDDEN avaloresdefault[1]

	*-- Es una matriz que se genera a partir de la propiedad cAtributosFiltro
	HIDDEN aatributosdefault[1]

	*-- Es una matriz que contiene los tipos de datos de los campos de edicion segun la propiedad cTipoDatoCampoEdicion
	HIDDEN atipodatocamposedicion[1]


	*-- Recibe como parametro el objeto Grid que se va a trabajar en forma dinamica
	PROCEDURE vinculargrid
		LPARAMETER toGrid, toHelp
		*!*	El valor del par�metro es un objeto Grid, el cual se pasa por referencia para
		*!*	actualizar sus valores y contenido.

		IF !( VARTYPE(toGrid)=="O" AND toGrid.BASECLASS="Grid" )
			THIS.nError		= 1
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		THIS.oGrid = toGrid

		IF ( VARTYPE(toHelp)=="O" AND toHelp.BASECLASS=="Commandbutton" )
			THIS.oHelp			= toHelp
			THIS.cNombreEntidad = toHelp.cNombreEntidad
			THIS.cWhereSQL		= toHelp.cWhereSQL
			THISFORM.CAPTION	= toHelp.cTituloAyuda
		ELSE
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				FOR J=1 TO THIS.oGrid.COLUMNS(I).CONTROLCOUNT
					IF THIS.oGrid.COLUMNS(I).CONTROLS(J).BASECLASS = "Commandbutton"
						THIS.oHelp = THIS.oGrid.COLUMNS(I).CONTROLS(J)
						EXIT
					ENDIF
				ENDFOR
			ENDFOR
		ENDIF
		RETURN .T.
	ENDPROC


	*-- Construye la Grid dinamica basada en la Propiedad cCodigoEntidad o cNombreEntidad
	PROCEDURE configurargridconsulta
		LPARAMETERS tcWhere, tnAyuda

		**EXTERNAL CLASS ADMVRS.VCX

		LOCAL lnParamtros , lnValores , lReturn

		lnParamtros	= PARAMETERS()

		*!*	Chequear Par�metros de Entrada
		DO CASE
			CASE lnParamtros = 0
				tcWhere	= ""
				tnAyuda	= 1
			CASE lnParamtros = 1
				tcWhere	= IIF(VARTYPE(tcWhere)=="C",ALLTRIM(tcWhere),"")
				tnAyuda	= 1
			CASE lnParamtros = 2
				tcWhere	= IIF(VARTYPE(tcWhere)=="C",ALLTRIM(tcWhere),"")
				tnAyuda	= IIF(VARTYPE(tnAyuda) == "L" , IIF(tnAyuda,1,2) , tnAyuda )
		ENDCASE

		THIS.cSQL = ""

		*!*	Chequear todas las propiedades que require el m�todo
		*!*	-----------------------------------------------------
		IF NOT "ADMVRS" $ SET("CLASSLIB")
			*SET CLASSLIB TO _LIB_VARIOS_GEN ADDITIVE
			**SET CLASSLIB TO ADMVRS ADDITIVE
		ENDIF

		IF !(VARTYPE(THIS.oGrid)=="O" AND THIS.oGrid.BASECLASS=="Grid")
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		*!*	-----------------------------------------------------

		lReturn	= THIS.GenerarColumnasConsulta( tnAyuda )

		IF  !lReturn	&& Ocurrio un Error en la ejecucion del m�todo anterior
			THIS.oGrid.INIT()
			RETURN .F.
		ENDIF

		IF !USED(THIS.cAliasColumnas)		&& No esta en uso el cursor necesario
			THIS.nError		= 3
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		SELECT(THIS.cAliasColumnas)

		*!*	OJO	Contar cuantas columnas se deben de mostrar
		COUNT ALL TO lnColumnas FOR FlagMuestraGrid

		THIS.cSQL = THIS.GenerarSQL()

		*=MESSAGEBOX(THIS.cSQL)

		*!*	Configurar el Grid que mostrar� los Datos
		SELECT(THIS.cAliasColumnas)


		WITH THIS.oGrid
			IF THIS.lDinamicGrid
				.COLUMNCOUNT = lnColumnas
			ENDIF
			.READONLY = .T.

			i=0
			GO TOP
			SCAN WHILE I < .COLUMNCOUNT

				*!*	OJO Verificar que la columna, es la que se debe de mostrar
				IF !FlagMuestraGrid AND !FlagAyuda
					LOOP
				ENDIF

				i = i + 1  && N�mero de Columnas

				IF THIS.lDinamicGrid	&& Me indica que debe de modificar el ancho de la columna
					.COLUMNS(i).WIDTH = LongitudCabecera
				ENDIF

				IF !EMPTY(MascaraDato) AND !ISNUL(MascaraDato) AND ;
						( ISNUL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
						( ISNUL(CodigoTabla) OR EMPTY(CodigoTabla) )
					IF NOT "@" $ MascaraDato
						.COLUMNS(i).INPUTMASK = ALLTRIM(MascaraDato)
					ENDIF
				ELSE
					IF ISNULL(LongitudCabeceraVisualizacion) OR ;
							EMPTY(LongitudCabeceraVisualizacion)
						IF THIS.lDinamicGrid	&& Me indica que debe de modificar el ancho de la columna
							.COLUMNS(i).WIDTH = 10
						ENDIF
					ELSE
						IF THIS.lDinamicGrid	&& Me indica que debe de modificar el ancho de la columna
							.COLUMNS(i).WIDTH = LongitudCabeceraVisualizacion
						ENDIF
					ENDIF
				ENDIF

				.COLUMNS(i).READONLY = .T.

				FOR j = 1 TO .COLUMNS(i).CONTROLCOUNT  && Numero de Controles contenidos en el Objeto Column
					IF	.COLUMNS(i).CONTROLS(j).BASECLASS == 'Header'
						IF THIS.lDinamicGrid	&& Me indica que debe de modificar el CAPTION de la columna
							.COLUMNS(i).CONTROLS(j).CAPTION = ALLTRIM(DescripcionCabecera)
							IF !ISNUL(CodigoEntidadCampo) OR !EMPTY(CodigoEntidadCampo)
								.COLUMNS(i).CONTROLS(j).CAPTION = ALLTRIM(DescCabeceraVisualizacion)
							ENDIF
						ENDIF
					ENDIF
					IF	.COLUMNS(i).CONTROLS(j).BASECLASS == 'Textbox'
						.COLUMNS(i).CONTROLS(j).FONTBOLD	= .F.
						.COLUMNS(i).CONTROLS(j).FONTSIZE	= 8
					ENDIF
				ENDFOR
			ENDSCAN

			*!*	Columna de M�ltiple Selecci�n
			IF THIS.lMultiSelect
				IF .COLUMNS(.COLUMNCOUNT).CURRENTCONTROL <> "chkColumn"
					.COLUMNCOUNT = .COLUMNCOUNT + 1
					.COLUMNS(.COLUMNCOUNT).NEWOBJECT("chkColumn","base_Checkbox_Multiselect")
					.COLUMNS(.COLUMNCOUNT).CURRENTCONTROL = "chkColumn"
					.COLUMNS(.COLUMNCOUNT).CONTROLS(1).CAPTION = "a"
					.COLUMNS(.COLUMNCOUNT).CONTROLS(1).FONTSIZE = 12
					.COLUMNS(.COLUMNCOUNT).CONTROLS(1).FONTNAME = "Marlett"
					.COLUMNS(.COLUMNCOUNT).SPARSE = .F.
					.COLUMNS(.COLUMNCOUNT).WIDTH = 18
					*!*	Alterna registros blancos y verdes.
					.SETALL("DynamicBackColor","IIF(Multiselect=0, RGB(255,255,255), RGB(210,210,210))","Column")
				ENDIF
			ENDIF
			.VISIBLE = .T.
			.INIT()
		ENDWITH
		RETURN .T.
	ENDPROC


	*-- Valida la asignaci�n de las propiedades cCodigoEntidad y cNombreEntidad
	HIDDEN PROCEDURE validarparametros
		*!*	Obtiene el codigo de la entidad o el nombre completo de la entidad
		LPARAMETERS tcCodigoEntidad , tcNombreEntidad
		LOCAL laEntidad

		IF  (EMPTY(tcCodigoEntidad) OR ISNULL(tcCodigoEntidad)) AND ;
			(EMPTY(tcNombreEntidad) OR ISNULL(tcNombreEntidad))
			THIS.nError		= 5
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		DIMENSION laEntidad[1]
		STORE SPACE(0) TO laEntidad
		IF !GOENTORNO.SQLENTORNO
			*** aQUI TE QUIERO VER PUES RECON ,,,,,,
			DO CASE

				CASE !EMPTY(tcNombreEntidad) AND !ISNULL(tcNombreEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath + "GEntidades" ;
						WHERE UPPER(ALLTRIM(NombreEntidad)) == UPPER(ALLTRIM(tcNombreEntidad)) ;
						INTO ARRAY laEntidad

				CASE !EMPTY(tcCodigoEntidad) AND !ISNULL(tcCodigoEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath+"GEntidades" ;
						WHERE CodigoEntidad==tcCodigoEntidad ;
						INTO ARRAY laEntidad
			ENDCASE
			IF _TALLY > 0 AND TYPE("laEntidad[1,3]")=="C"
				tcCodigoEntidad	= laEntidad[1,4]
				*!*	Retorna	: Tabla
				tcNombreEntidad = ALLTRIM(laEntidad[1,3])

			ELSE
				IF USED("GEntidades")
					USE IN GEntidades
				ENDIF
				THIS.nError		= 5
				THIS.nTipoError	= 2
				THIS.MostrarError()
				RETURN .F.
			ENDIF
		ELSE
			DO CASE

				CASE !EMPTY(tcNombreEntidad) AND !ISNULL(tcNombreEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath + "GEntidades" ;
						WHERE UPPER(ALLTRIM(NombreEntidad)) == UPPER(ALLTRIM(tcNombreEntidad)) ;
						INTO ARRAY laEntidad

				CASE !EMPTY(tcCodigoEntidad) AND !ISNULL(tcCodigoEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath+"GEntidades" ;
						WHERE CodigoEntidad==tcCodigoEntidad ;
						INTO ARRAY laEntidad
			ENDCASE

			IF _TALLY > 0 AND TYPE("laEntidad[1,3]")=="C"
				tcCodigoEntidad	= laEntidad[1,4]
				DO CASE
				*!*	El servidor por defecto es diferente al que se obtuvo
				CASE UPPER(ALLTRIM(goConexion.Servidor)) <> UPPER(ALLTRIM(laEntidad[1,1]))
					*!*	Retorna	: Servidor.BaseDatos.dbo.Tabla
					tcNombreEntidad = ALLTRIM(laEntidad[1,1])+"."+ALLTRIM(laEntidad[1,2])+".dbo."+ALLTRIM(laEntidad[1,3])
				*!*	El servidor por defecto es igual al que se obtuvo, pero la Base de Datos es Diferente
				CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(laEntidad[1,1])) AND ;
					 UPPER(ALLTRIM(goConexion.BaseDatos))<> UPPER(ALLTRIM(laEntidad[1,2]))
					*!*	Retorna	: BaseDatos.dbo.Tabla
					tcNombreEntidad = ALLTRIM(laEntidad[1,2])+".dbo."+ALLTRIM(laEntidad[1,3])
				*!*	El servidor por defecto es igual al que se obtuvo, y la Base de Datos tambien
				CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(laEntidad[1,1])) AND ;
					 UPPER(ALLTRIM(goConexion.BaseDatos))== UPPER(ALLTRIM(laEntidad[1,2]))
					*!*	Retorna	: Tabla
					tcNombreEntidad = ALLTRIM(laEntidad[1,3])
				ENDCASE
			ELSE
				IF USED("GEntidades")
					USE IN GEntidades
				ENDIF
				THIS.nError		= 5
				THIS.nTipoError	= 2
				THIS.MostrarError()
				RETURN .F.
			ENDIF

		ENDIF


		IF USED("GEntidades")
			USE IN GEntidades
		ENDIF
		RETURN .T.
	ENDPROC


	*-- Genera el Cursor para la Grid dinamica
	PROCEDURE generarcursor
		*!*	Consulta al Servidor, y crea el cursor en el Cliente
		LPARAMETERS tcWhere

		LOCAL lcControlSource , lcValorField, LcCadenaSql

		IF	(!(VARTYPE(THIS.oGrid)=="O" AND THIS.oGrid.BASECLASS=="Grid") ) OR ;
			(EMPTY( THIS.cSQL ) OR ISNULL(THIS.cSQL))
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		IF ISNULL(tcWhere) OR EMPTY(tcWhere) OR VARTYPE(tcWhere)<>"C"
			tcWhere = ""
		ELSE
			tcWhere =  " AND (" + ALLTRIM( STRTRAN(tcWhere,'"',"'") ) +")"
		ENDIF

		THIS.oGrid.RECORDSOURCE = ""
		THIS.oGrid.RECORDSOURCETYPE = 4
		IF GoEntorno.SqlEntorno
			goConexion.cSQL = THIS.cSQL + tcWhere + " " + THIS.cWhereSQL
		ELSE
			LcCadenaSql 	= THIS.cSQL + tcWhere + " " + THIS.cWhereSQL
		ENDIF
		*!*	=strtofile(goConexion.cSQL,"c:\windows\escritorio\sql.txt")

		IF EMPTY(THIS.cAliasCursor) OR ISNULL(THIS.cAliasCursor)
			THIS.cAliasCursor = SYS(2015)
		ENDIF

		IF USED(THIS.cAliasCursor)
			USE IN (THIS.cAliasCursor)
		ENDIF
		*=MESSAGEBOX(goConexion.cSQL)
		IF GoEntorno.SqlEntorno
			goConexion.cCursor = THIS.cAliasCursor
			lReturn = ( goConexion.DoSQL(THISFORM.DATASESSIONID) > 0 )
		ELSE
			LcCadenaSql = LcCadenaSql + ' INTO CURSOR '+ THIS.cAliasCursor
			&LcCadenaSql.
			lReturn = .T.
		ENDIF
		IF lReturn	AND USED(THIS.cAliasCursor)	&& Ejecut� correctamente la Sentencia
			THIS.oGrid.RECORDSOURCETYPE = 1  && Alias
			THIS.oGrid.RECORDSOURCE 	= THIS.cAliasCursor
			SELECT(THIS.cAliasCursor)
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				lcValorField	= EVAL(FIELD(I))
				DO CASE
				CASE VARTYPE(lcValorField) == "T"
					lcControlSource	= "TTOD(" + THIS.cAliasCursor + "." + FIELD(I) + ")"
				OTHERWISE
					lcControlSource	= THIS.cAliasCursor + "." + FIELD(I)
				ENDCASE
				THIS.oGrid.COLUMNS(I).CONTROLSOURCE	= lcControlSource
			ENDFOR
			THIS.oGrid.REFRESH()
		ENDIF

		RETURN lReturn
	ENDPROC


	*-- Genera el cursor de Columnas para Configurar la Grid
	HIDDEN PROCEDURE generarcolumnasconsulta
		*!*	Extrae las columnas que se mostrar�n en el Grid de Consulta
		LPARAMETERS tnAyuda

		LOCAL lcCodigoEntidad , lcNombreEntidad , lcCursor

		lcCodigoEntidad = THIS.cCodigoEntidad
		lcNombreEntidad = THIS.cNombreEntidad

		IF !EMPTY(THIS.cAliasColumnas) AND !ISNULL(THIS.cAliasColumnas) AND USED(THIS.cAliasColumnas)
			USE IN (THIS.cAliasColumnas)
			*THIS.cAliasColumnas = ""
			lcCursor = THIS.cAliasColumnas
		ELSE
			lcCursor = SYS(2015)
		ENDIF

		*lcCursor = SYS(2015)
		*lcCursor = THIS.cAliasColumnas

		IF !THIS.ValidarParametros( @lcCodigoEntidad , @lcNombreEntidad )
			RETURN .F.
		ENDIF

		THIS.cCodigoEntidad = lcCodigoEntidad
		THIS.cNombreEntidad = lcNombreEntidad

		DO CASE 
		*!*	Para pantalla de Consulta, Solo los marcados para "Mostrar en Consulta"
		CASE tnAyuda = 1
			SELECT *,IIF(FlagMuestraGrid,'0','1') AS Orden  ;
				FROM goEntorno.LocPath+"GEntidades_Detalle"  ;
				WHERE CodigoEntidad == THIS.cCodigoEntidad AND ( FlagMuestraGrid OR FlagConsultado ) ;
				ORDER BY Orden,OrdenColumna ;
				INTO CURSOR (lcCursor)
		*!*	Para pantalla de Ayuda, Solo los marcados para "Mostrar en Ayuda"
		CASE tnAyuda = 2
			SELECT *,IIF(FlagAyuda,'0','1') AS Orden  ; 
				FROM goEntorno.LocPath+"GEntidades_Detalle"  ;
				WHERE CodigoEntidad == THIS.cCodigoEntidad AND ( FlagAyuda OR FlagConsultado ) ;
				ORDER BY Orden,OrdenColumna ;
				INTO CURSOR (lcCursor)
		*!*	Para pantalla de Ayuda, Solo los marcados como "Campo de Retorno" y "Campo de Descripcion"
		CASE tnAyuda = 3 
			SELECT *  ;
				FROM goEntorno.LocPath+"GEntidades_Detalle"  ;
				WHERE CodigoEntidad == THIS.cCodigoEntidad AND ( FlagRetorno OR FlagVisualizacion ) ;
				ORDER BY FlagVisualizacion,OrdenColumna ;
				INTO CURSOR (lcCursor)
		ENDCASE

		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF

		THIS.cAliasColumnas = lcCursor

		IF EMPTY(_TALLY)
			THIS.nError		= 4
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		RETURN .T.
	ENDPROC


	HIDDEN PROCEDURE generarsql
		IF !USED(THIS.cAliasColumnas)		&& No esta en uso el cursor necesario
			THIS.nError		= 3
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	""
		ENDIF

		IF EMPTY(THIS.cNombreEntidad) OR ISNULL(THIS.cNombreEntidad)
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	""
		ENDIF

		SELECT(THIS.cAliasColumnas)
		GO TOP

		cSQL = "SELECT " + IIF(THIS.lDistinct , "DISTINCT ","")
		cColumn = ""

		SCAN
			DO CASE
					*!*	------------------------------------------------------------------------
					*!*	El campo es una clave que se valida en otra entidad, por ende debemos de
					*!*	generar la sentencia SQL para la subconsulta del campo
					*!*	------------------------------------------------------------------------
				CASE 	(!ISNULL(NombreEntidadCampo) AND !EMPTY(NombreEntidadCampo)) AND ;
						((ISNULL(Codigotabla) OR EMPTY(CodigoTabla)) AND ;
						!ISNULL(CampoVisualizacion) AND !EMPTY(CampoVisualizacion)) AND ;
						FlagExtraeDescripcion

					IF ISNULL(SecuenciaCampos) OR EMPTY(SecuenciaCampos)

						Tn = " T" +ALLTRIM( OrdenColumna )
						tcCampo = "( SELECT "+Tn+"."+ALLTRIM(CampoVisualizacion)+ ;
							" FROM "+ALLTRIM(NombreEntidadCampo)+ Tn + ;
							" WHERE T000."+ALLTRIM(NombreCampo) + ;
							" = " + Tn + "." + ALLTRIM(CampoRetorno) + " )"

						** por requerimiento de ALFREDO
						*cSQL = cSQL + ALLTRIM(CampoVisualizacion) + ALLTRIM(Tn) + " = " + tcCampo + " , "
						cSQL = cSQL + ALLTRIM(CampoVisualizacion) + " = " + tcCampo + " , "
						cColumn = cColumn + "T000."+ALLTRIM(NombreCampo) + " , "

					ELSE

						Tn = " T" +ALLTRIM( OrdenColumna )
						lcSecuenciaCampos = THIS.GenerarSecuenciaCampos(Tn)
						tcCampo = "( SELECT "+Tn+"."+ALLTRIM(CampoVisualizacion)+ ;
							" FROM "+ALLTRIM(NombreEntidadCampo)+ Tn + ;
							" WHERE T000."+ALLTRIM(NombreCampo) + ;
							" = " + Tn + "." + ALLTRIM(CampoRetorno) + lcSecuenciaCampos + " )"

						** por requerimiento de ALFREDO
						*cSQL = cSQL + ALLTRIM(CampoVisualizacion) + ALLTRIM(Tn) + " = " + tcCampo + " , "
						cSQL = cSQL + ALLTRIM(CampoVisualizacion) + " = " + tcCampo + " , "
						cColumn = cColumn + "T000."+ALLTRIM(NombreCampo) + " , "

					ENDIF

					*!*	------------------------------------------------------------------------
					*!*	El campo se valida en Tabla de Tablas, por ende debemos de validarlo
					*!*	en Gtablas_Detalle
					*!*	------------------------------------------------------------------------
				CASE !ISNULL(Codigotabla) AND !EMPTY(CodigoTabla) AND FlagExtraeDescripcion

					Tn = " T" +ALLTRIM( OrdenColumna )

					tcCampo = "( SELECT " +Tn+".DescripcionCortaArgumento" + ;
						" FROM " + ALLTRIM(goEntorno.RemotePathEntidad("GTablas_Detalle")) + Tn + ;
						" WHERE " + Tn + ".CodigoTabla = " + "'" + CodigoTabla+ "'" + ;
						" AND " + Tn+".ElementoTabla = T000." +ALLTRIM(NombreCampo)+ " )"

					cSQL	= cSQL + "DescripcionCortaArgumento" + ALLTRIM(Tn) + " = " + tcCampo + " , "
					cColumn = cColumn + "T000."+ALLTRIM(NombreCampo) + " , "

					*!*	------------------------------------------------------------------------
					*!*	En cualquier otro caso devolver solo el nombre del campo
					*!*	------------------------------------------------------------------------
				OTHERWISE
					cSQL = cSQL + "T000."+ALLTRIM(NombreCampo) + " , "

			ENDCASE

		ENDSCAN


		IF THIS.lMultiSelect
			cSQL = cSQL + cColumn + " 0 AS Multiselect "
		ELSE
			cSQL = cSQL + cColumn
			cSQL = LEFT(cSQL,LEN(cSQL)-3)
		ENDIF
		IF GOENTORNO.SqlEntorno
			cSQL = cSQL + " FROM " + THIS.cNombreEntidad + " T000 " + ;
				" WHERE T000.FlagEliminado = 0 "
		else
			cSQL = cSQL + " FROM " + goEntorno.RemotePathEntidad(THIS.cNombreEntidad) + " T000 " + ;
				" WHERE !deleted() "
		endif

		RETURN cSQL
	ENDPROC


	*-- Genera Cursor para el criterio de Busqueda
	HIDDEN PROCEDURE generarcolumnascriterios
		LPARAMETERS tnColumnas

		LOCAL lcCodigoEntidad , lcNombreEntidad , lcCursor , lcCursorTmp

		lcCodigoEntidad = THIS.cCodigoEntidad
		lcNombreEntidad = THIS.cNombreEntidad

		IF !EMPTY(THIS.cAliasColumnas) AND !ISNULL(THIS.cAliasColumnas) AND USED(THIS.cAliasColumnas)
			USE IN (THIS.cAliasColumnas)
			THIS.cAliasColumnas = ""
		ENDIF

		lcCursorTmp = SYS(2015)

		IF EMPTY(THIS.cAliasColumnas) OR ISNULL(THIS.cAliasColumnas)
			lcCursor = SYS(2015)
		ELSE
			lcCursor = THIS.cAliasColumnas
		ENDIF


		IF !THIS.ValidarParametros( @lcCodigoEntidad , @lcNombreEntidad )
			RETURN .F.
		ENDIF

		THIS.cCodigoEntidad = lcCodigoEntidad
		THIS.cNombreEntidad = lcNombreEntidad


		IF tnColumnas = 1
			*!*	Seleccionar todas las columnas que estan marcadas para "Criterio de Seleccion"
			SELECT	;
				DescripcionCampo,;
				SPACE(60) AS _ValorAtributo, ;
				SPACE(1) AS cmdAyuda,;
				SPACE(60) AS ValorAtributo , ;
				NombreCampo, ;
				SecuenciaCampos, ;
				TipodatoCampo,;
				CodigoAtributo,;
				CodigoEntidadCampo,;
				CampoVisualizacion,;
				Camporetorno,;
				NombreEntidadCampo,;
				Codigotabla,;
				LongitudDato,;
				MascaraDato,;
				ModoObtenerDatos,;
				FlagBusqueda,;
				0 AS FlagOrigenRemoto , ;
				.F. AS FlagDefault ;
			FROM ;
				goEntorno.LocPath+"GEntidades_Detalle"  ;
			WHERE ;
				CodigoEntidad == THIS.cCodigoEntidad AND FlagCriterio ;
			ORDER BY OrdenColumna ;
			INTO CURSOR (lcCursorTmp)
		ELSE
			*!*	Seleccionar todas las columnas (Para mantenimiento de Entidades)
			SELECT	;
				DescripcionCampo,;
				SPACE(60) AS _ValorAtributo, ;
				SPACE(1) AS cmdAyuda,;
				SPACE(60) AS ValorAtributo , ;
				NombreCampo, ;
				SecuenciaCampos, ;
				TipodatoCampo,;
				CodigoAtributo,;
				CodigoEntidadCampo,;
				CampoVisualizacion,;
				Camporetorno,;
				NombreEntidadCampo,;
				Codigotabla,;
				LongitudDato,;
				MascaraDato,;
				ModoObtenerDatos,;
				FlagBusqueda,;
				0 AS FlagOrigenRemoto , ;
				.F. AS FlagDefault ;
			FROM ;
				goEntorno.LocPath+"GEntidades_Detalle"  ;
			WHERE ;
				CodigoEntidad == THIS.cCodigoEntidad ;
			ORDER BY OrdenColumna ;
			INTO CURSOR (lcCursorTmp)
		ENDIF

		USE (DBF(lcCursorTmp)) IN 0 ALIAS (lcCursor) AGAIN
		USE IN (lcCursorTmp)

		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF

		THIS.cAliasColumnas = lcCursor

		IF EMPTY(_TALLY)
			THIS.nError		= 4
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		RETURN .T.
	ENDPROC


	PROCEDURE configurargridcriterios
		LPARAMETERS tcWhere, tnColumnas

		LOCAL lnParamtros , lnValores , lReturn , laValorAtributo

		lnParamtros	= PARAMETERS()

		*!*	Chequear Par�metros de Entrada
		DO CASE
			CASE lnParamtros = 0
				tcWhere		= ""
				tnColumnas	= 1
			CASE lnParamtros = 1
				tcWhere		= IIF(VARTYPE(tcWhere)=="C",ALLTRIM(tcWhere),"")
				tnColumnas	= 1
			CASE lnParamtros = 2
				tcWhere		= IIF(VARTYPE(tcWhere)=="C"		, ALLTRIM(tcWhere),"")
				tnColumnas	= IIF(VARTYPE(tnColumnas)== "L" , IIF(tnColumnas,1,2) , tnColumnas )
		ENDCASE

		THIS.cSQL = ""

		*!*	Chequear todas las propiedades que require el m�todo
		*!*	-----------------------------------------------------
		IF !(VARTYPE(THIS.oGrid)=="O" AND THIS.oGrid.BASECLASS=="Grid")
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		*!*	-----------------------------------------------------

		THIS.oGrid.RECORDSOURCE		= ""
		THIS.oGrid.RECORDSOURCETYPE = 4  && SQL

		lReturn	= THIS.GenerarColumnasCriterios( tnColumnas )

		IF  !lReturn	&& Ocurrio un Error en la ejecucion del m�todo anterior
			THIS.oGrid.INIT()
			RETURN .F.
		ENDIF

		IF !USED(THIS.cAliasColumnas)		&& No esta en uso el cursor necesario
			THIS.nError		= 3
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		SELECT(THIS.cAliasColumnas)

		*!*	Configurar los Valores por defecto
		THIS.CargarValoresDefault()
		SELECT(THIS.cAliasColumnas)
		GO TOP

		WITH THIS.oGrid
			.INIT()
			.RECORDSOURCETYPE = 1  && Alias
			.RECORDSOURCE = THIS.cAliasColumnas
			.REFRESH()
			.VISIBLE = .T.
		ENDWITH
		RETURN .T.
	ENDPROC


	*-- Extrae los atributos de la Plantilla (ATRIBUTO-VALOR)
	PROCEDURE generarplantilla
		LPARAMETER txParam

		LOCAL lnPlantilla
		LOCAL lcCodigoEntidad , lcNombreEntidad , lcCamposEdicionOrigen

		*!*	Validar el par�metro especificado
		DO CASE
			CASE VARTYPE(txParam) == "C"	&& Pas� como par�metro un Nombre de Tabla
				lcNombreEntidad	= ALLTRIM(SUBSTR(txParam,RAT('.',txParam)+1))
				lcCodigoEntidad	= SPACE(0)
				THIS.ValidarParametros(@lcCodigoEntidad,@lcNombreEntidad)
				lnTipoPlantilla = 2
				IF EMPTY(lcCodigoEntidad)	&& No se encontr� la Tabla
					=MESSAGEBOX("� No se pudo hallar Plantilla para la Tabla !",64,"Error en Par�metro")
					RETURN .F.
				ENDIF
			CASE VARTYPE(txParam) == "N"	&& Pas� como par�metro un N�mero, indica tipo de plantilla
				lnTipoPlantilla = IIF(BETWEEN(txParam,0,6),txParam,1)
				lcNombreEntidad	= SPACE(0)
				lcCodigoEntidad	= SPACE(0)
			OTHERWISE
				lnTipoPlantilla = 0
				lcNombreEntidad	= SPACE(0)
				lcCodigoEntidad	= SPACE(0)
		ENDCASE


		*!*	Quitar el Enlaze de la Grilla con cualquier Alias de Tablas para que no se deforme la Grilla
		THIS.oGrid.RECORDSOURCE = ""
		THIS.oGrid.RECORDSOURCETYPE = 4
		THIS.oGrid.REFRESH()


		IF ISNULL(THIS.cClavePlantilla) OR EMPTY(THIS.cClavePlantilla)
			RETURN .F.
		ENDIF

		*!* En caso de que el Cursor ya se encuentre abierto
		IF !ISNULL(THIS.cAliasAtributos) AND !EMPTY(THIS.cAliasAtributos)
			IF USED(THIS.cAliasAtributos)
				USE IN (THIS.cAliasAtributos)
			ENDIF
		ELSE
			THIS.cAliasAtributos = SYS(2015)
		ENDIF

		lcCamposEdicionOrigen = ""
		FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
			IF EMPTY(THIS.cTipoDatoCamposEdicion)
				lcValorDefault = "SPACE(40)"
			ELSE
				DO CASE
					CASE THIS.aTipoDatoCamposEdicion[I] == 'N'
						lcValorDefault = "000000.0000"
					CASE THIS.aTipoDatoCamposEdicion[I] == 'C'
						lcValorDefault = "SPACE(40)"
					CASE THIS.aTipoDatoCamposEdicion[I] == 'L'
						lcValorDefault = "CAST('0' AS BIT)"
					CASE THIS.aTipoDatoCamposEdicion[I] == 'D'
						lcValorDefault = "GETDATE()"
					OTHERWISE
						lcValorDefault = "SPACE(40)"
				ENDCASE
			ENDIF
			lcCamposEdicionOrigen = lcCamposEdicionOrigen + lcValorDefault + " AS "+ALLTRIM(THIS.aCamposEdicionOrigen[I])+" , "
			lcCamposEdicionOrigen = lcCamposEdicionOrigen + lcValorDefault + " AS "+ALLTRIM("_"+THIS.aCamposEdicionOrigen[I])+" , "
		ENDFOR
		lcCamposEdicionOrigen = LEFT(lcCamposEdicionOrigen,LEN(lcCamposEdicionOrigen)-3)

		THIS.cWhereSQL	= IIF(TYPE("THIS.cWhereSQL")=="C",ALLTRIM(THIS.cWhereSQL),"")

		DO CASE
			CASE lnTipoPlantilla == 0		&& Cargar Atributos de Producto
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad("CLAGEN_GProductos_Familia_Atributos")+;
					" WHERE CodigoProducto+CodigoFamilia ='"+THIS.cClavePlantilla+"'" + ;
					" AND IndicaSiAtributoComponente=0 " + THIS.cWhereSQL + ;
					" ORDER BY OrdenAtributos"
			CASE lnTipoPlantilla == 1		&& Cargar Atributos de Componente de Producto
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad("CLAGEN_GProductos_Familia_Atributos")+;
					" WHERE CodigoProducto+CodigoFamilia ='"+THIS.cClavePlantilla+"'" + ;
					" AND IndicaSiAtributoComponente=1 " + THIS.cWhereSQL + ;
					" ORDER BY OrdenAtributos"
			CASE lnTipoPlantilla == 2		&& Cargar Atributos de Entidad
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad("CLAGEN_Plantilla_Atributos_Entidad")+;
					" WHERE CodigoEntidad ='" + lcCodigoEntidad + "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 3		&& Cargar Atributos de Ruta de Acabado (VSJ - 28/08/00)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoTipoAcabado+CodigoProcesoAcabado ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 4		&& Cargar Regulaciones de M�quina (VSJ - 11/09/00)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoMaquina ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 5		&& Atributos de M�quina Tipo (VSJ - 29/09/00)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoMaquinaTipo ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 6		&& Atributos de Bloque (SYP - 12/10/2000)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoBloque ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL

		ENDCASE
		*goEntorno.conexion.cCursor = IIF(!ISNULL(THIS.cAliasAtributos) AND !EMPTY(THIS.cAliasAtributos),THIS.cAliasAtributos,'')
		goConexion.cCursor = THIS.cAliasAtributos

		lReturn = ( goConexion.DoSQL(THISFORM.DATASESSIONID) > 0 )

		IF lReturn
			*THIS.cAliasAtributos = goEntorno.conexion.cCursor
			THIS.oGrid.RECORDSOURCETYPE = 1  && Alias
			THIS.oGrid.RECORDSOURCE = THIS.cAliasAtributos
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				IF !EMPTY(THIS.oGrid.COLUMNS(I).TAG) AND !ISNULL(THIS.oGrid.COLUMNS(I).TAG)
					THIS.oGrid.COLUMNS(I).CONTROLSOURCE = THIS.cAliasAtributos+"."+ALLTRIM(THIS.oGrid.COLUMNS(I).TAG)
				ENDIF
			ENDFOR
			THIS.oGrid.REFRESH()
			THIS.oGrid.SETALL("DYNAMICBACKCOLOR","IIF(TYPE('IndicaSiAtributoRelevante')=='L' AND IndicaSiAtributoRelevante,RGB(230,255,255),RGB(255,255,255))","COLUMN")
			=CURSORSETPROP("Buffering", 5, THIS.cAliasAtributos )
		ELSE
			THIS.oGrid.RECORDSOURCE = ""
			THIS.oGrid.RECORDSOURCETYPE = 4  && Alias
			THIS.oGrid.REFRESH()
		ENDIF
		RETURN lReturn
	ENDPROC


	*-- Obtiene los valores de los atributos desde la entidad origen (ATRIBUTO-VALOR)
	PROCEDURE cargarvaloresatributos
		LOCAL lcSQL_Update , lcCodigoAtributo , lcNombreEntidadCampo
		LOCAL lcCampoRetorno , lcCampoVisualizacion	, lcModoObtenerDatos
		LOCAL lcSecuenciaCampos	, lcAlias

		WITH THIS
			IF !EMPTY(.cValoresClaveOrigen) AND !ISNULL(.cValoresClaveOrigen)
				*!*	 -----------------------------------------------------------
				*!*	Reemplazar todos los Valores de los campos de edici�n por valores en blanco
				*!*	 -----------------------------------------------------------
				lcSQL_Update = "UPDATE " + .cAliasAtributos + " SET "
				FOR I=1 TO ALEN(.aCamposEdicionOrigen)

					IF EMPTY(THIS.cTipoDatoCamposEdicion)
						lcValorDefault = "SPACE(0)"
					ELSE
						DO CASE
							CASE THIS.aTipoDatoCamposEdicion[I] == 'N'
								lcValorDefault = "0"
							CASE THIS.aTipoDatoCamposEdicion[I] == 'C'
								lcValorDefault = "SPACE(0)"
							CASE THIS.aTipoDatoCamposEdicion[I] == 'L'
								lcValorDefault = ".F."
							CASE THIS.aTipoDatoCamposEdicion[I] == 'D'
								lcValorDefault = "{}"
							OTHERWISE
								lcValorDefault = "SPACE(0)"
						ENDCASE
					ENDIF

					lcSQL_Update = lcSQL_Update + ALLTRIM(THIS.aCamposEdicionOrigen[I]) + "=" + lcValorDefault + ", " + ;
						"_"+ALLTRIM(THIS.aCamposEdicionOrigen[I]) + "=" + lcValorDefault + " , "
				ENDFOR
				lcSQL_Update = lcSQL_Update + " FlagOrigenRemoto=0"
				&lcSQL_Update

				=TABLEUPDATE(.T.,.T.,.cAliasAtributos)

				*!*	Obtener los Valores de los Atributos desde el servidor
				goConexion.cSQL = ;
					"SELECT * FROM "+.cEntidadOrigenAtributos+;
					" WHERE " +	STRTRAN(.cCamposClaveOrigen,';','+')+"='"+;
					STRTRAN(ALLTRIM(.cValoresClaveOrigen),';','')+"'"
				goConexion.cCursor = ''
				goConexion.DoSQL(THISFORM.DATASESSIONID)
				SELECT(goConexion.cCursor)
				lcAlias = ALIAS()

				*!*	-----------------------------------------------------------
				*!*	Actualizar el cursor con los valores de los atributos que se obtuvieron
				*!*	-----------------------------------------------------------
				GO TOP
				lcSQL_Update = ""
				THIS.nRegistros = 0
				SCAN WHILE NOT EOF()
					THIS.nRegistros = THIS.nRegistros + 1
					THIS.Actualizar_Registro(.cAliasAtributos)
					SELECT(lcAlias)
				ENDSCAN
				SELECT (lcALias)
				USE
				SELECT (.cAliasAtributos)
				=TABLEUPDATE(.T.,.T.,.cAliasAtributos)
				GO TOP IN (.cAliasAtributos)
			ENDIF
			IF USED('GTablas_Detalle')
				USE IN GTablas_Detalle
			ENDIF
			SELECT(.cAliasAtributos)
		ENDWITH
	ENDPROC


	*-- Guarda los cambios de los atributos en las tablas de Destino (ATRIBUTO-VALOR)
	PROCEDURE grabaratributovalor
		LPARAMETER lActualizar
		IF PARAMETERS() = 0
			lActualizar = .T.
		ELSE
			lActualizar = .F.
		ENDIF

		LOCAL lcSQL_Update ,  lcSQL_Insert , lcWhere , lcVariable
		LOCAL lnControl

		IF ISNULL(THIS.cAliasAtributos) OR EMPTY(THIS.cAliasAtributos)
			RETURN .F.
		ENDIF

		SELECT(THIS.cAliasAtributos)

		*!*	Filtrar todos los atributos que viuenen del servidor ademas
		*!*	de los que contienen valores y son de origen local
		lcFiltro = "SET FILTER TO FlagOrigenRemoto==1 OR (FlagOrigenRemoto==2 AND ("
		FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)
			IF EMPTY(THIS.cTipoDatoCamposEdicion)
				lcFiltro = lcFiltro + "!EMPTY(_" + THIS.aCamposEdicionDestino[I] + ") AND "
			ELSE
				IF THIS.aTipoDatoCamposEdicion[I] <> 'L'
					lcFiltro = lcFiltro + "!EMPTY(_" + THIS.aCamposEdicionDestino[I] + ") AND "
				ENDIF
			ENDIF
		ENDFOR
		lcFiltro = LEFT(lcFiltro,LEN(lcFiltro)-5) + ") )"
		&lcFiltro
		GO TOP
		lcSQL_Update = ""
		lcSQL_Insert = ""
		lcWhere		 = ""
		lnControl	 = 1

		FOR I=1 TO ALEN(THIS.aCamposClaveDestino)
			lcWhere = lcWhere + ALLTRIM(THIS.aCamposClaveDestino[I]) + "='" + ;
				ALLTRIM(THIS.aValoresClaveDestino[I]) + "' AND "
		ENDFOR

		IF !EMPTY(lcWhere) AND !ISNULL(lcWhere)
			lcWhere = LEFT(lcWhere,LEN(lcWhere)-5)
		ENDIF

		SELECT(THIS.cAliasAtributos)
		*!*	Obtener el N�mero del Registro Modificado

		*lnRecno = GETNEXTMODIFIED(0)

		*!*	Para forzar la Grabacion si se trata de grabar en otra tabla
		m.lForzarGrabacion	= THIS.cValoresClaveOrigen <> THIS.cValoresClaveDestino OR THIS.cEntidadOrigenAtributos <> THIS.cEntidadDestinoAtributos

		*DO WHILE lnRecno <> 0		&& Mientras exista algun registro modificado

		SCAN WHILE NOT EOF()		&& OJO------ Cambio temporal
			*IF EMPTY(lnRecno)
			*	EXIT
			*ENDIF
			*!*	Situarse en el registro que ha sufrido algun cambio
			*GO lnRecno IN (THIS.cAliasAtributos)

			*!*	Verificar si los campos han sufrido algun cambio
			*llBack = .T.
			*FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)	&& Indica cuantos campos de edici�n se maneja
			*	FOR J=1 TO FCOUNT()						&& Comprobar todos los campos
			*		IF THIS.aCamposEdicionDestino[I]=FIELD(J)	&& Es el campo de edici�n
			*			*IF GETFLDSTATE(J)==2	&& El registro fu� modificado
			*			IF OLDVAL(FIELD(J))<>EVAL(FIELD(J))	&& �Los valores actual e inicial sean diferentes?
			*				llBack = .F.
			*				EXIT
			*			ENDIF
			*		ENDIF
			*	ENDFOR
			*	IF llBack
			*		EXIT
			*	ENDIF
			*ENDFOR

			*IF llBack		&& No se modific� ese registro
			*	=TABLEUPDATE(.F.,.T.)
			*!*	Obtener el N�mero del Registro Modificado
			*	lnRecno = GETNEXTMODIFIED(lnRecno)
			*	LOOP
			*ENDIF

			IF FlagOrigenRemoto == 1 AND !m.lForzarGrabacion	&& Viene del Servidor
				*lcSQL_Update = "UPDATE "+THIS.cEntidadDestinoAtributos+" SET "
				lcSQL_Update = ""
				lnVacio = 0
				FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)
					lcCampoEdicionDestino	= ALLTRIM(THIS.aCamposEdicionDestino[I])
					lcVariable				= "m.xx_" + ALLTRIM(STR(I)) + "_" + lcCampoEdicionDestino
					PUBLIC &lcVariable
					&lcVariable				= EVAL(lcCampoEdicionDestino)
					lcSQL_Update = lcSQL_Update + ;
						lcCampoEdicionDestino + " = ?" + lcVariable + " , "
					*	lcCampoEdicionDestino + " = '" + ALLTRIM(&lcCampoEdicionDestino) + "' , "

					IF EMPTY(&lcCampoEdicionDestino)
						lnVacio = lnVacio + 1
					ENDIF
				ENDFOR

				lcSQL_Update = LEFT(lcSQL_Update,LEN(lcSQL_Update)-3)

				IF lnVacio = ALEN(THIS.aCamposEdicionDestino)
					lcSQL_Update = "DELETE " + THIS.cEntidadDestinoAtributos
				ELSE
					lcSQL_Update = "UPDATE " + THIS.cEntidadDestinoAtributos + " SET " + ;
						"FHModificacion = GETDATE() , " + ;
						"EstacionModificacion = '" + goEntorno.USER.Estacion + "' , " + ;
						"UsuarioModificacion = '" + goEntorno.USER.Login + "', " + lcSQL_Update
				ENDIF
				lcSQL_Update = lcSQL_Update + ;
					" WHERE " + lcWhere + " AND CodigoAtributo = '" + CodigoAtributo + "'"
				*=MESSAGEBOX(lcSQL_Update)
				goConexion.cSQL = lcSQL_Update
			ELSE						&& Es Local
				lcSQL_Insert = "INSERT  "+THIS.cEntidadDestinoAtributos+" ("+;
					ALLTRIM(STRTRAN(THIS.cCamposClaveDestino,";",",")) + ;
					",CodigoAtributo,UsuarioCreacion,FHCreacion,EstacionCreacion"+;
					",UsuarioModificacion,FHModificacion,EstacionModificacion," + ;
					ALLTRIM(STRTRAN(THIS.cCamposEdicionDestino,";",",")) + ;
					") VALUES ('"+;
					ALLTRIM(STRTRAN(THIS.cValoresClaveDestino,";","','")) + ;
					"','"+CodigoAtributo+ "','" + goEntorno.USER.Login + "',GETDATE()," + ;
					"'" + goEntorno.USER.Estacion + "','" + goEntorno.USER.Login + "',GETDATE()," + ;
					"'" + goEntorno.USER.Estacion + "' , "

				FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)
					lcCampoEdicionDestino	= ALLTRIM(THIS.aCamposEdicionDestino[I])
					lcVariable				= "m.xx_" + ALLTRIM(STR(I)) + "_" + lcCampoEdicionDestino
					PUBLIC &lcVariable
					&lcVariable				= EVAL(lcCampoEdicionDestino)

					lcSQL_Insert = lcSQL_Insert + ;
						"?" + lcVariable + " , "
					*	"'" + ALLTRIM(&lcCampoEdicionDestino) + "' , "
				ENDFOR
				lcSQL_Insert = LEFT(lcSQL_Insert,LEN(lcSQL_Insert)-3) + ")"
				*=MESSAGEBOX(lcSQL_Insert)
				goConexion.cSQL = lcSQL_Insert
			ENDIF

			*=MESSAGEBOX(goConexion.cSQL)
			*DISP MEMO TO FILE C:\WINDOWS\ESCRITORIO\MEMORIA.TXT
			*MODIFY COMMAND C:\WINDOWS\ESCRITORIO\MEMORIA.TXT IN SCREEN

			lnControl = goConexion.DoSQL()
			IF lnControl>0
				IF lActualizar
					REPLACE FlagOrigenRemoto WITH 1
					=TABLEUPDATE(.F.,.T.)
				ENDIF
			ELSE
				=MESSAGEBOX("No se pudo guardar los datos del Atributo "+ALLTRIM(DesCripcionCampo),;
					64,"Error al grabar")
			ENDIF
			*!*	Obtener el N�mero del Registro Modificado
			*lnRecno = GETNEXTMODIFIED(lnRecno)
			*ENDDO
		ENDSCAN
		SET FILTER TO
		GO TOP
		THIS.oGrid.REFRESH()
		RELEASE ALL LIKE xx_
		RETURN lnControl>0
	ENDPROC


	*-- Convierte una cadena con delimitadores a una matriz
	PROCEDURE chrtoarray
		*!*	Convertir una cadena en una matriz seg�n sus separadores.
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
	ENDPROC


	HIDDEN PROCEDURE cvaloresclavedestino_assign
		LPARAMETERS tcValoresClaveDestino

		*!*	Inicializar Matriz temporal
		LOCAL laValoresClaveDestino
		DIMENSION laValoresClaveDestino[1]
		STORE SPACE(0) TO laValoresClaveDestino

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresClaveDestino)=="C"
			tcValoresClaveDestino	= ALLTRIM(tcValoresClaveDestino)
			tcValoresClaveDestino	= CHRTRAN(tcValoresClaveDestino,SPACE(1),SPACE(0))
			THIS.cValoresClaveDestino = tcValoresClaveDestino

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresClaveDestino , ";" , @laValoresClaveDestino )

		ENDIF
		nLen = ALEN(laValoresClaveDestino)
		DIMENSION THIS.aValoresClaveDestino(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresClaveDestino,THIS.aValoresClaveDestino)
	ENDPROC


	HIDDEN PROCEDURE ccamposedicionorigen_assign
		LPARAMETERS tcCamposEdicionOrigen

		*!*	Inicializar Matriz temporal
		LOCAL laCamposEdicionOrigen
		DIMENSION laCamposEdicionOrigen[1]
		STORE SPACE(0) TO laCamposEdicionOrigen

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposEdicionOrigen)=="C"
			tcCamposEdicionOrigen	= ALLTRIM(tcCamposEdicionOrigen)
			tcCamposEdicionOrigen	= CHRTRAN(tcCamposEdicionOrigen,SPACE(1),SPACE(0))
			THIS.cCamposEdicionOrigen = tcCamposEdicionOrigen

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposEdicionOrigen , ";" , @laCamposEdicionOrigen )

		ENDIF
		nLen = ALEN(laCamposEdicionOrigen)
		DIMENSION THIS.aCamposEdicionOrigen(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposEdicionOrigen,THIS.aCamposEdicionOrigen)
	ENDPROC


	HIDDEN PROCEDURE ccamposclaveorigen_assign
		LPARAMETERS tcCamposClaveOrigen

		*!*	Inicializar Matriz temporal
		LOCAL laCamposClaveOrigen
		DIMENSION laCamposClaveOrigen[1]
		STORE SPACE(0) TO laCamposClaveOrigen

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposClaveOrigen)=="C"
			tcCamposClaveOrigen	= ALLTRIM(tcCamposClaveOrigen)
			tcCamposClaveOrigen	= CHRTRAN(tcCamposClaveOrigen,SPACE(1),SPACE(0))
			THIS.cCamposClaveOrigen = tcCamposClaveOrigen

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposClaveOrigen , ";" , @laCamposClaveOrigen )

		ENDIF
		nLen = ALEN(laCamposClaveOrigen)
		DIMENSION THIS.aCamposClaveOrigen(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposClaveOrigen,THIS.aCamposClaveOrigen)
	ENDPROC


	HIDDEN PROCEDURE ccamposclavedestino_assign
		LPARAMETERS tcCamposClaveDestino

		*!*	Inicializar Matriz temporal
		LOCAL laCamposClaveDestino
		DIMENSION laCamposClaveDestino[1]
		STORE SPACE(0) TO laCamposClaveDestino

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposClaveDestino)=="C"
			tcCamposClaveDestino	= ALLTRIM(tcCamposClaveDestino)
			tcCamposClaveDestino	= CHRTRAN(tcCamposClaveDestino,SPACE(1),SPACE(0))
			THIS.cCamposClaveDestino = tcCamposClaveDestino

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposClaveDestino , ";" , @laCamposClaveDestino )
		ENDIF
		nLen = ALEN(laCamposClaveDestino)
		DIMENSION THIS.aCamposClaveDestino(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposClaveDestino,THIS.aCamposClaveDestino)
	ENDPROC


	HIDDEN PROCEDURE ccamposediciondestino_assign
		LPARAMETERS tcCamposEdicionDestino

		*!*	Inicializar Matriz temporal
		LOCAL laCamposEdicionDestino
		DIMENSION laCamposEdicionDestino[1]
		STORE SPACE(0) TO laCamposEdicionDestino

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposEdicionDestino)=="C"
			tcCamposEdicionDestino	= ALLTRIM(tcCamposEdicionDestino)
			tcCamposEdicionDestino	= CHRTRAN(tcCamposEdicionDestino,SPACE(1),SPACE(0))
			THIS.cCamposEdicionDestino = tcCamposEdicionDestino

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposEdicionDestino , ";" , @laCamposEdicionDestino )

		ENDIF
		nLen = ALEN(laCamposEdicionDestino)
		DIMENSION THIS.aCamposEdicionDestino(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposEdicionDestino,THIS.aCamposEdicionDestino)
	ENDPROC


	HIDDEN PROCEDURE generarsecuenciacampos
		LPARAMETER tcTn
		tcTn = tcTn + "."

		LOCAL cAtributo , cAlias , lcNombreCampo
		LOCAL laSecuencia
		DIMENSION laSecuencia[1]
		cAlias = ALIAS()
		lcNombreCampo = ""
		WITH THIS
			DIMENSION aAtributos[1]
			IF !EMPTY(SecuenciaCampos) AND !ISNULL(SecuenciaCampos)
				THIS.ChrToArray( SecuenciaCampos, ";" , @aAtributos)
				FOR I=1 TO ALEN(aAtributos)
					cAtributo = ALLTRIM(aAtributos[I])
					cCodigoEntidad = THIS.cCodigoEntidad
					SELECT NombreCampo,CampoRetorno ;
						FROM goEntorno.LocPath+"GEntidades_Detalle" ;
						WHERE CodigoAtributo == cAtributo AND ;
						CodigoEntidad  == cCodigoEntidad ;
						INTO ARRAY laSecuencia
					IF _TALLY>0
						lcValorCampo  = THIS.BuscarValorAtributo(UPPER(ALLTRIM(laSecuencia[1,1])))
						IF EMPTY(lcValorCampo)
							lcCampo = ALLTRIM(laSecuencia[1,2])
							lcCampo = IIF(ISNULL(lcCampo) OR EMPTY(lcCampo),laSecuencia[1,1],lcCampo)
							lcValorCampo = tcTn + ALLTRIM(lcCampo)
							lcNombreCampo = lcNombreCampo + "T000." + ALLTRIM(laSecuencia[1,1]) + "=" + ;
								lcValorCampo + " AND "
						ELSE
							lcNombreCampo = lcNombreCampo + tcTn + ALLTRIM(laSecuencia[1,1]) + "='" + ;
								lcValorCampo + "' AND "
						ENDIF
					ENDIF
				ENDFOR
			ENDIF
		ENDWITH
		IF !EMPTY(lcNombreCampo) AND !ISNULL(lcNombreCampo)
			lcNombreCampo = LEFT(lcNombreCampo,LEN(lcNombreCampo)-5)
		ENDIF
		IF USED("GAtributos")
			USE IN GAtributos
		ENDIF
		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF

		SELECT(cAlias)
		IF !EMPTY(lcNombreCampo) AND !ISNULL(lcNombreCampo)
			lcNombreCampo = " AND " + lcNombreCampo
		ENDIF
		RETURN lcNombreCampo
	ENDPROC


	*-- Busca en la matriz de aValoresFiltro del Objeto cmdHelp un valor segun el campo especificado
	HIDDEN PROCEDURE buscarvaloratributo
		LPARAMETER tcNombreCampo

		IF !(TYPE("THIS.oHelp")=="O" AND THIS.oHelp.BASECLASS=="Commandbutton")
			RETURN ""
		ENDIF
		lnPos = ASCAN(THIS.oHelp.aCamposFiltro,tcNombreCampo)
		IF lnPos > 0
			lcValor = THIS.oHelp.aValoresFiltro[lnPos]
		ELSE
			lcValor = ""
		ENDIF
		RETURN lcValor
	ENDPROC


	HIDDEN PROCEDURE cvaloresclaveorigen_assign
		LPARAMETERS tcValoresClaveOrigen

		*!*	Inicializar Matriz temporal
		LOCAL laValoresClaveOrigen
		DIMENSION laValoresClaveOrigen[1]
		STORE SPACE(0) TO laValoresClaveOrigen

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresClaveOrigen)=="C"
			tcValoresClaveOrigen	= ALLTRIM(tcValoresClaveOrigen)
			tcValoresClaveOrigen	= CHRTRAN(tcValoresClaveOrigen,SPACE(1),SPACE(0))
			THIS.cValoresClaveOrigen = tcValoresClaveOrigen

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresClaveOrigen , ";" , @laValoresClaveOrigen )

		ENDIF
		nLen = ALEN(laValoresClaveOrigen)
		DIMENSION THIS.aValoresClaveOrigen(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresClaveOrigen,THIS.aValoresClaveOrigen)
	ENDPROC


	HIDDEN PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		IF VARTYPE(tcWhereSQL)<>"C"
			tcWhereSQL = ""
		ELSE
			tcWhereSQL = ALLTRIM(tcWhereSQL)
		ENDIF
		THIS.cWhereSql = tcWhereSQL
	ENDPROC


	*-- Genera una clausula WHERE con los criterios seleccionados. (Entidades)
	PROCEDURE generarwheresqlcriterios
		SELECT(THIS.cAliasColumnas)
		GO TOP

		LOCAL m.lxInicio , m.lxFin
		LOCAL m.lnInicio , m.lnTamano
		LOCAL m.lcValorAtributo , m.lcDia , m.lcMes , m.lcAnio
		LOCAL m.lcWhereSQL, m.lcWhereSQL2

		lcWhereSQL = ""
		lcWhereSQL2= ""
		SCAN
			IF EMPTY(ValorAtributo)
				LOOP
			ENDIF
			lcValorAtributo	= ALLTRIM(ValorAtributo)
			lcNombreCampo	= ALLTRIM(NombreCampo)
			lcTipoDatoCampo	= ALLTRIM(TipoDatoCampo)
			lcValorAtributo2= ALLTRIM(_ValorAtributo)
			lcDescAtributo	= ALLTRIM(DescripcionCampo)
			lcWhereSQL		= lcWhereSQL + " AND ( "
			lcWhereSQL2	= lcWhereSQL2 + lcDescAtributo
			DO CASE
				CASE "<" $ lcValorAtributo AND ">" $ lcValorAtributo AND ";" $ lcValorAtributo
					*!*	Rango
					IF lcTipoDatoCampo == "D"
						lnInicio	= AT("<" , lcValorAtributo) + 1
						lnTamano	= AT(";" , lcValorAtributo) - lnInicio
						DO CASE
						CASE goEntorno.Conexion.cDateFormat == "DMY"
							lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
						CASE goEntorno.Conexion.cDateFormat == "MDY"
							lxInicio	= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))))+ " 00:00:00"
						OTHERWISE
							lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
						ENDCASE

						lnInicio	= AT(";" , lcValorAtributo) + 1
						lnTamano	= AT(">" , lcValorAtributo) - lnInicio

						DO CASE
						CASE goEntorno.Conexion.cDateFormat == "DMY"
							lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
						CASE goEntorno.Conexion.cDateFormat == "MDY"
							lxFin		= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)))) + " 23:59:59"
						OTHERWISE
							lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
						ENDCASE
					ELSE
						lnInicio	= AT("<" , lcValorAtributo)+1
						lnTamano	= AT(";" , lcValorAtributo)-m.lnInicio
						lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))

						lnInicio	= AT(";" , lcValorAtributo)+1
						lnTamano	= AT(">" , lcValorAtributo) - lnInicio
						lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))
					ENDIF
					DO CASE
						CASE lcTipoDatoCampo = "D"
							lcWhereSQL2	= lcWhereSQL2 + " ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " BETWEEN CAST('" + ;
								ALLTRIM(lxInicio) + "' AS DateTime) AND "+;
								"CAST('" + ALLTRIM(lxFin) + "' AS DateTime) "
						CASE lcTipoDatoCampo = "N"
							lcWhereSQL2	= lcWhereSQL2 + " QUE ESTE ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " BETWEEN " + ALLTRIM(lxInicio) + " AND " + ALLTRIM(lxFin) + " "
						CASE lcTipoDatoCampo = "C"
							lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] � [" + lxFin + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN('" + lxInicio + "','" + lxFin + "') "
							*!*	Igual que Caracter (por si aparaecen otros tipos de datos
						OTHERWISE
							lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] � [" + lxFin + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN('"+ lxInicio + "','" + lxFin + "') "
					ENDCASE
				CASE ";"$lcValorAtributo AND NOT ("<"$lcValorAtributo AND ">"$lcValorAtributo)
					*!*	Lista
					lcWhereSQL2		= lcWhereSQL2 + " QUE SE ENCUENTRE EN [" + lcValorAtributo2 + "]"
					DO CASE
						CASE lcTipoDatoCampo = "D"
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS DateTime), CAST(")
							lcValorAtributo	= "CAST(" + lcValorAtributo + " AS DateTime)"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + lcValorAtributo + ") "
						CASE lcTipoDatoCampo = "N"
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS Decimal(11,4)), CAST(")
							lcValorAtributo	= "CAST(" + lcValorAtributo+ " AS Decimal(11,4))"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + lcValorAtributo + ") "
						CASE lcTipoDatoCampo = "C"
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ,"','")
							lcWhereSQL		= lcWhereSQL + lcNombreCampo +" IN ('" + lcValorAtributo + "') "
							*!*	Igual que Caracter (por si aparaecen otros tipos de datos
						OTHERWISE
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" , "','")
							lcWhereSQL		= lcWhereSQL + "RTRIM(" + lcNombreCampo +") IN ('" + lcValorAtributo + "') "
					ENDCASE

				OTHERWISE
					*!*	Valor especifico
					IF lcTipoDatoCampo = "C" AND ;
							( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
							( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
						lcWhereSQL2	= lcWhereSQL2 + " PARECIDO A [" + ALLTRIM(lcValorAtributo2) + "]"
					ELSE
						lcWhereSQL2	= lcWhereSQL2 + " IGUAL A [" + ALLTRIM(lcValorAtributo2) + "]"
					ENDIF
					DO CASE
						CASE lcTipoDatoCampo = "C"
							IF ( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
									( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
							ELSE
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = '" + ALLTRIM(lcValorAtributo) + "' "
							ENDIF
						CASE lcTipoDatoCampo = "D"
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= CAST('" + ALLTRIM(lcValorAtributo) + "' AS DateTime) "
						CASE lcTipoDatoCampo = "N"
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = "+ ALLTRIM(lcValorAtributo)+ " "
						CASE lcTipoDatoCampo = "L"
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = "+ IIF(ALLTRIM(lcValorAtributo)=='SI','1','0')+ " "
							*!*	Igual que Caracter (por si aparaecen otros tipos de datos
						OTHERWISE
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
					ENDCASE
			ENDCASE
			lcWhereSQL	= lcWhereSQL + " ) "
			lcWhereSQL2	= lcWhereSQL2 + CHR(13)
		ENDSCAN
		IF !EMPTY(lcWhereSQL)
			THIS.cLiteralCriterios = lcWhereSQL2
		ELSE
			THIS.cLiteralCriterios = ""
		ENDIF
		*=messagebox(lcWhereSQL)
		RETURN lcWhereSQL
	ENDPROC


	*-- Genera una clausula WHERE con los atributos seleccionados (ATRIBUTO-VALOR)
	PROCEDURE generarwheresqlatributos
		SELECT(THIS.cAliasAtributos)
		GO TOP
		LOCAL m.lxInicio , m.lxFin
		LOCAL m.lnInicio , m.lnTamano
		LOCAL m.lcValorAtributo , m.lcDia , m.lcMes , m.lcAnio
		LOCAL m.lcWhereSQL , m.lcWhereSQL2
		LOCAL tn , I
		tn	= "T999."

		lcWhereSQL	= ""
		lcWhereSQL2	= ""

		THIS.nCriterios	= 0

		SCAN
			lReturn = .T.
			FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
				lcNombreCampoOrigen	= ALLTRIM(THIS.aCamposEdicionOrigen[I])
				IF !EMPTY(&lcNombreCampoOrigen)
					lReturn = .F.
				ENDIF
			ENDFOR
			IF lReturn	&& Indica que todos los campos de edici�n est�n vac�os
				LOOP
			ENDIF

			*!*	Recorrer cada campo de edici�n para generar el criterio (WHERE)
			THIS.nCriterios	= THIS.nCriterios + 1

			lcCodigoAtributo= CodigoAtributo
			lcDescAtributo	= ALLTRIM(DescripcionCampo)
			lcWhereSQL	= lcWhereSQL + tn + "CodigoAtributo = '" + lcCodigoAtributo + "' AND "
			lcWhereSQL2	= lcWhereSQL2 + lcDescAtributo
			lcTipoDatoCampo	= ALLTRIM(TipoDatoCampo)

			FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
				lcNombreCampo	= ALLTRIM(THIS.aCamposEdicionOrigen[I])
				lcNombreCampo2	= "_" + ALLTRIM(THIS.aCamposEdicionOrigen[I])

				*!*	Si es el primer campo de edicion, tomar el tipo de dato que trae la Configuracion
				IF I>1
					*!*	Si no, obtener el tipo de dato de la propiedad
					IF TYPE("THIS.aTipoDatoCamposEdicion[I]")=="C"
						lcTipoDatoCampo	= THIS.aTipoDatoCamposEdicion[I]
					ELSE
						*!*	En caso de no tener las propiedades, obtener del campo de la tabla
						lcTipoDatoCampo	= TYPE(&lcNombreCampo)
					ENDIF
				ENDIF
				DO CASE
				CASE lcTipoDatoCampo = "C" OR I=1
					lcValorAtributo	= ALLTRIM(&lcNombreCampo)
					lcValorAtributo2= ALLTRIM(&lcNombreCampo2)
				CASE lcTipoDatoCampo = "N" AND I>1
					lcValorAtributo	= ALLTRIM(STR(&lcNombreCampo,15,4))
					lcValorAtributo2= ALLTRIM(STR(&lcNombreCampo2,15,4))
				CASE lcTipoDatoCampo = "L" AND I>1
					lcValorAtributo	= IIF(&lcNombreCampo,"1","0")
					lcValorAtributo2= IIF(&lcNombreCampo2,"1","0")
				CASE lcTipoDatoCampo = "D" AND I>1
					lcValorAtributo	= DTOC(&lcNombreCampo)
					lcValorAtributo2= DTOC(&lcNombreCampo2)
				ENDCASE
				lcNombreCampo	= tn + ALLTRIM(THIS.aCamposEdicionOrigen[I])
				IF EMPTY(lcValorAtributo)
					LOOP
				ENDIF

				DO CASE
					CASE "<" $ lcValorAtributo AND ">" $ lcValorAtributo AND ";" $ lcValorAtributo
						*!*	Rango
						IF lcTipoDatoCampo == "D"
							lnInicio	= AT("<" , lcValorAtributo) + 1
							lnTamano	= AT(";" , lcValorAtributo) - lnInicio

							DO CASE
							CASE goEntorno.Conexion.cDateFormat == "DMY"
								lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
							CASE goEntorno.Conexion.cDateFormat == "MDY"
								lxInicio	= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))))+ " 00:00:00"
							OTHERWISE
								lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
							ENDCASE

							lnInicio	= AT(";" , lcValorAtributo) + 1
							lnTamano	= AT(">" , lcValorAtributo) - lnInicio

							DO CASE
							CASE goEntorno.Conexion.cDateFormat == "DMY"
								lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
							CASE goEntorno.Conexion.cDateFormat == "MDY"
								lxFin		= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)))) + " 23:59:59"
							OTHERWISE
								lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
							ENDCASE

						ELSE
							lnInicio	= AT("<" , lcValorAtributo)+1
							lnTamano	= AT(";" , lcValorAtributo)-m.lnInicio
							lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))

							lnInicio	= AT(";" , lcValorAtributo)+1
							lnTamano	= AT(">" , lcValorAtributo) - lnInicio
							lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))
						ENDIF
						DO CASE
							CASE lcTipoDatoCampo = "D"
								lcWhereSQL2	= lcWhereSQL2 + " ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS DateTime) " + ;
										" BETWEEN CAST('" + ALLTRIM(lxInicio) + "' AS DateTime) " + ;
										" AND CAST('" + ALLTRIM(lxFin) + "' AS DateTime) "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + ;
										" BETWEEN CAST('" + ALLTRIM(lxInicio) + "' AS DateTime) " + ;
										" AND CAST('" + ALLTRIM(lxFin) + "' AS DateTime) "
								ENDIF
							CASE lcTipoDatoCampo = "N"
								lcWhereSQL2	= lcWhereSQL2 + " QUE ESTE ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS Decimal(15,4) ) " + ;
										" BETWEEN " + ALLTRIM(lxInicio) + " AND " + ALLTRIM(lxFin) + " "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + ;
										" BETWEEN " + ALLTRIM(lxInicio) + " AND " + ALLTRIM(lxFin) + " "
								ENDIF
							CASE lcTipoDatoCampo = "C"
								lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] � [" + lxFin + "]"
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " IN('" + lxInicio + "','" + lxFin + "') "
								*!*	Igual que Caracter (por si aparaecen otros tipos de datos
							OTHERWISE
								lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] � [" + lxFin + "]"
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " IN('"+ lxInicio + "','" + lxFin + "') "
						ENDCASE
					CASE ";"$lcValorAtributo AND NOT ("<"$lcValorAtributo AND ">"$lcValorAtributo)
						*!*	Lista
						lcValorAtributo2= "[" + STRTRAN(lcValorAtributo2 , ";" , "],[") + "]"
						lcWhereSQL2		= lcWhereSQL2 + " QUE SE ENCUENTRE EN " + lcValorAtributo2
						DO CASE
							CASE lcTipoDatoCampo = "D"
								IF I=1
									lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS DateTime), CAST(")
									lcValorAtributo	= "CAST(" + lcValorAtributo + " AS DateTime)"
									lcWhereSQL		= lcWhereSQL + "CAST(" + lcNombreCampo + " AS DateTime) " + ;
										" IN (" + lcValorAtributo + ") "
								ELSE
									lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + STRTRAN(lcValorAtributo , ";" ,",") + ") "
								ENDIF
							CASE lcTipoDatoCampo = "N"
								IF I=1
									lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS Decimal(15,4)), CAST(")
									lcValorAtributo	= "CAST(" + lcValorAtributo+ " AS Decimal(15,4))"
									lcWhereSQL		= lcWhereSQL + "CAST(" + lcNombreCampo + " AS Decimal(15,4) ) " + ;
										" IN (" + lcValorAtributo + ") "
								ELSE
									lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + STRTRAN(lcValorAtributo , ";" ,",") + ") "
								ENDIF
							CASE lcTipoDatoCampo = "C"
								lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ,"','")
								lcWhereSQL		= lcWhereSQL + lcNombreCampo +" IN ('" + lcValorAtributo + "') "
								*!*	Igual que Caracter (por si aparaecen otros tipos de datos
							OTHERWISE
								lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ,"','")
								lcWhereSQL		= lcWhereSQL + lcNombreCampo +" IN ('" + lcValorAtributo + "') "
						ENDCASE

					OTHERWISE
						*!*	Valor especifico
						IF lcTipoDatoCampo = "C" AND ;
								( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
								( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
							lcWhereSQL2	= lcWhereSQL2 + " PARECIDO A [" + ALLTRIM(lcValorAtributo2) + "]"
						ELSE
							lcWhereSQL2	= lcWhereSQL2 + " IGUAL A [" + ALLTRIM(lcValorAtributo2) + "]"
						ENDIF
						DO CASE
							CASE lcTipoDatoCampo = "C"
								IF ( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
										( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = '" + ALLTRIM(lcValorAtributo) + "' "
								ENDIF
							CASE lcTipoDatoCampo = "D"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS DateTime) " + ;
										"= CAST('" + ALLTRIM(lcValorAtributo) + "' AS DateTime) "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= CAST('" + ALLTRIM(lcValorAtributo) + "' AS DateTime) "
								ENDIF
							CASE lcTipoDatoCampo = "N"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS Decimal(15,4) ) " + ;
										"= "+ ALLTRIM(lcValorAtributo)+ " "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= "+ ALLTRIM(lcValorAtributo)+ " "
								ENDIF
							CASE lcTipoDatoCampo = "L"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS BIT) " + ;
										"= "+ IIF(ALLTRIM(lcValorAtributo)=='SI','1','0')+ " "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= "+ lcValorAtributo+ " "
								ENDIF
								*!*	Igual que Caracter (por si aparaecen otros tipos de datos
							OTHERWISE
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
						ENDCASE
				ENDCASE
				lcWhereSQL	= lcWhereSQL + " AND "
				lcWhereSQL2	= lcWhereSQL2 + CHR(13)
			ENDFOR
				lcWhereSQL	= SUBSTR(lcWhereSQL,1,LEN(lcWhereSQL)-6) + " ) OR ( "
				lcWhereSQL2	= lcWhereSQL2 + CHR(13)
		ENDSCAN
		IF !EMPTY(lcWhereSQL)
			lcWhereSQL	= " ( ( " + LEFT(lcWhereSQL,LEN(lcWhereSQL)-6) + " ) "
			THIS.cLiteralAtributos = lcWhereSQL2
		ELSE
			THIS.cLiteralAtributos = ""
		ENDIF
		*!*	=messagebox(lcWhereSQL)
		*!*	=STRTOFILE(lcWhereSQL,"C:\WINDOWS\ESCRITORIO\SQL.TXT")
		RETURN lcWhereSQL
	ENDPROC


	*-- Genera la Senetencia SQL para la busqueda por ATRIBUTO-VALOR
	PROCEDURE generarsqlatributos
		LOCAL lcSQL
		LOCAL lcWhereSQL
		lcWhereSQL = THIS.GenerarWhereSQLAtributos()
		*!*	Obtener los Valores de los Atributos desde el servidor
		IF !EMPTY(lcWhereSQL)
			lcSQL = "AND EXISTS ( " + ;
				"SELECT " + "T999."+STRTRAN(THIS.cCamposClaveOrigen,';',' , T999.') + ;
				" FROM "  + THIS.cEntidadOrigenAtributos + " T999 " + ;
				" WHERE " + lcWhereSQL + " AND ( " + ;
				" T999." + STRTRAN(THIS.cCamposClaveOrigen,';',' + T999.') + "=" + ;
				" T000." + STRTRAN(THIS.cCamposClaveOrigen,';',' + T000.') + " ) " + ;
				" GROUP BY " + "T999."+STRTRAN(THIS.cCamposClaveOrigen,';',',T999.') + ;
				" HAVING count(*) >= " + ALLTRIM(STR(THIS.nCriterios)) + " ) "
		ELSE
			lcSQL = ""
		ENDIF
		RETURN lcSQL
	ENDPROC


	HIDDEN PROCEDURE cvaloresdefault_assign
		LPARAMETERS tcValoresDefault

		*!*	Inicializar Matriz temporal
		LOCAL laValoresDefault
		DIMENSION laValoresDefault[1]
		STORE SPACE(0) TO laValoresDefault

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresDefault)=="C"
			tcValoresDefault	= ALLTRIM(tcValoresDefault)
			tcValoresDefault	= CHRTRAN(tcValoresDefault,SPACE(1),SPACE(0))
			THIS.cValoresDefault = tcValoresDefault

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresDefault , ";" , @laValoresDefault )

		ENDIF
		nLen = ALEN(laValoresDefault)
		DIMENSION THIS.aValoresDefault(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresDefault,THIS.aValoresDefault)
	ENDPROC


	HIDDEN PROCEDURE catributosdefault_assign
		LPARAMETERS tcAtributosDefault

		*!*	Inicializar Matriz temporal
		LOCAL laAtributosDefault
		DIMENSION laAtributosDefault[1]
		STORE SPACE(0) TO laAtributosDefault

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcAtributosDefault)=="C"
			tcAtributosDefault	= ALLTRIM(tcAtributosDefault)
			tcAtributosDefault	= CHRTRAN(tcAtributosDefault,SPACE(1),SPACE(0))
			THIS.cAtributosDefault = tcAtributosDefault

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcAtributosDefault , ";" , @laAtributosDefault )

		ENDIF
		nLen = ALEN(laAtributosDefault)
		DIMENSION THIS.aAtributosDefault(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laAtributosDefault,THIS.aAtributosDefault)
	ENDPROC


	*-- Actualiza un registro segun el dato cargado (ATRIBUTO-VALOR)
	HIDDEN PROCEDURE actualizar_registro
		*!*	Actualiza el registro correspondiente al campo seleccionado (Criterios de Seleccion)
		LPARAMETERS tcAlias , lcCodigoAtributo , lcValores
		lnParameters = PARAMETERS()
		lcAlias = ALIAS()

		LOCAL lReadOnly , lcVariable , laValores

		DO CASE
		CASE lnParameters==0
			tcAlias = THIS.cAliasAtributos
		CASE lnParameters==1
			lcCodigoAtributo	= CodigoAtributo
			lcValores			= ""
		CASE lnParameters==2
			tcValores	= ""
		ENDCASE


		DIMENSION laValores[1]
		STORE "" TO laValores

		IF LEFT(lcCodigoAtributo,1)=="#"
			lReadOnly = .T.
			lcCodigoAtributo = SUBSTR(lcCodigoAtributo,2)
		ELSE
			lReadOnly = .F.
		ENDIF

		lcSQL_Update 	= "UPDATE " + tcAlias + " SET "

		SELECT(tcAlias)

		IF TYPE("FlagDefault")=="L" AND lReadOnly
			lcSQL_Update	= "UPDATE " + tcAlias + " SET FlagDefault=.T. , "
		ENDIF

		*!*	Buscar en la tabla, las propiedades del atributo
		LOCATE ALL FOR CodigoAtributo=lcCodigoAtributo
		lcNombreEntidadCampo	= NombreEntidadCampo
		lcCodigoTabla			= CodigoTabla
		lcCampoRetorno			= CampoRetorno
		lcCampoVisualizacion	= CampoVisualizacion
		lcModoObtenerDatos		= ModoObtenerDatos
		lcSecuenciaCampos		= SecuenciaCampos
		lcTipoDatoCampo			= TipoDatoCampo

		*!*	Si es un campo de edici�n, no extraer la descripci�n de la tabla de origen
		*!*	s�lo mostrar el valor digitado (Ejm. NumeroOT, se valida en otra tabla pero
		*!*	s�lo debe mostrarse el numero de Ot digitado, no una descripci�n de la misma)

		IF !ISNULL(lcModoObtenerDatos) AND lcModoObtenerDatos == "E"	&& Edicion
			lcNombreEntidadCampo	= ""
			lcCodigoTabla			= ""
			lcCampoRetorno			= ""
			lcCampoVisualizacion	= ""
			lcSecuenciaCampos		= ""
		ENDIF

		IF !EMPTY(lcValores)
			THIS.chrToArray(lcValores , ";" , @laValores)
		ENDIF

		SELECT(lcAlias)


		FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
			lcNombreCampoOrigen1 = ALLTRIM(THIS.aCamposEdicionOrigen[I])
			lcNombreCampoOrigen2 = "_"+ALLTRIM(THIS.aCamposEdicionOrigen[I])

			*!*	 -----------------------------------------------------------
			*!*	Si el atributo se valida en otra tabla, traer la descripcion y el codigo
			*!*	 -----------------------------------------------------------
			lcVariable			= "m.xx_" + ALLTRIM( STR(I) ) + "_" + lcNombreCampoOrigen1
			lcVariable2			= "m.xx_" + ALLTRIM( STR(I) ) + "" + lcNombreCampoOrigen1
			PUBLIC &lcVariable , &lcVariable2

			IF EMPTY(lcValores)
				*lcValorCampoOrigen1 = IIF(ISNULL(&lcNombreCampoOrigen1),"",ALLTRIM(&lcNombreCampoOrigen1))
				&lcVariable			= EVAL(lcNombreCampoOrigen1)
				IF lcTipoDatoCampo == 'L'
					&lcVariable2		= IIF( ALLTRIM(EVAL(lcNombreCampoOrigen1)) == '1' , 'SI','NO')
				ELSE
					&lcVariable2		= EVAL(lcNombreCampoOrigen1)
				ENDIF
				lcValorCampoOrigen1 = &lcNombreCampoOrigen1
			ELSE
				lcValorCampoOrigen1 = IIF(TYPE("laValores[I]")<>"C","",ALLTRIM(laValores[I]))
				&lcVariable			= IIF(TYPE("laValores[I]")<>"C","",ALLTRIM(laValores[I]))
				&lcVariable2		= IIF(TYPE("laValores[I]")<>"C","",ALLTRIM(laValores[I]))
			ENDIF

			DO CASE
			*!*	El atributo se valida en otra entidad
			CASE !ISNULL(lcNombreEntidadCampo) AND !EMPTY(lcNombreEntidadCampo)	AND ;
				 (ISNULL(lcCodigoTabla) OR EMPTY(lcCodigoTabla)) AND VARTYPE(lcValorCampoOrigen1)=="C"

				THIS.oHelp.ConfigurarParametros(lcValorCampoOrigen1,;
								SUBSTR(lcNombreEntidadCampo,RAT('.',lcNombreEntidadCampo)+1),;
								lcCampoRetorno , lcCampoVisualizacion , .t. , "" , "" , ;
								lcModoObtenerDatos , lcSecuenciaCampos)

				SELECT(tcAlias)
				THIS.oHelp.GenerarSecuenciaCampos()

				IF THIS.oHelp.ValidarDato(lcValorCampoOrigen1)
					SELECT(lcAlias)
					IF TYPE("&lcVariable2")== TYPE("THIS.oHelp.cValorDescripcion")
						&lcVariable2 = THIS.oHelp.cValorDescripcion
					ENDIF

					lcSQL_Update = lcSQL_Update + ;
						lcNombreCampoOrigen2 + "= " + lcVariable2 + " ,"
						*lcNombreCampoOrigen2 + "='" + THIS.oHelp.cValorDescripcion + "',"

				ENDIF

			*!*	El atributo se valida en Tabla de Tablas (GTablas_Detalle)
			CASE !ISNULL(lcCodigoTabla) AND !EMPTY(lcCodigoTabla) AND VARTYPE(lcValorCampoOrigen1)=="C"
				*!*	Validar el Codigo De tabla de tablas
				DIMENSION laValorTabla[1]
				SELECT DescripcionLargaArgumento ;
					FROM goEntorno.LocPath+"GTablas_Detalle" ;
					WHERE CodigoTabla = lcCodigoTabla AND ;
						ElementoTabla = lcValorCampoOrigen1 ;
					INTO ARRAY laValorTabla

				IF !EMPTY(_TALLY)
					IF TYPE("&lcVariable2") = TYPE("laValorTabla[1]")
						&lcVariable2 = laValorTabla[1]
					ENDIF

					lcSQL_Update = lcSQL_Update + ;
						lcNombreCampoOrigen2 + "= " + lcVariable2 + " ,"
						*lcNombreCampoOrigen2 + "='" + laValorTabla[1] + "',"
				ELSE
					lcSQL_Update = lcSQL_Update + ;
						lcNombreCampoOrigen2 + "= " + lcVariable + " ,"
				ENDIF

			OTHERWISE
				lcSQL_Update = lcSQL_Update + ;
					lcNombreCampoOrigen2 + "= " + lcVariable2 + " ,"
			ENDCASE
			lcSQL_Update = lcSQL_Update + ;
				lcNombreCampoOrigen1 + "= " + lcVariable + " , "
		ENDFOR

		lcSQL_Update = lcSQL_Update + "FlagOrigenRemoto = 1 " + ;
					"WHERE CodigoAtributo = '" + lcCodigoAtributo + "'"

		&lcSQL_Update
		RELEASE ALL LIKE xx_*
		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE ctipodatocamposedicion_assign
		LPARAMETERS tcTipoDatoCamposEdicion

		*!*	Inicializar Matriz temporal
		LOCAL laTipoDatoCamposEdicion
		DIMENSION laTipoDatoCamposEdicion[1]
		STORE SPACE(0) TO laTipoDatoCamposEdicion

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcTipoDatoCamposEdicion)=="C"
			tcTipoDatoCamposEdicion	= ALLTRIM(tcTipoDatoCamposEdicion)
			tcTipoDatoCamposEdicion	= CHRTRAN(tcTipoDatoCamposEdicion,SPACE(1),SPACE(0))
			THIS.cTipoDatoCamposEdicion = tcTipoDatoCamposEdicion

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcTipoDatoCamposEdicion , ";" , @laTipoDatoCamposEdicion )

		ENDIF
		nLen = ALEN(laTipoDatoCamposEdicion)
		DIMENSION THIS.aTipoDatoCamposEdicion(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laTipoDatoCamposEdicion,THIS.aTipoDatoCamposEdicion)
	ENDPROC


	*-- Permite Mostrar el Error ocurrido
	PROCEDURE mostrarerror
		DO CASE
		CASE THIS.nError = 1
			THIS.cMensajeError	= "Trat� de asignar un valor no v�lido a una propiedad de la clase"
		CASE THIS.nError = 2
			THIS.cMensajeError	= "El Valor de la Propiedad no es el que se esperaba"
		CASE THIS.nError = 3
			THIS.cMensajeError	= "No se encuentra el cursor especificado"
		CASE THIS.nError = 4
			THIS.cMensajeError	= "No existen columnas configuradas para mostrar"
		CASE THIS.nError = 5
			THIS.cMensajeError	= "Los par�metros no son correctos"
		OTHERWISE
			THIS.cMensajeError	= "Error ..."
		ENDCASE

		THIS.cMensajeError	= 	THIS.cMensajeError	+ CHR(13) + ;
							  "Programa : " + PROGRAM(1) + CHR(13) + ;
							  "Linea : " + ALLTRIM(STR(LINENO(1)))

		DO CASE
		CASE THIS.nTipoError = 1
			lcTipoError	= "Warning"
			lnIcono		= 64
		CASE THIS.nTipoError = 2
			lcTipoError	= "Error Fatal"
			lnIcono		= 32
		ENDCASE

		=MESSAGEBOX(THIS.cMensajeError,lnIcono,lcTipoError)
	ENDPROC


	*-- Carga los Valores por defecto que se asignaron a las propiedades cAtributosDefault, cValoresDefault
	PROCEDURE cargarvaloresdefault
		*!*	Verificar si tiene Atributos por defecto
		DIMENSION laValorAtributo[1]
		STORE .F. TO laValorAtributo
		SELECT(THIS.cAliasColumnas)
		LOCAL I,J

		IF !EMPTY(THIS.cValoresDefault) OR !ISNULL(THIS.cValoresDefault)
			FOR I=1 TO ALEN(THIS.aAtributosDefault)
				IF TYPE("THIS.aValoresDefault[I]")<>"C" OR TYPE("THIS.aAtributosDefault[I]")<>"C"
					LOOP
				ENDIF
				FOR J=1 TO ALEN(THIS.aCamposEdicionOrigen)
					IF TYPE("THIS.aCamposEdicionOrigen[J]")=="C"
						lcValorAtributo		= THIS.aValoresDefault[I]
						lcNombreCampo1		= UPPER(ALLTRIM(THIS.aAtributosDefault[I]))
						lcNombreCampo2		= IIF(LEFT(lcNombreCampo1,1)=="#",SUBSTR(lcNombreCampo1,2),lcNombreCampo1)

						*!*	Buscar el Campo que corresponde para actualizar su valor
						SELECT(THIS.cAliasColumnas)
						LOCATE ALL FOR UPPER(ALLTRIM(NombreCampo)) == lcNombreCampo2
						IF FOUND()
							*!*	Capturar el codigo de atributo del campo
							lcCodigoAtributo = IIF(LEFT(lcNombreCampo1,1)=="#","#","")+CodigoAtributo
							*!*	Actualiza el Valor en el Cursor
							THIS.Actualizar_Registro(THIS.cAliasColumnas,lcCodigoAtributo,lcValorAtributo)

						ENDIF
					ENDIF
				ENDFOR
			ENDFOR
		ENDIF
	ENDPROC


	PROCEDURE Init
		WITH THIS
			*!*	Forzar a los Metodos ASSIGN se ejecuten

			*!*	Campos del Origen
			.cEntidadOrigenAtributos	= IIF(VARTYPE(.cEntidadOrigenAtributos)<>"C" ,"",ALLTRIM(.cEntidadOrigenAtributos))

			.cCamposClaveOrigen			= IIF(VARTYPE(.cCamposClaveOrigen)<>"C","",.cCamposClaveOrigen)
			.cValoresClaveOrigen		= IIF(VARTYPE(.cValoresClaveOrigen)<>"C","",.cValoresClaveOrigen)

			.cCamposEdicionOrigen		= IIF(VARTYPE(.cCamposEdicionOrigen)<>"C" ,"ValorAtributo",.cCamposEdicionOrigen)
			.cCamposEdicionOrigen		= IIF(EMPTY(.cCamposEdicionOrigen) ,"ValorAtributo",.cCamposEdicionOrigen)

			*!*	Campos del Destino
			.cEntidadDestinoAtributos	= IIF(VARTYPE(.cEntidadDestinoAtributos)<>"C","",ALLTRIM(.cEntidadDestinoAtributos))

			.cCamposClaveDestino		= IIF(VARTYPE(.cCamposClaveDestino)<>"C","",.cCamposClaveDestino)
			.cValoresClaveDestino		= IIF(VARTYPE(.cValoresClaveDestino)<>"C","",.cValoresClaveDestino)

			.cCamposEdicionDestino		= IIF(VARTYPE(.cCamposEdicionDestino)<>"C","ValorAtributo",.cCamposEdicionDestino)
			.cCamposEdicionDestino		= IIF(EMPTY(.cCamposEdicionDestino),"ValorAtributo",.cCamposEdicionDestino)

			*!*	Si los campos del destino estan vacios asumir los del Origen
			.cEntidadDestinoAtributos	= IIF(EMPTY(.cEntidadDestinoAtributos),.cEntidadOrigenAtributos,.cEntidadDestinoAtributos)

			.cCamposClaveDestino		= IIF(EMPTY(.cCamposClaveDestino) ,.cCamposClaveOrigen ,.cCamposClaveDestino)
			.cValoresClaveDestino		= IIF(EMPTY(.cValoresClaveDestino),.cValoresClaveOrigen,.cValoresClaveDestino)


			.cAtributosDefault			= IIF(VARTYPE(.cAtributosDefault)<>"C","",.cAtributosDefault)
			.cValoresDefault			= IIF(VARTYPE(.cValoresDefault)<>"C","",.cValoresDefault)

			.cTipoDatoCamposEdicion		= IIF(VARTYPE(.cTipoDatoCamposEdicion)<>"C","",.cTipoDatoCamposEdicion)
			.cWhereSQL					= .cWhereSQL


			*!*	Inicializar propiedades con valores por defecto

			.cAliasAtributos			= IIF(VARTYPE(.cAliasAtributos)<>"C",SYS(2015),ALLTRIM(.cAliasAtributos))
			.cAliasColumnas				= IIF(VARTYPE(.cAliasColumnas)<>"C" ,SYS(2015),ALLTRIM(.cAliasColumnas))
			.cAliasCursor				= IIF(VARTYPE(.cAliasCursor)<>"C"   ,SYS(2015),ALLTRIM(.cAliasCursor))

			.cClavePlantilla			= IIF(VARTYPE(.cClavePlantilla)<>"C","",ALLTRIM(.cClavePlantilla))

			.cCodigoEntidad				= IIF(VARTYPE(.cCodigoEntidad)<>"C"			 ,"",ALLTRIM(.cCodigoEntidad))
			.cNombreEntidad				= IIF(VARTYPE(.cNombreEntidad)<>"C"			 ,"",ALLTRIM(.cNombreEntidad))

			.cSQL	= IIF(VARTYPE(.cSQL)<>"C"  ,"",ALLTRIM(.cSQL))
			.cWhere	= IIF(VARTYPE(.cWhere)<>"C","",ALLTRIM(.cWhere))

			.lMultiSelect	= IIF(VARTYPE(.lMultiSelect)<>"L",.F.,.lMultiSelect)
			.lDinamicGrid	= IIF(VARTYPE(.lDinamicGrid)<>"L",.F.,.lDinamicGrid)
			.lDistinct		= IIF(VARTYPE(.lDistinct)<>"L"    ,.F.,.lDistinct)

			.cLiteralAtributos	= IIF(VARTYPE(.cLiteralAtributos)<>"C","",ALLTRIM(.cLiteralAtributos))
			.cLiteralCriterios	= IIF(VARTYPE(.cLiteralCriterios)<>"C","",ALLTRIM(.cLiteralCriterios))

			.nRegistros	= 0
			.nCriterios	= 0

		ENDWITH
	ENDPROC


	PROCEDURE Destroy
		*!*	Cierra el cursor de las columnas de criterios de seleccion
		IF !EMPTY(THIS.cAliasColumnas) AND !ISNULL(THIS.cAliasColumnas)
			IF USED(THIS.cAliasColumnas)
				USE IN (THIS.cAliasColumnas)
			ENDIF
		ENDIF

		*!*	Cierra el cursor de Atributo-Valor
		IF !EMPTY(THIS.cAliasAtributos) AND !ISNULL(THIS.cAliasAtributos)
			IF USED(THIS.cAliasAtributos)
				USE IN (THIS.cAliasAtributos)
			ENDIF
		ENDIF

		*!*	Cierra el cursor de la Consulta dinamica
		IF !EMPTY(THIS.cAliasCursor) AND !ISNULL(THIS.cAliasCursor)
			IF USED(THIS.cAliasCursor)
				USE IN (THIS.cAliasCursor)
			ENDIF
		ENDIF
	ENDPROC


	*-- Genera cadena WHERE para cSQL
	HIDDEN PROCEDURE generarwhere
	ENDPROC


ENDDEFINE
*
*-- EndDefine: dataejecutor
**************************************************


**************************************************
*-- Class:        env (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   02/02/06 11:31:05 AM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS env AS custom OLEPUBLIC


	Height = 76
	Width = 100
	*-- Es un objeto que contiene informacion del usuario atachado a la red
	user = ""
	*-- Es un objeto que contiene informaci�n de la conexi�n ODBC por defecto
	conexion = ""
	*-- Ruta de los archivos temporales
	tmppath = ""
	*-- Ruta de los archivos locales
	locpath = ""
	*-- Nombre de la base de datos de seguridad del sistema
	basedatos = ""
	*-- Nombre del Servidor donde se encuentra la base de datos de seguridad del Sistema
	servidor = ""
	*-- Ruta de la compa�ia
	tspathcia = ""
	*-- Ruta de la base de datos que administra el sistema
	tspathadm = ([])
	*-- Ruta donde se encuentra la base de datos y/o tablas
	tspathdata = ([])
	Name = "env"
	sistema = .F.
	modulo = .F.

	*-- Es el codigo del perfil del usuario
	perfil = .F.
	descripcionsistema = .F.

	*-- Es .t. si se esta comunicando con un servidor de datos Sql
	sqlentorno = .F.
	conexion_db_vfp = .F.

	*-- Compa�ia actual de trabajo
	gscodcia = .F.

	*-- Periodo actual de trabajo
	gsperiodo = .F.

	*-- Es .t. si se esta comunicado con un servidor de datos a traves de ADO
	adoentorno = .F.

	*-- Es .t. si se esta comunicando con un servidor de datos VFP DBC
	vfpdbcentorno = .F.

	*-- Servidor de datos por defecto
	cdefaultbackendconecct = .F.

	*-- Pide compa�ia
	lpidcia = .F.
	DIMENSION atoolbars[1,1]


	*-- Captura la ruta de los datos segun la compa�ia actual
	PROCEDURE pathdatacia
		LPARAMETERS _CodCia
		IF !VARTYPE(_CodCia)='C'
			_CodCia ='001'  && Siempre la primera por defecto
		ENDIF
		RETURN JUSTPATH(ADDBS(THIS.TsPathadm))+'\CIA'+_CODCIA+'\'
	ENDPROC


	*-- Permite obtener el tipo de cambio segun la fecha.
	PROCEDURE _tipocambio
		PARAMETER _dFchDoc,_TpoCmb,_Estado
		IF ISNULL(_dFchDoc) OR empty(_dFchDoc)
			return 0
		ENDIF
		IF PARAMETERS()<3
			_Estado = ''
		ENDIF
		IF PARAMETERS()<2
			_TpoCmb = 0
		ENDIF

		LsArea_Act = ALIAS()
		Local LfTpoCmb,LlExiste
		LfTpoCmb = 0   && Si no existe nos evitamos dividir por cero
		LlExiste = .f.


		*IF GoCfgAlm.lPidPco AND GoCfgAlm.lCtoVta && AND GoCfgAlm.Crear
			IF SEEK(DTOS(_dFchDoc),"TCMB")
				LlExiste = .T.
				IF USED('OPER') 
					LfTpoCmb = iif(OPER.TpoCmb=1,TCMB.OFICMP,TCMB.OFIVTA)
				ELSE
					LfTpoCmb = TCMB.OFIVTA
				ENDIF
			ELSE
				SELECT TCMB
				IF !FOUND() AND RECNO(0)>0 
					GO RECNO(0)
					LfTpoCmb = TCMB->OfiVta
				ENDIF
				LlExiste = .f.
			ENDIF
			IF !LlExiste
			**	IF INLIST(_estado,'I','A')
					IF _TpoCmb > 0
						IF USED('OPER') 
							IF OPER.CodMon=1
								INSERT  INTO TCMB  (FchCmb,OFICMP) VALUES  (_dFchDoc,_TpoCmb )
							ELSE
								INSERT  INTO TCMB  (FchCmb,OFIVTA) VALUES  (_dFchDoc,_TpoCmb )
							ENDIF
						ELSE
							INSERT  INTO TCMB  (FchCmb,OFIVTA) VALUES  (_dFchDoc,_TpoCmb )
						ENDIF
						LfTpoCmb = _TpoCmb
					ENDIF
			**	ENDIF
				*=messagebox([ Tipo de Cambio del dia NO definido ],'Consultar a contabilidad')
			ENDIF
		*ELSE
		*ENDIF
		IF !EMPTY(LsArea_Act)
			SELECT (LsArea_Act)
		ENDIF
		RETURN LfTpoCmb
	ENDPROC


	PROCEDURE setpath
		PARAMETERS TsPath as String 
		IF PARAMETERS()<1
			TsPath = ''
		ENDIF
		IF EMPTY(TsPath)
			Local LsPath  As String
			LsPath = SET("Path")
			SET PATH TO lspath + "," + this.tspathadm + "," + this.tspathdata 
		ELSE
			LsPath = SET("Path")
			SET PATH TO lspath + "," + TsPath
		ENDIF
	ENDPROC


	PROCEDURE Init
		LOCAL lcServidor , lcBaseDatos , lcTmpPath , lcLocPath , lcFileINI , lcStringINI ,lcDefaBackEnd

		*!*	*!*	THIS.USER			= CREATEOBJECT('User' )
		*!*	*!*	THIS.Perfil			= SPACE(0)
		*!*	*!*	THIS.USER.Login		= ALLTRIM( SUBSTR(SYS(0) , AT( '#' , SYS(0) ) + 1 ) )
		*!*	*!*	THIS.USER.Estacion	= ALLTRIM( LEFT(  SYS(0) , AT( '#' , SYS(0) ) - 1 ) )

		*!*	*!*	*!*	Extraer de GPersonal
		*!*	*!*	*!*	(ApellidoPaterno,ApellidoMaterno,PrimerNombre,SegundoNombre,TercerNombre)
		*!*	*!*	*!*	(CodigoTrabajador)
		*!*	*!*	THIS.USER.Nombre			= SPACE(0)
		*!*	*!*	THIS.USER.CodigoTrabajador	= SPACE(0)
		*!*	*!*	THIS.USER.PASSWORD			= SPACE(0)
		*!*	*!*	THIS.USER.Categoria			= SPACE(0)


		LcFileIni = LOCFILE("CONFIG.INI") 
		*!*	Leer el Archivo .INI
		LcStringINI	= UPPER( FILETOSTR("CONFIG.INI") )
		oIniVal=NEWOBJECT("oldinireg","registry.vcx")


		*!*	Obtener el Path Local
		lcLocPath	= SUBSTR( lcStringINI , AT( "PATH LOCAL" , lcStringINI) )
		lcLocPath	= ALLTRIM( SUBSTR( lcLocPath , AT( "=" , lcLocPath ) + 1 ) )
		IF CHR(13) $ lcLocPath
			lcLocPath	= ALLTRIM( LEFT (  lcLocPath , AT( CHR(13) , lcLocPath	) - 1 ) )
		ENDIF
		lcLocPath	= STRTRAN( lcLocPath , CHR(13) , "" )
		lcLocPath	= STRTRAN( lcLocPath , CHR(10) , "" )

		*!*	Obtener el Path Temporal
		lcTmpPath	= SUBSTR( lcStringINI , AT( "PATH TMP" , lcStringINI) )
		lcTmpPath	= ALLTRIM( SUBSTR( lcTmpPath , AT( "=" , lcTmpPath ) + 1 ) )
		IF CHR(13) $ lcTmpPath
			lcTmpPath	= ALLTRIM( LEFT (  lcTmpPath , AT( CHR(13) , lcTmpPath ) - 1 ) )
		ENDIF
		lcTmpPath	= STRTRAN( lcTmpPath, CHR(13) , "" )
		lcTmpPath	= STRTRAN( lcTmpPath, CHR(10) , "" )

		THIS.TmpPath	= IIF( EMPTY( lcTmpPath ) , ADDBS( GETENV( "TEMP" ) ) , lcTmpPath )
		THIS.LocPath	= IIF( EMPTY( lcLocPath ) , "C:\APLVFP\Tmp" , lcLocPath )

		* Obtener tipo de servidor de datos por defecto
		lcDefaBackEnd	= SUBSTR( lcStringINI , AT( "BACKEND" , lcStringINI) )
		lcDefaBackEnd	= ALLTRIM( SUBSTR( lcDefaBackEnd , AT( "=" , lcDefaBackEnd ) + 1 ) )
		IF CHR(13) $ lcDefaBackEnd
			lcDefaBackEnd	= ALLTRIM( LEFT (  lcDefaBackEnd , AT( CHR(13) , lcDefaBackEnd ) - 1 ) )
		ENDIF
		lcDefaBackEnd	= STRTRAN( lcDefaBackEnd, CHR(13) , "" )
		lcDefaBackEnd	= STRTRAN( lcDefaBackEnd, CHR(10) , "" )
		LcValue =''
		oIniVal.getinientry(@lcvalue,'Path Database','Data Admin',LcFileIni) 
		this.TsPathAdm	= LcValue
		LcValue =''
		oIniVal.getinientry(@lcvalue,'Path Database','Data Source',LcFileIni)
		This.tspathData	= LcValue

		THIS.TmpPath	= IIF( EMPTY( lcTmpPath ) , ADDBS( GETENV( "TEMP" ) ) , lcTmpPath )
		THIS.LocPath	= IIF( EMPTY( lcLocPath ) , "C:\Temp" , lcLocPath )
		this.cdefaultbackendconecct = IIF( EMPTY( lcDefaBackEnd ) , "VFPDBC" , lcDefaBackEnd )
		this.SqlEntorno = (this.cdefaultbackendconecct = 'ODBC')
		THIS.Vfpdbcentorno = (this.cdefaultbackendconecct = 'VFPDBC')
		THIS.Adoentorno = (this.cdefaultbackendconecct = 'ADO')

		IF THIS.SqlEntorno
			THIS.Conexion	= goConexion
			THIS.Servidor	= goConexion.cServer
			THIS.BaseDatos	= goConexion.cDataBase
		ENDIF
		IF THIS.Vfpdbcentorno 
			THIS.Servidor	= goConexion.cServer
			THIS.BaseDatos	= goConexion.cDataBase
		ENDIF
		IF THIS.Adoentorno 
			THIS.Servidor	= goConexion.cServer
			THIS.BaseDatos	= goConexion.cDataBase

		ENDIF


		IF !this.lpidcia 
			this.gscodcia =GsCodCia
		    this.tspathcia = this.pathdatacia(this.gscodcia) 
		ENDIF


		IF VARTYPE(_ANO)<>'N'  OR VARTYPE(_MES)<>'N'
			this.gsperiodo=DTOS(DATE()) 
		ELSE
			this.GsPeriodo = STR(_ANO,4,0)+TRAN(_MES,'@L ##')
		ENDIF
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF SET("Development")='ON' 
			MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')

			RETURN CONTEXT_E_ABORTED
		ELSE


			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
			RETURN CONTEXT_E_ABORTED
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: env
**************************************************


**************************************************
*-- Class:        lineadetalle (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/03/03 06:13:00 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS lineadetalle AS custom OLEPUBLIC


	Height = 17
	Width = 86
	*-- Precio Unitario
	preuni = 0
	*-- Cantidad a facturar
	canfac = 0
	*-- Factor de equivalencia de unidades
	facequ = 0
	*-- Importe por registro del detalle
	implin = 0
	*-- Nro. de documento de referencia
	nrog_r = ""
	*-- Codigo de material
	codmat = ""
	*-- Unidad de venta
	undvta = ""

	*-- Descuento 1
	d1 = .F.

	*-- Descuento 2
	d2 = .F.

	*-- Descuento 3
	d3 = .F.

	*-- Descripcion del material
	desmat = .F.

	*-- Tipo de documento
	tpodoc = .F.

	*-- Codigo de documento
	coddoc = .F.

	*-- Numero de documento
	nrodoc = .F.

	*-- Documento de referencia
	nroref = .F.

	*-- Fecha de documento
	fchdoc = .F.


ENDDEFINE
*
*-- EndDefine: lineadetalle
**************************************************


**************************************************
*-- Class:        onegocios (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   02/11/06 06:05:13 AM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS onegocios AS custom OLEPUBLIC


	Height = 43
	Width = 115
	sdesmov = ""
	glorf1 = ""
	glorf2 = ""
	glorf3 = ""
	gloaux = ""
	gloven = ""
	stmon = ""
	sglopie1 = ""
	sglopie2 = ""
	sglopie3 = ""
	sglopie4 = ""
	*-- Tipo de referencia 1
	tporf1 = ""
	*-- Tipo de referencia 2
	tporf2 = ""
	*-- Tipo de referencia 3
	tporf3 = ""
	*-- Tipo de referencia asociada a la cabecera de la transacci�n
	xstporef = ""
	cmpref = ""
	*-- Variable de referencia
	varref = ""
	serr = ""
	sprgpant = ""
	ce1 = ""
	ce2 = ""
	scoddoc = ""
	ctipmov = ""
	scodmov = ""
	fimptot = 0
	fimpbrt = 0
	fporigv = 0
	fimpigv = 0
	snrodoc = ""
	dfchdoc = {}
	snrorf1 = ""
	snrorf2 = ""
	snrorf3 = ""
	snroodt = ""
	scodven = ""
	scodpro = ""
	scodcli = ""
	sobserv = ""
	scodaux = ""
	sclfaux = ""
	ncodmon = 0
	ftpocmb = 0
	scodprd = ""
	fbatch = 0
	nomtra = ""
	dirtra = ""
	ructra = ""
	platra = ""
	brevet = ""
	motivo = 0
	gntotdel = 0
	*-- Fecha de cierre
	xdfchcie = {}
	smodulo = ""
	stund = ""
	entidadcorrelativo = "ALMCDOCM"
	*-- Almacen de carga/descarga stock
	subalm = ""
	*-- Usuario
	usuario = ""
	*-- Sede de negocio
	codsed = ""
	*-- Codigo de compa�ia
	codcia = ""
	*-- Codigo de fase de producci�n
	ccodfase = ""
	ccodactiv = ""
	ccodcult = ""
	ccodlote = ""
	ccodprocs = ""
	fcandes = 0
	ffactor = 1
	fpreuni = 0
	fcnfmla = 0
	*-- Unidad de venta
	sundvta = ""
	scodmat = ""
	nreggrb = 0
	scodpar = ""
	almori = ([])
	*-- Costo promedio unitario moneda nacional
	pctomn = 0
	*-- Costo promedio Unitario en dolares
	pctous = 0
	*-- Stock general actual por sede
	stkact = 0
	*-- Stock actual de almacen
	stksub = 0
	*-- Costo unitario
	ctouni = 0.0000
	*-- Indica si se puede modificar el mes
	glmodmes = .T.
	*-- Almacena la fecha de cierre del almacen
	gdfchcie = {}
	*-- Objeto que tiene la referencia al objeto contnendor del formulario
	ocntcab = .NULL.
	*-- Objeto que contiene la referencia  al objeto contenedor del formulario
	ocntpage = .NULL.
	*-- Codigo de documento de referencia
	xscodref = ""
	*-- Punto de venta
	xsptovta = ""
	*-- Numero de documento
	xsnrodoc = ""
	*-- Fecha del documento
	xdfchdoc = {}
	*-- Codigo del cliente
	xscodcli = ""
	*-- Numero de orden de compra
	xsnroo_c = ""
	*-- Fecha de la orden de compra
	xdfcho_c = {}
	*-- Forma de pago
	xifmapgo = 1
	*-- Dias de vencimiento
	xidiavto = 0
	xsfmasol = ""
	*-- Condicion de pago
	xscndpgo = ""
	*-- Codigo de vendedor
	xscodven = ""
	xicodmon = 1
	*-- Moneda
	xncodmon = 1
	*-- Tipo de cambio
	xftpocmb = 0
	*-- Porcentaje de I.G.V (IVA)
	xfporigv = 0
	*-- Porcentaje de descuento
	xfpordto = 0
	*-- Importe Bruto
	xfimpbto = 0
	*-- Importe del descuento
	xfimpdto = 0
	*-- Gastos/Intereses financieros
	xfimpint = 0
	*-- Gastos administrativos
	xfimpadm = 0
	*-- Impuesto general a las ventas
	xfimpigv = 0
	*-- Importe total
	xfimptot = 0
	*-- Flete
	xfimpflt = 0
	*-- Estado del documento
	xcflgest = ""
	*-- Vencimiento
	xdfchvto = {}
	*-- Ubicacion del documento por cobrar
	xcflgubc = ""
	xsglosa1 = ""
	xsglosa2 = ""
	xsglosa3 = ""
	xsglodoc = ""
	*-- Numero de documento de referencia
	xsnroref = ""
	*-- Nuemro de pedido
	xsnroped = ""
	*-- Nombre cliente
	xsnomcli = ""
	*-- Direccion del cliente
	xsdircli = ""
	*-- Ruc
	xsruccli = ""
	*-- Direccion de entrega
	xsdirent = ""
	*-- Tipo de documento de la cabecera
	xstpodoc = ""
	*-- Maximo numero de items en el detalle
	cimaxele = 40
	*-- Tipo de facturaci�n
	xntpofac = ([001])
	*-- Objeto Administrador  de datos
	odatadm = .NULL.
	*-- Indice de la tabla de correlativos (ID) de la transaccion
	cindice_id = ""
	*-- Valor de la llave de la tabla de correlativo definido por la tabla  principal (cabecera) de la transaccion.
	cvalor_id = ""
	*-- Campos que conforman la clave primaria (PK) de la tabla de correlativos (IDs)
	ccmps_id = ""
	*-- Campo donde se almacena el valor del correlativo (contador)
	ccampo_id = ""
	*-- Longitud del campo del campo que contiene el valor del correlativo (ID) en la tabla cabecera de la transacci�n.
	nlen_id = 0
	*-- Valor de la llave primaria
	cvalor_pk = ""
	*-- Indice de la clave Primaria
	cindice_pk = ""
	*-- Campos de la llave primaria
	ccampos_pk = ""
	*-- Cursor  de la cabecera de la transaccion
	ccursor_c = ""
	*-- Cursor de  el detalle de al transaccion
	ccursor_d = ""
	*-- Alias de la tabla de la cabecera
	caliascab = ""
	*-- Alias de la tabala del detalle
	caliasdet = ""
	*-- Tabla cabecera de la transaccion
	ctabla_c = ""
	*-- Tabla detale de la transaccion
	ctabla_d = ""
	*-- Alias de la tabla detalle del detalle de las transacciones
	caliasdet_det = ""
	*-- Tipo de transacci�n controlada por el objeto de negocios
	que_transaccion = ""
	*-- Referencia a objeto que contiene un registro del detalle
	oitem = .NULL.
	*-- Flag de estado del Documento referencia
	xcflgest_ref = ([E])
	*-- Contiene el valor de las propiedades o campos que conforman la llave primaria de la transacci�n.
	ceval_valor_pk = ""
	*-- Referencia al objeto de contabilidad
	ocontab = .NULL.
	ceval_campo_id = ""
	*-- Tipo de venta
	xntpovta = 0
	*-- Importe de la venta
	xfimpvta = 0
	*-- Entorno principal del sistema en base a clase ENV
	oentorno = .NULL.
	almtrf = ([])
	*-- Ruta de transporte de mercaderia hacia el cliente
	xsruta = ([])
	*-- Numero de elemento actual en array aDetalle
	numele = .F.
	*-- Maximo de elementos en arreglo aDetalle
	maxele = .F.
	*-- .t. si es agente de retencion
	xlrete = .F.
	*-- Monto de retenci�n
	xfreten = 0
	*-- Flag de agente de retenci�n a grabar en cabecera de ventas
	xcagente = ('')
	Name = "onegocios"
	lpidrf1 = .F.
	lpidrf2 = .F.
	lpidcli = .F.
	lpidpro = .F.
	lpidodt = .F.
	lmodpre = .F.
	lundstk = .F.
	lundvta = .F.
	lundcmp = .F.
	lmodcsm = .F.
	lafetra = .F.
	lextpco = .F.
	lpidpco = .F.
	lmonnac = .F.
	lmonusa = .F.
	lmonelg = .F.
	lpidrf3 = .F.
	bdefbrow = .F.
	primera = .F.
	lpidven = .F.
	crear = .F.
	lpidactfijo = .F.
	xlmodif = .F.

	*-- Total  de items en el detalle
	gitotitm = .F.

	*-- Costo de venta
	lctovta = .F.

	*-- Usa correlativo unico
	lcorr_u = .F.

	*-- Motivo de la transacci�n de almacen
	lpidmot = .F.

	*-- Codigo de documento
	xscoddoc = .F.

	*-- Admite transacciones con stock negativo
	lstkneg = .F.

	*-- Via de transporte o envio de mercaderia
	xcvia = .F.

	*-- Destino de venta ; Nacional o Exportaci�n
	xcdestino = .F.

	*-- Importe del Seguro
	xfimpseg = .F.
	xscodvia = .F.
	es_imp = .F.
	transf = .F.
	DIMENSION aregdel[1]

	*-- Matriz de sedes
	DIMENSION msedes[1,2]
	DIMENSION asnrog_r[1]
	DIMENSION ascodmat[1]
	DIMENSION asdesmat[1]
	DIMENSION asundvta[1]
	DIMENSION afpreuni[1]
	DIMENSION afcanfac[1]
	DIMENSION affacequ[1]
	DIMENSION afimplin[1]
	DIMENSION and1[1]
	DIMENSION and2[1]
	DIMENSION and3[1]

	*-- Arreglo que contiene un objeto de referencia  por cada registro del detalle.
	DIMENSION adetalle[1]


	PROCEDURE _cuales
		LPARAMETERS _Cual
		DO CASE
		   CASE _Cual = 1
		     RETURN [    Solo Materiales con Stock     ]
		   CASE _Cual = 2
		     RETURN [Todos los Materiales Seleccionados]
		   OTHER
		     RETURN [ ]
		ENDCASE
	ENDPROC


	PROCEDURE correlativo
		Lparameters _tabla,_tipMov,_CodMov,_Almacen,_Valor
		SELECT * from (_tabla) where TipMov=_Tipmov and Codmov=_Codmov and SubAlm=_Almacen INTO CURSOR c_CDOC
		Local LsCampo,LnNroDoc,LsPicture,LnLenSufijo,LnLenNDoc,LsCampo2
		LsCampo = 'C_CDOC.NDOC'+XsNroMes
		LsCampo2 = 'NDOC'+XsNroMes
		LnNroDoc= EVAL(LsCampo)
		IF EMPTY(LnNroDoc) OR ISNULL(LnNroDoc)
			this.serr = "Falta definir en maestro de correlativos por almacen"
			RETURN .f.
		ENDIF
		LsPicture = "@L "+REPLI('#',LEN(dtra.NroDoc))
		LnLenNDoc = LEN(dtra.NroDoc) - LEN(XsNroMes)
		*IF CDOC->ORIGEN
			LnNroDoc = VAL(XsNroMes+RIGHT(TRANSF(LnNroDoc,LsPicture),LnLenNDoc))
		*ENDIF
		IF  !_valor == '0'
			IF VAL(_Valor) > LnNroDoc
		    	LnNroDoc = VAL(_Valor) + 1
			ELSE
		    	LnNroDoc = LnNroDoc + 1
			ENDIF     
		*!*	    DO CASE 
		*!*	    	CASE XsNroMES <= "13"
		*!*	        	LsCampo='NDOC'+XsNroMes
		*!*	        OTHER
		*!*	        	LsCampo='NRODOC'
		*!*	   ENDCASE
		   UPDATE (_Tabla) SET &LsCampo2. = LnNroDoc ;
		   WHERE TipMov=_Tipmov and Codmov=_Codmov and SubAlm=_Almacen
		ENDIF
		RETURN  RIGHT(REPLI('0',LEN(dtra.NroDoc)) + LTRIM(STR(LnNroDoc)), 10)
	ENDPROC


	PROCEDURE nroast
		LPARAMETERS XsNroAst
		DO CASE
		   CASE XsNroMES = "00"
		     iNroDoc = CDOC->NDOC00
		   CASE XsNroMES = "01"
		     iNroDoc = CDOC->NDOC01
		   CASE XsNroMES = "02"
		     iNroDoc = CDOC->NDOC02
		   CASE XsNroMES = "03"
		     iNroDoc = CDOC->NDOC03
		   CASE XsNroMES = "04"
		     iNroDoc = CDOC->NDOC04
		   CASE XsNroMES = "05"
		     iNroDoc = CDOC->NDOC05
		   CASE XsNroMES = "06"
		     iNroDoc = CDOC->NDOC06
		   CASE XsNroMES = "07"
		     iNroDoc = CDOC->NDOC07
		   CASE XsNroMES = "08"
		     iNroDoc = CDOC->NDOC08
		   CASE XsNroMES = "09"
		     iNroDoc = CDOC->NDOC09
		   CASE XsNroMES = "10"
		     iNroDoc = CDOC->NDOC10
		   CASE XsNroMES = "11"
		     iNroDoc = CDOC->NDOC11
		   CASE XsNroMES = "12"
		     iNroDoc = CDOC->NDOC12
		   CASE XsNroMES = "13"
		     iNroDoc = CDOC->NDOC13
		   OTHER
		     iNroDoc = CDOC->NRODOC
		ENDCASE

		*IF CDOC->ORIGEN
		   iNroDoc = VAL(XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ##########"),8))
		*ENDIF
		IF PARAMETER() = 1
		   IF VAL(XsNroAst) > iNroDoc
		     iNroDoc = VAL(XsNroAst) + 1
		   ELSE
		     iNroDoc = iNroDoc + 1
		   ENDIF
		   DO CASE
		      CASE XsNroMES = "00"
		        REPLACE   CDOC->NDOC00 WITH iNroDoc
		      CASE XsNroMES = "01"
		        REPLACE   CDOC->NDOC01 WITH iNroDoc
		      CASE XsNroMES = "02"
		        REPLACE   CDOC->NDOC02 WITH iNroDoc
		      CASE XsNroMES = "03"
		        REPLACE   CDOC->NDOC03 WITH iNroDoc
		      CASE XsNroMES = "04"
		        REPLACE   CDOC->NDOC04 WITH iNroDoc
		      CASE XsNroMES = "05"
		        REPLACE   CDOC->NDOC05 WITH iNroDoc
		      CASE XsNroMES = "06"
		        REPLACE   CDOC->NDOC06 WITH iNroDoc
		      CASE XsNroMES = "07"
		        REPLACE   CDOC->NDOC07 WITH iNroDoc
		      CASE XsNroMES = "08"
		        REPLACE   CDOC->NDOC08 WITH iNroDoc
		      CASE XsNroMES = "09"
		        REPLACE   CDOC->NDOC09 WITH iNroDoc
		      CASE XsNroMES = "10"
		        REPLACE   CDOC->NDOC10 WITH iNroDoc
		      CASE XsNroMES = "11"
		        REPLACE   CDOC->NDOC11 WITH iNroDoc
		      CASE XsNroMES = "12"
		        REPLACE   CDOC->NDOC12 WITH iNroDoc
		      CASE XsNroMES = "13"
		        REPLACE   CDOC->NDOC13 WITH iNroDoc
		      OTHER
		        REPLACE   CDOC->NRODOC WITH iNroDoc
		   ENDCASE
		   UNLOCK IN CDOC
		ENDIF
		RETURN  RIGHT("0000000000" + LTRIM(STR(iNroDoc)), 10)
	ENDPROC


	PROCEDURE capstkalm
		LPARAMETERS sSubAlm,sCodMat,dFecha
		PRIVATE m.CurrArea
		if vartype(dfecha) = 'T'
			dfecha=TTOD(dfecha)
		endif
		m.CurrArea = ALIAS()
		m.NroRegAct= RECNO()
		m.OrdenAct = ORDER()
		m.Nra_CALM = 0
		IF m.CurrArea#[CALM]
		   m.NRA_CALM=RECNO([CALM])
		   IF ORDER([CALM])=[CATA01]
		      =SEEK(sSubAlm+sCodmat,[CALM])
		   ELSE
		      =SEEK(sCodmat+sSubAlm,[CALM])
		   ENDIF
		ENDIF
		LfStkSub=CALM.StkIni
		SELE DTRA
		SET ORDER TO DTRA02
		SEEK sSubAlm+sCodMat+DTOS(dFecha+1)
		IF !FOUND()
		   IF RECNO(0)>0
		      GO RECNO(0)
		      IF DELETED()
		         SKIP
		      ENDIF
		   ENDIF
		ENDIF
		SKIP -1
		IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
		   LfStkSub = StkSub
		ENDIF
		IF m.Nra_Calm>0 AND RECNO([CALM])<>m.Nra_CALM
		   GO m.Nra_CALM IN [CALM]
		ENDIF
		SELE (m.CurrArea)
		SET ORDER TO (OrdenAct)
		GO m.NroRegAct
		RETURN LfStkSub
	ENDPROC


	PROCEDURE capstkmin
		*** FUNCTION CapStkMin  && Convertir en metodo de formulario o del almplibf
		LPARAMETERS _CODMAT,_FECHA
		PRIVATE K,LfStkMin,LsStkMin,Area_Ant,Tag_Ant
		Area_Ant=ALIAS()
		Tag_Ant =ORDER()
		LsStkMin = [STKM]+TRAN(MONTH(_Fecha),[@L ##])
		LfStkMin = 0
		FOR K=1 TO ALEN(gocfgalm.msedes,1)
		    SELE CALM
		    SEEK _CodMat
		    SCAN WHILE CodMat=_CodMat FOR ALMA.CodSed=gocfgalm.mSedes(K,1)
		        LfStkMin = LfStkMin + round(&LsStkMin.,1)
		    ENDSCAN
		ENDFOR
		SELE (Area_Ant)
		SET ORDER TO (Tag_Ant)
		return LfStkMin
	ENDPROC


	PROCEDURE cap_cfg_transacciones
		PARAMETERS m.cTipMov , m.sCodMov
		xAlias = ALIAS()
		IF !USED('CFTR')
			LOCAL LlCerrar AS Boolean
			LlCerrar=this.oDatAdm.AbrirTabla('ABRIR','ALMCFTRA','CFTR','CFTR01','')
		ELSE
			LlCerrar = .f.
		ENDIF
		=SEEK(m.cTipMov + m.sCodMov,'CFTR')
		**select * from almcftra into cursor CFTR where TipMov = m.cTipMov AND CodMov = m.sCodMov

		** Definiendo Variables a necesitar **
		this.sDesMov = CFTR.DesMov
		this.lPidRf1 = CFTR.PidRf1
		this.GloRf1  = CFTR.GloRf1
		this.lPidRf2 = CFTR.PidRf2
		this.GloRf2  = CFTR.GloRf2
		this.lPidVen = CFTR.PidVen
		this.lPidCli = CFTR.PidCli
		this.lPidPro = CFTR.PidPro
		this.lPidOdT = CFTR.PidOdT
		this.lModPre = CFTR.ModPre
		this.lUndStk = CFTR.UndStk .OR. EOF([CFTR])
		this.lUndVta = CFTR.UndVta
		this.lUndCmp = CFTR.UndCmp
		this.lPidActFijo = CFTR.PidActFijo
		IF ! this.lUndVta .and. ! this.lUndCmp
		   this.lUndStk = .t.
		ENDIF
		*
		this.lModCsm = CFTR.ModCsm
		this.lAfeTra = CFTR.AfeTra
		*
		this.lExtPco = CFTR.ExtPco
		this.lPidPco = CFTR.PidPco
		this.lMonNac = CFTR.MonNac
		this.lMonUsa = CFTR.MonUsa
		this.lMonElg = CFTR.MonElg
		this.lCtoVta = CFTR.CtoVta
		this.lCorr_u = CFTR.Corr_u
		this.lPidMot = CFTR.PidMot
		this.lstkneg = CFTR.StkNeg
		this.Es_Imp  = CFTR.Es_Imp
		this.Transf =  CFTR.Transf
		*
		if ! this.lMonElg .and. ! this.lMonUsa
		   this.lMonNac = .t.
		   this.lMonElg = .f.
		   this.lMonUsa = .f.
		ENDIF
		this.lPidRf3 = CFTR.PidRf3
		this.GloRf3  = CFTR.GloRf3
		this.GloAux = SPACE(15)
		this.GloAux = SPACE(15)
		this.GloVen = SPACE(15)
		IF this.lPidOdt
		   IF !USED([DFPRO])
		      IF !LoDatAdm.AbrirTabla('ABRIR','CPIDFPRO','DFPRO','DFPR01','')
					this.sErr =	[No se puede abrir archivo de formulaci�n]	      
		      ENDIF
		   ENDIF
		ELSE
		   IF USED([DFPRO])
		      SELE DFPRO
		      USE
		   ENDIF
		ENDIF
		IF this.lPidCli
		   this.GloAux = PADR("CLIENTE   :",15)
		ENDIF
		IF this.lPidPro
		   this.GloAux = PADR("PROVEEDOR :",15)
		ENDIF
		IF this.lPidVen
		   this.GloVen = PADR("VENDEDOR  :",15)
		ENDIF

		DO CASE
		   CASE this.lUndStk
			This.sTUnd = [U.STK]
		   CASE this.lUndVta
			This.sTUnd = [U.VTA]
		   CASE this.lUndCmp
			This.sTUnd = [U.CMP]
		ENDCASE
		IF this.lPidPco
		   IF ! this.lMonUsa
		      this.sTMon ="S/."
		   ELSE
		      this.sTMon ="US$"
		   ENDIF
		   this.sGloPie1 = [IMPORTE BRUTO:]
		   this.sGloPie2 = [% I.G.V.     :]
		   this.sGloPie3 = [TOTAL  I.G.V.:]
		   this.sGloPie4 = [IMPORTE NETO :]
		ELSE
		   this.sGloPie1 = []
		   this.sGloPie2 = []
		   this.sGloPie3 = []
		   this.sGloPie4 = []
		ENDIF
		this.bDefBrow= .T.
		this.Primera = .T.

		*!*	=SEEK(GsSubAlm+m.cTipMov+m.sCodMov+CHR(255),"CTRA")
		*!*	m.sNroDoc = CTRA.NroDoc

		this.TpoRf1 = CFTR.TpoRf1
		this.TpoRf2 = CFTR.TpoRf2
		this.TpoRf3 = CFTR.TpoRf3
		THIS.XsTpoRef = []
		this.CmpRef = []
		this.VarRef = []

		IF !EMPTY(this.TpoRf1)
		   this.XsTpoRef = this.TpoRf1
		   this.CmpRef = [NroRf1]
		   this.VarRef = [NroRf1]
		ENDIF
		IF !EMPTY(this.TpoRf2)
		   this.XsTpoRef = this.TpoRf2
		   this.CmpRef = [NroRf2]
		   this.VarRef = [NroRf2]
		ENDIF
		IF !EMPTY(this.TpoRf3)
		   this.XsTpoRef = this.TpoRf3
		   this.CmpRef = [NroRf3]
		   this.VarRef = [NroRf3]
		ENDIF

		IF this.lModCsm .or. this.lAfeTra
		   IF !USED([DFPRO])
		      IF !LoDatAdm.AbrirTabla('ABRIR','CPIDFPRO','DFPRO','DFPR01','')
				 this.sErr = [Tabla de formulas no puede ser abierta]
		      ENDIF
		   ENDIF
		ELSE
		   IF USED([DFPRO])
		      SELE DFPRO
		      USE
		   ENDIF
		ENDIF

		IF this.lPidPco
		   THIS.sPrgPANT= [ALMPMI1A.SPR]
		ELSE
		   THIS.sPrgPANT= [ALMPMI1B.SPR]
		ENDIF
		IF TYPE([GLCORRU_I])=[U]
		    PUBLIC GLCORRU_I
		    GLCORRU_I=.F.
		ENDIF

		IF TYPE([CFTR.CORR_U])=[L]
		   GLCORRU_I=CFTR.CORR_U
		ENDIF

		IF GLCORRU_I
		**   SELE CDOC
		**   SET ORDER TO CDOC02
		ELSE
		**   sele cdoc
		**   SET ORDER TO CDOC01
		ENDIF
		IF LlCerrar
			USE IN CFTR
		ENDIF
		IF ALIAS()<>xAlias
			IF !EMPTY(xAlias)
				SELE (xAlias)
			ENDIF
		ENDIF
	ENDPROC


	*-- Carga las variables de configuraci�n del objeto de transacciones
	PROCEDURE inicializavariablescfg
		this.cE1    = ""
		this.cE2    = ""
		this.sDesMov = ""
		this.lPidRf1 = .F.
		this.GloRf1 = ""
		this.lPidRf2 = .F.
		this.GloRf2 = ""
		this.lPidVen = .F.
		this.lPidCli = .F.
		this.lPidPro = .F.
		this.lPidOdT = .F.
		this.lModPre = .F.
		this.lUndStk = .T.
		this.lUndVta = .F.
		this.lUndCmp = .F.
		this.lPidActFijo = .F.
		*
		this.lModCsm = .F.
		this.lAfeTra = .F.
		*
		this.lExtPco = .f.
		this.lPidPco = .f.
		this.lMonNac = .t.
		this.lMonUsa = .f.
		this.lMonElg = .f.
		this.lpidrf3 = .f.
		this.lStkneg =.f.
		this.Es_Imp  = .F.

		this.GloRf3 = []
		this.GloAux = []
		this.GloVen = []
		this.TpoRf1 = []
		this.TpoRf2 = []
		this.TpoRf3 = []


		this.XsTpoRef=[]
		this.CmpRef =[]
		this.VarRef =[]

		this.sCodDoc =[INGR]  && Codigo de correlativo unico
		this.cTipMov = "I"
		this.sCodMov = ""     && << OJO : Filtra los que tienen ModPre ="X" <<
		*********************
		this.fImpTot = 0.00
		this.fImpBrt = 0.00
		this.fPorIgv = 0.00
		this.fImpIgv = 0.00
		*********************
		this.sNroDoc = ""
		this.dFchDoc = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),GdFecha)
		this.sNroRf1 = ""
		this.sNroRf2 = ""
		this.sNroRf3 = ""
		this.sNroOdt = ""
		this.sCodVen = ""
		this.sCodPro = ""
		this.sCodCli = ""
		this.sObserv = ""
		this.sCodAux = ""
		this.sClfAux = ""
		this.nCodMon = 0
		this.fTpoCmb = 0.00
		this.sCodPrd  = []
		this.FBatch  = 1
		this.sCodPar = ""
		** datos del transportista **
		this.NomTra = []
		this.DirTra = []
		this.RucTra = []
		this.PlaTra = []
		this.Brevet = []
		this.Motivo = 4
		**

		STORE [] TO this.sGloPie1,this.sGloPie2,this.sGloPie3,this.sGloPie4

		*

		_LLAVE = []

		*
		ScrMov = 1    && Pantalla de Presentaci�n
		This.Crear  = .t.
		XlMate = .F.
		This.GnTotDel = 0
		this.aregdel=''
		*

		This.sModulo = []

		blBorrar=.F.

		This.sTUnd = [STK]
		THIS.sTMon = [S/.]

		*!*	** para cierre logico **
		*!*	PRIVATE XdFchCie
		THIS.XdFchCie = {  ,  ,    }         && Fecha de cierre logico de almacenes 

		** VARIABLES DE VENTAS ** 
		*this.XsCodRef = 'FACT'

		RESTORE FROM THIS.oentorno.tspathcia+'vtaCONFG.MEM' ADDITIVE
		THIS.XSCoddoc = 'FACT'
		THIS.XsNroDoc = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.NroDoc)))
		this.XdFchDoc = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),GdFecha)
		this.XdFchVto = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),GdFecha)
		this.XsCodCli = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.CodCli)))
		this.XsCodVen = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.CodVen)))
		this.XsNomCli = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.NomCli)))
		this.XsDirCli = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.DirCli)))
		this.XsRucCli = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.RucCli)))
		this.XsNroO_C = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.NroO_C)))
		this.XdFchO_C = {}
		this.XiFmaPgo = 1
		this.XsFmaSol = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.FmaSol)))
		this.XiDiaVto = 0
		this.XsCndPgo = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.CndPgo)))
		this.XiCodMon = 2
		this.XfTpoCmb = 0
		this.XfPorIgv = CFGADMIGV
		this.XfPorDto = 0
		this.XfImpBto = 0
		this.XfImpDto = 0
		this.XfImpInt = 0
		this.XfImpAdm = 0
		THIS.XfImpSeg = 0
		this.XfImpIgv = 0
		this.XfImpTot = 0
		this.XsGloDoc = []
		this.XcFlgEst = [P]
		this.XcFlgUbc = [C]
		this.XsCodRef = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.CodRef)))
		this.XsNroRef = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.NroRef)))
		this.XsNroPed = IIF(!USED('GDOC'),'',SPACE(LEN(GDOC.NroPed)))
		this.XnTpoFac = 3 && En base a una Guia
		this.XnTpoVta = 1
		THIS.XcVia = 'A'
		THIS.XcDestino = 'N'  && o  Exportaci�n
		this.XsCodVia = ''
		THIS.XlRETE	= .F.
		THIS.XfRETEN  = 0
		THIS.XcAGENTE	= ''
		** Variables de la Grilla **
		this.GiTotItm = 0

		RETURN
	ENDPROC


	*-- Abre tablas que intervienen en transacciones de almacen
	PROCEDURE abrir_dbfs_alm
		* Bases de datos **

		*=F1QEH("ABRE_DBF")
		LlRetVal =  .T.
		SELECT 0
		** USE almCTRAN  ORDER CTRA01 ALIAS CTRA
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCTRAN','CTRA','CTRA01','')
		   LlRetVal =  .f.
		ENDIF
		*
		*Arch = GoEntorno.TmpPath+SYS(3)
		Arch = SYS(2023)+'\'+SYS(3)
		SELECT 0
		** USE almDTRAN ORDER DTRA01 ALIAS DTRA
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almDTRAN','DTRA','DTRA01','')
		   LlRetVal =  .f.
		ENDIF
		SELE DTRA

		IF !USED('TEMP')
			SELE 0
			CREATE TABL (Arch) FREE (CodMat C(8)   , DesMat C(40) ,CanDes N(14,4),UndVta C(3),;
					    PreUni N(14,4),ImpCto N(14,4),NroItm N(5),CodAlm C(3),   ;
					    SubAlm C(3)   ,TipMov C(1)   ,CodMov C(3),NroDoc C(10),  ;
					Factor N(7,4) ,NroReg N(6),ImpCtoA N(14,4),PreUniA N(14,4),  ;
					NroRef C(10),TpoRef C(4),;
					canrec  n(14,4),;
					canreca n(14,4),;
					CanDesA N(14,4) )
			USE (arch) ALIAS TEMP EXCLU
			IF !USED()
			   LlRetVal =  .f.
			ENDIF
			INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,5,0) TAG DTRA01
		ENDIF
		*
		SELECT 0
		**USE almCATGE ORDER CATG01 ALIAS CATG
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCATGE','CATG','CATG01','')
		   LlRetVal =  .f.
		ENDIF
		*
		SELECT 0
		**USE almCATAL ORDER CATA01 ALIAS CALM
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCATAL','CALM','CATA01','')
		   LlRetVal =  .f.
		ENDIF
		*
		SELECT 0
		** USE almCdocm ORDER CDOC01 ALIAS CDOC
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCdocm','CDOC','CDOC01','')
		   LlRetVal =  .f.
		ENDIF
		*
		*SELECT 0
		*USE CbdMauxi ORDER AUXI01 ALIAS AUXI
		*IF !USED()
		*   LlRetVal =  .f.
		*ENDIF
		*
		SELECT 0
		** USE admmtcmb ORDER TCMB01 ALIAS TCMB
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','admmtcmb','TCMB','TCMB01','')
		   LlRetVal =  .f.
		ENDIF
		*
		SELECT 0
		** USE almTDIVF ORDER DIVF01 ALIAS DIVF
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almTDIVF','DIVF','DIVF01','')
		    LlRetVal =  .f.
		ENDIF
		* 
		SELECT 0
		** USE almESTCM ORDER ESTA01 ALIAS ESTA
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almESTCM','ESTA','ESTA01','')
		   LlRetVal =  .f.
		ENDIF
		*
		SELECT 0
		** USE almESTTR ORDER ESTR01 ALIAS ESTR
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almESTTR','ESTR','ESTR01','')
		   LlRetVal =  .f.
		ENDIF
		*
		** USE ALMEQUNI IN 0 ORDER EQUN01 ALIAS EQUN
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','ALMEQUNI','EQUN','EQUN01','')
		   LlRetVal =  .f.
		ENDIF
		*
		SELECT 0
		** USE almTGSIS ORDER TABL01 ALIAS TABL
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','ALMTGSIS','TABL','TABL01','')
		   LlRetVal =  .f.
		ENDIF
		*
		SELECT 0
		** USE almCFTRA ORDER CFTR01 ALIAS CFTR
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCFTRA','CFTR','CFTR01','')
		   LlRetVal =  .f.
		ENDIF
		*
		select 0
		** use almtalma order alma01 alias ALMA
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almtalma','ALMA','ALMA01','')
		   LlRetVal =  .f.
		ENDIF
		SELECT 0
		IF !THIS.oDatAdm.AbrirTabla('ABRIR','almdlote','DLOTE','DLOTE01','')
		   LlRetVal =  .f.
		ENDIF

		IF !LlRetVal 
			*=MESSAGEBOX([Fall� apertura de archivos])
		ELSE
			*=F1QEH("Listo")
		ENDIF
		return LlRetVal
	ENDPROC


	PROCEDURE borra_registro_local_detalle
		*!*	IF !lBorra
		*!*	   =F1QEH("No es posible borrar registro")
		*!*	   RETURN
		*!*	ENDIF
		LOCAL m.RegAct
		m.RegAct = RECNO()
		IF TYPE([NroReg])=[N]
		   this.GnTotDel = this.GnTotDel + 1
		   this.GiTotItm = this.GiTotItm - 1
		   IF ALEN(this.aRegDel)<this.GnTotDel
		      DIMENSION this.aRegDel(this.GnTotDel + 5)
		   ENDIF
		   this.aRegDel(this.GnTotDel) = NroReg
		ENDIF
		DELETE

		SKIP +1
		IF EOF()

			LOCATE
		ENDIF
		*!*	blBorrar = .T.
	ENDPROC


	PROCEDURE _tipocambio
		PARAMETER _dFchDoc,_estado,_TpoCmb
		IF ISNULL(_dFchDoc) OR empty(_dFchDoc)
			return 0
		ENDIF
		IF PARAMETERS()<3
			_TpoCmb = 0
		ENDIF
		IF PARAMETERS()<2
			_Estado = ''
		ENDIF

		LsArea_Act = ALIAS()
		Local LfTpoCmb
		LfTpoCmb = 0


		*IF GoCfgAlm.lPidPco AND GoCfgAlm.lCtoVta && AND GoCfgAlm.Crear
			IF SEEK(DTOS(_dFchDoc),"TCMB")
				LfTpoCmb = TCMB->OfiVta
			ELSE
				SELECT TCMB
				IF !FOUND() AND RECNO(0)>0 
					GO RECNO(0)
					LfTpoCmb = TCMB->OfiVta
				ENDIF
			ENDIF
			IF LfTpoCmb <= 0
				IF INLIST(_estado,'I','A')
					IF _TpoCmb > 0
						LfTpoCmb = _TpoCmb
						INSERT  INTO TCMB  (FchCmb,OFIVTA) VALUES  (_dFchDoc,_TpoCmb )
					ENDIF
				endif
				*=messagebox([ Tipo de Cambio del dia NO definido ],'Consultar a contabilidad')
			ENDIF
		*ELSE
		*ENDIF
		IF !EMPTY(LsArea_Act)
			SELECT (LsArea_Act)
		ENDIF
		RETURN LfTpoCmb
	ENDPROC


	*-- Carga un vector con las sedes
	PROCEDURE cargasedes
		THIS.oDatAdm.AbrirTabla('ABRIR','SEDES','SEDES','SEDE01','')
		SELECT SEDES
		SET FILTER TO !(UPPER(Nombre)=[CENTRAL]) && Central de informaci�n
		COUNT TO nSedes
		DIME THIS.mSedes(nSedes,3)
		COPY TO ARRAY THIS.mSedes FIELDS LIKE C*,N*,A*
		use in sedes
	ENDPROC


	*-- Abre tablas que intervienen en las transacciones de ventas
	PROCEDURE abrir_dbfs_vta
		parameter _CodDoc
		* ABRIR TABLAS A UTILIZAR EN TRANSACCIONES DE VENTAS *
		LlRetVal =  .T.	   && Siempre optimistas


		DO CASE 
			CASE _CODDOC = [PEDI]
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','CCTCLIEN','','','')
				   LlRetVal =  .f.
				ENDIF
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdmauxi','CLIE','AUXI01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtavpedi','VPED','VPED01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtarpedi','RPED','RPED01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtatdocm','DOCM','DOCM01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCatgE','CATG','CATG01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCATAL','CALM','CATA01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almEQUNI','UVTA','EQUN01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almtgsis','TABL','TABL01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !LlRetVal
					IF USED('CATG')
						USE IN CATG
					ENDIF
					IF USED('ALMA')
						USE IN ALMA
					ENDIF
					IF USED('UVTA')
						USE IN UVTA
					ENDIF
					IF USED('TABL')
						USE IN TABL
					ENDIF
					IF USED('DTRA')
						USE IN DTRA
					ENDIF
					IF USED('TCMB')
						USE IN TCMB
					ENDIF
					IF USED('CLIE')
						USE IN CLIE
					ENDIF
					IF USED('VPED')
						USE IN VPED
					ENDIF
					IF USED('RPED')
						USE IN RPED
					ENDIF
					IF USED('DOCM')
						USE IN DOCM
					ENDIF
					RETURN LlRetVal
				ENDIF


			CASE _CODDOC = [G/R ]
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','CCTCLIEN','','','')
				   LlRetVal =  .f.
				ENDIF
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdmauxi','CLIE','AUXI01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtavpedi','VPED','VPED01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtarpedi','RPED','RPED02','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtatdocm','DOCM','DOCM01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtavguia','VMOV','VGUI01','')
				   LlRetVal =  .f.
				ENDIF
					* ARCHIVOS DE ALMACEN *
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCatgE','CATG','CATG01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCATAL','CALM','CATA01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almDTRAN','DTRA','DTRA04','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almtalma','ALMA','ALMA01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almEQUNI','UVTA','EQUN01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almtgsis','TABL','TABL01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !LlRetVal
					IF USED('CATG')
						USE IN CATG
					ENDIF

					IF USED('DIVF')
						USE IN DIVF
					ENDIF
					IF USED('ALMA')
						USE IN ALMA
					ENDIF
					IF USED('UVTA')
						USE IN UVTA
					ENDIF
					IF USED('TABL')
						USE IN TABL
					ENDIF
					IF USED('DTRA')
						USE IN DTRA
					ENDIF
					IF USED('DETA')
						USE IN DETA
					ENDIF
					IF USED('TCMB')
						USE IN TCMB
					ENDIF
					IF USED('GUIA')
						USE IN GUIA
					ENDIF
					IF USED('CLIE')
						USE IN CLIE
					ENDIF
					IF USED('VPED')
						USE IN VPED
					ENDIF
					IF USED('RPED')
						USE IN RPED
					ENDIF
					IF USED('DOCM')
						USE IN DOCM
					ENDIF
					IF USED('GDOC')
						USE IN GDOC
					ENDIF
					RETURN LlRetVal
				ENDIF

			CASE _CodDoc $ [FACT|BOLE]
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','CCTCLIEN','','','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdmauxi','CLIE','AUXI01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtavpedi','VPED','VPED01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtarpedi','RPED','RPED02','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtatdocm','DOCM','DOCM01','')
				   LlRetVal =  .f.
				ENDIF
					*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtavguia','GUIA','VGUI01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCatgE','CATG','CATG01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almCATAL','CALM','CATA01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almDTRAN','DTRA','DTRA04','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','vtaritem','DETA','ITEM01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almDTRAN','DTRA','DTRA04','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','admmtcmb','TCMB','TCMB01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almtgsis','TABL','TABL01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almEQUNI','UVTA','EQUN01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','almtDIVF','DIVF','DIVF01','')
				   LlRetVal =  .f.
				ENDIF
				** Archivo Auxiliar **
				IF USED('AUXI')
					SELECT auxi
					zap
				ELSE

					Arch = SYS(2023)+'\'+SYS(3)
					SELE 0
					CREATE TABLE (Arch) FREE ( CodDoc C(4), NroDoc C(LEN(GDOC.NroDoc)), FchDoc D, Selec L(1), FlgEst C(1), NroPed C(LEN(GDOC.NroPed)) )
					USE (Arch) ALIAS AUXI EXCLU
					IF !USED()
					   LlRetVal =  .f.
					ENDIF
				ENDIF
				IF !LlRetVal
					IF USED('CATG')
						USE IN CATG
					ENDIF

					IF USED('DIVF')
						USE IN DIVF
					ENDIF
					IF USED('TDOC')
						USE IN TDOC
					ENDIF
					IF USED('UVTA')
						USE IN UVTA
					ENDIF
					IF USED('TABL')
						USE IN TABL
					ENDIF
					IF USED('DTRA')
						USE IN DTRA
					ENDIF
					IF USED('DETA')
						USE IN DETA
					ENDIF
					IF USED('TCMB')
						USE IN TCMB
					ENDIF
					IF USED('GUIA')
						USE IN GUIA
					ENDIF
					IF USED('CLIE')
						USE IN CLIE
					ENDIF
					IF USED('VPED')
						USE IN VPED
					ENDIF
					IF USED('RPED')
						USE IN RPED
					ENDIF
					IF USED('DOCM')
						USE IN DOCM
					ENDIF
					IF USED('GDOC')
						USE IN GDOC
					ENDIF
					IF USED('AUXI')
						USE IN AUXI
					ENDIF

					RETURN LlRetVal
				ENDIF

				** relaciones a usar **
				SELECT GDOC
				RETURN LlRetVal
			CASE _coddoc = 'CTB'
					*********************************************************************** FIN() *
				* Objeto : Abrir Base de Contabilidad
				******************************************************************************
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdvmovm','Head','vmov01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdrmovm','item','rmov01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdtoper','oper','oper01','')
				   LlRetVal =  .f.
				ENDIF
				*
				IF !THIS.oDatAdm.AbrirTabla('ABRIR','cbdacmct','acct','acct01','')
				   LlRetVal =  .f.
				ENDIF

				*
				IF !LlRetval
					IF USED('CTAS')
						USE IN ctas
					ENDIF

					IF USED('HEAD')
						USE IN HEAD
					ENDIF
					IF USED('ITEM')
						USE IN ITEM
					ENDIF
					IF USED('OPER')
						USE IN OPER
					ENDIF
					IF USED('ACCT')
						USE IN ACCT
					ENDIF
				ENDIF


				RETURN LlRetVal


		ENDCASE 
	ENDPROC


	*-- Vincular contenedor de la pagina principal
	PROCEDURE vincularcntpage
		LPARAMETER toControl

		this.ocntpage = toControl
	ENDPROC


	*-- Vincular contenedor  de la cabecera
	PROCEDURE vincularcntcab
		LPARAMETER toControl

		this.ocntcab = toControl
	ENDPROC


	*-- Retorna el valor de la llave primaria de la tabla cabecera de transacciones
	PROCEDURE cfgvar_pk
		PARAMETERS TcTabla

		LOCAL LsCampo,LcCursor,LsArea_Act
		LsArea_Act=SELECT()
		TcTabla=UPPER(TcTabla)
		SELECT * from admin!sistdbfs WHERE archivo=TcTabla INTO CURSOR c_dbfs
		SELECT * from admin!sistcdxs WHERE archivo=TcTabla AND primary INTO CURSOR c_cdxs


		IF RECCOUNT('c_dbfs')=0
			USE IN c_dbfs
			RETURN SIN_DEFINIR_ENTIDAD
		ENDIF

		IF RECCOUNT('c_cdxs')=0
			USE IN c_cdxs
			RETURN TRANSAC_SIN_CORRE
		ENDIF
		this.cIndice_PK	=	TRIM(c_cdxs.indice)
		this.ccampos_PK	=	TRIM(c_cdxs.Llave) 
		this.cEval_valor_pk = RTRIM(c_dbfs.eval_valor_pk)
		*this.cvalor_PK	=	EVALUATE(c_dbfs.eval_valor_pk)
		this.cvalor_PK	=	this.cvalor_PK
		USE IN sistcdxs
		USE IN c_Cdxs
		USE IN c_dbfs

		SELECT(LsArea_Act)
	ENDPROC


	*-- Captura el tipo de movimiento segun configuracion de ventas
	PROCEDURE captipmovalm
		PARAMETERS _cEntidad , _cCamposPK ,_cValoresPK

		LOCAL LoDatadm as Object ,LcSql AS String ,LcAlias as String ,LnCerrar as integer , LsAlias_Act As String
		Lsalias_Act = ALIAS()
		LcAlias		= _cEntidad+'_xx'
		LnCerrar	= 0
		IF !USED(_cEntidad)
			LoDatAdm = CREATEOBJECT('dosvr.dataadmin')
			LnCerrar = LoDatAdm.GenCursor(LcAlias,_cEntidad,'', _cCamposPK ,_cValoresPK )

		ELSE
			LcAlias = _cEntidad
			=SELECT(_cEntidad)
			LOCATE FOR &_cCamposPK  =  _cValoresPK
		ENDIF

		this.cTipMov = &LcAlias..TipMov
		this.sCodMov = TRIM(&LcAlias..CodMov)
		this.SubAlm  = &LcAlias..SubAlm


		IF LnCerrar > 0
			IF USED(LcAlias)
				USE IN (LcAlias)
			ENDIF
		ENDIF

		IF !EMPTY(LsAlias_Act)
			SELECT (LsAlias_Act)
		ENDIF
	ENDPROC


	*-- Tipo de familia
	PROCEDURE _tipofamilia
		PARAMETERS _TipFam
		LOCAL LcDesTipFam
		LcDesTipFam = ''
		DO case
			CASE _Tipfam = 1
				LcDesTipFam = "Insumo" 
			CASE _Tipfam = 2
				LcDesTipFam = "Terminado"
			CASE _Tipfam = 3
				LcDesTipFam = "En proceso"
			CASE _Tipfam = 4
				LcDesTipFam = "Suministro"
		ENDCASE
		RETURN LcDesTipFam
	ENDPROC


	*-- Realiza la transacci�n segun parametros de actualizaci�n.
	PROCEDURE ejecuta_transaccion
		PARAMETERS ;
		cQue_Transaccion as string, ;
		cQue_Accion AS String 
		**PROCEDURE xGraba
		this.que_transaccion =	cQue_Transaccion
		** NOTA > Solo es crear y genera SIEMPRE correlativos **
		**
		DO CASE
			CASE cQue_transaccion = 'ALMACEN'

			CASE cQue_transaccion = 'VENTAS'

				*!*	IF !(&RegVal.)
				IF THIS.Crear 
					SELECT (this.cAliasCab)		&& GDOC
					IF SEEK(this.cValor_PK ,this.cAliasCab,this.cIndice_PK)
						This.XsNroDoc=this.gen_id('0')
						IF SEEK(this.cValor_PK ,this.cAliasCab,this.cIndice_PK)
						    RETURN REGISTRO_YA_EXISTE
						ENDIF
					ENDIF
					SELECT (THIS.cAliasCab)
				   APPEND BLANK
				   REPLACE TpoDoc WITH THIS.XsTpodoc 
				   REPLACE CodDoc WITH this.XsCodDoc
				   REPLACE NroDoc WITH this.XsNroDoc
				   =this.gen_id(this.XsNroDoc)
				ELSE
					SELECT (THIS.cAliasCab)
					=SEEK(this.cValor_PK ,this.cAliasCab,this.cIndice_PK)
				   IF ! RLOCK()
				      RETURN -1
				   ENDIF
				ENDIF
				**************
				SELECT (THIS.cAliasCab)
				REPLACE PtoVta	WITH EVALUATE(this.ccursor_c+'.PtoVta')
				REPLACE FchDoc WITH EVALUATE(this.ccursor_c+'.fchdoc')
				REPLACE FchVto WITH EVALUATE(this.ccursor_c+'.FchVto')
				REPLACE CodVen WITH EVALUATE(this.ccursor_c+'.CodVen')
				REPLACE TablDest WITH EVALUATE(this.ccursor_c+'.TablDest')
				REPLACE Destino WITH EVALUATE(this.ccursor_c+'.Destino')
				REPLACE TablVia WITH EVALUATE(this.ccursor_c+'.TablVia')
				REPLACE Via		WITH EVALUATE(this.ccursor_c+'.Via')
				REPLACE DiaVto WITH EVALUATE(this.ccursor_c+'.DiaVto')
				Replace FchVto WITH FchDoc + DiaVto
				REPLACE NroPed WITH EVALUATE(this.ccursor_c+'.NroPed')
				REPLACE NroO_C WITH EVALUATE(this.ccursor_c+'.NroO_C')
				REPLACE FchO_C WITH EVALUATE(this.ccursor_c+'.FchO_C')
				REPLACE FmaPgo WITH EVALUATE(this.ccursor_c+'.FmaPgo')
				REPLACE FmaSol WITH EVALUATE(this.ccursor_c+'.FmaSol')
				REPLACE CndPgo WITH EVALUATE(this.ccursor_c+'.CndPgo')
				REPLACE Ruta   WITH EVALUATE(this.ccursor_c+'.Ruta')
				IF This.Tag='REGULA_CCB' && No afecta importes, detalle ni contabilidad
					SELECT (THIS.cAliasCab)
					UNLOCK 
					RETURN
				ENDIF
				REPLACE CodCli WITH EVALUATE(this.ccursor_c+'.CodCli')
				REPLACE NomCli WITH EVALUATE(this.ccursor_c+'.NomCli')
				REPLACE CodDire WITH EVALUATE(this.ccursor_c+'.CodDire')
				REPLACE DirCli WITH EVALUATE(this.ccursor_c+'.DirCli')
				REPLACE RucCli WITH EVALUATE(this.ccursor_c+'.RucCli')
				REPLACE CodMon WITH EVALUATE(this.ccursor_c+'.CodMon')
				REPLACE TpoCmb WITH EVALUATE(this.ccursor_c+'.TpoCmb')
				REPLACE PorIgv WITH EVALUATE(this.ccursor_c+'.PorIgv')
				REPLACE PorDto WITH EVALUATE(this.ccursor_c+'.PorDto')
				REPLACE ImpBto WITH EVALUATE(this.ccursor_c+'.ImpBto')
				REPLACE ImpDto WITH EVALUATE(this.ccursor_c+'.ImpDto')
				replace TpoVta	WITH EVALUATE(this.ccursor_c+'.TpoVta')
				REPLACE ImpInt WITH EVALUATE(this.ccursor_c+'.ImpInt')
				REPLACE ImpGas WITH EVALUATE(this.ccursor_c+'.ImpGas')
				REPLACE ImpFlt WITH EVALUATE(this.ccursor_c+'.ImpFlt')
				REPLACE ImpSeg WITH EVALUATE(this.ccursor_c+'.ImpSeg')
				REPLACE ImpAdm WITH EVALUATE(this.ccursor_c+'.ImpAdm')
				REPLACE ImpIgv  WITH EVALUATE(this.ccursor_c+'.ImpIgv')
				REPLACE ImpTot  WITH EVALUATE(this.ccursor_c+'.ImpTot')
				REPLACE ImpNet  WITH EVALUATE(this.ccursor_c+'.ImpTot')
				REPLACE SdoDoc  WITH EVALUATE(this.ccursor_c+'.ImpTot')
				REPLACE GloDoc  WITH EVALUATE(this.ccursor_c+'.GloDoc')
				REPLACE FlgEst  WITH EVALUATE(this.ccursor_c+'.FlgEst')
				REPLACE FlgUbc  WITH EVALUATE(this.ccursor_c+'.FlgUbc')
				REPLACE TpoRef  WITH this.XsTpoRef
				REPLACE CodRef	WITH this.XsCodRef
				REPLACE NroRef	WITH this.XsNroRef


				this.graba_detalle_ventas(this.XsCodRef) 
				** ACTUALIZAMOS CONTABILIDAD **
				IF !INLIST(this.XsCoddoc,'PEDI')
					cKeyTpoDocSN = THIS.Codsed+This.XsCodDoc+This.XsPtoVta
					this.oContab.Actualiza_Contabilidad(cQue_transaccion,cKeyTpoDocSN)
				ENDIF
				* * *
				SELECT (THIS.cAliasCab)
				UNLOCK 

		ENDCASE

		RETURN 1
	ENDPROC


	*-- Genera correlativo para la transaccion
	PROCEDURE gen_id
		Lparameters _cValor,_cTabla
		IF !(VARTYPE(_cTabla) == 'C')		 
			_cTabla=this.entidadcorrelativo
		ENDIF

		IF !(VARTYPE(_nMes) == 'N')		 
			_nMes = _Mes
		ENDIF

		LOCAL LcCursor,LcNroMes
		LcNroMes = TRANSFORM(_nMes,'@L 99')
		LcCursor = SYS(2015) 

		LnResult = THIS.oDatAdm.GenCursor( LcCursor,_cTabla ,,this.ccmps_id,this.cvalor_id)
		*_cTabla=THIS.oDatAdm.RutaTabla(_cTabla)

		IF LnResult=0
			IF USED(LcCursor)
				USE IN (LcCursor)
			ENDIF
			RETURN '-1'
		ENDIF

		Local LsCampo,LnNroDoc,LsPicture,LnLenSufijo,LnLenNDoc,LsCampo2
		SELECT (LcCursor)
		LcVarSufijo = IIF(EMPTY(Var_Suf_ID),SPACE(2),EVALUATE(Var_Suf_ID))
		IF Corr_U
		**	m.sNroDoc = RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(cDOC->NroDoc)),LEN(m.sNroDoc))
			LsCampo = LcCursor+'.'+campo_id 
			LsCampo2 = campo_id 
		ELSE
			LsCampo = LcCursor+'.'+ccampo_id+LcVarSufijo
			LsCampo2 = ccampo_id +LcVarSufijo
		ENDIF
		LnNroDoc= EVAL(LsCampo)
		IF EMPTY(LnNroDoc) OR ISNULL(LnNroDoc)
			*WAIT WINDOW NOWAIT "Falta definir en maestro de correlativos por almacen"
		ENDIF
		LsPicture = "@L "+REPLI('#',Len_id)

		*IF CDOC->ORIGEN
		DO CASE
			CASE	Ant_Mes >0 
				LnLenNDoc = Len_id - LEN(LcNroMes)
				LnNroDoc = VAL(LcNroMes+RIGHT(TRANSF(LnNroDoc,LsPicture),LnLenNDoc))
			CASE	Ant_Serie >0 
				LnLenNDoc = Len_id - LEN(Serie)
				LnNroDoc = VAL(Serie+RIGHT(TRANSF(LnNroDoc,LsPicture),LnLenNDoc))
			CASE	Ant_PtoVta>0
				LnLenNDoc = Len_id - LEN(PtoVta)
				LnNroDoc = VAL(PtoVta+RIGHT(TRANSF(LnNroDoc,LsPicture),LnLenNDoc))
		ENDCASE
		m.Len_ID = Len_id

		IF !_cValor == '0'
			IF VAL(_cValor) > LnNroDoc
		    	LnNroDoc = VAL(_cValor) + 1
			ELSE
		    	LnNroDoc = LnNroDoc + 1
			ENDIF     
		*!*	    DO CASE 
		*!*	    	CASE XsNroMES <= "13"
		*!*	        	LsCampo='NDOC'+XsNroMes
		*!*	        OTHER
		*!*	        	LsCampo='NRODOC'
		*!*	   ENDCASE
			THIS.oDatAdm.actualizatabla( LcCursor,_cTabla ,,this.ccmps_id,this.cvalor_id,LsCampo2,STR(LnNroDoc)) 
		*!*	   UPDATE (_cTabla) SET &LsCampo2. = LnNroDoc ;
		*!*	   WHERE TipMov=_Tipmov and Codmov=_Codmov and SubAlm=_Almacen
		ENDIF
		USE IN (LcCursor)

		RETURN  RIGHT(REPLI('0',m.Len_id) + LTRIM(STR(LnNroDoc)), m.Len_id)
	ENDPROC


	*-- Configura los valores de las variables que intervienen en la generacion del correlativo (ID)
	PROCEDURE cfgvar_id
		PARAMETERS TcTabla

		LOCAL LsCampo,LcCursor,LsArea_Act
		LsArea_Act=SELECT()
		TcTabla=UPPER(TcTabla)
		SELECT * from admin!sistdbfs WHERE archivo=TcTabla INTO CURSOR c_dbfs
		SELECT * from admin!sistcdxs WHERE archivo=TcTabla AND primary INTO CURSOR c_cdxs


		IF RECCOUNT('c_dbfs')=0
			USE IN c_dbfs
			RETURN SIN_DEFINIR_ENTIDAD
		ENDIF

		IF RECCOUNT('c_cdxs')=0
			USE IN c_cdxs
			RETURN TRANSAC_SIN_CORRE
		ENDIF
		this.cIndice_id	=	TRIM(c_cdxs.indice)
		this.ccmps_id	=	TRIM(c_cdxs.Llave) 
		this.cvalor_id	=	EVALUATE(c_dbfs.eval_valor_pk)

		this.ccampo_id	=	TRIM(c_dbfs.eval_campo_id) 
		*!*	LcCursor = SYS(2015) 
		*!*	LnResult=this.odatadm.GenCursor(LcCurSor,TcTabla,'',this.cCmps_Id,This.cValor_Id) 
		*!*	IF LnResult <=0
		*!*		USE IN c_Cdxs
		*!*		USE IN c_dbfs
		*!*		RETURN	ERROR_GEN_CURSOR
		*!*	ENDIF

		*!*	SELECT (LcCursor)
		*!*	LsCampo=TRIM(T_DESTINO)+'.'+THIS.CCAMPO_ID

		*!*	this.nlen_id = LEN(EVALUATE(LsCampo))
		*!*	this.nlen_id  = Len_ID
		this.entidadcorrelativo = TcTabla

		USE IN c_Cdxs
		USE IN c_dbfs
		*!*	USE IN (LcCursor)

		SELECT(LsArea_Act)
	ENDPROC


	*-- Graba el detalle de ventas segun tipo de documento de referencia.
	PROCEDURE graba_detalle_ventas
		LPARAMETERS XsCodRef
		DO CASE 
			CASE INLIST(XsCodRef,'G/R','G\R','GR-','G-R','GUI')
				** Actualizamos G/R **
				SELE AUXI
				SCAN FOR FlgEst = [*]
				   SELE GUIA
				   SET ORDER TO VGUI01
				   SEEK AUXI.CodDoc+AUXI.NroDoc
				   IF !RLOCK()
				      SELE AUXI
				      LOOP
				   ENDIF
				   REPLACE CodFac WITH THIS.XsCodDoc     && << OJO <<
				   REPLACE NroFac WITH THIS.XsNroDoc
				   REPLACE FlgEst WITH [F]          && Facturado
				   UNLOCK
				   SELE AUXI
				ENDSCAN
				** Grabamos Browse **
				SELECT(THIS.cAliasdet)  	&&DETA

				IF THIS.CREAR 
					PRIVATE i
					i = 1
					DO WHILE i <= THIS.GiTotItm
					   APPEND BLANK
			  		   GATHER NAME this.adetalle(i) fields except nro_reg
					   REPLACE FchDoc WITH THIS.XdFchDoc
						UNLOCK
					   i = i + 1
					ENDDO
				ELSE
		*!*				PRIVATE i
		*!*				i = 1
		*!*				DO WHILE i <= THIS.GiTotItm
		*!*
		*!*					LsLlave = this.adetalle(i).coddoc+this.adetalle(i).nrodoc 
		*!*					SEEK LsLlave
		*!*					IF !FOUND()
		*!*						=MESSAGEBOX('ESTAS AGREGANDO ITEMS Y SOLO DEBES MODIFICARLOS',16)
		*!*					ELSE
		*!*						GATHER NAME this.adetalle(i)
		*!*						REPLACE FchDoc WITH THIS.XdFchDoc
		*!*						UNLOCK
		*!*						i = i + 1
		*!*					ENDIF
		*!*				ENDDO

					SEEK this.XsCodDoc+this.XsNroDoc 
					DELETE WHILE CodDoc+NroDoc = this.XsCodDoc+this.XsNroDoc 
					SELECT (this.cCursor_d)
					SCAN 
						SCATTER MEMVAR 
						SELECT(this.caliasdet) 
						APPEND BLANK
						GATHER MEMVAR fields except nro_reg
						REPLACE FchDoc WITH THIS.XdFchDoc
						UNLOCK 
						SELECT (this.cCursor_d)
					ENDSCAN 
					SELECT(this.caliasdet) 
				ENDIF


			CASE XsCodRef	= 'PEDI'
				** Primero Verificamos si el Pedido tiene G/R **
				SELE AUXI
				IF RECCOUNT() # 0
				   ** AJA!!! => marcamos las G/R como facturadas **
				   this.graba_detalle_ventas('G/R') 
				   RETURN
				ENDIF
				** Actualizamos PEDIDO **
				SELE VPED
				REPLACE FlgFac WITH [F]    && Marcamos el Pedido como FACTURADO
				UNLOCK
				** Grabamos Browse **
				SELE DETA
				PRIVATE i
				i = 1
				DO WHILE i <= this.GiTotItm
				   ** Actualizamos Saldo del Pedido **
				   SELE RPED
				   SEEK this.XsNroPed+this.AsCodMat(i)
				   XfCanFac = this.AfCanFac(i)
				   IF !RLOCK()
				      SELE VPED
				      LOOP
				   ENDIF
				   this.xAct_Ped
				   **
				   SELE DETA
		   		   APPEND BLANK
				   REPLACE CodDoc WITH XsCodDoc
				   REPLACE NroDoc WITH XsNroDoc
				   REPLACE FchDoc WITH XdFchDoc
				   REPLACE NroRef WITH THIS.AsNroG_R(i)
				   REPLACE CodMat WITH THIS.AsCodMat(i)
				   REPLACE DesMat WITH THIS.AsDesMat(i)
				   REPLACE UndVta WITH THIS.AsUndVta(i)
				   REPLACE PreUni WITH THIS.AfPreUni(i)
				   REPLACE D1     WITH THIS.AnD1    (i)
				   REPLACE D2     WITH THIS.AnD2    (i)
				   REPLACE D3     WITH THIS.AnD3    (i)
				   REPLACE CanFac WITH THIS.AfCanFac(i)
				   REPLACE FacEqu WITH THIS.AfFacEqu(i)
				   REPLACE ImpLin WITH THIS.AfImpLin(i)
				   UNLOCK
				   i = i + 1
				ENDDO

			CASE XsCodRef	= 'FREE'
				** Grabamos Browse **
		*!*	*!*			PRIVATE i
		*!*	*!*			i = 1
		*!*	*!*			DO WHILE i <= THIS.GiTotItm
		*!*	*!*				SELE DETA
		*!*	*!*				APPEND BLANK
		*!*	*!*				REPLACE CodDoc WITH XsCodDoc
		*!*	*!*				REPLACE NroDoc WITH XsNroDoc
		*!*	*!*				REPLACE FchDoc WITH XdFchDoc
		*!*	*!*				REPLACE NroRef WITH THIS.AsNroG_R(i)
		*!*	*!*				REPLACE CodMat WITH THIS.AsCodMat(i)
		*!*	*!*				REPLACE DesMat WITH THIS.AsDesMat(i)
		*!*	*!*				REPLACE UndVta WITH THIS.AsUndVta(i)
		*!*	*!*				REPLACE PreUni WITH THIS.AfPreUni(i)
		*!*	*!*				REPLACE D1     WITH THIS.AnD1    (i)
		*!*	*!*				REPLACE D2     WITH THIS.AnD2    (i)
		*!*	*!*				REPLACE D3     WITH THIS.AnD3    (i)
		*!*	*!*				REPLACE CanFac WITH THIS.AfCanFac(i)
		*!*	*!*				REPLACE FacEqu WITH THIS.AfFacEqu(i)
		*!*	*!*				REPLACE ImpLin WITH THIS.AfImpLin(i)
		*!*	*!*				i = i + 1
		*!*	*!*			ENDDO


						IF THIS.CREAR 
							SELECT (this.cCursor_d)
							SCAN
			   				   SCATTER MEMVAR
		 	   				   SELECT(THIS.cAliasdet)  
							   APPEND BLANK
					  		   GATHER MEMVAR FIELDS EXCEPT Nro_Reg  && AutoIncremental es solo de lectura
							ENDSCAN
						ELSE
		   				   SELECT(THIS.cAliasdet)  
							SEEK this.XsCodDoc+this.XsNroDoc 
							DELETE WHILE CodDoc+NroDoc = this.XsCodDoc+this.XsNroDoc 
							SELECT (this.cCursor_d)
							SCAN 
								SCATTER MEMVAR 
								SELECT(this.caliasdet) 
								APPEND BLANK
								GATHER MEMVAR FIELDS EXCEPT Nro_Reg  && AutoIncremental es solo de lectura
								UNLOCK 
								SELECT (this.cCursor_d)
							ENDSCAN 
							SELECT(this.caliasdet) 
						ENDIF


			OTHERWISE 
				DO CASE 
					CASE this.XsCodDoc = 'P'						&& Pedidos
						************************************************************************ FIN *
						* Objeto : Grabacion de Informacion
						******************************************************************************
		*!*					PROCEDURE xBgrab
						&& Aqui hay que cambiar por XML - Cursor
						LOCAL Attend,Totale,Pendie AS Integer  
						STORE 0 TO Attend ,	Totale,	Pendie 

						IF THIS.CREAR 
							SELECT (this.cCursor_d)
							SCAN
			   				   SCATTER MEMVAR
		 	   				   SELECT(THIS.cAliasdet)  
							   APPEND BLANK
					  		   GATHER MEMVAR FIELDS EXCEPT Nro_Reg  && AutoIncremental es solo de lectura
			   				   DO CASE
							      CASE CanDes = 0
							         REPLACE FlgEst WITH " "
							         Pendie = Pendie + 1
							      CASE CanDes < CanPed
							         REPLACE FlgEst WITH "P"
						    	     Attend = Attend + 1
						      	  OTHER
						         	REPLACE FlgEst WITH "C"
							         Totale = Totale + 1
							   ENDCASE

							ENDSCAN
						ELSE
		   				   SELECT(THIS.cAliasdet)  
							SEEK this.XsNroDoc 
							DELETE WHILE NroDoc = this.XsNroDoc 
							SELECT (this.cCursor_d)
							SCAN 
								SCATTER MEMVAR 
								SELECT(this.caliasdet) 
								APPEND BLANK
								GATHER MEMVAR FIELDS EXCEPT Nro_Reg  && AutoIncremental es solo de lectura
								UNLOCK 
				   				   DO CASE
								      CASE CanDes = 0
								         REPLACE FlgEst WITH " "
								         Pendie = Pendie + 1
								      CASE CanDes < CanPed
								         REPLACE FlgEst WITH "P"
							    	     Attend = Attend + 1
							      	  OTHER
							         	REPLACE FlgEst WITH "C"
								         Totale = Totale + 1
								   ENDCASE
								SELECT (this.cCursor_d)
							ENDSCAN 
							SELECT(this.caliasdet) 
						ENDIF
						SELECT(this.caliascab) 
						DO CASE
						   CASE Attend = 0 .AND. Totale = 0 .AND. Pendie > 0
						      REPLACE FlgEst WITH "E"
						   CASE Attend = 0 .AND. Totale > 0 .AND. Pendie = 0
						      REPLACE FlgEst WITH "C"
						   OTHER
						      REPLACE FlgEst WITH "E"
						ENDCASE


					CASE INLIST(THIS.XsCodDoc ,'N/C','N\C','NC')	&& Nota Credito
					CASE INLIST(THIS.XsCodDoc ,'N/D','N\D','ND')	&& Nota Debito

				ENDCASE 

		RETURN

		ENDCASE
	ENDPROC


	*-- Carga detalle de la factura con los items de la(s) guia(s) seleccionada(s)
	PROCEDURE traer_items_guias
		*PROCEDURE xBiniv2b

		**
		PRIVATE i,j
		STORE 0 TO i,j    && i : cantidad de items aceptados
		                  && j : cantidad de items por guia
		PRIVATE XcTipMov,XsCodMov,XsNroDoc,XsNroRef
		XcTipMov = [S]
		STORE [] TO XsCodMov,XsNroDoc,XsNroRef
		SELE AUXI
		DELETE FOR !(FlgEst=[*])   && borramos los no seleccionados
		SCAN 
		   * barremos la 1ra. guia *
		   XsCodRef = CodDoc
		   XsNroRef = NroDoc
		   SELE DTRA
		*   LsLlave = XcTipMov+XsCodMov+XsNroDoc
			LsLLave = XsCodRef+XsNroRef
		   j = 0
		   =SEEK(LsLLave,'DTRA','DTRA04')
		   SCAN WHILE TpoRef+NroRef = LsLlave FOR CanDes>0 AND TipMov=this.cTipMov AND  CodMov$this.sCodMov
		      j = j + 1
		   ENDSCAN
		   IF i+j > THIS.CIMAXELE    && Sobrepaso el limite
		      This.sErr = [A partir de la Guia ]+AUXI->NroDoc+[ no van a ser Facturados]
			  *    DO lib_merr WITH 99
		      * desmarcamos el resto de las guias *
		      SELE AUXI
		      REPLACE REST FlgEst WITH []
		      EXIT
		   ELSE
		      * Los Items de la guia son aceptados *
		      i = i + j
		   ENDIF
		   SELE AUXI
		ENDSCAN
		**************** FIN DEL CONTROL DE ITEMS POR FACTURA *****************
		SELE GUIA
		SET ORDER TO VGUI01
		SELE RPED
		SET ORDER TO RPED02
		SELE AUXI
		GO TOP
		i = 0
		This.GiTotItm = 0

		SCAN FOR FlgEst = [*]
		*	this.oitem=CREATEOBJECT('dosvr.Lineadetalle')
		   XsCodRef = CodDoc
		   XsNroRef = NroDoc
		   THIS.XsGloDoc = THIS.XsGloDoc+XsNroRef+','
		   SELE DTRA
			LsLLave = XsCodRef+XsNroRef
		   =SEEK(LsLLave,'DTRA','DTRA04')
		   SCAN WHILE TpoRef+NroRef = LsLlave FOR CanDes>0 AND TipMov=this.cTipMov AND  CodMov$this.sCodMov
		      THIS.GiTotItm = THIS.GiTotItm + 1
		      DIMENSION THIS.aDetalle[THIS.GiTotItm]
		      THIS.aDetalle(THIS.GiTotItm) = CREATEOBJECT('dosvr.Lineadetalle')
			  this.oItem	=	THIS.aDetalle(THIS.GiTotItm)
			  this.oitem.TpoDoc  	= this.Xstpodoc 
			  this.oItem.CodDoc	 	= this.XsCodDoc
			  this.oItem.NroDoc  	= this.XsNroDoc
			  this.OItem.NroRef  	= this.XsNroRef
			  this.oItem.FchDoc		= this.XdFchDoc
		      this.oitem.NroG_R 	= AUXI.NroDoc
		      this.oitem.CodMat = CodMat
		      =SEEK(AUXI.CodDoc+AUXI.NroDoc,"GUIA")      && Guia de Remision
		      
		      =SEEK(THIS.oitem.CodMat,"CATG")                && Catalogo de Materiales
		      =SEEK(this.subalm + this.oitem.CodMat,"CALM")
		      IF SEEK(GUIA.NroPed+THIS.oitem.CodMat,"RPED")   && Materiales por Pedido
		         THIS.oitem.DesMat = RPED.DesMat
		      ELSE
		         THIS.oitem.DesMat = CATG.DesMat
		      ENDIF
		      THIS.oitem.UndVta = IIF(EMPTY(DTRA.UndVta),CALM.UndVta,DTRA.UndVta)
		      * Definimos la moneda y el precio unitario *
		      IF !EMPTY(GUIA.NroPed) .AND. SEEK(GUIA.NroPed,"VPED")
		         IF THIS.XiCodMon = VPED.CodMon
		            *CFGADMIGV
		            THIS.oitem.PreUni = RPED.PreUni
		            IF this.XsCODDOC=[BOLE]
		               THIS.oitem.PreUni = ROUND(RPED.PreUni*(1+THIS.XfPorIgv/100),3)
		            ENDIF
		            THIS.oitem.D1    = RPED.D1
		            THIS.oitem.D2    = RPED.D2
		            THIS.oitem.D3    = RPED.D3
		         ELSE
		            IF THIS.XiCodMon = 1
		               THIS.oitem.PreUni = ROUND(RPED.PreUni*THIS.XfTpoCmb,2)
		               IF THIS.XsCODDOC=[BOLE]
		                  THIS.oitem.PreUni(i) = ROUND(RPED.PreUni*(1+THIS.XfPorIgv/100),3)
		               ENDIF
		            ELSE
		               IF THIS.XfTpoCmb<>0
		                  THIS.oitem.PreUni = ROUND(RPED.PreUni/THIS.XfTpoCmb,2)
		                  IF this.XsCODDOC=[BOLE]
		                     THIS.oitem.PreUni = ROUND(RPED.PreUni*(1+THIS.XfPorIgv/100),3)
		                  ENDIF
		               ELSE
		                  THIS.oitem.PreUni = RPED.PreUni
		                  IF this.XsCODDOC=[BOLE]
		                     THIS.oitem.PreUni = ROUND(RPED.PreUni*(1+THIS.XfPorIgv/100),3)
		                  ENDIF
		                  THIS.oitem.D1     = RPED.D1
		                  THIS.oitem.D2     = RPED.D2
		                  THIS.oitem.D3     = RPED.D3
		               ENDIF
		            ENDIF
		         ENDIF
		      ELSE
		          THIS.oitem.D1    = DTRA.D1
		          THIS.oitem.D2    = DTRA.D2
		          THIS.oitem.D3    = DTRA.D3
		        ** * * * * * * *
		         IF THIS.XiCodMon = 1
		            IF EMPTY(DTRA.PREUNI)
		               THIS.oitem.PreUni = IIF(CATG.CodMon=1,CATG.PuinMN,ROUND(CATG.PuinUS*THIS.XfTpoCmb,2))
		            ELSE
		               THIS.oitem.PreUni = DTRA.PREUNI
		            ENDIF
		            IF this.XSCODDOC=[BOLE]
		            	THIS.oitem.PreUni = ROUND(THIS.oitem.PreUni*(1+THIS.XfPorIgv/100),3)
		            ENDIF
		         ELSE
		            IF THIS.XfTpoCmb<>0
		               IF EMPTY(DTRA.PREUNI)
		               		THIS.oitem.PreUni = IIF(CATG.CodMon=1,CATG.PuinMN,CATG.PuinUS)
		               ELSE
			           		THIS.oitem.PreUni = DTRA.PREUNI
		               ENDIF
		               IF this.XSCODDOC=[BOLE]
		                  THIS.oitem.PreUni = ROUND(THIS.oitem.PreUni*(1+THIS.XfPorIgv/100),3)
		               ENDIF
		            ELSE
		               IF EMPTY(DTRA.PREUNI)
		                  THIS.oitem.PreUni = CATG.PuinUS
		               ELSE
		                  THIS.oitem.PreUni = DTRA.PREUNI
		               ENDIF
		               IF this.XsCODDOC=[BOLE]
		                  THIS.oitem.PreUni = ROUND(THIS.oitem.PreUni*(1+THIS.XfPorIgv/100),3)
		               ENDIF
		            ENDIF
		         ENDIF
		        ** * * * * * * *
		      ENDIF
		      THIS.oitem.CanFac = CanDes
		      THIS.oitem.FacEqu = Factor
		      THIS.oitem.ImpLin = ROUND(THIS.oitem.CanFac*THIS.oitem.PreUni*(1-THIS.oitem.D1/100)*(1-THIS.oitem.D2/100)*(1-THIS.oitem.D3/100),2)
		      i = i + 1
		      this.oitem=0  && Aqui desvinculamos el objeto detalle de el arreglo y dejamos a aDetalle intacto 

		  ENDSCAN
		ENDSCAN

		THIS.XsGloDoc = LEFT(THIS.XsGloDoc,LEN(GDOC.GloDoc))
		*** Cargamos el arreglo a el cursor
		SELECT (this.ccursor_d)
		DELETE ALL
		this.objarr2cursor(this.adetalle,this.Gitotitm ,this.ccursor_d)   
		*DO xRegenera
		IF CURSORGETPROP("Buffering",this.ccursor_d) > 1
			LlOk=TABLEUPDATE(1,.F.,this.ccursor_d)
			IF !Llok
				TABLEREVERT(.T.,this.ccursor_d)
			ENDIF
		ENDIF
		RETURN LlOk
	ENDPROC


	*-- Cargar los items de una guia
	PROCEDURE traer_items_g_r
		*PROCEDURE xBiniv2a

		this.XsNroRef = PADR(This.XsNroRef,LEN(GUIA.NroDoc))
		=SEEK(this.XsCodRef+this.XsNroRef,"GUIA")
		SELE AUXI
		ZAP
		APPEND BLANK
		REPLACE CodDoc WITH GUIA.CodDoc
		REPLACE NroDoc WITH GUIA.NroDoc
		REPLACE FchDoc WITH GUIA.FchDoc
		REPLACE FlgEst WITH [*]
		this.traer_items_guias()  
	ENDPROC


	*-- Cargar el objeto contenido en cada elemento de un arreglo a un cursor
	PROCEDURE objarr2cursor
		** Este metodo recibe una matriz(array) de una dimension cada fila es un objeto que
		** tiene como propiedades los campos que pertenecen al cursor o tabla que es pasado como 
		** parametro , osea debe ser una tabla o cursor abierto, por ahora no nos engorremos en crear la tabla
		** en base a las propiedades (campos) del objeto.
		PARAMETERS _aObjeto,_nElementos,_cCursor

		IF !USED(_cCursor)
			RETURN .f.
		ENDIF

		LOCAL k,LsAlias_act
		LsAlias_Act = SELECT()
		SELECT (_cCursor)

		FOR k=1 TO _nElementos
			APPEND BLANK
			GATHER NAME this.adetalle(k)
		ENDFOR

		SELECT(LsAlias_act)
		RETURN .t.
	ENDPROC


	PROCEDURE cvalor_pk_access
		*Pendiente: modificar esta rutina para el m�todo Access
		this.cvalor_PK	=	EVALUATE(this.cEval_valor_pk)
		RETURN THIS.cvalor_pk
	ENDPROC


	*-- Devuelva una cadena con la expresion en letras de un numero.
	PROCEDURE num2let
		*!*********************************************************************
		*!
		*!      Procedure: Numero
		*!                Num        : El n�mero que se desea escribir.
		*!                Dec        : N�mero de Decimales.
		*!                StrTipo    : Forma de escribir el n�mero :
		*!                             1 Mayusculas
		*!                             2 Minusculas
		*!                             3 Propia
		*!
		*!*********************************************************************
		*FUNC NUMERO
		PARAMETERS Num , Dec , StrTipo

		PRIVATE NumTexto,CienTexto,Ciento,Miles,Largo,Entero,Decimal

		NumTexto = []
		CienTexto= []
		Entero   = LTRIM(STR(INT(Num),15,0))
		Decimal  = RIGHT(STR(NUM,15,Dec),Dec)
		Largo    = LEN(Entero)
		Ciento   = []
		Miles    = 0

		DO WHILE Largo > 0

		   Ciento    = RIGHT('   '+Entero,3)     && Toma los Tres �ltimos digitos
		   Digito1   = SUBSTR(Ciento,3,1)        && El Ultimo D�gito
		   Digito2   = SUBSTR(Ciento,2,1)        && Pen�ltimo D�gito
		   Digito3   = SUBSTR(Ciento,1,1)        && Antepen�ltimo D�gito
		   CienTexto = []
		   * Texto del �ltimo d�gito *(UNIDADES)**********************************
		   DO CASE
		      CASE Digito1='1'
		         CienTexto='uno'
		      CASE Digito1='2'
		         CienTexto='dos'
		      CASE Digito1='3'
		         CienTexto='tres'
		      CASE Digito1='4'
		         CienTexto='cuatro'
		      CASE Digito1='5'
		         CienTexto='cinco'
		      CASE Digito1='6'
		         CienTexto='seis'
		      CASE Digito1='7'
		         CienTexto='siete'
		      CASE Digito1='8'
		         CienTexto='ocho'
		      CASE Digito1='9'
		         CienTexto='nueve'
		   ENDCASE
		   * Texto de los dos �ltimos d�gitos **(DECENAS)*************************
		   DO CASE
		      CASE Digito2='1'
		         DO CASE
		            CASE Digito1='0'
		               CienTexto='diez'
		            CASE Digito1='1'
		               CienTexto='once'
		            CASE Digito1='2'
		               CienTexto='doce'
		            CASE Digito1='3'
		               CienTexto='trece'
		            CASE Digito1='4'
		               CienTexto='catorce'
		            CASE Digito1='5'
		               CienTexto='quince'
		            OTHERWISE
		               CienTexto='dieci'+CienTexto
		         ENDCASE
		      CASE Digito2='2'
		         CienTexto= IIF(Digito1#'0','veinti'   +CienTexto,'veinte')
		      CASE Digito2='3'
		         CienTexto= IIF(Digito1#'0','treinti'  +CienTexto,'treinta')
		      CASE Digito2='4'
		         CienTexto= IIF(Digito1#'0','cuarenti' +CienTexto,'cuarenta')
		      CASE Digito2='5'
		         CienTexto= IIF(Digito1#'0','cincuenti'+CienTexto,'cincuenta')
		      CASE Digito2='6'
		         CienTexto= IIF(Digito1#'0','sesenti'  +CienTexto,'sesenta')
		      CASE Digito2='7'
		         CienTexto= IIF(Digito1#'0','setenti'  +CienTexto,'setenta')
		      CASE Digito2='8'
		         CienTexto= IIF(Digito1#'0','ochenti'  +CienTexto,'ochenta')
		      CASE Digito2='9'
		         CienTexto= IIF(Digito1#'0','noventi'  +CienTexto,'noventa')
		   ENDCASE
		   * Texto de los tres �ltimos d�gitos *(CENTENAS)************************
		   DO CASE
		      CASE Digito3='1'
		         CienTexto= IIF(CienTexto==[],'cien','ciento '+CienTexto)
		      CASE Digito3='2'
		         CienTexto='doscientos '   +CienTexto
		      CASE Digito3='3'
		         CienTexto='trescientos '  +CienTexto
		      CASE Digito3='4'
		         CienTexto='cuatrocientos '+CienTexto
		      CASE Digito3='5'
		         CienTexto='quinientos '   +CienTexto
		      CASE Digito3='6'
		         CienTexto='seiscientos '  +CienTexto
		      CASE Digito3='7'
		         CienTexto='setecientos '  +CienTexto
		      CASE Digito3='8'
		         CienTexto='ochocientos '  +CienTexto
		      CASE Digito3='9'
		         CienTexto='novecientos '  +CienTexto
		   ENDCASE
		   ***********************************************************************

		   IF Miles > 0 .AND. RIGHT(CienTexto,3)='uno'
		      CienTexto = SUBSTR(CienTexto,1,LEN(CienTexto)-1)
		   ENDIF

		   DO CASE
		      CASE Miles = 0
		         NumTexto= CienTexto
		      CASE (Miles= 1 .OR. Miles=3 .OR. Miles=5) .AND. VAL(Ciento)>0
		         NumTexto= CienTexto + ' mil ' + LTRIM(NumTexto)
		      CASE Miles = 2
		         IF CienTexto = 'un'
		            NumTexto  = 'un millon '+LTRIM(NumTexto)
		         ELSE
		            NumTexto  = CienTexto+' millones '+LTRIM(NumTexto)
		         ENDIF
		      CASE Miles =4
		         IF NumTexto = 'millones'
		            NumTexto = []
		         ENDIF
		         IF CienTexto= 'un'
		            NumTexto = 'un billon '+LTRIM(NumTexto)
		         ELSE
		            NumTexto = CienTexto + ' billones '+LTRIM(NumTexto)
		         ENDIF
		   ENDCASE
		   Miles   = Miles +1
		   Entero  = SUBSTR(Entero , 1 ,IIF(Largo>3 ,Largo-3,0) )
		   Largo   = Len(Entero)
		ENDDO

		NumTexto = LTRIM(TRIM(NumTexto))
		IF NumTexto == []
		   NumTexto = 'cero'
		ENDIF

		IF Dec > 0
		   NumTexto = NumTexto + ' con '+Decimal+'/100'
		ENDIF
		DO CASE
		   CASE  TYPE("StrTipo") <> "N"
		   CASE  StrTipo = 1
		      NumTexto = UPPER(NumTexto)
		   CASE  StrTipo = 3
		      NumTexto = UPPER(SUBSTR(NumTexto,1,1))+SUBSTR(NumTexto,2,LEN(NumTexto)-1)
		   CASE  StrTipo = 4
		      Numtexto = PROPER(NumTexto)
		ENDCASE

		RETURN NumTexto
	ENDPROC


	*-- Anula un documento segun el tipo de transaccion
	PROCEDURE anular_transaccion
		* Borrar Informacion
		******************************************************************************
		*!*	PROCEDURE xBorrar
		PARAMETERS cQue_transaccion 
		DO CASE 
			CASE cQue_transaccion = 'ALMACEN'
			CASE cQue_transaccion = 'VENTAS'

				cSufijo_Transaccion='_ANULAR'
				SELECT(this.cAliasCab) 	&& GDOC
				SEEK this.cvalor_pk 
				IF !FOUND()
					RETURN DOCUMENTO_NO_EXISTE
				ENDIF


				IF FlgEst#"P" .AND. FlgEst# "A"
				   **WAIT "INVALIDO REGISTRO A ANULAR" NOWAIT WINDOW
				   RETURN INVALIDO_REGISTRO
				ENDIF
				DO CASE 
					CASE INLIST(this.XsCodDoc,'F','B','N') 
						IF SdoDoc#ImpTot
						   **WAIT "DOCUMENTO TIENE AMORTIZACIONES" NOWAIT WINDOW
						   RETURN TIENE_AMORTIZACIONES
						ENDIF
						IF FlgCtb   && Ya paso a Contabilidad
						   XdFchDoc = GDOC->FchDoc
						   IF !this.verica_cierre_contable(XdFchDoc)
						      this.sErr = "Mes Cerrado, acceso denegado"
						      SELE GDOC
						      RETURN MES_CERRADO
						   ENDIF
						   SELE GDOC
						ENDIF

						IF !F1_RLOCK(5)

						    RETURN REGISTRO_BLOQUEADO
						ENDIF
						IF CodRef = [PEDI]
						   SELE VPED
						   SEEK GDOC->NroPed
						   IF !RLOCK()
						      SELE GDOC
						      UNLOCK
						      RETURN REGISTRO_BLOQUEADO
						   ENDIF
						ENDIF
						** Anulamos de Acuerdo al Tipo de Factura
						SELECT(this.caliascab) && GDOC
						THIS.BOrra_registro_transaccion(GDOC.CodRef) 
						* * * * *

						IF GDOC.FlgCtb
						   this.oContab.Actualiza_Contabilidad(cQue_transaccion+cSufijo_Transaccion)
						ENDIF

						* * * * *
						* anulado total
						* * * * *
						SELE GDOC
						IF FlgEst = "A"  && PARA QUE DESAPARESCA
						   DELETE
						ELSE

							REPLACE FlgEst WITH [A]
							REPLACE FchAct WITH DATE()
							REPLACE SdoDoc WITH 0
						ENDIF
						UNLOCK
						SKIP
					CASE INLIST(this.XsCodDoc,'P')   && Pedidos
						SELECT(this.caliascab) && GDOC
						THIS.BOrra_registro_transaccion(this.XsCodRef) 

				ENDCASE

		ENDCASE

		RETURN S_OK
	ENDPROC


	PROCEDURE verica_cierre_contable
		**FUNCTION Modificar
		PARAMETERS _FchDoc
		PRIVATE LnMes,LsAno
		LnMes = MONTH(_FchDoc)
		LsAno = YEAR(_FchDoc)
		this.oDatAdm.Abrirtabla('ABRIR','CBDTCIER','TCIE','','','',GsCodCia,STR(_ANO,4))
		SELE TCIE
		RegAct = MONTH(_FchDoc) + 1
		IF RegAct <= RECCOUNT()
		   GO RegAct
		ENDIF
		lCierre = !Cierre
		USE

		RETURN lCierre
	ENDPROC


	*-- Borra los registros de la transaccion segun el tipo de documento de referencia
	PROCEDURE borra_registro_transaccion
		**PROCEDURE xBorra1
		PARAMETERS _cCodref
		DO CASE 
			CASE _cCodref = 'G/R'
				* Buscamos G/R *
				SELE GUIA
				SET ORDER TO VGUI03
				SEEK GDOC.CodDoc+GDOC.NroDoc
				DO WHILE !EOF() .AND. CodFac+Nrofac = GDOC.CodDoc+GDOC.NroDoc
				   IF !RLOCK()
				      LOOP
				   ENDIF
				   REPLACE CodFac WITH []     && OJITO
				   REPLACE NroFac WITH []
				   REPLACE FlgEst WITH [E]
				   UNLOCK
				   SEEK GDOC->CodDoc+GDOC->NroDoc
				ENDDO
				SET ORDER TO VGUI01
				** anulamos detalles **
				SELE DETA
				SEEK GDOC->CodDoc+GDOC->NroDoc
				DO WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. ! EOF()
				   IF ! RLOCK()
				      LOOP
				   ENDIF
				   DELETE
				   UNLOCK
				   SKIP
				ENDDO

				RETURN

		************************************************************************ FIN()
		* Borrar Informacion
		******************************************************************************
		**PROCEDURE xBorra2
			CASE _cCodref = 'PEDI'
				* Verificamos Status del Pedido *
				SELE VPED
				IF FlgFac = [F]      && OJO : Todo el Pedido fue Facturado
				   ** anulamos detalles **
				   SELE DETA
				   SEEK GDOC->CodDoc+GDOC->NroDoc
				   DO WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. ! EOF()
				      IF ! RLOCK()
				         LOOP
				      ENDIF
				      =SEEK(VPED->NroDoc+DETA->CodMat,"RPED")
				      IF !RLOCK("RPED")
				         LOOP
				      ENDIF
				      DO xDes_Ped
				      SELE DETA
				      DELETE
				      UNLOCK
				      SKIP
				   ENDDO
				   SELE VPED
				   REPLACE FlgFac WITH []
				   UNLOCK
				ELSE
				   ** Desmarcamos G/R **
				   DO this.Borra_registro_transaccion(_cCodref) 
				ENDIF

				RETURN
		************************************************************************ FIN()
		* Borrar Informacion
		******************************************************************************
		**PROCEDURE xBorra3
			CASE _cCodref = 'FREE'
				** anulamos detalles **
				SELE DETA
				SEEK GDOC->CodDoc+GDOC->NroDoc
				DO WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. ! EOF()
				   IF ! RLOCK()
				      LOOP
				   ENDIF
				   DELETE
				   UNLOCK
				   SKIP
				ENDDO

				RETURN

			OTHERWISE 
				DO CASE 
					CASE this.XsCodDoc = 'P'						&& Pedidos

						************************************************************************ FIN()
						* Borrar Informacion
						******************************************************************************
		*!*					PROCEDURE xBorrar

						SELECT(this.caliascab)  && VPED
						BORTOT = .T.
						IF FlgEst = 'A'
						   IF !RLOCK()
						      RETURN
						   ENDIF
						   SELECT(this.caliasdet) && RPED
						   SEEK this.cvalor_pk  && VPED->NroDoc
						   DO WHILE NroDoc=VPED.NroDoc .AND. ! EOF()
						      IF RLOCK()
						         DELETE
						      ENDIF
						      UNLOCK
						      SKIP
						   ENDDO
						   SELECT(this.caliascab)  && VPED
						   DELETE
						   SKIP
						   RETURN
						ENDIF
						IF FlgEst = 'C'
		*!*					   GsMsgErr = [ Pedido Completo ]
		*!*					   DO lib_merr WITH 99
						   RETURN
						ENDIF
						IF FlgEst = 'P'
						   IF MESSAGEBOX(" Pedido Parcialmente Atendido, Desea continuar? ",4+32+256,'Atencion!')=7
						      RETURN
						   ENDIF
						   BORTOT = .F.
						ENDIF
						* Verificamos Flags
						SELECT(this.caliasdet)  && RPED
						SEEK VPED.NroDoc
						SCAN WHILE NroDoc = VPED.NroDoc
						   IF !EMPTY(FlgEst)    && Atencion Parcial o Total
							   IF MESSAGEBOX(" Pedido Parcialmente Atendido, Desea continuar? ",4+32+256,'Atencion!')=7
			         			   SELECT(this.caliascab)  && VPED
							         RETURN
						      ENDIF
						      BORTOT = .F.
						      WAIT "SE PROCEDE AL CIERRE DEL PEDIDO" WINDOW NOWAIT
						      EXIT
						   ENDIF
						ENDSCAN
						SELECT(this.caliascab)  &&VPED
						IF ! RLOCK()
						   RETURN
						ENDIF
						** anulamos detalles **
						SELECT(this.caliasdet)   && RPED
						SEEK VPED.NroDoc
						DO WHILE NroDoc=VPED.NroDoc .AND. ! EOF()
						   IF ! RLOCK()
						      LOOP
						   ENDIF
						   IF INLIST(FlgEst,[ ],[P])
						      REPLACE FLGEST WITH "N"    && NO atendido
						   ENDIF
						   IF BorTot
						      DELETE
						   ENDIF
						   UNLOCK
						   SKIP
						ENDDO
						SELECT(this.caliascab)  && VPED

						IF BorTot
						   REPLACE FlgEst WITH [A]
						ELSE
						   *** Cierra el pedido en forma manual ***
						   REPLACE FlgEst WITH [c]
						ENDIF
						UNLOCK
						SKIP


					CASE INLIST(THIS.XsCodDoc ,'N/C','N\C','NC')	&& Nota Credito
					CASE INLIST(THIS.XsCodDoc ,'N/D','N\D','ND')	&& Nota Debito

				ENDCASE 

		ENDCASE 
	ENDPROC


	*-- Descripcion del estado del documento
	PROCEDURE est_doc
		PARAMETERS _cFlgEst,_cQue_Transaccion
		IF PARAMETERS()<2
			_cQue_Transaccion	= this.Que_transaccion 
		ENDIF
		LOCAL LsDescrip
		LsDescrip = ''
		DO CASE 
			CASE _cQue_Transaccion = 'ALMACEN'

			CASE _cQue_Transaccion = 'VENTAS'
				DO CASE 
					CASE !INLIST(this.XsCodDoc,'PEDI')
						DO CASE
							CASE _cFlgEst = 'A'
								LsDescrip = 'Documento anulado'
							CASE _cFlgEst = 'C'
								LsDescrip = 'Documento cancelado'
							CASE _cFlgEst = 'P'
								LsDescrip = 'Documento pendiente'
							CASE _cFlgEst = 'F'
								LsDescrip = 'Documento facturado'
							CASE _cFlgEst = 'T'
								LsDescrip = 'Guia no es de ventas'
							 
						ENDCASE
					OTHER 
						DO CASE
							CASE _cFlgEst = 'A'
								LsDescrip = 'Pedido anulado'
							CASE _cFlgEst = 'C'
								LsDescrip = 'Pedido totalmente atendido'
							CASE _cFlgEst = 'P'
								LsDescrip = 'Pedido parcialmente atendido'
							CASE _cFlgEst = 'c'
								LsDescrip = 'Pedido cerrado manualmente'
							CASE _cFlgEst = 'E'
								LsDescrip = 'Pedido emitido'
							 
						ENDCASE

				ENDCASE 
		ENDCASE
		RETURN  LsDescrip 
	ENDPROC


	*-- Traer items de varias G/R de un cliente.
	PROCEDURE traer_items_g_r_cli
		Parameters PsAliasGuia,PsCamposPK,PsValorPK,PsIndice,PsCamposFiltro,PsValorFiltro,LsCursor,IdDataSession
		LOCAL LlReturn	,LcArea_Act,LsOrder
		IF PARAMETERS()=0
			PsAliasGuia		=	'GUIA'
			PsCamposPK		=	'CodCli+FlgEst' 
			PsValorPK		= 	THIS.XsCodCli+THIS.Xcflgest_ref
			PsIndice		=	'VGUI04'  
			PsCamposFiltro	=	'CodDoc' 
			PsValorFiltro	=	THIS.XsCodRef
			LsCursor		=	'AUXI'
			IdDataSession	=	1
		ENDIF

		IF EMPTY(IdDataSession) OR VARTYPE(IdDataSession)<>'N'
			DO CASE
			CASE TYPE("THISFORM") == "O"
				IdDataSession = THISFORM.DataSessionId 
			CASE TYPE("_SCREEN.ACTIVEFORM") == "O"
				IdDataSession = _SCREEN.ACTIVEFORM.DataSessionId 
			OTHERWISE
				IdDataSession = 1
			ENDCASE
		ENDIF
		SET DATASESSION TO (IdDataSession)
		** Y si no existe el cursor ** 


		LcArea_Act=SELECT()
		SELE (LsCursor)
		ZAP
		SELE (PsAliasGuia)
		LsOrder = ORDER()
		SET ORDER TO (PsIndice) &&VGUI04
		SEEK PsValorPK    && XsCodCli+[E] ; PsCamposPK = CodCli+FlgEst ; PsCamposFiltro = CodDoc
		SCAN WHILE EVAL(PsCamposPK) = PsValorPK FOR EVAL(PsCamposFiltro) = PsValorFiltro
		    SELE (LsCursor)
		    APPEND BLANK
		    DO CASE
		    	CASE UPPER(PsCamposFiltro)='CODDOC'  
				    REPLACE CodDoc WITH &PsAliasGuia..CodDoc
				    REPLACE NroDoc WITH &PsAliasGuia..NroDoc
				CASE UPPER(PsCamposFiltro)='CODFAC'  
				    REPLACE CodDoc WITH &PsAliasGuia..CodFac
				    REPLACE NroDoc WITH &PsAliasGuia..NroFac

		    ENDCASE
		    REPLACE FchDoc WITH &PsAliasGuia..FchDoc
		    REPLACE NroPed WITH &PsAliasGuia..NroPed
		    LlReturn = .T.
		    SELE (PsAliasGuia)
		ENDSCAN
		SET ORDER TO (LsOrder)
		SELE (LsCursor)
		GO TOP
		IF RECCOUNT()=0
		   GsMsgErr = [No existen Guias de Remisi�n Pendientes de Facturar]
		   LlReturn = .f.
		ENDIF
		 *
		IF !LlReturn
			IF !EMPTY(LsArea_Act)
				SELECT (LsArea_Act)

			ENDIF
		ENDIF

		Return LlReturn 
	ENDPROC


	*-- Permiter obtener el costo de almacen de un item especifico
	PROCEDURE costo_almacen
		PARAMETERS m.CodSed,m.CodMat,m.FchDocD,m.CodMon,m.Que_busca

			  * SALDOS INICIALES
		      *
		      
		      STORE 0 TO fStkAct, fValAct,fValIni
			  SELECT DTRA 
			  SET ORDER TO DTRA09
		      SEEK m.CodSed+m.CodMat+DTOC(m.FchDocD+1,1)
		      IF !FOUND()
		         IF RECNO(0)>0
		            GO RECNO(0)
		            IF DELETED()
		               SKIP
		            ENDIF
		         ENDIF
		      ENDIF
		      m.Reg_Ini = RECNO() 
		      SKIP -1
		      IF CodSed+CodMat=m.CodSed+m.CodMat AND FchDoc <= m.FchDocD
		         fStkAct = DTRA.StkAct
		         fValAct = IIF(m.CodMon = 1, VCTOMN, VCTOUS)
		      ENDIF
		*!*	      SKIP
		*!*	      IF RECNO()<>m.Reg_Ini AND m.Reg_Ini>0
		*!*	         GO m.Reg_Ini
		*!*	      ENDIF
		      *
		      * NO LISTA LOS QUE NO TIENEN MOVIMIENTO
		      *
		      IF !(DTRA.CodSed+DTRA.CodMat=m.CodSed+m.CodMat) AND fStkAct = 0
		         RETURN 0
		      ENDIF
		      *
		      IF fStkAct>0
			      fPrcPmd  = IIF(fStkAct>0,round(fValAct/fStkAct,4),0)
		      ELSE
		      	  fImpCto  = IIF(m.CodMon=1, DTRA.ImpNac, DTRA.ImpUsa)
			      fCanDes  = IIF(DTRA.Factor>0,round(DTRA.CanDes*DTRA.Factor,4),DTRA.CanDes)
		          fPreUni  = IIF(fCandes#0,round(fImpCto/fCanDes,4),fImpCto)
		      	  fPrcPmd  = fPreuni
		      ENDIF
		      *
		      fValIni  = fValIni + fValAct

		DO CASE 
			CASE m.Que_busca = COSTO_UNIT_ALMACEN 
				RETURN  fPrcPmd
			CASE m.Que_busca = VALOR_ALMACEN     
				RETURN  fValAct     
			CASE m.Que_busca = STOCK_ALMACEN     
				RETURN  fStkAct     
		ENDCASE 
	ENDPROC


	PROCEDURE mensajeerr
		PARAMETERS TnId_Error
		IF TnId_error = 0
			RETURN 0
		ENDIF
		SELECT * from admin!sistlerr WHERE id_err = TnId_error INTO ARRAY aMensaje
		IF _TALLY>0
			RETURN MESSAGEBOX(amensaje(1,2),amensaje(1,4)+amensaje(1,5),aMensaje(1,6))
		ELSE
			RETURN MESSAGEBOX('Se ha producido un error no identificado',0+16,'Atenci�n!!/Atention!!')
		ENDIF
	ENDPROC


	*-- cargar los documentos en base a los cuales sera generada la guia.
	PROCEDURE cargar_guia_enbasea_docs
		Parameters PsAliasTabla,PsTabla,PsCamposPK,PsValorPK,PsIndice,PsCamposFiltro,PsValorFiltro,LsCursor,IdDataSession
		LOCAL LlReturn	,LcArea_Act,LsOrder
		IF PARAMETERS()=0
			PsAliasTabla	=	'GDOC'
			PsTabla			=	'CCBRGDOC'
			PsCamposPK		=	'FLGEST+TPODOC+CODDOC+NRODOC' 
			PsValorPK		= 	THIS.Xcflgest_ref+THIS.XsTporef+THIS.XsCodref+This.XsNroref   
			PsIndice		=	'GDOC05'  
			** Falta hacer mas inteligente el control de estos 2 parametros, por revisar VETT 2005-05-27
		*!*		IF VARTYPE(PsCamposFiltro)='C' AND EMPTY(PsCamposFiltro)
				PsCamposFiltro	=	'CodCli;CodVen;Ruta' 
		*!*		ENDIF
		*!*		IF VARTYPE(PsValorFiltro)='C' AND EMPTY(PsValorFiltro)
				PsValorFiltro	=	THIS.XsCodCli+";"+THIS.XsCodven+";"+this.XsRuta  
		*!*		ENDIF
			LsCursor		=	'AUXI'
			IdDataSession	=	1
		ENDIF

		IF EMPTY(IdDataSession) OR VARTYPE(IdDataSession)<>'N'
			DO CASE
			CASE TYPE("THISFORM") == "O"
				IdDataSession = THISFORM.DataSessionId 
			CASE TYPE("_SCREEN.ACTIVEFORM") == "O"
				IdDataSession = _SCREEN.ACTIVEFORM.DataSessionId 
			OTHERWISE
				IdDataSession = 1
			ENDCASE
		ENDIF
		SET DATASESSION TO (IdDataSession)
		LcArea_Act=SELECT()

		LlCierraTabla = .F.
		IF !USED(PsAliasTabla)
			IF !THIS.oDatAdm.AbrirTabla('ABRIR',PsTabla,PsAliasTabla,PsIndice,'')
			   LlRetVal =  .f.
			   RETURN LlRetVal
			ENDIF
			LlCierraTabla = .t.
		ENDIF

		** Y si no existe el cursor ** 
		IF !USED(LsCursor)
			Arch = SYS(2023)+'\'+SYS(3)
			SELE 0
			CREATE TABLE (Arch) FREE ( CodDoc C(4), NroDoc C(LEN(GDOC.NroDoc)), FchDoc D, Selec L(1), FlgEst C(1), NroPed C(LEN(GDOC.NroPed)) )
			USE (Arch) ALIAS AUXI EXCLU
			IF !USED()
			   LlRetVal =  .f.
			   RETURN LlRetVal 
			ENDIF
		ENDIF


		SELE (LsCursor)
		ZAP
		SELE (PsAliasTabla)
		LsOrder = ORDER()
		SET ORDER TO (PsIndice) &&VGUI04
		SEEK PsValorPK    && XsCodCli+[E] ; PsCamposPK = CodCli+FlgEst ; PsCamposFiltro = CodDoc
		SCAN WHILE EVAL(PsCamposPK) = PsValorPK FOR EVAL(PsCamposFiltro) = PsValorFiltro
		    SELE (LsCursor)
		    APPEND BLANK
		    DO CASE
		      	CASE UPPER(PsCamposFiltro)='TPOREF'  
				    REPLACE CodDoc WITH &PsAliasTabla..CodDoc
				    REPLACE NroDoc WITH &PsAliasTabla..NroDoc
		    	CASE UPPER(PsCamposFiltro)='CODDOC'  
				    REPLACE CodDoc WITH &PsAliasTabla..CodDoc
				    REPLACE NroDoc WITH &PsAliasTabla..NroDoc
				CASE UPPER(PsCamposFiltro)='CODFAC'  
				    REPLACE CodDoc WITH &PsAliasTabla..CodFac
				    REPLACE NroDoc WITH &PsAliasTabla..NroFac

		    ENDCASE
		    REPLACE FchDoc WITH &PsAliasTabla..FchDoc
		    REPLACE NroPed WITH &PsAliasTabla..NroPed
		    LlReturn = .T.
		    SELE (PsAliasTabla)
		ENDSCAN
		SET ORDER TO (LsOrder)
		SELE (LsCursor)
		GO TOP
		IF RECCOUNT()=0
		   GsMsgErr = [No existen Guias de Remisi�n Pendientes de Facturar]
		   LlReturn = .f.
		ENDIF
		 *
		IF !LlReturn
			IF !EMPTY(LsArea_Act)
				SELECT (LsArea_Act)

			ENDIF
		ENDIF

		Return LlReturn 
	ENDPROC


	PROCEDURE Init
		this.oEntorno=CREATEOBJECT('Dosvr.Env')
		this.odatadm=CREATEOBJECT('Dosvr.DataAdmin')
		this.oItem=CREATEOBJECT('Dosvr.LineaDetalle')
		this.oContab=CREATEOBJECT('Dosvr.Contabilidad')
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF SET("Development")='ON' 
			LnRpta=MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')


			DO CASE
				CASE  LnRpta =3
					SUSPEND 
				CASE  LnRpta =4 
					SET STEP ON 
				CASE  LnRpta =5
					retry
			ENDCASE

			RETURN CONTEXT_E_ABORTED
		ELSE

			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
			RETURN CONTEXT_E_ABORTED

		ENDIF
	ENDPROC


	*-- Agrega un item al arreglo que almacena los registros del detalle de la transaccion
	PROCEDURE additem_detalle
	ENDPROC


	*-- Carga los items (detalle) de la guia en base a docs
	PROCEDURE cargar_guia_detalle_enbasea_docs
	ENDPROC


	*-- Graba registro del  detalle en el cursor local.
	PROCEDURE graba_registro_local_detalle
	ENDPROC


ENDDEFINE
*
*-- EndDefine: onegocios
**************************************************


**************************************************
*-- Class:        validadatos (k:\aplvfp\classgen\vcxs\dosvr.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   01/11/06 02:38:09 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS validadatos AS custom OLEPUBLIC


	Height = 23
	Width = 100
	Name = "validadatos"


	*-- Valida datos del cliente
	PROCEDURE validacliente
		PARAMETERS _CodCli,_CodDoc,_fImpTot,XsCursor
		LOCAL LoDatAdm,LlCerrarCursor
		LlCerrarCursor = .f.
		IF VARTYPE(XsCurSor)='U'
			XsCurSor = SYS(2015)
			LlCerrarCursor = .t.
		ENDIF
		LodatAdm=createobject('dosvr.dataadmin')

		nErrCode = S_OK

		XfLimite = 0
		LnControl=LoDatAdm.GenCursor(XsCurSor,'V_CLIENTES','','CodAux',_CodCli)

		IF LnControl<0
			RETURN SIN_ACCESO_TABLA
		ENDIF


		SELECT (XsCurSor)
		LOCATE
		DO CASE

			CASE EOF()
				nErrCode = CUST_NOT_FOUND
			CASE FlgInf
				nErrCode = CLIENTE_EN_INFOCORD
			CASE _fImpTot>MaxCred AND !EMPTY(MaxCred)
				nErrCode = LIMIT_EXCEEDED
			OTHERWISE
		ENDCASE
		IF LlCerrarCursor
			USE IN (XsCurSor)
		ELSE

		ENDIF
		USE IN v_clientes
		RELEASE LoDatAdm
		RETURN nErrCode
	ENDPROC


	*-- Valida codigo de material de almacen
	PROCEDURE validacodigoalmacen
		LPARAMETERS XsCodMat,XsSubAlm,XsCodSed,XcTipMov,XlStkNeg,XsLote,XfCanDes,XdFchDoc,XsCurSor
		LlCerrarCursor = .f.
		IF VARTYPE(XsCurSor)='U'
			XsCurSor = SYS(2015)
			LlCerrarCursor = .t.
		ENDIF
		LOCAL LoDatAdm as DataAdmin OF DoSvr
		LodatAdm=createobject('dosvr.dataadmin')

		LOCAL aProdStock,nErrCode,oMtx,oContext,lDataNotOpened,LnControl
		DIMENSION aProdStock[1]
		nErrCode = S_OK

		XfStock = 0
		IF EMPTY(XsSubAlm)
			LnControl=LoDatAdm.GenCursor(XsCurSor,'V_materiales_sin_almacen','Catg01','CodMat',XsCodMat)
		ELSE
			LnControl=LoDatAdm.GenCursor(XsCurSor,'V_materiales_x_almacen_3','Catg01',[_SubAlm:_CodMat],XsSubAlm+":"+XsCodMat,[CodSed=']+XsCodSed+['])
		ENDIF
		IF LnControl<0
			RETURN SIN_ACCESO_TABLA

		ENDIF


		SELECT (XsCurSor)
		LOCATE
		DO CASE

			CASE EOF()
				nErrCode = ITEM_NO_EXISTE
			CASE !EMPTY(XsSubAlm)
				DO CASE 
					CASE ISNULL(SubAlm)
						nErrCode = ITEM_NO_ASIGNADO
					CASE NOT this.haystkalm(SubAlm,CodMat,XdFchDoc,,,,XfCanDes,.T.,@XfStock) AND XcTipMov='S'  AND EMPTY(XsLote)
						nErrCode = ITEM_SIN_STOCK
						IF XlStkNeg
							nErrCode = ITEM_SIN_STOCK_NEG
						ENDIF
			ENDCASE
			CASE NOT EMPTY(XsLote)
				nErrCode = this.validacodigoalmacenlote(XsCodMat,XsSubAlm,XsCodSed,XcTipMov,XlStkNeg, XsLote,XfCanDes,XdFchDoc,'C_Lote') 
			OTHERWISE
		*!*			UPDATE products ;
		*!*			  SET in_stock = in_stock - m.nOrdAmount;
		*!*			  WHERE ALLTRIM(UPPER(product_id)) == ALLTRIM(UPPER(m.cPID))
		*!*			IF _TALLY = 0
		*!*				nErrCode = ITEM_NO_EXISTE
		*!*			ENDIF
		ENDCASE
		IF LlCerrarCursor
			USE IN (XsCurSor)
		ELSE
			IF VARTYPE(Stk_alm) = 'N'
				replace Stk_alm WITH XfStock
			ENDIF
		ENDIF
		IF EMPTY(XsSubAlm)
			USE IN V_materiales_sin_almacen
		ELSE
			USE IN V_materiales_x_almacen_3
		ENDIF

		RELEASE LoDatAdm
		RETURN nErrCode
	ENDPROC


	*-- Verifica si hay stock suficiente
	PROCEDURE haystkalm
		PARAMETERS sSubAlm,sCodMat,dFecha,cTipmov,sCodMov,sNroDoc,fCandes,lNuevo,fStock
		PRIVATE m.CurrArea
		if vartype(dfecha) = 'T'
			dfecha=TTOD(dfecha)
		endif
		m.CurrArea = ALIAS()
		m.NroRegAct= RECNO()
		m.OrdenAct = ORDER()
		m.Nra_CALM = 0
		IF m.CurrArea#[CALM]
		   m.NRA_CALM=RECNO([CALM])
		   IF ORDER([CALM])=[CATA01]
		      =SEEK(sSubAlm+sCodmat,[CALM])
		   ELSE
		      =SEEK(sCodmat+sSubAlm,[CALM])
		   ENDIF
		ENDIF

		DO CASE
		   CASE lNuevo
		        =SEEK(sSubAlm+sCodmat,[CALM])
		        LfStkSub=CALM.StkIni
		        SELE DTRA
		        SET ORDER TO DTRA02
		        SEEK sSubAlm+sCodMat+DTOS(dFecha+1)
		        IF !FOUND()
		           IF RECNO(0)>0
		              GO RECNO(0)
		              IF DELETED()
		                 SKIP
		              ENDIF
		           ENDIF
		        ENDIF
		        SKIP -1
		        IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
		           LfStkSub = StkSub
		        ENDIF
		   CASE .NOT. lNuevo
		        =SEEK(sSubAlm+sCodmat,[CALM])
		        LfStkSub=CALM.StkIni
		        SELE DTRA
		        SET ORDER TO DTRA02
		        SEEK sSubAlm+sCodMat+DTOS(dFecha)+cTipMov+sCodMov+sNroDoc
		        IF FOUND()
		           SKIP -1
		           IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
		              LfStkSub = StkSub
		           ENDIF
		        ENDIF
		ENDCASE


		IF m.Nra_Calm>0 AND RECNO([CALM])<>m.Nra_CALM
		   GO m.Nra_CALM IN [CALM]
		ENDIF
		SELE (m.CurrArea)
		SET ORDER TO (OrdenAct)
		GO m.NroRegAct
		fStock = LfStkSub

		RETURN (LfStkSub>=fCandes)
	ENDPROC


	PROCEDURE validacodigoalmacenlote
		LPARAMETERS XsCodMat,XsSubAlm,XsCodSed,XcTipMov,XlStkNeg,XsLote,XfCanDes,XdFchDoc,XsCurSor
		LlCerrarCursor = .f.
		IF VARTYPE(XsCurSor)='U'
			XsCurSor = SYS(3)
			LlCerrarCursor = .t.
		ENDIF
		LodatAdm=createobject('dosvr.dataadmin')

		LOCAL aProdStock,nErrCode,oMtx,oContext,lDataNotOpened,LnControl
		DIMENSION aProdStock[1]
		nErrCode = S_OK

		XfStock = 0
		LnControl=LoDatAdm.GenCursor(XsCurSor,'v_materiales_x_lote','Catg01','CodSed+SUBALM+CodMat+Lote',XsCodSed+XsSubAlm+XsCOdMat+XsLote)

		IF LnControl<0
			RETURN SIN_ACCESO_TABLA

		ENDIF


		SELECT (XsCurSor)
		LOCATE
		DO CASE

			CASE EOF()	AND XcTipMov='S'
				nErrCode = ITEM_NO_EXISTE_LOTE
		*!*		CASE ISNULL(SubAlm)
		*!*			nErrCode = ITEM_NO_ASIGNADO
		*!*		CASE NOT this.haystkalm(SubAlm,CodMat,XdFchDoc,,,,XfCanDes,.T.,@XfStock)
		*!*			nErrCode = ITEM_SIN_STOCK
			CASE StkAct<XfCandes AND XcTipMov='S'
				nErrCode = ITEM_SIN_STOCK_LOTE
				IF XlStkNeg
					nErrCode = ITEM_SIN_STOCK_NEG_LOTE
				ENDIF

			OTHERWISE
		*!*			UPDATE products ;
		*!*			  SET in_stock = in_stock - m.nOrdAmount;
		*!*			  WHERE ALLTRIM(UPPER(product_id)) == ALLTRIM(UPPER(m.cPID))
		*!*			IF _TALLY = 0
		*!*				nErrCode = ITEM_NO_EXISTE
		*!*			ENDIF
		ENDCASE
		IF LlCerrarCursor
			USE IN (XsCurSor)
		ELSE
			replace Stk_alm WITH XfStock
		ENDIF
		USE IN V_materiales_x_lote

		RETURN nErrCode
	ENDPROC


	*-- Valida documento de referencia
	PROCEDURE validnroref
		PARAMETERS _cCodRef,_cNroRef,_cCodCli,XsCurSor

		LOCAL LoDatAdm,LlCerrarCursor
		LlCerrarCursor = .f.
		IF VARTYPE(XsCurSor)='U'
			XsCurSor = SYS(2015)
			LlCerrarCursor = .t.
		ENDIF
		LodatAdm=createobject('dosvr.dataadmin')

		nErrCode = S_OK
		IF !EMPTY(_cNroRef)
			_cNroRef = PADR(_cNroRef,LEN(GUIA.NroDoc))
		endif
		XfLimite = 0
		LnControl=LoDatAdm.GenCursor(XsCurSor,'VTAVGUIA','','CodDoc+NroDoc',_cCodRef+_cNroRef)

		IF LnControl<0
			RETURN SIN_ACCESO_TABLA
		ENDIF
		IF VARTYPE(_cCodCli)#'C'
			_cCodCli=''
		ENDIF

		SELECT (XsCurSor)
		LOCATE
		DO CASE
			CASE _cCodRef = 'G/R'

				DO CASE

					CASE EOF()
						nErrCode = GUIA_NO_EXISTE
				    CASE FlgEst = "A"
				    	nErrCode = GUIA_ANULADA
				    CASE FlgEst = "T"
				    	nErrCode = GUIA_NO_ES_DE_VENTAS
				    CASE FlgEst = "F"
				    	nErrCode = GUIA_FACTURADA
				    CASE NOT (CodCli = _cCodCli) AND !EMPTY(_cCodCli)
			    		nErrCode = GUIA_DE_OTRO_CLIENTE
					OTHERWISE

				ENDCASE
			CASE _cCodRef = 'O_T'
			CASE _cCodRef = 'O_C'
			CASE _cCodRef = 'PEDI'
			CASE _cCodRef = 'FACT'


		ENDCASE

		IF LlCerrarCursor
			USE IN (XsCurSor)
		ELSE

		ENDIF
		RELEASE LoDatAdm
		RETURN nErrCode
	ENDPROC


	*-- Valida el codigo del item ingresado al pedido
	PROCEDURE validaitempedido
		LPARAMETERS XsCodMat,XsCodSed,XlStkNeg,XsLote,XfCanDes,XdFchDoc,XsCurSor
	ENDPROC


	*-- Valida la existencia de un campo en una tabla o cursor
	PROCEDURE validacampotabla
		PARAMETERS __cTabla,__cCampo,__ctipo,__nlong,__nDec

		IF !VARTYPE(__cTabla)='C'
			ASSERT .f. MESSAGE '1er parametro: [nombre de tabla] debe ser caracter(string)'
			RETURN .f.
		ENDIF

		IF !VARTYPE(__cCampo)='C'
			ASSERT .f. MESSAGE '2do parametro: [nombre de campo] debe ser caracter(string)'
			RETURN .f.
		ENDIf

		IF !VARTYPE(__cTipo)='C'
			ASSERT .f. MESSAGE '3er parametro: [tipo de campo] debe ser caracter(string)'
			RETURN .f.
		ENDIF

		IF !USED(__cTabla)
			ASSERT .f. MESSAGE 'No esta abierta o disponible la tabla/cursor:'+__cTabla
			RETURN .f.
		ENDIf

		*!*	Verificamos la cantidad de parametros 
		IF PARAMETERS()<2
			RETURN .F.
		ENDIF
		IF PARAMETERS()<5
			__nDec = 0
		ENDIF
		IF PARAMETERS()<4
			__nLong = 10
		ENDIF
		IF PARAMETERS()<3
			__cTipo = ''
		ENDIF
		__cTipo = IIF(isnull(__cTipo) or EMPTY(__cTipo),'U',__cTipo)

		*!*	 Verificamos si el campo existe en la tabla 
		LsCampoEval= __cTabla+'.'+__cCampo
		IF !USED(__cTabla)
			RETURN .f.
		ENDIF
		IF VARTYPE(LsCampoEval)='U' 
			RETURN .f.
		ENDIF
		&& Validamos el tipo de dato de la tabla si es que han pasado un tipo de dato como parametro.
		IF __cTipo<>'U'
			IF VARTYPE(LsCampoEval)==__cTipo
				RETURN .f.
			ENDIF
		ENDIF

		RETURN .t.
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF SET("Development")='ON' 
			LnRpta=MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')


			DO CASE
				CASE  LnRpta =3
					SUSPEND 
				CASE  LnRpta =4 
					SET STEP ON 
				CASE  LnRpta =5
					retry
			ENDCASE

			RETURN CONTEXT_E_ABORTED
		ELSE

			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
			RETURN CONTEXT_E_ABORTED

		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: validadatos
**************************************************
