IF !open_file()
	=MESSAGEBOX('Error en apertura de archivos',0,'Atención')
ENDIF
XsNroMes=TRANSFORM(_Mes,'@L 99')
XsCodOpe=SPACE(LEN(RMOV.CodOpe))
XsNroAst=SPACE(LEN(RMOV.NroAst))

DO FORM Cbd_Reclasifica_datos NAME WinDataAst 
RETURN 

FUNCTION open_File

goentorno.open_dbf1('ABRIR','cbdrmovm','rmov','rmov01','') 
goentorno.open_dbf1('ABRIR','cbdmctas','ctas','ctas01','') 
goentorno.open_dbf1('ABRIR','cbdmAUXI','auxi','auxi01','') 
goentorno.open_dbf1('ABRIR','cbdmtabl','tabl','tabl01','') 

FUNCTION Ver_datos
PARAMETERS Ps_Clave
IF !VARTYPE(Ps_Clave)='C'
	Ps_Clave = TRANSFORM(_MEs,'@L 99')
ENDIF
Ps_Clave1 = Ps_Clave
IF WEXIST('VentanaDatos')
	RELEASE WINDOWS VentanaDatos
ENDIF
*DEFINE WINDOW VentanaDatos FROM  
SELECT rmov
BROWSE KEY Ps_Clave, Ps_Clave1 FIELDS NroMes:H='Mes':R,;
			 CodoPe:H='Operacion':R,;
			 NroAst:H='Nro.Ast.':R,;
			 FchAst:H='Fch.Ast.':R,;
			 CodCta:H='Cuenta',;
			 CodAux:H='Auxiliar',;
			 ClfAux:H='Clasif.',;
			 CodRef:H='Mayorizado',;
			 CodDoc:H='T.Doc',;
			 TipDoc:H='T.Doc SN',;
			 NroDoc:H='Documento',;
			 FchDoc:H='Fch.Doc.',;
			 TipRef:H='T.Ref',;
			 NroRef:H='Referencia',;
			 FchRef:H='Fch.Refer.',;
			 Nrodtr:H='Nro. Detracc.',;
			 Fchdtr:H='Fch. Detracc.',;
			 GloDoc:H='Glosa',;
			 TpoMOv:H='T',;
			 Import:H='Imp S/.':P='999,999,999.99',;
			 TpoCmb:H='T.Cmb.':P='9.9999',;
 			 Codmon:H='Mon.':P='9',V=INLIST(Codmon,1,2,0),;
			 ImpUsa:H='Imp US$':P='999,999,999.99',;
 			 Afecto,V=INLIST(AFECTO,'A','N','I','G','X',' '),;
			 CodDiv:H='División',;
			 Ctapre:H='Cta.Presup.',; 
			 CodCco:H='C.Costo',;
			 TpoGto:H='T. Gasto',;
			 NumOri:H='User1':R,;
			 FchDig:H='Fec.Dig.':R,;
 			 HorDig:H='Hor.Dig.:R'
			 
			 