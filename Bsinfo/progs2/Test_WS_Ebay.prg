LOCAL o as ebaypricewatcher
LOCAL loWS
loWS = NEWOBJECT("Wsclient",Iif(Version(2)=0,"",Home()+"FFC\")+"_webservices.vcx")
loWS.cWSName = "ebaypricewatcher"
o = loWS.SetupClient("http://www.xmethods.net/sd/2001/EBayWatcherService.wsdl", "eBayWatcherService", "eBayWatcherPort")

DO WHILE .T.
	lnKey = INKEY(3)
	IF lnKey = 27
		EXIT
	ENDIF
	* Pass ebay auction number
	?o.getcurrentprice("1296041972")
ENDDO