*do progs/genera_kardex_gerencia_v1 with 0,"01","01","2016","03","LI01","SO",0,"EXPLOMIN"
*do progs/genera_kardex_gerencia_v1 with 0,"01","01","2016","03","G002","SO",0,"EXPLOMIN"
PARAMETERS pdriver,pcia,psuc,pano,pmes,pfilalm,pcodmon,pincmov,pnom_cia
PRIVATE wdriver,werror,wdbfdis,pcolumax,pfilamax,pininumero,wur_area,wruta_logo

IF PARAMETERS()< 9
  =MESSAGEBOX("De pasar 8 parámetros: conexion,cia,suc,ano,mes,filtro,moneda,incluir movimientos, nombre cia",48)
  retu
ENDIF

*** Iniciliza Variables
wcur_area=SELECT()
STORE 0    TO wdriver,werror,pcolumax,pfilamax,pini_fila
wruta_logo = SYS(5)+CURDIR()+"fotos\"
wfile_logo = "logo_empresa.png"
*
STORE 0 TO ting, tsal

*** Conecta a base de datos
IF pdriver=0
	DO conecta WITH "SERVER6\SQL2014","Explomin_V13","OSIS","rriosis"
	IF werror=1
	   retu
	ENDIF
ELSE
   wdriver=pdriver	
ENDIF
**** Incia Proceso
DO genera_cursor_de_datos
IF werror=0
   DO genera_hoja_excel
endif
IF pdriver=0
   DO desconecta
ENDIF

IF USED("Cur_Kardex")
   USE IN 'Cur_Kardex'
ENDIF

IF USED("Cur_Motivos")
   USE IN 'Cur_Motivos'
ENDIF

IF USED("Cur_DetaKar")
   USE IN 'Cur_DetaKar'
ENDIF

IF USED("Cur_KarAlmCC")
   USE IN 'Cur_KarAlmCC'
ENDIF

SELECT (wcur_area)
RETURN
*
*******************************
PROCEDUR genera_cursor_de_datos
*******************************
WAIT WINDOW ("Generando Información para Kardex Gerencial") NOWAIT noclear

wcad = 	"EXEC PA_REPORTE_KARDEX_GERENCIAL	"+;
 		"@cia=?pcia,   "+;
		"@suc=?psuc,   "+;
		"@ano=?pano,   "+; 
		"@mes=?pmes,   "+;
		"@pcodalm=?pfilalm "

IF Sqlexec(wdriver,wcad,'Cur_Kardex') <0
   werror=1
   =MESSAGEBOX("No se puede ejecutar PA_REPORTE_KARDEX_GERENCIAL "+MESSAGE(),48)
   RETURN .F. 
ENDIF 

SELECT 'Cur_Kardex'
INDEX on IdAlmacen+Tipo+IdMotivo TAG i
INDEX on IdAlmacen+IdSuministro+DTOS(FechaDoc)+Tdoc+NumDoc TAG j ADDITIVE 
INDEX on IdAlmacen+IdCenCos+IdFamilia TAG x ADDITIVE 
SET ORDER TO i

**** Maestro de Motivos ****
WAIT WINDOW ("Generando Tablas de Motivos (Ingresos y Salidas)") NOWAIT noclear
SELECT distinct 000 as ide_poscol, tipo, IDMotivo, Motivo FROM 'Cur_Kardex' ORDER BY Tipo, IdMotivo INTO CURSOR Cur_Motivos ReadWrite
SELECT "Cur_Motivos"
APPEND BLANK
replace ide_poscol WITH 000,     tipo   WITH '1.-ING'
replace IdMotivo   WITH 'ZZZ',  Motivo WITH 'TOTAL INGRESOS'
*
APPEND BLANK
replace ide_poscol WITH 000,     tipo   WITH '2.-SAL'
replace IdMotivo   WITH 'ZZZ',  Motivo WITH 'TOTAL SALIDAS'
*
witem = 1
FOR I=1 TO 2
    wtipo = IIF(i=1,'1.-ING','2.-SAL')
	go top
	SCAN WHILE !EOF() FOR tipo=wtipo
	     replace ide_poscol WITH witem
	     witem = witem + 1
	ENDSCAN
ENDFOR
INDEX on STR(ide_poscol,3) TAG Mot1
INDEX on Tipo+IdMotivo     TAG Mot2 addi
*
pindopc = 1
IF pincmov = 1
	   IF pindopc = 1 &&& Kardex Detallado => Almacen \ Centro de Costo \ Familia 
		      WAIT WINDOW ("Generando Kardex Detallado => Almacen \ Centro de Costo \ Familia") NOWAIT noclear   
		      *
		      CREATE Cursor Cur_KarAlmCC(nivel c(02),;
		                    IdAlmacen c(04), almacen      c(80),;
		                    IdCenCos  c(06), centrocosto  c(80),;
		                    IdFamilia c(04), familia      c(80),;
		                    cantidad   n(16,2), soles n(16,2), dolar n(16,2))
		                    
		      SELECT "Cur_KarAlmCC" 
		      &&INDEX on IdAlmacen+nivel+IdCenCos+IdFamilia TAG i
		      INDEX on IdAlmacen+IdCenCos+IdFamilia TAG i      
		      SET ORDER TO i
		      *
			  TEXT TO wsql TEXTMERGE NOSHOW PRETEXT 2 
					Select 
					b.ano_codano, b.mes_codmes, 
					b.alm_codalm as IdAlmacen, b.alm_codalm+'-'+c.alm_deslar as Almacen,
					ISNULL(b.cco_codcco,'      ') as IdCenCos, b.cco_codcco +'-'+e.cco_deslar as CentroCosto, 
					i.fpr_codfpr as IdFamilia, i.fpr_codfpr+'-'+j.fpr_deslar as Familia,
					sum((case when a.kad_tipmov='1' then 1 else -1 end)*a.kad_canpro) as Cantidad, 
					sum((case when a.kad_tipmov='1' then 1 else -1 end)*a.kad_impnac) as Soles, 
					sum((case when a.kad_tipmov='1' then 1 else -1 end)*a.kad_impdol) as Dolar
					From KARDEX_ALMACEN_KAD A
					Left Join KARDEX_ALMACEN_KAC B 
					On a.cia_codcia=b.cia_codcia 
					and a.suc_codsuc=b.suc_codsuc 
					and a.ano_codano=b.ano_codano 
					and a.mes_codmes=b.mes_codmes 
					and a.alm_codalm=b.alm_codalm 
					and a.tdo_codtdo=b.tdo_codtdo 
					and a.kac_nummov=b.kac_nummov
					Left Join Almacenes_ALM C 
					on a.cia_codcia=c.cia_codcia 
					and a.alm_codalm=C.alm_codalm
					Left Join Centro_Costo_Cco E 
					On b.cia_codcia=e.cia_codcia 
					and b.cco_codcco=e.cco_codcco
					Left Join Productos_PRD I 
					on a.cia_codcia=i.cia_codcia 
					and a.prd_codprd=i.prd_codprd
					Left Join Familia_Productos_FPR J 
					On I.cia_codcia=J.cia_codcia 
					and I.fpr_codfpr=J.fpr_codfpr
					Left Join TIPO_INVENTARIO_TIN R 
					ON I.tin_codtin=R.TIN_CODTIN
					Where a.cia_codcia=?pcia
					  and a.suc_codsuc=?psuc
					  and a.ano_codano=?pano
					  and a.mes_codmes=?pmes
					  and Isnull(R.TIN_INDVAL,0) = 1  
				      and B.KAC_INDEST = '1'
					  and case when len(ltrim(rtrim(?pfilalm)))=0 then 1 else charindex(b.alm_codalm,?pfilalm,1) end  > 0  
					group by 
					b.ano_codano, b.mes_codmes, 
					b.alm_codalm, c.alm_deslar,
					b.cco_codcco, e.cco_deslar,
					i.fpr_codfpr, j.fpr_deslar 	
			  ENDTEXT
			  IF SQLEXEC(wdriver,wSql, 'Cur_DetaKar') < 0
				   	werror=1
				    =MESSAGEBOX("No se puedo generar detalle de Kardex "+MESSAGE(),48)
					RETURN .F. 
			  ENDIF    
	  *
			SELECT "Cur_DetaKar"
			GO top
				  *
			DO WHILE !EOF()
				     lId_Alm = NVL(IdAlmacen,SPACE(04))
				     ldesAlm = NVL(Almacen,SPACE(80))
				     *
			  	     SELECT "Cur_KarAlmCC"
			  	     APPEND BLANK
			  	     replace nivel     WITH '01'
			  	     replace IdAlmacen WITH lId_Alm
			  	     replace Almacen   WITH ldesAlm
			  	     SELECT "Cur_DetaKar"
				     xbusca1 = lId_Alm+SPACE(06)+SPACE(04)
				     *
				     STORE 0 TO alm_cant, alm_soles, alm_dolar 
				     *
					DO WHILE !EOF() AND IdAlmacen = lId_Alm
							lId_Cen = NVL(IdCenCos,SPACE(06))
							ldesCen = NVL(CentroCosto,SPACE(80))
									    *
							SELECT "Cur_KarAlmCC"
							APPEND BLANK
							replace nivel       WITH '02'
							replace IdAlmacen   WITH lId_Alm
							replace Almacen     WITH ldesAlm
							replace IdCenCos    WITH lId_Cen
							replace CentroCosto WITH ldesCen
							SELECT "Cur_DetaKar"
							xbusca2 = lId_Alm+lId_Cen+SPACE(04)		      	        
				            *  	        
						      STORE 0 TO cos_cant, cos_soles, cos_dolar
						    * 
							DO WHILE !EOF() AND IdAlmacen = lId_Alm AND IdCenCos = lId_Cen
								       lId_Fam = NVL(IdFamilia,(04))
								       ldesFam = NVL(Familia,SPACE(80))
								       *
						  	           SELECT "Cur_KarAlmCC"
						  	           APPEND BLANK
						  	           replace nivel       WITH '03'
						  	           replace IdAlmacen   WITH lId_Alm
						  	           replace Almacen     WITH ldesAlm
						  	           replace IdCenCos    WITH lId_Cen
						  	           replace CentroCosto WITH ldesCen
						  	           replace IdFamilia   WITH lId_Fam
						  	           replace Familia     WITH ldesFam
						  	           SELECT "Cur_DetaKar"
							           xbusca3 = lId_Alm+lId_Cen+lId_Fam		      	          	           
							           *
								       STORE 0 TO fam_cant, fam_soles, fam_dolar
								       * 
								       SCAN WHILE !EOF() AND IdAlmacen=lId_Alm AND IdCenCos=lId_Cen AND IdFamilia=lid_Fam 
								           *
										       alm_cant  = alm_cant  + cantidad 
										       alm_soles = alm_soles + soles
										       alm_dolar = alm_dolar + dolar
										           *
										       cos_cant  = cos_cant  + cantidad
										       cos_soles = cos_soles + soles
										       cos_dolar = cos_dolar + dolar
										           *
										       fam_cant  = fam_cant  + cantidad
										       fam_soles = fam_soles + soles
										       fam_dolar = fam_dolar + dolar
								           *
								       ENDSCAN
								       *
								       SELECT "Cur_KarAlmCC"
								       SEEK xbusca3
								       IF FOUND()
											replace cantidad 	WITH cantidad + fam_cant
											replace soles    		WITH soles    + fam_soles
											replace dolar    	WITH dolar    + fam_dolar
								       ENDIF
								       SELECT "Cur_DetaKar"
							ENDDO
							SELECT "Cur_KarAlmCC"
							 SEEK xbusca2
							 IF FOUND()
								      replace cantidad 	WITH cantidad + cos_cant
						                  replace soles    		WITH soles    + cos_soles
					      	            replace dolar    	WITH dolar    + cos_dolar
							 ENDIF
							 SELECT "Cur_DetaKar"
					   *
					ENDDO
					SELECT "Cur_KarAlmCC"

				      SEEK xbusca1
				      IF FOUND()
				      	replace cantidad 	WITH cantidad + alm_cant
			            	replace soles    		WITH soles    + alm_soles
			            	replace dolar    	WITH dolar    + alm_dolar
				      ENDIF
					SELECT "Cur_DetaKar"
			 
			ENDDO
   *    
	ENDIF
ENDIF
*
RETURN

***************************
PROCEDURE genera_hoja_excel
***************************
PRIVATE wrutafile,wdisco,wfiles
wrutafile  = CURDIR()+"transfer\"
wdisco     = SYS(5)
wperiodo   = pano+'-'+pmes
wfile      = "Resumen_Kardex_Gerencial_"+wperiodo+".xls"

IF SET("safety")="ON"
   SET safety Off
ENDIF

oExcel = CreateObject("Excel.Application")
if vartype(oExcel) != "O"
  =MESSAGEBOX("No se puede abrir aplicacion Excel",48)
  return .F.
ENDIF

*** Adiciona Kardex Gerencial ***

oExcel.Application.Workbooks.Add()
oExcel.ActiveSheet.name='Kardex Gerencial' 
oExcel.Application.Worksheets(1).Activate

DO hoja_kardex_general   

IF pincmov = 1
   *
*** Adiciona Kardex Detallado Almacen Producto ***
   oExcel.Worksheets.Add(,oExcel.ActiveSheet)
   oExcel.ActiveSheet.name='Kardex_Detalle_Almacen_Prd'
   oExcel.Application.Worksheets(2).Activate
   *DO hoja_kardex_detallado_alm_prd
   *
*** Adiciona Kardex Detallado Almacen Centro de Costo Familia ***
   oExcel.Worksheets.Add(,oExcel.ActiveSheet)
   oExcel.ActiveSheet.name='Kardex_Detalle_Almacen_CC' 
   oExcel.Application.Worksheets(3).Activate
   DO hoja_kardex_detallado_alm_cc
   *
ENDIF

oExcel.Application.Worksheets(1).Activate

oExcel.visible = .T.

RETURN

*****************************
PROCEDURE hoja_kardex_general
*****************************
ptitulo = "RESUMEN KARDEX GERENCIAL "+wperiodo

wfila      = 0

wfil_ini_rep  = 01
wfil_ini_tit  = 07
wfil_ini_dat  = 08

wcol_ini_rep  = 01
wcol_ini_imp  = 02

pcolumax=RECCOUNT("cur_motivos")+wcol_ini_imp+1
preccmax=RECCOUNT("cur_kardex")

pcamimpo=RECCOUNT("cur_motivos")+1
IF pcamimpo > 0
	DIMENSION a_tot_gen(pcamimpo)
ENDIF
STORE 0 TO a_tot_gen  

****** Cabecera *****
WITH oExcel.ActiveWorkBook.ActiveSheet
     *********************************************
     *** Insert Logo *****************************
     IF FILE(wruta_logo+wfile_logo)
	    .Range("A1:A1").Select
	    .Pictures.Insert(wruta_logo+wfile_logo).name="Imagen1"
	    .Shapes("Imagen1").LockAspectRatio = 0
        .Shapes("Imagen1").Top = 0
        .Shapes("Imagen1").Left= 0 
	 ELSE
	    .Cells(wfil_ini_rep,wcol_ini_imp).Value = pnom_cia
        .Cells(wfil_ini_rep,wcol_ini_imp).font.bold = .t.     	    
	    .Cells(wfil_ini_rep,wcol_ini_imp).font.size = 09	    
     ENDIF
     *********************************************
     ** Inserta Fecha y Hora **
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).Merge
	 .Cells(wfil_ini_rep,pcolumax-1).Value = 'FECHA :'+ DTOC(DATE())
	 .Cells(wfil_ini_rep,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep,pcolumax-1).font.size = 10 &&12
	 *
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).Merge
	 .Cells(wfil_ini_rep+1,pcolumax-1).Value = 'HORA  :'+ TIME()
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.size = 10 &&12
     *	    
     *********************************************
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).Merge
     
     .Cells(wcol_ini_rep+2,1).Value = ptitulo
     .Cells(wcol_ini_rep+2,1).HorizontalAlignment = 3     
     .Cells(wcol_ini_rep+2,1).font.bold = .t.     
     .Cells(wcol_ini_rep+2,1).font.size = 09
     **
     .RANGE(.Cells(wfil_ini_rep+3,wcol_ini_rep+0),.Cells(wfil_ini_rep+3,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+3,wcol_ini_rep+0),.Cells(wfil_ini_rep+3,pcolumax)).Merge
     
     .Cells(wcol_ini_rep+3,1).Value = IIF(pcodmon='DO','EXPRESADO EN DOLARES','EXPRESADO EN NUEVOS SOLES')
     .Cells(wcol_ini_rep+3,1).HorizontalAlignment = 3     
     .Cells(wcol_ini_rep+3,1).font.bold = .t.     
     .Cells(wcol_ini_rep+3,1).font.size = 09
     **
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).Value = 'Nº'	
     .Cells(wfil_ini_tit-1,wcol_ini_rep+01).Value = 'ALMACEN'	

      SELECT 'Cur_Motivos'
      SET ORDER TO Mot1
      GO TOP
      SCAN WHILE !EOF()
         .Cells(wfil_ini_tit-1,wcol_ini_imp+cur_motivos.ide_poscol).Value = IIF(alltrim(cur_motivos.IDMotivo)='ZZZ',ALLTRIM(cur_motivos.tipo),alltrim(cur_motivos.IDMotivo))
         .Cells(wfil_ini_tit  ,wcol_ini_imp+cur_motivos.ide_poscol).Value = alltrim(cur_motivos.Motivo)        
      ENDSCAN
      .Cells(wfil_ini_tit-1,pcolumax).Value = 'TOTAL'
      .Cells(wfil_ini_tit  ,pcolumax).Value = 'GENERAL'
ENDWITH
*
SELECT "Cur_Kardex"
SET ORDER TO i

wlinea= wfil_ini_dat 
witem = 1
wrecc = 1

STORE 0 TO tot_ing,tot_sal,tot_gral	
GO top
DO WHILE !EOF("cur_kardex")
  	wlinea = wlinea + 1
    wllave1= IdAlmacen  
    
	WITH oExcel.ActiveWorkBook.ActiveSheet
	    .Cells(wlinea,wcol_ini_rep+00).Value = witem
	    .Cells(wlinea,wcol_ini_rep+01).Value = ALLTRIM(almacen)
	ENDWITH
	   
	oExcel.Range(oExcel.cells(wlinea,wcol_ini_imp+1), oExcel.Cells(wlinea,pcolumax)).Select
	oExcel.Selection.value = 0
	oExcel.Selection.NumberFormat = "###,###,##0.00"
	
	STORE 0 TO ing, sal, gral
	
	DO WHILE !EOF("cur_kardex") AND IdAlmacen = wllave1
	   wTipo  = cur_kardex.tipo
	   wIdMo  = cur_kardex.idmotivo
	   wllave2= cur_kardex.tipo + cur_kardex.idmotivo
	   nsoles = 0
	   
	   SCAN WHILE !EOF("cur_kardex") AND IdAlmacen = wllave1 AND Tipo+IdMotivo = wllave2
	        *
	        IF wtipo = '1.-ING'
	           ing = ing + IIF(pcodmon='SO',soles,dolar)
	        ELSE
	           sal = sal + IIF(pcodmon='SO',soles,dolar)
	        ENDIF
	        gral = gral + IIF(pcodmon='SO',soles,dolar)
	        *
	        nsoles   = nsoles + IIF(pcodmon='SO',soles,dolar)
		    wprocent = TRANSFORM(wrecc/preccmax*100,"999")+"%"
		    wmensaje = "Procesando registro Número "+ transform(wrecc,"999999")+ " de " + TRANSFORM(preccmax,"999999") +" - "+wprocent
		    WAIT WINDOW (wmensaje) NOWAIT noclear
		    wrecc=wrecc+1
		    *
	   ENDSCAN
	   *   
	   WITH oExcel.ActiveWorkBook.ActiveSheet
		    IF SEEK(wTipo+wIdMo,"Cur_Motivos","Mot2")
		       wpos=wcol_ini_imp+cur_motivos.ide_poscol
		       .Cells(wlinea,wpos).Value = nsoles
		       *
		       a_tot_gen(cur_motivos.ide_poscol) = a_tot_gen(cur_motivos.ide_poscol) + nsoles
		       *
		    ENDIF
	   ENDWITH
	   *
	ENDDO
	*
	WITH oExcel.ActiveWorkBook.ActiveSheet
		 IF SEEK('1.-ING'+'ZZZ',"Cur_Motivos","Mot2")
		    wpos=wcol_ini_imp+cur_motivos.ide_poscol
		    .Cells(wlinea,wpos).Value     = ing
		    *
		    a_tot_gen(cur_motivos.ide_poscol) = a_tot_gen(cur_motivos.ide_poscol) + ing
		    *
		 ENDIF
		 IF SEEK('2.-SAL'+'ZZZ',"Cur_Motivos","Mot2")
		    wpos=wcol_ini_imp+cur_motivos.ide_poscol
		    .Cells(wlinea,wpos).Value     = sal
		    *
		    a_tot_gen(cur_motivos.ide_poscol) = a_tot_gen(cur_motivos.ide_poscol) + sal
		    *
		 ENDIF
		 .Cells(wlinea,pcolumax).Value = gral
		 *
		 a_tot_gen(pcamimpo) = a_tot_gen(pcamimpo) + gral
		 *
	ENDWITH
	*
	witem  = witem  + 1
ENDDO
*
* TOTALES GENERALES
*
wlinea = wlinea + 1
oExcel.Range(oExcel.cells(wlinea,wcol_ini_imp+1), oExcel.Cells(wlinea,pcolumax)).Select
oExcel.Selection.NumberFormat = "###,###,##0.00"	
oExcel.Selection.borders(1).LineStyle = 1
oExcel.Selection.borders(2).LineStyle = 1
oExcel.Selection.borders(3).LineStyle = 1
oExcel.Selection.borders(4).LineStyle = 1   
WITH oExcel.ActiveWorkBook.ActiveSheet
     .Cells(wlinea,wcol_ini_rep+01).Value = 'TOTAL GENERAL'
	 .Cells(wlinea,wcol_ini_rep+01).font.bold = .t.      
	 FOR  wpos=1 TO pcamimpo
		  .Cells(wlinea,wcol_ini_imp+wpos).Value =  a_tot_gen(wpos)
		  .Cells(wlinea,wcol_ini_imp+wpos).font.bold = .t. 
	 ENDFOR    
ENDWITH
*
oExcel.Range(oExcel.cells(wfil_ini_dat,wcol_ini_rep), oExcel.Cells(wlinea,pcolumax)).Select
oExcel.Selection.font.size = 8

&&& Salidas
pcol_sal = 0
IF SEEK('1.-ING'+'ZZZ',"Cur_Motivos","Mot2")
    pcol_sal=wcol_ini_imp+cur_motivos.ide_poscol+1
	oExcel.Range(oExcel.cells(wfil_ini_dat,pcol_sal), oExcel.Cells(wlinea,pcolumax-1)).Select
	oExcel.Selection.font.colorindex = 3
	oExcel.Selection.font.bold = .t.
*!*		oExcel.Selection.borders(1).LineStyle = 1
*!*		oExcel.Selection.borders(2).LineStyle = 1
*!*		oExcel.Selection.borders(3).LineStyle = 1
*!*		oExcel.Selection.borders(4).LineStyle = 1   
endif

WAIT clear

oExcel.Range(oExcel.cells(wfil_ini_tit-1,wcol_ini_rep), oExcel.Cells(wfil_ini_tit,pcolumax)).Select
oExcel.Selection.Interior.colorindex = 37
oExcel.Selection.HorizontalAlignment = 3 
oExcel.Selection.font.colorindex = 1 
oExcel.Selection.font.size = 09
oExcel.Selection.font.bold = .t.
oExcel.Selection.borders(1).LineStyle = 1
oExcel.Selection.borders(2).LineStyle = 1
oExcel.Selection.borders(3).LineStyle = 1
oExcel.Selection.borders(4).LineStyle = 1   

oExcel.ActiveSheet.UsedRange.EntireColumn.Autofit
WITH oExcel.ActiveWorkBook.ActiveSheet	
	oExcel.ActiveWindow.SplitColumn=2
	oExcel.ActiveWindow.SplitRow=wfil_ini_tit
	oExcel.ActiveWindow.FreezePanes= .T.
ENDWITH

RETURN

**************************************
PROCEDURE hoja_kardex_detallado_alm_cc
**************************************
ptitulo = "KARDEX GERENCIAL DETALLADO - ALMACEN - CENTRO DE COSTO "+wperiodo

wfila      = 0

wfil_ini_rep  = 01
wfil_ini_tit  = 07
wfil_ini_dat  = 08

wcol_ini_rep  = 01
wcol_ini_imp  = 02

pcolumax=8
preccmax=RECCOUNT("Cur_KarAlmCC")

****** Cabecera *****
WITH oExcel.ActiveWorkBook.ActiveSheet
     *********************************************
     *** Insert Logo *****************************
     IF FILE(wruta_logo+wfile_logo)
	    .Range("A1:A1").Select
	    .Pictures.Insert(wruta_logo+wfile_logo).name="Imagen1"
	    .Shapes("Imagen1").LockAspectRatio = 0
        .Shapes("Imagen1").Top = 0
        .Shapes("Imagen1").Left= 0 
	 ELSE
	    .Cells(wfil_ini_rep,wcol_ini_imp).Value = pnom_cia
        .Cells(wfil_ini_rep,wcol_ini_imp).font.bold = .t.     	    
	    .Cells(wfil_ini_rep,wcol_ini_imp).font.size = 09	    
     ENDIF
     *********************************************
     ** Inserta Fecha y Hora **
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).Merge
	 .Cells(wfil_ini_rep,pcolumax-1).Value = 'FECHA :'+ DTOC(DATE())
	 .Cells(wfil_ini_rep,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep,pcolumax-1).font.size = 10
	 *
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).Merge
	 .Cells(wfil_ini_rep+1,pcolumax-1).Value = 'HORA  :'+ TIME()
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.size = 10
     *	    
     *********************************************
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).Merge
     
     .Cells(wcol_ini_rep+2,1).Value = ptitulo
     .Cells(wcol_ini_rep+2,1).HorizontalAlignment = 3     
     .Cells(wcol_ini_rep+2,1).font.bold = .t.     
     .Cells(wcol_ini_rep+2,1).font.size = 09
     *
     **** CODIGO
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+00),.Cells(wfil_ini_tit-1,wcol_ini_rep+02)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+00),.Cells(wfil_ini_tit-1,wcol_ini_rep+02)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).Value = 'CODIGO'
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).font.size = 09     
     *
     **** DESCRIPCION
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+03),.Cells(wfil_ini_tit-1,wcol_ini_rep+04)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+03),.Cells(wfil_ini_tit-1,wcol_ini_rep+04)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+03).Value = 'DESCRIPCION'
     .Cells(wfil_ini_tit-1,wcol_ini_rep+03).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+03).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+03).font.size = 09     
     *
     .Cells(wfil_ini_tit-1,wcol_ini_rep+05).Value = 'SUMA DE CANTIDAD'	
     .Cells(wfil_ini_tit-1,wcol_ini_rep+06).Value = 'SUMA DE SOLES'	     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+07).Value = 'SUMA DE DOLARES'	     
     *
ENDWITH
*
SELECT "Cur_KarAlmCC"

wlinea= wfil_ini_dat 
witem = 1
wrecc = 1

GO top
DO WHILE !EOF("Cur_KarAlmCC")
   wlinea = wlinea + 1
   WITH oExcel.ActiveWorkBook.ActiveSheet
         DO CASE
            CASE NIVEL = '01'
		         .Cells(wlinea,wcol_ini_rep+00).Value = IdAlmacen
		         .Cells(wlinea,wcol_ini_rep+03).Value = Almacen		         
		              .Cells(wfil_ini_tit-1,wcol_ini_rep+00).font.bold = .t.
            CASE NIVEL = '02'            
		         .Cells(wlinea,wcol_ini_rep+01).Value = IdCenCos            
		         .Cells(wlinea,wcol_ini_rep+03).Value = CentroCosto
            CASE NIVEL = '03'            
		         .Cells(wlinea,wcol_ini_rep+02).Value = IdFamilia
		         .Cells(wlinea,wcol_ini_rep+03).Value = Familia
         ENDCASE
   ENDWITH
	   
   oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+05), oExcel.Cells(wlinea,pcolumax)).Select
   oExcel.Selection.value = 0
   oExcel.Selection.NumberFormat = "###,###,##0.00"
   *
   WITH oExcel.ActiveWorkBook.ActiveSheet
		.Cells(wlinea,wcol_ini_rep+05).Value = cantidad
		.Cells(wlinea,wcol_ini_rep+06).Value = soles
		.Cells(wlinea,wcol_ini_rep+07).Value = dolar
   ENDWITH   
   *   
   wrecc  = wrecc  + 1
   witem  = witem  + 1
   *
   wprocent = TRANSFORM(wrecc/preccmax*100,"999")+"%"
   wmensaje = "Procesando registro Número "+ transform(wrecc,"999999")+ " de " + TRANSFORM(preccmax,"999999") +" - "+wprocent
   WAIT WINDOW (wmensaje) NOWAIT noclear
   *
   SKIP
   *
ENDDO	  
oExcel.Range(oExcel.cells(wfil_ini_dat,wcol_ini_rep), oExcel.Cells(wlinea,pcolumax)).Select
oExcel.Selection.font.size = 8

WAIT clear

oExcel.Range(oExcel.cells(wfil_ini_tit-1,wcol_ini_rep), oExcel.Cells(wfil_ini_tit,pcolumax)).Select
oExcel.Selection.Interior.colorindex = 37
oExcel.Selection.HorizontalAlignment = 3 
oExcel.Selection.font.colorindex = 1 
oExcel.Selection.font.size = 09
oExcel.Selection.font.bold = .t.
oExcel.Selection.borders(1).LineStyle = 1
oExcel.Selection.borders(2).LineStyle = 1
oExcel.Selection.borders(3).LineStyle = 1
oExcel.Selection.borders(4).LineStyle = 1   

oExcel.ActiveSheet.UsedRange.EntireColumn.Autofit
WITH oExcel.ActiveWorkBook.ActiveSheet	
	oExcel.ActiveWindow.SplitColumn=2
	oExcel.ActiveWindow.SplitRow=wfil_ini_tit
	oExcel.ActiveWindow.FreezePanes= .T.
ENDWITH

RETURN

***************************************
PROCEDURE hoja_kardex_detallado_alm_prd
***************************************
ptitulo = "KARDEX DETALLADO POR ALMACEN - CENTRO DE COSTO - FAMILIA "+wperiodo

wfila      = 0

wfil_ini_rep  = 01
wfil_ini_tit  = 07
wfil_ini_dat  = 08

wcol_ini_rep  = 01
wcol_ini_imp  = 02

pcolumax=17
preccmax=RECCOUNT("cur_kardex")

****** Cabecera *****
WITH oExcel.ActiveWorkBook.ActiveSheet
     *********************************************
     *** Insert Logo *****************************
     IF FILE(wruta_logo+wfile_logo)
	    .Range("A1:A1").Select
	    .Pictures.Insert(wruta_logo+wfile_logo).name="Imagen1"
	    .Shapes("Imagen1").LockAspectRatio = 0
        .Shapes("Imagen1").Top = 0
        .Shapes("Imagen1").Left= 0 
	 ELSE
	    .Cells(wfil_ini_rep,wcol_ini_imp).Value = pnom_cia
        .Cells(wfil_ini_rep,wcol_ini_imp).font.bold = .t.     	    
	    .Cells(wfil_ini_rep,wcol_ini_imp).font.size = 09	    
     ENDIF
     *********************************************
     ** Inserta Fecha y Hora **
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).Merge
	 .Cells(wfil_ini_rep,pcolumax-1).Value = 'FECHA :'+ DTOC(DATE())
	 .Cells(wfil_ini_rep,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep,pcolumax-1).font.size = 10
	 *
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).Merge
	 .Cells(wfil_ini_rep+1,pcolumax-1).Value = 'HORA  :'+ TIME()
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.size = 10
     *	    
     *********************************************
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).Merge
     
     .Cells(wcol_ini_rep+2,1).Value = ptitulo
     .Cells(wcol_ini_rep+2,1).HorizontalAlignment = 3     
     .Cells(wcol_ini_rep+2,1).font.bold = .t.     
     .Cells(wcol_ini_rep+2,1).font.size = 09
     *
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).Value = 'FECHA'	
     .Cells(wfil_ini_tit-1,wcol_ini_rep+01).Value = 'TIPO'	     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+02).Value = 'DOCUMENTO'	
     *
	 .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+03),.Cells(wfil_ini_tit-1,wcol_ini_rep+04)).MergeCells = .T.
	 .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+03),.Cells(wfil_ini_tit-1,wcol_ini_rep+04)).Merge
     .Cells(wfil_ini_tit-1,wcol_ini_rep+03).Value = 'MOTIVO'	
     *
     .Cells(wfil_ini_tit-1,wcol_ini_rep+05).Value = 'DOC.REFERENCIA'	
     .Cells(wfil_ini_tit-1,wcol_ini_rep+06).Value = 'O.COMPRA'	     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+07).Value = 'REFERENCIA TRASLADO'	     
     *
     **** UNIDADES
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+08),.Cells(wfil_ini_tit-1,wcol_ini_rep+10)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+08),.Cells(wfil_ini_tit-1,wcol_ini_rep+10)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).Value = 'UNIDADES'
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).font.size = 09     
     *
     **** VALORIZADO EN MONEDA NACIONAL
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+11),.Cells(wfil_ini_tit-1,wcol_ini_rep+13)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+11),.Cells(wfil_ini_tit-1,wcol_ini_rep+13)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).Value = "VALORIZADO EN MONEDA NACIONAL"
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).font.size = 09     
     *
     **** VALORIZADO EN DOLARES
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+14),.Cells(wfil_ini_tit-1,wcol_ini_rep+16)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+14),.Cells(wfil_ini_tit-1,wcol_ini_rep+16)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+14).Value = "VALORIZADO EN DOLARES"
     .Cells(wfil_ini_tit-1,wcol_ini_rep+14).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+14).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+14).font.size = 09     
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+08).Value = 'INGRESOS'	     
     .Cells(wfil_ini_tit,wcol_ini_rep+09).Value = 'SALIDAS'	                    
     .Cells(wfil_ini_tit,wcol_ini_rep+10).Value = 'SALDO'	                         
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+11).Value = 'INGRESOS'	     
     .Cells(wfil_ini_tit,wcol_ini_rep+12).Value = 'SALIDAS'	                    
     .Cells(wfil_ini_tit,wcol_ini_rep+13).Value = 'SALDO'	                         
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+14).Value = 'INGRESOS'	     
     .Cells(wfil_ini_tit,wcol_ini_rep+15).Value = 'SALIDAS'	                    
     .Cells(wfil_ini_tit,wcol_ini_rep+16).Value = 'SALDO'	                         
     *
ENDWITH
*
SELECT "Cur_Kardex"
SET ORDER TO J
&&IdAlmacen+IdSuministro+DTOS(FechaDoc)+Tdoc+NumDoc

wlinea= wfil_ini_dat 
witem = 1
wrecc = 1

GO top
DO WHILE !EOF("cur_kardex")
  	wlinea = wlinea + 1
    lId_Alm = cur_kardex.IdAlmacen 
    ldesAlm = cur_kardex.Almacen
    *
    oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+0), oExcel.Cells(wlinea,pcolumax)).Select
    oExcel.Selection.font.size = 8
    oExcel.Selection.font.bold = .t.
    *
    WITH oExcel.ActiveWorkBook.ActiveSheet
	    .Cells(wlinea,wcol_ini_rep+1).NumberFormat = "@"
   	    .Cells(wlinea,wcol_ini_rep+0).Value = 'ALMACEN'
        .Cells(wlinea,wcol_ini_rep+1).Value = ALLTRIM(ldesAlm)
    ENDWITH
    *     
  	wlinea = wlinea + 1   
    *
	DO WHILE !EOF("cur_kardex") AND IdAlmacen = lId_Alm
	   lId_Sum = cur_kardex.IdSuministro
	   ldesSum = cur_kardex.Suministro
	   *
	   oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+0), oExcel.Cells(wlinea,pcolumax)).Select
       oExcel.Selection.font.colorindex = 1 
       oExcel.Selection.font.size = 8
	   oExcel.Selection.font.bold = .t.
	   *   
	   WITH oExcel.ActiveWorkBook.ActiveSheet
			.Cells(wlinea,wcol_ini_rep+00).NumberFormat = "@"			  
            .Cells(wlinea,wcol_ini_rep+07).NumberFormat = "#,###,##0.00"
            .Cells(wlinea,wcol_ini_rep+09).NumberFormat = "#,###,##0.00"
            .Cells(wlinea,wcol_ini_rep+11).NumberFormat = "#,###,##0.00"            
	        *
	   	    .Cells(wlinea,wcol_ini_rep+00).Value = 'PRODUCTO'
	        *
		    .RANGE(.Cells(wlinea,wcol_ini_rep+01),.Cells(wlinea,wcol_ini_rep+05)).MergeCells = .T.
		    .RANGE(.Cells(wlinea,wcol_ini_rep+01),.Cells(wlinea,wcol_ini_rep+05)).Merge
	   	    .Cells(wlinea,wcol_ini_rep+01).Value = NVL(lDesSum,'')
	        *	    
	  	    wlinea = wlinea + 1		      		      
	   ENDWITH
	   *
	   SCAN WHILE !EOF("cur_kardex") AND IdAlmacen = lId_Alm AND IdSuministro = lId_Sum
	        *
            oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+8), oExcel.Cells(wlinea,pcolumax)).Select
            oExcel.Selection.value = 0
            oExcel.Selection.NumberFormat = "#,###,##0.00"
            
 		    WITH oExcel.ActiveWorkBook.ActiveSheet
				 .Cells(wlinea,wcol_ini_rep+01).NumberFormat = "@"			   
				 .Cells(wlinea,wcol_ini_rep+02).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+03).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+04).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+05).NumberFormat = "@"			   			   
				 .Cells(wlinea,wcol_ini_rep+06).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+07).NumberFormat = "@"			   			   
				 *
				 .Cells(wlinea,wcol_ini_rep+00).Value = NVL(cur_kardex.FechaDoc,'')
				 .Cells(wlinea,wcol_ini_rep+01).Value = NVL(cur_kardex.TDoc,'')				 
				 .Cells(wlinea,wcol_ini_rep+02).Value = NVL(cur_kardex.NumDoc,'')
				 .Cells(wlinea,wcol_ini_rep+03).Value = NVL(cur_kardex.IdMotivo,'')
				 .Cells(wlinea,wcol_ini_rep+04).Value = NVL(cur_kardex.Motivo,'')
				 .Cells(wlinea,wcol_ini_rep+05).Value = NVL(cur_kardex.DocRef1,'')
				 .Cells(wlinea,wcol_ini_rep+06).Value = NVL(cur_kardex.OC,'')				 
				 .Cells(wlinea,wcol_ini_rep+07).Value = NVL(cur_kardex.Doc_Destino,'')
				 *
				 .Cells(wlinea,wcol_ini_rep+08).Value = IIF(cur_kardex.TipMov=1,cur_kardex.cantidad,0)
				 .Cells(wlinea,wcol_ini_rep+09).Value = IIF(cur_kardex.TipMov=1,0,cur_kardex.cantidad)      
				 .Cells(wlinea,wcol_ini_rep+10).Value = cur_kardex.cantidad
				 *
				 .Cells(wlinea,wcol_ini_rep+11).Value = IIF(cur_kardex.TipMov=1,cur_kardex.soles,0)
				 .Cells(wlinea,wcol_ini_rep+12).Value = IIF(cur_kardex.TipMov=1,0,cur_kardex.soles)      
				 .Cells(wlinea,wcol_ini_rep+13).Value = cur_kardex.soles
				 *
				 .Cells(wlinea,wcol_ini_rep+14).Value = IIF(TipMov=1,cur_kardex.dolar,0)
				 .Cells(wlinea,wcol_ini_rep+15).Value = IIF(TipMov=1,0,cur_kardex.dolar)      
				 .Cells(wlinea,wcol_ini_rep+16).Value = cur_kardex.dolar
				 *
		  ENDWITH
		  *
          wrecc  = wrecc  + 1
          witem  = witem  + 1
          wlinea = wlinea + 1
	      *
	   ENDSCAN
	   *
       wprocent = TRANSFORM(wrecc/preccmax*100,"999")+"%"
       wmensaje = "Procesando registro Número "+ transform(wrecc,"999999")+ " de " + TRANSFORM(preccmax,"999999") +" - "+wprocent
       WAIT WINDOW (wmensaje) NOWAIT noclear
       *	
	   wlinea = wlinea + 1	   
	   *
	ENDDO
	*
	wlinea = wlinea + 2
	*
ENDDO
oExcel.Range(oExcel.cells(wfil_ini_dat,wcol_ini_rep), oExcel.Cells(wlinea,pcolumax)).Select
oExcel.Selection.font.size = 8

WAIT clear

oExcel.Range(oExcel.cells(wfil_ini_tit-1,wcol_ini_rep), oExcel.Cells(wfil_ini_tit,pcolumax)).Select
oExcel.Selection.Interior.colorindex = 37
oExcel.Selection.HorizontalAlignment = 3 
oExcel.Selection.font.colorindex = 1 
oExcel.Selection.font.size = 09
oExcel.Selection.font.bold = .t.
oExcel.Selection.borders(1).LineStyle = 1
oExcel.Selection.borders(2).LineStyle = 1
oExcel.Selection.borders(3).LineStyle = 1
oExcel.Selection.borders(4).LineStyle = 1   

oExcel.ActiveSheet.UsedRange.EntireColumn.Autofit
WITH oExcel.ActiveWorkBook.ActiveSheet	
	oExcel.ActiveWindow.SplitColumn=2
	oExcel.ActiveWindow.SplitRow=wfil_ini_tit
	oExcel.ActiveWindow.FreezePanes= .T.
ENDWITH

RETURN


*******************************
PROCEDURE hoja_kardex_detallado
*******************************
ptitulo = "KARDEX GERENCIAL DETALLADO "+wperiodo

wfila      = 0

wfil_ini_rep  = 01
wfil_ini_tit  = 07
wfil_ini_dat  = 08

wcol_ini_rep  = 01
wcol_ini_imp  = 02

pcolumax=19
preccmax=RECCOUNT("cur_kardex")

****** Cabecera *****
WITH oExcel.ActiveWorkBook.ActiveSheet
     *********************************************
     *** Insert Logo *****************************
     IF FILE(wruta_logo+wfile_logo)
	    .Range("A1:A1").Select
	    .Pictures.Insert(wruta_logo+wfile_logo).name="Imagen1"
	    .Shapes("Imagen1").LockAspectRatio = 0
        .Shapes("Imagen1").Top = 0
        .Shapes("Imagen1").Left= 0 
	 ELSE
	    .Cells(wfil_ini_rep,wcol_ini_imp).Value = pnom_cia
        .Cells(wfil_ini_rep,wcol_ini_imp).font.bold = .t.     	    
	    .Cells(wfil_ini_rep,wcol_ini_imp).font.size = 09	    
     ENDIF
     *********************************************
     ** Inserta Fecha y Hora **
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep,pcolumax-1),.Cells(wfil_ini_rep,pcolumax)).Merge
	 .Cells(wfil_ini_rep,pcolumax-1).Value = 'FECHA :'+ DTOC(DATE())
	 .Cells(wfil_ini_rep,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep,pcolumax-1).font.size = 10
	 *
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+1,pcolumax-1),.Cells(wfil_ini_rep+1,pcolumax)).Merge
	 .Cells(wfil_ini_rep+1,pcolumax-1).Value = 'HORA  :'+ TIME()
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.bold = .t.
	 .Cells(wfil_ini_rep+1,pcolumax-1).font.size = 10
     *	    
     *********************************************
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_rep+2,wcol_ini_rep+0),.Cells(wfil_ini_rep+2,pcolumax)).Merge
     
     .Cells(wcol_ini_rep+2,1).Value = ptitulo
     .Cells(wcol_ini_rep+2,1).HorizontalAlignment = 3     
     .Cells(wcol_ini_rep+2,1).font.bold = .t.     
     .Cells(wcol_ini_rep+2,1).font.size = 09
     *
     .Cells(wfil_ini_tit-1,wcol_ini_rep+00).Value = 'FECHA'	
     .Cells(wfil_ini_tit-1,wcol_ini_rep+01).Value = 'TIPO'	     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+02).Value = 'DOCUMENTO'	
     *
	 .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+03),.Cells(wfil_ini_tit-1,wcol_ini_rep+04)).MergeCells = .T.
	 .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+03),.Cells(wfil_ini_tit-1,wcol_ini_rep+04)).Merge
     .Cells(wfil_ini_tit-1,wcol_ini_rep+03).Value = 'MOTIVO'	
     *
     .Cells(wfil_ini_tit-1,wcol_ini_rep+05).Value = 'DOC.REFERENCIA'	
     .Cells(wfil_ini_tit-1,wcol_ini_rep+06).Value = 'O.COMPRA'	     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+07).Value = 'REFERENCIA TRASLADO'	     
     *
     **** UNIDADES
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+08),.Cells(wfil_ini_tit-1,wcol_ini_rep+10)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+08),.Cells(wfil_ini_tit-1,wcol_ini_rep+10)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).Value = 'UNIDADES'
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+08).font.size = 09     
     *
     **** VALORIZADO EN MONEDA NACIONAL
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+11),.Cells(wfil_ini_tit-1,wcol_ini_rep+14)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+11),.Cells(wfil_ini_tit-1,wcol_ini_rep+14)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).Value = "VALORIZADO EN MONEDA NACIONAL"
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+11).font.size = 09     
     *
     **** VALORIZADO EN DOLARES
     *
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+15),.Cells(wfil_ini_tit-1,wcol_ini_rep+18)).MergeCells = .T.
     .RANGE(.Cells(wfil_ini_tit-1,wcol_ini_rep+15),.Cells(wfil_ini_tit-1,wcol_ini_rep+18)).Merge
     
     .Cells(wfil_ini_tit-1,wcol_ini_rep+15).Value = "VALORIZADO EN DOLARES"
     .Cells(wfil_ini_tit-1,wcol_ini_rep+15).HorizontalAlignment = 3
     .Cells(wfil_ini_tit-1,wcol_ini_rep+15).font.bold = .t.
     .Cells(wfil_ini_tit-1,wcol_ini_rep+15).font.size = 09     
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+08).Value = 'INGRESOS'	     
     .Cells(wfil_ini_tit,wcol_ini_rep+09).Value = 'SALIDAS'	                    
     .Cells(wfil_ini_tit,wcol_ini_rep+10).Value = 'SALDO'	                         
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+11).Value = 'INGRESOS'	     
     .Cells(wfil_ini_tit,wcol_ini_rep+12).Value = 'SALIDAS'	                    
     .Cells(wfil_ini_tit,wcol_ini_rep+13).Value = 'SALDO'	                         
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+14).Value = 'C.UNI.'	                              
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+15).Value = 'INGRESOS'	     
     .Cells(wfil_ini_tit,wcol_ini_rep+16).Value = 'SALIDAS'	                    
     .Cells(wfil_ini_tit,wcol_ini_rep+17).Value = 'SALDO'	                         
     *
     .Cells(wfil_ini_tit,wcol_ini_rep+18).Value = 'C.UNI.'	                              
     *
ENDWITH
*

SELECT "Cur_Kardex"
SET ORDER TO J

&&IdAlmacen+IdSuministro+DTOS(FechaDoc)+Tdoc+NumDoc

wlinea= wfil_ini_dat 
witem = 1
wrecc = 1

GO top
DO WHILE !EOF("cur_kardex")
  	wlinea = wlinea + 1
    lId_Alm = cur_kardex.IdAlmacen 
    ldesAlm = cur_kardex.Almacen
    *
    oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+0), oExcel.Cells(wlinea,pcolumax)).Select
    oExcel.Selection.font.size = 8
    oExcel.Selection.font.bold = .t.
    *
    WITH oExcel.ActiveWorkBook.ActiveSheet

	    .Cells(wlinea,wcol_ini_rep+1).NumberFormat = "@"
        .Cells(wlinea,wcol_ini_rep+2).NumberFormat = "@"
        .Cells(wlinea,wcol_ini_rep+4).NumberFormat = "@"         
   
   	    .Cells(wlinea,wcol_ini_rep+0).Value = 'ALMACEN'
        .Cells(wlinea,wcol_ini_rep+1).Value = ALLTRIM(ldesAlm)
             
    ENDWITH
    *     
  	wlinea = wlinea + 1   
    *
	DO WHILE !EOF("cur_kardex") AND IdAlmacen = lId_Alm
	   lId_Sum = cur_kardex.IdSuministro
	   ldesSum = cur_kardex.Suministro
	   *
	   oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+0), oExcel.Cells(wlinea,pcolumax)).Select
       oExcel.Selection.font.colorindex = 1 
       oExcel.Selection.font.size = 8
	   oExcel.Selection.font.bold = .t.
	   *   
	   WITH oExcel.ActiveWorkBook.ActiveSheet

			.Cells(wlinea,wcol_ini_rep+00).NumberFormat = "@"			  
            .Cells(wlinea,wcol_ini_rep+07).NumberFormat = "#,###,##0.00"
            .Cells(wlinea,wcol_ini_rep+09).NumberFormat = "#,###,##0.00"
            .Cells(wlinea,wcol_ini_rep+11).NumberFormat = "#,###,##0.00"            
	        *
	   	    .Cells(wlinea,wcol_ini_rep+00).Value = 'PRODUCTO'
	        *
		    .RANGE(.Cells(wlinea,wcol_ini_rep+01),.Cells(wlinea,wcol_ini_rep+05)).MergeCells = .T.
		    .RANGE(.Cells(wlinea,wcol_ini_rep+01),.Cells(wlinea,wcol_ini_rep+05)).Merge
	   	    .Cells(wlinea,wcol_ini_rep+01).Value = NVL(lDesSum,'')
		    
*!*			    .Cells(wlinea,wcol_ini_rep+06).Value = 'SALDO INICIAL'
*!*	            .Cells(wlinea,wcol_ini_rep+07).Value = 0
*!*	            .Cells(wlinea,wcol_ini_rep+08).Value = 'SALDO INICIAL'
*!*	            .Cells(wlinea,wcol_ini_rep+09).Value = 0
*!*	            .Cells(wlinea,wcol_ini_rep+10).Value = 'C.UNI.INI.'
*!*	            .Cells(wlinea,wcol_ini_rep+11).Value = 0
                                            
	  	    wlinea = wlinea + 1		      		      
	  	    
	   ENDWITH
	   *
	   SCAN WHILE !EOF("cur_kardex") AND IdAlmacen = lId_Alm AND IdSuministro = lId_Sum
	        *
            oExcel.Range(oExcel.cells(wlinea,wcol_ini_rep+8), oExcel.Cells(wlinea,pcolumax)).Select
            oExcel.Selection.value = 0
            oExcel.Selection.NumberFormat = "#,###,##0.00"
            
 		    WITH oExcel.ActiveWorkBook.ActiveSheet
				 .Cells(wlinea,wcol_ini_rep+01).NumberFormat = "@"			   
				 .Cells(wlinea,wcol_ini_rep+02).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+03).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+04).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+05).NumberFormat = "@"			   			   
				 .Cells(wlinea,wcol_ini_rep+06).NumberFormat = "@"
				 .Cells(wlinea,wcol_ini_rep+07).NumberFormat = "@"			   			   
				 *
				 .Cells(wlinea,wcol_ini_rep+00).Value = NVL(cur_kardex.FechaDoc,'')
				 .Cells(wlinea,wcol_ini_rep+01).Value = NVL(cur_kardex.TDoc,'')				 
				 .Cells(wlinea,wcol_ini_rep+02).Value = NVL(cur_kardex.NumDoc,'')
				 .Cells(wlinea,wcol_ini_rep+03).Value = NVL(cur_kardex.IdMotivo,'')
				 .Cells(wlinea,wcol_ini_rep+04).Value = NVL(cur_kardex.Motivo,'')
				 .Cells(wlinea,wcol_ini_rep+05).Value = NVL(cur_kardex.DocRef1,'')
				 .Cells(wlinea,wcol_ini_rep+06).Value = NVL(cur_kardex.OC,'')				 
				 .Cells(wlinea,wcol_ini_rep+07).Value = NVL(cur_kardex.Doc_Destino,'')
				 *
				 .Cells(wlinea,wcol_ini_rep+08).Value = IIF(cur_kardex.TipMov=1,cur_kardex.cantidad,0)
				 .Cells(wlinea,wcol_ini_rep+09).Value = IIF(cur_kardex.TipMov=1,0,cur_kardex.cantidad)      
				 .Cells(wlinea,wcol_ini_rep+10).Value = cur_kardex.cantidad
				 *
				 .Cells(wlinea,wcol_ini_rep+11).Value = IIF(cur_kardex.TipMov=1,cur_kardex.soles,0)
				 .Cells(wlinea,wcol_ini_rep+12).Value = IIF(cur_kardex.TipMov=1,0,cur_kardex.soles)      
				 .Cells(wlinea,wcol_ini_rep+13).Value = cur_kardex.soles
				 *
				 .Cells(wlinea,wcol_ini_rep+14).Value = IIF((cur_kardex.soles>0 and cur_kardex.cantidad>0),ROUND(cur_kardex.soles/cur_kardex.cantidad,2),0)
				 *
				 .Cells(wlinea,wcol_ini_rep+15).Value = IIF(TipMov=1,cur_kardex.dolar,0)
				 .Cells(wlinea,wcol_ini_rep+16).Value = IIF(TipMov=1,0,cur_kardex.dolar)      
				 .Cells(wlinea,wcol_ini_rep+17).Value = cur_kardex.dolar
				 *
				 .Cells(wlinea,wcol_ini_rep+18).Value = IIF((cur_kardex.dolar>0 and cur_kardex.cantidad>0),ROUND(cur_kardex.dolar/cur_kardex.cantidad,2),0)
				 *
		  ENDWITH
		  *
          wrecc  = wrecc  + 1
          witem  = witem  + 1
          wlinea = wlinea + 1
	      *
	   ENDSCAN
	   *
       wprocent = TRANSFORM(wrecc/preccmax*100,"999")+"%"
       wmensaje = "Procesando registro Número "+ transform(wrecc,"999999")+ " de " + TRANSFORM(preccmax,"999999") +" - "+wprocent
       WAIT WINDOW (wmensaje) NOWAIT noclear
       *	
	   wlinea = wlinea + 1	   
	   *
	ENDDO
	*
	wlinea = wlinea + 2
	*
ENDDO
oExcel.Range(oExcel.cells(wfil_ini_dat,wcol_ini_rep), oExcel.Cells(wlinea,pcolumax)).Select
oExcel.Selection.font.size = 8

WAIT clear

oExcel.Range(oExcel.cells(wfil_ini_tit-1,wcol_ini_rep), oExcel.Cells(wfil_ini_tit,pcolumax)).Select
oExcel.Selection.Interior.colorindex = 37
oExcel.Selection.HorizontalAlignment = 3 
oExcel.Selection.font.colorindex = 1 
oExcel.Selection.font.size = 09
oExcel.Selection.font.bold = .t.
oExcel.Selection.borders(1).LineStyle = 1
oExcel.Selection.borders(2).LineStyle = 1
oExcel.Selection.borders(3).LineStyle = 1
oExcel.Selection.borders(4).LineStyle = 1   

oExcel.ActiveSheet.UsedRange.EntireColumn.Autofit
WITH oExcel.ActiveWorkBook.ActiveSheet	
	oExcel.ActiveWindow.SplitColumn=2
	oExcel.ActiveWindow.SplitRow=wfil_ini_tit
	oExcel.ActiveWindow.FreezePanes= .T.
ENDWITH

RETURN


***********************
PROCEDURE conecta
***********************
PARAMETERS pserver,pdatabase,puser,pclave,pdriver
lcDSNLess="driver={SQL Server};server="+pserver+";Database="+pdatabase+";uid="+puser+";pwd="+pclave
STORE SQLSTRINGCONNECT(lcDSNLess) TO wdriver
IF  wdriver < 0
   =MESSAGEBOX("No se conecto a:"+lcDSNLess,48) 
   werror=1
ENDIF
retu


***********************
PROCEDURE desconecta
***********************
IF wdriver>0
  =SQLDISCONNECT(wdriver)
endif
retu

