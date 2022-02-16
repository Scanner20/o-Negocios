**************************************************
*-- Class Library:  k:\aplvfp\libs\objetos_osis.vcx
**************************************************


**************************************************
*-- Class:        aux_codaux (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   06/11/05 12:10:00 PM
*
DEFINE CLASS aux_codaux AS texto


	MaxLength = 12
	estricto = .T.
	numerodigitos = 12
	tablavalid = "Taux"
	area_valid = 0
	ayudaalias = "Tauxiliar"
	ayudavalor = "codigo"
	Name = "aux_codaux"
	restringedigito = .F.


	PROCEDURE ayudapropiedades
		land=""

		This.AyudaWhere=ALLTRIM(This.AyudaWhere)

		IF !EMPTY(This.AyudaWhere) AND UPPER(LEFT(This.AyudaWhere,3))<>"AND"
			land=" and "
		ENDIF


		This.AyudaSqlselect = "Select a.aux_codaux as CODIGO,"+;
				 			  "Left(a.aux_nomaux,60) as NOMBRE,"+;
				 			  "a.aux_diraux,"+; 
						 	  "a.aux_numruc as RUC,"+;
							  "a.aux_inddom as DOM,"+;
							  "a.aux_fecact as FECACT "+;
							  "From V_Auxiliares a "+;
						      "Where a.cia_codcia='"+ThisForm.Entorno.Codigocia+"' "+;
		         		      " and a.aux_indest='1' "+land+This.AyudaWhere

		This.AyudaIndice[1,1]="codigo"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="nombre"
		This.AyudaIndice[2,2]="NOMBRE"
		This.AyudaIndice[3,1]="ruc"
		This.AyudaIndice[3,2]="RUC"
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()

		IF !This.AyudaActiva 
			IF EMPTY(NVL(This.Value,'')) AND !This.Estricto
			   RETURN
			ENDIF

			PRIVATE lcurdir,lcad
			lcurdir=SELECT()
			land=""
			This.AyudaWhere = ALLTRIM(This.AyudaWhere)

			IF LEN(This.AyudaWhere)>0 AND UPPER(LEFT(This.AyudaWhere,3))<>"AND"
				land=" and "
			ENDIF

			&&jcr: 11Jun05, reemplacé la vista por la vista v_auxiliares_aux, porque la validación estaba lenta 
			lcad="Select a.* "+;
				 "From dbo.V_AUXILIARES_AUX a "+;
			     "Where a.cia_codcia='"+ThisForm.Entorno.Codigocia+"' "+;
			     "and   a.aux_codaux='"+NVL(This.Value,"")+"' "+land+This.AyudaWhere
			     
			IF Ocnx.Tipo_BD=1     
				IF SQLEXEC(Ocnx.conexion,lcad,This.TablaValid)<0      
				   MESSAGEBOX("Error al validar Auxiliar: "+CHR(13)+MESSAGE()+CHR(13)+lcad,16,This.Name)
				   RETURN .f.
				ENDIF
			ENDIF
			IF Ocnx.Tipo_BD=4
				IF Ocnx.Ms_Ejecuta_SQL(lcad,This.TablaValid,ThisForm.DataSessionId)<0      
				   MESSAGEBOX("Error al validar Auxiliar: "+CHR(13)+MESSAGE(),16,This.Name)
				   RETURN .f.
				ENDIF
			ENDIF

			IF EOF()
			   MESSAGEBOX("El Auxiliar "+NVL(This.Value,SPACE(6))+" NO EXISTE O NO ES VALIDO",64,"Auxiliar") 
			   IF This.Estricto
			      SELECT (lcurdir)
			      RETURN .f.
			   ELSE
			      This.Value=""    
			   ENDIF
			ENDIF
			This.Area_valid=SELECT() 
		*!*		IF !EOF()
		*!*		    IF LEN(ALLTRIM(This.Value))<>This.NumeroDigitos AND This.restringedigito
		*!*		       MESSAGEBOX("El auxiliar tiene que tener "+STR(This.NumeroDigitos)+" Digitos",64,"Cuenta Contable")
		*!*			   IF This.Estricto
		*!*		    	  SELECT (lcurdir)
		*!*		      	  RETURN .f.
		*!*			   ELSE
		*!*		    	  This.Value=""    
		*!*			   ENDIF
		*!*		    ENDIF
		*!*		ENDIF
			This.DespuesValid()      
			SELECT (lcurdir)   
		ENDIF
	ENDPROC


	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: aux_codaux
**************************************************


**************************************************
*-- Class:        aux_direccion (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   06/28/03 11:19:09 AM
*
DEFINE CLASS aux_direccion AS texto


	Enabled = .F.
	Height = 23
	Width = 394
	*-- Código de Auxiliar
	aux_codaux = ("")
	lde_codlde = ("")
	Name = "aux_direccion"


	PROCEDURE Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select dbo.fx_auxiliar_direccion(?ThisForm.Entorno.Codigocia,?This.Aux_codaux,?This.Lde_codlde) as 'direcc' "
		IF SQLEXEC(Ocnx.conexion,lcad,"Tauxdirec")<0
		   SELECT (lcurdir)
		   WAIT WINDOW "Error: "+MESSAGE() NowAit
		ENDIF
		This.Value=Tauxdirec.direcc
		SELECT (lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: aux_direccion
**************************************************


**************************************************
*-- Class:        cba_codcba (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/08/03 07:00:11 PM
*
DEFINE CLASS cba_codcba AS texto


	InputMask = "XXXX"
	MaxLength = 4
	estricto = .T.
	numerodigitos = 4
	tablavalid = "Tcba"
	ayudavalor = "codigo"
	ayudaalias = "Tbanco_cba"
	Name = "cba_codcba"
	restringedigito = .F.


	PROCEDURE ayudapropiedades
		This.AyudaSqlselect = "Select a.cba_codcba as CODIGO,"+;
				              "        a.cba_numcta as NUMERO ,"+;
							  "        a.cba_descba as DESCRIPCION,"+;
							  "        c.tmo_codrep as MONEDA,"+;
							  "        a.bco_codbco as COD_BANCO,"+;
							  "        a.cct_codcct as CTA_CONTABLE,"+;
							  "        b.bco_nomlar as NOM_BANCO,"+;
							  "		   ISNULL(a.aux_codaux,'') as AUXILIAR,"+;
							  "		   ISNULL(d.aux_nomaux,'') as NOM_AUX,"+;
							  "		   a.tct_codtct as TIPO,"+;
							  "		   e.tct_deslar as DES_TIPO "+;
		                  	  " From cuentas_banco_cba a "+;
		                      "   Inner Join bancos_bco b "+;
			                  "     On(   b.bco_codbco=a.bco_codbco) "+;
		   	                  "   Inner Join tipo_de_moneda_tmo c "+;
		      	              "     On(   c.tmo_codtmo=a.tmo_codtmo) "+;
		      	              "	  Left join auxiliares_aux d "+;
		      	              "		ON (d.cia_codcia=a.cia_codcia "+;
		      	              "		and d.aux_codaux=a.aux_codaux) "+;
		      	              "	  Left join tipo_ctabanco_tct e "+;
		      	              "		ON (e.tct_codtct=a.tct_codtct) "+;
		         		      " Where a.cia_codcia=?Thisform.entorno.codigocia "+;
		               	      " and a.cba_indest='1' "+This.ayudawhere

		This.AyudaIndice[1,1]="codigo"
		This.AyudaIndice[1,2]="CUENTA"
		This.AyudaIndice[2,1]="numero"
		This.AyudaIndice[2,2]="NUMERO"
		This.AyudaIndice[3,1]="cod_banco"
		This.AyudaIndice[3,2]="BANCO"
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()

		IF !This.AyudaActiva 
			IF EMPTY(NVL(This.Value,'')) AND !This.Estricto
			   RETURN
			ENDIF

			PRIVATE lcurdir,lcad
			lcurdir=SELECT()
			lcad="Select a.cba_codcba,a.bco_codbco,a.tmo_codtmo,a.cct_codcct,a.tct_codtct,"+;
				 "a.cba_numcta,a.cba_descba,b.bco_nomlar,a.aux_codaux "+;
			     "From dbo.CUENTAS_BANCO_CBA a "+;
			     "Inner join bancos_bco b "+;
			     "On (b.bco_codbco=a.bco_codbco) "+;
			     "Where a.cia_codcia=?ThisForm.Entorno.Codigocia "+;
			     "and   a.cba_codcba=?This.Value "+This.ayudawhere
			IF SQLEXEC(Ocnx.conexion,lcad,This.TablaValid)<0      
			   MESSAGEBOX("Error al validar Cuenta de Banco: "+CHR(13)+MESSAGE(),16,This.Name)
			   RETURN .f.
			ENDIF
			IF EOF()
			   MESSAGEBOX("La Cuenta de Banco "+NVL(This.Value,SPACE(6))+" NO EXISTE",64,"Cuenta Contable") 
			   IF This.Estricto
			      SELECT (lcurdir)
			      RETURN .f.
			   ELSE
			      This.Value=""    
			   ENDIF
			ENDIF
			IF !EOF()
			    IF LEN(ALLTRIM(This.Value))<>This.NumeroDigitos 
			       MESSAGEBOX("La Cta. tiene que tener "+STR(This.NumeroDigitos)+" Digitos",64,"Cuenta Contable")
				   IF This.Estricto
			    	  SELECT (lcurdir)
			      	  RETURN .f.
				   ELSE
			    	  This.Value=""    
				   ENDIF
			    ENDIF
			ENDIF
			This.DespuesValid()      
			SELECT (lcurdir)   
		ENDIF
	ENDPROC


	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cba_codcba
**************************************************


**************************************************
*-- Class:        cbo_debehaber (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  combo (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   06/17/03 05:50:11 PM
*
DEFINE CLASS cbo_debehaber AS combo


	Name = "cbo_debehaber"


	PROCEDURE Init
		DODEFAULT()
		PRIVATE ps_cursor
		ps_cursor = "T" + ALLTRIM(This.Name)
		CREATE CURSOR &ps_cursor (codigo c(1), nombre c(10))
		INSERT INTO &ps_cursor VALUES ('1', 'DEBE')
		INSERT INTO &ps_cursor VALUES ('2', 'HABER')
		This.BoundColumn   = 2
		This.RowSourceType = 6
		This.RowSource     = ps_cursor + ".nombre,codigo"
		this.ColumnCount   = 2
		this.ColumnWidths  = "70,20"
	ENDPROC


	PROCEDURE Destroy
		DODEFAULT()
		ps_cursor = "T"+ALLTRIM(This.Name)
		IF USED("&ps_cursor")
			USE IN "&ps_cursor"
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cbo_debehaber
**************************************************


**************************************************
*-- Class:        cbo_inventario (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  combo (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   02/15/05 06:08:14 PM
*
DEFINE CLASS cbo_inventario AS combo


	BoundColumn = 2
	*-- forma de visualizar la lista : 12 = <<  CODIGO  !  DESC.LARGA >>,    21 = <<  DESC.LARGA  !  CODIGO >>
	ps_s_visualiza_lista = ('21')
	*-- condición where sql para filtra el tipo de inventario
	sqlwhere = ""
	Name = "cbo_inventario"


	PROCEDURE Destroy
		DODEFAULT()
		ps_cursor = "T"+ALLTRIM(This.Name)
		IF USED("&ps_cursor")
			USE IN "&ps_cursor"
		ENDIF
	ENDPROC


	PROCEDURE Init
		DODEFAULT()
		PRIVATE ps_cadena, ps_cursor
		ps_cursor = "T"+ALLTRIM(This.Name)
		ps_cadena=           "Select tin_codtin, tin_deslar "
		ps_cadena=ps_cadena+ "From Dbo.tipo_inventario_tin "
		ps_cadena=ps_cadena+ "Where tin_indest='1' "
		IF !EMPTY(This.SqlWhere)
			ps_cadena=ps_cadena+ " and " + This.SqlWhere
		ENDIF
		IF SQLEXEC(ocnx.conexion, ps_cadena, ps_cursor)<1
			MESSAGEBOX("Error al abrir el archivo  [ TIPO_INVENTARIO_TIN ]"+CHR(13)+;
					   "Tipo de Inventario"+CHR(13)+MESSAGE(),16,"Tipo de Inventario")
			RETURN .F.
		ENDIF
		SELECT (ps_cursor)
		This.RowSourceType = 6
		This.ColumnCount   = 2
		DO CASE
			CASE ALLTRIM(This.ps_s_visualiza_lista)$"12"
				INDEX ON tin_codtin TAG I ADDI
				This.RowSource    = ps_cursor + ".tin_codtin,tin_deslar"
				This.BoundColumn  = 1
				This.ColumnWidths = "40,200"
			CASE ALLTRIM(This.ps_s_visualiza_lista)$"21"
				INDEX ON tin_deslar TAG I ADDI
				This.RowSource    = ps_cursor + ".tin_deslar,tin_codtin"
				This.BoundColumn  = 2
				This.ColumnWidths = "200,40"
			OTHERWISE
		ENDCASE
		This.Requery()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cbo_inventario
**************************************************


**************************************************
*-- Class:        cbo_unidad (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  combo (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   06/17/03 10:44:01 AM
*
DEFINE CLASS cbo_unidad AS combo


	Height = 23
	Width = 100
	*-- forma de visualizar la lista : 12 = <<  CODIGO  !  DESC.LARGA >>,    21 = <<  DESC.LARGA  !  CODIGO >>
	ps_s_visualiza_lista = ('21')
	Name = "cbo_unidad"


	PROCEDURE Destroy
		DODEFAULT()
		ps_cursor = "T"+ALLTRIM(This.Name)
		IF USED("&ps_cursor")
			USE IN "&ps_cursor"
		ENDIF


	ENDPROC


	PROCEDURE Init
		DODEFAULT()
		PRIVATE ps_cadena, ps_cursor
		ps_cursor = "T"+ALLTRIM(This.Name)
		ps_cadena=           "Select ume_deslar,ume_codume "
		ps_cadena=ps_cadena+ "From Dbo.unidad_medida_ume "
		ps_cadena=ps_cadena+ "Where ume_indest='1' "
		IF SQLEXEC(ocnx.conexion, ps_cadena, ps_cursor)<1
			MESSAGEBOX("Error al abrir el archivo  [ UNIDAD_MEDIDA_UME ]"+CHR(13)+;
					   "Unidades de medida"+CHR(13)+MESSAGE(),64,"Unidad Medida")
			RETURN .F.
		ENDIF
		This.RowSourceType = 6
		This.ColumnCount   = 2
		SELECT (ps_cursor)
		DO CASE
			CASE ALLTRIM(This.ps_s_visualiza_lista)$"12"
				INDEX ON ume_codume TAG I
				This.RowSource    = ps_cursor + ".ume_codume,ume_deslar"
				This.BoundColumn  = 1
				This.ColumnWidths = "40,200"
			CASE ALLTRIM(This.ps_s_visualiza_lista)$"21"
				INDEX ON ume_deslar TAG I
				This.RowSource    = ps_cursor + ".ume_deslar,ume_codume"
				This.BoundColumn  = 2
				This.ColumnWidths = "200,40"
			OTHERWISE
		ENDCASE
		This.Requery()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cbo_unidad
**************************************************


**************************************************
*-- Class:        ccl_codccl (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/07/05 11:50:04 AM
*
DEFINE CLASS ccl_codccl AS texto


	Height = 23
	MaxLength = 2
	Width = 29
	ayudaalias = "Tcategoria"
	ayudacampos = "ccl_codccl,ccl_nomlar"
	ayudavalor = "ccl_codccl"
	ayudanombretabla = "CATEGORIA_CLIE_CCL"
	Name = "ccl_codccl"


	PROCEDURE ayudapropiedades
		This.AyudaWhere = " cia_codcia='"+ThisForm.Entorno.CodigoCia+"' "
		This.AyudaIndice[1,1]="ccl_codccl"
		This.AyudaIndice[1,2]="Codigo"
		This.AyudaIndice[2,1]="ccl_nomlar"
		This.AyudaIndice[2,2]="Descrip"
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcad,lcondi,lcurdir

		lcurdir=SELECT()
		lcondi=IIF(This.DatoObligatorio," 1=1 "," !EMPTY(NVL(This.Value,'')) ")

		IF !This.AyudaActiva AND &lcondi AND !This.Indicadorllave 
		   lcad="Select ccl_codccl "+;
		        "From dbo.CATEGORIA_CLIE_CCL "+;
		        "Where cia_codcia='"+ThisForm.Entorno.Codigocia+"' "+;
		        "and   ccl_codccl='"+NVL(This.Value,"")+"' "
		        
		   IF Ocnx.Tipo_BD=1    
			   IF SQLEXEC(Ocnx.conexion,lcad,"Temval")<0
			      MESSAGEBOX("ERROR: "+MESSAGE(),64,"Categoria de Cliente")
			      RETURN .F.
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4    
			   IF Ocnx.Ms_Ejecuta_SQL(lcad,"Temval",ThisForm.DataSessionId)<0
			      MESSAGEBOX("ERROR: "+MESSAGE(),64,"Categoria de Cliente")
			      RETURN .F.
			   ENDIF
		   ENDIF
		   
		   IF EOF()
		      MESSAGEBOX("Categoria de Cliente NO EXISTE",64,"Categoria")
		      This.Value=""
		      RETURN .F.
		   ENDIF
		         
		ENDIF
		SELECT (lcurdir) 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ccl_codccl
**************************************************


**************************************************
*-- Class:        cco_codcco (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   06/25/03 05:26:01 PM
*
DEFINE CLASS cco_codcco AS texto


	Height = 22
	InputMask = "999999"
	MaxLength = 6
	Width = 58
	*-- nombre del cursor para validar
	tablavalid = "Tcentro"
	ayudaalias = "Tcentrocosto"
	ayudanombretabla = "CENTRO_COSTO_CCO"
	ayudacampos = "cco_codcco,cco_deslar"
	ayudawhere = "cia_codcia=?ThisForm.Entorno.CodigoCia and cco_indest='1'"
	ayudavalor = "cco_codcco"
	Name = "cco_codcco"

	*-- Si esta en .T. el dato es obligatorio
	estricto = .F.


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcad,lcondi
		lcondi=IIF(This.Estricto,"1=1","!Empty(NVL(This.Value,''))") 
		IF !This.AyudaActiva AND &lcondi
		   lcad="Select cco_codcco, cco_deslar "+;
		        "From dbo.centro_costo_cco "+;
		        "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		        "and   cco_codcco=?This.Value "
		   IF SQLEXEC(Ocnx.conexion,lcad,this.tablavalid)<0
		      MESSAGEBOX("Error: "+MESSAGE(),16,Oentorno.nombrecia)
		      RETURN 
		   ENDIF
		   IF EOF()
		      MESSAGEBOX("CENTRO DE COSTO NO EXISTE",64,"Centro Costo")
		      IF !This.Estricto
		         This.Value=SPACE(6)
		      EndIf
		      RETURN .F.
		   ENDIF
		   this.despuesvalid()
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaIndice[1,1]="cco_codcco"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="cco_deslar"
		This.AyudaIndice[2,2]="DESCRIPCION"
	ENDPROC


	*-- ejecuta despues de validar
	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cco_codcco
**************************************************


**************************************************
*-- Class:        cct_codcct (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/11/03 03:21:12 PM
*
DEFINE CLASS cct_codcct AS texto


	Format = "!R"
	InputMask = "999999"
	MaxLength = 6
	*-- Obliga a Ingresar la cta.contable
	estricto = .T.
	numerodigitos = 6
	*-- Se ingresa el Nombre de la Tabla que se creara en el Valid
	tablavalid = "Tcta"
	ayudaalias = ("Tcuenta_contable")
	ayudacampos = "cct_codcct, cct_nomcta,cct_tipcta as tipo,cct_indcte as ind_cte,tmo_codtmo as moneda, tcu_codtcu as control"
	ayudanombretabla = "cuenta_contable_cct"
	ayudawhere = "cia_codcia=?ThisForm.Entorno.Codigocia"
	ayudavalor = "cct_codcct"
	area_valid = (0)
	Name = "cct_codcct"

	*-- Si esta en .T. verifica que la longitud de la Cta. sea igual a la propiedad NumeroDigitos
	restringedigito = .F.


	PROCEDURE Valid
		DODEFAULT()

		IF !This.AyudaActiva 
			IF EMPTY(NVL(This.Value,'')) AND !This.Estricto
			   RETURN
			ENDIF

			PRIVATE lcurdir,lcad
			lcurdir=SELECT()
			lcad="Select * "+;
			     "From CUENTA_CONTABLE_CCT "+;
			     "Where cia_codcia=?ThisForm.Entorno.Codigocia "+;
			     "and   cct_codcct=?This.Value "
			IF SQLEXEC(Ocnx.conexion,lcad,This.TablaValid)<0      
			   MESSAGEBOX("Error: "+MESSAGE(),16,This.Name)
			   RETURN .f.
			ENDIF
			IF EOF()
			   MESSAGEBOX("La Cta. Contable "+NVL(This.Value,SPACE(6))+" NO EXISTE",64,"Cuenta Contable") 
			   IF This.Estricto
			      SELECT (lcurdir)
			      RETURN .f.
			   ELSE
			      This.Value=""    
			   ENDIF
			ENDIF
			IF !EOF()
			    IF LEN(ALLTRIM(This.Value))<>This.NumeroDigitos 
			       MESSAGEBOX("La Cta. tiene que tener "+STR(This.NumeroDigitos)+" Digitos",64,"Cuenta Contable")
				   IF This.Estricto
			    	  SELECT (lcurdir)
			      	  RETURN .f.
				   ELSE
			    	  This.Value=""    
				   ENDIF
			    ENDIF
			ENDIF
			This.Area_Valid=SELECT()
			This.DespuesValid()      
			SELECT (lcurdir)   
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaIndice[1,1]="cct_codcct"
		This.AyudaIndice[1,2]="CUENTA"
		This.AyudaIndice[2,1]="cct_nomcta"
		This.AyudaIndice[2,2]="DESCRIP"
	ENDPROC


	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cct_codcct
**************************************************


**************************************************
*-- Class:        cia_codcia (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/19/03 12:26:11 PM
*
DEFINE CLASS cia_codcia AS texto


	Height = 21
	InputMask = "99"
	Width = 27
	Name = "cia_codcia"


ENDDEFINE
*
*-- EndDefine: cia_codcia
**************************************************


**************************************************
*-- Class:        cierre (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  procesos (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   02/14/06 03:15:11 PM
*
DEFINE CLASS cierre AS procesos


	DoCreate = .T.
	Caption = "Cierre de Periodo"
	abrir_periodo = (.F.)
	tipo = "CIER"
	Name = "cierre"
	entorno.Name = "entorno"
	StatusBar.Top = 206
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 433
	StatusBar.Name = "StatusBar"
	cristal.Name = "cristal"
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Picture = "..\imag\secur02a.ico"
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 60
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 120
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Name = "botongrupo"


	ADD OBJECT comentario AS edicion WITH ;
		Height = 131, ;
		Left = 16, ;
		ReadOnly = .T., ;
		Top = 32, ;
		Width = 324, ;
		Name = "Comentario"


	ADD OBJECT cmb_accion AS combo WITH ;
		BoundColumn = 2, ;
		RowSourceType = 2, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 61, ;
		Top = 170, ;
		Width = 131, ;
		Name = "Cmb_Accion"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Acción", ;
		Left = 18, ;
		Top = 173, ;
		Name = "Etiqueta1"


	PROCEDURE cierre_periodo
		PRIVATE lcierr

		lcierr="Exec dbo.SP_SYS_CIERRE_PERIODO_MODULO "+;
			   "@p_codcia=?ThisForm.Entorno.CodigoCia,"+;
			   "@p_codsuc=?ThisForm.Entorno.CodigoSuc,"+;
			   "@p_modulo=?ThisForm.Entorno.Modulo,"+;
			   "@p_codano=?ThisForm.Entorno.Ano,"+;
			   "@p_codmes=?ThisForm.Entorno.Mes,"+;
		       "@p_action=?ThisForm.Cmb_Accion.Value"
		       
		IF SQLEXEC(Ocnx.Conexion,lcierr)<0
		   Ocnx.ErrorMensaje=MESSAGE()
		   RETURN .F.
		ENDIF
		       
	ENDPROC


	PROCEDURE Init
		DODEFAULT()

		IF Ocnx.Nivel<9
		   PRIVATE ls10
		   ls10="Select ISNULL(s12_indeje,0) as s12_indeje "+;
		   		"From dbo.SYS_OPCIONES_USUARIOS_S12 "+;
		   		"Where s07_codopc='"+ALLTRIM(ThisForm.Entorno.Programa)+"' "+;
		   		"and   UPPER(s10_usuario)=UPPER('"+ALLTRIM(Ocnx.usuario)+"') "
		   
		   IF Ocnx.Tipo_BD=1
			   IF SQLEXEC(Ocnx.Conexion,ls10,"Ts10")<0
			      MESSAGEBOX("Error: "+MESSAGE(),16,This.Caption)
			      RETURN
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4
		   	   IF Ocnx.Ms_Ejecuta_SQL(ls10,"Ts10",ThisForm.DataSessionId)<0
			      RETURN
			   ENDIF
		   ENDIF  
		   	   
		   IF !EOF("Ts10")
		   	  This.Abrir_periodo 	= 	IIF(NVL(Ts10.s12_indeje,0)=1,.T.,.F.)
		   ENDIF
		   
		   IF USED("Ts10")
		      USE IN "Ts10"
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		IF ThisForm.Cmb_Accion.Value =="C" 
			lmessa="Realizar el Cierre del Periodo"
		ELSE
			lmessa="Abrir el Periodo"
		ENDIF

		IF MESSAGEBOX("¿Seguro de "+lmessa+TRANSFORM(ThisForm.Entorno.Periodo,"@r 9999-99")+" del "+;
		              "Modulo: "+ThisForm.Entorno.Modulo+"?",4+32,"Cierre de Periodo")=6
		   Ocnx.Modo(2)
		   IF ThisForm.Antes_del_cierre() 
		   	   IF ThisForm.Cierre_Periodo() 
		   	   	  IF ThisForm.Despues_del_Cierre() 
		   	   	  	 Ocnx.Commit()
		   	   	  	 MESSAGEBOX("CIERRE DE PERIODO SE REALIZO CON EXITO")
		   	   	  	 Ocnx.Modo(1)
		   	   	  	 ThisForm.Cerrar()
		   	   	  ELSE
		   	   	  	Ocnx.RollBack()
		   	   	  	MESSAGEBOX(Ocnx.ErrorMensaje,16,"Cierre Periodo")
		   	   	  ENDIF
		   	   	  
		   	   ELSE
		   	   	  Ocnx.RollBack()
		 	   	  MESSAGEBOX(Ocnx.ErrorMensaje,16,"Cierre Periodo")
		   	   ENDIF
		   	    
		   ELSE
		   	  Ocnx.RollBack()
		   	  MESSAGEBOX(Ocnx.ErrorMensaje,16,"Cierre Periodo")
		   ENDIF
		   Ocnx.Modo(1)
		ENDIF
		              
	ENDPROC


	PROCEDURE antes_del_cierre
	ENDPROC


	PROCEDURE despues_del_cierre
	ENDPROC


	PROCEDURE comentario.Init
		DODEFAULT()
		This.Value=""+;
		"Al Ejecutar el Cierre del Periodo: "+TRANSFORM(ThisForm.Entorno.Periodo,"@r 9999-99")+" del Modulo: "+ThisForm.Entorno.Modulo+;
		" "+ThisForm.Entorno.nombreModulo+", posiblemente ya no pueda realizar transacciones "+;
		"que correspondan a dicho Periodo."
	ENDPROC


	PROCEDURE cmb_accion.Refresh
		DODEFAULT()
		IF Ocnx.Nivel=9 OR ThisForm.abrir_periodo 
		   This.Enabled=.T. 
		ENDIF
	ENDPROC


	PROCEDURE cmb_accion.Init
		DODEFAULT()
		CREATE CURSOR "TabreCierra" (descri c(20),codigo c(1))
		INSERT INTO "TabreCierra" VALUES ("CERRAR","C")
		INSERT INTO "TabreCierra" VALUES ("ABRIR","A")
		This.RowSource="TabreCierra"

		This.Requery() 
		This.Value="C"
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cierre
**************************************************


**************************************************
*-- Class:        ctn_ccl_codccl (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:52:12 PM
*
DEFINE CLASS ctn_ccl_codccl AS contenedor


	Width = 321
	Height = 25
	Name = "ctn_ccl_codccl"


	ADD OBJECT ccl_codccl AS ccl_codccl WITH ;
		Left = 51, ;
		Top = 0, ;
		Name = "Ccl_codccl"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Categoria", ;
		Left = 0, ;
		Top = 4, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 81, ;
		Top = 0, ;
		Width = 238, ;
		Name = "txt_descri"


	PROCEDURE ccl_codccl.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select ccl_nomlar "+;
		     "From dbo.CATEGORIA_CLIE_CCL "+;
		     "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		     "and   ccl_codccl=?This.Parent.ccl_codccl.Value "

		IF SQLEXEC(Ocnx.conexion,lcad,"Tdescri")<0
		   SELECT(lcurdir)
		   WAIT WINDOW MESSAGE() NOWAIT
		   RETURN
		ENDIF

		This.Value=Tdescri.ccl_nomlar
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_ccl_codccl
**************************************************


**************************************************
*-- Class:        ctn_cco_codcco (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   02/14/04 10:34:09 AM
*
DEFINE CLASS ctn_cco_codcco AS container


	Width = 408
	Height = 25
	BackStyle = 0
	BorderWidth = 0
	Name = "ctn_cco_codcco"


	ADD OBJECT cco_codcco AS cco_codcco WITH ;
		Height = 23, ;
		Left = 47, ;
		Top = 1, ;
		Width = 58, ;
		Name = "cco_codcco"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 107, ;
		Top = 1, ;
		Width = 289, ;
		Name = "txt_descri"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "C.Costo", ;
		Left = 5, ;
		Top = 3, ;
		Name = "Etiqueta1"


	PROCEDURE cco_codcco.Valid
		DODEFAULT()
		This.Parent.Txt_Descri.Refresh()
	ENDPROC


	PROCEDURE cco_codcco.Init
		*IF !EMPTY(This.Parent.DatoObjeto)
		*   This.DatoObjeto=This.Parent.DatoObjeto
		*ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcad,lecurdir
		lecurdir = SELECT()
		lcad="Select cco_deslar "+;
		     "From dbo.CENTRO_COSTO_CCO "+;
		     "Where cia_codcia=?thisform.entorno.codigocia "+;
		     "  and cco_codcco=?This.Parent.Cco_codcco.Value "
		IF SQLEXEC(Ocnx.conexion,lcad,"Tdescco")<0
		   SELECT (lecurdir)
		   WAIT WINDOW "ERROR: "+MESSAGE() NOWAIT
		   RETURN
		ENDIF
		This.Value=Tdescco.cco_deslar
		SELECT (lecurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_cco_codcco
**************************************************


**************************************************
*-- Class:        ctn_cia_codcia (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:53:11 PM
*
DEFINE CLASS ctn_cia_codcia AS contenedor


	Width = 307
	Height = 24
	Name = "ctn_cia_codcia"


	ADD OBJECT cia_codcia AS cia_codcia WITH ;
		Left = 1, ;
		Top = 2, ;
		Name = "Cia_codcia"


	ADD OBJECT descripcion_cia AS descripcion WITH ;
		Height = 20, ;
		Left = 33, ;
		Top = 3, ;
		Width = 237, ;
		Name = "Descripcion_cia"


	PROCEDURE cia_codcia.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_cia_codcia
**************************************************


**************************************************
*-- Class:        ctn_did_coddid (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:54:01 PM
*
DEFINE CLASS ctn_did_coddid AS contenedor


	Width = 221
	Height = 26
	Name = "ctn_did_coddid"


	ADD OBJECT did_coddid AS did_coddid WITH ;
		Height = 23, ;
		Left = 70, ;
		Top = 3, ;
		Width = 31, ;
		Name = "Did_coddid"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Doc.Identidad", ;
		Left = 0, ;
		Top = 3, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 103, ;
		Top = 3, ;
		Width = 82, ;
		Name = "txt_descri"


	PROCEDURE did_coddid.Valid
		DODEFAULT()
		This.Parent.Txt_Descri.Refresh()
	ENDPROC


	PROCEDURE did_coddid.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcad,lecurdir
		lecurdir = SELECT ()
		lcad="Select did_descor "+;
		     "From dbo.DOC_IDENTIDAD_DID "+;
		     "Where did_coddid=?This.Parent.Did_coddid.Value "
		IF SQLEXEC(Ocnx.conexion,lcad,"Tdesdid")<0
		   SELECT (lecurdir)
		   WAIT WINDOW "ERROR: "+MESSAGE() NOWAIT
		   RETURN
		ENDIF
		This.Value=Tdesdid.did_descor
		SELECT (lecurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_did_coddid
**************************************************


**************************************************
*-- Class:        ctn_pai_codpai (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:54:06 PM
*
DEFINE CLASS ctn_pai_codpai AS contenedor


	Name = "ctn_pai_codpai"


	ADD OBJECT pai_codpai AS pai_codpai WITH ;
		Left = 36, ;
		Top = 0, ;
		Name = "Pai_codpai"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Pais", ;
		Left = 4, ;
		Top = 1, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 65, ;
		Top = 0, ;
		Width = 240, ;
		Name = "txt_descri"


	PROCEDURE pai_codpai.Valid
		DODEFAULT()
		This.Parent.txt_descri.Refresh()
	ENDPROC


	PROCEDURE pai_codpai.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select pai_nomcor "+;
		     "From dbo.pais_pai "+;
		     "Where pai_codpai=?This.Parent.Pai_codpai.Value "

		IF SQLEXEC(Ocnx.conexion,lcad,"Tdespai")<0
		   SELECT(lcurdir)
		   WAIT WINDOW MESSAGE() NOWAIT
		   RETURN
		ENDIF

		This.Value=Tdespai.pai_nomcor
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_pai_codpai
**************************************************


**************************************************
*-- Class:        ctn_tcl_codtcl (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:54:12 PM
*
DEFINE CLASS ctn_tcl_codtcl AS contenedor


	Name = "ctn_tcl_codtcl"


	ADD OBJECT tcl_codtcl AS tcl_codtcl WITH ;
		Left = 61, ;
		Top = 0, ;
		Name = "Tcl_codtcl"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Tipo Cliente", ;
		Left = 0, ;
		Top = 3, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 88, ;
		Top = 0, ;
		Width = 229, ;
		Name = "txt_descri"


	PROCEDURE tcl_codtcl.Valid
		DODEFAULT()
		This.Parent.txt_descri.Refresh() 
	ENDPROC


	PROCEDURE tcl_codtcl.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select tcl_deslar "+;
		     "From dbo.TIPO_CLIE_TCL "+;
		     "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		     "and   tcl_codtcl=?This.Parent.Tcl_codtcl.Value "

		IF SQLEXEC(Ocnx.conexion,lcad,"Tdescri")<0
		   SELECT(lcurdir)
		   WAIT WINDOW MESSAGE() NOWAIT
		   RETURN
		ENDIF

		This.Value=Tdescri.tcl_deslar
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_tcl_codtcl
**************************************************


**************************************************
*-- Class:        ctn_tdo_codtdo (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   04/22/05 03:40:06 PM
*
DEFINE CLASS ctn_tdo_codtdo AS contenedor


	Width = 299
	Height = 23
	Name = "ctn_tdo_codtdo"


	ADD OBJECT tdo_codtdo AS tdo_codtdo WITH ;
		Height = 23, ;
		Left = 60, ;
		Top = 0, ;
		Width = 32, ;
		Name = "Tdo_codtdo"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Tipo Doc.", ;
		Left = 0, ;
		Top = 4, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 95, ;
		Top = 0, ;
		Width = 200, ;
		Name = "txt_descri"


	PROCEDURE tdo_codtdo.Valid
		DODEFAULT()
		This.Parent.txt_descri.Refresh()  
	ENDPROC


	PROCEDURE tdo_codtdo.Init
		IF !EMPTY(This.Parent.DatoObjeto) 
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF

		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select tdo_descor "+;
		     "From dbo.TIPO_DE_DOCUMENTO_TDO "+;
		     "Where tdo_codtdo='"+NVL(This.Parent.Tdo_codtdo.Value,"")+"' "

		IF ocnx.Tipo_BD=1
			IF SQLEXEC(Ocnx.conexion,lcad,"Tdescri")<0
			   SELECT(lcurdir)
			   WAIT WINDOW MESSAGE() NOWAIT
			   RETURN
			ENDIF
		ENDIF

		IF ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(lcad,"Tdescri",ThisForm.DataSessionId)<0
			   SELECT(lcurdir)
			   WAIT WINDOW MESSAGE() NOWAIT
			   RETURN
			ENDIF
		ENDIF

		This.Value=Tdescri.tdo_descor
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_tdo_codtdo
**************************************************


**************************************************
*-- Class:        ctn_ubi_codubi (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:55:02 PM
*
DEFINE CLASS ctn_ubi_codubi AS contenedor


	Width = 471
	Height = 26
	Name = "ctn_ubi_codubi"


	ADD OBJECT ubi_codubi AS ubi_codubi WITH ;
		Left = 57, ;
		Top = 0, ;
		Name = "Ubi_codubi"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Ubicación", ;
		Left = 0, ;
		Top = 0, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 111, ;
		Top = 0, ;
		Width = 345, ;
		Name = "txt_descri"


	PROCEDURE ubi_codubi.Valid
		DODEFAULT()
		This.Parent.txt_descri.Refresh() 
	ENDPROC


	PROCEDURE ubi_codubi.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select ubi_desubi "+;
		     "From dbo.V_UBICACIONES_UBI "+;
		     "Where pai_codpai=?This.Parent.Ubi_codubi.Pai_codpai "+;
		     "and   ubi_codubi=?This.Parent.Ubi_codubi.Value "

		IF SQLEXEC(Ocnx.conexion,lcad,"Tdesubi")<0
		   SELECT(lcurdir)
		   WAIT WINDOW MESSAGE() NOWAIT
		   RETURN
		ENDIF

		This.Value=Tdesubi.ubi_desubi
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_ubi_codubi
**************************************************


**************************************************
*-- Class:        ctn_vde_codvde (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/27/03 05:55:06 PM
*
DEFINE CLASS ctn_vde_codvde AS contenedor


	Width = 328
	Height = 25
	Name = "ctn_vde_codvde"


	ADD OBJECT vde_codvde AS vde_codvde WITH ;
		Left = 51, ;
		Top = 0, ;
		Name = "Vde_codvde"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Vendedor", ;
		Left = 2, ;
		Top = 4, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 91, ;
		Top = 0, ;
		Width = 232, ;
		Name = "txt_descri"


	PROCEDURE vde_codvde.Valid
		DODEFAULT()
		This.Parent.txt_descri.Refresh() 
	ENDPROC


	PROCEDURE vde_codvde.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select VDE_NOMVDE "+;
		     "From dbo.VENDEDOR_VDE "+;
		     "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		     "and   VDE_CODVDE=?This.Parent.vde_codvde.Value "

		IF SQLEXEC(Ocnx.conexion,lcad,"Tdescri")<0
		   SELECT(lcurdir)
		   WAIT WINDOW MESSAGE() NOWAIT
		   RETURN
		ENDIF

		This.Value=Tdescri.VDE_NOMVDE
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_vde_codvde
**************************************************


**************************************************
*-- Class:        ctn_zve_codzve (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   07/02/03 06:18:08 PM
*
DEFINE CLASS ctn_zve_codzve AS contenedor


	Name = "ctn_zve_codzve"


	ADD OBJECT zve_codzve AS zve_codzve WITH ;
		InputMask = "9999", ;
		Left = 49, ;
		Top = 0, ;
		Name = "Zve_codzve"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Zona Vta.", ;
		Left = 0, ;
		Top = 3, ;
		Name = "Etiqueta1"


	ADD OBJECT txt_descri AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 88, ;
		Top = 0, ;
		Width = 232, ;
		Name = "txt_descri"


	PROCEDURE zve_codzve.Init
		IF !EMPTY(This.Parent.DatoObjeto)
		   This.DatoObjeto=This.Parent.DatoObjeto
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE zve_codzve.Valid
		DODEFAULT()
		This.Parent.txt_descri.Refresh() 
	ENDPROC


	PROCEDURE txt_descri.Refresh
		PRIVATE lcurdir,lcad

		lcurdir=SELECT()
		lcad="Select zve_nomzve "+;
		     "From dbo.ZONA_VENTA_ZVE "+;
		     "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		     "and   zve_codzve=?This.Parent.zve_codzve.Value "

		IF SQLEXEC(Ocnx.conexion,lcad,"Tdescri")<0
		   SELECT(lcurdir)
		   WAIT WINDOW MESSAGE() NOWAIT
		   RETURN
		ENDIF

		This.Value=Tdescri.zve_nomzve
		     
		SELECT(lcurdir)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ctn_zve_codzve
**************************************************


**************************************************
*-- Class:        descripcion (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/28/03 10:44:04 AM
*
DEFINE CLASS descripcion AS texto


	BackStyle = 0
	Enabled = .F.
	DisabledForeColor = RGB(0,0,160)
	Name = "descripcion"


ENDDEFINE
*
*-- EndDefine: descripcion
**************************************************


**************************************************
*-- Class:        did_coddid (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/29/05 05:05:09 PM
*
DEFINE CLASS did_coddid AS texto


	Height = 23
	InputMask = "999"
	MaxLength = 3
	Width = 25
	ayudanombretabla = "DOC_IDENTIDAD_DID"
	ayudaalias = "TIDENTIDAD_DID"
	ayudacampos = "did_coddid,did_deslar,did_descor"
	ayudavalor = "did_coddid"
	Name = "did_coddid"


	PROCEDURE ayudapropiedades
		This.AyudaIndice[1,1]="DID_CODDID"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="DID_DESLAR"
		This.AyudaIndice[2,2]="DESCRIPCION"
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcon,lcad,lcurdir
		IF !This.AyudaActiva 
		   lcon=IIF(This.DatoObligatorio,"1=1","!Empty(NVL(This.Value,''))")
		   IF &lcon
		      
		      lcad="Select did_coddid "+;
		           "From dbo.DOC_IDENTIDAD_DID "+;
		           "Where did_coddid='"+NVL(This.Value,"")+"' "
		      
		      lcurdir=SELECT()
		      IF Ocnx.Tipo_BD=1
			      IF SQLEXEC(Ocnx.Conexion,lcad,"Tdid")<0
			         MESSAGEBOX("Error: "+MESSAGE(),16,"Documento Identidad")
			         RETURN 
			      ENDIF
		      ENDIF
		      
		      IF Ocnx.Tipo_BD=4
			      IF Ocnx.Ms_Ejecuta_SQL(lcad,"Tdid",ThisForm.DataSessionId)<0
			         MESSAGEBOX("Error: "+MESSAGE(),16,"Documento Identidad")
			         RETURN 
			      ENDIF
		      ENDIF
		      
		      IF EOF()
		         MESSAGEBOX("DOCUMENTO DE INDENTIDAD NO EXISTE",64,"Documento Identidad")
		         SELECT (lcurdir) 
		         This.Value=SPACE(3)
		         This.Refresh()
		         RETURN .f.
		      ENDIF      
		      SELECT (lcurdir)
		   ENDIF
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: did_coddid
**************************************************


**************************************************
*-- Class:        et_cantidad (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:24:11 AM
*
DEFINE CLASS et_cantidad AS etiqueta


	Caption = "Cantidad"
	Name = "et_cantidad"


ENDDEFINE
*
*-- EndDefine: et_cantidad
**************************************************


**************************************************
*-- Class:        et_codigo (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:20:01 AM
*
DEFINE CLASS et_codigo AS etiqueta


	Caption = "Código"
	Name = "et_codigo"


ENDDEFINE
*
*-- EndDefine: et_codigo
**************************************************


**************************************************
*-- Class:        et_descripcion (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:21:00 AM
*
DEFINE CLASS et_descripcion AS etiqueta


	AutoSize = .T.
	Caption = "Descripción"
	Name = "et_descripcion"


ENDDEFINE
*
*-- EndDefine: et_descripcion
**************************************************


**************************************************
*-- Class:        et_estado (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:22:00 AM
*
DEFINE CLASS et_estado AS etiqueta


	Caption = "Estado"
	Name = "et_estado"


ENDDEFINE
*
*-- EndDefine: et_estado
**************************************************


**************************************************
*-- Class:        et_nombre (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:23:12 AM
*
DEFINE CLASS et_nombre AS etiqueta


	Caption = "Nombre"
	Name = "et_nombre"


ENDDEFINE
*
*-- EndDefine: et_nombre
**************************************************


**************************************************
*-- Class:        et_ruc (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:21:08 AM
*
DEFINE CLASS et_ruc AS etiqueta


	Caption = "R.U.C."
	Name = "et_ruc"


ENDDEFINE
*
*-- EndDefine: et_ruc
**************************************************


**************************************************
*-- Class:        et_siglas (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/20/03 11:25:02 AM
*
DEFINE CLASS et_siglas AS etiqueta


	Caption = "Siglas"
	Name = "et_siglas"


ENDDEFINE
*
*-- EndDefine: et_siglas
**************************************************


**************************************************
*-- Class:        fca_codfca (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   01/07/05 12:52:09 PM
*
DEFINE CLASS fca_codfca AS texto


	Height = 22
	InputMask = "XXXXXX"
	Width = 50
	numerodigitos = 4
	tablavalid = "TFca"
	ayudaalias = "TFlujoCaja"
	ayudavalor = "codigo"
	Name = "fca_codfca"
	estricto = .F.
	restringedigito = .F.


	PROCEDURE Valid
		DODEFAULT()

		IF !This.AyudaActiva 
			IF EMPTY(NVL(This.Value,'')) AND !This.Estricto
			   RETURN
			ENDIF

			PRIVATE lcurdir,lcad
			lcurdir=SELECT()
			lcad="Select a.* "+;
			     "From dbo.Flujo_Caja_Fca a "+;
				 "Where a.cia_codcia=?ThisForm.Entorno.Codigocia "+;
		         " and a.fca_codfca=?This.Value "
			IF SQLEXEC(Ocnx.conexion,lcad,This.TablaValid)<0      
			   MESSAGEBOX("Error al validar Flujo de Caja: "+CHR(13)+MESSAGE(),16,This.Name)
			   SELECT (lcurdir)
			   RETURN .f.
			ENDIF
			IF EOF()
			   MESSAGEBOX("El Código de Flujo de Caja "+NVL(This.Value,SPACE(6))+" NO EXISTE O NO ES VALIDO",64,"Flujo de Caja") 
			   IF This.Estricto
			      SELECT (lcurdir)
			      RETURN .f.
			   ELSE
			      This.Value=""    
			   ENDIF
			ENDIF
			IF !EOF()
			    IF LEN(ALLTRIM(This.Value))<>This.NumeroDigitos AND This.restringedigito
			       MESSAGEBOX("El Código de Flujo de Caja tiene que tener "+STR(This.NumeroDigitos)+" Digitos",64,"Flujo de Caja")
				   IF This.Estricto
			    	  SELECT (lcurdir)
			      	  RETURN .f.
				   ELSE
			    	  This.Value=""    
				   ENDIF
			    ENDIF
			ENDIF
			IF !This.DespuesValid()      
				RETURN .f.
			ENDIF 
			SELECT (lcurdir)   
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaSqlselect = "Select a.fca_codfca as CODIGO,"+;
				 			  "a.fca_Deslar as DESCRI,"+;
				 			  "(case when a.fca_tipflu='1' then 'INGRESO' else 'EGRESO' END) as TIP_FLU,"+; 
						 	  "a.fca_indfca as IND_FLU "+; 
							  "From dbo.Flujo_Caja_Fca a "+;
						      "Where a.cia_codcia=?ThisForm.Entorno.Codigocia "+;
		         		      " and a.fca_indest='1' "+This.AyudaWhere

		This.AyudaIndice[1,1]="codigo"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="descri"
		This.AyudaIndice[2,2]="DESCRI"
	ENDPROC


	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: fca_codfca
**************************************************


**************************************************
*-- Class:        fca_codfca2 (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   06/23/21 09:14:10 PM
*
DEFINE CLASS fca_codfca2 AS texto


	Height = 22
	InputMask = "XXXXXX"
	Width = 50
	numerodigitos = 4
	tablavalid = "TFca"
	ayudaalias = "TFlujoCaja"
	ayudavalor = "codigo"
	Name = "fca_codfca"
	estricto = .F.
	restringedigito = .F.


	PROCEDURE ayudapropiedades
		This.AyudaSqlselect = "Select a.fca_codfca as CODIGO,"+;
				 			  "a.fca_Deslar as DESCRI,"+;
				 			  "(case when a.fca_tipflu='1' then 'INGRESO' else 'EGRESO' END) as TIP_FLU,"+; 
						 	  "a.fca_indfca as IND_FLU "+; 
							  "From dbo.Flujo_Caja_Fca a "+;
						      "Where a.cia_codcia=?ThisForm.Entorno.Codigocia "+;
		         		      " and a.fca_indest='1' "+This.AyudaWhere

		This.AyudaIndice[1,1]="codigo"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="descri"
		This.AyudaIndice[2,2]="DESCRI"
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()

		IF !This.AyudaActiva 
			IF EMPTY(NVL(This.Value,'')) AND !This.Estricto
			   RETURN
			ENDIF

			PRIVATE lcurdir,lcad
			lcurdir=SELECT()
			lcad="Select a.* "+;
			     "From dbo.Flujo_Caja_Fca a "+;
				 "Where a.cia_codcia=?ThisForm.Entorno.Codigocia "+;
		         " and a.fca_codfca=?This.Value "
			IF SQLEXEC(Ocnx.conexion,lcad,This.TablaValid)<0      
			   MESSAGEBOX("Error al validar Flujo de Caja: "+CHR(13)+MESSAGE(),16,This.Name)
			   SELECT (lcurdir)
			   RETURN .f.
			ENDIF
			IF EOF()
			   MESSAGEBOX("El Código de Flujo de Caja "+NVL(This.Value,SPACE(6))+" NO EXISTE O NO ES VALIDO",64,"Flujo de Caja") 
			   IF This.Estricto
			      SELECT (lcurdir)
			      RETURN .f.
			   ELSE
			      This.Value=""    
			   ENDIF
			ENDIF
			IF !EOF()
			    IF LEN(ALLTRIM(This.Value))<>This.NumeroDigitos AND This.restringedigito
			       MESSAGEBOX("El Código de Flujo de Caja tiene que tener "+STR(This.NumeroDigitos)+" Digitos",64,"Flujo de Caja")
				   IF This.Estricto
			    	  SELECT (lcurdir)
			      	  RETURN .f.
				   ELSE
			    	  This.Value=""    
				   ENDIF
			    ENDIF
			ENDIF
			IF !This.DespuesValid()      
				RETURN .f.
			ENDIF 
			SELECT (lcurdir)   
		ENDIF
	ENDPROC


	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: fca_codfca2
**************************************************


**************************************************
*-- Class:        indicador_auxiliares (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    container
*-- Time Stamp:   04/11/05 09:50:09 AM
*
DEFINE CLASS indicador_auxiliares AS contenedor


	*-- Si alguno tiene Check el valor sera Mayor que Cero
	graba_auxiliar = 0
	Name = "indicador_auxiliares"


	ADD OBJECT aux_indcli AS check WITH ;
		Top = 8, ;
		Left = 8, ;
		Caption = "Cliente", ;
		Name = "aux_indcli"


	ADD OBJECT aux_indpro AS check WITH ;
		Top = 8, ;
		Left = 68, ;
		Caption = "Proveedor", ;
		Name = "aux_indpro"


	ADD OBJECT aux_indemp AS check WITH ;
		Top = 8, ;
		Left = 140, ;
		Caption = "Trabajador", ;
		Name = "aux_indemp"


	ADD OBJECT aux_indgas AS check WITH ;
		Top = 8, ;
		Left = 212, ;
		Caption = "Gasto", ;
		Name = "aux_indgas"


	ADD OBJECT aux_indotr AS check WITH ;
		Top = 8, ;
		Left = 272, ;
		Caption = "Otro", ;
		Name = "aux_indotr"


	PROCEDURE verifica_auxiliar
		PRIVATE lverif

		lverif=.F.

		This.Aux_indcli.Refresh()
		IF NVL(This.Aux_indcli.Value,0)=1
		   lverif=.T.
		ENDIF
		This.Aux_indpro.Refresh()
		IF NVL(This.Aux_indpro.Value,0)=1
		   lverif=.T.
		ENDIF
		This.Aux_indemp.Refresh()
		IF NVL(This.Aux_indemp.Value,0)=1
		   lverif=.T.
		ENDIF
		This.Aux_indgas.Refresh()
		IF NVL(This.Aux_indgas.Value,0)=1
		   lverif=.T.
		ENDIF
		This.Aux_indotr.Refresh()
		IF NVL(This.Aux_indotr.Value,0)=1
		   lverif=.T.
		EndIf

		RETURN lverif
	ENDPROC


	*-- Se envia 2 parametros para actualizar el Valor segun el Orden de los Datos
	PROCEDURE actualizavalor
		LPARAMETERS lobj,lhabil

		PRIVATE lsen,lcam

		IF PARAMETERS()=2
		   IF TYPE("lobj")=="N" AND TYPE("lobj")=="L"
		      lcam=""
		   	  DO CASE
		   	     CASE lobj=1
		   	     	  lcam="aux_indcli" 
		   	     CASE lobj=2
		   	     	  lcam="aux_indpro" 
		   	     CASE lobj=3
		   	     	  lcam="aux_indemp" 
		   	     CASE lobj=4
		   	     	  lcam="aux_indgas"
		   	     CASE lobj=5
		   	     	  lcam="aux_indotr"
		   	  ENDCASE
		   	  IF !EMPTY(lcam)
			   	  lsen="This."+lcam+".Enabled=lhabil"
			   	  &lsen
		   	  ENDIF
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE Init
		PRIVATE ln
		IF Ocnx.Nivel<9
		   FOR ln=1 TO 5
			   IF TYPE("Oentorno.Parametros["+ALLTRIM(STR(ln))+",1]")=="N"
			      This.ActualizaValor(ln,Oentorno.Parametros[1,2])  
			   ENDIF
		   ENDFOR
		ENDIF
	ENDPROC


	PROCEDURE aux_indcli.Click
		DODEFAULT()
		This.Parent.Refresh()
	ENDPROC


	PROCEDURE aux_indpro.Click
		DODEFAULT()
		This.Parent.Refresh()
	ENDPROC


	PROCEDURE aux_indemp.Click
		DODEFAULT()
		This.Parent.Refresh()
	ENDPROC


	PROCEDURE aux_indgas.Click
		DODEFAULT()
		This.Parent.Refresh()
	ENDPROC


	PROCEDURE aux_indotr.Click
		DODEFAULT()
		This.Parent.Refresh()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: indicador_auxiliares
**************************************************


**************************************************
*-- Class:        indicadorestado (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  combo (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   07/23/03 06:41:11 PM
*
DEFINE CLASS indicadorestado AS combo


	BoundColumn = 2
	RowSourceType = 2
	DisabledBackColor = RGB(255,255,255)
	DisabledForeColor = RGB(0,0,160)
	utilizanombre = .T.
	Name = "indicadorestado"


	PROCEDURE Init
		DODEFAULT()
		Wcrea="Create Cursor T"+ALLTRIM(This.Name)+" (descri c(20),codigo c(1))"
		&Wcrea

		Wins="INSERT INTO T"+ALLTRIM(This.Name)+" Values ('VIGENTE','1')"
		&Wins
		Wins="INSERT INTO T"+ALLTRIM(This.Name)+" Values ('CANCELADO','0')"
		&Wins
		This.RowSourceType	= 2 
		This.RowSource		= "T"+ALLTRIM(This.Name)
		This.Requery()
		This.Refresh()
	ENDPROC


	PROCEDURE Refresh
		DODEFAULT()
		This.DisabledForeColor=IIF(This.Value='1',RGB(0,0,160),RGB(255,0,0))
	ENDPROC


ENDDEFINE
*
*-- EndDefine: indicadorestado
**************************************************


**************************************************
*-- Class:        pai_codpai (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/06/05 05:35:14 PM
*
DEFINE CLASS pai_codpai AS texto


	Height = 23
	Width = 27
	areavalid = 0
	ayudanombretabla = "pais_pai"
	ayudacampos = "pai_codpai,pai_nomcor"
	ayudavalor = "pai_codpai"
	ayudaalias = "Tpais"
	Name = "pai_codpai"


	PROCEDURE ayudapropiedades
		This.AyudaIndice[1,1]="pai_codpai"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="pai_nomcor"
		This.AyudaIndice[2,2]="NOMBRE"
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcad,lcondi,lcurdir

		lcurdir=SELECT()
		lcondi=IIF(This.DatoObligatorio," 1=1 "," !EMPTY(This.Value) ")

		IF !This.AyudaActiva AND &lcondi
		   lcad="Select * "+;
		        "From dbo.pais_pai "+;
		        "Where pai_codpai='"+NVL(This.Value,"")+"' "
		   IF Ocnx.Tipo_BD=1     
			   IF SQLEXEC(Ocnx.conexion,lcad,"Tvalpais")<0
			      MESSAGEBOX("ERROR: "+MESSAGE(),64,"PAIS")
			      RETURN .F.
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4     
			   IF Ocnx.Ms_Ejecuta_SQL(lcad,"Tvalpais",ThisForm.DataSessionId)<0
			      MESSAGEBOX("ERROR: "+MESSAGE(),64,"PAIS")
			      RETURN .F.
			   ENDIF
		   ENDIF
		   
		   This.AreaValid=SELECT() 
		   IF EOF()
		      MESSAGEBOX("CODIGO DE PAIS NO EXISTE",64,"PAIS")
		      This.Value=""
		      This.AreaValid=0
		      RETURN .F.
		   ENDIF
		   This.Valid_Campos() 
		   IF USED("Tvalpais")     
		      USE IN "Tvalpais"
		   ENDIF
		   This.AreaValid=0
		ENDIF
		SELECT (lcurdir) 
	ENDPROC


	*-- Este metodo se ejecuta si es que se a encontrado el dato que se requiere y lo devuelve en un cursor que esta en el area AreaValid
	PROCEDURE valid_campos
	ENDPROC


ENDDEFINE
*
*-- EndDefine: pai_codpai
**************************************************


**************************************************
*-- Class:        ruc (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/19/03 12:47:02 PM
*
DEFINE CLASS ruc AS texto


	InputMask = "99999999999"
	MaxLength = 11
	utilizanombre = .T.
	Name = "ruc"


ENDDEFINE
*
*-- EndDefine: ruc
**************************************************


**************************************************
*-- Class:        s10_usuario (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  combo (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   12/12/03 10:41:05 AM
*
DEFINE CLASS s10_usuario AS combo


	ColumnWidths = "200"
	Width = 250
	alias = ("")
	Name = "s10_usuario"


	PROCEDURE Init
		PRIVATE lcurdir,lcad
		This.Alias=SYS(2015) 
		lcurdir=SELECT()
		lcad="Select (Case s10_indest When '1' then s10_nomusu else 'ZZ C A N C E L A D O '+s10_nomusu end ) as s10_nomsus,"+;
			 "s10_usuario "+;
		     "From dbo.SYS_TABLA_USUARIOS_S10 "+;
		     "Order by 1"
		IF SQLEXEC(Ocnx.Conexion,lcad,This.Alias)<0
		   MESSAGEBOX("Error al Cargar Combo de Usuarios: "+CHR(13)+MESSAGE(),16,"Usuarios")
		   RETURN .f.
		ENDIF
		This.BoundColumn=2
		This.RowSourceType= 2
		This.RowSource=This.Alias
		This.Requery()
		SELECT (lcurdir)
		DODEFAULT()
		This.Refresh()
	ENDPROC


	PROCEDURE Destroy
		PRIVATE luse
		DODEFAULT()
		IF USED(This.Alias)
		   luse="Use in '"+This.Alias+"'"
		   &luse
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: s10_usuario
**************************************************


**************************************************
*-- Class:        tcl_codtcl (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/07/05 12:26:09 PM
*
DEFINE CLASS tcl_codtcl AS texto


	Height = 23
	InputMask = "99"
	MaxLength = 2
	Width = 26
	ayudanombretabla = "TIPO_CLIE_TCL"
	ayudaalias = "TipoCliente"
	ayudacampos = "tcl_codtcl,tcl_deslar"
	ayudavalor = "tcl_codtcl"
	Name = "tcl_codtcl"
	cia_codcia = .F.


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcon,lcurdir,lcad
		lcon=IIF(This.DatoObligatorio,"1=1","!EMPTY(NVL(This.Value,''))") 
		IF !This.AyudaActiva AND &lcon AND !This.Indicadorllave 
		   lcurdir=SELECT()
		   lcad="Select tcl_codtcl "+;
		        "From dbo.TIPO_CLIE_TCL "+;
		        "Where cia_codcia='"+ThisForm.Entorno.CodigoCia+"' "+;
		        "and   tcl_codtcl='"+NVL(This.Value,"")+"' "
		   IF Ocnx.Tipo_BD=1    
			   IF SQLEXEC(Ocnx.conexion,lcad,"Ttipcli")<0
			      SELECT (lcurdir)
			      MESSAGEBOX("Error: "+MESSAGE(),16,"Tipo de Cliente")
			      RETURN 
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4    
			   IF Ocnx.Ms_Ejecuta_SQL(lcad,"Ttipcli",ThisForm.DataSessionId)<0
			      SELECT (lcurdir)
			      MESSAGEBOX("Error: "+MESSAGE(),16,"Tipo de Cliente")
			      RETURN 
			   ENDIF
		   ENDIF
		   
		   IF EOF()
		      MESSAGEBOX("Codigo de Tipo de Cliente NO EXISTE",16,"Tipo de Cliente")
		      SELECT (lcurdir)
		      RETURN .F.
		   ENDIF
		   SELECT (lcurdir)
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaWhere = " cia_codcia='"+ThisForm.Entorno.CodigoCia+"' "
		This.AyudaIndice[1,1]="tcl_codtcl"
		This.AyudaIndice[1,2]="Codigo"
		This.AyudaIndice[2,1]="tcl_deslar"
		This.AyudaIndice[2,2]="Descrip"
	ENDPROC


ENDDEFINE
*
*-- EndDefine: tcl_codtcl
**************************************************


**************************************************
*-- Class:        tdo_codtdo (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/11/05 06:05:13 PM
*
DEFINE CLASS tdo_codtdo AS texto


	Height = 22
	InputMask = "XXX"
	Width = 32
	numerodigitos = 3
	tablavalid = "Ttdo"
	*-- En esta propiedad Ingrese separado por comas (,) los documentos que solo quiere que aparescan: Ejem: FAC,BVE
	tipo_docus = ("")
	ayudaalias = "TTipdoc"
	ayudacampos = "tdo_codtdo as codigo,tdo_deslar as descri,tdo_codofi as cod_ofi,tdo_descor as des_cor,tdo_indest as estado"
	ayudanombretabla = "Tipo_de_documento_tdo"
	ayudavalor = "codigo"
	ayudawhere = "tdo_indest='1'"
	Name = "tdo_codtdo"
	estricto = .F.
	restringedigito = .F.


	PROCEDURE Valid
		DODEFAULT()

		IF !This.AyudaActiva 
			IF EMPTY(NVL(This.Value,'')) AND !This.Estricto
			   RETURN
			ENDIF

			PRIVATE lcurdir,lcad
			lcurdir=SELECT()
			lcad="Select TDO_CODTDO,TDO_DESLAR,TDO_DESCOR,TDO_CODOFI,"+;
				 "		TDO_INDSIG,TDO_INDRET,TDO_CTACTE "+;
				 "From tipo_de_documento_tdo "+;
			     "Where tdo_codtdo='"+NVL(This.Value,"")+"' "
			IF Ocnx.Tipo_BD=1     
				IF SQLEXEC(Ocnx.conexion,lcad,This.TablaValid)<0      
				   MESSAGEBOX("Error al validar Tipo de Documento: "+CHR(13)+MESSAGE(),16,This.Name)
				   RETURN .f.
				ENDIF
			ENDIF
			IF Ocnx.Tipo_BD=4     
				IF Ocnx.Ms_Ejecuta_SQL(lcad,This.TablaValid,ThisForm.DataSessionId)<0      
				   MESSAGEBOX("Error al validar Tipo de Documento: "+CHR(13)+MESSAGE(),16,This.Name)
				   RETURN .f.
				ENDIF
			ENDIF

			IF EOF()
			   MESSAGEBOX("El Tipo de Documento "+NVL(This.Value,SPACE(6))+" NO EXISTE O NO ES VALIDO",64,"Tipo de Documento") 
			   IF This.Estricto
			      SELECT (lcurdir)
			      RETURN .f.
			   ELSE
			      This.Value=""    
			   ENDIF
			ENDIF
			IF !EOF()
			    IF LEN(ALLTRIM(This.Value))<>This.NumeroDigitos AND This.restringedigito
			       MESSAGEBOX("El Tipo de Documento tiene que tener "+STR(This.NumeroDigitos)+" Digitos",64,"Tipo de Documento")
				   IF This.Estricto
			    	  SELECT (lcurdir)
			      	  RETURN .f.
				   ELSE
			    	  This.Value=""    
				   ENDIF
			    ENDIF
			ENDIF
			This.DespuesValid()      
			SELECT (lcurdir)   
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaIndice[1,1]="codigo"
		This.AyudaIndice[1,2]="CUENTA"
		This.AyudaIndice[2,1]="descri"
		This.AyudaIndice[2,2]="DESCRI"
	ENDPROC


	PROCEDURE ayuda
		IF !EMPTY(This.Tipo_Docus)
		      This.Tipo_Docus=ALLTRIM(This.Tipo_Docus) 
		      lwhere=""
		      lini=1
		   	  lpos=0
		   	  If ","$This.Tipo_Docus
			      FOR ln=1 TO 30
		    		  lpos=ATC(",",This.Tipo_Docus,ln)
		    	  	  IF lpos>0 
		    	  	     lfin=(lpos) - lini
					     lwhere=lwhere+"'"+SUBSTR(This.Tipo_Docus,lini,lfin)+"',"
				    	 lini=lpos + 1
		    		  ELSE
		    		     lwhere=lwhere+"'"+SUBSTR(This.Tipo_Docus,lini,LEN(ALLTRIM(This.Tipo_Docus)))+"',"
		    		     Exit
			      	  EndIf
				  ENDFOR
		   	  ELSE
		   	     lwhere=lwhere+"'"+Allt(This.Tipo_Docus)+"',"
		   	  ENDIF
		   	  IF !EMPTY(lwhere)
		   	     lwhere=LEFT(lwhere,LEN(lwhere)-1)
		   	     lwhere=" AND TDO_CODTDO IN ("+lwhere+")"
		   	     This.AyudaWhere=This.AyudaWhere+lwhere   
		   	  ENDIF
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE despuesvalid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: tdo_codtdo
**************************************************


**************************************************
*-- Class:        tmo_codtmo (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  combo (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   04/11/05 03:21:04 PM
*
DEFINE CLASS tmo_codtmo AS combo


	Height = 24
	Width = 133
	*-- Si es 1 Muestra la Descripción Larga, 2 Muestra Descripción Corta , 3 Muestra el Simbolo
	dato_mostrar = 1
	Name = "tmo_codtmo"


	PROCEDURE Init
		DODEFAULT()
		PRIVATE lcarea,lcad,lorden
		lcarea=SELECT()
		DO Case
		   CASE This.Dato_mostrar=1
		        lorden="tmo_deslar,tmo_codtmo"
		   CASE This.Dato_mostrar=2
		        lorden="tmo_descor,tmo_codtmo"
		   CASE This.Dato_mostrar=3 
		        lorden="tmo_codrep,tmo_codtmo"
		EndCase
		lcad="Select "+lorden+;
		     " From dbo.TIPO_DE_MONEDA_TMO "
		IF Ocnx.Tipo_BD=1
			IF SQLEXEC(Ocnx.conexion,lcad,"Temmon_"+ALLTRIM(This.Name))<0
			   WAIT WINDOW "Error: "+MESSAGE() NOWAIT 
			   RETURN 
			ENDIF
		ENDIF
		IF Ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(lcad,"Temmon_"+ALLTRIM(This.Name),ThisForm.DataSessionId)<0
			   WAIT WINDOW "Error: "+MESSAGE() NOWAIT 
			   RETURN 
			ENDIF
		ENDIF

		This.BoundColumn=2
		This.RowSourceType= 2 
		This.RowSource="Temmon_"+ALLTRIM(This.Name)
		This.Requery()   
		SELECT (lcarea)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: tmo_codtmo
**************************************************


**************************************************
*-- Class:        ubi_codubi (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/06/05 05:37:04 PM
*
DEFINE CLASS ubi_codubi AS texto


	Height = 23
	InputMask = "999999"
	MaxLength = 6
	Width = 53
	*-- Codigo del Pais
	pai_codpai = ("01")
	areavalid = 0
	ayudaalias = "Temubica"
	ayudacampos = "ubi_codubi,ubi_desubi"
	ayudanombretabla = "V_UBICACIONES_UBI"
	ayudavalor = "ubi_codubi"
	Name = "ubi_codubi"


	PROCEDURE ayuda
		This.AyudaWhere=" pai_codpai='"+This.Pai_codpai+"' "  
		&&SUSP
		DODEFAULT()
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaIndice[1,1]="ubi_codubi"
		This.AyudaIndice[1,2]="CODIGO"
		This.AyudaIndice[2,1]="Left(ubi_desubi,239)"
		This.AyudaIndice[2,2]="DESCRIP"
		This.ayudaindicedefault = 2
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcad,lcondi,lcurdir

		lcurdir=SELECT()
		lcondi=IIF(This.DatoObligatorio," 1=1 "," !EMPTY(NVL(This.Value,'')) ")

		IF !This.AyudaActiva AND &lcondi
		   lcad="Select ubi_codubi,"+;
		        "dbo.fx_ubicacion(pai_codpai,ubi_codubi) as 'ubi_desubi' "+;  
		        "From dbo.ubicaciones_ubi "+;
		        "Where pai_codpai='"+NVL(This.pai_codpai,"")+"' "+;
		        "and   ubi_codubi='"+NVL(This.Value,"")+"' "
		   
		   IF Ocnx.Tipo_BD=1     
			   IF SQLEXEC(Ocnx.conexion,lcad,"Tubicacion")<0
			      MESSAGEBOX("ERROR: "+MESSAGE(),64,"UBICACION")
			      RETURN .F.
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4     
			   IF Ocnx.Ms_Ejecuta_SQL(lcad,"Tubicacion")<0
			      MESSAGEBOX("ERROR: "+MESSAGE(),64,"UBICACION")
			      RETURN .F.
			   ENDIF
		   ENDIF
		   
		   This.AreaValid=SELECT() 
		   IF EOF()
		      MESSAGEBOX("CODIGO DE UBICACION/LOCALIDAD NO EXISTE",64,"PAIS")
		      This.Value=""
		      This.AreaValid=0
		      RETURN .F.
		   ENDIF
		   This.Valid_Campos() 
		   This.AreaValid=0
		   IF USED("UBICACION")
		      USE IN "UBICACION"
		   ENDIF
		ENDIF
		SELECT (lcurdir) 
	ENDPROC


	PROCEDURE valid_campos
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ubi_codubi
**************************************************


**************************************************
*-- Class:        vde_codvde (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/07/05 11:48:00 AM
*
DEFINE CLASS vde_codvde AS texto


	Height = 23
	MaxLength = 4
	Width = 39
	vde_nomvde = ("")
	ayudaalias = "Tvendedores"
	ayudacampos = "vde_codvde,vde_nomvde"
	ayudanombretabla = "VENDEDOR_VDE"
	ayudavalor = "vde_codvde"
	Name = "vde_codvde"


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcon,lcurdir,lcad
		lcon=IIF(This.DatoObligatorio,"1=1","!EMPTY(NVL(This.Value,''))") 
		IF !This.AyudaActiva AND &lcon AND This.Indicadorllave=.F. 
		   lcurdir=SELECT()
		   lcad="Select vde_codvde,vde_nomvde "+;
		        "From dbo.VENDEDOR_VDE "+;
		        "Where cia_codcia='"+ThisForm.Entorno.CodigoCia+"' "+;
		        "and   vde_codvde='"+NVL(This.Value,"")+"' "
		   IF Ocnx.Tipo_BD=1     
			   IF SQLEXEC(Ocnx.conexion,lcad,"Temval")<0
			      SELECT (lcurdir)
			      MESSAGEBOX("Error: "+MESSAGE(),16,"Vendedor")
			      RETURN 
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4     
			   IF Ocnx.Ms_Ejecuta_SQL(lcad,"Temval",ThisForm.DataSessionId)<0
			      SELECT (lcurdir)
			      MESSAGEBOX("Error: "+MESSAGE(),16,"Vendedor")
			      RETURN 
			   ENDIF
		   ENDIF
		   
		   IF EOF()
		      MESSAGEBOX("Codigo de Vendedor NO EXISTE",16,"Vendedor")
		      SELECT (lcurdir)
		      RETURN .F.
		   ENDIF
		   This.vde_nomvde=NVL(Temval.vde_nomvde,'') 

		   IF USED("Temval")
		   		USE IN "Temval"
		   ENDIF
		   This.Despues_valid() 
		   SELECT (lcurdir)
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaWhere = "cia_codcia='"+ThisForm.Entorno.CodigoCia+"'"
		This.Ayudaindice[1,1]="vde_codvde"
		This.Ayudaindice[1,2]="Codigo"
		This.Ayudaindice[2,1]="vde_nomvde"
		This.Ayudaindice[2,2]="Nombre"
	ENDPROC


	PROCEDURE despues_valid
	ENDPROC


ENDDEFINE
*
*-- EndDefine: vde_codvde
**************************************************


**************************************************
*-- Class:        zve_codzve (k:\aplvfp\libs\objetos_osis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/07/05 11:48:04 AM
*
DEFINE CLASS zve_codzve AS texto


	Height = 23
	MaxLength = 4
	Width = 38
	area_valid = 0
	ayudaalias = "Tzonaventa"
	ayudanombretabla = "ZONA_VENTA_ZVE"
	ayudacampos = "zve_codzve,zve_nomzve"
	ayudavalor = "zve_codzve"
	Name = "zve_codzve"


	PROCEDURE Valid
		DODEFAULT()
		PRIVATE lcon,lcurdir,lcad
		lcon=IIF(This.DatoObligatorio,"1=1","!EMPTY(NVL(This.Value,''))") 
		IF !This.AyudaActiva AND &lcon
		   lcurdir=SELECT()
		   lcad="Select * "+;
		        "From dbo.ZONA_VENTA_ZVE "+;
		        "Where cia_codcia='"+ThisForm.Entorno.CodigoCia+"' "+;
		        "and   zve_codzve='"+NVL(This.Value,"")+"' "
		   IF Ocnx.Tipo_BD=1     
			   IF SQLEXEC(Ocnx.conexion,lcad,"Temval")<0
			      SELECT (lcurdir)
			      MESSAGEBOX("Error: "+MESSAGE(),16,"Zona de Venta")
			      RETURN 
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4     
			   IF Ocnx.Ms_Ejecuta_SQL(lcad,"Temval",ThisForm.DataSessionId)<0
			      SELECT (lcurdir)
			      MESSAGEBOX("Error: "+MESSAGE(),16,"Zona de Venta")
			      RETURN 
			   ENDIF
		   ENDIF
		   
		   This.Area_Valid=SELECT() 
		   IF EOF()
		      This.Area_Valid=0
		      MESSAGEBOX("Codigo de Tipo de Cliente NO EXISTE",16,"Zona de Venta")
		      SELECT (lcurdir)
		      RETURN .F.
		   ENDIF
		   This.Valid_Campos() 
		   IF USED("Temval")
		      USE IN "Temval"
		   ENDIF
		   This.Area_Valid=0
		   SELECT (lcurdir)
		ENDIF
	ENDPROC


	PROCEDURE ayudapropiedades
		This.AyudaWhere = " cia_codcia='"+ThisForm.Entorno.CodigoCia+"' "
		This.AyudaIndice[1,1]="zve_codzve"
		This.AyudaIndice[1,2]="Codigo"
		This.AyudaIndice[2,1]="zve_nomzve"
		This.AyudaIndice[2,2]="Descrip"
	ENDPROC


	PROCEDURE valid_campos
	ENDPROC


ENDDEFINE
*
*-- EndDefine: zve_codzve
**************************************************
