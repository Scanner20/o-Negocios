*:*****************************************************************************
*:
*: Procedure file: C:\APLICA\CPINDU\CPIPRO_T.PRG
*:         System: Reproceso de ordenes de trabajo (Batchs)
*:         Author: Victor E. Torres Tejada
*:      Copyright (c) 1996-1999, Belcsoft
*:  Last modified: 09/09/1999 at  5:29:02
*:
*:  Procs & Fncts: ABRIRDBFS()
*:               : BORREGANT
*:               : RECALCULO
*:               : REPOR_ERR
*:               : GENSTDREN
*:               : GRBLIN1
*:               : GRBLIN2
*:               : ACMCNFOREST()
*:               : BORRCNFMLA
*:               : ERR_DO_T
*:               : BORR_REG
*:               : VALOR_PT
*:               : ACT_CST_PT
*:               : _PROD()
*:
*:          Calls: F1_BASE()          (function in ?)
*:               : F1_ALERT()         (function in ?)
*:               : ABRIRDBFS()        (function in CPIPRO_T.PRG)
*:               : F1MSGERR.PRG
*:               : CPIPRO_T.SPR
*:               : BORREGANT          (procedure in CPIPRO_T.PRG)
*:               : RECALCULO          (procedure in CPIPRO_T.PRG)
*:               : F1_ALARM()         (function in ?)
*:               : REPOR_ERR          (procedure in CPIPRO_T.PRG)
*:
*:      Documented 18:28:26                                FoxDoc version 3.00a
*:*****************************************************************************
*=f1_base(gsnomcia,gsnomsub,"Usuario:"+gsusuario,gsperiodo)
PUBLIC arctmp,ulttecla,m.control0,m.solorep,m.procesa_ot,m.gen_balance,lsfch1,;
m.fch1,m.fch2,m.codprod,m.codproh,m.codmatd,m.codmath,aCodPro,aCodFam,aCodLin
arctmp   = pathuser+SYS(3)
ulttecla = 0
m.Control0=1
m.solorep     = .F.
m.Procesa_Ot  = .t.
m.gen_balance = .F.
**------------------**
DO FORM cpi_CPIPROCE
**------------------**
*IF lastkey() = k_esc OR M.CONTROL0=2
*    RETURN
*ENDIF
*lsfch1 = "01/"+TRAN(_mes,"@L ##")+"/"+SUBSTR(TRAN(_ano,"9999"),3)
*m.fch1 = CTOD(lsfch1)
*m.fch2 = gdfecha
*STORE [] TO m.codprod,m.codproh,m.codmatd,m.codmath
*DIMENSION aCodPro(10),aCodFam(10),aCodLin(10)
*IF !abrirdbfs()
*    DO f1msgerr WITH [Error en apertura de archivos]
*    CLOSE DATA
*    RETURN
*ENDIF
*IF Procesa_Ot OR Gen_Balance
*	DO cpipro_t.spr
*ENDIF
*IF ulttecla # k_esc AND (Procesa_Ot OR Gen_Balance)
*    m.codprod=TRIM(m.codprod)
*    m.codproh=TRIM(m.codproh)+CHR(255)
*    m.codmatd=TRIM(m.codmatd)
*    m.codmath=TRIM(m.codmath)+CHR(255)
*    SELE erro_t
*    zap
*    IF Procesa_Ot
*	    DO borregant
*	    DO recalculo
*   ENDIF
*    IF Gen_Balance
*		Do Act_Cst_Pt    
*	ENDIF
*ENDIF
*IF !EMPTY(WOUTPUT())
*    RELEASE WINDOW (WOUTPUT())
*ENDIF
*=f1_alarm()
*DO repor_err
*CLOSE DATA
*WAIT WINDOW [Procesando terminado.] NOWAIT
RETURN
*******************
*!*****************************************************************************
*!
*!      Procedure: BORREGANT
*!
*!      Called by: CPIPRO_T.PRG                      
*!
*!          Calls: F1_RLOCK()         (function in ?)
*!               : BORR_REG           (procedure in CPIPRO_T.PRG)
*!
*!*****************************************************************************
PROCEDURE borregant
*******************
IF USED([TO_T])
    SELE to_t
    SET ORDER TO TO_T01   && DTOS(FCHDOC)+CODPRD 
    SEEK DTOS(m.fch1)
    IF !FOUND() AND RECNO(0)>0
        GO RECNO(0)
    ENDIF
    SCAN WHILE fchdoc <= m.fch2 FOR codprd>=m.codprod AND codprd<=m.codproh
        IF VAL(clfdiv)>1 AND !EMPTY(m.codprod) AND !EMPTY(m.codproh)
            xnreg_act = RECN()
            xnclfdiv = VAL(clfdiv)
            xscodprd = codprd
            xdfchdoc = fchdoc
            FOR i=1 TO xnclfdiv-1
                xsllave = DTOS(xdfchdoc)+PADR(LEFT(xscodprd,IIF(i=1,3,5)),LEN(to_t.codprd))
                SEEK xsllave
                IF FOUND() AND f1_rlock(0)
                    DO borr_reg
                    UNLOCK
                ENDIF
            ENDFOR
            GO xnreg_act
        ENDIF
        DO borr_reg
    ENDSCAN
ENDIF
*******************
*!*****************************************************************************
*!
*!      Procedure: RECALCULO
*!
*!      Called by: CPIPRO_T.PRG                      
*!
*!          Calls: BORRCNFMLA         (procedure in CPIPRO_T.PRG)
*!               : GENSTDREN          (procedure in CPIPRO_T.PRG)
*!               : VALOR_PT           (procedure in CPIPRO_T.PRG)
*!
*!*****************************************************************************
PROCEDURE recalculo
*******************
STORE 0 TO lfcanfin,lfcanobj,lftotbat,lfvmerma,lfcanfor,lfvformu
cancelar = .F.
m.quepre = 1
m.codprod=TRIM(m.codprod)
m.codproh=TRIM(m.codproh)+CHR(255)

m.codmatd=TRIM(m.codmatd)
m.codmath=TRIM(m.codmath)+CHR(255)
DO borrcnfmla
SELE co_t
SET ORDER TO co_t03
FOR ncod=1 TO ALEN(aCodPro)
	
	LsCodPro=LEFT(aCodPro(nCod),LEN(CATG.CodMat))
	IF LsCodPro = [A02FLXX01]
	*	SET STEP ON 
	ENDIF 
	LsCodEqu=SUBSTR(aCodPro(nCod),50,LEN(CATG.CodMat))
	LsTipMat=SUBSTR(aCodPro(nCod),48,LEN(CATG.TipMat))
	LsDesPro=SUBSTR(aCodPro(nCod),10,35)
    IF LsCodPro<=m.CodProH AND LsCodPro>=m.CodProD
	    SELE co_t
	    SEEK lscodpro+DTOS(m.fch1)
	    IF !FOUND()  AND RECNO(0)>0
	        GO RECNO(0)
	    ENDIF
	    SCAN WHILE fchdoc<=m.fch2 AND codpro=lscodpro AND !cancelar;
	            FOR flgest#[A]
	        
	        n_digfam = galencod(1)&&IIF(Lstipmat=[2],3,5) AMAA16-03-07
	        zstporef = SPACE(LEN(dtra.tporef))
	        =SEEK(PADR(LEFT(codpro,n_digfam),LEN(cdoc.codfam))+LEFT(nrodoc,3),[CDOC])
	        zstporef = PADR(cdoc.tippro,LEN(dtra.tporef))
	        WAIT WINDOW [Procesando :]+lscodpro+[ ]+LsDesPro+[  Fecha :]+DTOC(fchdoc) NOWAIT
	        DO genstdren
	        SELE co_t
	        DO valor_pt
	        UNLOCK
	        cancelar = (INKEY()=k_esc OR cancelar)
	    ENDSCAN
    ENDIF
ENDFOR
*******************
*!*****************************************************************************
*!
*!      Procedure: GENSTDREN
*!
*!      Called by: RECALCULO          (procedure in CPIPRO_T.PRG)
*!
*!          Calls: ERR_DO_T           (procedure in CPIPRO_T.PRG)
*!               : ACMCNFOREST()      (function in CPIPRO_T.PRG)
*!               : GRBLIN1            (procedure in CPIPRO_T.PRG)
*!               : GRBLIN2            (procedure in CPIPRO_T.PRG)
*!               : CPIPAP_T.PRG
*!               : F1_RLOCK()         (function in ?)
*!
*!*****************************************************************************
PROCEDURE genstdren
*******************
** Posicionamos en orden trabajo **
lsnroo_t = nrodoc
lscodprd = codpro
lfcanobj = canobj
lfcanfin = canfin
lffactor = factor
ldfchdoc = fchdoc
ldfchfin = fchfin
lfprod   = SEEK(lscodprd,"CFPRO")
IF lfprod AND cfpro.canobj>0
    wfcanobj = cfpro.canobj*lffactor
    IF ABS(lfcanobj - wfcanobj)>.1
        lfcanobj = wfcanobj
    ENDIF
ENDIF
IF lfcanobj<=0
    lfeficie = 0
ELSE
    lfeficie = ROUND(lfcanfin/lfcanobj*100,2)
ENDIF
*
STORE 0 TO fvform1d01,fvbatc1d01,fvmerm1d01
STORE 0 TO fvform1d02,fvbatc1d02,fvmerm1d02
*
STORE 0 TO fvform2d01,fvbatc2d01,fvmerm2d01
STORE 0 TO fvform2d02,fvbatc2d02,fvmerm2d02
*
STORE 0 TO fvforl1d01,fvbatl1d01,fvmerl1d01
STORE 0 TO fvforl1d02,fvbatl1d02,fvmerl1d02
*
STORE 0 TO fvforl2d01,fvbatl2d01,fvmerl2d01
STORE 0 TO fvforl2d02,fvbatl2d02,fvmerl2d02
*
STORE 0 TO lnitm01,lnitm02,lnnroitm,fvdevol1,fvdevol2,fvdevoll1,fvdevoll2
*

SELE do_t
SEEK lsnroo_t
SCAN WHILE nrodoc=lsnroo_t FOR codmat>=m.codmatd AND codmat<=m.codmath
    lssubalm = subalm
    lscodmat = codmat
    lsnroo_t = nrodoc
    =SEEK(codmat,[CATG])
    lfplisus = catg.puinus
    lfplismn = catg.puinmn
    =SEEK(codpro+subalm+codmat,[DFPRO])
    =SEEK(codpro,[CFPRO])
    ** Valorizaci¢n **
    DO CASE
    CASE m.quepre = 1
        lfpunimn = 0
        lfpunius = 0
        bllave = zstporef+PADR(nrodoc,LEN(dtra.nroref))+codmat+subalm
        IF SEEK(bllave,[DTRA])
            lfcandes = IIF(dtra.factor>0,dtra.candes*dtra.factor,dtra.candes)
            lfvctomn = dtra.impnac
   		    lfvctous = dtra.impusa
            IF lfcandes>0
                lfpunimn = ROUND(lfvctomn/lfcandes,4)
                lfpunius = ROUND(lfvctous/lfcandes,4)
            ELSE
                lfpunimn = 0
                lfpunius = 0
            ENDIF
        ELSE
            IF zstporef#[O_T]
                ***             		SET STEP oN
            ENDIF
            DO err_do_t
        ENDIF
        ** Tomamos el ultimo valor mas proximo a la fecha; si es cero
        IF lfpunimn = 0
            =SEEK(subalm+codmat,[CALM])
            lfvctomn =calm.vinimn
            lfvctous =calm.vinius
            IF calm.stkini>0
                lfpunimn = ROUND(lfvctomn/calm.stkini,4)
                lfpunius = ROUND(lfvctous/calm.stkini,4)
            ELSE
                lfpunimn = 0
                lfpunius = 0
            ENDIF
            SELE dtra
            SET ORDER TO dtra02
            SEEK lssubalm+lscodmat+DTOS(ldfchdoc+1)
            IF !FOUND()
                IF RECNO(0)>0
                    GO RECNO(0)
                    IF DELETED()
                        SKIP
                    ENDIF
                ENDIF
            ENDIF
            SKIP -1
            IF lssubalm+lscodmat=subalm+codmat  AND fchdoc<=ldfchdoc
                lfvctomn = impnac
                lfvctous = impusa
                lfcandes = IIF(dtra.factor>0,dtra.candes*dtra.factor,dtra.candes)
                IF lfcandes>0
                    lfpunimn = ROUND(lfvctomn/lfcandes,4)
                    lfpunius = ROUND(lfvctous/lfcandes,4)
                ELSE
                    lfpunimn = 0
                    lfpunius = 0
                ENDIF
            ENDIF
            SET ORDER TO dtra04
        ENDIF
    CASE m.quepre = 2
        lfpreuni = IIF(m.codmon=1,lfpctomn,lfpctous)
    ENDCASE
    ** Fin ; Valorizaci¢n
    IF !catg.noprom
        lsnivel = [D01]
    ELSE
        lsnivel = [D02]
    ENDIF
    lffacequ = IIF(do_t.facequ>0,do_t.facequ,1)
    IF co_t.canfin<1
        lffacequ=0
    ENDIF
    SELE ro_t
    SEEK lsnroo_t+lsnivel+lscodprd+do_t.codmat
    IF !FOUND()
        APPEND BLANK
        REPLACE nivel   WITH lsnivel
        REPLACE nrodoc  WITH lsnroo_t
        REPLACE codprd  WITH lscodprd
        REPLACE codmat  WITH do_t.codmat
    ENDIF
    REPLACE fchdoc  WITH ldfchdoc
    REPLACE desmat  WITH LEFT(catg.desmat,26)+[ ]+do_t.undpro
    REPLACE cnbatch WITH do_t.cnfmla
    IF EMPTY(cnbatch)
        REPLACE cnbatch WITH do_t.canfor
    ENDIF
    
    REPLACE cnformu WITH IIF(lffactor>0,ROUND(cnbatch/lffactor,4),0)
    REPLACE salfor  WITH do_t.canfor
    REPLACE saladi  WITH do_t.canadi
    REPLACE ingdev  WITH do_t.candev
    REPLACE salrea  WITH salfor+saladi - ingdev
    REPLACE salbpr  WITH ROUND(lfeficie*salrea/100,4)
    REPLACE salbfm  WITH ROUND(lfeficie*cnbatch/100,4)
    *** Para tomar salidas que no afectan el almacen 17/01/97
    IF !EMPTY(do_t.cansal)
        REPLACE salbfm  WITH do_t.cansal
    ENDIF
    ***
    REPLACE facequ  WITH lffacequ
    ** Estos campos los podemos calcular **
    **REPLACE VFORMU  WITH ROUND(LfPUniMn*CnBatch*LfFacEqu,2)
    **REPLACE VBATCH  WITH ROUND(LfPUniMn*SalRea *LfFacEqu,2)
    **REPLACE VMerma  WITH ROUND(LfPUniMn*(SalRea - SalBfm)*LfFacEqu,2)
    ** solo guardamos los precios **
    REPLACE punimn  WITH lfpunimn
    REPLACE punius  WITH lfpunius
    REPLACE plismn  WITH lfplismn
    REPLACE plisus  WITH lfplisus
    
    **IF vBatch <=0
    **   REPLACE PorMer  WITH 0
    **ELSE
    **   REPLACE PorMer  WITH ROUND(Vmerma/(VBatch-VMerma)*100,2)
    **ENDIF
    DO CASE
    CASE nivel = [D01]
        lnitm01 = lnitm01 + 1
        fvform1d01 = fvform1d01 + ROUND(lfpunimn*cnbatch*lffacequ,2)
        fvbatc1d01 = fvbatc1d01 + ROUND(lfpunimn*salrea *lffacequ,2)
        fvmerm1d01 = fvmerm1d01 + ROUND(lfpunimn*(salrea - salbfm)*lffacequ,2)
        *
        fvform2d01 = fvform2d01 + ROUND(lfpunius*cnbatch*lffacequ,2)
        fvbatc2d01 = fvbatc2d01 + ROUND(lfpunius*salrea *lffacequ,2)
        fvmerm2d01 = fvmerm2d01 + ROUND(lfpunius*(salrea - salbfm)*lffacequ,2)
        *
        fvforl1d01 = fvforl1d01 + ROUND(lfplismn*cnbatch*lffacequ,2)
        fvbatl1d01 = fvbatl1d01 + ROUND(lfplismn*salrea *lffacequ,2)
        fvmerl1d01 = fvmerl1d01 + ROUND(lfplismn*(salrea - salbfm)*lffacequ,2)
        *
        fvforl2d01 = fvforl2d01 + ROUND(lfplismn*cnbatch*lffacequ,2)
        fvbatl2d01 = fvbatl2d01 + ROUND(lfplismn*salrea *lffacequ,2)
        fvmerl2d01 = fvmerl2d01 + ROUND(lfplismn*(salrea - salbfm)*lffacequ,2)
        
        lnnroitm = lnitm01
    CASE nivel = [D02]
        lnitm02 = lnitm02 + 1
        fvform1d02 = fvform1d02 + ROUND(lfpunimn*cnbatch*lffacequ,2)
        fvbatc1d02 = fvbatc1d02 + ROUND(lfpunimn*salrea *lffacequ,2)
        fvmerm1d02 = fvmerm1d02 + ROUND(lfpunimn*(salrea - salbfm)*lffacequ,2)
        *
        fvform2d02 = fvform2d02 + ROUND(lfpunius*cnbatch*lffacequ,2)
        fvbatc2d02 = fvbatc2d02 + ROUND(lfpunius*salrea *lffacequ,2)
        fvmerm2d02 = fvmerm2d02 + ROUND(lfpunius*(salrea - salbfm)*lffacequ,2)
        *
        fvforl1d02 = fvforl1d02 + ROUND(lfplismn*cnbatch*lffacequ,2)
        fvbatl1d02 = fvbatl1d02 + ROUND(lfplismn*salrea *lffacequ,2)
        fvmerl1d02 = fvmerl1d02 + ROUND(lfplismn*(salrea - salbfm)*lffacequ,2)
        *
        fvforl2d02 = fvforl2d02 + ROUND(lfplismn*cnbatch*lffacequ,2)
        fvbatl2d02 = fvbatl2d02 + ROUND(lfplismn*salrea *lffacequ,2)
        fvmerl2d02 = fvmerl2d02 + ROUND(lfplismn*(salrea - salbfm)*lffacequ,2)
        lnnroitm = lnitm02
    ENDCASE
    fvdevol1  = fvdevol1  + ROUND(ingdev*punimn,2)
    fvdevol2  = fvdevol2  + ROUND(ingdev*punius,2)
    fvdevoll1 = fvdevoll1 + ROUND(ingdev*plismn,2)
    fvdevoll2 = fvdevoll2 + ROUND(ingdev*plisus,2)
    REPLACE nroitm WITH lnnroitm
    SELE do_t
    DO acmcnforest
ENDSCAN
** totales de insumos que no son envases **
lnnroitm = lnitm01
DO grblin1 WITH [D01],[A],[LS],09,13
DO grblin1 WITH [D01],[B],[]
DO grblin1 WITH [D01],[C],[LS],09,13
** totales de insumos que son envases **
lnnroitm = lnitm02
DO grblin1 WITH [D02],[A],[LD],1
DO grblin1 WITH [D02],[B],[]
DO grblin1 WITH [D02],[C],[LD],09,13
** total   de insumos                 **
lnnroitm = 0
**DO GrbLin1 WITH [D03],[A],[LD],1
DO grblin1 WITH [D03],[B],[]
DO grblin1 WITH [D03],[C],[LD],09,13
** Totales de producci¢n **
lnnroitm = 0
DO grblin1 WITH [P01],[A],[LD],1,3
DO grblin1 WITH [P01],[B],[]
DO grblin1 WITH [P01],[C],[LD],1,3
DO grblin1 WITH [P02],[A],[]
DO grblin2 WITH [P03],[A]
lnnroitm = lnnroitm + 1
DO grblin1 WITH [P04],[A],[LD],1,3
DO grblin1 WITH [P04],[B],[BL]
lnnroitm = 0
DO grblin1 WITH [R01],[A],[]
DO grblin1 WITH [R01],[B],[LS],6,8
DO grblin1 WITH [R02],[A],[]
DO grblin1 WITH [R03],[A],[]
DO grblin1 WITH [R04],[A],[]
DO grblin1 WITH [R05],[A],[]
DO grblin1 WITH [R06],[A],[]

** Acumulamos en archivos de totales de producci¢n **
fcnobjot = lfcanobj
fcnfinot = lfcanfin
fnobatot = lffactor

fvformmn = (fvform1d01 + fvform1d02)
fvbatcmn = (fvbatc1d01 + fvbatc1d02)
fvmermmn = (fvmerm1d01 + fvmerm1d02)

fvformus = (fvform2d01 + fvform2d02)
fvbatcus = (fvbatc2d01 + fvbatc2d02)
fvmermus = (fvmerm2d01 + fvmerm2d02)
*
fvforlmn = (fvforl1d01 + fvforl1d02)
fvbatlmn = (fvbatl1d01 + fvbatl1d02)
fvmerlmn = (fvmerl1d01 + fvmerl1d02)

fvforlus = (fvforl2d01 + fvforl2d02)
fvbatlus = (fvbatl2d01 + fvbatl2d02)
fvmerlus = (fvmerl2d01 + fvmerl2d02)
**
DO cpi_cpipap_t WITH lscodprd,ldfchdoc
**
SELE co_t
=f1_rlock(0)
*REPLACE VFormMn WITH fVformMn
*REPLACE VBatcMn WITH fVBatcMn
*REPLACE VMermMn WITH fVMermMn
*
*REPLACE VFormUs WITH fVFormUs
*REPLACE VBatcUs WITH fVBatcUs
*REPLACE VMermUs WITH fVMermUS
**
*REPLACE VForLMn WITH fVForLMn
*REPLACE VBatLMn WITH fVBatLMn
*REPLACE VMerLMn WITH fVMerLMn
*
*REPLACE VForLUs WITH fVForLUs
*REPLACE VBatLUs WITH fVBatLUs
*REPLACE VMerLUs WITH fVMerLUs
*
** Guardamos tambien los parciales **
REPLACE vform1d01 WITH fvform1d01
REPLACE vform1d02 WITH fvform1d02
REPLACE vbatc1d01 WITH fvbatc1d01
REPLACE vbatc1d02 WITH fvbatc1d02
REPLACE vmerm1d01 WITH fvmerm1d01
REPLACE vmerm1d02 WITH fvmerm1d02

REPLACE vform2d01 WITH fvform2d01
REPLACE vform2d02 WITH fvform2d02
REPLACE vbatc2d01 WITH fvbatc2d01
REPLACE vbatc2d02 WITH fvbatc2d02
REPLACE vmerm2d01 WITH fvmerm2d01
REPLACE vmerm2d02 WITH fvmerm2d02

REPLACE vforl1d01 WITH fvforl1d01
REPLACE vforl1d02 WITH fvforl1d02
REPLACE vbatl1d01 WITH fvbatl1d01
REPLACE vbatl1d02 WITH fvbatl1d02
REPLACE vmerl1d01 WITH fvmerl1d01
REPLACE vmerl1d02 WITH fvmerl1d02

REPLACE vforl2d01 WITH fvforl2d01
REPLACE vforl2d02 WITH fvforl2d02
REPLACE vbatl2d01 WITH fvbatl2d01
REPLACE vbatl2d02 WITH fvbatl2d02
REPLACE vmerl2d01 WITH fvmerl2d01
REPLACE vmerl2d02 WITH fvmerl2d02

REPLACE vdevomn WITH fvdevol1
REPLACE vdevous WITH fvdevol2
REPLACE vdevlmn WITH fvdevoll1
REPLACE vdevlus WITH fvdevoll2
REPLACE canobj  WITH fcnobjot
REPLACE eficie  WITH lfeficie
SELE ro_t
*ZAP
RETURN
*****************
*!*****************************************************************************
*!
*!      Procedure: GRBLIN1
*!
*!      Called by: GENSTDREN          (procedure in CPIPRO_T.PRG)
*!
*!*****************************************************************************
PROCEDURE grblin1
*****************
PARAMETER m.nivel,m.cdmat,m.tipo,m.col1,m.col2
STORE 0 TO colini,colfin
IF PARAMETERS()>3
    colini = m.col1
    colfin = 13
ENDIF
IF PARAMETERS()>4
    colini = m.col1
    colfin = m.col2
ENDIF
lnnroitm = lnnroitm + 1
SELE ro_t
SEEK lsnroo_t+m.nivel+lscodprd+m.cdmat
IF !FOUND()
    APPEND BLANK
    REPLACE nivel  WITH m.nivel
    REPLACE nrodoc WITH lsnroo_t
    REPLACE codprd WITH lscodprd
    REPLACE codmat WITH m.cdmat
ENDIF
REPLACE fchdoc WITH ldfchdoc
REPLACE nroitm WITH lnnroitm
IF m.tipo = [BL]
    RETURN
ENDIF
DO CASE
CASE m.nivel =[D]
    DO CASE
    CASE m.tipo = [L]
        raya = IIF(INLIST(m.tipo,[LS],[RS]),[-],[=])
        IF colini>0
            FOR K = colini TO colfin
                campo1 = [COL]+TRAN(K,[@L ##])
                nlen   = LEN(&campo1.)
                REPLACE  &campo1. WITH REPLI(raya,nlen)
            ENDFOR
        ENDIF
    CASE m.tipo # [L]
        IF m.nivel<[D03]
            *Campo1a= [VForm1]
            *Campo2a= [VBatc1]
            *Campo3a= [VMerm1]
            *Campo1 = [fVForm1]+m.Nivel
            *Campo2 = [fVBatc1]+m.Nivel
            *Campo3 = [fVMerm1]+m.Nivel
            *REPLACE &Campo1a. WITH &Campo1.
            *REPLACE &Campo2a. WITH &Campo2.
            *REPLACE &Campo3a. WITH &Campo3.
            **
            *Campo1a= [VForm2]
            *Campo2a= [VBatc2]
            *Campo3a= [VMerm2]
            *Campo1 = [fVForm2]+m.Nivel
            *Campo2 = [fVBatc2]+m.Nivel
            *Campo3 = [fVMerm2]+m.Nivel
            *REPLACE &Campo1a. WITH &Campo1.
            *REPLACE &Campo2a. WITH &Campo2.
            *REPLACE &Campo3a. WITH &Campo3.
            **
            *Campo1a= [VForL1]
            *Campo2a= [VBatL1]
            *Campo3a= [VMerL1]
            *Campo1 = [fVForL1]+m.Nivel
            *Campo2 = [fVBatL1]+m.Nivel
            *Campo3 = [fVMerL1]+m.Nivel
            *REPLACE &Campo1a. WITH &Campo1.
            *REPLACE &Campo2a. WITH &Campo2.
            *REPLACE &Campo3a. WITH &Campo3.
            **
            *Campo1a= [VForL2]
            *Campo2a= [VBatL2]
            *Campo3a= [VMerL2]
            *Campo1 = [fVForL2]+m.Nivel
            *Campo2 = [fVBatL2]+m.Nivel
            *Campo3 = [fVMerL2]+m.Nivel
            *REPLACE &Campo1a. WITH &Campo1.
            *REPLACE &Campo2a. WITH &Campo2.
            *REPLACE &Campo3a. WITH &Campo3.
            *IF vBatch <=0
            *   REPLACE PorMer  WITH 0
            *ELSE
            *   REPLACE PorMer  WITH ROUND(Vmerma/(VBatch-VMerma)*100,2)
            *ENDIF
        ELSE
            *REPLACE VForm1 WITH fVForm1D01+fVForm1D02
            *REPLACE VBatc1 WITH fVBatc1D01+fVBatc1D02
            *REPLACE VMerm1 WITH fVMerm1D01+fVmerm1D02
            **
            *REPLACE VForm2 WITH fVForm2D01+fVForm2D02
            *REPLACE VBatc2 WITH fVBatc2D01+fVBaTC2D02
            *REPLACE VMerm2 WITH fVMerm2D01+fVmerm2D02
            **
            *REPLACE VForL1 WITH fVForL1D01+fVForL1D02
            *REPLACE VBatL1 WITH fVBatL1D01+fVBaTL1D02
            *REPLACE VMerL1 WITH fVMerL1D01+fVmerL1D02
            **
            *REPLACE VForL2 WITH fVForL2D01+fVForL2D02
            *REPLACE VBatL2 WITH fVBatL2D01+fVBaTL2D02
            *REPLACE VMerL2 WITH fVMerL2D01+fVmerL2D02
            
            *IF vBatch <=0
            *   REPLACE PorMer  WITH 0
            *ELSE
            *   REPLACE PorMer  WITH ROUND(Vmerma/(VBatch-VMerma)*100,2)
            *ENDIF
        ENDIF
    ENDCASE
CASE m.nivel =[P]
    DO CASE
    CASE m.tipo = [L]
        raya = IIF(INLIST(m.tipo,[LS],[RS]),[-],[=])
        IF colini>0
            FOR K = colini TO colfin
                campo1 = [COL]+TRAN(K,[@L ##])
                nlen   = LEN(&campo1.)
                REPLACE  &campo1. WITH REPLI(raya,nlen)
            ENDFOR
        ENDIF
    CASE m.tipo # [L]
        DO CASE
        CASE m.nivel = [P01]
            REPLACE desmat WITH [TOTALES]
            REPLACE col03  WITH [UND]
        CASE m.nivel = [P02]
            REPLACE desmat  WITH [PRODUCCION ESTIMADA   UND]
            REPLACE cnformu WITH INT(cfpro.canobj)
            REPLACE cnbatch WITH INT(co_t.canobj)
        ENDCASE
    ENDCASE
CASE m.nivel =[R]
    DO CASE
    CASE m.tipo = [L]
        raya = IIF(INLIST(m.tipo,[LS],[RS]),[-],[=])
        IF colini>0
            FOR K = colini TO colfin
                campo1 = [COL]+TRAN(K,[@L ##])
                nlen   = LEN(&campo1.)
                REPLACE  &campo1. WITH REPLI(raya,nlen)
            ENDFOR
        ENDIF
    CASE m.tipo # [L]
        DO CASE
        CASE m.nivel = [R01]
            REPLACE desmat WITH [RESUMEN DE VALORIZACION:]
        CASE m.nivel = [R02]
            REPLACE desmat  WITH [PRODUCCION SEGUN FORMULA   ]   && +IIF(m.CodMon=1,[S/.],[US$])
            **REPLACE CnFormu WITH fVformuD01+fVformuD02
            REPLACE col06   WITH [MERMA:]
            **m.VMerma=(fVMermaD01+fVMermaD02)
            **m.VCReal=(fVBatchD01+fVBatchD02)-(fVMermaD01+fVMermaD02)
            **LfPorMer = round(m.VMerma/VCReal*100,2)
            **REPLACE COL07   WITH TRAN(LfPorMer,"999.99")+[%]
            **LfVMerma = fVMermaD01+fVMermaD02
            **REPLACE COL08   WITH IIF(m.CodMon=1,[S/.],[US$])+TRAN(LfVMerma,"99999.99")
        CASE m.nivel = [R03]
            REPLACE desmat  WITH [DEVOLUCION DE INSUMOS      ]   && +IIF(m.CodMon=1,[S/.],[US$])
            **REPLACE CnFormu WITH fVDevoluc
            REPLACE col06   WITH [EFICIENCIA:]
            REPLACE col07   WITH TRAN(lfeficie,"999.99")+[%]
        CASE m.nivel = [R04]
            REPLACE desmat  WITH [PRODUCCION FORMULA NETA    ]   && +IIF(m.CodMon=1,[S/.],[US$])
            **REPLACE CnFormu WITH fVformuD01+fVformuD02-fVDevoluc
            REPLACE col06   WITH REPLI([-],LEN(col06))
            REPLACE col07   WITH REPLI([-],LEN(col07))
            REPLACE col08   WITH REPLI([-],LEN(col08))
        CASE m.nivel = [R05]
            REPLACE desmat  WITH [COSTO PRODUCCION-MAT.PRIMA ]   && +IIF(m.CodMon=1,[S/.],[US$])
            **REPLACE CnFormu WITH fVBatchD01+fVBatchD02
        CASE m.nivel = [R06]
            REPLACE desmat  WITH [MERMA DE PRODUCCION        ]   && +IIF(m.CodMon=1,[S/.],[US$])
            **REPLACE CnFormu WITH fVMermaD01+fVMermaD02
            
            
        ENDCASE
    ENDCASE
ENDCASE
RETURN
*****************
*!*****************************************************************************
*!
*!      Procedure: GRBLIN2
*!
*!      Called by: GENSTDREN          (procedure in CPIPRO_T.PRG)
*!
*!          Calls: ALMNOMBR()         (function in ?)
*!
*!*****************************************************************************
PROCEDURE grblin2
*****************
PARAMETER m.nivel,m.cdmat,m.tipo,m.col1,m.col2
STORE 0 TO colini,colfin
IF PARAMETERS()>3
    colini = m.col1
    colfin = 13
ENDIF
IF PARAMETERS()>4
    colini = m.col1
    colfin = m.col2
ENDIF

DO CASE
CASE m.nivel = [P03]
    STORE 0 TO tfcnformu,tfcnbatch
    SELE po_t
    SEEK lsnroo_t
    SCAN WHILE nrodoc = lsnroo_t
        lnnroitm = lnnroitm + 1
        SELE ro_t
        SEEK lsnroo_t+m.nivel+lscodprd+m.cdmat
        IF !FOUND()
            APPEND BLANK
            REPLACE nivel  WITH m.nivel
            REPLACE nrodoc WITH lsnroo_t
            REPLACE codprd WITH lscodprd
            REPLACE codmat WITH m.cdmat
        ENDIF
        REPLACE nroitm  WITH lnnroitm
        REPLACE fchdoc  WITH ldfchdoc
        REPLACE desmat  WITH almnombr(po_t.subalm)
        SCATTER MEMVAR
        lfcnbatch = po_t.canfin
        IF co_t.factor>0
            lfcnformu = po_t.canfin/co_t.factor
        ELSE
            lfcnformu = 0
        ENDIF
        REPLACE cnformu WITH lfcnformu
        REPLACE cnbatch WITH lfcnbatch
        
        tfcnformu = tfcnformu + cnformu
        tfcnbatch = tfcnbatch + cnbatch
        SELE po_t
    ENDSCAN
    lnnroitm = lnnroitm + 1
    SELE ro_t
    SEEK lsnroo_t+m.nivel+lscodprd+m.cdmat
    IF !FOUND()
        APPEND BLANK
        REPLACE nivel  WITH m.nivel
        REPLACE nrodoc WITH lsnroo_t
        REPLACE codprd WITH lscodprd
        REPLACE codmat WITH m.cdmat
    ENDIF
    REPLACE fchdoc  WITH ldfchdoc
    REPLACE nroitm  WITH lnnroitm
    REPLACE desmat  WITH [PRODUCCION REAL]
    REPLACE cnformu WITH tfcnformu
    REPLACE cnbatch WITH tfcnbatch
    ** Grabamos porcentajes de rendimiento **
    lnnroitm = lnnroitm + 1
    SELE ro_t
    SEEK lsnroo_t+m.nivel+lscodprd+m.cdmat
    IF !FOUND()
        APPEND BLANK
        REPLACE nivel  WITH m.nivel
        REPLACE nrodoc WITH lsnroo_t
        REPLACE codprd WITH lscodprd
        REPLACE codmat WITH m.cdmat
    ENDIF
    REPLACE fchdoc WITH ldfchdoc
    REPLACE nroitm  WITH lnnroitm
    REPLACE desmat  WITH [PORCENTAJE EN BASE A PRODUCIDO %]
    REPLACE cnformu WITH lfeficie
    REPLACE cnbatch WITH lfeficie
ENDCASE
RETURN
******************
*!*****************************************************************************
*!
*!       Function: ABRIRDBFS
*!
*!      Called by: CPIPRO_T.PRG                      
*!
*!          Calls: F1QEH()            (function in ?)
*!
*!           Uses: ALMTDIVF.DBF           Alias: DIVF
*!               : ALMCDOCM.DBF           Alias: CDOC
*!               : ALMCFTRA.DBF           Alias: CFTR
*!               : ALMDTRAN.DBF           Alias: DTRA
*!               : ALMCTRAN.DBF           Alias: CTRA
*!               : ALMCATAL.DBF           Alias: CALM
*!               : ALMCATGE.DBF           Alias: CATG
*!               : CPICFPRO.DBF           Alias: CFPRO
*!               : CPIDFPRO.DBF           Alias: DFPRO
*!               : CPIDO_TB.DBF           Alias: DO_T
*!               : CPICO_TB.DBF           Alias: CO_T
*!               : CPIPO_TB.DBF           Alias: PO_T
*!               : CPIRO_TB.DBF           Alias: RO_T
*!               : CPITO_TB.DBF           Alias: TO_T
*!               : ALMESTCM.DBF           Alias: ESTA
*!               : &ARCTEMP               Alias: CATGX
*!
*!        Indexes: RO_T01                 (tag in CPIRO_TB.CDX)
*!               : RO_T02                 (tag in CPIRO_TB.CDX)
*!               : TO_T01                 (tag in CPITO_TB.CDX)
*!               : TO_T02                 (tag in CPITO_TB.CDX)
*!               : ERRO01                 (tag in CPITO_TB.CDX)
*!               : ERRO02                 (tag in CPITO_TB.CDX)
*!               : CDOC01                 (tag in CPITO_TB.CDX)
*!
*!      CDX files: ALMCDOCM.CDX
*!               : ALMCFTRA.CDX
*!               : ALMDTRAN.CDX
*!               : ALMCTRAN.CDX
*!               : ALMCATAL.CDX
*!               : ALMCATGE.CDX
*!               : CPICFPRO.CDX
*!               : CPIDFPRO.CDX
*!               : CPIDO_TB.CDX
*!               : CPICO_TB.CDX
*!               : CPIPO_TB.CDX
*!               : CPIRO_TB.CDX
*!               : CPITO_TB.CDX
*!
*!*****************************************************************************
FUNCTION abrirdbfs
******************
=f1qeh([ABRE_DBF])
IF !USED([CATG])
    SELE 0
    USE almcatge ORDER catg01 ALIAS catg
    IF !USED()
        CLOSE DATA
        RETURN .F.
    ENDIF
ENDIF
**
SELE 0
USE almcatge ORDER catg01 ALIAS catgx AGAIN
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
**
IF m.gen_balance OR m.Procesa_Ot
	*
	IF !USED([DIVF])
	    SELE 0
	    USE almtdivf ORDER divf01 ALIAS divf
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([CDOC])
	    SELE 0
	    USE almcdocm ORDER cdoc01 ALIAS cdoc
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([CFTR])
	    SELE 0
	    USE almcftra ORDER cftr01 ALIAS cftr
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([DTRA])
	    SELE 0
	    USE almdtran ORDER dtra04 ALIAS dtra
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([CTRA])
	    SELE 0
	    USE almctran ORDER ctra01 ALIAS ctra
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([CALM])
	    SELE 0
	    USE almcatal ORDER cata01 ALIAS calm
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([CFPRO])
	    SELE 0
	    USE cpicfpro ORDER cfpr01 ALIAS cfpro
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*

	IF !USED([DFPRO])
	    SELE 0
	    USE cpidfpro ORDER dfpr01 ALIAS dfpro
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([DO_T])
	    SELE 0
	    USE cpido_tb ORDER do_t01 ALIAS do_t
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([CO_T])
	    SELE 0
	    USE cpico_tb ORDER co_t02 ALIAS co_t
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	IF !USED([PO_T])
	    SELE 0
	    USE cpipo_tb ORDER po_t01 ALIAS po_t
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	ENDIF
	*
	arctmp=pathuser+[CPIRO_TB.DBF]
	IF !FILE("CPIRO_TB.DBF")
	    SELE 0
	    CREATE TABLE cpiro_tb ;
	        (nivel C(3),nrodoc C(8),fchdoc D(8),codprd C(8),codmat C(8),;
	        desmat C(40),glosa C(40),nroitm N(4), cnformu N(14,4),preuni N(14,4),   ;
	        cnbatch N(14,4),factor N(6,2),salfor N(14,4),saladi N(14,4),            ;
	        ingdev N(14,4),salrea N(14,4),salbpr N(14,4),salbfm N(14,4),            ;
	        col01 C(40),col02 C(10),col03 C(10),col04 C(10),col05 C(10),col06 C(10),;
	        col07 C(10),col08 C(11),col09 C(10),col10 C(10),col11 C(10),col12 C(08),;
	        col13 C(8),facequ N(10,4),;
	        punimn N(14,4),punius N(14,4),plismn N(14,4),plisus N(14,4) )
	    
	    USE cpiro_tb ALIAS ro_t EXCL
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	    INDEX ON nrodoc+nivel+codprd+codmat TAG ro_t01
	    INDEX ON DTOS(fchdoc)+codprd+nrodoc+nivel TAG ro_t02
	    COPY STRU TO (arctmp)
	ELSE
	    SELE 0
	    USE cpiro_tb ALIAS ro_t
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	    COPY STRU TO (arctmp)
	ENDIF
	SELE ro_t
	USE (arctmp) EXCLU ALIAS ro_t
	IF !USED()
	    CLOSE DATA
	    RETURN .F.
	ENDIF
	INDEX ON nrodoc+nivel+codprd+codmat TAG ro_t01
	*
	IF !FILE("CPITO_TB.DBF")
	    SELE 0
	    CREATE TABLE cpito_tb ;
	        (clfdiv C(2),fchdoc D(8),codprd C(8),;
	        canobj N(14,4),canfin N(14,4),batobj N(14,4),batpro N(14,4),   ;
	        vform1 N(14,4),vreal1 N(14,4),vmerma1 N(14,4), ;
	        vform2 N(14,4),vreal2 N(14,4),vmerma2 N(14,4), ;
	        vforml1 N(14,4),vreall1 N(14,4),vmermal1 N(14,4), ;
	        vforml2 N(14,4),vreall2 N(14,4),vmermal2 N(14,4)                   )
	    
	    
	    
	    USE cpito_tb ALIAS to_t EXCL
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	    INDEX ON DTOS(fchdoc)+codprd TAG to_t01
	    INDEX ON codprd+DTOS(fchdoc) TAG to_t02
	ELSE
	    SELE 0
	    USE cpito_tb ALIAS to_t EXCL
	    IF !USED()
	        CLOSE DATA
	        RETURN .F.
	    ENDIF
	    SET ORDER TO to_t01
	ENDIF
	*
	SELE 0
	USE almestcm ORDER esta04 ALIAS esta
	IF !USED()
	    CLOSE DATA
	    RETURN .F.
	ENDIF
	*
	arctemp = pathuser+SYS(3)
	m.Len0 = LEN(CATG.CodMat)
	m.Len1 = m.Len0 - GaLenCod(1)
	m.Len2 = m.Len0 - GaLenCod(2)
	m.Len3 = m.Len0 - GaLenCod(3)
	STORE 0 TO zl,zf,zp
	SELE DIVF
	SCAN 
		DO CASE
			CASE ClfDiv=[01]
				zl=zl + 1
				if alen(aCodLin)< zl
		        	dimension aCodLin(zl+5)
		        endif
	            aCodLin(zl) = LEFT(CodFam,GaLenCod(1))+SPACE(m.Len1)+[ ]+PADR(DesFam,35)+[ ]+DIVF.ClfDiv
			CASE ClfDiv=[02]
				zf = zf + 1
				if alen(aCodFam)< zf
		        	dimension aCodFam(zf+5)
		        endif
	            aCodFam(zf) = LEFT(CodFam,GaLenCod(2))+SPACE(m.Len2)+[ ]+PADR(DesFam,35)+[ ]+DIVF.ClfDiv
				SELE CATG
				SEEK DIVF.CodFam
				SCAN WHILE CodMat=DIVF.CodFam
					IF INLIST(CATG.TipMat,[11],[20])
						zp=zp + 1
						if alen(aCodPro)< zp
				        	dimension aCodPro(zp+5)
				        endif
			            aCodPro(zp) = CodMat+[ ]+PADR(DesMat,35)+[ ]+GaClfDiv(03)+TipMat+CodEqu
					ENDIF
				ENDSCAN
				SELE DIVF
		ENDCASE
	ENDSCAN	
	**
	IF zl<=0
		DO F1MsgErr WITH [No se ha podido seleccionar las lineas de productos]
		return .f.
	ELSE
		DIMENSION aCodLin(zl)
	ENDIF
	**
	IF zf<=0
		DO F1MsgErr WITH [No se ha podido seleccionar los productos por Familia]
		return .f.
	ELSE
		DIMENSION aCodFam(zf)
	ENDIF
	**
	IF zp<=0
		DO F1MsgErr WITH [No se ha podido seleccionar los productos terminados]
		return .f.
	ELSE
		DIMENSION aCodPro(zp)
	ENDIF

	**** Capturamos correlativos de produccion
	arc_cdoc=pathuser+SYS(3)
	SELE cdoc
	COPY TO (arc_cdoc) FOR !EMPTY(siglas)
	USE (arc_cdoc) ALIAS cdoc EXCLU
	REPLA ALL codfam WITH codmov FOR EMPTY(codfam)
	INDEX ON codfam+siglas TAG cdoc01
	SET ORDER TO cdoc01
	**
	ArcCsto=pathdef+[\cia]+gscodcia+[\cpicstpt.dbf]
	IF !FILE(ArcCsto)
		SELE 0
		CREATE TABLE (ArcCsto) ( periodo c(6)  ,;
							   CODPRD C(8)   ,;
							   codequ c(8)   ,;
							   codref c(8)   ,;
		                       DESMAT C(40)  ,;
		                       UNDSTK C(3)   ,;
		                       VALO_T N(14,4),;
		                       VALADI N(14,4),;
		                       VALREA N(14,4),;
		                       VALFOR N(14,4),;
		                       VMERMA N(14,4),;
		                       PORMER N(14,4),;
		                       CANOBJ N(14,4),;
		                       CANFIN N(14,4),;
		                       CANOEQ N(14,4),;
		                       CANFEQ N(14,4),;
		                       BATPRO N(14,4),;
		                       UNIREA N(14,4),;
		                       UNIFOR N(14,4),;
		                       UNIMER N(14,4),;
		                       UNIREAEQ N(14,4),;
		                       UNIFOREQ N(14,4),;
		                       UNIMEREQ N(14,4),;
		                       VALO_T2 N(14,4),;
		                       VALADI2 N(14,4),;
		                       VALREA2 N(14,4),;
		                       VALFOR2 N(14,4),;
		                       VMERMA2 N(14,4),;
		                       UNIREA2 N(14,4),;
		                       UNIFOR2 N(14,4),;
		                       UNIMER2 N(14,4),;
		                       UNIREAEQ2 N(14,4),;
		                       UNIFOREQ2 N(14,4),;
		                       UNIMEREQ2 N(14,4) )
		                       


		   USE (ArcCsto) exclu
		   index on periodo+codprd tag csto01
		   INDEX on codprd+periodo TAG csto02
		   INDEX on codequ+periodo TAG csto03
		   index on periodo+codequ TAG CSTO04
		   USE
	ENDIF
	SELE 0
	USE (ArcCsto) ALIAS CSTO exclu
	IF !USED()
		CLOSE DATA
		RETURN
	ENDIF
    index on periodo+codprd tag csto01
	INDEX on codprd+periodo TAG csto02
	INDEX on codequ+periodo TAG csto03
	index on periodo+codequ TAG CSTO04
	set order to CSTO01
ENDIF	
**
IF m.Gen_Balance
	Arc_Dbf=[\base\cia]+gscodcia+[\C]+STR(_ANO,4,0)+[\cbdacmct.dbf]
	SELE 0
	USE (Arc_Dbf) ORDER ACCT01 ALIAS ACCT
	IF !USED()
		RETURN .F.
	ENDIF
	*
	Arc_Dbf=[\base\cia]+gscodcia+[\cbdmauxi.dbf]
	SELE 0
	USE (Arc_Dbf) ORDER AUXI01 ALIAS AUXI
	IF !USED()
		RETURN .F.
	ENDIF
	**
	SELE 0
	USE CPICFGCP ORDER CFGC01 ALIAS CFGCP
	IF !USED()
		RETURN .F.
	ENDIF
ENDIF
**
arcerr = [CPIERR]+TRAN(_mes,[@L ##])+[.DBF]
IF !FILE(arcerr)
    SELE do_t
    COPY STRU TO (arcerr)
    SELE 0
    USE (arcerr) EXCLU
    INDEX ON codpro+codmat+nrodoc+subalm TAG erro01
    INDEX ON DTOS(fchdoc)+nrodoc+codpro  TAG erro02
    USE
ELSE
    SELE 0
    USE (arcerr) EXCLU
    INDEX ON codpro+codmat+nrodoc+subalm TAG erro01
    INDEX ON DTOS(fchdoc)+nrodoc+codpro  TAG erro02
    USE
ENDIF
SELE 0
USE (arcerr) ORDER erro01 ALIAS erro_t EXCLU

RETURN .T.
********************
*!*****************************************************************************
*!
*!       Function: ACMCNFOREST
*!
*!      Called by: GENSTDREN          (procedure in CPIPRO_T.PRG)
*!
*!          Calls: GALENCOD()         (function in ?)
*!               : GACLFDIV()         (function in ?)
*!               : F1_RLOCK()         (function in ?)
*!
*!*****************************************************************************
FUNCTION acmcnforest  && Acumulamos cantidad según f_rmula para estad_sticas
********************
PRIVATE lscodpro,lscodmat,lsperiod,lsalias,ndiv
lsalias = ALIAS()
lscodmat = PADR(do_t.codmat,LEN(esta.codmat))
SELE esta
FOR K = 1 TO ALEN(galencod)
    lscodpro = PADR(LEFT(do_t.codpro,galencod(K)),LEN(esta.codpro))
    lsperiod = PADR(LEFT(DTOS(do_t.fchdoc),6),LEN(esta.periodo))
    SEEK gaclfdiv(K)+lscodmat+lscodpro+lsperiod
    IF FOUND() AND f1_rlock(0)
        REPLACE canfor WITH canfor + do_t.cnfmla
        FOR ndiv=1 TO ALEN(gaclfdiv)
            IF clfdiv =gaclfdiv(ndiv)
                REPLACE codequ WITH LEFT(lscodequ,galencod(ndiv))
                UNLOCK
            ENDIF
        ENDFOR
    ENDIF
ENDFOR
SELE (lsalias)
RETURN
********************
*!*****************************************************************************
*!
*!      Procedure: BORRCNFMLA
*!
*!      Called by: RECALCULO          (procedure in CPIPRO_T.PRG)
*!
*!          Calls: F1_RLOCK()         (function in ?)
*!
*!*****************************************************************************
PROCEDURE borrcnfmla   && Borra acumulados de consumos según formúla en estad_sticas
********************
WAIT WINDOW [Borrando acumulados de consumos según f_rmula] NOWAIT
PRIVATE lsperiod,lsalias
lsalias = ALIAS()
lsanomes = LEFT(DTOS(m.fch2),6)
*
IF !EMPTY(m.codprod) AND !EMPTY(m.codproh)
    SELE esta
    SET ORDER TO esta01
    SEEK lsanomes
    SCAN WHILE periodo=lsanomes FOR codpro>=m.codprod AND codpro<=m.codproh AND ;
            codmat>=m.codmatd AND codmat<=m.codmath
        xnreg_act = RECN()
        IF VAL(clfdiv)>1
            xncanfor = canfor
            xnclfdiv = VAL(clfdiv)
            xscodmat = codmat
            xscodpro = codpro
            SELE esta
            SET ORDER TO esta04
            FOR i=1 TO xnclfdiv-1
                xsllave = TRAN(i,[@l 99])+xscodmat+PADR(LEFT(xscodpro,IIF(i=1,3,5)),LEN(esta.codpro))+PADR(lsanomes,LEN(esta.periodo))
                SEEK xsllave
                IF FOUND() AND f1_rlock(0)
                    REPLA canfor WITH canfor - xncanfor
                    UNLOCK
                ENDIF
            ENDFOR
            SELE esta
            SET ORDER TO esta01
            GO xnreg_act
        ENDIF
    ENDSCAN
ENDIF
*
SELE esta
SET ORDER TO esta01
SEEK lsanomes
REPLACE REST canfor WITH 0 WHILE periodo=lsanomes FOR codpro>=m.codprod AND ;
    codpro<=m.codproh AND ;
    codmat>=m.codmatd AND ;
    codmat<=m.codmath

SET ORDER TO esta04
SELE (lsalias)
RETURN
******************
*!*****************************************************************************
*!
*!      Procedure: ERR_DO_T
*!
*!      Called by: GENSTDREN          (procedure in CPIPRO_T.PRG)
*!
*!*****************************************************************************
PROCEDURE err_do_t
******************
PRIVATE xalias
xalias=ALIAS()
SCATTER MEMVAR
SELE erro_t
SEEK do_t.codpro+do_t.codmat+do_t.nrodoc+do_t.subalm
IF !FOUND()
    APPEND BLANK
ENDIF
DO WHILE !RLOCK()
ENDDO
GATHER MEMVAR
SELE (xalias)
RETURN
*******************
*!*****************************************************************************
*!
*!      Procedure: REPOR_ERR
*!
*!      Called by: CPIPRO_T.PRG                      
*!
*!          Calls: F0PRINT.PRG
*!
*!*****************************************************************************
PROCEDURE repor_err
*******************
SELE erro_t
SET ORDER TO erro02
GO TOP
IF EOF()
    IF !m.solorep
        WAIT WINDOW [NO HAY ERRORES REGISTRADOS !!!INCREIBLE!!!] TIMEOUT 5
    ELSE
        WAIT WINDOW [NO SE HA GENERADO ARCHIVO DE ERRORES O NO LOS HAY] TIMEOUT 5
    ENDIF
ELSE
    SET RELA TO codmat INTO catg
    SET RELA TO codpro INTO catgx
    snomrep=[CPICPIER]
    largo     = 66
    iniprn    = [_Prn0+_Prn5a+CHR(Largo)+_Prn5b+_Prn3]
    DO f0print WITH [REPORTS]
ENDIF
RETURN
******************
*!*****************************************************************************
*!
*!      Procedure: BORR_REG
*!
*!      Called by: BORREGANT          (procedure in CPIPRO_T.PRG)
*!
*!*****************************************************************************
PROCEDURE borr_reg
******************
REPLACE canobj   WITH 0
REPLACE canfin   WITH 0
REPLACE canoeq   WITH 0
REPLACE canfeq   WITH 0
REPLACE batobj   WITH 0
REPLACE batpro   WITH 0
REPLACE vform1   WITH 0
REPLACE vform2   WITH 0
REPLACE vreal1   WITH 0
REPLACE vreal2   WITH 0
REPLACE vmerma1  WITH 0
REPLACE vmerma2  WITH 0
REPLACE vforml1  WITH 0
REPLACE vforml2  WITH 0
REPLACE vreall1  WITH 0
REPLACE vreall2  WITH 0
REPLACE vmermal1 WITH 0
REPLACE vmermal2 WITH 0
RETURN
******************
*!*****************************************************************************
*!
*!      Procedure: VALOR_PT
*!
*!      Called by: RECALCULO          (procedure in CPIPRO_T.PRG)
*!
*!          Calls: F1_RLOCK()         (function in ?)
*!               : ALMPCPP1.PRG
*!
*!*****************************************************************************
PROCEDURE valor_pt
******************
PRIVA xnvalmn, xnvalus, xncanfin,ii
STORE 0 TO xnvalmn, xnvalus, xncanfin
xncanfin = co_t.canfin
IF INLIST(co_t.nrodoc,[PB-06001])
    ***    SET STEP ON
ENDIF
SELE dtra
SET ORDER TO dtra04
SEEK zstporef + co_t.nrodoc
SCAN WHILE tporef=zstporef AND nroref=co_t.nrodoc AND !EOF()
    lpro_term=.F.
    IF SEEK(tipmov+codmov,[CFTR])
        IF cftr.porp_t
            lpro_term=.T.
        ENDIF
    ENDIF
    IF lpro_term
        LOOP
    ENDIF
    IF tipmov = [S]
        xnvalmn = xnvalmn + impnac
        xnvalus = xnvalus + impusa
    ELSE
        xnvalmn = xnvalmn - impnac
        xnvalus = xnvalus - impusa
    ENDIF
ENDSCAN
*
SELE po_t
xnreg_act = RECNO()
SEEK co_t.nrodoc
SCAN WHILE nrodoc = co_t.nrodoc AND !EOF()
    =f1_rlock(0)
    REPLA costmn WITH IIF(xncanfin<>0,ROUND(xnvalmn*canfin/xncanfin,2),0)
    REPLA costus WITH IIF(xncanfin<>0,ROUND(xnvalus*canfin/xncanfin,2),0)
    UNLOCK
    xsnroalm = subalm + codp_t
    xsllave  = zstporef+PADR(nrodoc,LEN(dtra.nroref))+codprd+subalm
    SELE dtra
    SEEK xsllave
    m.encontre=(tporef+nroref+codmat+subalm==xsllave)
    IF m.encontre AND subalm+tipmov+codmov+nrodoc==xsnroalm
        =f1_rlock(0)
        IF codmon=1
            REPLA impcto WITH ROUND(po_t.costmn,2)
            IF candes#0
                REPLA preuni WITH ROUND(impcto/candes,4)
            ELSE
                REPLA preuni WITH 0
            ENDIF
        ELSE
            REPLA impcto WITH ROUND(po_t.costus,2)
            IF candes#0
                REPLA preuni WITH ROUND(po_t.costus/candes,2)
            ELSE
                REPLA preuni WITH 0
            ENDIF
        ENDIF
        REPLA codajt WITH [A]
        *DO almpcpp1
        UNLOCK
    ENDIF
    SELE po_t
ENDSCAN
RETURN
********************
*!*****************************************************************************
*!
*!      Procedure: ACT_CST_PT
*!
*!          Calls: F1QEH()            (function in ?)
*!               : ACODPRO()          (function in ?)
*!               : GACLFDIV()         (function in ?)
*!               : _PROD()            (function in CPIPRO_T.PRG)
*!
*!*****************************************************************************
PROCEDURE act_cst_pt
********************
** borrando informacion anterior **
PRIVATE CMP
SELE CSTO
SET ORDER TO CSTO01   && PERIODO+CODPRD 
SEEK GsAnoMes 
SCAN WHILE Periodo=GsAnoMes FOR CODPRD>=m.CodProD AND CodPrd<=m.CodProH	
	FOR CMP=1 TO FCOUNT()
		IF INLIST(TYPE(FIELD(CMP)),[N],[F])
			REPLACE (FIELD(CMP)) WITH 0 
		ENDIF			
	ENDFOR
	RELEASE CMP
ENDSCAN

SELE TO_T
SET ORDER TO TO_T02
SELE esta
SET ORDER TO esta01
PRIVATE K
=f1qeh("PROC_INFO")
FOR m.QueDiv=1 TO ALEN(GaClfDiv)
	STORE 0  TO xfvalfor,xfvaladi,xfvmerma,xfvalo_t
	STORE 0  TO xfcanobj,xfcanfin,xfbatpro,xfvalrea
	XnLonVec=IIF(m.QueDiv=1,ALEN(aCodLin),IIF(m.QueDiv=2,ALEN(aCodFam),ALEN(aCodPro)))
	FOR K = 1 TO XnLonVec
	    m.codpro = IIF(m.QueDiv=1,aCodLin(K),IIF(m.QueDiv=2,aCodFam(K),aCodPro(K)))
	    m.CodPro = LEFT(m.CodPro,LEN(CATG.CodMat))
	    IF m.CodPro <=M.CodProH AND m.CodPro>=m.CodProD	    	
		    m.clfdiv = gaclfdiv(m.quediv)
		    =SEEK(m.codpro,[CATG])
		    =SEEK(m.clfdiv+TRIM(m.codpro),[DIVF])
		    IF m.quediv = 3
		        lsdesmat = catg.desmat
		    ELSE
		        lsdesmat = divf.desfam
		    ENDIF
		    WAIT WINDOW lsdesmat NOWAIT
		    **
		    SELE esta
		    STORE 0 TO lfctopro,LfCtoPro2
		    m.fecha  = m.fch1
		    lsfecha  = PADR(LEFT(DTOS(m.fecha),6),LEN(esta.periodo))
		    SEEK lsfecha+m.codpro
		    DO WHILE periodo+codpro = lsfecha+m.codpro AND !EOF()
		        STORE 0 TO m.caning,m.cansal,m.vcting1,m.vctsal1
		        STORE 0 TO m.cnform,m.vcform,m.vcting2,m.vctsal2
		        WAIT WINDOW [INSUMOS DE:]+lsdesmat+[ ]+DTOC(m.fecha) NOWAIT
		        m.codmat=codmat
		        SCAN WHILE periodo+codpro = lsfecha+m.codpro  AND codmat=m.codmat
		        
		            m.cansal  = m.cansal  + cansal
		            m.caning  = m.caning  + caning
		            m.vctsal1 = m.vctsal1 + vsalmn
		            m.vcting1 = m.vcting1 + vingmn
		            m.vctsal2 = m.vctsal2 + vsalus
		            m.vcting2 = m.vcting2 + vingus
		            
		        ENDSCAN
		        lfctopro  = lfctopro  + m.vctsal1 - m.vcting1
		        lfctopro2 = lfctopro2 + m.vctsal2 - m.vcting2
		        SELE esta
		    ENDDO
		    ** acumulando resumen por producto
		    =_prod(m.codpro)
		    **
		ENDIF		    
	ENDFOR
	RELEASE K
ENDFOR	
DO GRB_GTO_FAB
**************
*!*****************************************************************************
*!
*!       Function: _PROD
*!
*!      Called by: ACT_CST_PT         (procedure in CPIPRO_T.PRG)
*!
*!          Calls: GACLFDIV()         (function in ?)
*!
*!*****************************************************************************
FUNCTION _prod
**************
PARAMETER lscodprd
PRIVATE xalias
 
xalias = ALIAS()
STORE 0 TO lfvalfor,lfcanobj,lfbatobj,lfvalo_t,lfvalfor,lfcanfin,lfvmerma,lfbatpro
STORE 0 TO lfcanoeq,lfcanfeq
STORE 0 TO lfvalfor2,lfvalo_t2,lfvalfor2,lfvmerma2
SELE to_t
SET ORDER TO TO_T02   && CODPRD+DTOS(FCHDOC) 
SEEK lscodprd+DTOS(m.fch1)
IF !FOUND() AND RECNO(0)>0
    GO RECNO(0)
ENDIF
lsclfdiv  = gaclfdiv(m.quediv)
SCAN WHILE codprd = lscodprd AND fchdoc <= m.fch2 FOR clfdiv=lsclfdiv
    lfcanobj = lfcanobj + canobj
    lfcanfin = lfcanfin + canfin
    lfcanoeq = lfcanoeq + canoeq
    lfcanfeq = lfcanfeq + canfeq
    lfbatpro = lfbatpro + batpro
    ** SOLES
    lfvalfor = lfvalfor + vform1
    lfvalo_t = lfvalo_t + vreal1
    lfvmerma = lfvmerma + vmerma1
    ** DOLARES
    lfvalfor2 = lfvalfor2 + vform2
    lfvalo_t2 = lfvalo_t2 + vreal2
    lfvmerma2 = lfvmerma2 + vmerma2
ENDSCAN

IF lfcanobj>0
    lfunifor  = ROUND(lfvalfor /lfcanobj,3)
    lfunifor2 = ROUND(lfvalfor2/lfcanobj,3)
ELSE
    lfunifor  = 0
    lfunifor2 = 0
ENDIF
IF lfcanfin>0
    lfunirea = ROUND(lfvalo_t /lfcanfin,3)
    lfunirea2= ROUND(lfvalo_t2/lfcanfin,3)
ELSE
    lfunirea  = 0
    lfunirea2 = 0
ENDIF
lfunimer  = ROUND(lfunirea  - lfunifor ,3)
lfunimer2 = ROUND(lfunirea2 - lfunifor2,3)
** Precio Unitario Equivalente **
IF lfcanoeq>0
    lfuniforeq = ROUND(lfvalfor /lfcanoeq,3)
    lfuniforeq2= ROUND(lfvalfor2/lfcanoeq,3)
ELSE
    lfuniforeq = 0
    lfuniforeq2= 0
ENDIF
IF lfcanfeq>0
    lfunireaeq = ROUND(lfvalo_t /lfcanfeq,3)
    lfunireaeq2= ROUND(lfvalo_t2/lfcanfeq,3)
ELSE
    lfunireaeq = 0
    lfunireaeq2= 0
ENDIF
lfunimereq  = ROUND(lfunireaeq  - lfuniforeq,3)
lfunimereq2 = ROUND(lfunireaeq2 - lfuniforeq2,3)
**
*LfVMerma = ROUND(LfUniMer*LfCanFin,2)
lfvaladi  = lfctopro  - lfvalo_t
lfvaladi2 = lfctopro2 - lfvalo_t2

SELE CSTO
SET ORDER TO CSTO01   && PERIODO+CODPRD 
SEEK GsAnoMes+lscodprd
SET STEP ON 
IF !FOUND()
    APPEND BLANK
    =SEEK(lscodprd,[CATG])
    =SEEK(m.clfdiv+TRIM(lscodprd),[DIVF])
    IF m.quediv = 3
        lsdesmat = catg.desmat
    ELSE
        lsdesmat = divf.desfam
    ENDIF
    REPLACE Periodo WITH GsAnoMes
    REPLACE codprd  WITH lscodprd
    REPLACE desmat  WITH lsdesmat
    REPLACE undstk  WITH catg.undstk
ENDIF
REPLACE unifor WITH lfunifor
REPLACE unirea WITH lfunirea
REPLACE unimer WITH lfunimer
REPLACE uniforeq WITH lfuniforeq
REPLACE unireaeq WITH lfunireaeq
REPLACE unimereq WITH lfunimereq
REPLACE canobj WITH lfcanobj
REPLACE canfin WITH lfcanfin
REPLACE canoeq WITH lfcanoeq
REPLACE canfeq WITH lfcanfeq
REPLACE valfor WITH lfvalfor
REPLACE valrea WITH lfctopro
REPLACE valadi WITH lfvaladi
REPLACE valo_t WITH lfvalo_t
REPLACE batpro WITH lfbatpro
REPLACE vmerma WITH lfvmerma
**-----COSTOS OTRA MONEDA-------**
REPLACE valfor2 WITH lfvalfor2
REPLACE valrea2 WITH lfctopro2
REPLACE valadi2 WITH lfvaladi2
REPLACE valo_t2 WITH lfvalo_t2
REPLACE vmerma2 WITH lfvmerma2
** COSTOS UNITARIOS OTRA MONEDA ** 
REPLACE unifor2 WITH lfunifor2
REPLACE unirea2 WITH lfunirea2
REPLACE unimer2 WITH lfunimer2
REPLACE uniforeq2 WITH lfuniforeq2
REPLACE unireaeq2 WITH lfunireaeq2
REPLACE unimereq2 WITH lfunimereq2

lfvalor = lfvalo_t - lfvmerma
IF lfvalor>0
    REPLACE pormer WITH ROUND(lfvmerma/lfvalor*100,2)
ELSE
    REPLACE pormer WITH 0
ENDIF
xfvalfor = xfvalfor + valfor
xfvmerma = xfvmerma + vmerma
xfvaladi = xfvaladi + valadi
xfvalo_t = xfvalo_t + valo_t
xfvalrea = xfvalrea + valrea
xfcanobj = xfcanobj + 0       &&&CanObj
xfcanfin = xfcanfin + 0       &&&CanFin
xfbatpro = xfbatpro + batpro
SELE (xalias)

RETURN
*********************
PROCEDURE GRB_GTO_FAB
*********************
** Acumulamos los Valores Globales Por Periodo+Concepto -> LLave=Periodo+CodPrd
SELE CFGCP

SCAN FOR TIPO=[R]   
	SCATTER MEMVAR MEMO	
	DIMENSION vAcumula(m.N_Var_Acm),vFormula(m.N_Var_Acm),vCmpGrb(m.N_Var_Acm)
	STORE 0 TO vAcumula
	FOR V=1 TO m.N_Var_Acm
		vFormula(v) = EVAL([m.Eval_Form]+TRAN(V,[9]))
		vCmpGrb(v)  = EVAL([m.Grab_Form]+TRAN(V,[9]))
	ENDFOR
	RELEASE V
	**------------------------------**
	m.Alias_EN =TRIM(m.Alias_EN)
	m.Alias_DET=TRIM(m.Alias_DET)
	m.Orden_EN =TRIM(m.Orden_EN)
	m.Orden_DET=TRIM(m.Orden_DET)
	**------------------------------**
	SELE (m.Alias_EN)
	SET ORDER TO (m.Orden_EN)
	DO CASE
		CASE m.E_1=[C]  && Evalua como Variable de cadena
			m.Igual_A_1=PADR(EVAL(m.Igual_A_1),LEN(EVAL(m.Campo_1)))
		CASE m.E_1=[E]  && Evalua como Expresión
			m.Igual_A_1=EVAL(m.Igual_A_1)
	ENDCASE
	**
	DO CASE			
		CASE m.E_2=[C]  && Evalua como Variable de cadena
			m.Igual_A_2=PADR(EVAL(m.Igual_A_2),LEN(EVAL(m.Campo_2)))
		CASE m.E_2=[E]  && Evalua como Expresión
			m.Igual_A_2=EVAL(m.Igual_A_2)
	ENDCASE
	**
	IF !EMPTY(m.Alias_DET)

		SELE (m.Alias_DET)
		SET ORDER TO (m.Orden_DET)
		DO CASE
			CASE m.E_1D=[C]  && Evalua como Variable de cadena
				m.Igual_A_1D=PADR(EVAL(m.Igual_A_1D),LEN(EVAL(m.Campo_1D)))
			CASE m.E_1D=[E]  && Evalua como Expresión
				m.Igual_A_1D=EVAL(m.Igual_A_1D)
		ENDCASE
		**
		DO CASE				
			CASE m.E_2D=[C]  && Evalua como Variable de cadena
				m.Igual_A_2D=PADR(EVAL(m.Igual_A_2D),LEN(EVAL(m.Campo_2D)))
			CASE m.E_2D=[E]  && Evalua como Expresión
				m.Igual_A_2D=EVAL(m.Igual_A_2D)
		ENDCASE
	ENDIF
	*---------------- Variables derivadas ---------------------*
	*** Encabezado ***
	m.Clave   = m.Campo_1+IIF(EMPTY(m.Campo_2),[],[+]+m.Campo_2)
	m.EvaKey  = m.Igual_A_1+IIF(EMPTY(m.Igual_A_2),[],m.Igual_A_2)
	m.EvaFor  = IIF(EMPTY(CFGCP.E_FOR),[.T.],CFGCP.E_FOR)
	*** Detalle   ***
	m.ClaveD  = m.Campo_1D+IIF(EMPTY(m.Campo_2D),[],[+]+m.Campo_2D)
	m.EvaKeyD = m.Igual_A_1D+IIF(EMPTY(m.Igual_A_2D),[],m.Igual_A_2D)
	m.EvaForD = IIF(EMPTY(CFGCP.E_FOR_D),[.T.],CFGCP.E_FOR_D)
	*----------------------------------------------------------*
	DO CASE
		CASE !EMPTY(m.Alias_DET)
			SELE (m.Alias_EN)
			SEEK m.EvaKey
			SCAN WHILE EVAL(m.Clave)= m.EvaKey FOR EVAL(m.EvaFor)
				SELE (m.Alias_DET)
				SEEK m.EvaKeyD
				SCAN WHILE EVAL(m.ClaveD)= m.EvaKeyD FOR EVAL(m.EvaForD)
					FOR V=1 TO m.N_Var_Acm
						vAcumula(V) = vAcumula(V)  + EVAL(vFormula(v))
					ENDFOR
					RELEASE V
				ENDSCAN
				SELE (m.Alias_EN)						
			ENDSCAN
		CASE !EMPTY(m.Alias_EN)
			SELE (m.Alias_EN)
			SEEK m.EvaKey
			SCAN WHILE EVAL(m.Clave)= m.EvaKey FOR EVAL(m.EvaFor)
				FOR V=1 TO m.N_Var_Acm
					vAcumula(V) = vAcumula(V)  + EVAL(vFormula(v))
				ENDFOR
				RELEASE V
			ENDSCAN
	ENDCASE			
	*--------------- Grabando Resumen por concepto -------------*
	SELE CSTO	
	SEEK GSAnoMes+m.Nom_Cmp
	IF !FOUND()
		APPEND BLANK
		REPLACE Periodo WITH GsAnoMes
		REPLACE CodPrd  WITH m.Nom_Cmp	
	ENDIF
	FOR V=1 TO m.N_Var_Acm
		REPLACE (vCmpGrb(v)) WITH vAcumula(V)
	ENDFOR	
	RELEASE V
	**----------------------------------------------------------*
	SELE CFGCP
ENDSCAN
*suspen
** Cargamos Costos de fabricacion globales del Mes **
** Estas variables deben de cargarse de la tabla CPICFGCP.DBF
** Distribucion de Costos por Division y Familia; por producto no es posible AUN !!!
PRIVATE K,XnLonVec,J
FOR J=1 TO ALEN(GaClfDiv)
	XnLonVec=IIF(m.QueDiv=1,ALEN(aCodLin),IIF(m.QueDiv=2,ALEN(aCodFam),ALEN(aCodPro)))
	FOR K = 1 TO XnLonVec
	    m.codpro = IIF(m.QueDiv=1,aCodLin(K),IIF(m.QueDiv=2,aCodFam(K),aCodPro(K)))
	    m.CodPro = LEFT(m.CodPro,LEN(CATG.CodMat))
	    IF .T.
	    
	    ENDIF
	    
	ENDFOR
	RELEASE K
ENDFOR
*: EOF: CPIPRO_T.PRG
