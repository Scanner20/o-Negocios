********************************************************************************
*  bDef_Cmp    Funci¢n que define los campos que se van a presentar en la ven- *
*              tana browse, asi como las funciones asociadas al VALID,WHEN,cam-*
*              calculados,encabezados y formatos de edici¢n (PICTURE)          *
********************************************************************************
*****************
FUNCTION bdef_cmp
*****************
PARAMETERS smodulo
IF PARAMETERS() = 0
	WAIT "Falta definir campos a examinar(Browse)" WINDOW NOWAIT
	RETURN TO MASTER

ENDIF
PRIVATE scmp
DO CASE
CASE INLIST(smodulo,[DIARIO_GEN])
OTHER
	WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
	RETURN TO MASTER
ENDCASE
RETURN scmp
********************
PROCEDURE bborra_reg
********************
IF !lborra
	=f1qeh("No es posible borrar registro")
	RETURN
ENDIF
m.regact = RECNO()
IF TYPE([NroReg])=[N]
	gntotdel = gntotdel + 1
	IF ALEN(aregdel)<gntotdel
		DIMENSION aregdel(gntotdel + 5)
	ENDIF
	aregdel(gntotdel) = nroreg
ENDIF
DELE
SKIP +1
blborrar = .T.
DEACTIVATE WINDOW (m.bdeta)
SHOW WINDOW (m.bdeta) REFRESH TOP
*********************
PROCEDURE bagrega_reg
*********************
PRIVATE eof1
IF !ladiciona
	=f1qeh("No es posible a¤adir registro")
	RETURN
ENDIF
eof1 = EOF()
APPEND BLANK
DO CASE
CASE INLIST(smodulo,[DIARIO_GEN])
	DO WHILE !RLOCK()
	ENDDO
	REPLACE nromes WITH xsnromes
	REPLACE codope WITH xscodope
	REPLACE nroast WITH xsnroast
	UNLOCK
CASE INLIST(smodulo,[SIST_REQU])
	DO WHILE !RLOCK([REQU])
	ENDDO
	REPLACE area    WITH lsarea
	REPLACE sistema WITH gssistema
	REPLACE sede    WITH lssede
	UNLOCK IN [REQU]
ENDCASE
IF eof1
	GO TOP
	DEACTIVATE WINDOW (m.bdeta)
	SHOW WINDOW (m.bdeta) REFRESH TOP
ENDIF
RETURN
********************************************************************************
*
*                                                                            Ý
* vBrw      VALID      del browse a nivel de registro                        Ý
*                                                                            Ý
*                                                                            Ý
********************************************************************************
FUNCTION vbrw

DO CASE
CASE INLIST(smodulo,[INGRESOS],[SALIDAS])
	IF TYPE("NroItm")="N"
		IF nroitm<>RECNO()
			REPLACE nroitm WITH RECNO()
		ENDIF
	ENDIF
CASE INLIST(smodulo,[APERTURA])
	IF lgrb_arch
		DO brw_grab
		lgrb_arch = .F.
	ENDIF
	*@ 22,14 SAY CATG.DESMAT PICT "@S40"
ENDCASE
********************************************************************************
*                                                                            Ý
* wBrw      WHEN       del browse a nivel de registro                        Ý
*                                                                            Ý
*                                                                            Ý
********************************************************************************
*************
FUNCTION wbrw
*************
IF DELETED()
	RETURN .F.
ENDIF
DO CASE
CASE INLIST(smodulo,[INGRESOS],[SALIDAS])
	IF TYPE("NroItm")="N"
		IF nroitm<>RECNO()
			REPLACE nroitm WITH RECNO()
		ENDIF
	ENDIF
CASE INLIST(smodulo,[APERTURA])
	=SEEK(codmat,"CATG")
	@ 22,14 SAY catg.desmat PICT "@S40"
	lgrb_arch = .F.
CASE INLIST(smodulo,[GEN_O/T])
	=SEEK(codmat,"CATG")
	** SubAlm,05 : CodMat,42
	=SEEK(codmat,[CATG])
	@ 19,01 SAY LEFT(SUBS(almnombr(subalm),5),17)+[ Mat.:]+LEFT(catg.desmat,35)+[ F:]+TRAN(cnfmla,'999999.9999')
	lgrb_arch = .F.
CASE smodulo = [FORMPROD]
	@ 20,4 SAY "ALMACEN:"+SUBS(almnombr(subalm),5)
ENDCASE
RETURN .T.
******************
FUNCTION  _cuales
******************
PARAMETER _cual
DO CASE
CASE _cual = 1
	RETURN [    Solo Materiales con Stock     ]
CASE _cual = 2
	RETURN [Todos los Materiales Seleccionados]
OTHER
	RETURN [ ]
ENDCASE
******************
PROCEDURE resetpag
******************
IF linfin <= PROW() .OR. numpag = 0 ;
		.OR. saltopag
	saltopag = .F.
	IF numpag > 0
		numlin = linfin + 1
		IF numlin < (PROW() + 1)
			numlin = (PROW() + 1)
		ENDIF
		@ numlin,ancho -12  SAY "Continua.."
	ENDIF
	DO f0mbprn IN f0print
	IF INKEY() = k_esc
		cancelar = .T.
	ENDIF
ENDIF
RETURN
****************
FUNCTION NROAST
*****************
PARAMETER XsNroAst
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = OPER->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = OPER->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = OPER->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = OPER->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = OPER->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = OPER->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = OPER->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = OPER->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = OPER->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = OPER->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = OPER->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = OPER->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = OPER->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = OPER->NDOC13
   OTHER
     iNroDoc = OPER->NRODOC
ENDCASE

IF OPER->ORIGEN
   iNroDoc = VAL(TsCodDiv1+XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ########"),4))
ENDIF
IF PARAMETER() = 1
   IF VAL(XsNroAst) > iNroDoc
     iNroDoc = VAL(XsNroAst) + 1
   ELSE
     iNroDoc = iNroDoc + 1
   ENDIF
   DO CASE
      CASE XsNroMES = "00"
        REPLACE   OPER->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   OPER->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN OPER
ENDIF
RETURN  RIGHT("00000000" + LTRIM(STR(iNroDoc)), 8)
***************
FUNCTION _chknro
***************
IF (&sesrgv.)
	IF MONTH(ctra.fchdoc)#VAL(xsnromes)
		serr = [Registro pertenece al mes de ]+PADR(mes(MONTH(ctra.fchdoc)),10)
		RETURN .F.
	ENDIF
ENDIF
RETURN .T.
******************
PROCEDURE cbdagdbf
******************
** Abrimos areas a usar **
SELECT 0
USE cbdtcier
IF !USED()
	RETURN .F.
ENDIF
regact = _mes + 1
modificar = ! cierre
IF regact <= RECCOUNT()
	GOTO regact
	modificar = ! cierre
ENDIF
USE
*
SELE 0
USE admmtcmb ORDER tcmb01   ALIAS tcmb
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE cbdmctas ORDER ctas01   ALIAS ctas
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE cbdmauxi ORDER auxi01   ALIAS auxi
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE &gsrutaaux.cbdvmovm ORDER vmov01   ALIAS vmov
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE &gsrutaaux.cbdrmovm ORDER rmov01   ALIAS rmov
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE &gsrutaaux.cbdtoper ORDER oper01   ALIAS oper
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE &gsrutaaux.cbdacmct ORDER acct01   ALIAS acct
IF !USED()
	RETURN .F.
ENDIF
** Archivo de Control de Documentos del Proveedor **
IF GsProgram=[CBDRDGP0]
	SELE 0
	USE cjadprov ORDER dpro06   ALIAS dpro
	IF !USED()
		RETURN .F.
	ENDIF
	**
	SELE 0
	USE cjatprov ORDER prov02   ALIAS prov
	IF !USED()
		RETURN .F.
	ENDIF
	**
	SELE 0
	USE cbddrmov ORDER drmo01 ALIAS drmov
	IF !USED()
		RETURN .F.
	ENDIF
ENDIF
RETURN .T.
******************
PROCEDURE movpimp
******************
IF vmov->codmon = 1
	*@  20,40    SAY "S/."                                   COLOR SCHEME 7
	@  15,48    SAY vmov->dbenac  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  15,63    SAY vmov->hbenac  PICTURE "999,999,999.99"  COLOR SCHEME 7

	*@  23,40    SAY "US$"                                   COLOR SCHEME 7
	*@  23,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
	*@  23,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
ELSE
	*@  20,40    SAY "US$"                                   COLOR SCHEME 7
	@  15,48    SAY vmov->dbeusa  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  15,63    SAY vmov->hbeusa  PICTURE "999,999,999.99"  COLOR SCHEME 7

	*@  23,40    SAY "S/."                                   COLOR SCHEME 7
	*@  23,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
	*@  23,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
ENDIF
RETURN
******************
PROCEDURE actcta40
******************
CLOSE DATA
SELE 0
USE \aplica\cia001\cbdmcta2 ORDER cta201 ALIAS cta2

SELE 0
USE \base\cia001\c1999\cbdrmovm ORDER rmov03
FOR K=8 TO 12
	tsnromes=TRAN(K,[@L ##])
	SEEK tsnromes+[40]
	SCAN WHILE nromes+codcta=tsnromes+[40]    && for CodOpe#[040]
		WAIT WINDOW [Procesando: ]+codcta+[ ]+nromes+[ ]+codope+[  ]+nroast+[ ]+nrodoc NOWAIT
		lsnrodoc=nromes+[0001-99]
		jc_clfaux = clfaux
		=f1_rlock(0)
		lexiste=SEEK(codcta,[CTA2])
		REPLA clfaux WITH [40]
		IF !lexiste
			LOOP
		ENDIF
		DO CASE
		CASE INLIST(codcta,[40100100])
			REPLA codaux WITH cta2.codaux    &&  [401010]
			
		CASE INLIST(codcta,[40100101])
			REPLA codaux WITH cta2.codaux    &&  [401010]
			
		CASE INLIST(codcta,[40100102])
			REPLA codaux WITH cta2.codaux    &&  [401010]
	    		
		CASE INLIST(codcta,[40170200])
			REPLA codaux WITH cta2.codaux    &&  [401720]

		CASE INLIST(codcta,[40170300])
			REPLA codaux WITH cta2.codaux    &&  [401730]

		CASE INLIST(codcta,[40190100])
			REPLA codaux WITH cta2.codaux    &&  [401910]

		CASE INLIST(codcta,[40190200])
			REPLA codaux WITH cta2.codaux    &&  [401920]

		CASE INLIST(codcta,[40509900])
 		   *REPLA codaux WITH cta2.codaux    &&  [405990]		
		    if jc_clfaux <> [40]
		       repla codaux with cta2.codaux &&  [405990]
		    endif
		    if jc_clfaux = [40] and empty(codaux)
		       repla codaux with cta2.codaux &&  [405990]		    
		    endif

		CASE INLIST(codcta,[40300100])
			REPLA codaux WITH cta2.codaux    &&  [403010]

		CASE INLIST(codcta,[40300200])
			REPLA codaux WITH cta2.codaux    &&  [403020]

		CASE INLIST(codcta,[40300300])
			REPLA codaux WITH cta2.codaux    &&  [403030]

		CASE INLIST(codcta,[40300400])
			REPLA codaux WITH cta2.codaux    &&  [403040]

		CASE INLIST(codcta,[40302000])
			REPLA codaux WITH cta2.codaux    &&  [403200]

		CASE INLIST(codcta,[40302200])
			REPLA codaux WITH cta2.codaux    &&  [403220]

		CASE INLIST(codcta,[40302300])
			REPLA codaux WITH cta2.codaux    &&  [403230]

		CASE INLIST(codcta,[40302500])
			REPLA codaux WITH cta2.codaux    &&  [403250]

		CASE INLIST(codcta,[40302700])
			REPLA codaux WITH cta2.codaux    &&  [403270]

		CASE INLIST(codcta,[40302800])
			REPLA codaux WITH cta2.codaux    &&  [403280]
		ENDCASE
		IF nromes>[07] AND !INLIST(codope,[040],[270])
			IF (nrodoc=nroast OR EMPTY(nrodoc))
				REPLACE nrodoc WITH lsnrodoc
			ENDIF
			lsvcto=[CTA2.VCto]+nromes
			IF !EMPTY(EVAL(lsvcto))
				REPLACE fchvto WITH EVAL(lsvcto)
				REPLACE fchped WITH EVAL(lsvcto)
			ENDIF
		ENDIF
		UNLOCK
	ENDSCAN
ENDFOR
******************
PROCEDURE act40100
******************
*
CLOSE DATA
SELE 0
USE \aplica\cia001\cbdmcta2 ORDER cta201 ALIAS cta2
SELE 0
USE \base\cia001\c1999\cbdrmovm ORDER rmov03
FOR K=8 TO 12
	tsnromes=TRAN(K,[@L ##])
	SEEK tsnromes+[40100100]
	SCAN WHILE nromes+codcta=tsnromes+[40100100] for inlist(codope,[065],[070],[072]) and tpomov=[D]
		 WAIT WINDOW [Procesando: ]+codcta+[ ]+nromes+[ ]+codope+[  ]+nroast+[ ]+nrodoc NOWAIT
		 lsnrodoc=nromes+[0001-99]
		 lexiste=SEEK(codcta,[CTA2])
		 IF !lexiste
		 	LOOP
		 ENDIF
		 =f1_rlock(0)
		 DO CASE
		    CASE INLIST(codcta,[40100100])
		         repla clfaux with [40]
			     REPLA codaux WITH cta2.codaux    &&  [401010]
			     REPLACE nrodoc WITH lsnrodoc
			     lsvcto=[CTA2.VCto]+nromes
			    *IF !EMPTY(EVAL(lsvcto))
				    REPLACE fchvto WITH EVAL(lsvcto)
				    REPLACE fchped WITH EVAL(lsvcto)
   			    *ENDIF
   		 endcase	 
		 UNLOCK
	ENDSCAN
ENDFOR
**********************
PROCEDURE act_data_ctb   && Actualizaci_n de numeros de Asientos 01/07/99 05:34p.m.
**********************
m.DesProc1=[Abriendo archivos...]
IF !open_arch1([CBDACTDV])
	CLOSE DATA
	RETURN
ENDIF
*
lProcessing=.t.
m.DesProc1=[Actualizando estructuras...]
IF !act_stru_dbf()
    CLOSE DATA
    RETURN
ENDIF
*
DIMENSION vcodcta(10)
STORE [] TO vcodcta
=capctaprov()

*
xscoddiv1=[01]
xscoddiv2=[02]
xscoddiv3=[03]
*
m.DesProc1=[Consolidando informaci_n de divisionarias...]
SELE rmov2
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv2+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv2+NroAst,70)
    =muestra_est()
	REPLA coddiv WITH xscoddiv2
	REPLA nroast WITH xscoddiv2+nroast
	IF !EMPTY(nrodoc) AND chkcta(codcta)
	    m.DesProc3=PADR([Divisi_n:]+XsCodDiv2+[ Provisi_n:]+NroDoc+[ -> ]+XsCodDiv2+NroDoc,70)
	    =muestra_est()
		REPLA nrodoc WITH xscoddiv2+nrodoc
	ENDIF
ENDSCAN
*
SELE rmov3
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv3+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv2+NroAst,70)
    =muestra_est()
	REPLA coddiv WITH xscoddiv3
	REPLA nroast WITH xscoddiv3+nroast
	IF !EMPTY(nrodoc) AND chkcta(codcta)
	    m.DesProc3=PADR([Divisi_n:]+XsCodDiv3+[ Provisi_n:]+NroDoc+[ -> ]+XsCodDiv3+NroDoc,70)
	    =muestra_est()
		REPLA nrodoc WITH xscoddiv3+nrodoc
	ENDIF
ENDSCAN
*
SELE rmov
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLA coddiv WITH xscoddiv1
	REPLA nroast WITH xscoddiv1+nroast
	IF !EMPTY(nrodoc) AND chkcta(codcta)
	    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Provisi_n:]+NroDoc+[ -> ]+XsCodDiv1+NroDoc,70)
	    =muestra_est()
		REPLA nrodoc WITH xscoddiv1+nrodoc
	ENDIF
ENDSCAN
*
SELE vmov2
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv2+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv2+NroAst,70)
    =muestra_est()
	REPLA nroast WITH xscoddiv2+nroast
ENDSCAN
*
SELE vmov3
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv3+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv3+NroAst,70)
    =muestra_est()
	REPLA nroast WITH xscoddiv3+nroast
ENDSCAN
*
SELE vmov
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLA nroast WITH xscoddiv1+nroast
ENDSCAN
*
SELE dpro2
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv2+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv2+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv2+nrodoc
	REPLACE nroast WITH xscoddiv2+nroast
ENDSCAN
*
SELE dpro3
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv3+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv3+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv3+nrodoc
	REPLACE nroast WITH xscoddiv3+nroast
ENDSCAN
*
SELE dpro
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv1+nrodoc
	REPLACE nroast WITH xscoddiv1+nroast
ENDSCAN
*
SELE DRMO2
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv2+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv2+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv2+nrodoc
	REPLACE nroast WITH xscoddiv2+nroast
ENDSCAN
*
SELE DRMO3
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv3+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv3+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv3+nrodoc
	REPLACE nroast WITH xscoddiv3+nroast
ENDSCAN
*
SELE DRMO
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv1+nrodoc
	REPLACE nroast WITH xscoddiv1+nroast
ENDSCAN
*
SELE CHEQ
m.DesProc2=PADR(dbf(),70)
SCAN
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLA nroast WITH xscoddiv1+nroast
ENDSCAN
*
SELE GRCH
m.DesProc2=PADR(dbf(),70)
SCAN
	IF EMPTY(CodDiv)
		REPLACE CodDiv WITH XsCodDiv1
	ENDIF
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLA nroast WITH xscoddiv1+nroast
	REPLA nrodoc WITH xscoddiv1+nrodoc
ENDSCAN
*
SELE DFJR

m.DesProc2=PADR(dbf(),70)
SCAN
	IF EMPTY(CodDiv)
		REPLACE CodDiv WITH XsCodDiv1
	ENDIF
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv1+nrodoc
	REPLACE nroast WITH xscoddiv1+nroast
ENDSCAN

*
SELE REAL
m.DesProc2=PADR(dbf(),70)
SCAN
	IF EMPTY(CodDiv)
		REPLACE CodDiv WITH XsCodDiv1
	ENDIF
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv1+nrodoc
	REPLACE nroast WITH xscoddiv1+nroast
ENDSCAN

*
Store [] TO m.DesProc2,m.DesProc3
=muestra_est()
m.DesProc2=PADR([Generando archivos consolidados...],70)
=muestra_est()

SELE BDET

m.DesProc2=PADR(dbf(),70)
SCAN
	IF EMPTY(CodDiv)
		REPLACE CodDiv WITH XsCodDiv1
	ENDIF
    m.DesProc3=PADR([Divisi_n:]+XsCodDiv1+[ Nro.Asiento:]+NroAst+[ -> ]+XsCodDiv1+NroAst,70)
    =muestra_est()
	REPLACE nrodoc WITH xscoddiv1+nrodoc
	REPLACE nroast WITH xscoddiv1+nroast
ENDSCAN
*
SELE vmov2
USE
*
SELE rmov2
USE
*
SELE vmov3
USE
*
SELE rmov3
USE
*
SELE dpro2
USE
*
SELE dpro3
USE
*
SELE DRMO2
USE
*
SELE DRMO3
USE
*
SELE vmov
m.DesProc3=PADR(dbf()+[ Cabecera de Asientos],70)
=muestra_est()
APPEND FROM \base\cia015\c1999\cbdvmovm.dbf
APPEND FROM \base\cia016\c1999\cbdvmovm.dbf
*
SELE rmov
m.DesProc3=PADR(dbf()+[ Detalle de Asientos],70)
=muestra_est()
APPEND FROM \base\cia015\c1999\cbdrmovm.dbf
APPEND FROM \base\cia016\c1999\cbdrmovm.dbf
*
SELE dpro
m.DesProc3=PADR(dbf()+[ Recepci_n de documentos],70)
=muestra_est()
APPEND FROM \base\cia015\cjadprov.dbf
APPEND FROM \base\cia016\cjadprov.dbf
*
SELE DRMO
m.DesProc3=PADR(dbf()+[ Detalle Sunat y Letras],70)
=muestra_est()
APPEND FROM \base\cia015\C1999\CBDDRMOV.dbf
APPEND FROM \base\cia016\C1999\CBDDRMOV.dbf
*
FOR K = 1 TO _MES
	SELE OPER
	SCAN FOR ORIGEN
		XsCmpMes=[NDOC]+TRAN(K,[@L ##])
		XsNroDoc=XsCodDiv1+TRAN(K,[@L ##])
		XsNroDoc=XsNroDoc+RIGHT(TRIM(tran(EVAL(XsCmpMes),[@L ########])),4)
		REPLACE (XsCmpMes) WITH VAL(XsNroDoc)
	ENDSCAN
ENDFOR
*
CLOSE DATA
lProcessing=.f.
RETURN
********************
PROCEDURE open_arch1
********************
PARAMETER p_modulo
PRIVATE sDbfEd,sAlias,sTag,sExclu
IF !USED([STRU])
	SELE 0
	USE SISTSTRE ORDER STRE01 ALIAS STRU
	IF !USED()
		RETURN .F.
	ENDIF
ENDIF
*
lScanReg=.f.
p_modulo=UPPER(TRIM(p_modulo))
SELE STRU
**>SCAN FOR programa=UPPER(p_modulo)
SCAN FOR UPPER(p_modulo)$Programa
	lScanReg=.t.
	sAlias=TRIM(STRU.Alias)
	sDbfEd=TRIM(STRU.Arc_Dbf_ed)
	sTag  =TRIM(STRU.Tag)
	sExclu=IIF(STRU.Exclusive,[EXCLU],[])
	IF Type("m.DesProc2")=[C]
		m.Desproc2=PADR(TRIM(STRU.Arc_Dbf_ed),70)
		=muestra_est()
	ENDIF
	IF !open_dbf1(sDbfEd,sAlias,sTag,sExclu)
			
		sDbfEd=TRIM(STRU.Arc_Dbf_ed)
		=F1_ALERT([No es posible abrir archivo ]+sDbfEd+[;]+;
		          [Verifique la configuraci_n para este programa],[MENSAJE])
		
		 RETURN .F.
	ENDIF		
	SELE STRU
ENDSCAN
SELE STRU
USE
*
IF !lScanReg
	=F1_ALERT([No existe configuración de tablas para el programa ]+[;]+;
	          [Verificar en menu \Mantenimiento\Configuración de sistema],[MENSAJE])
		
	 RETURN .F.
ENDIF
RETURN .T.
*******************
FUNCTION capctaprov
*******************
numcta = 0
numcta1= 0
*
SELE prov
SCAN FOR tipo=[A]
	lsxxcodcta = ALLTRIM(prov->codcta)
	DO WHILE .T.
		IF EMPTY(lsxxcodcta)
			EXIT
		ENDIF
		numcta = numcta + 1
		IF numcta > ALEN(vcodcta)
			DIMENSION vcodcta(numcta+5)
		ENDIF
		z = AT(",",lsxxcodcta)
		IF z = 0
			z = LEN(lsxxcodcta) + 1
		ENDIF
		okk = .T.
		FOR K = 1 TO numcta1
			*
			IF PADR(LEFT(lsxxcodcta,z-1),LEN(rmov->codcta))=[46900400]
				okk = .F.
			ENDIF
			*
			IF vcodcta(K)= PADR(LEFT(lsxxcodcta,z-1),LEN(rmov->codcta))
				okk = .F.
			ENDIF
		NEXT
		numcta1 = numcta
		IF okk
			vcodcta(numcta) = PADR(LEFT(lsxxcodcta,z-1),LEN(rmov->codcta))
		ELSE
			vcodcta(numcta) = []
		ENDIF
		IF z > LEN(lsxxcodcta)
			EXIT
		ENDIF
		lsxxcodcta = SUBSTR(lsxxcodcta,z+1)
	ENDDO
ENDSCAN
IF numcta<=0
	RETURN .F.
ELSE
	DIMENSION vcodcta(numcta)
	RETURN .T.
ENDIF

***************
FUNCTION chkcta
***************
PARAMETER _cta

FOR kk = 1 TO ALEN(vcodcta)
	IF vcodcta(kk)=_cta
		RETURN .T.
	ENDIF
ENDFOR
RETURN .F.
**********************
PROCEDURE act_stru_dbf
**********************
PRIVATE sDbfEd,sAlias,sTag,sExclu
IF !USED([STRU])
	SELE 0
	USE SISTSTRE ORDER STRE01 ALIAS STRU
	IF !USED()
		RETURN .F.
	ENDIF
ENDIF
SELE STRU
SCAN FOR Cmp_Pro#0
	sAlias=TRIM(STRU.Alias)
	sDbfEd=TRIM(STRU.Arc_Dbf_ed)
	sTag  =TRIM(STRU.Tag)
	sExclu=IIF(STRU.Exclusive,[EXCLU],[])
	hay_arc_memo=.F.
	IF !USED(sAlias)
		IF !open_dbf1(sDbfEd,sAlias,sTag,sExclu)
			IF F1_ALERT([No es posible abrir archivo ]+sDbfEd+[;]+;
			            [Desea seguir con el proceso ?],[SI_O_NO])=1
			   LOOP         	
			ELSE
			   RETURN
			ENDIF			
		ENDIF		
	ENDIF
	m.DesProc2=PADR(sDbfEd,70)
	m.DesProc3=[]
	=muestra_est()
	SELE (salias)
	Xarc_dbf_ed=DBF()
	arc_dbf=addbs(justpath(DBF()))+juststem(DBF())
	IF FILE(arc_dbf+[.Fpt])
		hay_arc_memo=.T.
	ENDIF
	COPY STRU EXTENDED TO stru_ed
	lhay_DBF=SEEK(salias,[Stru])
	SELE (salias)
	USE stru_ed EXCLU
	*
	FOR kk=1 TO STRU.Cmp_Pro
		xtip_act=[Stru.Tip_Act]+STR(kk,1,0)
		xcmp    =[Stru.Cmp]+STR(kk,1,0)
		xtipo   =[Stru.Tipo]+STR(kk,1,0)
		xlon    =[Stru.Lon]+STR(kk,1,0)
		xdec    =[Stru.Dec]+STR(kk,1,0)
		m.DesProc3=PADR([Actualizando campo ]+xCmp ,70)
		=muestra_est()
		IF EVAL(xtip_act)#0 AND !EMPTY(EVAL(xcmp))
			m.DesProc3=PADR([Actualizando campo ]+xCmp ,70)
			=muestra_est()
			IF EVAL(xTip_act)=3  && Actualizacion de varios campos del mismo tipo
				SCAN  FOR TRIM(Field_Name)=TRIM(EVAL(xCmp))
					REPLACE field_type WITH EVAL(xtipo)
					REPLACE field_len  WITH EVAL(xlon)
					REPLACE field_dec  WITH EVAL(xdec)
				ENDSCAN				
				EXIT
			ELSE	
				LOCATE FOR TRIM(field_name)==TRIM(EVAL(xcmp))
				IF !TRIM(field_name)==TRIM(EVAL(xcmp)))  && OSEA NO EXISTE EL CAMPO
					APPEND BLANK
					REPLA FIELD_NAME WITH TRIM(EVAL(xcmp))
				ENDIF
				IF field_type#EVAL(xtipo) AND !EMPTY(EVAL(xTipo))
					REPLACE field_type WITH EVAL(xtipo)
				ENDIF
				IF field_len#EVAL(xlon) AND !EMPTY(EVAL(xLon))					
					REPLACE field_len  WITH EVAL(xlon)
				ENDIF
				IF field_dec#EVAL(xDEC) AND !EMPTY(EVAL(xDec))					
					REPLACE field_dec  WITH EVAL(xdec)
				ENDIF					
			ENDIF
		ENDIF
	ENDFOR
	*
	m.DesProc3=PADR([Generando nueva estructura...],70)
	=muestra_est()
	CREATE new_arc FROM stru_ed
	APPEND FROM (Xarc_dbf_ed)
	arc_dbf_bk=arc_dbf+[.Bbf]
	RENAME (Xarc_dbf_ed) TO (arc_dbf_bk)
	*
	IF (hay_arc_memo)
		arc_fpt   =arc_dbf+[.Fpt]
		arc_fpt_bk=arc_dbf+[.Bpt]
		RENAME (arc_fpt) TO (arc_fpt_bk)
	ENDIF
	*
	USE
	RENAME new_arc.dbf TO (Xarc_dbf_ed)
	IF hay_arc_memo
		RENAME new_arc.fpt TO  (arc_fpt)
	ENDIF
	*
	USE (xArc_dbf_ed) ALIAS (sAlias)
	IF !EMPTY(sTag)
		SET ORDER TO (sTag)
	ENDIF
	m.DesProc3=PADR([Ok],70)
	=muestra_est()
	SELE STRU
ENDSCAN	
RETURN
******************
FUNCTION Open_dbf1
******************
PARAMETER xArchivo,xAlias,xTag,xExclu
xArea_Act=SELECT()
SELE 0
DO CASE
	CASE !EMPTY(xArchivo) AND !EMPTY(xAlias) AND !EMPTY(xExclu)
		USE (xArchivo) ALIAS (xAlias) EXCLU
	CASE !EMPTY(xArchivo) AND !EMPTY(xAlias) AND EMPTY(xExclu)
		USE (xArchivo) ALIAS (xAlias) SHARED
	CASE !EMPTY(xArchivo) AND EMPTY(xAlias) AND !EMPTY(xExclu)
		USE (xArchivo) EXCLU
	CASE !EMPTY(xArchivo) AND EMPTY(xAlias) AND EMPTY(xExclu)
		USE (xArchivo) SHARED
	OTHER 		
		SELE (xArea_Act)
		RETURN .F.
ENDCASE
IF !USED()
	SELE (xArea_act)
	RETURN .F.
ENDIF
IF !EMPTY(xTag)
	SET ORDER TO (xTag)
ENDIF
RETURN .t.
*********************
procedure Muestra_est
*********************
IF lProcessing
	SHOW GET m.CtrlCnfg DISABLE
	SHOW GET m.Control  DISABLE
ELSE
	SHOW GETS ENABLE
ENDIF
SHOW GET m.DesProc1 ENABLE
SHOW GET m.DesProc2 ENABLE
SHOW GET m.DesProc3 ENABLE
return
******************
PROCEDURE CBDACUMD
******************
*  Nombre    : CbdAcumd.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Acumulador de Cuentas                                     *
*  Creaci_n  : 1999/Enero/15                                             *
*  Par metros:   XsCodCta : Codigo de la Cuenta                          *
*                XnMesIni : Mes de inicio a acumulador                   *
*                XnMesFin : Mes de fin a acumular                        *
*                XsCodRef : Cod. de Referencia                           *
*    ******************* Moneda Nacional ********************            *
*               XvCalc( 1): Importe Debe C lculado del mes fin  ...      *
*               XvCalc( 2): Importe Haber C lculado del mes fin ...      *
*               XvCalc( 3): Importe Saldo C lculado del mes fin ...      *
*               XvCalc( 4): Importe Acumulado Debe C lculado    ...      *
*               XvCalc( 5): Importe Acumulado Haber C lculado   ...      *
*               XvCalc( 6): Saldo Acumulado C lculado   ..........       *
*    ******************* Moneda Extranjera ******************            *
*               XvCalc( 7): Importe Debe C lculado del mes fin           *
*               XvCalc( 8): Importe Haber C lculado del mes fin          *
*               XvCalc( 9): Importe Saldo C lculado del mes fin          *
*               XvCalc(10): Importe Acumulado Debe C lculado             *
*               XvCalc(11): Importe Acumulado Haber C lculado            *
*               XvCalc(12): Saldo Acumulado C lculado                    *
*                                                                        *
*                                                                        *
**************************************************************************
PARAMETERS XsCodCta , XnMesIni , XnMesFin , XsCodRef
PRIVATE TnMes,xLLave,xSelect,KK
xSelect = SELECT()
IF XnMesIni < 0  .OR. XnMesFin < 0
   XnMesIni = ABS( XnMesIni )
   XnMesFin = ABS( XnMesFin )
ENDIF
SELECT ACCT
STORE 0 TO XvCalc,XvCalc_D
TnMes = XnMesIni
DO WHILE TnMes <= XnMesFin
   IF PARAMETER() < 4
      xLLave = STR(TnMes,2,0)+XsCodCta
   ELSE
      xLLave = STR(TnMes,2,0)+XsCodCta+XsCodRef
   ENDIF
   SEEK xLlave
   DO WHILE (NroMes+CodCta+CodRef = xLLave ) .AND. ! EOF()
      XvCalc( 4) = XvCalc( 4) + DbeNac  && Debe  Acumulado Moneda Nacional
      XvCalc( 5) = XvCalc( 5) + HbeNac  && Haber Acumulado Moneda Nacional
      XvCalc(10) = XvCalc(10) + DbeExt  && Debe  Acumulado Moneda Extranjera
      XvCalc(11) = XvCalc(11) + HbeExt  && Haber Acumulado Moneda Extranjera
      ** Acumulando  por Division **
      FOR KK=1 to GnDivis
	  		XsCmpDbe1= [DBENAC]+LEFT(vDivision(kk),2)
	  		XsCmpHbe1= [HBENAC]+LEFT(vDivision(kk),2)
	  		XsCmpDbe2= [DBEEXT]+LEFT(vDivision(kk),2)
	  		XsCmpHbe2= [HBEEXT]+LEFT(vDivision(kk),2)
			XvCalc_D(kk,04) = XvCalc_D(kk,04) + EVAL(XsCmpDbe1)
			XvCalc_D(kk,05) = XvCalc_D(kk,05) + EVAL(XsCmpHbe1)
			XvCalc_D(kk,10) = XvCalc_D(kk,10) + EVAL(XsCmpDbe2)
			XvCalc_D(kk,11) = XvCalc_D(kk,11) + EVAL(XsCmpHbe2)
			IF TnMes=XnMesFin
				XvCalc_D(KK,01) = XvCalc_D(KK,01) + EVAL(XsCmpDbe1)
				XvCalc_D(KK,02) = XvCalc_D(KK,02) + EVAL(XsCmpHbe1)
				XvCalc_D(kk,07) = XvCalc_D(kk,07) + EVAL(XsCmpDbe2)
				XvCalc_D(kk,08) = XvCalc_D(kk,08) + EVAL(XsCmpHbe2)
			ENDIF
      ENDFOR
      RELEASE KK
      IF TnMes = XnMesFin
         XvCalc( 1) = XvCalc( 1) + DbeNac    && Debe  del Mes Moneda Nacional
         XvCalc( 2) = XvCalc( 2) + HbeNac    && Haber del Mes Moneda Nacional
         XvCalc( 7) = XvCalc( 7) + DbeExt    && Debe  del Mes Moneda Extranjera
         XvCalc( 8) = XvCalc( 8) + HbeExt    && Haber del Mes Moneda Extranjera
      ENDIF
      SKIP
   ENDDO
   TnMes = TnMes + 1
ENDDO
*** Saldos *************************
XvCalc( 3) = XvCalc( 1) - XvCalc( 2)  && Saldo del Mes Moneda Nacional
XvCalc( 6) = XvCalc( 4) - XvCalc( 5)  && Saldo Acumulado Moneda Nacional
XvCalc( 9) = XvCalc( 7) - XvCalc( 8)  && Saldo del Mes Moneda Extranjera
XvCalc(12) = XvCalc(10) - XvCalc(11)  && Saldo Acumulado Moneda Extranjera
FOR kk= 1 TO GnDivis
	XvCalc_D(kk, 3) = XvCalc_D(kk, 1) - XvCalc_D(kk, 2)  && Saldo del Mes Moneda Nacional
	XvCalc_D(kk, 6) = XvCalc_D(kk, 4) - XvCalc_D(kk, 5)  && Saldo Acumulado Moneda Nacional
	XvCalc_D(kk, 9) = XvCalc_D(kk, 7) - XvCalc_D(kk, 8)  && Saldo del Mes Moneda Extranjera
	XvCalc_D(kk,12) = XvCalc_D(kk,10) - XvCalc_D(kk,11)  && Saldo Acumulado Moneda Extranjera
ENDFOR
RELEASE KK
SELECT (xSelect)
RETURN


