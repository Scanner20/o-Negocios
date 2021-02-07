Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento, 
  		NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito 
		FROM  "CAR_NOTACREDITO_MA" Nc, 
		 "GEN_TERMINALES_MA" Ofi 
		 , "GEN_PREFIJO_MA" Serie 
		where to_char(fe_notacredito,'YYYYMM')='] +lperiod+['] 
		and     NC.co_oficina = Ofi.co_terminal ] 
		 and    ( NC.co_OFICINA   = Serie.co_terminal  
		 and      NC.co_estacion  = Serie.co_estacion  
		 and      '07'            = Serie.co_tipodoc  
		 and      NC.nu_serie     = Serie.co_prefijo )   


----
Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento, NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito  FROM  "CAR_NOTACREDITO_MA" Nc,  "GEN_TERMINALES_MA" Ofi  , "GEN_PREFIJO_MA" Serie where to_char(fe_notacredito,'YYYYMM')='201805' and     NC.co_oficina = Ofi.co_terminal  and    ( NC.co_OFICINA   = Serie.co_terminal  and      NC.co_estacion  = Serie.co_estacion  and      '07'            = Serie.co_tipodoc  and      NC.nu_serie     = Serie.co_prefijo ) 


----
Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento, 
  		NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito 
		FROM  "CAR_NOTACREDITO_MA" Nc, 
		 "GEN_TERMINALES_MA" Ofi 
		 , "GEN_PREFIJO_MA" Serie 
		where to_char(fe_notacredito,'YYYYMM')= ?lperiod  
		and     NC.co_oficina = Ofi.co_terminal ] 
		 and    ( NC.co_OFICINA   = Serie.co_terminal  
		 and      NC.co_estacion  = Serie.co_estacion  
		 and      '07'            = Serie.co_tipodoc  
		 and      NC.nu_serie     = Serie.co_prefijo )   
		 
----
Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento, 
  		NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito 
		FROM  "CAR_NOTACREDITO_MA" Nc, 
		 "GEN_TERMINALES_MA" Ofi 
		 , "GEN_PREFIJO_MA" Serie 
		where to_char(fe_notacredito,'YYYYMM')= '201805'  
		and     NC.co_oficina = Ofi.co_terminal ] 
		 and    ( NC.co_OFICINA   = Serie.co_terminal  
		 and      NC.co_estacion  = Serie.co_estacion  
		 and      '07'            = Serie.co_tipodoc  
		 and      NC.nu_serie     = Serie.co_prefijo )   
		 
----
Connectivity error: ERROR: character 0xc291 of encoding "UTF8" has no equivalent in "WIN1252";
Error while executing the query 		 
		 