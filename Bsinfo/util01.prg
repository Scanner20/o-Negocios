CLOSE ALL
SELECT 0
USE H:\tpower\DATA\cia001\cctclien ORDER clien01 ALIAS clie
SELECT 0
USE h:\tpower\data\cia001\cctcdire ORDER dire01 ALIAS dire
SELECT 0
USE H:\tpower\DATA\cia001\cbdmauxi ORDER auxi01 ALIAS auxi
SET FILTER TO clfaux = "CLI"
n = 1
l = 1
SCAN WHILE !EOF()
	SELECT clie
	APPEND BLANK
	replace clfaux WITH auxi.clfaux
	replace codaux WITH auxi.codaux
	replace codcli WITH TRANSFORM(n,"@l ####")
	replace nroruc WITH auxi.rucaux
	replace RazSoc WITH auxi.nomaux
	SELECT dire
	APPEND BLANK
	replace clfaux WITH auxi.clfaux
	replace codaux WITH auxi.codaux
	replace codcli WITH TRANSFORM(n,"@l ####")
	replace coddire WITH TRANSFORM(l,"@l ###")
	replace desdire WITH auxi.diraux
	UNLOCK ALL
	n = n + 1
	SELECT auxi
ENDSCAN