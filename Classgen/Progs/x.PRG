 LOCAL cmemvar
 =SYS(3054,11,"cmemvar")

LfHoraIni = SECONDS()
SET CLOCK TO 03,02
SELECT 0
SELECT  * FROM  gocfgvta.oentorno.locpath+'Fact_bol' INTO CURSOR FACT READWRITE 

LfHoraFin = SECONDS()
LsHora    = TotHoras(LfHoraIni,LfHoraFin)
WAIT WINDOW LsHora
 LfHoraIni = SECONDS()
_Coddoc = 'FACT'
_NroDoc = '0200004924'
SELECT ccbrgdoc
=SEEK('CARGO'+_Coddoc+_NroDoc,'GDOC','GDOC01')
SCATTER MEMVAR 
=SEEK(GsClfVen+m.CodVen,'AUXI','AUXI01')
m.NomAux = AUXI.NomAux
=SEEK(GsClfCli+m.CodCli+m.CodDire,'DIRE','DIRE02')
m.DesDire = DIRE.DesDire
SELECT ITEM
=SEEK(_Coddoc+_NroDoc,'ITEM','ITEM01')
SCAN WHILE CodDoc+NroDoc= _Coddoc+_NroDoc
	SCATTER MEMVAR
	INSERT INTO FACT FROM MEMVAR
ENDSCAN 
LfHoraFin = SECONDS()
LsHora    = TotHoras(LfHoraIni,LfHoraFin)
WAIT WINDOW LsHora
clear
? cmemvar
******************
PROCEDURE TotHoras
******************
PARAMETER _HoraIni,_HoraFin
DO CASE
   CASE (_HoraFin - _HoraIni)/(60*60)>1
        LfHora    = INT((_HoraFin - _HoraIni)/(60*60))
        LfMinutos = ROUND((_HoraFin - _HoraIni)/(60*60) - INT((_HoraFin - _HoraIni)/(60*60)),0)*60
        _Hora=TRAN(LfHora,'@L ##')+[Hrs ]+TRAN(LfMinutos,'99')+[Min]
        
   CASE (_HoraFin - _HoraIni)/(60*60)<=1
        IF (_HoraFin - _HoraIni)/60>1
           LfMinutos = INT((_HoraFin - _HoraIni)/60)
           LfSegundos= ROUND((_HoraFin - _HoraIni)/60 - INT((_HoraFin - _HoraIni)/60),2)*60
           IF LfSegundos>=60
              LfMinutos = LfMinutos + INT(LfSegundos/60)
              LfSegundos= (LfSegundos - INT(LfSegundos))*60
           ENDIF
           _Hora=TRAN(Lfminutos,'@L ##')+[Min ]+TRAN(Lfsegundos,'99')+[ Seg]
        ELSE
           LfSegundos= ROUND(_HoraFin - _HoraIni,2)
           _Hora=TRAN(Lfsegundos,'99.99')+[ Seg]
        ENDIF
ENDCASE
RETURN _Hora


SELECT ITEMSMiraflores && Codigos que hay que pasar de Miraflores a Chincha extraidos del almcatal subalm='010'
SCAN
SELECT almcatal
SET ORDER TO cata01
SEEK '020'+ITEMSMiraflores.codmat &&buscando si ya existe registro en Chincha
IF !FOUND()
	APPEND BLANK
	replace  codmat WITH ITEMSMiraflores.codmat
	replace  undvta WITH ITEMSMiraflores.undstk
	replace  facequ WITH ITEMSMiraflores.facequ
ENDIF 
ENDSCAN
*********************
FUNCTION RenumNro_Itm
*********************
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\vtarcoti
SET ORDER TO RCOT01   && NRODOC
LOCATE
DO WHILE !EOF()
	LsNroDoc=NroDoc
	NItem = 0
	SCAN WHILE NroDOc=LsNroDoc	
		nItem = nItem + 1
		=RLOCK()
		replace Nro_Itm WITH nItem 
		UNLOCK
	ENDSCAN
ENDDO