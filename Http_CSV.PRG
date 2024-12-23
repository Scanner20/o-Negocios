LOCAL lcToken, lcURL, loHTTP, lcRespuesta, lcArchivo, lcBoundary, lcData

lcToken = ALLTRIM(token.respuesta)
lcArchivo = 'c:/sys/envio.csv'
lcURL = "https://qremitexxx.empresa.com.ar/api/v1/qr"
lcBoundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
lcData = '--' + lcBoundary + CHR(13) + CHR(10) + ;
         'Content-Disposition: form-data; name="file"; filename="' + JUSTFNAME(lcArchivo) + '"' + CHR(13) + CHR(10) + ;
         'Content-Type: application/octet-stream' + CHR(13) + CHR(10) + CHR(13) + CHR(10) + ;
         FILETOSTR(lcArchivo) + CHR(13) + CHR(10) + ;
         '--' + lcBoundary + '--'

loHTTP = CREATEOBJECT("Msxml2.ServerXMLHTTP.6.0")
loHttp.setOption(2) = 13056

IF VARTYPE(loHTTP) = "O" THEN
    WITH loHTTP
        .OPEN("POST", lcURL, .F.)
        .setRequestHeader("Authorization", "Bearer " + lcToken)
        .SetRequestHeader("Content-Type", "multipart/form-data; boundary=" + lcBoundary)
        .Send(lcData)
        lcRespuesta = ALLTRIM(.ResponseText)

        IF .Status = 200
            =MESSAGEBOX("Status Ok: " + STR(.Status, 4) + CHR(13) + "Respuesta: " + lcRespuesta)
        ELSE
            =MESSAGEBOX("Status Error: " + STR(.Status, 4) + CHR(13) + "Respuesta: " + lcRespuesta)
        ENDIF
    ENDWITH
ELSE
    =MESSAGEBOX("No se pudo crear el Objeto", 48, "Mensaje del Sistema")
ENDIF

loHTTP = .NULL.
RELEASE loHTTP