PARAMETERS PcSuc,PsSubAlm
CLOSE TABLES ALL 

PcSuc = TRIM(PcSuc)
PsSubAlm = TRIM(PsSubAlm)
LsPathArti1 = ADDBS('D:\SERVIDOR\BACKUP\SUC_'+PcSuc)
LsPathArti2 = ADDBS('D:\SERVIDOR\KPLUS_G\SUC_'+PcSuc)
LsPathArti3 = ADDBS('D:\SERVIDOR\BACKUP\SUC_'+'0000')

SELECT 0
USE LsPathArti1 +'articulo.dbf' exclu ALIAS arti
INDEX on articulo tag articulo
SELECT 0
USE LsPathArti1+'art_anex' exclu ALIAS ARTA
INDEX on articulo TAG articulo
SELECT 0
USE LsPathArti3+'UNIDADES' exclu ALIAS UNID
INDEX on articulo+ounidad TAG articulo
SELECT 0
USE LsPathArti1+'UNID_MAR' exclu ALIAS UMAR
INDEX on articulo+ounidad TAG articulo
SELECT 0
USE LsPathArti1+'KARD_ART' exclu ALIAS KARD 
INDEX on articulo+DTOS(fecha) TAG articulo
SET ORDER TO ARTICULO  DESCENDING

DO CASE
	CASE PcSuc ='0000'
			LsSubAlm = ''
	OTHERWISE 
			LsSubAlm = RIGHT(PcSuc,3)
ENDCASE

SELECT 0
USE ADMIN!ADMMTCMB ORDER TCMB01 ALIAS TCMB
SEEK DTOS(DATE())
IF FOUND() AND  TCMB.OfiVta>0  AND TCMB.OfiCmp>0
	XfOfiVta    = TCMB.OfiVta
	XfOfiCmp =  TCMB.OfiCmp

ELSE
	=MESSAGEBOX('No existe tipo de cambio del dia: '+DTOC(DATE()),0,'ATENCION!') )
	XfOfiVta = VAL(INPUTBOX("T/C Venta:", "Ingresar Tipo de Cambio", "1",0 ,'1' , '1'))
      XfOfiCmp = VAL(INPUTBOX("T/C Compra:", "Ingresar Tipo de Cambio",  "1",0 ,'1' , '1'))
      =RLOCK()
      replace OfiVta WITH XfOFiVta , OfiCmp WITH XfOfiCmp, BCOVta WITH XfOFiVta , BCOCmp WITH XfOfiCmp
      
ENDIF

** TABLA DE UNIDADES EQUIVALENTE POR ARTICULO 
SELECT 0
USE CIA001!ALMEQUNI ALIAS EQUN 
SET ORDER TO EQUN02   && CODMAT+UNDVTA+UNDSTK 
** VETT  04/03/2011 01:52 PM : Para DCASA le agregaremos los precios por articulo y unidad equivalente
SET STEP ON 
IF PcSuc = '0000'
	SELECT 0
	USE p0012011!almcatge ALIAS catg
	SET ORDER TO catg01
	SELECT ARTI
	SCAN
		m.CodMat = PADR(Articulo,LEN(CATG.CodMat))
		m.Articulo = Articulo
		m.DesMat = Des_Articu
		m.oUnidad = OUnidad
		m.UndStk = IIF(SEEK(m.Articulo+m.OUnidad,'UNID'),UNID.Unidad_Ven,'')
		m.UndCmp = m.UndStk
		m.FacEqu  =  1
		m.TipMat    = '50'
		m.CodUser = ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1))
		m.FchHora = DATETIME()
		** el ultimo precio de venta del kardex : Kard_Art
		m.PrecioD = IIF(SEEK(m.Articulo,'KARD'),KARD.PrecioD,0)
		** Precios por articulo  - con la UNidad de Stock
		m.OUnidad = OUnidad
		m.Prevn1 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),UMAR.MUContado,0)   && Se guarda en soles
		m.Prevn2 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),UMAR.MU7dias,0)
		m.Prevn3 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),UMAR.MU15dias,0)
		m.Prevn4 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),UMAR.MU30dias,0)
		m.Prevn5 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),UMAR.MU45dias,0)
		m.Prevn6 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),UMAR.MU60dias,0)
		** En Moneda extranjera , aplicamos tipo de cambio del momento,
		m.Preve1 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),ROUND(UMAR.MUContado/XfOfiVta,2),		0)
		m.Preve2 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),ROUND(UMAR.MU7dias/XfOfiVta,      2), 		0)
		m.Preve3 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),ROUND(UMAR.MU15dias/XfOfiVta,    2),		0)
		m.Preve4 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),ROUND(UMAR.MU30dias/XfOfiVta,    2),		0)
		m.Preve5 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),ROUND(UMAR.MU45dias/XfOfiVta,    2),		0)
		m.Preve6 = IIF(SEEK(m.Articulo+m.OUnidad,'UMAR'),ROUND(UMAR.MU60dias/XfOfiVta,    2),		0)
		* *  Guardamos las unidades adicionales y los precios por unidades de medida adicional por producto
		**   EN EL ALMEQUNI	** 
		
		
		**
		SELECT CATG
		SEEK m.CodMat
		IF !FOUND()
			APPEND BLANK 
		ELSE
			=RLOCK()	 
		ENDIF
		GATHER memvar
		
		LlPrimera = .T.
		SELECT UNID
		SEEK m.Articulo
		SCAN WHILE Articulo = m.Articulo && PADR(m.CodMat,LEN(Articulo))
			m.UndVta =   PADR(Unidad_ven,LEN(TABL.CodIgo))
			m.FacEqu = Equivale
			m.UndStk = IIF(Equivale=1,Unidad_Ven,m.UndStk)
			=SEEK(TRIM(m.UndVta),'TABL')
			m.DesVta = TABL.NomBre
			SELECT EQUN
			SEEK m.CodMat+PADR(m.UndVta,LEN(EQUN.UndVta))+PADR(m.UndStk,LEN(EQUN.UndStk))
			IF !FOUND()
				APPEND BLANK 
			ENDIF
			GATHER memvar
			SELECT UNID		
		ENDSCAN	
		
		SELECT ARTI
	ENDSCAN 
ELSE
	SELECT 0
	USE p0012011!almtalma ALIAS ALMA
	SET ORDER TO ALMA01  && SUBALM
	SELECT 0
	USE p0012011!almcatal ALIAS calm
	SET ORDER TO CATA01   && SUBALM+CODMAT 
	SELECT ARTA
	SCAN
		m.CodMat = PADR(Articulo,LEN(CATG.CodMat))
		m.SubAlm =  RIGHT(PcSuc,3)
		=SEEK(m.SubAlm,'ALMA')
		m.CodSed = ALMA.CodSed 
		m.UndVta = IIF(SEEK(m.CodMat,'CATG'),CATG.UndStk,'')
		m.StkIni    = STOCK
		m.ViniMn = ROUND(Costo_Prom  * STOCK,4)
		m.ViniUS  = ROUND(Costo_PRD   * STOCK ,4)
		SELECT CALM
		SEEK m.SubAlm+m.CodMat
		IF !FOUND()
			APPEND BLANK 
		ELSE
			=RLOCK()	 
		ENDIF
		GATHER memvar
		SELECT ARTA
	ENDSCAN
	
	
ENDIF

****************************************************************
PROCEDURE Cargar_Precios_Sucursal_Und_Venta
****************************************************************


