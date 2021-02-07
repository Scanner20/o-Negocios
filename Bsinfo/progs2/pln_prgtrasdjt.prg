*** NEW
*!*	XsCodPln = TRIM(GsCodPln)
*!*	XsNroPer = IIF(INLIST(XsCodPln,'1','4'),XsNroMes,XsNroSem)
*!*	SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos Archivos
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln = XsCodPln
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNDJTF1','DJF1','DJF101','EXCL')
ZAP
goentorno.open_dbf1('ABRIR','PLNDJTF2','DJF2','DJF201','EXCL')
ZAP
*!*	Ejecutamos el formulario
DO FORM Pln_FrmTrasDJT
RETURN

*************************
PROCEDURE Genera_DJT_0600
*************************
SELECT PERS
SCAN WHILE !EOF()
	IF VALCAL('@SIT') >= 5
		LOOP
	ENDIF
	XsTpoDoc = TpoDoc
	XsNroDoc = LElect
	XnDiaTra = VALCAL('BA01')
	XnRemIes = 0.00
	IF pers.TpoAfi = '2'
		XnRemPen = VALCAL('RB01')
	ELSE
		XnRemPen = 0.00
	ENDIF
	XnRemSal = VALCAL('RB01')
	XnRemArt = 0.00
	IF VALCAL('RF12')<> 0.00
		XnRemQui = VALCAL('RB01')
		XnTriQui = VALCAL('RF12')
	ELSE
		XnRemQui = 0.00
		XnTriQui = 0.00
	ENDIF
	SELECT DJF1
	APPEND BLANK
	REPLACE TpoDoc_Aseg WITH TRANSFORM(XsTpoDoc,"@Z ##")
	REPLACE NroDoc_Aseg WITH XsNroDoc
	REPLACE Dias_Trab WITH TRANSFORM(XnDiaTra,"@L 99")
	REPLACE Rem_Ies WITH XnRemIes
	REPLACE Rem_Pen WITH XnRemPen
	REPLACE Rem_Sal WITH XnRemSal
	REPLACE Rem_Art WITH XnRemArt
	REPLACE Rem_Qui WITH XnRemQui
	REPLACE Tri_Qui WITH XnTriQui
ENDSCAN
SELECT 0
ArcTmp = GoEntorno.TmpPath + SYS(3)
CREATE TABLE (ArcTmp) FREE (cadena c(254))
USE (ArcTmp) ALIAS temp
WAIT WINDOW [Ok...] NOWAIT
SELECT DJF1
GO TOP
STORE '' TO XsRemIes,XsRemPen,XsRemSal,XsRemArt,XsRemQui,XsTriQui
SCAN WHILE !EOF()
	*!*	Armamos la cadena
	MiCadena = ALLTRIM(TpoDoc_Aseg) + '|'
	MiCadena = MiCadena + TRIM(NroDoc_Aseg) + '|'
	MiCadena = MiCadena + TRIM(Dias_Trab) + '|'
	IF Rem_Ies = 0.00
		XsRemIes = ''
	ELSE
		XsRemIes = ALLTRIM(TRANSFORM(Rem_Ies,'#######.##'))
	ENDIF
	MiCadena = MiCadena + XsRemIes + '|'
	IF Rem_Pen = 0.00
		XsRemPen = ''
	ELSE
		XsRemPen = ALLTRIM(TRANSFORM(Rem_Pen,'#######.##'))
	ENDIF
	MiCadena = MiCadena + XsRemPen + '|'
	IF Rem_Sal = 0.00
		XsRemSal = ''
	ELSE
		XsRemSal = ALLTRIM(TRANSFORM(Rem_Sal,'#######.##'))
	ENDIF
	MiCadena = MiCadena + XsRemSal + '|'
	IF Rem_Art = 0.00
		XsRemArt = ''
	ELSE
		XsRemArt = ALLTRIM(TRANSFORM(Rem_Art,'#######.##'))
	ENDIF
	MiCadena = MiCadena + XsRemArt + '|'
	IF Rem_Qui = 0.00
		XsRemQui = ''
	ELSE
		XsRemQui = ALLTRIM(TRANSFORM(Rem_Qui,'#######.##'))
	ENDIF
	MiCadena = MiCadena + XsRemQui + '|'
	IF Tri_Qui = 0.00
		XsTriQui = ''
	ELSE
		XsTriQui = ALLTRIM(TRANSFORM(Tri_Qui,'#######.##'))
	ENDIF
	MiCadena = MiCadena + XsTriQui + '|'
	SELECT temp
	APPEND BLANK
	REPLACE cadena WITH MiCadena
	MiCadena = ''
ENDSCAN
SELE TEMP
GO TOP
COPY TO (PathUser)+XsArchivo SDF
RETURN

*************************
PROCEDURE Genera_DJT_0610
*************************
SELECT PERS
SCAN WHILE !EOF()
	IF CodSct <> '01'
		LOOP
	ENDIF
	XsTpoDoc = TpoDoc
	XsNroDoc = LElect
	XsRucCen = GsRucCia
	XnTasa = VALCAL('AC02')
	XnRemSct = VALCAL('RB01')
	SELECT DJF2
	APPEND BLANK
	replace TpoDoc_Aseg WITH XsTpoDoc
	replace NroDoc_Aseg WITH XsNroDoc
	replace Ruc_Cent WITH XsRucCen
	replace Corr_Cent WITH '1'
	replace Tasa WITH XnTasa
	replace Rem_Sctr WITH XnRemSct
ENDSCAN
SELECT 0
ArcTmp = GoEntorno.TmpPath + SYS(3)
CREATE TABLE (ArcTmp) FREE (cadena c(254))
USE (ArcTmp) ALIAS TEMP
WAIT WINDOW [Ok...] NOWAIT
SELECT DJF2
GO TOP
STORE '' TO XsRemSct
SCAN WHILE !EOF()
	*!*	Armamos la cadena
	MiCadena = TRIM(TpoDoc_Aseg) + '|'
	MiCadena = MiCadena + TRIM(NroDoc_Aseg) + '|'
	MiCadena = MiCadena + TRIM(Ruc_Cent) + '|'
	MiCadena = MiCadena + ALLTRIM(Corr_Cent) + '|'
	MiCadena = MiCadena + ALLTRIM(TRANSFORM(Tasa,'#.##')) + '|'
	MiCadena = MiCadena + ALLTRIM(TRANSFORM(Rem_Sctr,'######.##')) + '|'
	SELECT TEMP
	APPEND BLANK
	REPLACE cadena WITH MiCadena
	MiCadena = ''
ENDSCAN
SELE TEMP
GO TOP
COPY TO (PathUser)+XsArchivo SDF
RETURN