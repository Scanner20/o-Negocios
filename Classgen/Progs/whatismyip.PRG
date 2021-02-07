declare Sleep in win32api integer
loIE    = Createobject('InternetExplorer.Application')
loIE.Navigate2('http://whatismyip.org')
lnStart = Seconds()
do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
    Sleep(100)
enddo
if loIE.Busy
    ? 'Timeout'
else
    ? loIE.Document.Body.InnerText
    RETURN loIE.Document.Body.InnerText
ENDIF
