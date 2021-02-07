SET SYSMENU TO DEFA
	IF INLIST(SYS(5),'F','E','C')
		CD SYS(5)+'\aplvfp\bsinfo\proys\'
		SET DEFA TO \AplVfp\bsinfo
*!*			CD SYS(5)+'\dev\aplvfp\bsinfo\proys\'
*!*			SET DEFA TO \dev\AplVfp\bsinfo
*!*			DEFINE WINDOW desktop2 FROM 1,20 TO 40,77  TITLE 'Las Bebitas' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE(SYS(5)+'\APLVFP\grafgen\jpeg\Jane\jane_joan_3.JPG')
*!*			ACTIVATE WINDOW desktop2

	ELSE
		CD SYS(5)+'\aplvfp\bsinfo\proys\'
		SET DEFA TO \AplVfp\bsinfo
*!*			DEFINE WINDOW desktop2 FROM 1,20 TO 40,77  TITLE 'Las Bebitas' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE(SYS(5)+'\aplvfp\grafgen\jpeg\Jane\jane_joan_3.JPG')
*!*			ACTIVATE WINDOW desktop2

	ENDIF


SET PATH TO .\Forms , ; 
            .\Progs , ;
            .\Reports , ;
            .\Menus , ;
            .\vcxs , ;
           D:\o-negocios\AROMas , ;
            D:\o-negocios\AROMas\Data , ;
			..\classgen\vcxs , ;
			..\classgen\Forms ,;
			..\classgen\Reports ,;
			..\Classgen\wwSoap,;
			..\Classgen\wwSoap\Classes,;
			..\classgen\PROGS ,;
			..\DLLS

			
SET STEP ON 
DO WWSOAP
lcWSDL = "http://www.foxcentral.net/foxcentral.wsdl"

loSOAP = CREATEOBJECT("wwSOAP")

loSOAP.ParseServiceWSDL(lcWSDL)
loSOAP.AddParameter("lnDays",60)
loSOAP.AddParameter("lnProvider",0)
loSOAP.AddParameter("lcType","All")

lcXML=loSOAP.CallWSDLMethod("GetNewsItems")

IF loSOAP.lError
   ? loSoap.cErrorMsg
   RETURN
ENDIF

XMLTOCURSOR(lcXML,"TNewsItems")

BROWSE