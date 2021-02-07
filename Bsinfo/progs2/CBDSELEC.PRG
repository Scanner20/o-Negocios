PARAMETERS NomCampo,m.ActGet
PRIVATE m.actget, m.select, m.title, m.for, m.key1, m.key2;
 		m.valget, m.store, m.ancho, m.fields
IF PARAMETERS() = 0
   m.actget = .T.
   NomCampo = UPPER(VARREAD())
ENDIF
IF PARAMETERS() = 1
   m.actget = .F.
ENDIF
IF PARAMETERS() = 2
   m.actget = .T.
ENDIF
m.select = SELECT()
m.title  = ""
m.for    = ".T."
m.key1   = ""
m.key2   = ""
m.store  = ""
IF TYPE("p_area")<>"C"
   p_area = ALIAS()
ENDIF
m.keyF5    = ON("KEY","F5")
m.keyF4    = ON("KEY","F4")
Localizar = .F.
*** preservando la rutina de on key ***
DO CASE
   CASE INLIST(NomCampo,"CTAS2")
      IF ! USED(p_area)
         RETURN
      ENDIF
      SELECT (p_area)
      m.Key1   = xTabla
      m.Key2   = xTabla
      m.for    = [.t.]
      m.order  = ORDER()
      m.fields = [CodCta:H="Codigo",NomCta:H="Nombre"]
      m.title  = "PLAN DE CUENTAS"
      m.ancho  = 50
      m.store  = [KEYBOARD CTAS.CODCTA]
      SET ORDER TO CTAS02
   CASE INLIST(NomCampo,"CTAS","CTACTB","CTAC")
      IF ! USED(p_area)
         RETURN
      ENDIF
      SELECT (p_area)
     *SEEK TRIM(m.ctactb)

      m.Key1   = xTabla
      m.Key2   = xTabla
      xOrder1  = [CTAS01]
      xOrder2  = [CTAS02]
      Init_Codigo = SPACE(LEN(CTAS->CodCta))
      Init_Nombre = SPACE(LEN(CTAS->NomCta))
      xFOR        =  [TRIM(LsNombre)$UPPER(NomCta)]
      xWHILE1     = "CodCta"
      xWHILE2     = "NomCta"
      m.for    = [ AftMOv = 'S']
      m.order  = ORDER()
      m.fields = [CodCta:H="Cta.Ctb.",NomCta:H="Nombre"]
      m.title  = "PLAN DE CUENTAS"
      m.ancho  = 60
      m.store  = [KEYBOARD CTAS.CODCTA]
      ON KEY LABEL F5 DO XCTASF5
      
   CASE NomCampo = "OPER"
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      m.Title  = " CODIGOS OPERATIVOS "
      m.Fields = [codope:H="OPER.",nomope:H="DESCRIPCION"]
      m.KEY1   = xTabla
      m.KEY2   = xTabla
      m.Ancho  = 65
      m.store  = [KEYBOARD codope]
      
   CASE INLIST(NomCampo,"CODAUX","CODPR1","CODPR2","CODCLI","PROV","AUXI")
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      SEEK m.Llave
      m.key1   = xTabla
      m.key2   = xTabla
      m.order  = ORDER()
      m.fields = [CodAux:H="Codigo",NomAux:H="Nombre"]
      DO CASE
         CASE NomCampo="CODAUX"
              m.title  = "CODIGOS AUXILIARES"
         CASE INLIST(NomCampo,"CODPR1","CODPR2","PROV")
              m.title  = "PROVEEDORES"
         CASE NomCampo="CODCLI"
              m.title  = "CLIENTES"
      ENDCASE
      m.ancho  = 50
      m.store  = [KEYBOARD CodAux]
      ON KEY LABEL F5 DO XAUXF5
      ON KEY LABEL F4 DO XF4
     *GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
     *DO LIB_MTEC WITH 99
   CASE NomCampo="DIVF" OR  NomCampo="CODFAM"
      ** Familias **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.Key1   = xTabla
      m.Key2   = xTabla
      m.order  = ORDER()
      m.Title  = " DIVISION - FAMILIAS "
      m.Fields = [CodFam:H="CODIGO",DesFam:H="NOMBRE"]
      m.ancho  = 50
      m.store  = [KEYBOARD CODFAM]
   CASE INLIST(NomCampo ,"CFTR","CODMOV")
      ** Tabla de Movimiento **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      m.KEY1   = xTabla
      m.KEY2   = xTabla
      m.Title  = " MOTIVOS DE "+IIF(xTabla=[I],[INGRESO],IIF(xTabla=[S],[SALIDA],[TRANSACCION]))
      m.Fields = [CodMov:H="COD.",DesMov:H="DESCRIPCION"]
      m.ancho  = 50
      m.store  = [KEYBOARD CODMOV]
   CASE NomCampo = "ALMA" OR NomCampo = "SUBALM"
      ** C¢digos de Sub Almacenes **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      m.Title  = " ALMACENES "
      m.Fields = [SubAlm:H="COD.",DesSub:H="Nombre"]
      m.ancho  = 50
      m.store  = [KEYBOARD SUBALM]
   CASE NomCampo = "CATGF"
      ** MATERIALES GENERALES CLASIFICADOS POR FAMILIAS **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      m.KEY1    = xTabla
      m.KEY2    = xTabla
      xORDER1 = "CATG01"
      xORDER2 = "CATG02"
      Init_Codigo = SPACE(LEN(CATG->CodMat))
      Init_Nombre = SPACE(LEN(CATG->DesMat))
      LsNombre    = SPACE(LEN(CATG->DesMat))
      xFOR        =  [TRIM(LsNombre)$UPPER(DesMat)]
      xWHILE1     = "CodMat"
      xWHILE2     = "DesMat"
      m.Title  = " CATALOGO GENERAL CLASIFICADO POR FAMILIA"
      m.Fields = [CodMat:H="CODIGO",CATG.DESMAT:H="DESCRIPCION":P='@S40',UndStk:H="UND"]
      m.Ancho     = 60
      m.store  = [KEYBOARD CATG.CODMAT]
      ON KEY LABEL F5 DO xCATGF
   CASE NomCampo = "CATG"
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      m.Title   = " CATALOGO GENERAL "
      m.Fields = [CodMat:H="CODIGO",CATG.DESMAT:H="DESCRIPCION":P='@S40',UndStk:H="UND"]
      m.Ancho     = 60
      xORDER1 = "CATG01"
      xORDER2 = "CATG02"
      Init_Codigo = SPACE(LEN(CATG->CodMat))
      Init_Nombre = SPACE(LEN(CATG->DesMat))
      LsNombre    = SPACE(LEN(CATG->DesMat))
      xFOR        =  [TRIM(LsNombre)$DesMat]
      xWHILE1     = "CodMat"
      xWHILE2     = "DesMat"
      m.store  = [KEYBOARD CATG.CODMAT]
      ON KEY LABEL F5 DO XCATGF
   CASE NomCampo = "CALM"
      ** MATERIALES POR ALMACEN **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      SET ORDER TO CATA01
      m.Title  = " MATERIALES POR ALMACEN "
      m.Fields = [CodMat:H="COD.",D=bDesmat():H="DESCRIPCION":40,CATG.UndStk]
      m.KEY1   = xTabla
      m.KEY2   = xTabla
      m.Ancho  = 60
      m.store  = [KEYBOARD CALM.CODMAT]
   CASE NomCampo = "CTRA"
      ** Documentos registrados por almacen **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      m.KEY1 = xTabla
      m.KEY2 = xTabla
      SEEK xTabla
      LeeReg = FOUND()
      m.Title  = "DOCUMENTOS REGISTRADOS"
      m.Fields = [NroDoc:H="No.Doc.",FchDoc:H="Fecha",NroRf1:H="#Refer 1",]
      m.Fields = m.Fields+[NroRf2:H="#Refer 2",NroOdt:H="# O/T"]
      m.Ancho  = 50
   CASE NomCampo = "MDLO"
      ** Asientos tipo **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      m.KEY1 = xTabla
      m.KEY2 = xTabla
      SEEK xTabla
      LeeReg = FOUND()
      m.Title  = "TABLA DE ASIENTOS MODELO"
      m.Fields = [CODMOD:H="Modelo",NotAst:H="Nombre":35]
      m.Ancho  = 45
   CASE NomCampo = "EQUN"
      ** Tabla de Movimiento **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      SET ORDER TO EQUN01
      m.order  = ORDER()
      m.Title  = " UNIDADES ALTERNATIVAS "
      m.Fields = [UndVta:H="COD.",DesVta:H="DESCRIPCION",FacEqu:P="####.###":H="EQUIVALE A",UndStk:H="Und"]
      m.KEY1 = xTabla
      m.KEY2 = xTabla
      m.Ancho = 50
   CASE NomCampo = "DENS"
      ** Tabla de Movimiento **
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      SET ORDER TO EQUN03
      m.order  = ORDER()
      m.Title  = " EQUIVALENCIAS SEGUN DENSIDAD "
      m.Fields = [UndVta:H="COD.",DesVta:H="DESCRIPCION",FacEqu:P="####.###":H="EQUIVALE A",UndStk:H="Und"]
      m.KEY1 = xTabla
      m.KEY2 = xTabla
      m.Ancho = 50
   CASE NomCampo = "TABL"
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      m.order  = ORDER()
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      SEEK "00"+xTabla
      nDigitos = IIF(Digitos>0,Digitos,LEN(Codigo))
      STORE SPACE(nDigitos) TO Desde,Hasta,LsNombre
      m.Key1     = xTabla
      m.Key2     = xTabla
     *LinReg   = "LEFT(Codigo,nDigitos)+' '+LEFT(Nombre,30)"
      m.Fields = [Codigo:H="COD.",Nombre:H="DESCRIPCION"]
      Ancho    = 50
      m.Title  = PADC(TRIM(Nombre),Ancho-2)
      ON KEY LABEL F5 DO XTABL5
      ON KEY LABEL F4  DO XF4
   CASE NomCampo = "NOMB"
      IF ! USED(p_area)
         RETURN .F.
      ENDIF
      SELECT (p_area)
      SET ORDER TO TABL02
      m.order  = ORDER()
      SET ORDER TO TABL01
      SEEK "00"+xTabla
      nDigitos = IIF(Digitos>0,Digitos,LEN(Codigo))
      STORE SPACE(nDigitos) TO Desde,Hasta,LsNombre
      SET ORDER TO (m.Order)
      m.Key1     = xTabla
      m.Key2     = xTabla
     *LinReg   = "LEFT(Codigo,nDigitos)+' '+LEFT(Nombre,30)"
      m.Fields = [C=LEFT(Codigo,nDigitos):H="COD.",Nombre:H="DESCRIPCION"]
      Ancho    = 50
      m.Title  = PADC(TRIM(Nombre),Ancho-2)
      ON KEY LABEL F5 DO XNOMB5
      ON KEY LABEL F4  DO XF4
   OTHER
      ?? CHR(7)
      WAIT "Consulta no disponible" WINDOWS NOWAIT
      RETURN .F.
ENDCASE
m.keyf8    = ON("KEY","F8")
m.key_pgup = ON("KEY","CTRL+PGUP")
m.key_pgdn = ON("KEY","CTRL+PGDN")
m.keyenter = ON("KEY","ENTER")
ON KEY LABEL F8
ON KEY LABEL CTRL+PGUP GOTO TOP
ON KEY LABEL CTRL+PGDN GOTO BOTTOM
ON KEY LABEL ENTER KEYBOARD CHR(23)   && RELEASE WINDOW CONSULTA
** Eliminando Cualquier menu ***
*MENUOLD = SET("SYSMENU")
*SET SYSMENU OFF
DEFINE WINDOWS CONSULTA FROM 08,77-Ancho TO 22,77 ;
       FLOAT GROW ZOOM NOCLOSE SHADOW NONE   COLOR SCHEME 10
DO CASE
   CASE m.key1 == "" AND m.key2 == ""
      BROWSE FIELD &fields KEY m.key1,m.key2 NOMODIFY NODELETE NOAPPEND TITLE m.title;
           WINDOWS CONSULTA  FOR EVALUATE(m.for)
   CASE ! m.key1 == "" AND m.key2 == ""
      BROWSE FIELD &fields KEY m.key1 NOMODIFY NODELETE NOAPPEND TITLE m.title;
           WINDOWS CONSULTA FOR EVALUATE(m.for)
   OTHER
      BROWSE FIELD &fields KEY m.key1,m.key2 NOMODIFY NODELETE NOAPPEND TITLE m.title;
           WINDOWS CONSULTA FOR EVALUATE(m.for)
ENDCASE
SET ORDER TO (m.order)
RELEASE WINDOWS CONSULTA
ON KEY LABEL F8 &KEYF8
ON KEY LABEL CTRL+PGUP &KEY_PGUP
ON KEY LABEL CTRL+PGDN &KEY_PGDN
ON KEY LABEL ENTER  &KEYENTER
ON KEY LABEL F5 &KEYF5
ON KEY LABEL F4 &KEYF4
IF LASTKEY() <> 27 AND ! m.store == "" AND m.actget
   &Store
ENDIF
UltTecla = LASTKEY()
SELECT (m.select)
*SET SYSMENU &MENUOLD
RETURN .T.
****************
PROCEDURE BUSCAR
****************
SAVE SCREEN TO BELU
@ LinMsg,0 SAY "HOLA"
RESTORE SCREEN FROM BELU
RETURN
****************
PROCEDURE XAUXF5
****************
PUSH KEY CLEAR
DEFINE WINDOW BELU FROM 13,1 TO 22,34 SHADOW
ACTIVATE WINDOW BELU
sorteo   = 1
LsNombre = SPACE(LEN(NomAux))
*@ 13,1 CLEAR TO 22,34
*@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
*@ 13,2 TO 21,34 DOUBLE
@ 01,04 SAY "Ordenado : " GET Sorteo PICT "@^ Nombre;C¢digo"
READ
IF LASTKEY()=27
   POP KEY
   DEACTIVATE WINDOW BELU
   RELEASE WINDOW BELU
   RETURN
ENDIF
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO AUXI02
   STORE SPACE(LEN(NomAux)) TO Desde,Hasta
ELSE
   SET ORDER TO AUXI01
   STORE SPACE(LEN(CodAux)) TO Desde,Hasta
ENDIF
@ 04,4  SAY "Desde : " GET Desde  PICT IIF(Sorteo=1,"@!S15",REPLI("!",LEN(DESDE)))
@ 05,4  SAY "Hasta : " GET Hasta  PICT IIF(Sorteo=1,"@!S15",REPLI("!",LEN(HASTA)))
@ 06,2  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
IF LASTKEY()=27
   POP KEY
   DEACTIVATE WINDOW BELU
   RELEASE WINDOW BELU
   RETURN
ENDIF
Ciclo = .F.
IF Sorteo = 2
   m.Key1   = xTabla+TRIM(Desde)
   m.Key2   = xTabla+TRIM(Hasta)
ELSE
   m.Key1   = xTabla + TRIM(Desde)
   m.Key2   = xTabla + TRIM(Hasta)
ENDIF
IF ! EMPTY(LsNombre)
   Localizar = .t.
   SEEK Key1
   IF Sorteo = 1
      LOCATE WHILE CLFAUX+CODAUX<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ELSE
      LOCATE WHILE CLFAUX+NOMAUX<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ENDIF
   LeeReg = FOUND()
ELSE
   SEEK KEY1
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
ENDIF
POP KEY
DEACTIVATE WINDOW BELU
RELEASE WINDOW BELU
RETURN
****************
PROCEDURE XCATGF
****************
PUSH KEY CLEAR
DEFINE WINDOW BELU FROM 13,1 TO 22,34 SHADOW
ACTIVATE WINDOW BELU
sorteo   = 2
LsNombre = SPACE(LEN(CATG.DesMat))
@ 01,04 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
IF LASTKEY()=27
   POP KEY
   DEACTIVATE WINDOW BELU
   RELEASE WINDOW BELU
   RETURN
ENDIF
Localizar = .f.
IF Sorteo = 2
   SET ORDER TO &xORDER2
   STORE SPACE(LEN(Init_Nombre)) TO Desde,Hasta
ELSE
   SET ORDER TO &xORDER1
   STORE SPACE(LEN(Init_Codigo)) TO Desde,Hasta
ENDIF
@ 04,4  SAY "Desde : " GET Desde  PICT IIF(Sorteo=2,"@!S15",REPLI("!",LEN(DESDE)))
@ 05,4  SAY "Hasta : " GET Hasta  PICT IIF(Sorteo=2,"@!S15",REPLI("!",LEN(HASTA)))
@ 06,2  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
IF LASTKEY()=27
   POP KEY
   DEACTIVATE WINDOW BELU
   RELEASE WINDOW BELU
   RETURN
ENDIF
Ciclo = .F.
IF Sorteo = 2
   m.Key1   = TRIM(Desde)
   m.Key2   = TRIM(Hasta)
ELSE
   m.Key1   = xTabla + TRIM(Desde)
   m.Key2   = xTabla + TRIM(Hasta)
ENDIF
IF ! EMPTY(LsNombre)
   Localizar = .t.
   SEEK m.Key1
   IF Sorteo = 1
      LOCATE WHILE &xWHILE1.<=m.Key2 FOR &xFOR
   ELSE
      LOCATE WHILE &xWHILE2.<=m.Key2 FOR &xFOR.
   ENDIF
   LeeReg = FOUND()
ELSE
   SEEK m.KEY1
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
ENDIF
POP KEY
DEACTIVATE WINDOW BELU
RELEASE WINDOW BELU
RETURN
*****************
PROCEDURE XCTASF5
*****************
PUSH KEY CLEAR
DEFINE WINDOW BELU FROM 13,1 TO 22,34 SHADOW
ACTIVATE WINDOW BELU
sorteo   = 2
LsNombre = SPACE(LEN(CTAS.NomCta))
@ 01,04 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
IF LASTKEY()=27
   POP KEY
   DEACTIVATE WINDOW BELU
   RELEASE WINDOW BELU
   RETURN
ENDIF
Localizar = .f.
IF Sorteo = 2
   SET ORDER TO &xORDER2
   STORE SPACE(LEN(Init_Nombre)) TO Desde,Hasta
ELSE
   SET ORDER TO &xORDER1
   STORE SPACE(LEN(Init_Codigo)) TO Desde,Hasta
ENDIF
@ 04,4  SAY "Desde : " GET Desde  PICT IIF(Sorteo=2,"@!S15",REPLI("!",LEN(DESDE)))
@ 05,4  SAY "Hasta : " GET Hasta  PICT IIF(Sorteo=2,"@!S15",REPLI("!",LEN(HASTA)))
@ 06,2  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
IF LASTKEY()=27
   POP KEY
   DEACTIVATE WINDOW BELU
   RELEASE WINDOW BELU
   RETURN
ENDIF
Ciclo = .F.
IF Sorteo = 2
   m.Key1   = TRIM(Desde)
   m.Key2   = TRIM(Hasta)
ELSE
   m.Key1   = xTabla + TRIM(Desde)
   m.Key2   = xTabla + TRIM(Hasta)
ENDIF
IF ! EMPTY(LsNombre)
   Localizar = .t.
   SEEK m.Key1
   IF Sorteo = 1
      LOCATE WHILE &xWHILE1.<=m.Key2 FOR &xFOR
   ELSE
      LOCATE WHILE &xWHILE2.<=m.Key2 FOR &xFOR.
   ENDIF
   LeeReg = FOUND()
ELSE
   SEEK m.KEY1
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
ENDIF
POP KEY
DEACTIVATE WINDOW BELU
RELEASE WINDOW BELU
RETURN
****************
PROCEDURE XTABL5
****************
PUSH KEY CLEAR
DEFINE WINDOW BELU FROM 13,1 TO 22,34 SHADOW
ACTIVATE WINDOW BELU
IF NomCampo = [NOMB]
   Sorteo = 2
ENDIF
LsNombre = SPACE(LEN(Nombre))
@ 01,04 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO TABL01
   STORE SPACE(nDigitos) TO Desde,Hasta
ELSE
   SET ORDER TO TABL02
   STORE SPACE(LEN(Nombre)) TO Desde,Hasta
ENDIF
@ 04,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 05,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 06,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
m.Key1   = xTabla + TRIM(Desde)
m.Key2   = xTabla + TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK m.Key1
   Localizar = .t.
   IF Sorteo = 1
      LOCATE WHILE TABLA+CODIGO<=m.Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
   ELSE
      LOCATE WHILE TABLA+NOMBRE<=m.Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
   ENDIF
   LeeReg = FOUND()
ELSE
   SEEK m.KEY1
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
ENDIF
POP KEY
DEACTIVATE WINDOW BELU
RELEASE WINDOW BELU
RETURN
*************
PROCEDURE XF4
*************
IF ! Localizar
   RETURN
ENDIF
CONTINUE
IF FOUND()
   Listar = .t.
ELSE
  ?? CHR(7)
ENDIF
****************
PROCEDURE XNOMB5
****************
PUSH KEY CLEAR
DEFINE WINDOW BELU FROM 13,1 TO 22,34 SHADOW
ACTIVATE WINDOW BELU
LsNombre = SPACE(LEN(Nombre))
@ 01,04 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO TABL01
   STORE SPACE(nDigitos) TO Desde,Hasta
ELSE
   SET ORDER TO TABL02
   STORE SPACE(LEN(Nombre)) TO Desde,Hasta
ENDIF
@ 04,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 05,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 06,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
m.Key1   = xTabla + TRIM(Desde)
m.Key2   = xTabla + TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK m.Key1
   Localizar = .t.
   IF Sorteo = 1
      LOCATE WHILE TABLA+CODIGO<=m.Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
   ELSE
      LOCATE WHILE TABLA+NOMBRE<=m.Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
   ENDIF
   LeeReg = FOUND()
ELSE
   SEEK m.KEY1
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
ENDIF
POP KEY
DEACTIVATE WINDOW BELU
RELEASE WINDOW BELU
RETURN
