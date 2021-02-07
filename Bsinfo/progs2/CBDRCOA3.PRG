********************************************************************************
* Programa      : CBDRgcoa.PRG                                                 *
* Objeto        : REGISTRO DE ARCHIVOS PARA TRASFERENCIA - COA                 *
* Autor         : VETT                                                         *
* Creaci¢n      : 20/06/95                                                     *
* Actualizaci¢n : 24/04/96                                     - MILKITO       *
********************************************************************************
PRIVATE XsNroMes
*** Abrimos Bases ****

sele 3
use cbdmctas order ctas01 alias CTAS
if !used(3)
	close data
	return
endif
sele 4
use cbdrmovm order RMOV01 ALIAS RMOV
if !used(4)
    close data
    return
endif
sele 5
use cbdvmovm order VMOV01 ALIAS VMOV
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(7)
    close data
    return
ENDIF
SELE 8
USE cbdtoper ORDER oper01   ALIAS OPER
IF !used(8)
    close data
    return
ENDIF

SELE 9
USE cjatprov ORDER prov02   ALIAS PROV
IF !used(9)
    close data
    return
ENDIF
*
USE admmtcmb IN 0 ORDER tcmb01   ALIAS TCMB
IF !used()
    close data
    return
ENDIF
*
use cbddrmov in 0 order drmo01   alias drmov
if !used()
    close data
    return
endif
*
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ACTUALIZACION DE REGISTRO DE COMPRAS AL COA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 19,68      COLOR W/N
@  8,11 CLEAR TO 18,69
@  8,11       TO 18,69

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = "065"
=SEEK(XsCodOpe,"PROV")
XiNroMes = _Mes
XcTipo   = [ ]

@ 10,18 SAY "             Mes de Trabajo : "
@ 11,18 SAY "             Operaci¢n      : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,48 GET XiNroMes PICT "@LZ 99" RANGE 1,12
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELE OPER
         SET FILTER TO INLIST(CodOpe,[065],[070],[072])
         @ 11,48 GET XsCodOpe PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !CBDBUSCA("OPER")
               UltTecla = 0
               LOOP
            ELSE
                XsCodOpe = CodOpe
                UltTecla = Enter
            ENDIF
         ENDIF
         SEEK XsCodOpe
         IF !FOUND() AND !EMPTY(XsCodOpe)
            GsMsgErr = "Operaci¢n inv lida"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF

   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 2 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 1 )

      CASE UltTecla = Enter
         IF  i < 2
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
=SEEK(XsCodOpe,"OPER")
SELECT VMOV

XsNroMes = transf(XiNroMES,"@L ##")
IF EMPTY(XsCodOpe)
ELSE
   xLLave = XsNroMes+XsCodOpe
   SEEK xLLave
   IF ! FOUND()
      GsMsgErr = "No Existen registros a Listar"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
XsNroMes = transf(XiNroMES,"@L ##")
xLLave = XsNroMes
SEEK xLLave
IF  !Crea_Arch()
    GsMsgErr = "Error en creaci¢n de archivos para el COA"
    DO LIB_MERR WITH 99
    CLOSE DATA
    RETURN
ENDIF
** Borramos anteriores actualizaciones **
@ 20,20 SAY "   Borrando anteriores actualizaciones  " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
XsAno = TRANS(_Ano,"9999")
IF inlist(XsCodOpe,[065],[072]) &&,[070])
   SELE X58
   SEEK XsAno+XsNroMes
   DELE REST WHILE X58PERIODO=XsAno+XsNroMes for codope=xscodope
   PACK
   *
   SELE X68
   SEEK XsAno+XsNroMes
   DELE REST WHILE X68PERIODO=XsAno+XsNroMes for codope=xscodope
   PACK
ENDIF
IF XsCodOpe=[070]
   SELE X78
   SEEK XsAno+XsNroMes
   DELE REST WHILE X78PERIODO=XsAno+XsNroMes
   PACK
ENDIF
**
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Cancelar = .F.
@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
En1 = "L I B R O    C O M P R A S"
En2 = "MES DE "+MES(VAL(XsNroMes),1)+" DE "+TRANS(_ANO,"9999")
En3 = " "
En4 = ""
En5 = ""
En6 = "******** ****** **************************************** ********** ******** ********** ****** ****************************************************** ******************************* ******************************* ***************"
En7 = "           COD.                                             Nro.     Fecha    Nro.      Nro.                                                               ** MONTO IMPONIBLE **              ** IMPUESTOS **             IMPORTE    "
En8 = " FECHA     AUX.               P R O V E E D O R             RUC      DOCUME.  DOCUMENTO REGIS.                      C O N C E P T O                      AFECTA         NO AFECTA         I.G.V.          OTROS            TOTAL     "
En9 = "******** ****** **************************************** ********** ******** ********** ****** ****************************************************** *************** *************** *************** *************** ***************"
***                                                                                                                                                             1                 2                 3               4               5

DIMENSION vImport(5),vTotal(5)
DIMENSION vCodCta(10)
STORE [] TO vCodCta
NumCta = 0
NumCta1= 0
SELE OPER
SEEK TRIM(XsCodOpe)
DO WHILE !EOF() AND CodOpe = TRIM(XsCodOpe)
   SELE PROV
   SEEK OPER->CodOpe
   DO WHILE !EOF() AND CodOpe = OPER->CodOpe
      LsxxCodCta = ALLTRIM(PROV->CodCta)
      DO WHILE .T.
         IF EMPTY(LsxxCodCta)
            EXIT
         ENDIF
         NumCta = NumCta + 1
         IF NumCta > ALEN(vCodCta)
            DIMENSION vCodCta(NumCta+5)
         ENDIF
         Z = AT(",",LsxxCodCta)
         IF Z = 0
            Z = LEN(LsxxCodCta) + 1
         ENDIF
         okk = .T.
         FOR k = 1 TO NumCta1
             *
             if padr(left(lsxxcodcta,z-1),len(rmov->codcta))=[46900400]
                okk = .f.
             endif
             *
             IF vCodCta(k)= PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
                Okk = .F.
             ENDIF
         NEXT
         NumCta1 = NumCta
         IF okk
             vCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
         ELSE
             vCodCta(NumCta) = []
         ENDIF
         IF Z > LEN(LsxxCodCta)
            EXIT
         ENDIF
         LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
      ENDDO
      SKIP
   ENDDO
   SELE OPER
   SKIP
ENDDO
***
SELECT VMOV
NumPag   = 0
SELE OPER
SEEK TRIM(XsCodOpe)
do case
   case inlist(xscodope,[065]) &&,[070])
        DO WHILE !EOF() AND CodOpe=TRIM(XsCodOpe)
            SALTOPAG = .T.
            EN1 = TRIM(OPER->NomOpe)
            xLlave = XsNroMes+OPER->CodOpe
            SELECT VMOV
            Seek xLLave
            STORE 0 TO vTotal
            DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF() .AND. ! Cancelar
               STORE 0 TO vImport
              *XdFchDoc = {,,}
               XdFchDoc = {  ,  ,    }              
               XsCLFAUX = ""
               XsCodAux = ""
               XsNomAux = ""
               XsNroRef = ""
               XyNroRef = ""
               XsNroAST = ""
               XsRefImp = ""
               XsNroRuc = ""
               XfImport = 0
               XfImpInf = 0
               XiCodMon = 1
               XfDolar  = 0
               XlAfecto = .F.
               CHK      = 0
               *
               XsTipo   = []
               XsTipOri = []
               XsNumOri = []
              *XsFecOri = {,,}
               XsFecOri = {  ,  ,    }              
               *
               sKey = NroMes+CodOpe+NroAst
               SELECT RMOV
               SEEK sKey
               XsCtaAnt = SPACE(LEN(RMOV->CodCta))
               DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF()
                  CHK        = CHK        + IIF(TpoMov="D",Import,-Import)
                 *IF  (ELiItm = "ú")
                  IF  (ELiItm = "*")                 
                      SKIP
                      LOOP
                  ENDIF
                  DO CASE
                     CASE ChkCta(CodCta)    &&AND TpoMov="H"
                          =seek(clfaux+codaux,[auxi])
                          xdfchdoc   = fchdoc
                          xsclfaux   = clfaux
                          xscodaux   = codaux
                          xsnroref   = nroref
                          xynroref   = nroref
                          xsnroast   = nroast
                          xsclfaux   = clfaux
                          xicodmon   = codmon     && 1 soles ,2 dolares
                          vimport(5) = vimport(5) + iif(tpomov=[H],import,-import)
                          xfdolar    = xfdolar  + iif(tpomov=[H],impusa,-impusa)
                          *
                          if inlist(xscodaux,[112799],[112699],[102301])
                             xsnomaux = glodoc
                             xsnroruc = nroruc
                          else
                             xsnomaux = auxi->nomaux
                             xsnroruc = auxi->rucaux
                          endif
                          *
                          xstipdoc   = tipdoc
                          if !inlist(xstipdoc,[NO],[  ])
                             if inlist(xscodaux,[112799],[112699],[102301])
                                xsnomaux = iniaux
                                xsnroruc = nroruc
                             endif
                             if inlist(xstipdoc,[07],[08])
                                jj=[SUNAT]+nromes+codope+nroast+codcta+tipdoc+nroref
                                sele drmov
                                seek jj
                                if found()
                                   xstipori = tipori
                                   xsnumori = numori
                                   xsfecori = vctori
                                endif
                                sele rmov
                             endif
                          endif
                          *
                     CASE INLIST(CODCTA,[401001],[401101])
                          xsnroast   = nroast
                          xlafecto = .t.
                       *  xscodaux   = codaux
                          xsrefimp   = nroref
                          vimport(3) = vimport(3) + iif(tpomov=[D],import,-import)
                     CASE CODCTA=[40]
                          xsnroast   = nroast
                          vimport(4) = vimport(4) + iif(tpomov=[D],import,-import)
                       *  xscodaux   = codaux
                     OTHER
                         IF !INLIST(CodCta,"40","42")
                         XsNroAST   = NroAST
                            XfImport = XfImport + IIF(TpoMov="D",Import,-Import)
                         ENDIF
                  ENDCASE
                  SELECT RMOV
                  XsCtaAnt = CODCTA
                  SKIP
               ENDDO
               SELECT VMOV
               Chk = ROUND((ABS(XfImport*18/100) - ABS(vImport(3))),2)
               IF XlAfecto
                  vImport(1) = XfImport
                  vImport(2) = 0
                  IF ABS(Chk) > .01
                     vImport(1) = ROUND(vImport(3)*100/18,2)
                  ENDIF
               ELSE
                  vImport(1) = 0
                  vImport(2) = XfImport
               ENDIF
               LsImport = []
               IF VMOV->CodMon <> 1
                  LsImport = ' (US$' + ALLTRIM(STR(XfDolar,14,2))+")"
                  IF RIGHT(LsImport,3)=".00"
                     LsImport = ' (US$' + ALLTRIM(STR(XfDolar,14,0))+")"
                  ENDIF
               ENDIF
               LsGloDoc = LEFT(VMOV->NotAst,52-LEN(LsImport))+LsImport
               FOR i = 1 to 5
                   Col = 150 + (i-1)*16
                   vTotal(i) = vTotal(i) + vImport(i)
               NEXT
               DO xGrbCoa
               SELE VMOV
               SKIP
               Cancelar = (INKEY() = ESCAPE) .OR. Cancelar
            ENDDO
            IF ! Cancelar
              *@ NumLin,000 SAY "** TOTAL GENERAL **"
               FOR i = 1 to 5
                   Col = 149 + (i-1)*16
                  *@ NumLin,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
               NEXT
            ENDIF
            SELE OPER
            SKIP
        ENDDO
 case xscodope = [070]
       do while !eof() and codope=trim(xscodope)
           xllave = xsnromes+oper->codope
           select vmov
           seek xllave
           do while nromes+codope=xllave .and. !eof() .and. !cancelar
              xsflag   = 0
              xsnumpol = []
              xsimptot = 0
              xsimpadv = 0
              xsimpigv = 0
             *xdfchpag = {,,}
              xdfchpag = {  ,  ,    }             
              xsnroast = nroast
              skey = nromes+codope+nroast
              select rmov
              seek skey
              do while nromes+codope+nroast=skey .and. ! eof()
                 if left(codcta,2)=[40]
                    if tipdoc = [50]
                       jj=[SUNAT]+nromes+codope+nroast+codcta+tipdoc+nroref
                       sele drmov
                       seek jj
                       if found()
                          xsnumpol = n_poliza
                          xsimptot = impori
                          xsimpadv = impnac1
                          xsimpigv = impnac2
                          xdfchpag = vctori
                       endif
                    endif
                    sele rmov
                    xsflag = 1
                 endif
                 skip
              enddo
              select vmov
              if xsflag = 1
                 do xgrbcoa
                 sele vmov
              endif
              skip
              cancelar = (inkey() = escape) .or. cancelar
           enddo
           sele oper
           skip
       enddo
 
   case xscodope = [072]
        do while !eof() and codope=trim(xscodope)
           xllave = xsnromes+oper->codope
           select vmov
           seek xllave
           do while nromes+codope = xllave .and. ! eof() .and. ! cancelar
              skey = nromes+codope+nroast
              select rmov
              seek skey
              do while nromes+codope+nroast = skey .and. ! eof()
                 store 0 to xn58base, xn58igv
                *xdfchdoc = {,,}
                 xdfchdoc = {  ,  ,    }                 
                 store [] to xsclfaux,xscodaux,xsnomaux,xsnroref
                 store [] to xynroref,xsnroast,xsrefimp,xsnroruc
                 store 0  to xfimport,xfimpinf,xfdolar,chk
                 xicodmon = 1
                 xlafecto = .f.
                 xstipo   = []
                 xstipori = []
                 xsnumori = []
                *xsfecori = {,,}
                 xsfecori = {  ,  ,    }                
                 *
                 do case
                    case codcta=[401001]
                         xdfchdoc   = fchdoc
                         xsclfaux   = clfaux
                         xscodaux   = codaux
                         xsnroref   = nroref
                         xynroref   = nroref
                         xsnroast   = nroast
                         xsclfaux   = clfaux
                         xicodmon   = codmon     && 1 soles ,2 dolares
                         *
                         if inlist(xscodaux,[112799],[112699],[102301],[      ])
                            xsnomaux = iniaux
                            xsnroruc = nroruc
                         else
                            xsnomaux = auxi->nomaux
                            xsnroruc = auxi->rucaux
                         endif
                         *
                         xstipdoc   = tipdoc
                         if inlist(xstipdoc,[07],[08])
                            jj=[SUNAT]+nromes+codope+nroast+codcta+tipdoc+nroref
                            sele drmov
                            seek jj
                            if found()
                               xstipori = tipori
                               xsnumori = numori
                               xsfecori = vctori
                            endif
                            sele rmov
                         endif
                         *
                         xn58igv    = iif(tpomov=[D],import,-import)
                         if xn58igv <> 0
                            xn58base = round((100*abs(xn58igv)/18),2)
                         endif
                         do xgrbcoa
                 endcase
                 select rmov
                 skip
              enddo
              sele vmov
              skip
              cancelar = (inkey() = escape) .or. cancelar
           enddo
           sele oper
           skip
        enddo
endcase
CLOSE DATA
@ 20,20 SAY "                                        "
@ 21,20 SAY "                                        "
DO Copia_disk
RETURN

*****************
PROCEDURE xGrbCoa
*****************
IF XiNroMes < 12
   LdFechaFin = CTOD("01/"+STR(XiNroMes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
ELSE
   LdFechaFin = CTOD("31/12/"+STR(_Ano,4,0))
ENDIF
do case
   case xscodope = [065]
       *IF Month(XdFchDoc)<>XiNroMes
       *    XdFchDoc = LdFechaFin
       *ENDIF
   otherwise
endcase

do case
   case inlist(xscodope,[065]) &&,[070])
        IF !(vImport(1)=0 AND vImport(2)=0)
           if vImport(3)<0   &&& Notas de Abono
              xstipdoc = [07]         
           endif    
           if !inlist(xstipdoc,[NO],[  ])
              if inlist(xstipdoc,[07],[08])   &&& NOTAS CREDITO Y NOTAS DE DEBITO
                 sele x68
                 append blank
                 repla x68nroreg  with val(xsnroast)
                 *
                 if inlist(xscodaux,[112799],[112699],[102301])
                    repla x68ident   with xsnroruc
                 else
                    repla x68ident   with alltrim(xsclfaux)+xscodaux
                 endif
                 if !empty(xsnroruc)
                    repla x68ident   with xsnroruc
                 endif
                 *
                 repla x68periodo with right(trans(_ano,[9999]),4)+xsnromes
                 repla x68fecha   with dtos(xdfchdoc)
                 repla x68tipo    with xstipdoc
                 repla x68serie   with left(xsnroref,3)
                 repla x68numero  with subs(xsnroref,4)
                 repla x68base    with abs(round(vimport(1),2))
                 repla x68igv     with abs(round(vimport(3),2))
                 repla x68codigo  with [001]
                 if x68igv = 0
                    repla x68codigo with [004]
                    repla x68base   with abs(round(vimport(2),2))
                 endif
                 repla x68flagmon with iif(xicodmon=1,'1','0')
                 repla x68norden  with [ ]
                 repla x68tipori  with xstipori
                 repla x68serori  with left(xsnumori,3)
                 repla x68numori  with subs(xsnumori,4)
                 repla x68fecori  with dtos(xsfecori)
                 repla x68estado  with '0'
                 *
                 repla nrodoc     with xynroref
                 repla codope     with xscodope
                 *
              else
                 sele x58
                 append blank
                 repla x58nroreg  with val(xsnroast)
                 *
                 if inlist(xscodaux,[112799],[112699],[102301])
                    repla x58ident   with xsnroruc
                 else
                    repla x58ident   with alltrim(xsclfaux)+xscodaux
                 endif
                 if !empty(xsnroruc)
                    repla x58ident   with xsnroruc
                 endif
                 *
                 repla x58periodo with right(trans(_ano,[9999]),4)+xsnromes
                 repla x58fecha   with dtos(xdfchdoc)
                 repla x58tipo    with xstipdoc
                 repla x58serie   with left(xsnroref,3)
                 repla x58numero  with substr(xsnroref,4)
                 repla x58base    with abs(round(vimport(1),2))
                 repla x58igv     with abs(round(vimport(3),2))
                 repla x58codigo  with [001]
                 if x58igv = 0
                    repla x58codigo with [004]
                    repla x58base   with abs(round(vimport(2),2))
                 endif
                 repla x58flagmon with iif(xicodmon=1,'1','0')
                 repla x58norden  with [ ]
                 repla x58estado  with '0'
                 *
                 repla nrodoc     with xynroref
                 repla codope     with xscodope                 
                 *
              endif
           else
              if left(XsNroRef,1)<>'N'  && COMPROBANTES DE PAGO
                 sele X58
                 append blank
                 repla x58nroreg with val(XSNroAst)
                 *
                 repla x58ident  with alltrim(XsClfAux)+XsCodAux
                 IF EMPTY(XsCodAux) or INLIST(XsCodAux,[112799],[112899])
                    repla x58ident with XsNroRuc
                 ENDIF
                 if !empty(xsnroruc)
                    repla x58ident   with xsnroruc
                 endif
                 *
                 repla x58periodo with RIGHT(TRANS(_Ano,"9999"),4)+xsnromes
                 repla x58fecha   with dtos(XdFchdoc)
                 ***
                 LsNroFact= ALLTRIM(XsNroRef)
                 LiNroFact= 0
                 XsNroRef = []
                 XsSerFac = []
                 FlgSer = .T.
                 LsCadena=[]
                 FOR I = 1 TO LEN(LsNroFacT)
                     IF ! SUBSTR(LsNroFact,i,1)$"0123456789"
                        LsChar=SUBSTR(LsNroFact,i,1)
                        IF LsChar=[-]
                           FlgSer = .F.
                        ENDIF
                        LsCadena=LsCadena+LsChar
                     ELSE
                        XsNroRef =XsNroRef + SUBSTR(LsNroFact,i,1)
                        XsSerFac =XsSerFac + IIF(FlgSer,SUBSTR(LsNroFact,i,1),[])
                     ENDIF
                 ENDFOR
                 *
                 DO CASE
                    CASE LsCadena=[F/-]
                    OTHER
                 ENDCASE
                 *
                 repla x58tipo   with [01]
                 repla x58serie  with xsSerFac
                 repla x58numero with xsNroRef
                 *
                 repla x58base with abs(round(vimport(1),2))
                 repla x58igv  with abs(round(vimport(3),2))

                 if vimport(3)<0
                    repla X58tipo with [07] && Notas de credito
                 endif
                 *
                 repla x58codigo  with '001'  &&& ????
                 if x58igv = 0
                    repla x58codigo with '004'
                    repla x58base   with abs(round(vimport(2),2))
                 endif
                 repla x58flagmon with iif(xicodmon=1,'1','0')
                 repla x58norden  with [ ]
                 repla x58estado  with '0'
                 *
                 repla nrodoc     with xynroref
                 repla codope     with xscodope                 
                 *
              else
                 sele X68
                 append blank
                 repla x68nroreg with val(XSNroAst)
                 *
                 repla x68ident  with alltrim(XsClfAux)+XsCodAux
                 IF EMPTY(XsCodAux) or INLIST(XsCodAux,[112799],[112899])
                    repla x68ident with XsNroRuc
                 ENDIF
                 if !empty(xsnroruc)
                    repla x68ident   with xsnroruc
                 endif
                 *
                 repla x68periodo with RIGHT(TRANS(_Ano,"9999"),4)+xsnromes
                 repla x68fecha   with dtos(XdFchdoc)

                 ***

                 LsNroFact= ALLTRIM(XsNroRef)
                 LiNroFact= 0
                 XsNroRef = []
                 XsSerFac = []
                 FlgSer = .T.
                 LsCadena=[]
                 FOR I = 1 TO LEN(LsNroFacT)
                     IF ! SUBSTR(LsNroFact,i,1)$"0123456789"
                        LsChar=SUBSTR(LsNroFact,i,1)
                        IF LsChar=[-]
                           FlgSer = .F.
                        ENDIF
                        LsCadena=LsCadena+LsChar
                     ELSE
                        XsNroRef =XsNroRef + SUBSTR(LsNroFact,i,1)
                        XsSerFac =XsSerFac + IIF(FlgSer,SUBSTR(LsNroFact,i,1),[])
                     ENDIF
                 ENDFOR
                 *
                 DO CASE
                    CASE LsCadena=[F/-]
                    OTHER
                 ENDCASE
                 *
                 repla x68tipo   with [08]
                 repla x68serie  with xsSerFac
                 repla x68numero with xsNroRef
                 *
                 replace X68base with ABS(ROUND(vimport(1),2))
                 replace X68igv  with ABS(ROUND(vimport(3),2))
                 if vimport(3)<0
                    repla X68tipo with [07] && Notas de credito
                 endif
                 *
                 repla x68codigo  with '001' && ????
                 if x68igv=0
                    repla x68codigo with '004'
                    repla x68base   with abs(round(vimport(2),2))
                 endif
                 repla x68flagmon with iif(xicodmon=1,'1','0')
                 repla x68norden  with [ ]
                 repla x68tipori  with [ ]
                 repla x68serori  with [ ]
                 repla x68numori  with [ ]
                 repla x68fecori  with [ ]
                 repla x68estado  with '0'
                 *
                 repla nrodoc     with xynroref
                 repla codope     with xscodope                 
                 *
           endif
           endif
        endif
        
   case xscodope = [070]
        sele x78
        append blank
        repla x78nroreg  with val(xsnroast)
        repla x78periodo with right(trans(_ano,[9999]),4)+xsnromes
        repla x78f_pago  with dtos(xdfchpag)
        repla x78tipo    with [50]
        repla x78numpol  with xsnumpol
        repla x78numfrac with []
        repla x78numcuo  with 0
        repla x78m_impor with xsimptot
        repla x78advalor with xsimpadv
        repla x78isc     with 0
        repla x78igv     with xsimpigv
        repla x78codigo  with [001]
        repla x78norden  with [ ]
        repla x78estado  with '0'


   case xscodope = [072]
        if xn58igv <> 0
           if xn58igv < 0 
              xstipdoc = [07]
           endif
           * 
           if inlist(xstipdoc,[07],[08])
              sele x68
              append blank
              repla x68nroreg  with val(xsnroast)
              *
              if inlist(xscodaux,[112799],[112699],[102301],[      ])
                 repla x68ident   with xsnroruc
              else
                 repla x68ident   with alltrim(xsclfaux)+xscodaux
              endif
              if !empty(xsnroruc)
                 repla x68ident   with xsnroruc
                 repla x68nombre  with xsnomaux
              endif
              *
              repla x68periodo with right(trans(_ano,[9999]),4)+xsnromes
              repla x68fecha   with dtos(xdfchdoc)
              repla x68tipo    with xstipdoc
              repla x68serie   with left(xsnroref,3)
              repla x68numero  with substr(xsnroref,4)
              repla x68base    with abs(xn58base)
              repla x68igv     with abs(xn58igv)
              repla x68codigo  with [001]
              repla x68flagmon with iif(xicodmon=1,'1','0')
              repla x68norden  with [ ]
              repla x68tipori  with xstipori
              repla x68serori  with left(xsnumori,3)
              repla x68numori  with subs(xsnumori,4)
              repla x68fecori  with dtos(xsfecori)
              repla x68estado  with '0'
              *
              repla nrodoc     with xynroref
              repla codope     with xscodope
              *         
           else
              sele x58
              append blank
              repla x58nroreg  with val(xsnroast)
              *
              if inlist(xscodaux,[112799],[112699],[102301],[      ])
                 repla x58ident   with xsnroruc
              else
                 repla x58ident   with alltrim(xsclfaux)+xscodaux
              endif
              if !empty(xsnroruc)
                 repla x58ident   with xsnroruc
                 repla x58nombre  with xsnomaux
              endif
              *
              repla x58periodo with right(trans(_ano,[9999]),4)+xsnromes
              repla x58fecha   with dtos(xdfchdoc)
              repla x58tipo    with xstipdoc
              repla x58serie   with left(xsnroref,3)
              repla x58numero  with substr(xsnroref,4)
              repla x58base    with abs(xn58base)
              repla x58igv     with abs(xn58igv)
              repla x58codigo  with [001]
              repla x58flagmon with iif(xicodmon=1,'1','0')
              repla x58norden  with [ ]
              repla x58estado  with '0'
              *
              repla nrodoc     with xynroref
              repla codope     with xscodope
           endif
           *
        endif
endcase
*
*if (xscodope=[065] .or. xscodope=[070] .or. (xscodope=[072] and !empty(xsnroruc)))
if (xscodope=[065] .or. (xscodope=[072] and !empty(xsnroruc))) and xsnroruc<>[25856228]
   sw = 0
   if empty(xsnroruc)
      sw = 1
   endif
   sele x61
   if sw = 0
      set order to x6102
      seek padr(xsnroruc,len(x61.x61nroruc))
   else
      set order to x6101
      seek padr(alltrim(xsclfaux)+xscodaux,len(x61.x61cinter))
   endif
   if !found()
      append blank
      repla x61nroreg with recn()
      repla x61nroruc with xsnroruc
      if inlist(xscodaux,[112799],[112699],[102301])
         if empty(xsnroruc)
            repla x61cinter with alltrim(xsclfaux)+xscodaux
         else
            repla x61cinter with xsnroruc
         endif
      else
         repla x61cinter with alltrim(xsclfaux)+xscodaux
      endif
      repla x61nombre with xsnomaux
      repla x61estado with '0'
      repla nroast    with xscodope+[-]+xsnroast
   else
      if xscodope = [072]   &&& Caja Chica
         if !empty(xsnomaux) and empty(x61.X61nombre)
            do while !rlock()
            enddo
            repla x61nombre with xsnomaux
            unlock
         endif
      endif
   endif
endif
return
*********************
PROCEDURE  Crea_Arch
*********************

ArcTmp1 = "x68cpcoa.dbf" && Notas de Credito y Debito
IF !FILE(ArcTmp1)
    SELE 0
    CREATE TABLE &ArcTmp1. (x68nroreg n(06), x68ident   c(15)  , x68periodo c(06),;
                            x68fecha  c(08), x68tipo    c(02)  , x68serie   c(04),;
                            x68numero c(20), x68base    n(15,2), x68igv     n(15,2),;
                            x68codigo c(03), x68flagmon c(01)  , x68norden  c(06),;
                            x68tipori c(02), x68serori  c(04)  , x68numori  c(15),;
                            x68fecori c(08), x68estado c(01))

    USE &ArcTmp1. EXCL
    IF !USED()
       RETURN .F.
    ENDIF
    INDEX ON X68PERIODO+STR(X68NROREG,6,0) TAG X6801
    USE
ENDIF
sele 0
use &ArcTmp1. ORDER X6801  ALIAS X68 EXCL
IF !USED()
   RETURN .F.
ENDIF

***

ArcTmp2 = "X58CPCOA.DBF"  && Comprobantes de Pago
IF !FILE(ArcTmp2)
    SELE 0
    CREATE TABLE &ArcTmp2. (x58nroreg n(06), x58ident   c(15)  , x58periodo c(06),;
                            x58fecha  c(08), x58tipo    c(02)  , x58serie   c(04),;
                            x58numero c(20), x58base    n(15,2), x58igv     n(15,2),;
                            x58codigo c(03), x58flagmon c(01)  , x58norden  c(06),;
                            x58estado c(01) )
    USE &ArcTmp2. EXCL
    IF !USED()
       RETURN .F.
    ENDIF
    INDEX ON X58PERIODO+STR(X58NROREG,6,0) TAG X5801
    USE
ENDIF

sele 0
use &ArcTmp2. ALIAS X58 EXCL
INDEX ON X58PERIODO+STR(X58NROREG,6,0) TAG X5801
IF !USED()
   RETURN .F.
ENDIF

***

ArcTmp3 = "x78cpcoa.DBF"  && Polizas de Importaci¢n
IF !FILE(ArcTmp3)
   SELE 0
   CREATE TABLE &ArcTmp3. ( x78nroreg  n(06),;
                            x78periodo c(06),;
                            x78f_pago  c(08),;
                            x78Tipo    c(02),;
                            x78numpol  c(20),;
                            x78numfrac c(06),;
                            x78numcuo  n(02,0),;
                            x78m_impor n(15,2),;
                            x78advalor n(15,2),;
                            x78isc     n(15,2),;
                            x78igv     n(14,2),;
                            x78codigo  c(03),;
                            x78norden  c(06),;
                            x78estado  c(01) )
    USE &ArcTmp3. EXCL
    IF !USED()
       RETURN .F.
    ENDIF
    INDEX ON X78PERIODO+STR(X78NROREG,6,0) TAG X7801
    USE

ENDIF
sele 0
use &ArcTmp3. ORDER X7801 ALIAS X78 EXCL
IF !USED()
   RETURN .F.
ENDIF

*****

ArcTmp4 = "X61COAPR.DBF" &&& REGISTRO DE PROVEEDORES
IF !FILE(ArcTmp4)
   SELE 0
   CREATE TABLE &ArcTmp4. ( x61nroreg n(06), x61nroruc c(08),;
                            x61cinter c(15), x61nombre c(40),;
                            x61estado c(01) )
   USE &ArcTmp4. EXCL
   IF !USED()
      RETURN .F.
   ENDIF
   index on x61cinter+x61nroruc tag x6101
   index on x61nroruc           tag x6102 additive
   use
endif

sele 0
use &arctmp4. order x6102 alias x61 excl
if !used()
   return .f.
endif

sele 0
use x79cpcoa alias x79 excl
index on x58periodo+str(x58nroreg,6,0) tag x7901
if !used()
   return .f.
endif

return .t.
********************
PROCEDURE Copia_Disk
********************
IF ALRT("Actualizaci¢n de archivos a diskette")
   LinMsg = 20
   XsNomArc = SPACE(8)
   Drive    = "A"
   UltTecla = 0
   DO WHILE !INLIST(UltTecla,Escape,CtrlW)
      @ 16,12 SAY "El nombre de archivo en blanco implica todos los archivos"
      @ 12,18 SAY "Nombre del archivo :" GET XsNomArc
      @ 14,18 SAY "Drive  (A/B/C)     :" GET Drive PICT "@!" VALID DRIVE$"ABC"
      READ
      UltTecla = LASTKEY()
      IF UltTecla = Enter
         UltTecla = CTRLW
      ENDIF
      IF UltTecla = CTRLW
         IF !EMPTY(XsNomArc)
            XsNomArc = TRIM(XsNomArc)
            IF FILE(XsNomArc+".DBF")
               SAVE SCREEN
               GsMsgErr = "Coloque diskette...."
               DO LIB_MERR WITH 99
               Contenido= Drive+":"
               @LInMsg,0
               !COPY &XsNomArc..DBF &Contenido
               @LInMsg,0
               UltTecla = 0
               RESTORE SCREEN
               LOOP
            ELSE
               GsMsgErr = "Archivo no existe"
               DO LIB_MERR WITH 99
               UltTecla = 0
               LOOP
            ENDIF
         ELSE
            SAVE SCREEN
            GsMsgErr = "Coloque diskette...."
            DO LIB_MERR WITH 99
            Contenido= Drive+":"
            @LInMsg,0
            !COPY X68TRCOA.DBF &Contenido
            @LInMsg,0
            !COPY X58CPCOA.DBF &Contenido
            @LInMsg,0
            !COPY X61COAPR.DBF &Contenido
            @LInMsg,0
            !COPY X78POLIM.DBF &Contenido
            @LInMsg,0
            UltTecla = 0
            LOOP
            RESTORE SCREEN
         ENDIF
      ENDIF
   ENDDO
ENDIF
RETURN
********************
FUNCTION ChkCta
parameter _cta

FOR KK = 1 TO NumCta - 1
    IF vCodCta(kk)=_Cta
       RETURN .T.
    ENDIF
ENDFOR
RETURN .F.
********************

