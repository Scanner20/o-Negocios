*** 
*** ReFox XI+  #IT489753  Victor  EMBRACE [VFP70]
***
**
FUNCTION SALDOS
 PARAMETER m1, sw
 SELECT sldconta
 suma_d = 0.00 
 suma_h = 0.00 
 FOR i = 0 TO m1-1
    campo = 'D_Mof_'+ALLTRIM(STR(i))
    suma_d = suma_d + &campo
    campo = 'H_Mof_'+ALLTRIM(STR(i))
    suma_h = suma_h + &campo
 ENDFOR
 sldant = suma_d-suma_h
 campo = 'D_Mof_'+ALLTRIM(STR(m1))
 debemes = &campo
 campo = 'H_Mof_'+ALLTRIM(STR(m1))
 habermes = &campo
 sldact = sldant+debemes-habermes
 DO CASE
    CASE sw=1
       RETURN sldant
    CASE sw=2
       RETURN debemes
    CASE sw=3
       RETURN habermes
    CASE sw=4
       RETURN sldact
 ENDCASE
 RETURN
ENDFUNC
**
PROCEDURE MAYOR
 PARAMETER p1
 mesx = ALLTRIM(STR(MONTH(a_fecha)))
 DO CASE
    CASE p1=1
       var = 'D_MOF_'+mesx
    CASE p1=2
       var = 'H_MOF_'+mesx
    CASE p1=3
       var = 'D_CONV_'+mesx
    CASE p1=4
       var = 'H_CONV_'+mesx
 ENDCASE
 var = 'Sldconta->'+var
 RETURN &VAR
ENDPROC
**
FUNCTION SLDINI
 PARAMETER p1, p2
 v_desde = 0
 v_hasta = MONTH(a_fecha)-1
 IF  .NOT. EMPTY(p2)
    v_desde = p2
    v_hasta = p2
 ENDIF
 vd1 = 0
 vh1 = 0
 vd2 = 0
 vh2 = 0
 FOR i = v_desde TO v_hasta
    vard1 = 'Sldconta->D_Mof_'+ALLTRIM(STR(i))
    varh1 = 'Sldconta->H_Mof_'+ALLTRIM(STR(i))
    vard2 = 'Sldconta->D_Conv_'+ALLTRIM(STR(i))
    varh2 = 'Sldconta->H_Conv_'+ALLTRIM(STR(i))
    vd1 = vd1 + &vard1
    vh1 = vh1 + &varh1
    vd2 = vd2 + &vard2
    vh2 = vh2 + &varh2
 ENDFOR
 DO CASE
    CASE p1=1
       RETURN vd1
    CASE p1=2
       RETURN vh1
    CASE p1=3
       RETURN vd2
    CASE p1=4
       RETURN vh2
 ENDCASE
 RETURN
ENDFUNC
**
FUNCTION SLDACOSTO
 PARAMETER p1
 vd1 = 0
 vh1 = 0
 vd2 = 0
 vh2 = 0
 FOR i = 0 TO MONTH(a_fecha)-1
    vard1 = 'Sldcosto->D_Mof_'+ALLTRIM(STR(i))
    varh1 = 'Sldcosto->H_Mof_'+ALLTRIM(STR(i))
    vard2 = 'Sldcosto->D_Conv_'+ALLTRIM(STR(i))
    varh2 = 'Sldcosto->H_Conv_'+ALLTRIM(STR(i))
    vd1 = vd1 + &vard1
    vh1 = vh1 + &varh1
    vd2 = vd2 + &vard2
    vh2 = vh2 + &varh2
 ENDFOR
 DO CASE
    CASE p1=1
       RETURN vd1
    CASE p1=2
       RETURN vh1
    CASE p1=3
       RETURN vd2
    CASE p1=4
       RETURN vh2
 ENDCASE
 RETURN
ENDFUNC
**
FUNCTION SLDCCOSTO
 PARAMETER p1
 vd1 = 0
 vh1 = 0
 vd2 = 0
 vh2 = 0
 FOR i = 0 TO MONTH(a_fecha)-1
    vard1 = 'Sld->D_Mof_'+ALLTRIM(STR(i))
    varh1 = 'Sld->H_Mof_'+ALLTRIM(STR(i))
    vard2 = 'Sld->D_Conv_'+ALLTRIM(STR(i))
    varh2 = 'Sld->H_Conv_'+ALLTRIM(STR(i))
    vd1 = vd1 + &vard1
    vh1 = vh1 + &varh1
    vd2 = vd2 + &vard2
    vh2 = vh2 + &varh2
 ENDFOR
 DO CASE
    CASE p1=1
       RETURN vd1
    CASE p1=2
       RETURN vh1
    CASE p1=3
       RETURN vd2
    CASE p1=4
       RETURN vh2
 ENDCASE
 RETURN
ENDFUNC
**
FUNCTION Sldinix
 PARAMETER xmes, p1
 vd1 = 0
 vh1 = 0
 vd2 = 0
 vh2 = 0
 FOR i = 0 TO xmes-1
    vard1 = 'Sldconta->D_Mof_'+ALLTRIM(STR(i))
    varh1 = 'Sldconta->H_Mof_'+ALLTRIM(STR(i))
    vard2 = 'Sldconta->D_Conv_'+ALLTRIM(STR(i))
    varh2 = 'Sldconta->H_Conv_'+ALLTRIM(STR(i))
    vd1 = vd1 + &vard1
    vh1 = vh1 + &varh1
    vd2 = vd2 + &vard2
    vh2 = vh2 + &varh2
 ENDFOR
 DO CASE
    CASE p1=1
       RETURN vd1
    CASE p1=2
       RETURN vh1
    CASE p1=3
       RETURN vd2
    CASE p1=4
       RETURN vh2
 ENDCASE
 RETURN
ENDFUNC
**
PROCEDURE sumax
 IF VAL(mes)=mes_1
    sh1 = sh1+resh1
    sd1 = sd1+resd1
    sh2 = sh2+resh2
    sd2 = sd2+resd2
 ENDIF
ENDPROC
**
PROCEDURE ini_suma
 sh1 = 0
 sd1 = 0
 sh2 = 0
 sd2 = 0
 RETURN
ENDPROC
**
FUNCTION FILE_NAME
 PARAMETER prefijo, v_sw
 v_sw = UPPER(v_sw)
 IF LEN(prefijo)=2
    prefijo = prefijo+'_'+v_sw
 ELSE
    prefijo = prefijo+v_sw
 ENDIF
 aa = YEAR(a_fecha)-INT(YEAR(a_fecha)/100)*100
 IF aa<10
    aapro = '0'+ALLTRIM(STR(aa))
 ELSE
    aapro = ALLTRIM(STR(aa))
 ENDIF
 mm = MONTH(a_fecha)
 IF mm<10
    mmprox = '0'+ALLTRIM(STR(mm))
 ELSE
    mmprox = ALLTRIM(STR(mm))
 ENDIF
 file = prefijo+aapro+mmprox
 RETURN file
ENDFUNC
**
FUNCTION OPEN_A
 PARAMETER prefijo, idx1, idx2
 file_c = a_ruta+file_name(prefijo, 'C')
 IF  .NOT. vry_files(prefijo, 'c')
    RETURN .F.
 ENDIF
 SELECT 0
 USE &file_c
 SET ORDER TO IDX1
 file_c = a_ruta+file_name(prefijo, 'L')
 IF  .NOT. vry_files(prefijo, 'l')
    SET SKIP OF MENU _MSYSMENU .F.
    RETURN .F.
 ENDIF
 SELECT 0
 USE &file_c
 SET ORDER TO IDX2
 RETURN
ENDFUNC
**
FUNCTION OPEN_CL
 PARAMETER prefijo, sw, in1
 sw = UPPER(sw)
 file_c = a_ruta_exe+a_ruta+file_name(prefijo, sw)
 IF  .NOT. seek_files(file_name(prefijo, sw))
    SET SKIP OF MENU _MSYSMENU .F.
    RETURN .F.
 ENDIF
 SELECT 0
 USE &file_c
 SET ORDER TO IN1
 RETURN
ENDFUNC
**
FUNCTION OPEN_FILE
 PARAMETER nombre, in1
 j_file = a_ruta+nombre
 IF  .NOT. seek_files(nombre)
    SET SKIP OF MENU _MSYSMENU .F.
    RETURN .F.
 ENDIF
 SELECT 0
 USE &j_file
 SET ORDER TO IN1
 RETURN
ENDFUNC
**
FUNCTION VRY_FILES
 PARAMETER v_prefijo, v_sw, imagen1
 SET SAFETY OFF
 v_prefijo = UPPER(v_prefijo)
 vbd_ = ''
 v_prefijo1 = LEFT(v_prefijo, 2)
 DO CASE
    CASE v_prefijo1='CO'
       vbd_ = "CONTA"
    CASE INLIST(v_prefijo1, 'FA', 'FAP')
       vbd_ = "FACTU"
    CASE LEFT(v_prefijo1, 2)='FI'
       vbd_ = "FINAN"
    CASE v_prefijo1='AL'
       vbd_ = "ALMACEN"
    CASE v_prefijo1='CM'
       vbd_ = "COMPRAS"
    CASE v_prefijo1='IM'
       vbd_ = "IMPOR"
    CASE v_prefijo1='PR'
       vbd_ = "PRESU"
    CASE v_prefijo1='AF'
       vbd_ = "ACTIVOS"
 ENDCASE
 vproc_ok = .T.
 vmsg = ''
 IF  .NOT. EMPTY(vbd_)
    kk = a_ruta_exe+'Bd\Estruct\'
    v_sw = UPPER(v_sw)
    IF  .NOT. FILE(a_ruta+file_name(v_prefijo, v_sw)+'.DBF')
       IF MESSAGEBOX("Archivo de Movimiento al mes de "+ALLTRIM(CMONTH(a_fecha))+" del "+ALLTRIM(STR(YEAR(a_fecha)))+" no existe"+CHR(13)+"                      ¿ Desea Crearlo ?    ", 036, "Aviso DatEasy")=6
          vcopia_dest = a_ruta+file_name(v_prefijo, v_sw)
          SELECT 0
          vopen_file_estru = kk+imagen1
          IF  .NOT. FILE(vopen_file_estru+'.DBF')
             vmsg = 'Estructura '+imagen1+' no se encuentra '+"Contactar con su proveedor"
             vproc_ok = .F.
          ELSE
             IF FILE(a_ruta+vbd_+'.DBC')
                USE &vopen_file_estru
                vbd_add = a_ruta+vbd_
                COPY STRU TO &vcopia_dest WITH CDX DATABASE &vbd_add
                USE
                IF v_sw="C"
                   CREATE TRIGGER ON &vcopia_dest FOR DELETE  AS __ri_delete_cabecera()
                   CREATE TRIGGER ON &vcopia_dest FOR UPDATE  AS __ri_update_cabecera()
                ENDIF
                IF v_sw="L"
                   CREATE TRIGGER ON &vcopia_dest FOR INSERT  AS __ri_altera_linea()
                   CREATE TRIGGER ON &vcopia_dest FOR UPDATE  AS __ri_altera_linea()
                ENDIF
                IF INLIST(v_sw, 'C', 'L')
                   vlinea = a_ruta+file_name(v_prefijo, "L")
                   vcabeza = a_ruta+file_name(v_prefijo, "C")
                   IF FILE(vlinea+'.DBF') .AND. FILE(vcabeza+'.DBF')
                      SELECT 0
                      valias = ("__CA"+LTRIM(STR(SELECT())))
                      USE &vcabeza AGAIN ALIAS vcabece_
                      vind_pk = dat_primary(1)
                      vkey_pk = dat_primary(2)
                      vnombre_ori = DBF()
                      vnombre_ori = SUBSTR(vnombre_ori, RAT("\", vnombre_ori)+1)
                      vnombre_ori = SUBSTR(vnombre_ori, 1, AT(".", vnombre_ori)-1)
                      ALTER TABLE &vlinea ADD FOREIGN KEY &vkey_pk TAG &vind_pk REFERENCES &vnombre_ori
                      valiasl_ = file_name(v_prefijo, "L")
                      SELECT &valiasl_
                      USE
                      USE IN (VAL(SUBSTR(valias, 5)))
                   ENDIF
                ENDIF
             ELSE
                vproc_ok = .F.
                vmsg = "Base de datos "+vbd_+" no existe "+"Contactar con su proveedor"
             ENDIF
          ENDIF
       ELSE
          vproc_ok = .F.
       ENDIF
    ENDIF
 ELSE
    vproc_ok = .F.
    vmsg = "No existe base de datos para este modulo "+"Contactar con su proveedor"
 ENDIF
 IF  .NOT. vproc_ok .AND.  .NOT. EMPTY(vmsg)
    = MESSAGEBOX(vmsg, 16, "Aviso DatEasy")
 ENDIF
 OPEN DATABASE (a_ruta+vbd_)
 RETURN vproc_ok
ENDFUNC
**
FUNCTION SEEK_FILES
 LPARAMETERS name_f_, ruta_de_archivo, no_esta_en_modulo
 name_f = ''
 vtcomas = 1
 FOR vtni = 1 TO LEN(name_f_)
    vtcomas = vtcomas+IIF(SUBSTR(name_f_, vtni, 1)=',', 1, 0)
    IF  .NOT. EMPTY(SUBSTR(name_f_, vtni, 1))
       name_f = name_f+SUBSTR(name_f_, vtni, 1)
    ENDIF
 ENDFOR
 vtni_ = 1
 total_cadena = ''
 FOR vtfiles = 1 TO vtcomas
    vfile = ''
    FOR vtni = vtni_ TO LEN(name_f)
       total_cadena = total_cadena+SUBSTR(name_f, vtni, 1)
       IF SUBSTR(name_f, vtni, 1)=','
          EXIT
       ENDIF
       vfile = vfile+ALLTRIM(SUBSTR(name_f, vtni, 1))
    ENDFOR
    vtni_ = LEN(total_cadena)+1
    IF  .NOT. FILE(ALLTRIM(ruta_de_archivo)+vfile)
       msg = 'El Archivo '+vfile+' no existe'+CHR(13)+'Probablemente a sido movido o eliminado'+CHR(13)+'Es necesario la existencia de este archivo'+CHR(13)+'Dentro de la carpeta  '+ruta_de_archivo+CHR(13)+'Para seguir el proceso.Imposible continuar'
       = MESSAGEBOX(msg, 16, "Aviso DatEasy")
       IF  .NOT. no_esta_en_modulo
          = exit_systema()
       ELSE
          = exit_systema(.T.)
       ENDIF
       RETURN .F.
    ENDIF
 ENDFOR
ENDFUNC
**
PROCEDURE ELM
 PARAMETER m
 var1 = 'D_Mof_'+ALLTRIM(STR(MONTH(a_fecha)))
 var2 = 'H_Mof_'+ALLTRIM(STR(MONTH(a_fecha)))
 var3 = 'D_Conv_'+ALLTRIM(STR(MONTH(a_fecha)))
 var4 = 'H_Conv_'+ALLTRIM(STR(MONTH(a_fecha)))
 DO CASE
    CASE m=1
       RETURN &var1
    CASE m=2
       RETURN &var2
    CASE m=3
       RETURN &var3
    CASE m=4
       RETURN &var4
    CASE m=5
       RETURN &var5
 ENDCASE
 RETURN
ENDPROC
**
PROCEDURE CAMP
 PARAMETER m
 DO CASE
    CASE m='L'
       SELECT &file_lines
    CASE m='C'
       SELECT &file_cab
 ENDCASE
 RETURN
ENDPROC
**
FUNCTION SLDCAJA
 PARAMETER limite, varia, nomtab
 t_a_b_l_a = IIF( .NOT. EMPTY(nomtab), ALLTRIM(nomtab)+'.', '')
 STORE 0 TO ingreso, egreso
 FOR td = 0 TO limite
    STORE 0 TO montoi, montoe
    montoi = t_a_b_l_a+'Ing_'+STRTRAN(STR(td, 2), ' ', '0')
    montoe = t_a_b_l_a+'Egr_'+STRTRAN(STR(td, 2), ' ', '0')
    ingreso = ingreso + &montoi
    egreso  = egreso  + &montoe
 ENDFOR
 sant = ingreso-egreso
 DO CASE
    CASE UPPER(varia)='SA'
       RETURN sant
    CASE UPPER(varia)='I'
       RETURN ingreso
    CASE UPPER(varia)='E'
       RETURN egreso
 ENDCASE
ENDFUNC
**
FUNCTION VAL_CIEMES
 PARAMETER ssi
 valias = ALIAS()
 vreturn = .T.
 titu = 'Cierre de mes'
 IF  .NOT. FILE(a_ruta+ssi+'.dbf')
    mm = 'Finalizacion del Programa, Archivo de entorno no existe'+CHR(13)+'Nombre : '+a_ruta+ssi+'.dbf'
    = MESSAGEBOX(mm, 48, titu)
    vreturn = .F.
 ELSE
    USE &a_ruta&ssi AGAIN ALIAS en__t IN 0
    SELECT en__t
    IF  .NOT. ALLTRIM(STR(YEAR(a_fecha)))$ALLTRIM(STR(ano_c1)) .AND.  .NOT. ALLTRIM(STR(YEAR(a_fecha)))$ALLTRIM(STR(ano_c2))
       mm = 'Años no coinciden .. Verificar entorno '
       = MESSAGEBOX(mm, 48, titu)
       vreturn = .F.
    ELSE
       IF YEAR(a_fecha)=ano_c1
          mesc = 'Mes_c1_'+ALLTRIM(STR(MONTH(a_fecha)))
       ELSE
          mesc = 'Mes_c2_'+ALLTRIM(STR(MONTH(a_fecha)))
       ENDIF
       IF &mesc = 'C'
          = MESSAGEBOX("Mes  "+ALLTRIM(CMONTH(a_fecha))+" del "+ALLTRIM(STR(YEAR(a_fecha)))+" ha sido cerrado "+CHR(13), 48, "Aviso DatEasy")
          vreturn = .F.
       ENDIF
    ENDIF
 ENDIF
 IF USED('EN__T')
    USE IN en__t
 ENDIF
 IF  .NOT. EMPTY(valias)
    SELECT &valias
 ENDIF
 RETURN vreturn
ENDFUNC
**
FUNCTION DTCAMBIO
 PARAMETER tc, fecha, vmon
 IF EMPTY(vmon)
    mo = '02'
 ELSE
    mo = vmon
 ENDIF
 ano = ALLTRIM(STR(YEAR(fecha)))
 mm = IIF(LEN(ALLTRIM(STR(MONTH(fecha))))=1, '0'+ALLTRIM(STR(MONTH(fecha))), ALLTRIM(STR(MONTH(fecha))))
 busca = mo+ano+mm
 IF SEEK(busca, 'Co_tipca', 'Master')
    tc = IIF(tc='V', 'TCV_', 'TCC_')
    tc = tc+ALLTRIM(STR(DAY(fecha)))
    tc = 'CO_TIPCA.'+tc
    tc = &tc
 ELSE
    tc = 0.00 
    DO CASE
       CASE mo="02"
          WAIT WINDOW 'Tipo de cambio de Dólares no existe'
       CASE mo="03"
          WAIT WINDOW 'Tipo de cambio de Marco a Dólares no existe'
       CASE mo="04"
          WAIT WINDOW 'Tipo de cambio de Yenes a Dólares no existe'
       CASE mo="05"
          WAIT WINDOW 'Tipo de cambio de Euros a Dólares no existe'
    ENDCASE
 ENDIF
 RETURN tc
ENDFUNC
**
PROCEDURE CUADRALINEAS
 PARAMETER dmo, hmo, dme, hme
 IF dmo=hmo .AND. dme=hme
    RETURN
 ENDIF
 d = 0.00 
 d = IIF(dmo>hmo, dmo-hmo, hmo-dmo)
 ma = IIF(dmo>hmo, 'D', 'H')
 SELECT temporal
 DELETE FROM TEMPORAL WHERE EMPTY(cta)
 GOTO BOTTOM IN temporal
 IF dme=hme
    IF ma='D'
       IF haber_mof>0
          REPLACE haber_mof WITH haber_mof+d
       ELSE
          REPLACE debe_mof WITH debe_mof-d
       ENDIF
    ELSE
       IF debe_mof>0
          REPLACE debe_mof WITH debe_mof+d
       ELSE
          REPLACE haber_mof WITH haber_mof-d
       ENDIF
    ENDIF
 ENDIF
 d1 = 0.00 
 d1 = IIF(dme>hme, dme-hme, hme-dme)
 ma1 = IIF(dme>hme, 'D', 'H')
 IF dmo=hmo
    IF ma1='D'
       IF haber_mex>0
          REPLACE haber_mex WITH haber_mex+d1
       ELSE
          REPLACE debe_mex WITH debe_mex-d1
       ENDIF
    ELSE
       IF debe_mex>0
          REPLACE debe_mex WITH debe_mex+d1
       ELSE
          REPLACE haber_mex WITH haber_mex-d1
       ENDIF
    ENDIF
 ENDIF
 SUM debe_mof, haber_mof, debe_mex, haber_mex TO dmof, hmof, dmex, hmex 
 GOTO BOTTOM IN temporal
 IF  .NOT. EMPTY(m.t_cambio)
    IF mon_ext='02'
       IF dmof<>hmof
          REPLACE debe_mof WITH debe_mex*m.t_cambio
          REPLACE haber_mof WITH haber_mex*m.t_cambio
       ENDIF
       REPLACE debe_conv WITH debe_mex
       REPLACE haber_conv WITH haber_mex
    ELSE
       IF dmex<>hmex
          REPLACE debe_mex WITH debe_mof/m.t_cambio
          REPLACE haber_mex WITH haber_mof/m.t_cambio
       ENDIF
       REPLACE debe_conv WITH debe_mex
       REPLACE haber_conv WITH haber_mex
    ENDIF
 ENDIF
 GOTO TOP
 RETURN
ENDPROC
**
FUNCTION VER_LINE
 LPARAMETERS tablat
 tabla1 = ALIAS()
 SELECT &tablat
 GOTO TOP
 contador = 0
 DO WHILE  .NOT. EMPTY(cta)
    IF stat='E'
       SELECT &tabla1
       RETURN .F.
    ENDIF
    contador = contador+1
    SKIP
 ENDDO
 SELECT &tabla1
 IF contador=0
    RETURN .F.
 ENDIF
 RETURN
ENDFUNC
**
FUNCTION ANULADCAJA
 PARAMETER cei, oo
 SELECT cabecera
 clave1 = oper_fin
 clave2 = nro_sec
 banco = bco
 moneda = mon
 _fecha_ = fch_conta
 montot = IIF(cei='E' .AND. mon='02', cargo_con, IIF(cei='E' .AND. mon='01', cargo_mof, IIF(cei='I' .AND. mon='02', abono_con, abono_mof)))
 tipod = IIF(cei='E' .AND. oo='C', 'P', IIF(cei='I' .AND. oo='C', 'C', ''))
 tabla = IIF(cei='E', 'Fi_ctapg', 'Fi_ctact')
 SELECT &tabla
 indice = TAG()
 SET ORDER TO ADCAJA
 SELECT linea
 contador_registros_anticipo = 0
 SCAN FOR oper_fin=clave1 .AND. nro_sec=clave2
    IF tipo_apl=tipod .AND. flg_doc="A"
       coa_tmp = coa
       doc_tmp = doc
       docs_tmp = doc_serie
       docn_tmp = doc_nro
       SELECT &tabla
       contador_registros_anticipo = 0
       = SEEK(coa_tmp+doc_tmp+docs_tmp+docn_tmp)
       DO WHILE coa=coa_tmp .AND. doc=doc_tmp .AND. doc_serie=docs_tmp .AND. doc_nro=docn_tmp .AND.  .NOT. EOF()
          contador_registros_anticipo = contador_registros_anticipo+1
          SKIP
       ENDDO
       IF contador_registros_anticipo>1
          EXIT
       ENDIF
    ENDIF
    SELECT linea
 ENDSCAN
 IF contador_registros_anticipo>1
    msg = "No es posible realizar la Anulación de este Documento, debido a que"+CHR(13)+"a alguno(s) de los Anticipos registrados en el Detalle del mismo se"+CHR(13)+"les ha efectuado uno o mas "+IIF(tipod="C", "Cobros", "Pagos")+"."
    RELEASE contador_registros_anticipo
    MESSAGEBOX(msg, 16, "Aviso DatEasy")
    SELECT &tabla
    SET ORDER TO TAG &indice
    RETURN .F.
 ENDIF
 RELEASE contador_registros_anticipo
 SELECT linea
 SCAN FOR oper_fin=clave1 .AND. nro_sec=clave2
    REPLACE stat WITH 'X'
    IF tipo_apl=tipod
       coa_tmp = coa
       doc_tmp = doc
       docs_tmp = doc_serie
       docn_tmp = doc_nro
       SELECT &tabla
       IF SEEK(coa_tmp+doc_tmp+docs_tmp+docn_tmp+clave1+STR(clave2))
          DELETE
          = SEEK(coa_tmp+doc_tmp+docs_tmp+docn_tmp)
          DO WHILE coa=coa_tmp .AND. doc=doc_tmp .AND. doc_serie=docs_tmp .AND. doc_nro=docn_tmp .AND.  .NOT. EOF()
             REPLACE stat_canc WITH ''
             SKIP
          ENDDO
       ENDIF
    ENDIF
    SELECT linea
 ENDSCAN
 IF oo='C'
    SELECT saldo
    key1 = moneda+banco
    IF cei='E'
       dia_mov = 'Egr_'+STRTRAN(STR(DAY(_fecha_), 2), ' ', '0')
    ELSE
       dia_mov = 'Ing_'+STRTRAN(STR(DAY(_fecha_), 2), ' ', '0')
    ENDIF
    IF SEEK(key1)
       DO WHILE .T.
          IF RLOCK()
             REPLACE &dia_mov WITH &dia_mov - montot
          ELSE
             WAIT WINDOW NOWAIT 'Espere intentando grabar...'
             LOOP
          ENDIF
          UNLOCK
          EXIT
       ENDDO
    ELSE
       = MESSAGEBOX('No se ha podido descargar la transaccion '+CHR(13)+'de este codigo de banco.  Es posible que se '+CHR(13)+'desactualize su saldo. Verifique la operación.', 32, "Aviso DatEasy")
    ENDIF
 ENDIF
 SELECT &tabla
 SET ORDER TO TAG &indice
 SELECT cabecera
 REPLACE stat WITH 'X'
 IF oo='C'
    = cuadrebco(ing_egr, bco, mon, oper_fin, nro_sec)
 ENDIF
 RETURN
ENDFUNC
**
FUNCTION NLETRA
 PARAMETER expresionnumerica
 SET DECIMALS TO 2
 DIMENSION palabras(12)
 palabras = SPACE(12)
 DIMENSION digitos(10)
 digitos(1) = ""
 digitos(2) = "Un "
 digitos(3) = "Dos "
 digitos(4) = "Tres "
 digitos(5) = "Cuatro "
 digitos(6) = "Cinco "
 digitos(7) = "Seis "
 digitos(8) = "Siete "
 digitos(9) = "Ocho "
 digitos(10) = "Nueve "
 IF expresionnumerica<1
    expresionnumerica = STR(expresionnumerica, 12, 2)
    string = 'Cero  y '+SUBSTR(expresionnumerica, 11, 2)+'/100'
    RETURN string
 ENDIF
 expresionnumerica = STR(expresionnumerica, 12, 2)
 string = ''
 xx = 1
 DO initstng
 DO WHILE .T.
    IF xx>=10
       EXIT
    ENDIF
    IF palabras(xx)>' '
       DO cientos
    ENDIF
    xx = xx+1
    IF palabras(xx)>' '
       IF palabras(xx)='Un '
          xx = xx+1
          DO decenas
          DO millon
          xx = xx+1
          LOOP
       ELSE
          DO unidades
          IF palabras(xx+1)>' '
             string = string+'y '
          ENDIF
       ENDIF
    ENDIF
    xx = xx+1
    IF palabras(xx)>' '
       string = string+digitos(VAL(SUBSTR(expresionnumerica, xx, 1))+1)
    ENDIF
    DO millon
    xx = xx+1
 ENDDO
 string = string+'con '+SUBSTR(expresionnumerica, 11, 2)+'/100'
 IF ("un millones"$string) .AND. (AT("Un Millones", string)=1)
    string = "Un Millón"+SUBSTR(string, 12, LEN(string)-12)
 ENDIF
 RETURN string
ENDFUNC
**
PROCEDURE millon
 DO CASE
    CASE xx=3
       IF palabras(1)>' ' .OR. palabras(2)>' ' .OR. palabras(3)>' '
          string = string+'Millones '
       ENDIF
    CASE xx=6
       IF palabras(4)>' ' .OR. palabras(5)>' ' .OR. palabras(6)>' '
          string = string+'Mil '
       ENDIF
 ENDCASE
ENDPROC
**
PROCEDURE cientos
 DO CASE
    CASE palabras(xx)==''
       string = string+'Cien '
    CASE palabras(xx)='Un '
       IF (palabras(xx+1)>' ' .OR. palabras(xx+2)>' ')
          string = string+'Ciento '
       ELSE
          string = string+'Cien '
       ENDIF
    CASE palabras(xx)='Dos '
       string = string+'Doscientos '
    CASE palabras(xx)='Tres '
       string = string+'Trescientos '
    CASE palabras(xx)='Cuatro '
       string = string+'Cuatrocientos '
    CASE palabras(xx)='Cinco '
       string = string+'Quinientos '
    CASE palabras(xx)='Seis '
       string = string+'Seiscientos '
    CASE palabras(xx)='Siete '
       string = string+'Setecientos '
    CASE palabras(xx)='Ocho '
       string = string+'Ochocientos '
    CASE palabras(xx)='Nueve '
       string = string+'Novecientos '
 ENDCASE
 RETURN
ENDPROC
**
PROCEDURE decenas
 DO CASE
    CASE palabras(xx)==''
       string = string+'Diez '
    CASE palabras(xx)='Un '
       string = string+'Once '
    CASE palabras(xx)='Dos '
       string = string+'Doce '
    CASE palabras(xx)='Tres '
       string = string+'Trece '
    CASE palabras(xx)='Cuatro '
       string = string+'Catorce '
    CASE palabras(xx)='Cinco '
       string = string+'Quince '
    CASE palabras(xx)='Seis '
       string = string+'Qieciseis '
    CASE palabras(xx)='Siete '
       string = string+'Diecisiete '
    CASE palabras(xx)='Ocho '
       string = string+'Dieciocho '
    CASE palabras(xx)='Nueve '
       string = string+'Diecinueve '
 ENDCASE
 RETURN
ENDPROC
**
PROCEDURE unidades
 DO CASE
    CASE palabras(xx)==''
       RETURN
    CASE palabras(xx)='Un '
       string = string+'Diez '
    CASE palabras(xx)='Dos '
       string = string+'Veinte '
    CASE palabras(xx)='Tres '
       string = string+'Treinta '
    CASE palabras(xx)='Cuatro '
       string = string+'Cuarenta '
    CASE palabras(xx)='Cinco '
       string = string+'Cincuenta '
    CASE palabras(xx)='Seis '
       string = string+'Sesenta '
    CASE palabras(xx)='Siete '
       string = string+'Setenta '
    CASE palabras(xx)='Ocho '
       string = string+'Ochenta '
    CASE palabras(xx)='Nueve '
       string = string+'Noventa '
 ENDCASE
 RETURN
ENDPROC
**
PROCEDURE initstng
 DO WHILE .T.
    IF xx>12
       EXIT
    ENDIF
    DO CASE
       CASE SUBSTR(expresionnumerica, xx, 1)='.'
          palabras(xx) = 'y'
       CASE SUBSTR(expresionnumerica, xx, 1)=' '
          palabras(xx) = ' '
       OTHERWISE
          ultimaposiciondecimal = VAL(SUBSTR(expresionnumerica, xx, 1))
          palabras(xx) = digitos(ultimaposiciondecimal+1)
    ENDCASE
    xx = xx+1
 ENDDO
 xx = 1
 RETURN
ENDPROC
**
FUNCTION BOPET
 PARAMETER opt
 IF EMPTY(opt)
    mm = ' Tipo de operación esta vacia seleccione un tipo para continuar ...'
    = MESSAGEBOX(mm, 48, "Aviso DatEasy")
    RETURN .F.
 ENDIF
 IF  .NOT. SEEK(opt, 'Fi_tippg', 'Oper_fin')
    mm = 'Tipo de operación '+opt+' no existe  en tablas de tipo de pago'
    = MESSAGEBOX(mm, 48, "Aviso DatEasy")
    RETURN .F.
 ELSE
    IF EMPTY(fi_tippg.t_t_cambio)
       mm = 'La operación '+opt+' no tiene asociado un tipo de '+CHR(13)+'Cambio actualize estos  datos  en tablas de tipo de '+CHR(13)+'pagos. Si continua debera digitar un valor en este campo '
       = MESSAGEBOX(mm, 16, "Aviso DatEasy")
       RETURN .F.
    ENDIF
 ENDIF
 RETURN .T.
ENDFUNC
**
FUNCTION SALBAN
 LPARAMETERS nomtab, frepo
 IF frepo=1
    vsaldo = (ALLTRIM(nomtab))+".ing_00"
    vsaldo2 = (ALLTRIM(nomtab))+".egr_00"
    vsaldo3=&vsaldo
    vsaldo4=&vsaldo2
    vsaldo5 = vsaldo3-vsaldo4
 ELSE
    tipmon = (ALLTRIM(nomtab))+".mon"
    vsaldo5=&tipmon
 ENDIF
 RETURN vsaldo5
ENDFUNC
**
FUNCTION FLG_CON_OK
 IF flg_cont='S'
    = MESSAGEBOX('Documento ha sido centralizado no puede ser anulado.'+CHR(13)+'SI DESEA PUEDE DESCENTRALIZARLO', 48, "Aviso DatEasy")
    RETURN .F.
 ENDIF
 RETURN
ENDFUNC
**
FUNCTION _CTRTIB_
 PARAMETER mdl, op, condicion
 COUNT TO totalr FOR &condicion
 GOTO TOP
 modulo = IIF(mdl='FAC', 'facturación', IIF(mdl='ALM', 'almacen', IIF(mdl='CPP' .OR. mdl='ADP' .OR. mdl='ALP', 'Cuentas por pagar', IIF(mdl='CPC' .OR. mdl='ADC' .OR. mdl='ALC', 'Cuentas por cobrar', IIF(mdl='CBO', 'Planillas', 'Tesoreria')))))
 opera = IIF(op='C', 'Asientos generados', IIF(op='D', 'Asientos descentralizados', IIF(op='GB', 'Boletas generadas', 'Retenciones Generadas')))
 DO CASE
    CASE op='C'
       titu = 'Centralización de asientos de '+modulo+' al mes de '+ALLTRIM(CMONTH(a_fecha))+' de '+ALLTRIM(STR(YEAR(a_fecha)))
    CASE op='D'
       titu = 'Descentralizando  asientos de '+modulo+' al mes de '+ALLTRIM(CMONTH(a_fecha))+' de '+ALLTRIM(STR(YEAR(a_fecha)))
    CASE op='GB'
       titu = 'Generando  boletas de '+modulo+' al mes de '+ALLTRIM(CMONTH(a_fecha))+' de '+ALLTRIM(STR(YEAR(a_fecha)))
    CASE op='GQ'
       titu = 'Generando  Quinta Categoria de '+modulo+' al mes de '+ALLTRIM(CMONTH(a_fecha))+' de '+ALLTRIM(STR(YEAR(a_fecha)))
 ENDCASE
 DO FORM \TTL\FRM\Barra_co WITH titu
 WITH _SCREEN.activeform
    .lblhora_inicio.caption = TIME()
    .shp2.width = 0
    .lbltotal_a_procesar.caption = 'Total a procesar : '+ALLTRIM(STR(totalr))
    .lbltotal_procesados.caption = opera
    .lbltotal_a_procesar.visible = .T.
    .lbltotal_procesados.visible = .T.
    .lbltotal_no_procesados.visible = .T.
 ENDWITH
 RETURN totalr
ENDFUNC
**
FUNCTION DVCAMPO
 PARAMETER dh, dhm
 DO CASE
    CASE dhm=1
       dev = IIF(dh='D', 'Debe_mof', 'Haber_mof')
    CASE dhm=2
       dev = IIF(dh='D', 'Debe_mex', 'Haber_mex')
    CASE dhm=21
       dev = IIF(dh='D', 'Debe_conv', 'Haber_conv')
 ENDCASE
 RETURN dev
ENDFUNC
**
PROCEDURE BARRA
 PARAMETER j, n, r, l
 _SCREEN.activeform.txt2.value = j
 _SCREEN.activeform.txt4.value = n
 _SCREEN.activeform.lbl6.caption = ALLTRIM(STR(r))+'%'
 _SCREEN.activeform.s4.width = l
 _SCREEN.activeform.s4.backcolor = RGB(255, 255, 0)
 RETURN
ENDPROC
**
PROCEDURE ADDEST
 LPARAMETERS mo
 SELECT estadis
 m.dscerror = mmm
 DO CASE
    CASE mo=1
       m.opera = key_tp_fact
       IF  .NOT. SEEK(m.opera)
          INSERT INTO ESTADIS FROM MEMVAR
       ENDIF
    CASE mo=2
       m.opera = oplo
       m.almacen = alm
       IF  .NOT. SEEK(m.opera+m.almacen)
          INSERT INTO ESTADIS FROM MEMVAR
       ENDIF
    CASE mo=3
       m.opera = opf
       m.nro = nsec
       IF  .NOT. SEEK(m.opera+STR(m.nro))
          INSERT INTO ESTADIS FROM MEMVAR
       ELSE
          REPLACE dscerror WITH dscerror+m.dscerror
       ENDIF
    CASE mo=4
    CASE mo=5
       INSERT INTO ESTADIS FROM MEMVAR
 ENDCASE
 RETURN
ENDPROC
**
PROCEDURE MENSAJES
 LPARAMETERS ms, ic
 DO FORM \ttl7\FRM\ERRCENT WITH ms, ic
 RETURN
ENDPROC
**
PROCEDURE Cuadrebco
 LPARAMETERS x1, x2, x3, x4, x5
 tt = ALIAS()
 SELECT cabecera
 m1 = 0
 s1 = 0
 anulax = IIF(UPPER(stat)='X', .T., .F.)
 imported = IIF(x1='I' .AND. x3='01', abono_mof, IIF(x1='I' .AND. x3='02', abono_con, IIF(x1='E' .AND. x3='01', cargo_mof, cargo_con)))
 registro = RECNO()
 filtro = FILTER()
 SET FILTER TO ing_egr=x1 .AND. flg_ccte='B'
 DO CASE
    CASE x1='I'
       SUM IIF(x3='01', abono_mof, abono_con) TO m1 FOR ing_egr=x1 .AND. bco=x2 .AND. flg_ccte='B' .AND. stat='A'
       SELECT saldo
       s1 = (sldcaja(31, 'I')-ing_00)
    CASE x1='E'
       SUM IIF(x3='01', cargo_mof, cargo_con) TO m1 FOR ing_egr=x1 .AND. bco=x2 .AND. flg_ccte='B' .AND. stat='A'
       SELECT saldo
       s1 = (sldcaja(31, 'E')-egr_00)
 ENDCASE
 SELECT cabecera
 SET FILTER TO &filtro
 GOTO registro
 SELECT saldo
 IF s1<>m1
    signom = IIF(anulax, '+', '-')
    mm = 'El Sistema a detectado un descuadre '+CHR(13)+ 'de los saldos de bancos al realizar esta operación'+CHR(13)+ 'Para normalizar esta inconsistencia ejecute la opción'+ CHR(13)+ 'Repoceso de saldo del Administrador del sistema' +CHR(13)+CHR(13)+ 'ING/EGR  : '+ IIF(x1='I','Ingresos a caja bancos','Egresos a caja bancos')+IIF(anulax,'  (Anulación)','')+CHR(13)+ 'BCO      : '+ x2+CHR(13)+ 'MONEDA   : '+ x3+CHR(13)+ 'OPERACION: '+ x4+CHR(13)+ 'SECUENCIA: '+ STR(x5)+CHR(13)+ 'TOTAL  MOVIMIENTO ANTERIOR: '+STR(m1 &signom imported,20,2)+CHR(13)+ 'SALDO DE BCOS ANTERIOR  : '  +STR(s1 &signom imported,20,2)+CHR(13)+ 'TOTAL  MOVIMIENTO NUEVO : '  +STR(m1,20,2)+CHR(13)+ 'SALDO DE BCOS  NUEVO    : '  +STR(s1,20,2)+CHR(13)+ 'FECHA ACTUAL            :'+DTOC(DATE())+CHR(13)+ 'HORA ACTUAL             :'+TIME()+CHR(13)+ 'USUARIO QUE REALIZO LA OPERACIÓN : '+a_userdsc+CHR(13)
    = MESSAGEBOX(mm, 32, "Aviso DatEasy")
 ENDIF
 SELECT &tt
 RETURN
ENDPROC
**
FUNCTION ANULA_AD
 LPARAMETERS a_docu, a_apli
 IF MESSAGEBOX(" ¿ Realmente Desea Anular este documento ? ", 0292, "Aviso DatEasy")=7
    RETURN .F.
 ENDIF
 fileletra = IIF(a_docu='L', IIF(a_apli='C', 'FI_LECOB', 'FI_LEPAG'), '')
 filectact = IIF(a_apli='C', 'FI_CTACT', 'FI_CTAPG')
 SELECT cabecera
 clave1 = oper_fin
 clave2 = nro_sec
 SELECT linea
 = SEEK(clave1+STR(clave2))
 vmsg = 'Este documento '
 DO WHILE oper_fin=clave1 .AND. nro_sec=clave2 .AND.  .NOT. EOF()
    vcoa = coa
    vdoc = doc
    vserie = doc_serie
    vnro = doc_nro
    clave = vcoa+vdoc+vserie+vnro
    IF a_docu='L' .AND. a_apli='P'
       IF doc="LP"
          IF  .NOT. valida_doc(clave)
             RETURN .F.
          ENDIF
       ENDIF
    ELSE
       IF a_docu='L' .AND. a_apli='C'
          IF flg_la="A"
             IF  .NOT. valida_doc(clave)
                RETURN .F.
             ENDIF
          ENDIF
       ENDIF
    ENDIF
    SELECT linea
    SKIP
 ENDDO
 IF  .NOT. EMPTY(fileletra)
    SELECT &fileletra
    filtrol = FILTER()
    SET FILTER TO
 ENDIF
 SELECT linea
 = SEEK(clave1+STR(clave2))
 DO WHILE oper_fin=clave1 .AND. nro_sec=clave2 .AND.  .NOT. EOF()
    vcoa = coa
    vdoc = doc
    vserie = doc_serie
    vnro = doc_nro
    clave = vcoa+vdoc+vserie+vnro+clave1+STR(clave2)
    clavel = vcoa+vdoc+vserie+vnro
    IF (a_docu='L' .AND. a_apli='P')
       IF flg_doc<>"L"
          IF SEEK(clave, filectact, 'ADCAJA')
             SELECT &filectact
             DELETE
             = SEEK(vcoa+vdoc+vserie+vnro)
             DO WHILE coa=vcoa .AND. doc=vdoc .AND. doc_serie=vserie .AND. doc_nro=vnro .AND.  .NOT. EOF()
                REPLACE stat_canc WITH 'P', flg_let WITH ''
                SKIP
             ENDDO
          ENDIF
       ELSE
          IF SEEK(clave, filectact, 'ADCAJA')
             SELECT &filectact
             DELETE
          ENDIF
          IF SEEK(clavel, fileletra, 'master')
             campo = fileletra+'.stat'
             REPLACE &campo WITH 'P'
          ENDIF
       ENDIF
    ELSE
       IF (a_docu='L' .AND. a_apli='C')
          IF flg_la='C'
             IF SEEK(clave, filectact, 'ADCAJA')
                SELECT &filectact
                DELETE
                = SEEK(vcoa+vdoc+vserie+vnro)
                DO WHILE coa=vcoa .AND. doc=vdoc .AND. doc_serie=vserie .AND. doc_nro=vnro .AND.  .NOT. EOF()
                   REPLACE stat_canc WITH 'P', flg_let WITH '', nro_pl WITH ''
                   SKIP
                ENDDO
             ENDIF
          ELSE
             IF SEEK(clave, filectact, 'ADCAJA')
                SELECT &filectact
                DELETE
             ENDIF
             clavel_new_l = linea.nro_pl+linea.doc+linea.doc_serie+linea.doc_nro
             IF SEEK(clavel_new_l, fileletra, 'letra')
                SELECT &fileletra
                vorden_actual = ORDER()
                SET ORDER TO letra
                REPLACE stat WITH 'P'
                SELECT &fileletra
                IF  .NOT. EMPTY(vorden_actual)
                   SET ORDER TO &vorden_actual
                ENDIF
             ENDIF
          ENDIF
       ELSE
          IF (a_docu='D' .AND. a_apli='P') .OR. (a_docu='D' .AND. a_apli='C')
             IF SEEK(clave, filectact, 'ADCAJA')
                SELECT &filectact
                DELETE
                = SEEK(vcoa+vdoc+vserie+vnro)
                DO WHILE coa=vcoa .AND. doc=vdoc .AND. doc_serie=vserie .AND. doc_nro=vnro .AND.  .NOT. EOF()
                   REPLACE stat_canc WITH 'P'
                   SKIP
                ENDDO
             ENDIF
          ENDIF
       ENDIF
    ENDIF
    SELECT linea
    SKIP
 ENDDO
 REPLACE stat WITH 'X' FOR oper_fin=clave1 .AND. nro_sec=clave2
 = TABLEUPDATE(.T.)
 IF  .NOT. EMPTY(fileletra)
    SELECT &fileletra
    SET FILTER TO &filtrol
 ENDIF
 SELECT cabecera
 REPLACE stat WITH 'X'
 = TABLEUPDATE()
 RETURN
ENDFUNC
**
FUNCTION Valida_doc
 LPARAMETERS clave
 contador = 0
 vmsg = 'Este documento '
 vdatos = 'Coa  :'+vcoa+CHR(13)+'DOC  :'+vdoc+CHR(13)+'SERIE:'+vserie+CHR(13)+'NRO  :'+vnro+CHR(13)
 SELECT &filectact
 = SEEK(clave)
 DO WHILE coa=vcoa .AND. doc=vdoc .AND. doc_serie=vserie .AND. doc_nro=vnro .AND.  .NOT. EOF()
    contador = contador+1
    IF flg_let='L'
       WAIT WINDOW TIMEOUT 1.5 vmsg+'no puede ser eliminado: se ha Canjeado po letras '+CHR(13)+vdatos
       RETURN .F.
       EXIT
    ENDIF
    IF stat_canc='C'
       WAIT WINDOW TIMEOUT 1.5 vmsg+'esta cancelado '+CHR(13)+vdatos
       RETURN .F.
       EXIT
    ENDIF
    IF contador>1
       WAIT WINDOW TIMEOUT 1.5 vmsg+'tiene pagos realizados '+CHR(13)+vdatos
       RETURN .F.
       EXIT
    ENDIF
    SKIP
 ENDDO
 RETURN
ENDFUNC
**
FUNCTION VRI_EXI_FILE
 PARAMETER pruta, pnombre, pindice
 b_ruta = pruta+pnombre
 IF  .NOT. FILE(b_ruta+'.DBF')
    m1 = 'Imposible ubicar archivo '+b_ruta+CHR(13)+'PROBABLEMENTE HAYA SIDO ELIMINADO.'+CHR(13)+'PROCESO SERA CANCELADO'
    = MESSAGEBOX(m1, 16, "Aviso DatEasy")
    RETURN .F.
 ELSE
    USE &b_ruta SHARED IN 0
    SELECT &pnombre
    IF  .NOT. EMPTY(pindice)
       indice_ok = .F.
       FOR tt = 1 TO TAGCOUNT()
          IF UPPER(TAG(tt))=UPPER(pindice)
             indice_ok = .T.
             EXIT
          ENDIF
       ENDFOR
       IF  .NOT. indice_ok
          m1 = 'Indice  '+pindice+' del archivo '+b_ruta+' no existe'+CHR(13)+'IMPOSIBLE CONTINUAR'
          = MESSAGEBOX(m1, 16, "Aviso DatEasy")
          RETURN .F.
       ENDIF
       SET ORDER TO TAG &pindice
    ENDIF
 ENDIF
 RETURN
ENDFUNC
**
FUNCTION NALEATORIO
 DO WHILE .T.
    wrkf = 'Wk_'+ALLTRIM(STR(INT(RAND()*10000)))
    base = a_ruta+wrkf
    IF  .NOT. FILE(base+'.DBF')
       EXIT
    ENDIF
 ENDDO
 RETURN base
ENDFUNC
**
FUNCTION SELECT_RV
 LPARAMETERS c_select, tabla_p, tabla_s1, campo_s1, totalo
 PRIVATE vregistros, vregistros_o
 SELECT aprn
 SET ORDER TO
 COUNT ALL TO vregistros
 COUNT FOR  .NOT. EMPTY(idp) TO vregistros_o
 GOTO TOP
 SELECT MAX(idp) AS maxi FROM aprn INTO CURSOR Maxi
 IF maxi>vregistros
    MESSAGEBOX("Especifique ordenamientos segun la cantidad de Registros"+CHR(13)+"que muestra la opción de Avanzadas de Impresión.", 48, "Aviso DatEasy")
    USE IN maxi
    RETURN .F.
 ENDIF
 USE IN maxi
 SELECT COUNT(idp) AS cant FROM aprn WHERE  NOT EMPTY(idp) GROUP BY idp HAVING cant>1 INTO CURSOR Ord
 IF _TALLY>0
    MESSAGEBOX("Especifique correctamente el orden. No puede haber"+CHR(13)+"más de un Campo con el mismo ordenamiento", 48, "Aviso DatEasy")
    USE IN ord
    RETURN .F.
 ENDIF
 USE IN ord
 SELECT aprn
 SET ORDER TO idp
 FOR to = 1 TO totalo
    xc = "Xc"+ALLTRIM(STR(to))
    xd = "Xd"+ALLTRIM(STR(to))
    STOR "" TO &xc, &xd
 ENDFOR
 STORE "" TO orden, campos_ok, campo_rela, tabla_rela
 contador = 0
 solo_vc = 0
 pri_o = .F.
 condicion_final = ""
 SCAN FOR swr .AND.  .NOT. EMPTY(idp)
    clave_p0 = IIF( .NOT. EMPTY(campo_clav), campo_clav, clavet)
    clave_p = "a."+clave_p0
    tabla_r = namet+" "+sws
    campo_claver = sws+"."+clave_p0
    campo_r = sws+"."+dsct
    xcampo = "Xc"+ALLTRIM(STR(idp))
    xcampo1 = "Xd"+ALLTRIM(STR(idp))
    pri_o = .F.
    IF idp=1 .AND. INLIST(vc, "F", "O")
       pri_o = .T.
    ENDIF
    condicion1 = ""
    condicion2 = ""
    tabla_re = ""
    campo_re = ""
    IF optg="3"
       xcond = ".T."
    ELSE
       IF optg="1"
          IF  .NOT. INLIST(vc, "F", "O")
             xcond = clave_p+" = "+IIF( .NOT. EMPTY(desdex), "["+ALLTRIM(desdex)+"]", "[]")
          ELSE
             IF vc="F"
                xcond = clave_p+" = "+"Ctod"+IIF( .NOT. EMPTY(desdex), "('"+ALLTRIM(DTOC(CTOD(desdex)))+"')", "('')")
             ELSE
                xcond = clave_p+" = "+IIF( .NOT. EMPTY(desdex), "["+ALLTRIM(desdex)+"]", "[]")
             ENDIF
          ENDIF
       ELSE
          IF  .NOT. INLIST(vc, "F", "O")
             xcond = "Between("+clave_p+","+IIF( .NOT. EMPTY(desdex), "["+ALLTRIM(desdex)+"]", "[]")+","+IIF( .NOT. EMPTY(hastax), "["+ALLTRIM(hastax)+"]", "[]")+")"
          ELSE
             IF vc="F"
                xcond = "Between("+clave_p+","+"Ctod"+IIF( .NOT. EMPTY(desdex), "('"+ALLTRIM(DTOC(CTOD(desdex)))+"')", "('')")+","+"CTOD"+IIF( .NOT. EMPTY(hastax), "('"+ALLTRIM(DTOC(CTOD(hastax)))+"')", "('')")+")"
             ELSE
                xcond = "Between("+clave_p+","+IIF( .NOT. EMPTY(desdex), "["+ALLTRIM(desdex)+"]", "[]")+","+IIF( .NOT. EMPTY(hastax), "["+ALLTRIM(hastax)+"]", "[]")+")"
             ENDIF
          ENDIF
       ENDIF
    ENDIF
    campos_ok = campos_ok+IIF(contador>0, ","+clave_p+" AS "+xcampo, clave_p+" AS "+xcampo)
    IF  .NOT. INLIST(vc, "F", "O")
       condicion2 = clave_p+"="+campo_claver
       tabla_re = tabla_r
       campo_re = campo_r+" AS "+xcampo1
       solo_vc = solo_vc+1
    ENDIF
    tabla_re = IIF( .NOT. EMPTY(tabla_re), tabla_re, "")
    campo_re = IIF( .NOT. EMPTY(campo_re), campo_re, "")
    IF  .NOT. EMPTY(tabla_re)
       tabla_rela = tabla_rela+IIF(contador>0 .AND.  .NOT. EMPTY(tabla_rela), ","+tabla_re, tabla_re)
    ENDIF
    IF  .NOT. EMPTY(campo_re)
       campo_rela = campo_rela+IIF(contador>0 .AND.  .NOT. EMPTY(campo_rela), ","+campo_re, campo_re)
    ENDIF
    condicion1 = xcond
    condicion1 = IIF( .NOT. EMPTY(condicion1), condicion1, "")
    condicion2 = IIF( .NOT. EMPTY(condicion2), condicion2, "")
    IF  .NOT. EMPTY(condicion1) .AND.  .NOT. EMPTY(condicion2)
       xcond1 = IIF(contador>0, " And "+condicion1, condicion1+" And ")
       xcond2 = IIF(contador>0, " And "+condicion2, condicion2)
    ELSE
       xcond1 = IIF(EMPTY(condicion1), "", IIF(contador>0, " And "+condicion1, condicion1))
       xcond2 = IIF(EMPTY(condicion2), "", IIF(contador>0, " And "+condicion2, condicion2))
    ENDIF
    condicion_final = condicion_final+xcond1+xcond2
    orden = orden+IIF(contador>0, ","+"a."+clave_p0, "a."+clave_p0)
    contador = contador+1
 ENDSCAN
 GOTO TOP
 IF EMPTY(orden)
    RETURN
 ENDIF
 campos_v = IIF(EMPTY(solo_vc), campos_ok+", "+c_select, campos_ok+" , "+campo_rela+" , "+c_select)
 condicion_v = condicion_final
 tablas_v	=	IIF(EMPTY(solo_vc),"&Tabla_p "+"a", "&Tabla_p "+"a"+ ","+ "&Tabla_rela ")
 IF  .NOT. EMPTY(tabla_s1) .AND.  .NOT. EMPTY(campo_s1)
    campo_s1_a = "a."+campo_s1
    campo_s1_b = "b."+campo_s1
    tablas_v	= tablas_v + ","+"&Tabla_s1 "+ "b"
    SELECT &campos_v   FROM &tablas_v  WHERE &condicion_v AND &campo_s1_a = &campo_s1_b ORDER BY &orden	 INTO CURSOR avanzado
 ELSE
    SELECT &campos_v  FROM &tablas_v  WHERE &condicion_v ORDER BY &orden	 INTO CURSOR avanzado
 ENDIF
 xm = " registros generados"
 reg_gene1 = ALLTRIM(STR(_TALLY))
 = MESSAGEBOX(reg_gene1+xm, 46, "Aviso DatEasy")
ENDFUNC
**
FUNCTION TRATA_ERROR
 LPARAMETERS nro_error
 vopen_ok = .F.
 DO CASE
    CASE nro_error=3
       error_abrir_mov = .T.
    CASE nro_error=125
       = MESSAGEBOX(MESSAGE(), 16, "Aviso DatEasy")
       RETURN
    CASE nro_error=1884
       vclave_primary_ok = .F.
       RETURN .F.
    CASE INLIST(nro_error, 1, 1567)
       vtabla_no_existe = .T.
    CASE nro_error=41
       vfpt_no_existe = .T.
    CASE nro_error=15
       vnoes_tabla = .T.
 ENDCASE
 RETURN
ENDFUNC
**
FUNCTION F_PRE_DSC
 LPARAMETERS pre_dsc, vconvierte_ok, vequivalencia
 IF pre_dsc=1
    SELECT temporal
    vcoa = cabecera.coa
    varticulo = articulo
    SELECT fa_lprcl
    IF SEEK(vcoa)
       DIMENSION mprec(3, 1)
       FOR vcont = 1 TO 3
          IF coa=vcoa
             mprec(vcont, 1) = IIF(fa_cprec.tipo="E", "1", IIF(fa_cprec.tipo="P", "2", "3"))
             SKIP
          ELSE
             mprec(vcont, 1) = ""
          ENDIF
       ENDFOR
       = ASORT(mprec)
       FOR vcont = 1 TO 3
          IF  .NOT. EMPTY(mprec(vcont, 1))
             vtipo = IIF(mprec(vcont, 1)="1", "E", IIF(mprec(vcont, 1)="2", "P", "N"))
             EXIT
          ENDIF
       ENDFOR
       RELEASE mprec
    ELSE
       WAIT WINDOW "Este Cliente no ha sido Registrado en alguna Lista de Precios"
       RETURN .F.
    ENDIF
    FOR vcont99 = 1 TO 3
       SELECT fa_lprcl
       SEEK vcoa 
       vigual = .F.
       DO WHILE coa=vcoa .AND.  .NOT. EOF()
          IF fa_cprec.tipo=vtipo
             vigual = .T.
             EXIT
          ENDIF
          SKIP
       ENDDO
       vprecio = 0
       IF vigual
          vcodigo = codigo
          SELECT fa_lprec
          vprecio = 0
          DO WHILE codigo=vcodigo .AND.  .NOT. EOF()
             IF articulo=varticulo
                vprecio = cabecera.mon
                EXIT
             ENDIF
             SKIP
          ENDDO
       ENDIF
       IF EMPTY(vprecio)
          vtipo = IIF(vtipo="E", "P", IIF(vtipo="P", "N", ""))
       ENDIF
    ENDFOR
    IF EMPTY(vprecio)
       WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" no Figura en la Lista de Precios de este Cliente"
       RETURN .F.
    ELSE
       SELECT temporal
       IF vprecio="01"
          IF EMPTY(fa_lprec.precio_mn)
             WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" tiene Precio en la otra Moneda"
             RETURN .F.
          ELSE
             REPLACE imp_u_mof WITH IIF(vconvierte_ok, fa_lprec.precio_mn*vequivalencia, fa_lprec.precio_mn)
             REPLACE imp_u_con WITH imp_u_mof/m.t_cambio
          ENDIF
       ELSE
          IF EMPTY(fa_lprec.precio_me)
             WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" tiene Precio en la otra Moneda"
             RETURN .F.
          ELSE
             REPLACE imp_u_con WITH IIF(vconvierte_ok, fa_lprec.precio_me*vequivalencia, fa_lprec.precio_me)
             REPLACE imp_u_mof WITH imp_u_con*m.t_cambio
          ENDIF
       ENDIF
    ENDIF
 ELSE
    SELECT temporal
    vcoa = cabecera.coa
    varticulo = articulo
    SELECT fa_ldscl
    IF SEEK(vcoa)
       DIMENSION mprec(3, 1)
       FOR vcont = 1 TO 3
          IF coa=vcoa
             mprec(vcont, 1) = IIF(fa_cdsct.tipo="E", "1", IIF(fa_cdsct.tipo="P", "2", "3"))
             SKIP
          ELSE
             mprec(vcont, 1) = ""
          ENDIF
       ENDFOR
       = ASORT(mprec)
       FOR vcont = 1 TO 3
          IF  .NOT. EMPTY(mprec(vcont, 1))
             vtipo = IIF(mprec(vcont, 1)="1", "E", IIF(mprec(vcont, 1)="2", "P", "N"))
             EXIT
          ENDIF
       ENDFOR
       RELEASE mprec
       FOR vcont99 = 1 TO 3
          SELECT fa_ldscl
          SEEK vcoa 
          vigual = .F.
          DO WHILE coa=vcoa .AND.  .NOT. EOF()
             IF fa_cdsct.tipo=vtipo
                vigual = .T.
                EXIT
             ENDIF
             SKIP
          ENDDO
          vprecio = 0
          IF vigual
             vcodigo = codigo
             SELECT fa_ldsct
             vprecio = 0
             DO WHILE codigo=vcodigo .AND.  .NOT. EOF()
                IF articulo=varticulo
                   vprecio = cabecera.mon
                   EXIT
                ENDIF
                SKIP
             ENDDO
          ENDIF
          IF EMPTY(vprecio)
             vtipo = IIF(vtipo="E", "P", IIF(vtipo="P", "N", ""))
          ENDIF
       ENDFOR
       IF EMPTY(vprecio)
          WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" no Figura en la Lista de Descuentos de este Cliente"
       ELSE
          SELECT temporal
          IF fa_ldsct.chk_mon
             IF vprecio="01"
                IF EMPTY(fa_ldsct.dsc_mon_mn)
                   WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" tiene Descuento en la Otra Moneda"
                ELSE
                   IF  .NOT. fa_ento.pre_c_iva
                      REPLACE imp_d_mof WITH imp_b_mof*(fa_ldsct.dsc_mon_mn/100)
                      REPLACE imp_d_con WITH imp_d_mof/m.t_cambio
                   ELSE
                      REPLACE imp_d_iva WITH imp_t_iva*(fa_ldsct.dsc_mon_mn/100)
                   ENDIF
                   REPLACE imp_d WITH fa_ldsct.dsc_mon_mn
                ENDIF
             ELSE
                IF EMPTY(fa_ldsct.dsc_mon_me)
                   WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" tiene Descuento en la Otra Moneda"
                ELSE
                   IF  .NOT. fa_ento.pre_c_iva
                      REPLACE imp_d_con WITH imp_b_con*(fa_ldsct.dsc_mon_me/100)
                      REPLACE imp_d_mof WITH imp_d_con*m.t_cambio
                   ELSE
                      REPLACE imp_d_iva WITH imp_t_iva*(fa_ldsct.dsc_mon_me/100)
                   ENDIF
                   REPLACE imp_d WITH fa_ldsct.dsc_mon_me
                ENDIF
             ENDIF
          ELSE
             IF vprecio="01"
                IF EMPTY(fa_ldsct.vol_mn)
                   WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" tiene Descuento en la Otra Moneda"
                ELSE
                   IF IIF(fa_ento.pre_c_iva, imp_t_iva, imp_b_mof)>=fa_ldsct.vol_mn
                      IF  .NOT. fa_ento.pre_c_iva
                         REPLACE imp_d_mof WITH imp_b_mof*(fa_ldsct.dsc_vol_mn/100)
                         REPLACE imp_d_con WITH imp_d_mof/m.t_cambio
                      ELSE
                         REPLACE imp_d_iva WITH imp_t_iva*(fa_ldsct.dsc_vol_mn/100)
                      ENDIF
                      REPLACE imp_d WITH fa_ldsct.dsc_vol_mn
                   ELSE
                      WAIT WINDOW "El Importe Bruto del Artículo "+ALLTRIM(varticulo)+" es Menor Volumen de Venta Mínimo para Aplicar el Descuento"
                   ENDIF
                ENDIF
             ELSE
                IF EMPTY(fa_ldsct.vol_me)
                   WAIT WINDOW "El Artículo "+ALLTRIM(varticulo)+" tiene Descuento en la Otra Moneda"
                ELSE
                   IF IIF(fa_ento.pre_c_iva, imp_t_iva, imp_b_con)>=fa_ldsct.vol_me
                      IF  .NOT. fa_ento.pre_c_iva
                         REPLACE imp_d_con WITH imp_b_con*(fa_ldsct.dsc_vol_me/100)
                         REPLACE imp_d_mof WITH imp_d_con/m.t_cambio
                      ELSE
                         REPLACE imp_d_iva WITH imp_t_iva*(fa_ldsct.dsc_vol_me/100)
                      ENDIF
                      REPLACE imp_d WITH fa_ldsct.dsc_vol_me
                   ELSE
                      WAIT WINDOW "El Importe Bruto del "+ALLTRIM(varticulo)+" es Menor Volumen de Venta Mínimo para Aplicar el Descuento"
                   ENDIF
                ENDIF
             ENDIF
          ENDIF
       ENDIF
    ELSE
       WAIT WINDOW "Este Cliente no ha sido Registrado en alguna Lista de Descuentos"
    ENDIF
 ENDIF
 RETURN .T.
ENDFUNC
**
PROCEDURE PREC_O_DSCTO
 LPARAMETERS vtip, vlista, varticulo, vmon, vcampomn, vcampome, vtabla, vconvierte_ok, vequivalencia
 vt_cambio = m.t_cambio
 IF vtip='P'
    IF SEEK(vlista+varticulo, "Fa_lpre", "CODART")
       IF vmon="01"
          REPLA &vcampomn WITH IIF(vconvierte_ok,fa_lpre.precio_mn*vequivalencia,fa_lpre.precio_mn) IN &vtabla
          REPLA &vcampome WITH &vcampomn / vt_cambio IN &vtabla
       ELSE
          REPLA &vcampome WITH IIF(vconvierte_ok,fa_lpre.precio_me*vequivalencia,fa_lpre.precio_me) IN &vtabla
          REPLA &vcampomn WITH &vcampome * vt_cambio IN &vtabla
       ENDIF
    ELSE
       REPLA &vcampomn WITH 0.00 &vcampome WITH 0.00 IN &vtabla
    ENDIF
 ELSE
    por_mon_ = vtabla+'.imp_d'
    IF SEEK(vlista+varticulo, "Fa_ldsc", "CODART")
       vbrutomn = EVALUATE(vtabla+IIF(fa_ento.pre_c_iva, ".imp_d_iva", ".imp_b_mof"))
       vbrutome = EVALUATE(vtabla+IIF(fa_ento.pre_c_iva, ".imp_d_iva", ".imp_b_con"))
       IF fa_ldsc.chk_vol
          IF vmon="01"
             IF vbrutomn>=fa_ldsc.vol_mn
                REPLA &vcampomn WITH vbrutomn*(fa_ldsc.dsc_vol_mn/100) IN &vtabla
                IF  .NOT. fa_ento.pre_c_iva
                   REPLA &vcampome WITH &vcampomn / vt_cambio IN &vtabla
                ENDIF
                REPLA &por_mon_ WITH fa_ldsc.dsc_vol_mn
             ELSE
                WAIT WINDOW "El Importe Bruto del Artículo "+ALLTRIM(varticulo)+" es Menor Volumen de Venta Mínimo para Aplicar el Descuento"
             ENDIF
          ELSE
             IF vbrutome>=fa_ldsc.vol_me
                REPLA &vcampome WITH vbrutome*(fa_ldsc.dsc_vol_me/100) IN &vtabla
                IF  .NOT. fa_ento.pre_c_iva
                   REPLA &vcampomn WITH &vcampome * vt_cambio IN &vtabla
                ENDIF
                REPLA &por_mon_ WITH fa_ldsc.dsc_vol_me
             ELSE
                WAIT WINDOW "El Importe Bruto del Artículo "+ALLTRIM(varticulo)+" es Menor Volumen de Venta Mínimo para Aplicar el Descuento"
             ENDIF
          ENDIF
       ELSE
          IF vmon="01"
             REPLA &vcampomn WITH vbrutomn*(fa_ldsc.dsc_mon_mn/100) IN &vtabla
             IF  .NOT. fa_ento.pre_c_iva
                REPLA &vcampome WITH &vcampomn / vt_cambio IN &vtabla
             ENDIF
             REPLA &por_mon_ WITH fa_ldsc.dsc_mon_mn
          ELSE
             REPLA &vcampome WITH vbrutome*(fa_ldsc.dsc_mon_me/100) IN &vtabla
             IF  .NOT. fa_ento.pre_c_iva
                REPLA &vcampomn WITH &vcampome * vt_cambio IN &vtabla
             ENDIF
             REPLA &por_mon_ WITH fa_ldsc.dsc_mon_me
          ENDIF
       ENDIF
    ELSE
       REPLA &vcampomn WITH 0.00 &vcampome WITH 0.00, &por_mon_ WITH 0.00 IN &vtabla
    ENDIF
 ENDIF
ENDPROC
**
FUNCTION ACUM_SLD
 LPARAMETERS porc_
 IF PCOUNT()=0
    RETURN
 ENDIF
 IF porc_=0
    RETURN
 ENDIF
 t_tmp = ALIAS()
 SELECT linea_r
 acum_haber = 0
 hmes__ = 'H_mof_'+ALLTRIM(STR(MONTH(a_fecha)))
 hmes__ = "sld__."+hmes__
 SCAN FOR porcentaje=porc_
    IF SEEK(ALLTRIM(STR(YEAR(a_fecha)))+ccosto_lin+cta_haber, "sld__")
       acum_haber = acum_haber + &hmes__
    ENDIF
 ENDSCAN
 IF acum_haber>0
    acum_haber = ROUND(acum_haber*(porc_/100), 2)
 ENDIF
 SELECT &t_tmp
 RETURN acum_haber
ENDFUNC
**
FUNCTION REST_MOVI
 LPARAMETERS valmacen, voper_fin, vsolo_almacen
 IF  .NOT. SEEK(valmacen, "Al_almac", "Almacen")
    WAIT WINDOW "Almacen no existe"
    RETURN .F.
 ENDIF
 IF  .NOT. USED("Al_moval")
    IF  .NOT. FILE(a_ruta+"Al_moval.dbf")
       = MESSAGEBOX("File de restricciones no existe"+CHR(13)+"Contacte con su provedor", 32, "Aviso DatEasy")
       RETURN .F.
    ELSE
       USE a_ruta+"Al_moval.dbf" IN 0
    ENDIF
 ENDIF
 IF vsolo_almacen
    SELECT almacen FROM al_almac WHERE  NOT movimiento AND almacen=valmacen UNION ALL SELECT DISTINCT a.almacen FROM al_moval a, al_almac b WHERE a.almacen=b.almacen AND b.movimiento AND a.almacen=valmacen AND a.cod_user=a_usuario INTO CURSOR cAlmacen
    vmsg = "Usuario "+a_userdsc+CHR(13)+"No esta autorizado usar el almacen : "+valmacen+" "+ALLTRIM(al_almac.dsc)+CHR(13)
    IF EMPTY(_TALLY)
       = MESSAGEBOX(vmsg, 32, "Aviso DatEasy")
       RETURN .F.
    ENDIF
 ELSE
    IF al_almac.movimiento
       vmsg = "El tipo de operación "+'"'+voper_fin+'"'+" del usuario "+a_userdsc+CHR(13)+" no esta autorizado para el almacen "+valmacen+" "+ALLTRIM(al_almac.dsc)+CHR(13)+"Si desea registrar una transacción con este tipo de  operación matricule"+CHR(13)+"este codigo en tablas de  ALMACENES"
       vwhere = "almacen=VALMACEN AND cod_user = A_usuario AND UPPER(oper_log)=UPPER(VOPER_FIN)"
       SELECT almacen,cod_user,oper_log FROM al_moval WHERE &vwhere  INTO CURSOR cal_mov
       IF EMPTY(_TALLY)
          = MESSAGEBOX(vmsg, 32, "Aviso DatEasy")
          RETURN .F.
       ENDIF
    ENDIF
 ENDIF
ENDFUNC
**
PROCEDURE CUADRA_IGV
 LPARAMETERS suma_igv, igv_neto, c_igv_mn, c_igv_me, reg_act, vmon, vtcambio, voriginal_
 signo_ = "-"
 vdif = 0
 IF igv_neto>suma_igv
    vdif = igv_neto-suma_igv
    signo_ = "+"
 ELSE
    vdif = suma_igv-igv_neto
    signo_ = "-"
 ENDIF
 GOTO reg_act
 IF voriginal_
    IF vmon="01"
       REPLACE &c_igv_mn WITH &c_igv_mn &signo_ vdif
    ELSE
       REPLACE &c_igv_me WITH &c_igv_me &signo_ vdif
    ENDIF
 ELSE
    IF vmon="02"
       REPLACE &c_igv_mn WITH &c_igv_mn &signo_ vdif
    ELSE
       REPLACE &c_igv_me WITH &c_igv_me &signo_ vdif
    ENDIF
 ENDIF
 CALCULATE SUM(IIF(cabecera.mon="01", imp_i_mof, imp_i_con)) TO vimp_i 
 GOTO reg_act
ENDPROC
**
FUNCTION F_ACU_PREJ
 LPARAMETERS vprej, vmesn
 vmesacu = 0
 FOR vcont = 1 TO vmesn
    vmesact = "pr_presu."+IIF(vprej=1, "p", "ej")+"_"+IIF(pr_presu.mon="01", "mof", "con")+"_"+ALLTRIM(STR(vcont))
    vmesact2=&vmesact
    vmesacu = vmesacu+vmesact2
 ENDFOR
 RELEASE vmesact, vmesact2
 RETURN vmesacu
ENDFUNC
**
PROCEDURE LLENA_ACCESOS
 condicion = 'User = A_Usuario And Emp = A_Cemp And Mod  = vmodulo_'
 FOR i = 1 TO 99
    a_access[i] = .T.
 ENDFOR
 SELECT * FROM AD_ACCES WHERE UPPER(ALLTRIM(user))==UPPER(ALLTRIM(a_usuario)) AND UPPER(ALLTRIM(emp))==UPPER(ALLTRIM(a_cemp)) AND UPPER(ALLTRIM(mod))==UPPER(ALLTRIM(vmodulo_)) INTO CURSOR cAD_ACCES
 SELECT cad_acces
 GOTO TOP
 DO WHILE  .NOT. EOF()
    a_access[opc] = .F.
    SKIP
 ENDDO
ENDPROC
**
FUNCTION DAT_PRIMARY
 LPARAMETERS vvalor_ingre
 vnro_ind = 0
 vvalor_reto = .F.
 FOR vtind = 1 TO TAGCOUNT()
    IF PRIMARY(vtind)
       vnro_ind = vtind
       EXIT
    ENDIF
 ENDFOR
 DO CASE
    CASE vvalor_ingre=1
       vvalor_reto = TAG(vnro_ind)
    CASE vvalor_ingre=2
       vvalor_reto = KEY(vnro_ind)
 ENDCASE
 RETURN vvalor_reto
ENDFUNC
**
FUNCTION NOT_EXISTE_RECORD
 LPARAMETERS vtabla, vmensaje
 vclave_primary_ok = .T.
 ccerror = ON("Error")
 ON ERROR DO trata_error WITH ERROR()
 vregto_actual = RECNO(vtabla)
 IF  .NOT. EOF(vtabla)
    GO vregto_actual IN &vtabla
 ENDIF
 IF  .NOT. EMPTY(ccerror)
    ON ERROR &ccerror
 ELSE
    ON ERROR
 ENDIF
 IF  .NOT. vclave_primary_ok
    vms = ''
    IF  .NOT. EMPTY(vmensaje)
       vms = vmensaje
    ENDIF
    UNLOCK ALL
    = MESSAGEBOX(vms+CHR(13)+CHR(13)+MESSAGE(), 16, "Aviso DatEasy")
    RETURN .F.
 ENDIF
ENDFUNC
**
FUNCTION SOLO_1_REGTO
 LPARAMETERS vtabla, vtag, vcodigo_busca, vcodigo_a_buscar
 IF EMPTY(vcodigo_busca)
    RETURN
 ENDIF
 SELECT &vtabla
 vorder = TAG()
 registro = RECNO()
 contador = 0
 SET ORDER TO &vtag
 = SEEK(vcodigo_busca)
 DO WHILE &VCODIGO_A_BUSCAR = VCODIGO_BUSCA And Not Eof()
    contador = contador+1
    IF contador=2
       GOTO registro
       SET ORDER TO &vorder
       = MESSAGEBOX(" El registro ya existe. "+CHR(13)+al_artic.dsc, 16, "Aviso DatEasy")
       REPLACE &vcodigo_a_buscar WITH ''
       RETURN .F.
    ENDIF
    SKIP
 ENDDO
 SET ORDER TO &vorder
 GOTO registro
ENDFUNC
**
PROCEDURE UPDATE_LINEA
 LPARAMETERS vcondicion, vclave, vnro_reg_tmp, vinsert
 SELECT linea
 GOTO TOP
 SEEK (vclave) 
 COUNT WHILE &vcondicion TO vnro_reg_lin
 DO CASE
    CASE vnro_reg_tmp>vnro_reg_lin
       FOR i = 1 TO (vnro_reg_tmp-vnro_reg_lin)
          INSERT INTO &vinsert
       ENDFOR
    CASE vnro_reg_tmp<vnro_reg_lin
       SELECT linea
       SEEK (vclave) 
       i = vnro_reg_lin-vnro_reg_tmp
       n_delete = 0
       DO WHILE &VCONDICION And Not Eof()
          n_delete = n_delete+1
          DELETE
          IF n_delete=i
             EXIT
          ENDIF
          SKIP IN linea
       ENDDO
 ENDCASE
 SELECT linea
 SEEK (vclave) 
 SELECT temporal
 GOTO TOP
 SCAN
    SCATTER MEMO MEMVAR
    SELECT linea
    GATHER MEMO MEMVAR
    IF  .NOT. EOF('linea')
       SKIP IN linea
    ENDIF
    SELECT temporal
 ENDSCAN
ENDPROC
**
FUNCTION SAVE_ING_ALMACEN
 LPARAMETERS vcabecera, vtemporal, vsaldo, vmovim, vtran_ok, voper_tran
 SELECT &vcabecera
 m.doc_fch = doc_fch
 m.fch_act = DATE()
 m.hora = TIME()
 m.usr = a_usuario
 m.ej = ALLTRIM(STR(YEAR(a_fecha)))
 m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
 PRIVATE un_tmp, cos_tmn, cos_tme, cos_umn, cos_ume
 STORE 0 TO un_tmp, cos_tmn, cos_tme, cos_umn, cos_ume
 SELECT &vtemporal
 SCAN
    IF reg_orig="L"
       IF  .NOT. save_ing_almacen_lote(vtran_ok, voper_tran, articulo)
          RETURN .F.
       ENDIF
    ENDIF
    m.fch_act = DATE()
    m.hora = TIME()
    SELECT &vtemporal
    un_tmp = und
    cos_tmn = cos_t_mof
    cos_tme = cos_t_con
    cos_umn = cos_ua_mof
    cos_ume = cos_ua_con
    SCATTER MEMVAR
    IF cabecera.origen='C'
       m.doc_ref = ALLTRIM(ord_tip)+' '+ALLTRIM(ord_ser)+' '+ALLTRIM(ord_nro)
    ENDIF
    IF vtran_ok
       m.mon_ext = '01'
       m.oper_log = voper_tran
       m.almacen = almacen_t
       key_1 = almacen_t+articulo
       m.almacen_t = ""
    ELSE
       key_1 = almacen+articulo
    ENDIF
    SELECT &vsaldo
    IF  .NOT. SEEK(key_1, vsaldo, "Alar")
       INSERT INTO &vsaldo FROM MEMVAR
       REPLACE und_ti WITH un_tmp, und_mi WITH un_tmp
       REPLACE cos_ti_mof WITH cos_tmn, cos_ti_con WITH cos_tme
       REPLACE cos_mi_mof WITH cos_tmn, cos_mi_con WITH cos_tme
       REPLACE cos_u_mof WITH ((cos_ti_mof-cos_ts_mof)/(und_ti-und_ts))
       REPLACE cos_u_con WITH ((cos_ti_con-cos_ts_con)/(und_ti-und_ts))
    ELSE
       GATHER MEMVAR
       REPLACE und_ti WITH und_ti+(un_tmp), und_mi WITH und_mi+(un_tmp)
       REPLACE cos_ti_mof WITH (cos_ti_mof+cos_tmn), cos_ti_con WITH (cos_ti_con+cos_tme)
       REPLACE cos_mi_mof WITH (cos_mi_mof+cos_tmn), cos_mi_con WITH (cos_mi_con+cos_tme)
       IF und_ti-und_ts>0
          REPLACE cos_u_mof WITH ((cos_ti_mof-cos_ts_mof)/(und_ti-und_ts))
          REPLACE cos_u_con WITH ((cos_ti_con-cos_ts_con)/(und_ti-und_ts))
       ENDIF
    ENDIF
    IF  .NOT. SEEK(key_1, vsaldo, "Alar")
       WAIT WINDOW "El producto :"+EVALUATE(vtemporal+".articulo")+" no se guardo en los saldos "+CHR(13)+"del almacen : "+EVALUATE(vtemporal+".almacen")+" Si el problema persiste realize el"+CHR(13)+"proceso de reindexado, de lo contrario comuniquese con su proveedor"+CHR(13)+CHR(13)+"La transacción sera cancelada"
       RETURN .F.
    ENDIF
    uta = und_ti-und_ts
    cumn = cos_u_mof
    cume = cos_u_con
    camn = cos_ti_mof-cos_ts_mof
    came = cos_ti_con-cos_ts_con
    SELECT &vmovim
    INSERT INTO &vmovim FROM MEMVAR
    REPLACE und_ta WITH uta, und_i WITH un_tmp
    REPLACE cos_u_mof WITH cumn, cos_u_con WITH cume
    REPLACE cos_ua_mof WITH cos_umn, cos_ua_con WITH cos_ume
    REPLACE cos_ta_mof WITH camn, cos_ta_con WITH came
    REPLACE cos_ti_mof WITH cos_tmn, cos_ti_con WITH cos_tme
    SELECT &vtemporal
 ENDSCAN
ENDFUNC
**
FUNCTION SAVE_SAL_ALMACEN
 LPARAMETERS vcabecera, vtemporal, vsaldo, vmovim, vmodulo
 SELECT &vcabecera
 m.doc_fch = doc_fch
 m.fch_act = DATE()
 m.hora = TIME()
 m.usr = a_usuario
 m.ej = ALLTRIM(STR(YEAR(a_fecha)))
 m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
 SELECT &vtemporal
 SCAN
    IF reg_orig="L"
       IF  .NOT. save_sal_almacen_lote(articulo, vmodulo)
          RETURN .F.
       ENDIF
    ENDIF
    SELECT &vtemporal
    un_tmp = und
    IF vmodulo="A"
       cos_tmn = cos_t_mof
       cos_tme = cos_t_con
       cos_umn = cos_ua_mof
       cos_ume = cos_ua_con
    ENDIF
    SCATTER MEMO MEMVAR
    IF vmodulo="F"
       un_tmp = IIF(EMPTY(cod_conv), und, und*und_ped)
       m.mon_ext = mon
       m.doc_ref = doc
    ENDIF
    key_1 = almacen+articulo
    IF  .NOT. SEEK(key_1, vsaldo, "Alar")
       WAIT WINDOW "El producto :"+EVALUATE(vtemporal+".articulo")+" no existe en los saldos "+CHR(13)+"del almacen : "+EVALUATE(vtemporal+".almacen")+" no se puede realizar una salida"+CHR(13)+"sin stock del almacen"+CHR(13)+CHR(13)+"La transacción sera cancelada"
       RETURN .F.
    ENDIF
    SELECT &vsaldo
    IF  .NOT. SEEK(key_1)
       APPEND BLANK
       GATHER MEMVAR
       REPLACE und_ts WITH un_tmp, und_ms WITH un_tmp
       REPLACE cos_ts_mof WITH cos_tmn, cos_ts_con WITH cos_tme
       REPLACE cos_ms_mof WITH cos_tmn, cos_ms_con WITH cos_tme
    ELSE
       IF vmodulo="F"
          cos_umn = cos_u_mof
          cos_ume = cos_u_con
          cos_tmn = cos_u_mof*un_tmp
          cos_tme = cos_u_con*un_tmp
       ENDIF
       GATHER MEMVAR
       REPLACE und_ts WITH und_ts+(un_tmp), und_ms WITH und_ms+(un_tmp)
       REPLACE cos_ts_mof WITH (cos_ts_mof+cos_tmn), cos_ts_con WITH (cos_ts_con+cos_tme)
       REPLACE cos_ms_mof WITH (cos_ms_mof+cos_tmn), cos_ms_con WITH (cos_ms_con+cos_tme)
    ENDIF
    uta = und_ti-und_ts
    cumn_sld = cos_u_mof
    cume_sld = cos_u_con
    camn_sld = cos_ti_mof-cos_ts_mof
    came_sld = cos_ti_con-cos_ts_con
    SELECT &vmovim
    APPEND BLANK
    GATHER MEMO MEMVAR
    REPLACE und_ta WITH uta
    REPLACE cos_u_mof WITH cumn_sld, cos_u_con WITH cume_sld
    REPLACE cos_ua_mof WITH cos_umn, cos_ua_con WITH cos_ume
    REPLACE cos_ta_mof WITH camn_sld, cos_ta_con WITH came_sld
    REPLACE und_s WITH un_tmp
    REPLACE cos_ts_mof WITH cos_tmn, cos_ts_con WITH cos_tme
    SELECT &vtemporal
 ENDSCAN
ENDFUNC
**
FUNCTION ENCRIPTA_DATOS
 LPARAMETERS x, y
 a = ''
 FOR i = 1 TO LEN(x)
    cc = SUBSTR(x, i, 1)
    a=a+CHR(ASC(cc) &y i)
 ENDFOR
 RETURN a
ENDFUNC
**
FUNCTION PARA_ENTORNO
 PARAMETER ssi, que_hacer, vento_glob
 valias = ALIAS()
 titu = 'Cierre de mes'
 IF  .NOT. vento_glob
    USE &a_ruta&ssi AGAIN ALIAS en__t IN 0
 ELSE
    vruta_ = a_ruta_exe+'BD\AD_ENTOR'
    USE &vruta_ AGAIN ALIAS en__t IN 0 ORDER PARAME
 ENDIF
 SELECT en__t
 DO CASE
    CASE que_hacer=1
       vretorno = lst_p_o_d
    CASE que_hacer=2
       vretorno = eliminar
    CASE que_hacer=3
       vretorno = mod_p_f
    CASE que_hacer=4
       vretorno = mod_d_f
    CASE que_hacer=5
       vretorno = elimina_ga
    CASE que_hacer=6
       vretorno = mod_p_g
    CASE que_hacer=7
       vretorno = mod_d_g
    CASE que_hacer=8
       vretorno = elimina_cp
    CASE que_hacer=9
       vretorno = mod_p_c
    CASE que_hacer=10
       vretorno = mod_d_c
    CASE que_hacer=11
       vretorno = elimina_pp
    CASE que_hacer=12
       vretorno = mod_p_p
    CASE que_hacer=13
       vretorno = mod_d_p
    CASE que_hacer=14
       vretorno = presentaco
    CASE que_hacer=500
       vretorno = .F.
       IF SEEK("MNS") .AND. UPPER(ALLTRIM(cond))='S'
          vretorno = .T.
       ENDIF
    CASE que_hacer=600
       vretorno = .F.
       IF SEEK("MLO") .AND. UPPER(ALLTRIM(cond))='S'
          vretorno = .T.
       ENDIF
 ENDCASE
 USE
 IF  .NOT. EMPTY(valias)
    SELECT &valias
 ENDIF
 RETURN vretorno
ENDFUNC
**
FUNCTION ATRIB_USUARIO
 LPARAMETERS vbuscar, vmodulo
 vretorno = .F.
 IF  .NOT. USED("AD_ATRIB")
    USE a_ruta_exe+'BD\AD_ATRIB' IN 0
 ENDIF
 IF SEEK(a_usuario+'2 '+vbuscar, 'AD_ATRIB', 'FACTUR_A')
    vretorno = ad_atrib.mod_2_a
 ENDIF
 RETURN vretorno
ENDFUNC
**
FUNCTION ANULA_DOCUMENTO
 PARAMETER vtipo_docum, v_factura, v_guia, solo_fact_cte
 DO CASE
    CASE vtipo_docum='V'
       BEGIN TRANSACTION
       IF v_factura
          IF  .NOT. v_guia
             SELECT fi_ctact
             filectact = "fi_ctact"
             vcoa = m.coa
             vdoc = m.doc
             vserie = m.doc_serie
             vnro = m.doc_nro
             clave = vcoa+vdoc+vserie+vnro
             IF  .NOT. valida_doc(clave)
                RELEASE filectact, vcoa, vdoc, vserie, vnro, clave
                ROLLBACK
                RETURN .F.
             ENDIF
             = SEEK(clave)
             DO WHILE coa=vcoa .AND. doc=vdoc .AND. doc_serie=vserie .AND. doc_nro=vnro .AND.  .NOT. EOF()
                DELETE
                SKIP
             ENDDO
             RELEASE filectact, vcoa, vdoc, vserie, vnro, clave
          ENDIF
          IF SEEK("01", "AD_ENTOR", "PARAME") .AND. ALLTRIM(ad_entor.cond)="S" .AND.  .NOT. solo_fact_cte
             SELECT al_nuser
             SET ORDER TO Salida
             SELECT linea
             vvkey = m.doc+m.doc_serie+m.doc_nro
             SEEK vvkey 
             DO WHILE doc+doc_serie+doc_nro=vvkey .AND.  .NOT. EOF()
                IF EMPTY(flg_tipo)
                   IF serie_arti
                      valor_busq = almacen+articulo+ALLTRIM(doc)+doc_serie+doc_nro
                      IF SEEK(valor_busq, "Al_nuser", "Salida")
                         SELECT al_nuser
                         REPLACE alm_sal WITH '', doc_sal WITH '', doc_s_sal WITH '', doc_n_sal WITH '', coa_sal WITH '', fch_sal WITH {}, flg_des WITH .F. WHILE alm_sal+articulo+ALLTRIM(doc_sal)+doc_s_sal+doc_n_sal==valor_busq .AND.  .NOT. EOF()
                         = TABLEUPDATE(.T.)
                      ENDIF
                   ENDIF
                   SELECT linea
                   un_tmp = IIF(EMPTY(cod_conv), und, und*und_ped)
                   SCATTER MEMO MEMVAR
                   m.doc_ref = doc
                   m.ej = ALLTRIM(STR(YEAR(a_fecha)))
                   m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
                   m.fch_act = DATE()
                   m.doc_fch = a_fecha
                   m.hora = TIME()
                   m.usr = a_usuario
                   m.emp = a_cemp
                   m.mon_ext = m.mon
                   vvvkey = m.almacen+articulo
                   SELECT saldo
                   IF SEEK(vvvkey)
                      cos_umn = cos_u_mof
                      cos_ume = cos_u_con
                      cos_tmn = cos_u_mof*un_tmp
                      cos_tme = cos_u_con*un_tmp
                      GATHER MEMO MEMVAR
                      REPLACE und_ti WITH und_ti+un_tmp, und_mi WITH und_mi+un_tmp
                      REPLACE cos_ti_mof WITH cos_ti_mof+cos_tmn, cos_ti_con WITH cos_ti_con+cos_tme
                      REPLACE cos_mi_mof WITH cos_mi_mof+cos_tmn, cos_mi_con WITH cos_mi_con+cos_tme
                      IF und_ti-und_ts>0
                         REPLACE cos_u_mof WITH (cos_ti_mof-cos_ts_mof)/(und_ti-und_ts)
                         REPLACE cos_u_con WITH (cos_ti_con-cos_ts_con)/(und_ti-und_ts)
                      ENDIF
                      REPLACE stat WITH "A"
                      uta = und_ti-und_ts
                      cumn = cos_u_mof
                      cume = cos_u_con
                      camn = cos_ti_mof-cos_ts_mof
                      came = cos_ti_con-cos_ts_con
                      SELECT movim
                      APPEND BLANK
                      GATHER MEMO MEMVAR
                      REPLACE cos_u_mof WITH cumn, cos_u_con WITH cume
                      REPLACE und_ta WITH uta
                      REPLACE cos_ua_mof WITH cos_umn, cos_ua_con WITH cos_ume
                      REPLACE cos_ta_mof WITH camn, cos_ta_con WITH came
                      REPLACE und_i WITH un_tmp, oper_log WITH "IVT", stat WITH "A"
                      REPLACE cos_ti_mof WITH cos_tmn, cos_ti_con WITH cos_tme
                      IF reg_orig="L"
                         m.ej = ALLTRIM(STR(YEAR(a_fecha)))
                         m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
                         SELECT cabecera
                         vclave_buscar = m.ej+m.mes+cabecera.almacen+cabecera.oper_log+cabecera.doc_serie+cabecera.doc_nro+linea.articulo
                         ZAP IN cal_mlote
                         SELECT al_mlote
                         = SEEK(vclave_buscar, "al_mlote", "AOSNART")
                         PRIVATE un_tmp, cos_tmn, cos_tme, cos_umn, cos_ume
                         STORE 0 TO un_tmp, cos_tmn, cos_tme, cos_umn, cos_ume
                         DO WHILE ej+mes+almacen+oper_log+doc_serie+doc_nro+articulo=vclave_buscar .AND.  .NOT. EOF()
                            un_tmp = und_s
                            SCATTER MEMVAR
                            key_1 = ej+mes+almacen+articulo+lote
                            SELECT al_slote
                            IF SEEK(key_1, "al_slote", "maestro1")
                               GATHER MEMVAR
                               REPLACE und_ti WITH und_ti+(un_tmp), und_mi WITH und_mi+(un_tmp)
                            ELSE
                               WAIT WINDOW "El producto :"+al_mlote.articulo+" no se guardo en los saldos "+CHR(13)+"del almacen por lotes: "+al_mlote.almacen+" Si el problema persiste realize el"+CHR(13)+"proceso de reindexado, de lo contrario comuniquese con su proveedor"+CHR(13)+CHR(13)+"La transacción sera cancelada"
                               RELEASE vclave_buscar
                               ROLLBACK
                               RETURN .F.
                            ENDIF
                            uta = und_ti-und_ts
                            m.und_s = 0
                            INSERT INTO CAL_mlote FROM MEMVAR
                            RELEASE m.und_s
                            REPLACE und_ta WITH uta, und_i WITH un_tmp, oper_log WITH "IVT", stat WITH "A" IN cal_mlote
                            RELEASE uta, un_tmp, key_1
                            SELECT al_mlote
                            SKIP
                         ENDDO
                         RELEASE vclave_buscar
                         cappend = DBF("CAL_MLOTE")
                         APPEND FROM (cappend)
                         RELEASE cappend
                      ENDIF
                   ENDIF
                ENDIF
                SELECT linea
                SKIP
             ENDDO
             ZAP IN cal_mlote
             RELEASE vvkey
          ENDIF
       ENDIF
       SELECT cabecera
       REPLACE stat WITH "X"
       vkey = doc+doc_serie+doc_nro
       IF  .NOT. TABLEUPDATE()
          = MESSAGEBOX('La anulación no se pudo realizar '+MESSAGE(), 32, "Aviso DatEasy")
          ROLLBACK
          RETURN .F.
       ENDIF
       SELECT linea
       SEEK vkey 
       DO WHILE doc+doc_serie+doc_nro=vkey .AND.  .NOT. EOF()
          REPLACE stat WITH "X"
          SKIP
       ENDDO
       IF  .NOT. TABLEUPDATE(.T.)
          = MESSAGEBOX('La anulación no se pudo realizar en la linea'+MESSAGE(), 32, "Aviso DatEasy")
          ROLLBACK
          RETURN .F.
       ENDIF
       END TRANSACTION
       RELEASE vkey
    CASE vtipo_docum='P'
       BEGIN TRANSACTION
       SELECT fi_ctapg
       filectact = 'Fi_ctapg'
       vcoa = m.coa
       vdoc = m.doc
       vserie = m.doc_serie
       vnro = m.doc_nro
       clave = vcoa+vdoc+vserie+vnro
       IF  .NOT. valida_doc(clave)
          RELEASE filectact, vcoa, vdoc, vserie, vnro, clave
          ROLLBACK
          RETURN .F.
       ENDIF
       = SEEK(clave)
       DO WHILE coa=vcoa .AND. doc=vdoc .AND. doc_serie=vserie .AND. doc_nro=vnro .AND.  .NOT. EOF()
          DELETE
          SKIP
       ENDDO
       SELECT cabecera
       vkey = oper_fin+STR(nro_sec)
       REPLACE stat WITH 'X'
       = TABLEUPDATE()
       SELECT linea
       = SEEK(vkey)
       DO WHILE oper_fin+STR(nro_sec)=vkey .AND.  .NOT. EOF()
          REPLACE stat WITH 'X'
          SKIP
       ENDDO
       = TABLEUPDATE(.T.)
       SELECT cabecera
       END TRANSACTION
 ENDCASE
 RETURN
ENDFUNC
**
FUNCTION VALIDA_FECHA_EMISION
 LPARAMETERS vfecha_emision
 IF MONTH(vfecha_emision)<>MONTH(a_fecha) .OR. YEAR(vfecha_emision)<>YEAR(a_fecha)
    = MESSAGEBOX('Fecha no corresponde al mes de '+ALLTRIM(CMONTH(a_fecha))+' del '+ALLTRIM(STR(YEAR(a_fecha))), 32, "Aviso DatEasy")
    RETURN .F.
 ENDIF
ENDFUNC
**
FUNCTION __FORMATO__
 LPARAMETERS _codigo_formato_, _ruta_de_dbf_, _ruta_de_frx_
 vdbf_actual = ALIAS()
 IF  .NOT. FILE(_ruta_de_dbf_+'c_forma.dbf') .OR.  .NOT. FILE(_ruta_de_dbf_+'l_forma.dbf')
    vmsg = 'Archivos no existen: c_forma.dbf, l_forma.dbf'+CHR(13)+" Verificar en :"+_ruta_de_dbf_
    = MESSAGEBOX(vmsg, 32, "Aviso DatEasy")
    vretorno = .F.
 ELSE
    IF  .NOT. USED("l_forma")
       USE _ruta_de_dbf_+'l_forma' ORDER CODIGO IN 0
    ENDIF
    vreporte_elegido = ''
    SELECT l_forma
    = SEEK(_codigo_formato_)
    DO WHILE codigo=_codigo_formato_ .AND.  .NOT. EOF()
       IF rpt_ok
          vreporte_elegido = ALLTRIM(dsc)
       ENDIF
       SKIP
    ENDDO
    IF  .NOT. FILE(_ruta_de_frx_+vreporte_elegido+'.frx')
       vmsg = 'Archivo de reporte no existe: '+vreporte_elegido+CHR(13)+' verificar en : '+_ruta_de_frx_
       = MESSAGEBOX(vmsg, 32, "Aviso DatEasy")
       vretorno = .F.
    ELSE
       vretorno = vreporte_elegido
    ENDIF
    IF  .NOT. EMPTY(vdbf_actual)
       SELECT &vdbf_actual
    ENDIF
    RETURN vretorno
 ENDIF
ENDFUNC
**
PROCEDURE _BARRA_
 PARAMETER j, n, r, l
 _SCREEN.activeform.lbltotal_procesados.caption = 'Total Procesados    :'+ALLTRIM(STR(j))
 _SCREEN.activeform.lbltotal_no_procesados.caption = 'Total no Procesados :'+ALLTRIM(STR(n))
 _SCREEN.activeform.lblporcentaje.caption = ALLTRIM(STR(r))+'%'
 _SCREEN.activeform.shp2.width = l
 RETURN
ENDPROC
**
PROCEDURE RECORD_EXIST
 LPARAMETERS nerror
 IF nerror=1884
    RETURN
 ENDIF
ENDPROC
**
FUNCTION UPD_ACCES
 LPARAMETERS vna
 catrib = a_ruta_exe+'BD\AD_ACCES'
 IF  .NOT. USED("_cAcces_")
    USE &catrib AGAIN ALIAS _cacces_ IN 0
 ENDIF
 vretorno = .T.
 IF SEEK(a_usuario+a_cemp+vmodulo_+STR(vna), '_cAcces_', 'UEMOO')
    vretorno = .F.
 ENDIF
 USE IN _cacces_
 RETURN vretorno
ENDFUNC
**
FUNCTION EXISTE_PRN
 LPARAMETERS vname
 error_prn_not = .T.
 verr_actual = ON('ERROR')
 ON ERROR DO error_prn
 SET PRINTER TO NAME &vname
 IF  .NOT. error_prn_not
    = MESSAGEBOX("Impresora de nombre "+vname+" no ha sido creado "+CHR(13)+"favor agregarlo en configuración de impresora", 32, "Aviso DatEasy")
 ENDIF
 IF  .NOT. EMPTY(verr_actual)
    ON ERRO &verr_actual
 ELSE
    ON ERROR
 ENDIF
 RETURN error_prn_not
ENDFUNC
**
PROCEDURE ERROR_PRN
 IF ERROR()=1957
    error_prn_not = .F.
 ENDIF
ENDPROC
**
FUNCTION Valida_serie
 LPARAMETERS vcodigo_tm, vtabla_hija, vcodigo_th, vcanti_, vnombre_art, vsal_ing
 vtabla_ = ALIAS()
 vsal_ing_ = IIF(TYPE("vSal_ing")="C", vsal_ing, "I")
 SELECT &vtabla_hija
 IF vsal_ing_="S"
    SET ORDER TO SAL_FACTU
 ENDIF
 = SEEK(vcodigo_tm)
 vcon_codi = 0
 DO WHILE &vcodigo_th == vcodigo_tm And Not Eof()
    IF vsal_ing_="S"
       IF  .NOT. EMPTY(nro_serie)
          IF flg_wrk_fa
             vcon_codi = vcon_codi+1
          ENDIF
       ENDIF
    ELSE
       IF  .NOT. EMPTY(nro_serie)
          vcon_codi = vcon_codi+1
       ENDIF
    ENDIF
    SKIP
 ENDDO
 IF vcon_codi<>vcanti_
    vmsg = "Cantidad de series del articulo :"+CHR(13)+ALLTRIM(vnombre_art)+" "+CHR(13)+"no es igual al nro de cantidades ingresadas "+CHR(13)+CHR(13)+"Cantidad ingresada : "+STR(vcanti_)+CHR(13)+"Cantidad de series : "+STR(vcon_codi)+CHR(13)+"Corregir datos "
    = MESSAGEBOX(vmsg, 32, "Aviso DatEasy")
    RELEASE vcon_codi
    RETURN .F.
 ENDIF
 RELEASE vcon_codi
 IF  .NOT. EMPTY(vtabla_)
    SELECT &vtabla_
 ENDIF
 RETURN
ENDFUNC
**
PROCEDURE Salida_serie
 LPARAMETERS vsalmacen
 SELECT cabecera
 vdoc = IIF(vsalmacen, oper_log, doc)
 vserie = doc_serie
 vnro = doc_nro
 vfch_ = doc_fch
 vcoa = coa
 SELECT temporal
 SCAN FOR serie_arti
    v_articulo = articulo
    valm = almacen
    SELECT al_nuser
    = SEEK(valm+v_articulo)
    DO WHILE alm_ing+articulo==valm+v_articulo .AND.  .NOT. EOF()
       IF flg_wrk_fa
          REPLACE alm_sal WITH valm, doc_sal WITH vdoc, doc_s_sal WITH vserie, doc_n_sal WITH vnro, coa_sal WITH vcoa, fch_sal WITH vfch_, flg_des WITH .T., fch_act_s WITH DATE(), hora_s WITH TIME(), usr_s WITH a_usuario
          IF  .NOT. vsalmacen
             REPLACE vendedor WITH cabecera.vendedor, zona WITH cabecera.zona IN al_nuser
          ENDIF
          = TABLEUPDATE(.F.)
       ENDIF
       SKIP
    ENDDO
    SELECT temporal
 ENDSCAN
 RETURN
ENDPROC
**
FUNCTION Trae_Direcciones
 LPARAMETERS vcoa, vupd_listar
 IF  .NOT. USED("cFa_dir")
    CREATE CURSOR cFa_dir (direccion C (FSIZE("direccion", "Fa_direc")), distrito C (FSIZE("Distrito", "Fa_direc")), provincia C (FSIZE("Provincia", "Fa_direc")), dpto C (FSIZE("Dpto", "Fa_direc")), codigo N (4), tipo C (1), flg_p L)
 ENDIF
 SELECT cfa_dir
 ZAP
 vdireccion = ''
 vexis_ok = SEEK(vcoa, "co_coa", "coa")
 IF vexis_ok
    vdireccion = co_coa.direccion
    IF  .NOT. EMPTY(vdireccion)
       INSERT INTO cFa_dir (direccion, distrito, provincia, dpto) VALUES (vdireccion, co_coa.distrito, co_coa.provincia, co_coa.dpto)
    ENDIF
    SELECT direccion, distrito, provincia, dpto, codigo, flg_p, tipo FROM Fa_direc WHERE UPPER(coa)==UPPER(vcoa) ORDER BY direccion INTO CURSOR A1
    cdbf = DBF("A1")
    SELECT cfa_dir
    APPEND FROM (cdbf)
    USE IN a1
    RELEASE cdbf
    GOTO TOP IN cfa_dir
 ENDIF
 IF vupd_listar
    REPLACE distrito WITH cfa_dir.distrito, provincia WITH cfa_dir.provincia, dpto WITH cfa_dir.dpto, cod_dir WITH cfa_dir.codigo IN cabecera
 ENDIF
 RETURN vdireccion
ENDFUNC
**
FUNCTION Trae_n_guias
 LPARAMETERS vdetalle, vkeyy
 CREATE CURSOR nroGui (doc_g C (FSIZE("doc", vdetalle)), ser_g C (FSIZE("doc_serie", vdetalle)), nro_g C (FSIZE("doc_nro", vdetalle)))
 vnro_guias = ''
 SELE &vdetalle
 SEEK vkeyy 
 DO WHILE doc+doc_serie+doc_nro=vkeyy .AND.  .NOT. EOF()
    INSERT INTO nroGui (doc_g, ser_g, nro_g) VALUES (EVALUATE(vdetalle+'.doc_ref_d'), EVALUATE(vdetalle+'.doc_ref_s'), EVALUATE(vdetalle+'.doc_ref_n'))
    SKIP
 ENDDO
 SELECT * FROM nroGui GROUP BY doc_g, ser_g, nro_g INTO CURSOR cnroGui
 GOTO TOP
 SCAN
    vnro_guias = vnro_guias+ALLTRIM(ser_g)+'-'+ALLTRIM(nro_g)+','
 ENDSCAN
 SELE &vdetalle
 SEEK vkeyy 
 RETURN SUBSTR(ALLTRIM(vnro_guias), 1, LEN(ALLTRIM(vnro_guias))-1)
ENDFUNC
**
PROCEDURE fStatPed
 LPARAMETERS vtotdoc, vmone_docu, vt_cambio
 SELECT fi_ctact
 vtag_actual = TAG()
 SET ORDER TO PENDIENTES
 = SEEK(m.coa)
 LOCAL vcargomof, vabonomof, vcargocon, vabonocon
 STORE 0 TO vcargomof, vabonomof, vcargocon, vabonocon
 DO WHILE coa=m.coa .AND.  .NOT. EOF()
    IF stat_canc<>'C'
       vcargomof = vcargomof+cargo_mof
       vabonomof = vabonomof+abono_mof
       vcargocon = vcargocon+cargo_con
       vabonocon = vabonocon+abono_con
    ENDIF
    SKIP
 ENDDO
 LOCAL vmoncred
 vmoncred = fa_tipos.mon
 tot0 = 0
 IF SEEK(m.coa, "CO_COA", "COA")
    tot0 = co_coa.credito
    vmoncred = co_coa.mon_cred
 ENDIF
 IF vmoncred="01"
    vsaldo = vcargomof-vabonomof
    IF vmone_docu="02"
       vtotdoc = vtotdoc*vt_cambio
    ENDIF
 ELSE
    vsaldo = vcargocon-vabonocon
    IF vmone_docu="01"
       vtotdoc = vtotdoc/vt_cambio
    ENDIF
 ENDIF
 tot = tot0-vsaldo
 IF tot<vtotdoc
    msg = 'Este pedido excede al Credito disponible en Moneda '+CHR(13)+IIF(vmoncred='01', 'Nacional', 'Extranjera')+CHR(13)+CHR(13)+'LIMITE CREDITO          :       '+RTRIM(STR(tot0, 15, 2))+CHR(13)+'CREDITO UTILIZADO       :     '+RTRIM(STR(vsaldo, 15, 2))+CHR(13)+'-----------------------------------------------------------------'+CHR(13)+'CREDITO DISPONIBLE     :    '+RTRIM(STR(tot, 15, 2))+CHR(13)+CHR(13)+'EL PEDIDO SERA RETENIDO'
    st = 'R'
 ENDIF
 GOTO TOP
 IF st='P'
    = SEEK(m.coa)
    DO WHILE coa=m.coa .AND.  .NOT. EOF()
       IF EMPTY(oper_fin)
          IF stat_canc<>'C' .AND. doc_fch_vc<=DATE()
             st = 'M'
             msg = 'Tiene Documento(s) Vencido(s)'
             EXIT
          ENDIF
       ENDIF
       SKIP
    ENDDO
 ENDIF
 IF st='P'
    = SEEK(m.coa)
    DO WHILE coa=m.coa .AND.  .NOT. EOF()
       IF stat_canc<>'C'
          IF UPPER(doc)='CD'
             st = 'C'
             msg = 'Cheque devuelto '+CHR(13)+CHR(13)+'NRO DE CHEQHE :  '+doc_nro
             EXIT
          ENDIF
          IF ubic_act='50'
             st = 'L'
             msg = 'Letra Protestada '+CHR(13)+CHR(13)+'NRO DE LETRA :'+doc_nro
             EXIT
          ENDIF
       ENDIF
       SKIP
    ENDDO
 ENDIF
 SELECT fi_ctact
 IF  .NOT. EMPTY(vtag_actual)
    SET ORDER TO TAG &vtag_actual
 ENDIF
ENDPROC
**
PROCEDURE Tra_afecto_inafecto
 LPARAMETERS vdocumento
 valias = ALIAS()
 SELECT fi_ctapg
 corder_actual = TAG()
 STORE 0 TO vmontoa, vmontoi, vabono_mn, vpago_parcial
 SET ORDER TO docoa
 = SEEK(vdocumento)
 DO WHILE coa+doc+doc_serie+doc_nro=vdocumento .AND.  .NOT. EOF()
    IF stat_canc<>"C"
       vmontoa = vmontoa+imp_a_mof
       vmontoi = vmontoi+imp_bi_mof
       vabono_mn = vabono_mn+abono_mof
       vpago_parcial = vpago_parcial+1
    ENDIF
    SKIP
 ENDDO
 SELECT fi_ctapg
 IF  .NOT. EMPTY(corder_actual)
    SET ORDER TO TAG &corder_actual
 ENDIF
 IF  .NOT. EMPTY(valias)
    SELECT &valias
 ENDIF
 RELEASE corder_actual, valias
 RETURN
ENDPROC
**
FUNCTION SLDACTIVO
 PARAMETER p1, p2, p3
 dmn1 = 0
 dme1 = 0
 dmn2 = 0
 dme2 = 0
 FOR i = p2 TO p3
    vdmn1 = 'SLDAFIJO->DME_'+PADL(ALLTRIM(STR(i)), 2, '0')+'_MN1'
    vdme1 = 'SLDAFIJO->DME_'+PADL(ALLTRIM(STR(i)), 2, '0')+'_ME1'
    vdmn2 = 'SLDAFIJO->DME_'+PADL(ALLTRIM(STR(i)), 2, '0')+'_MN2'
    vdme2 = 'SLDAFIJO->DME_'+PADL(ALLTRIM(STR(i)), 2, '0')+'_ME2'
    dmn1 = dmn1 + &vdmn1
    dme1 = dme1 + &vdme1
    dmn2 = dmn2 + &vdmn2
    dme2 = dme2 + &vdme2
 ENDFOR
 DO CASE
    CASE p1=1
       RETURN dmn1
    CASE p1=2
       RETURN dme1
    CASE p1=3
       RETURN dmn2
    CASE p1=4
       RETURN dme2
 ENDCASE
 RETURN
ENDFUNC
**
PROCEDURE Afecto_ina_factu
 LPARAMETERS xmon, vtemporal, vcabecera
 vtabla_defaul = ALIAS()
 SELECT (vtemporal)
 vcampo_iva = IIF(xmon='01', "imp_i_mof", "imp_i_con")
 SUM imp_b_mof, imp_b_con TO vafectomn, vafectome FOR tipo_linea="A"
 SUM imp_b_mof, imp_b_con TO vinafectomn, vinafectome FOR tipo_linea="I"
 SUM imp_d_mof, imp_d_con TO vdctoafmn, vdctoafme FOR tipo_linea="A"
 SUM imp_d_mof, imp_d_con TO vdctoinafmn, vdctoinafme FOR tipo_linea="I"
 REPLACE imp_ba_mof WITH vafectomn, imp_ba_con WITH vafectome, imp_bi_mof WITH vinafectomn, imp_bi_con WITH vinafectome, imp_da_mof WITH vdctoafmn, imp_da_con WITH vdctoafme, imp_di_mof WITH vdctoinafmn, imp_di_con WITH vdctoinafme IN (vcabecera)
 RELEASE vcampo_iva
 IF  .NOT. EMPTY(vtabla_defaul)
    SELECT (vtabla_defaul)
 ENDIF
 RETURN
ENDPROC
**
FUNCTION Val_Imp_Con_Sal_Doc
 LPARAMETERS tipo_ie, moneda_v, moneda_d
 file_ctacte = IIF(tipo_ie='I', 'Fi_ctact', 'Fi_ctapg')
 SELECT &file_ctacte
 clave = temporal.coa+temporal.doc+temporal.doc_serie+temporal.doc_nro
 SEEK (clave) 
 STORE 0 TO total_cargos, total_abonos, total_saldo
 DO WHILE coa=temporal.coa .AND. doc=temporal.doc .AND. doc_serie=temporal.doc_serie .AND. doc_nro=temporal.doc_nro .AND.  .NOT. EOF()
    total_cargos = total_cargos+IIF(moneda_d='01', cargo_mof, cargo_con)
    total_abonos = total_abonos+IIF(moneda_d='01', abono_mof, abono_con)
    SKIP
 ENDDO
 SELECT temporal
 IF tipo_ie='I'
    total_saldo = total_cargos-total_abonos
 ELSE
    total_saldo = total_abonos-total_cargos
 ENDIF
 msg = ''
 IF moneda_v=moneda_d
    importe_equiv_cobrar = IIF(moneda_d='01', temporal.abono_mn, temporal.abono_me)
    IF importe_equiv_cobrar>total_saldo
       msg = 'El importe a Cobrar en Moneda '+IIF(moneda_d='01', 'Nacional', 'Extranjera')+' excede al Saldo'+CHR(13)+'restante de este Documento en su Moneda Original ('+IIF(moneda_d='01', 'Nacional', 'Extranjera')+').'+CHR(13)+CHR(13)+'Importe a Cobrar en Moneda '+IIF(moneda_d='01', 'Nacional', 'Extranjera')+'   : '+STR(importe_equiv_cobrar, 19, 2)+CHR(13)+'Importe por Cobrar en Moneda '+IIF(moneda_d='01', 'Nacional', 'Extranjera')+' : '+STR(total_saldo, 19, 2)
    ENDIF
 ELSE
    IF moneda_v='01' .AND. moneda_d='02'
       importe_equiv_cobrar = ROUND(temporal.abono_mn/cabecera.t_cambio, 2)
       IF importe_equiv_cobrar>total_saldo
          importe_a_cobrar = temporal.abono_mn
          msg = 'El importe a Cobrar en Moneda Nacional excede al Saldo restante'+CHR(13)+'de este Documento en su Moneda Original ('+IIF(moneda_d='01', 'Nacional', 'Extranjera')+').'+CHR(13)+CHR(13)+'Importe a Cobrar en Moneda Nacional        : '+STR(importe_a_cobrar, 19, 2)+CHR(13)+'Importe a Cobrar Equiv. en Mon. Extranjera : '+STR(importe_equiv_cobrar, 19, 2)+CHR(13)+'Importe por Cobrar en Moneda Extranjera    : '+STR(total_saldo, 19, 2)
       ENDIF
    ENDIF
    IF moneda_v='02' .AND. moneda_d='01'
       importe_equiv_cobrar = ROUND(temporal.abono_me*cabecera.t_cambio, 2)
       IF importe_equiv_cobrar>total_saldo
          importe_a_cobrar = temporal.abono_me
          msg = 'El importe a Cobrar en Moneda Extranjera excede al Saldo restante'+CHR(13)+'de este Documento en su Moneda Original ('+IIF(moneda_d='01', 'Nacional', 'Extranjera')+').'+CHR(13)+CHR(13)+'Importe a Cobrar en Moneda Extranjera    : '+STR(importe_a_cobrar, 19, 2)+CHR(13)+'Importe a Cobrar Equiv. en Mon. Nacional : '+STR(importe_equiv_cobrar, 19, 2)+CHR(13)+'Importe por Cobrar en Moneda Nacional    : '+STR(total_saldo, 19, 2)
       ENDIF
    ENDIF
 ENDIF
 IF  .NOT. EMPTY(msg)
    _msg_ = 'Cod. Cliente : '+temporal.coa+CHR(13)+'N° Documento : '+temporal.doc+' - '+temporal.doc_serie+' - '+temporal.doc_nro+CHR(13)+CHR(13)+msg
    MESSAGEBOX(_msg_, 16, "Aviso DatEasy")
    IF moneda_d='01'
       REPLACE abono_mn WITH total_saldo IN temporal
       REPLACE abono_me WITH total_saldo/cabecera.t_cambio IN temporal
       REPLACE cargo_mn WITH cargo_me*cabecera.t_cambio IN temporal
    ELSE
       REPLACE abono_me WITH total_saldo IN temporal
       REPLACE abono_mn WITH total_saldo*cabecera.t_cambio IN temporal
       REPLACE cargo_me WITH cargo_mn/cabecera.t_cambio IN temporal
    ENDIF
    RETURN .F.
 ENDIF
ENDFUNC
**
FUNCTION SAVE_ING_ALMACEN_LOTE
 LPARAMETERS vtran_ok, voper_tran, varticulo, vingreso_factu
 cvingreso_factu = IIF(TYPE("VINGRESO_FACTU")="L", "A", vingreso_factu)
 SELECT cabecera
 m.doc_fch = doc_fch
 m.fch_act = DATE()
 m.hora = TIME()
 m.usr = a_usuario
 m.ej = ALLTRIM(STR(YEAR(a_fecha)))
 m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
 vindice = "Articulo"
 IF cvingreso_factu="M"
    vindice = "Articuloi"
 ENDIF
 SELECT cal_mlote
 = SEEK(varticulo, "Cal_mlote", vindice)
 PRIVATE un_tmp, cos_tmn, cos_tme, cos_umn, cos_ume
 STORE 0 TO un_tmp, cos_tmn, cos_tme, cos_umn, cos_ume
 DO WHILE articulo=varticulo .AND.  .NOT. EOF()
    IF  .NOT. EMPTY(lote) .AND. IIF(vtran_ok, und_s>0, .T.)
       IF cvingreso_factu="M"
          STORE '' TO m.clase, m.sub_clase, m.um, m.artic_dsc
          IF SEEK(varticulo, 'AL_ARTIC', 'ARTICULO')
             m.clase = al_artic.clase
             m.sub_clase = al_artic.sub_clase
             m.um = al_artic.um
          ENDIF
          REPLACE um WITH m.um, clase WITH m.clase, sub_clase WITH m.sub_clase
       ELSE
          REPLACE um WITH temporal.um, clase WITH temporal.clase, sub_clase WITH temporal.sub_clase
       ENDIF
       REPLACE ej WITH m.ej, mes WITH m.mes, stat WITH "A", doc_serie WITH cabecera.doc_serie, doc_nro WITH cabecera.doc_nro, doc_fch WITH cabecera.doc_fch, fch_lote WITH cabecera.doc_fch, t_cambio WITH IIF(cvingreso_factu="A", temporal.t_cambio, cabecera.t_cambio), coa WITH cabecera.coa
       IF cvingreso_factu="A"
          REPLACE almacen WITH IIF(vtran_ok, cabecera.almacen_t, cabecera.almacen), almacen_t WITH IIF(vtran_ok, '', cabecera.almacen_t), oper_log WITH IIF(vtran_ok, voper_tran, cabecera.oper_log), origen WITH temporal.origen, mon_ext WITH temporal.mon_ext
       ELSE
          IF cvingreso_factu="M"
             REPLACE almacen WITH cabecera.almacen_i, oper_log WITH cabecera.oper_log, origen WITH "M", mon_ext WITH cabecera.mon_ext
          ELSE
             REPLACE almacen WITH temporal.almacen, oper_log WITH temporal.oper_log, origen WITH "", mon_ext WITH temporal.mon
          ENDIF
       ENDIF
       un_tmp = IIF(vtran_ok, und_s, und_i)
       REPLACE und_s WITH 0
       SCATTER MEMVAR
       IF cvingreso_factu="A"
          IF cabecera.origen='C'
             m.doc_ref = ALLTRIM(temporal.ord_tip)+' '+ALLTRIM(temporal.ord_ser)+' '+ALLTRIM(temporal.ord_nro)
          ENDIF
       ELSE
          IF cvingreso_factu="M"
             m.doc_ref = cabecera.parte_mezc
          ELSE
             m.doc_ref = temporal.doc
          ENDIF
       ENDIF
       IF vtran_ok
          m.mon_ext = '01'
          m.oper_log = voper_tran
          m.almacen = almacen
          key_1 = ej+mes+almacen+articulo+lote
          m.almacen_t = ""
       ELSE
          key_1 = ej+mes+almacen+articulo+lote
       ENDIF
       SELECT al_slote
       IF  .NOT. SEEK(key_1, "al_slote", "maestro1")
          INSERT INTO al_slote FROM MEMVAR
          REPLACE und_ti WITH un_tmp, und_mi WITH un_tmp
       ELSE
          GATHER MEMVAR
          REPLACE und_ti WITH und_ti+(un_tmp), und_mi WITH und_mi+(un_tmp)
       ENDIF
       IF  .NOT. SEEK(key_1, "al_slote", "maestro1")
          WAIT WINDOW "El producto :"+cal_mlote.articulo+" no se guardo en los saldos "+CHR(13)+"del almacen por lotes: "+cal_mlote.almacen+" Si el problema persiste realize el"+CHR(13)+"proceso de reindexado, de lo contrario comuniquese con su proveedor"+CHR(13)+CHR(13)+"La transacción sera cancelada"
          RETURN .F.
       ENDIF
       uta = und_ti-und_ts
       SELECT al_mlote
       INSERT INTO AL_mlote FROM MEMVAR
       REPLACE und_ta WITH uta, und_i WITH un_tmp
       RELEASE uta, un_tmp, key_1
    ENDIF
    SELECT cal_mlote
    SKIP
 ENDDO
 RELEASE cvingreso_factu
ENDFUNC
**
FUNCTION SAVE_SAL_ALMACEN_LOTE
 LPARAMETERS varticulo, vmodulo
 SELECT cabecera
 m.doc_fch = doc_fch
 m.fch_act = DATE()
 m.hora = TIME()
 m.usr = a_usuario
 m.ej = ALLTRIM(STR(YEAR(a_fecha)))
 m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
 vindice = "Articulo"
 IF vmodulo="M"
    vindice = "Articulos"
 ENDIF
 SELECT cal_mlote
 = SEEK(varticulo, "Cal_mlote", vindice)
 DO WHILE articulo=varticulo .AND.  .NOT. EOF()
    IF  .NOT. EMPTY(lote) .AND. und_s>0
       IF vmodulo="M"
          REPLACE almacen WITH temporal.almacen_s, oper_log WITH temporal.oper_log_s, doc_serie WITH temporal.serie_s, doc_nro WITH temporal.doc_nro_s
       ELSE
          REPLACE almacen WITH temporal.almacen, oper_log WITH temporal.oper_log, doc_serie WITH temporal.doc_serie, doc_nro WITH temporal.doc_nro
       ENDIF
       REPLACE ej WITH m.ej, mes WITH m.mes, um WITH temporal.um, clase WITH temporal.clase, sub_clase WITH temporal.sub_clase, doc_fch WITH temporal.doc_fch, fch_lote WITH temporal.doc_fch, t_cambio WITH cabecera.t_cambio, almacen_t WITH IIF(vmodulo="A", temporal.almacen_t, ''), mon_ext WITH IIF(vmodulo="F", temporal.mon, temporal.mon_ext), origen WITH IIF(vmodulo="F", '', temporal.origen), stat WITH "A"
       un_tmp = und_s
       IF vmodulo="A"
       ENDIF
       SCATTER MEMO MEMVAR
       m.fch_lote = doc_fch
       m.t_estad = ''
       IF vmodulo="F"
          un_tmp = IIF(EMPTY(temporal.cod_conv), und_s, und_s*temporal.und_ped)
          m.doc_ref = temporal.doc
       ELSE
          IF vmodulo="M"
             m.doc_ref = cabecera.parte_mezc
          ENDIF
       ENDIF
       key_1 = ej+mes+almacen+articulo+lote
       IF  .NOT. SEEK(key_1, "al_slote", "maestro1")
          WAIT WINDOW TIMEOUT 3 "El producto :"+temporal.articulo+" no existe en los saldos "+CHR(13)+"del almacen por lotes: "+cal_mlote.almacen+" lote : "+m.lote+" no se puede realizar una salida"+CHR(13)+"sin stock del almacen"+CHR(13)+CHR(13)+"La transacción sera cancelada"
          RETURN .F.
       ENDIF
       SELECT al_slote
       IF  .NOT. SEEK(key_1, "al_slote", "maestro1")
          APPEND BLANK
          GATHER MEMVAR
          REPLACE und_ts WITH un_tmp, und_ms WITH un_tmp
       ELSE
          IF vmodulo="F"
          ENDIF
          GATHER MEMVAR
          REPLACE und_ts WITH und_ts+(un_tmp), und_ms WITH und_ms+(un_tmp)
       ENDIF
       uta = und_ti-und_ts
       SELECT al_mlote
       APPEND BLANK
       GATHER MEMO MEMVAR
       REPLACE und_ta WITH uta, und_s WITH un_tmp
    ENDIF
    SELECT cal_mlote
    SKIP
 ENDDO
ENDFUNC
**
PROCEDURE Sal_Lotes
 LPARAMETERS valor_ok, _nuevo_, vmodulo
 IF vmodulo="M"
    m.almacen = cabecera.almacen_s
    m.oper_log = cabecera.oper_log_s
    m.doc_serie = cabecera.serie_s
    m.doc_nro = cabecera.doc_nro_s
 ELSE
    m.almacen = cabecera.almacen
    m.oper_log = cabecera.oper_log
    m.doc_serie = cabecera.doc_serie
    m.doc_nro = cabecera.doc_nro
 ENDIF
 m.stat = cabecera.stat
 m.ej = ALLTRIM(STR(YEAR(a_fecha)))
 m.mes = PADL(ALLTRIM(STR(MONTH(a_fecha))), 2, "0")
 USE a_ruta+"al_entor" AGAIN ALIAS al_en__ IN 0
 vrespeta_fch_vcto = IIF(TYPE("al_en__.tipo_cont4")="N", .T., .F.)
 IF vrespeta_fch_vcto
    vrespeta_fch_vcto = al_en__.tipo_cont4=1
 ENDIF
 USE IN al_en__
 SELECT temporal
 IF valor_ok
    IF (_nuevo_ .OR. m.stat="E")
       GOTO TOP IN cal_mlote
       vtable_ = "cAl_mlote"
       vdsc_ar_ = ALLTRIM(temporal.artic_dsc)
       vtag_ = 'N'
       vund_ = und
       vdemark_ = .T.
       SELECT almacen, articulo, lote, und_ti-und_ts AS und_ta, fch_vcto FROM al_slote WHERE ej+mes+almacen+articulo=m.ej+m.mes+m.almacen+temporal.articulo AND und_ti-und_ts>0 ORDER BY fch_vcto INTO CURSOR cal_slote
       GOTO TOP
       SCAN
          ct_estad = IIF(fch_vcto<cabecera.doc_fch .AND. vrespeta_fch_vcto, "V", "")
          m.tipo_reg = ""
          vorden_asi = "nro_lote"
          IF vmodulo="M"
             m.tipo_reg = "S"
             vorden_asi = "nro_lotes"
          ENDIF
          IF  .NOT. SEEK(articulo+lote, "cal_mlote", vorden_asi)
             SCATTER MEMO MEMVAR
             m.t_estad = ct_estad
             INSERT INTO CAL_mlote FROM MEMVAR
          ELSE
             REPLACE und_ta WITH cal_slote.und_ta, t_estad WITH ct_estad IN cal_mlote
             IF cal_slote.fch_vcto<cabecera.doc_fch
                REPLACE fch_vcto WITH cal_slote.fch_vcto, und_s WITH 0 IN cal_mlote
             ENDIF
          ENDIF
       ENDSCAN
    ELSE
       IF IIF(vmodulo="F", INLIST(m.stat, "P", "A"), m.stat='A')
          vwhere = "ej + mes + almacen + oper_log + doc_serie + Doc_nro + articulo=				M.ej+M.mes+M.almacen+M.oper_log+M.doc_serie+M.doc_nro+Temporal.articulo"
          SELECT articulo,lote,fch_vcto,und_ta+und_s AS und_ta,und_s,und_i FROM al_mlote WHERE &vwhere INTO CURSOR s1
          GOTO TOP IN s1
          vtable_ = "S1"
          vdsc_ar_ = ALLTRIM(temporal.artic_dsc)
          vtag_ = 'A'
          vund_ = temporal.und
          vdemark_ = .F.
       ENDIF
    ENDIF
    DO FORM \ttl7\FRM\lotes WITH vtable_, vdsc_ar_, vtag_, vund_, vdemark_, .T., .F., vmodulo
 ENDIF
 RETURN
ENDPROC
**
PROCEDURE Detalle_Lote
 LPARAMETERS tipo
 CREATE CURSOR lotes (articulo C (20), detalle M)
 SELECT linea
 GOTO TOP
 SEEK (cabecera.almacen+cabecera.oper_log+cabecera.doc_serie+cabecera.doc_nro) 
 DO WHILE almacen+oper_log+doc_serie+doc_nro=cabecera.almacen+cabecera.oper_log+cabecera.doc_serie+cabecera.doc_nro .AND.  .NOT. EOF()
    IF EMPTY(linea.reg_orig)
       SELECT linea
       SKIP
       LOOP
    ENDIF
    IF tipo="I"
       campos = 'articulo,lote,fch_vcto,und_i'
       detalle = 'PADR(ALLTRIM(Detalle.LOTE),15," ")  + SPACE(5) + ALLTRIM(DTOC(Detalle.FCH_VCTO)) + SPACE(5) + PADL(ALLTRIM(STR(Detalle.und_i,13,2)),14," ")'
    ELSE
       campos = 'articulo,lote,fch_vcto,UND_S'
       detalle = 'PADR(ALLTRIM(Detalle.LOTE),15," ")  + SPACE(5) + ALLTRIM(DTOC(Detalle.FCH_VCTO)) + SPACE(5) + PADL(ALLTRIM(STR(detalle.und_s,13,2)),14," ")'
    ENDIF
    SELECT lotes
    APPEND BLANK
    REPLACE articulo WITH linea.articulo IN lotes
    REPLACE detalle WITH '     LOTE           FECH. VCTO         CANTIDAD' IN lotes
    SELECT &campos FROM al_mlote WHERE ej + mes + almacen + oper_log + doc_serie + doc_nro + articulo  = cabecera.ej+cabecera.mes+cabecera.almacen+cabecera.oper_log+cabecera.doc_serie+cabecera.doc_nro+linea.articulo INTO CURSOR detalle
    DO WHILE  .NOT. EOF()
       REPLACE detalle WITH detalle + CHR(13) +  &detalle IN lotes
       SKIP
    ENDDO
    USE IN detalle
    SELECT linea
    SKIP
 ENDDO
ENDPROC
**
PROCEDURE Cuadra_detalle
 LPARAMETERS vdetalle, sumar_a_detalle, sumar_a_cabecera, campo_total_cabecera
 DO CASE
    CASE INLIST(vdetalle, "P", "H")
       PRIVATE tota_detalle, total_cacebera
       tota_detalle = 0
       m.t_cambio = cabecera.t_cambio
       tota_detalle = IIF(cabecera.mon='01', tota_dme, tota_dmn)
       IF vdetalle="P"
          total_cacebera = IIF(cabecera.mon='01', cabecera.imp_t_con, cabecera.imp_t_mof)
       ELSE
          total_cacebera = IIF(cabecera.mon='01', cabecera.imp_n_con, cabecera.imp_n_mof)
       ENDIF
       IF TYPE("sumar_a_detalle")="C"
          tota_detalle = tota_detalle + &sumar_a_detalle
       ENDIF
       IF TYPE("sumar_a_cabecera")="C"
          total_cacebera = total_cacebera+ &sumar_a_cabecera
       ENDIF
       IF total_cacebera<>tota_detalle
          IF total_cacebera>tota_detalle
             vdif = total_cacebera-tota_detalle
             signo_ = "-"
          ELSE
             vdif = tota_detalle-total_cacebera
             signo_ = "+"
          ENDIF
          REPLACE &campo_total_cabecera WITH &campo_total_cabecera &signo_ vdif IN cabecera
       ENDIF
       SELECT cabecera
 ENDCASE
ENDPROC
**
PROCEDURE Detecta_indices_dañados
 PRIVATE orden_actual, cerror_actual
 = AUSED(vdbf_open)
 IF TYPE("vDbf_open")="U"
    RETURN
 ENDIF
 CREATE CURSOR Imalos (codigo C (15), obs M, ruta_file C (30))
 INDEX ON codigo TAG codigo
 cerror_actual = ON("Error")
 vopen_ok = .T.
 hay_problemas = .F.
 ON ERROR DO trata_error WITH ERROR()
 FOR tdbf_open = 1 TO ALEN(vdbf_open, 1)
    vname_table = UPPER((ALLTRIM(vdbf_open(tdbf_open, 1))))
    IF JUSTEXT(DBF(vname_table))="TMP"
       LOOP
    ENDIF
    SELECT (vname_table)
    orden_actual = TAG()
    total_indices = TAGCOUNT()
    FOR tcdx = 1 TO total_indices
       vtag = TAG(tcdx)
       SET ORDER TO (vtag)
       LOCATE FOR 2=3
       IF  .NOT. vopen_ok
          vopen_ok = .T.
          hay_problemas = .T.
          vmsg = "Nombre del indice   : "+vtag+CHR(13)+"Información       : "+MESSAGE()
          IF  .NOT. SEEK(vname_table, "imalos", "codigo")
             INSERT INTO Imalos (codigo, obs, ruta_file) VALUES (vname_table, vmsg, JUSTPATH(DBF(vname_table)))
          ELSE
             REPLACE obs WITH imalos.obs+CHR(13)+vmsg IN imalos
          ENDIF
       ENDIF
    ENDFOR
    IF  .NOT. EMPTY(orden_actual)
       SET ORDER IN (vname_table) TO (orden_actual)
    ENDIF
 ENDFOR
 IF  .NOT. EMPTY(cerror_actual)
    ON ERROR &cerror_actual
 ELSE
    ON ERROR
 ENDIF
 RELEASE vdbf_open
 IF hay_problemas
    IF MESSAGEBOX("El sistema detecto inconsistencias en las bases de datos por problemas fisicos"+CHR(13)+"Es necesario su impresión de estos datos", 036, "Aviso DatEasy")=6
       SELECT imalos
       REPORT FORM \ttl7\reportes\dañados PREVIEW
    ENDIF
    FOR xs = 1 TO TXNLEVEL()
       ROLLBACK
    ENDFOR
    = exit_systema(.T.)
 ENDIF
 USE IN imalos
ENDPROC
**
FUNCTION SystemDir
 LOCAL lcpath, lnsize
 lcpath = SPACE(255)
 lnsize = 255
 DECLARE INTEGER GetSystemDirectory IN Win32API STRING @, INTEGER
 lnsize = getsystemdirectory(@lcpath, lnsize)
 IF lnsize<=0
    lcpath = ""
 ELSE
    lcpath = ADDBS(SUBSTR(lcpath, 1, lnsize))
 ENDIF
 RETURN lcpath
ENDFUNC
**
FUNCTION AVANZADO
 SELECT avanzado_hasta
 SET ORDER TO
 COUNT TO vcant
 IF vcant>0
    rango_v = ''
    SELECT DISTINCT campo AS campo, alias AS alias FROM Avanzado_hasta INTO CURSOR Campos
    DO WHILE  .NOT. EOF()
       SELECT * FROM Avanzado_hasta WHERE campo=campos.campo INTO CURSOR Procesar
       rango_s = ''
       cont_items = 0
       DO WHILE  .NOT. EOF()
          rango_s = rango_s+"'"+ALLTRIM(procesar.codigo)+"',"
          cont_items = cont_items+1
          IF cont_items>24
             EXIT
          ENDIF
          SKIP
       ENDDO
       IF cont_items<25
          rango_s = "INLIST("+IIF(EMPTY(campos.alias), '', ALLTRIM(campos.alias)+".")+ALLTRIM(campos.campo)+","+LEFT(rango_s, LEN(rango_s)-1)+")"
          rango_v = rango_v+rango_s+" And "
       ELSE
          rango_v = rango_v+IIF(EMPTY(campos.alias), '', ALLTRIM(campos.alias)+".")+ALLTRIM(campos.campo)+" In (Select Codigo"+" From Avanzado_Hasta Where ALLTRIM(Campo) = '"+ALLTRIM(campos.campo)+"') And "
       ENDIF
       SELECT campos
       SKIP
    ENDDO
    rango_v = LEFT(rango_v, LEN(rango_v)-4)
 ELSE
    rango_v = '.T.'
 ENDIF
 IF USED('Campos')
    USE IN campos
 ENDIF
 IF USED('Procesar')
    USE IN procesar
 ENDIF
 RELEASE rango_s
 RETURN rango_v
ENDFUNC
**
FUNCTION cQuery_var
 LPARAMETERS vcampos, ctabla_extraer, cmas_tablas, vmaswhere, vorder_by, ctabla_llena, csimple
 vcquerys = IIF( .NOT. csimple, "cQuery", "cQuerys")
 SELECT (vcquerys)
 vlike = ''
 vlista_ok = .F.
 IF USED("Avanzado_hasta")
    UPDATE Avanzado_hasta SET tag = ""
 ENDIF
 SCAN FOR  .NOT. EMPTY(ccampos) .AND.  .NOT. EMPTY(ccriterio)
    IF TYPE("cotro")="C"
       IF UPPER(ALLTRIM(cotro))="L"
          vvccampos = UPPER(ALLTRIM(ccampos))
          UPDATE Avanzado_hasta SET tag = "N" WHERE UPPER(ALLTRIM(campo))==vvccampos
          vlista_ok = .T.
          SELECT (vcquerys)
          LOOP
       ENDIF
    ENDIF
    vvalor_digitado = UPPER(ALLTRIM(cvalor))
    vvalor_digitado = IIF(EMPTY(vvalor_digitado), [''], vvalor_digitado)
    vvalor_cbo = IIF(EMPTY(cvar), "a.", ALLTRIM(cvar)+".")+ALLTRIM(ccampos)
    ctabla_extraer_mas_campo = IIF(EMPTY(cvar), ctabla_extraer, ALLTRIM(cvar))+"."+ALLTRIM(ccampos)
    vcriterio = UPPER(ALLTRIM(ccriterio))
    IF vcriterio="LIKE"
       IF TYPE(ctabla_extraer_mas_campo)="C"
          IF  .NOT. EMPTY(vvalor_digitado)
             vvalor_digitado = 'UPPER(allt('+vvalor_cbo+')) like '+'"%'+vvalor_digitado+'%"'
          ELSE
             vvalor_digitado = 'UPPER(allt('+vvalor_cbo+')) like '+'"%'+''+'%"'
          ENDIF
       ENDIF
       IF TYPE(ctabla_extraer_mas_campo)="D"
          vvalor_digitado = 'UPPER(allt(dtoc('+vvalor_cbo+'))) like '+'"%'+vvalor_digitado+'%"'
       ENDIF
       IF TYPE(ctabla_extraer_mas_campo)="N"
          vvalor_digitado = 'UPPER(allt(str('+vvalor_cbo+',15,3))) like '+'"%'+vvalor_digitado+'%"'
       ENDIF
       vvalor_cbo = ''
       ccriterio = ''
    ELSE
       IF vcriterio='='
          IF TYPE(ctabla_extraer_mas_campo)="C"
             vvalor_digitado = "["+vvalor_digitado+"]"
          ELSE
             IF TYPE(ctabla_extraer_mas_campo)="D"
                vvalor_digitado = "ctod(["+vvalor_digitado+"])"
             ENDIF
          ENDIF
       ELSE
          IF INLIST(vcriterio, "IN", "BETWEEN") .AND. TYPE(ctabla_extraer_mas_campo)="D"
             vvalor_cbo = 'UPPER(allt(dtoc('+vvalor_cbo+')))'
          ENDIF
       ENDIF
    ENDIF
    vlike = vlike+ALLTRIM(vvalor_cbo)+" "+IIF(cnot .AND. vcriterio<>'IN', " !", IIF(cnot .AND. vcriterio='IN', " Not ", " "))+""+IIF(vcriterio='LIKE', ' ', IIF(vcriterio="IN", vcriterio+"(", ccriterio))+" "+vvalor_digitado+IIF(vcriterio="IN", ")", " ")+ALLTRIM(coperador)+" "
 ENDSCAN
 rango_v = ".t."
 IF vlista_ok
    hay_and = RIGHT(UPPER(ALLTRIM(vlike)), 4)
    vlike = IIF(AT("AND", hay_and)>0, SUBSTR(vlike, 1, LEN(vlike)-4), vlike)
    DELETE FROM Avanzado_hasta WHERE tag<>"N"
    rango_v = avanzado()
 ENDIF
 IF EMPTY(vlike)
    vlike = '.t.'
 ENDIF
 vlike = "("+vlike+")"
 cerror = ON("Error")
 cmas_tablas = IIF(EMPTY(cmas_tablas), "", UPPER(cmas_tablas))
 cmas_tablas = "a "+IIF( .NOT. EMPTY(cmas_tablas), IIF("JOIN"$cmas_tablas, cmas_tablas, ", "+cmas_tablas), "")
 vopen_ok = .T.
 cenestecursor = "INTO CURSOR cFa_cgui"
 cselect_o_cursor = UPPER(ctabla_llena)
 csolo_select = AT("ENESTECURSOR", cselect_o_cursor)>0
 IF csolo_select
    cenestecursor = SUBSTR(cselect_o_cursor, 1, AT("ENESTECURSOR", cselect_o_cursor)-2)
    cenestecursor = "INTO CURSOR "+cenestecursor
 ENDIF
 ON ERROR DO trata_error WITH ERROR()
 SELECT &vcampos FROM &ctabla_extraer &cmas_tablas  WHERE &vlike AND &rango_v AND &vmaswhere ORDER BY &vorder_by &cenestecursor
 RELEASE cenestecursor
 IF  .NOT. EMPTY(cerror)
    ON ERROR &cerror
 ELSE
    ON ERROR
 ENDIF
 IF  .NOT. vopen_ok
    = MESSAGEBOX("Error de sintaxis, Por favor revise las expresiones", 32, "Aviso DatEasy", 5000)
    IF  .NOT. csolo_select
       ZAP IN (ctabla_llena)
    ENDIF
    RETURN .F.
 ENDIF
 IF  .NOT. csolo_select
    SELECT (ctabla_llena)
    ZAP
    APPEND FROM (DBF("cFa_cgui"))
 ENDIF
 RELEASE csolo_cursor, vcriterio, vlista_ok
ENDFUNC
**
FUNCTION Valida_concepto
 LPARAMETERS cconcepto_digitado
 SELECT a.ok, INT(VAL(a.codigo)) AS codigo FROM ad_perfi a WHERE cod_emp=a_cemp AND cod_usr=a_usuario AND INT(VAL(a.codigo))=cconcepto_digitado AND a.tipo="CO" AND a.ok INTO CURSOR cConcept
 RETURN IIF(_TALLY=0, .F., .T.)
ENDFUNC
**
FUNCTION Fva_cta_corriente
 LPARAMETERS vruta, vcodigo
 PRIVATE ctabla_tmp
 ctabla_tmp = ALIAS()
 creturn = .T.
 SELECT 0
 cselect = "cfi_do"+ALLTRIM(STR(SELECT()))
 USE vruta+"fi_docum" AGAIN ALIAS (cselect)
 SELECT * FROM ALIAS() WHERE UPPER(ALLTRIM(doc))=ALLTRIM(UPPER(vcodigo)) INTO CURSOR cDocu_
 IF _TALLY>0
    creturn = UPPER(ALLTRIM(flg_cte))="S"
 ELSE
    creturn = .F.
 ENDIF
 USE IN cdocu_
 USE IN (cselect)
 IF  .NOT. EMPTY(ctabla_tmp) .AND. USED(ctabla_tmp)
    SELECT &ctabla_tmp
 ENDIF
 RETURN creturn
ENDFUNC
**
FUNCTION cCUENTA_REGISTRO
 LPARAMETERS ctable, vcond
 valias_a = ALIAS()
 SELECT (ctable)
 vcondicion = ' NOT EOF() '
 IF TYPE('vCOND')<>'L'
    vcondicion = vcond
 ENDIF
 SELECT * FROM ALIAS() INTO CURSOR DDSSS
 _xx_ = _TALLY
 USE IN ddsss
 IF  .NOT. EMPTY(valias_a)
    SELECT (valias_a)
 ENDIF
 RETURN _xx_
ENDFUNC
**
PROCEDURE bienve_modulo
 LPARAMETERS vopcion
 USE SHARED a_ruta_exe+"BD\AD_MENU"
 = SEEK(vopcion, 'AD_MENU', 'MOD')
 msg = 'Bienvenidos al  '+ALLTRIM(dsc)+CHR(13)+'Este es un sistema de Demostracion'+CHR(13)+CHR(13)+'No puede crear , modificar, ni eliminar registros en tablas'+CHR(13)+'Este modulo contiene datos para que los revise y le sirva de referencia'+CHR(13)+'Puede Crear :'+CHR(13)+'- Hasta 50 documentos de cada movimientos. '+CHR(13)+"Nuestra dirección Web es  http://www.microsig.com"+CHR(13)+"Nuestro E-Mail es         info@microsig.com"
 = MESSAGEBOX(msg, 64, "Aviso DatEasy")
 USE
ENDPROC
**
PROCEDURE A_AUDITORIA
 LPARAMETERS ctabla_var, _ctipo_modi_
 cerror = ON("Error")
 vopen_ok = .T.
 ON ERROR DO trata_error WITH ERROR()
 vtantos_campos = AFIELDS(vtodos_campos, ctabla_var)
 lhay_modificaciones = .F.
 cstring_cambios = ''
 FOR tcampos = 1 TO vtantos_campos
    cnombre_campo = ALLTRIM(vtodos_campos(tcampos, 1))
    ctipo_dato = vtodos_campos(tcampos, 2)
    IF GETFLDSTATE(cnombre_campo, ctabla_var)<>1
       lhay_modificaciones = .T.
       cvalor_digitado = ''
       cvalor_antiguo = OLDVAL(ctabla_var+"."+cnombre_campo)
       DO CASE
          CASE ctipo_dato="C"
             cvalor_digitado = EVALUATE(ctabla_var+"."+cnombre_campo)
          CASE ctipo_dato="D"
             cvalor_digitado = DTOC(EVALUATE(ctabla_var+"."+cnombre_campo))
             cvalor_antiguo = DTOC(cvalor_antiguo)
          CASE ctipo_dato="L"
             cvalor_digitado = IIF(EVALUATE(ctabla_var+"."+cnombre_campo), ".T.", ".F.")
             cvalor_antiguo = IIF(cvalor_antiguo, ".T.", ".F.")
          CASE ctipo_dato="M"
             cvalor_digitado = EVALUATE(ctabla_var+"."+cnombre_campo)
          CASE ctipo_dato="N"
             cvalor_digitado = ALLTRIM(STR(EVALUATE(ctabla_var+"."+cnombre_campo), 18, 2))
             cvalor_antiguo = ALLTRIM(STR(cvalor_antiguo, 18, 2))
          CASE ctipo_dato="F"
             cvalor_digitado = ALLTRIM(STR(EVALUATE(ctabla_var+"."+cnombre_campo)))
             cvalor_antiguo = ALLTRIM(STR(cvalor_antiguo))
          CASE ctipo_dato="I"
             cvalor_digitado = ALLTRIM(STR(EVALUATE(ctabla_var+"."+cnombre_campo)))
             cvalor_antiguo = ALLTRIM(STR(cvalor_antiguo))
          CASE ctipo_dato="B"
             cvalor_digitado = ALLTRIM(STR(EVALUATE(ctabla_var+"."+cnombre_campo)))
             cvalor_antiguo = ALLTRIM(STR(cvalor_antiguo))
          CASE ctipo_dato="Y"
             cvalor_digitado = ALLTRIM(STR(EVALUATE(ctabla_var+"."+cnombre_campo)))
             cvalor_antiguo = ALLTRIM(STR(cvalor_antiguo))
          CASE ctipo_dato="T"
             cvalor_digitado = DTOC(EVALUATE(ctabla_var+"."+cnombre_campo))
             cvalor_antiguo = DTOC(cvalor_antiguo)
          CASE ctipo_dato="G"
             cvalor_antiguo = 'general'
       ENDCASE
       cstring_cambios = cstring_cambios+"Nombre de campo : "+cnombre_campo+CHR(13)+"Valor Antiguo   : "+cvalor_antiguo+CHR(13)+"Valor Nuevo     : "+cvalor_digitado+CHR(13)
    ENDIF
 ENDFOR
 m.tipo = IIF(TYPE("_cTipo_modi_")="L", "M", _ctipo_modi_)
 IF lhay_modificaciones .OR. m.tipo="E"
    IF  .NOT. USED("ad___audi")
       IF FILE(a_ruta_exe+"bd\ad_audit.dbf")
          USE SHARED a_ruta_exe+"bd\ad_audit" AGAIN ALIAS ad___audi IN 0
          m.emp = a_cemp
          m.tabla = ctabla_var
          vprimary_valor = ''
          SELECT (ctabla_var)
          FOR cprymari = 1 TO TAGCOUNT()
             IF PRIMARY(cprymari)
                vprimary_valor = KEY(cprymari)
                vprimary_valor = EVALUATE(vprimary_valor)
                EXIT
             ENDIF
          ENDFOR
          cdtos1 = IIF(m.tipo="E", "Usuario que elimino : ", "Usuario que modifico : ")
          cdtos2 = IIF(m.tipo="E", "Datos eliminados : ", "Datos modificados : ")
          IF TYPE("vPrimary_valor")="N"
             m.keyp = ALLTRIM(STR(vprimary_valor))
          ELSE
             m.keyp = vprimary_valor
          ENDIF
          m.fch_act = DATE()
          m.hora = TIME()
          m.usr = a_usuario
          m.n_r_t = JUSTFNAME(DBF(ctabla_var))
          m.n_r_t = SUBSTR(m.n_r_t, 1, AT(".", m.n_r_t)-1)
          a_userdsc = IIF(TYPE("A_userdsc")="C", a_userdsc, "")
          cstring_cambios = "Empresa : "+a_cemp+" "+a_empresa+CHR(13)+cdtos1+a_usuario+" "+ALLTRIM(a_userdsc)+CHR(13)+"Fecha : "+DTOC(DATE())+CHR(13)+"Hora  : "+TIME()+CHR(13)+"Tabla : "+ctabla_var+"  "+"("+m.n_r_t+")"+CHR(13)+cdtos2+CHR(13)+"-------------------------------------------------------------------------------"+CHR(13)+cstring_cambios
          m.obs = cstring_cambios
          m.pc = SYS(0)
          m.tipo = m.tipo
          INSERT INTO ad___audi FROM MEMVAR
          USE IN ad___audi
       ENDIF
    ENDIF
 ENDIF
 IF  .NOT. EMPTY(cerror)
    ON ERROR &cerror
 ELSE
    ON ERROR
 ENDIF
 IF  .NOT. vopen_ok
    WAIT WINDOW NOWAIT "se detecto inconsistenciass ..."
 ENDIF
 RELEASE vtantos_campos, vtodos_campos, ctabla_var
 RETURN
ENDPROC
**
*** 
*** ReFox - todo no se pierde 
***
