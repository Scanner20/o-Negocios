*** 
*** ReFox XI+  #IT489753  Victor  EMBRACE [VFP70]
***
**
PROCEDURE exit_systema
 PARAMETER _menu_ok_, _menu_pk_, verror
 IF  .NOT. verror
    IF  .NOT. _menu_ok_ .AND.  .NOT. _menu_pk_ .AND.  .NOT. verror
       IF TYPE("A_entorno")='O'
          IF a_entorno.contador_frm>0
             RETURN
          ENDIF
       ENDIF
    ENDIF
 ENDIF
 CLEAR WINDOW
 SET SKIP OF MENU _MSYSMENU .F.
 CLEAR EVENTS
 CLOSE TABLE ALL
 IF  .NOT. _menu_ok_ .OR. _menu_pk_
    IF SYS(5)<>"\:"
       a_ruta_exe0 = SYS(5)+SYS(2003)+'\'
    ELSE
       a_ruta_exe0 = SYS(2003)+'\'
    ENDIF
    _cruta_exe = a_ruta_exe0
    IF  .NOT. USED("AD_DATLO")
       vfile = _cruta_exe+'Bd\AD_DATLO.DLL'
       IF FILE(vfile)
          USE &vfile IN 0
          SELECT ad_datlo
          IF  .NOT. _menu_ok_ .AND.  .NOT. _menu_pk_
             ccampoidx = 'Mod'+ALLTRIM(STR(VAL(vmodulo_)))
             _ctma_ = 'Tma'+ALLTRIM(STR(VAL(vmodulo_)))
             SET ORDER TO &ccampoidx
             IF SEEK(a_usuario+UPPER(ALLTRIM(SYS(0)))+vmodulo_+'A')
                IF &_ctma_ <=1
                   REPLACE &ccampoidx WITH '', &_ctma_ WITH 0
                   IF  .NOT. o_
                      total_mod_act = 0
                      FOR _mod_act = 1 TO 15
                         _cm_ = EVALUATE('Mod'+ALLTRIM(STR(_mod_act)))
                         total_mod_act = total_mod_act+IIF( .NOT. EMPTY(_cm_), 1, 0)
                         IF total_mod_act>0
                            EXIT
                         ENDIF
                      ENDFOR
                      IF total_mod_act=0
                         reg_actual = RECNO()
                         USE
                         USE &vfile
                         GOTO reg_actual
                         REPLACE estado WITH 'I', fch_sal WITH DATE(), hor_sal WITH TIME()
                      ENDIF
                   ENDIF
                ELSE
                   REPLACE &_ctma_ WITH &_ctma_ - 1
                ENDIF
             ENDIF
          ENDIF
          IF _menu_pk_
             SET ORDER TO estado
             IF SEEK(a_usuario+UPPER(ALLTRIM(SYS(0)))+'A')
                REPLACE o_ WITH .F.
                total_mod_act = 0
                FOR _mod_act = 1 TO 15
                   _cm_ = EVALUATE('Mod'+ALLTRIM(STR(_mod_act)))
                   total_mod_act = total_mod_act+IIF( .NOT. EMPTY(_cm_), 1, 0)
                   IF total_mod_act>0
                      EXIT
                   ENDIF
                ENDFOR
                IF total_mod_act=0
                   reg_actual = RECNO()
                   USE
                   USE &vfile
                   GOTO reg_actual
                   REPLACE estado WITH 'I', fch_sal WITH DATE(), hor_sal WITH TIME()
                ENDIF
             ENDIF
          ENDIF
          USE
       ENDIF
    ENDIF
 ENDIF
 RELEASE ALL
 CANCEL
 CLEAR WINDOW
 QUIT
 RETURN
ENDPROC
**
FUNCTION lic_usr
 PARAMETER _cmodulo, _cruta_exe
 IF  .NOT. USED("AD_DATLO")
    vfile = _cruta_exe+'Bd\AD_DATLO.DLL'
    USE &vfile IN 0
 ENDIF
 SELECT ad_datlo
 ccampoidx = 'Mod'+ALLTRIM(STR(VAL(_cmodulo)))
 _ctma_ = 'Tma'+ALLTRIM(STR(VAL(_cmodulo)))
 vtmp = SYS(2023)
 vcont = 1
 DO WHILE .T.
    cidx = vtmp+'\'+'mod'+ALLTRIM(STR(vcont))+'.idx'
    IF  .NOT. FILE(cidx)
       EXIT
    ENDIF
    vcont = vcont+1
 ENDDO
 SET ORDER TO &ccampoidx
 xtantos = 0
 IF  .NOT. SEEK(a_usuario+UPPER(SYS(0))+_cmodulo+'A')
    INDEX ON &ccampoidx+estado TO (cidx)
    = SEEK(_cmodulo+'A')
    COUNT WHILE &ccampoidx = _cmodulo AND UPPER(estado) = "A" TO xtantos
 ENDIF
 SET ORDER TO estado
 vretorno = .T.
 IF  .NOT. vdfoxlib(_cmodulo, ccampoidx, _ctma_)
    vretorno = .F.
 ENDIF
 USE IN ad_datlo
 DELETE FILE &cidx
 RETURN vretorno
ENDFUNC
**
FUNCTION vdfoxlib
 LPARAMETERS _cmodulo, ccampoidx, _ctma_
 pathusr = _cruta_exe+'Bd\'
 LOCAL cod_tmp
 cod_tmp = 0
 IF  .NOT. FILE(pathusr+'foxlib.dbf')
    = MESSAGEBOX('La Licencia no es valida. Copia no autorizada. Si es usuario		registrado llamar a Soporte Tecnico', 16, "Aviso DatEasy")
    RETURN .F.
 ELSE
    SELECT 0
    USE pathusr+'foxlib.dbf'
    _cmo_ = VAL(_cmodulo)
    venteros = ALLTRIM(STR(INT(_cmo_*_cmo_/3)))
    _cmo_ = ALLTRIM(STR(_cmo_*_cmo_/3, 5, 2))
    _cmo_ = INT(VAL(SUBSTR(_cmo_, AT(".", _cmo_)+1)))
    IF  .NOT. EMPTY(_cmo_)
       venteros = venteros+'.'+ALLTRIM(STR(INT(_cmo_)))
    ENDIF
    LOCATE FOR UPPER(ALLTRIM(modulo))=UPPER(ALLTRIM(encripta_datos(venteros, '-')))
    RELEASE _cmo_, venteros
    vli_no = .F.
    IF FOUND()
       IF LEFT(codigo, 2)<>'RL'
          vli_no = .T.
       ENDIF
       cod_tmp = VAL(encripta_datos(SUBSTR(codigo, 3), '+'))-179
    ELSE
       vli_no = .T.
    ENDIF
    USE IN foxlib
    IF vli_no
       RELEASE vli_no
       = MESSAGEBOX('La Licencia a sido violada. Copia no autorizada.						Llamar a Soporte Tecnico', 16, "Aviso DatEasy")
       RETURN .F.
    ENDIF
    RELEASE vli_no
 ENDIF
 IF xtantos+1>cod_tmp
    = MESSAGEBOX('Licencia autorizado para '+ALLTRIM(STR(cod_tmp))+' usuarios', 32, "Aviso DatEasy")
 ENDIF
 SELECT ad_datlo
 IF  .NOT. SEEK(a_usuario+UPPER(ALLTRIM(SYS(0)))+'A')
    INSERT INTO ad_datlo (cod_user,fch_ing,hor_ing,terminal,&ccampoidx,estado,o_,&_ctma_) VALUES(a_usuario, DATE(), TIME(), SYS(0), _cmodulo,'A',.T.,1)
 ELSE
    REPLACE &ccampoidx WITH _cmodulo, &_ctma_ WITH &_ctma_+1
 ENDIF
ENDFUNC
**
PROCEDURE _mPOPUP_
 LPARAMETERS tnbar
 DO CASE
    CASE tnbar=1
       xbmp = ALLTRIM(GETFILE('bmp,gif,jpg,dib,ico'))
       IF  .NOT. EMPTY(xbmp)
          xbmp = "BMP"+SUBSTR(xbmp, RAT("\", xbmp))
       ENDIF
       IF  .NOT. SEEK(a_usuario+'80'+'01', 'AD_ATRIB', 'PANTAP')
          INSERT INTO AD_ATRIB (cod_usr, tipo_a, codigo_a, val_2_a) VALUES (a_usuario, '80', '01', xbmp)
       ELSE
          REPLACE val_2_a WITH xbmp IN ad_atrib
       ENDIF
       _SCREEN.activeform.picture = xbmp
       _SCREEN.activeform.refresh
       RELEASE xbmp
    CASE tnbar=2
       xcolo = ALLTRIM(STR(GETCOLOR()))
       IF xcolo='-1'
          RETURN
       ENDIF
       IF  .NOT. SEEK(a_usuario+'81'+'01', 'AD_ATRIB', 'PANTAP')
          INSERT INTO AD_ATRIB (cod_usr, tipo_a, codigo_a, val_5_a) VALUES (a_usuario, '81', '01', xcolo)
       ELSE
          REPLACE val_5_a WITH xcolo IN ad_atrib
       ENDIF
       _SCREEN.backcolor = VAL(xcolo)
       _SCREEN.refresh
    CASE tnbar=4
       xbmp = ALLTRIM(GETFILE('bmp,gif,jpg,dib,ico'))
       IF  .NOT. EMPTY(xbmp)
          xbmp = "BMP"+SUBSTR(xbmp, RAT("\", xbmp))
       ENDIF
       IF  .NOT. SEEK(a_usuario+'82'+'01', 'AD_ATRIB', 'PANTAP')
          INSERT INTO AD_ATRIB (cod_usr, tipo_a, codigo_a, val_2_a) VALUES (a_usuario, '82', '01', xbmp)
       ELSE
          REPLACE val_2_a WITH xbmp IN ad_atrib
       ENDIF
       _SCREEN.activeform.image1.picture = xbmp
       _SCREEN.activeform.refresh
       RELEASE xbmp
 ENDCASE
 DEACTIVATE POPUP gridpopup
ENDPROC
**
*** 
*** ReFox - todo no se pierde 
***
