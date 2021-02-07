FUNCTION NCred_Cargo
TEXT TO LsQryCARGO  TEXTMERGE NOSHOW  PRETEXT 15
SELECT 
        case co_tipodocumento when '01' then 'F' when '03' then 'B' end ||
        lpad(trim(Nc.nu_serie),3,'0')|| '-' ||lpad(rtrim(Nc.nu_notacredito),8,'0') as documento,
        Nc.fe_notacredito fe_emision,
        ' ' as fe_vencimiento,
        '07' co_tipodoc,
        case co_tipodocumento when '01' then 'F' when '03' then 'B' end ||
        lpad(trim(Nc.nu_serie),3,'0') as nu_serie,
        lpad(rtrim(Nc.nu_notacredito),8,'0') as documento,        
        fu_buscaorigen_id( nc.co_tipodocumento ,  nu_seriedocumento, LPAD(to_char(nc.nu_documento),7,'0'),
                                                    to_char(nc.fe_documento,'YYYY-MM-DD') ) co_tipo_identidad ,
        fu_buscaorigen_idnum( nc.co_tipodocumento ,  nu_seriedocumento, LPAD(to_char(nc.nu_documento),7,'0'),
                                                    to_char(nc.fe_documento,'YYYY-MM-DD') ) nu_documento_cliente,
        case Nc.st_notacredito when '03' then 'A N U L A D O' else Nc.de_nombrecliente end as de_cliente,
         0 as Pasajes,
        /*  Excesos */
        Case fu_buscaorigen_venta( nc.co_tipodocumento , nc.nu_seriedocumento, LPAD(to_char(nc.nu_documento),7,'0'), to_char(nc.fe_documento,'YYYY-MM-DD') )
             when 'E' then im_neto*-1  else 0.00 end AS Excesos,       
        /* Gastos */
        Case fu_buscaorigen_venta( nc.co_tipodocumento , nc.nu_seriedocumento,LPAD(to_char(nc.nu_documento),7,'0'), to_char(nc.fe_documento,'YYYY-MM-DD') )
             when 'G' then im_neto*-1  else 0.00 end AS Gadm ,
        /* Cargo */
           Case fu_buscaorigen_venta( nc.co_tipodocumento ,
           case substring(nu_seriedocumento,1,1)
                when 'F' then substring(trim(nc.nu_seriedocumento),2,3)
                else TRIM(nc.nu_seriedocumento)
                end ,
            LPAD(to_char(nc.nu_documento),7,'0'),
            to_char(nc.fe_documento,'YYYY-MM-DD') )
            when 'C' then im_neto*-1  else 0.00 end AS im_tot_neto ,
        	im_igv*-1   AS im_tot_igv ,
        	im_total*-1 AS im_tot_flete ,
 	        Nc.st_notacredito,
 	        Ofi.de_abreviatura as localidadterminal,
        	'' AS numerodocumentoimpresion,
       
	        case substring(nu_seriedocumento,1,1)
	             when 'F' then ''
	             else
	                case NC.co_tipodocumento
	                     when '01' then 'F'
	                     when '03' then 'B'
	                     else ''
	                end
	        end ||TRIM(nc.nu_seriedocumento)  as SERIEF,
         lpad(nc.nu_documento,7,'0') NUMF,
         to_char(fe_documento,'DD/MM/YYYY') FECHF 
        , co_tipodocumento Tref
  FROM  "CAR_NOTACREDITO_MA" Nc,
        "GEN_TERMINALES_MA" Ofi
      , "GEN_PREFIJO_MA" Serie
where  to_char(fe_notacredito,'YYYYMM')= <<[']+lperiod+[']>> 
and     NC.co_oficina = Ofi.co_terminal
and    ( NC.co_OFICINA   = Serie.co_terminal
and      NC.co_estacion  = Serie.co_estacion
and      '07'            = Serie.co_tipodoc
and      NC.nu_serie     = Serie.co_prefijo )

ENDTEXT
RETURN LsQryCARGO


SELECT 
        case co_tipodocumento when '01' then 'F' when '03' then 'B' end ||
        lpad(trim(Nc.nu_serie),3,'0')|| '-' ||lpad(rtrim(Nc.nu_notacredito),8,'0') as documento,
        Nc.fe_notacredito fe_emision,
        ' ' as fe_vencimiento,
        '07' co_tipodoc,
        case co_tipodocumento when '01' then 'F' when '03' then 'B' end ||
        lpad(trim(Nc.nu_serie),3,'0') as nu_serie,
        lpad(rtrim(Nc.nu_notacredito),8,'0') as documento,        
        fu_buscaorigen_id( nc.co_tipodocumento ,  nu_seriedocumento, LPAD(to_char(nc.nu_documento),7,'0'),
                                                    to_char(nc.fe_documento,'YYYY-MM-DD') ) co_tipo_identidad ,
        fu_buscaorigen_idnum( nc.co_tipodocumento ,  nu_seriedocumento, LPAD(to_char(nc.nu_documento),7,'0'),
                                                    to_char(nc.fe_documento,'YYYY-MM-DD') ) nu_documento_cliente,
        case Nc.st_notacredito when '03' then 'A N U L A D O' else Nc.de_nombrecliente end as de_cliente,
         0 as Pasajes,
        /*  Excesos */
        Case fu_buscaorigen_venta( nc.co_tipodocumento , nc.nu_seriedocumento, LPAD(to_char(nc.nu_documento),7,'0'), to_char(nc.fe_documento,'YYYY-MM-DD') )
             when 'E' then im_neto*-1  else 0.00 end AS Excesos,       
        /* Gastos */
        Case fu_buscaorigen_venta( nc.co_tipodocumento , nc.nu_seriedocumento,LPAD(to_char(nc.nu_documento),7,'0'), to_char(nc.fe_documento,'YYYY-MM-DD') )
             when 'G' then im_neto*-1  else 0.00 end AS Gadm ,
        /* Cargo */
           Case fu_buscaorigen_venta( nc.co_tipodocumento ,
           case substring(nu_seriedocumento,1,1)
                when 'F' then substring(trim(nc.nu_seriedocumento),2,3)
                else TRIM(nc.nu_seriedocumento)
                end ,
            LPAD(to_char(nc.nu_documento),7,'0'),
            to_char(nc.fe_documento,'YYYY-MM-DD') )
            when 'C' then im_neto*-1  else 0.00 end AS im_tot_neto ,
        	im_igv*-1   AS im_tot_igv ,
        	im_total*-1 AS im_tot_flete ,
 	        Nc.st_notacredito,
 	        Ofi.de_abreviatura as localidadterminal,
        	'' AS numerodocumentoimpresion,
       
	        case substring(nu_seriedocumento,1,1)
	             when 'F' then ''
	             else
	                case NC.co_tipodocumento
	                     when '01' then 'F'
	                     when '03' then 'B'
	                     else ''
	                end
	        end ||TRIM(nc.nu_seriedocumento)  as SERIEF,
         lpad(nc.nu_documento,7,'0') NUMF,
         to_char(fe_documento,'DD/MM/YYYY') FECHF 
        , co_tipodocumento Tref
  FROM  "CAR_NOTACREDITO_MA" Nc,
        "GEN_TERMINALES_MA" Ofi
      , "GEN_PREFIJO_MA" Serie
where  to_char(fe_notacredito,'YYYYMM')=  '201608' 
and     NC.co_oficina = Ofi.co_terminal
and    ( NC.co_OFICINA   = Serie.co_terminal
and      NC.co_estacion  = Serie.co_estacion
and      '07'            = Serie.co_tipodoc
and      NC.nu_serie     = Serie.co_prefijo )

IF .F.

	LnControlCargo  = SQLEXEC(CnCARGO,[Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento,]  +; 
                [ NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito  ] +;
  [FROM  "CAR_NOTACREDITO_MA" Nc, ] + ;
       [ "GEN_TERMINALES_MA" Ofi ] + ;
     [ , "GEN_PREFIJO_MA" Serie ] + ;
     [where to_char(fe_notacredito,'YYYYMM')='] +lperiod+['] + ;
     [ and     NC.co_oficina = Ofi.co_terminal ] + ;
     [ and    ( NC.co_OFICINA   = Serie.co_terminal ] + ;
   [ and      NC.co_estacion  = Serie.co_estacion ] + ;
   [ and      '07'            = Serie.co_tipodoc ] + ;
   [ and      NC.nu_serie     = Serie.co_prefijo ) ]  ,'NCredito2')
   
ENDIF   