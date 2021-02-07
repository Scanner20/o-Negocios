CLOSE TABLES all
m.FileReso = SYS(2005)

SET RESOURCE TO c:\temp\foxuser2.dbf

*** Abrimos tablas
SELECT 0
USE ccbrgdoc order gdoc01 ALIAS GDOC
SELECT 0
USE almdtran ORDER dtra04 ALIAS DTRA
SELECT 0
USE vtavguia ORDER VGUI01 ALIAS GUIA
SELECT 0
USE almdtran ORDER dtra04 ALIAS GDET AGAIN 
SELECT 0
USE almCtran ORDER ctra01 ALIAS CTRA 

SELECT GDOC
SET RELATION TO coddoc+SUBSTR(CodDoc,1,1)+SUBSTR(nrodoc,2) INTO dtra ADDITIVE
SET RELATION TO CODREF+NroRef INTO GUIA additive
SELECT GUIA
SET RELATION TO coddoc+nrodoc INTO gdet
SELECT DTRA
SET RELATION TO Dtra.subalm+ Dtra.tipmov+ Dtra.codmov+ Dtra.nrodoc INTO Ctra ADDITIVE


SELECT GDET
*BROWSE  FIELDS tporef,nroref,nrorfb,codsed,subalm,tipmov,codmov,nrodoc,fchdoc,codcli,codmat,desmat,candes,factor,Cnt=ROUND(Candes*Factor,2),preuni nowait FONT 'Arial',8
BROWSE LAST NOWAIT
SELECT DTRA
*BROWSE FIELDS tporef,nroref,nrorfb,codsed,subalm,tipmov,codmov,nrodoc,fchdoc,codcli,codmat,desmat nowait FONT 'Arial',8
BROWSE LAST NOWAIT 
SELECT CTRA
*BROWSE FIELDS tporf1,nrorf1,codsed,subalm,tipmov,codmov,nrodoc,fchdoc,flgest,codcli nowait FONT 'Arial',8
BROWSE LAST NOWAIT 
SELECT GDOC
*BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,flgest,tporef,codref,nroref,glosa2:40 nowait FONT 'Arial',8
BROWSE LAST NOWAIT 
SELECT GUIA
*BROWSE FIELDS coddoc,nrodoc,codcli,nomcli:25,fchdoc,flgest,codfac,nrofac nowait FONT 'Arial',8
BROWSE LAST NOWAIT 

SELECT GUIA

SET RESOURCE TO (m.FileReso)
return
SELECT 0
USE factguiaen ALIAS FaGu

SCAN FOR EMPTY(Estado)
	IF estant='XX'
		SET STEP ON 
	ENDIF
	SELECT GDOC
	SEEK 'CARGOFACT'+Fagu.Factura
	IF FOUND()
		SELECT FAGU
		LlTieneGuia=.F.
		FOR k= 1 TO 10
			LsCmpGuia='GUIA'+TRANSFORM(K,"@L 99")
			IF !EMPTY(EVALUATE(LsCmpGuia))
				LsNroGui=EVALUATE(LsCmpGuia)
				LlTieneGuia=.T.
				SELECT DTRA
				SEEK 'FACT'+'F'+SUBSTR(Fagu.Factura,2)
				IF FOUND()
					=ActEstado('A1') && Encontro la factura en almacen
					** Borramos la salida de la factura en el almacen
					SCATTER MEMVAR 
					DELETE WHILE TpoRef+NroRef == 'FACT'+'F'+SUBSTR(Fagu.Factura,2)
					SELECT CTRA
					SEEK m.SubAlm+m.TipMov+m.CodMov+m.NroDoc
					DELETE WHILE SubAlm+TipMov+CodMov+NroDoc == m.SubAlm+m.TipMov+m.CodMov+m.NroDoc
					SELECT DTRA
					SEEK 'FACT'+'F'+SUBSTR(Fagu.Factura,2)
					IF !FOUND()
						=ActEstado('A2') && Borro la salida de la factura en almacen
					ENDIF
					DO ActFactGuia			
				ELSE
					IF FAGU.Estado = 'A3' && La factura fue borrada en almacen pero hay mas guias que revisar
						DO ActFactGuia			
					ELSE
						SELECT GDOC
						SEEK 'CARGOFACT'+Fagu.Factura
						IF FOUND() AND LsNroGui$GDOC.Glosa2
							=ActEstado('A4') && && Guia ya se enlazo previamente a la factura
						ELSE
							=ActEstado('X1') && No Encontro la factura en almacen	 
						ENDIF
						
					ENDIF	
				ENDIF
				
			ENDIF
			SELECT FAGU
		ENDFOR
		IF !LlTieneGuia
			=ActEstado('A5') && Factura libre no tiene guias
		ENDIF
	ELSE
		SELECT FAGU
		=ActEstado('X5') && No existe la Factura ?????
	ENDIF	
ENDSCAN

*********************
PROCEDURE ActFactGuia
*********************
*** Actualizamos la factura y la GUIA
SELECT GDOC
SEEK 'CARGOFACT'+FAGU.Factura
IF FOUND()
	replace CodRef WITH 'G/R'
	IF EMPTY(NroRef)
		Replace NroRef WITH LsNroGui
		replace Glosa2 WITH LsNroGui
	ELSE
		Replace NroRef WITH ''
		replace Glosa2 WITH RTRIM(Glosa2)+','+LsNroGui
	ENDIF 					
	SELECT GUIA
	SEEK 'G/R '+LsNroGui
	IF FOUND() AND FlgEst <> 'A'
		replace CodFac WITH 'FACT'
		replace NroFac WITH Fagu.Factura
		replace FlgEst WITH 'F'
		=ActEstado('A3')	&& Guia se enlazo con Factura
	ELSE
		IF FlgEst = 'A'
			=ActEstado('X3') && No existe la guia
		ELSE
			=ActEstado('X4')  && La guia esta anulada
		ENDIF	
	ENDIF
ELSE
	=ActEstado('X5') && No existe la Factura ?????
ENDIF				

FUNCTION  ActEstado
PARAMETERS PsEstado
replace EstAnt WITH Estado	 IN Fagu 
replace Estado WITH PsEstado IN Fagu 
