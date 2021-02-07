*** wwSOAP Proxy Header - DO NOT REMOVE THIS LINE

* *** Load Class Libraries
DO wwSoap 
SET PROCEDURE TO foxcentralProxy ADDITIVE
RETURN

*!*   LOCAL oProxy as foxcentralProxy
*!*   oProxy = CREATEOBJECT("foxcentralProxy",0,.T.)
*!*   oProxy.nTimeout = 5
*!*   oProxy.LoadWSDL()

*!*   ? oProxy.HelloWorld("Test")

*!*   ? oProxy.cErrorMsg

*** End wwSOAP Proxy Header - DO NOT REMOVE THIS LINE


*** wwSOAP Proxy Class for foxcentral - generated 10/29/2004 02:46:32 AM
DEFINE CLASS foxcentralProxy as wwSOAPProxy

cWSDLUrl = "http://www.foxcentral.net/foxcentral.wsdl"

*** If you override any methods and want to preserve the override 
*** between generations use the section below - you still have 
*** to remove the method from the generated class code below

*** wwSOAP Overridden Method Code - DO NOT REMOVE THIS LINE

*** End wwSOAP Overridden Method Code - DO NOT REMOVE THIS LINE

FUNCTION GetNewsItems(lnDays as integer,lnProvider as integer,lcType as string) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lnDays",lnDays)
   THIS.oSOAP.AddParameter("lnProvider",lnProvider)
   THIS.oSOAP.AddParameter("lcType",lcType)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetNewsItems",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetNewsItems(lnDays,lnProvider,lcType)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetItems(ldLastOn as datetime,ldTimeZone as integer,lnProvider as integer,lcType as string) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("ldLastOn",ldLastOn)
   THIS.oSOAP.AddParameter("ldTimeZone",ldTimeZone)
   THIS.oSOAP.AddParameter("lnProvider",lnProvider)
   THIS.oSOAP.AddParameter("lcType",lcType)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetItems",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetItems(ldLastOn,ldTimeZone,lnProvider,lcType)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION AddItem(lcSubject as string,lcContent as string,lcLink as string,ldDate as datetime,lnProviderPk as integer,lcPassword as string) AS integer
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcSubject",lcSubject)
   THIS.oSOAP.AddParameter("lcContent",lcContent)
   THIS.oSOAP.AddParameter("lcLink",lcLink)
   THIS.oSOAP.AddParameter("ldDate",ldDate)
   THIS.oSOAP.AddParameter("lnProviderPk",lnProviderPk)
   THIS.oSOAP.AddParameter("lcPassword",lcPassword)

   lvResult=THIS.oSOAP.CallWSDLMethod("AddItem",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.AddItem(lcSubject,lcContent,lcLink,ldDate,lnProviderPk,lcPassword)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION SaveItemEx(lcXMLNewsItem as string) AS integer
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcXMLNewsItem",lcXMLNewsItem)

   lvResult=THIS.oSOAP.CallWSDLMethod("SaveItemEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.SaveItemEx(lcXMLNewsItem)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetItemEx(lnPK as integer) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lnPK",lnPK)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetItemEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetItemEx(lnPK)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION DeleteItem(lnPK as integer,lcPassword as string) AS boolean
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lnPK",lnPK)
   THIS.oSOAP.AddParameter("lcPassword",lcPassword)

   lvResult=THIS.oSOAP.CallWSDLMethod("DeleteItem",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.DeleteItem(lnPK,lcPassword)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetProviders() AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")


   lvResult=THIS.oSOAP.CallWSDLMethod("GetProviders",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetProviders()
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetProviderEx(lnProviderPk as integer,lcPassword as string) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lnProviderPk",lnProviderPk)
   THIS.oSOAP.AddParameter("lcPassword",lcPassword)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetProviderEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetProviderEx(lnProviderPk,lcPassword)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION SaveProviderEx(lcXML as string) AS boolean
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcXML",lcXML)

   lvResult=THIS.oSOAP.CallWSDLMethod("SaveProviderEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.SaveProviderEx(lcXML)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetTypes() AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")


   lvResult=THIS.oSOAP.CallWSDLMethod("GetTypes",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetTypes()
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetResources(lcType as string,lnProvider as integer) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcType",lcType)
   THIS.oSOAP.AddParameter("lnProvider",lnProvider)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetResources",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetResources(lcType,lnProvider)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetResourcesWithFilter(lcType as string,lnProvider as integer,ldFromDate as datetime,ldToDate as datetime,lcKeywords as string) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcType",lcType)
   THIS.oSOAP.AddParameter("lnProvider",lnProvider)
   THIS.oSOAP.AddParameter("ldFromDate",ldFromDate)
   THIS.oSOAP.AddParameter("ldToDate",ldToDate)
   THIS.oSOAP.AddParameter("lcKeywords",lcKeywords)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetResourcesWithFilter",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetResourcesWithFilter(lcType,lnProvider,ldFromDate,ldToDate,lcKeywords)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION SaveResourceEx(lcXMLResourceItem as string) AS integer
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcXMLResourceItem",lcXMLResourceItem)

   lvResult=THIS.oSOAP.CallWSDLMethod("SaveResourceEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.SaveResourceEx(lcXMLResourceItem)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetArticles() AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")


   lvResult=THIS.oSOAP.CallWSDLMethod("GetArticles",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetArticles()
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetArticlesEx(lnProviderPk as integer,ldDate as datetime,lcKeyWord as string) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lnProviderPk",lnProviderPk)
   THIS.oSOAP.AddParameter("ldDate",ldDate)
   THIS.oSOAP.AddParameter("lcKeyWord",lcKeyWord)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetArticlesEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetArticlesEx(lnProviderPk,ldDate,lcKeyWord)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION GetArticleEx(lnPK as integer) AS string
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lnPK",lnPK)

   lvResult=THIS.oSOAP.CallWSDLMethod("GetArticleEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.GetArticleEx(lnPK)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION AddArticle(lcSubject as string,lcContent as string,lcLink as string,ldDate as datetime,lcAuthor as string,lcKeywords as string,lnProviderPk as integer,lcPassword as string) AS integer
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcSubject",lcSubject)
   THIS.oSOAP.AddParameter("lcContent",lcContent)
   THIS.oSOAP.AddParameter("lcLink",lcLink)
   THIS.oSOAP.AddParameter("ldDate",ldDate)
   THIS.oSOAP.AddParameter("lcAuthor",lcAuthor)
   THIS.oSOAP.AddParameter("lcKeywords",lcKeywords)
   THIS.oSOAP.AddParameter("lnProviderPk",lnProviderPk)
   THIS.oSOAP.AddParameter("lcPassword",lcPassword)

   lvResult=THIS.oSOAP.CallWSDLMethod("AddArticle",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.AddArticle(lcSubject,lcContent,lcLink,ldDate,lcAuthor,lcKeywords,lnProviderPk,lcPassword)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

FUNCTION SaveArticleEx(lcXMLArticle as string) AS integer
LOCAL lvResult

THIS.SetError()

DO CASE
*** wwSOAP Client
CASE THIS.nClientMode = 0  
   THIS.oSOAP.AddParameter("RESET")

   THIS.oSOAP.AddParameter("lcXMLArticle",lcXMLArticle)

   lvResult=THIS.oSOAP.CallWSDLMethod("SaveArticleEx",THIS.oSDL)
   IF THIS.oSOAP.lError
      THIS.SetError(THIS.oSOAP.cErrorMsg)
      RETURN .F.
   ENDIF

   RETURN lvResult

*** MSSOAP Client
CASE THIS.nClientMode = 1  
   LOCAL loException

   TRY
      this.SetMSSOAPConnectionProperties()
      lvResult = THIS.oSOAP.SaveArticleEx(lcXMLArticle)
   CATCH TO loException
      this.lError = .t.
      this.cErrorMsg = this.oSoap.FaultString
      IF EMPTY(this.cErrorMsg)
         this.cErrorMsg = loException.Message
      ENDIF
   ENDTRY

   IF this.lError
      RETURN .F.
   ENDIF

   RETURN lvResult
ENDCASE
ENDFUNC

ENDDEFINE