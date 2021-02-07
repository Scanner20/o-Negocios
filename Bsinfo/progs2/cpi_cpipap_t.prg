*:*****************************************************************************
*:
*:        Program: C:\APLICA\CPINDU\CPIPAP_T.PRG
*:         System: Reproceso de ordenes de trabajo (Batchs)
*:         Author: Victor E. Torres Tejada
*:      Copyright (c) 1996-1999, Belcsoft
*:  Last modified: 16/07/1999 at 11:13:06
*:
*:      Called by: GENSTDREN          (procedure in CPIPRO_T.PRG)
*:
*:          Calls: GALENCOD()         (function in ?)
*:               : GACLFDIV()         (function in ?)
*:
*:      Documented 18:28:29                                FoxDoc version 3.00a
*:*****************************************************************************
PARAMETERS ccodpro , dfecha
PRIVATE tnlen1 , tnlen2 , tncont ,xselect

xselect = SELECT()
IF EMPTY(ccodpro)
    ccodpro = REPLI("9",LEN(do_t.codmat))
ENDIF
tnlen1   = LEN(ccodpro)
tnlen2   = LEN(TRIM(ccodpro))
tncont   = tnlen2
TsClfDiv = GaClfDiv(3)
lfundequ = 1
IF SEEK(ccodpro,[CATG])
    lfundequ = catg.facequ &&AMAA 19-03-07 FACEQU x UNDEQU
    IF lfundequ<=0
        lfundequ = 0
    ENDIF
ENDIF
**
lffacreg=1
IF co_t.tipbat>1
    lffacreg=0
ENDIF
**
DO WHILE tncont > 0
    okey = .F.
    FOR zi = 1 TO ALEN(galencod)
        IF galencod(zi)=tncont
            tsclfdiv = gaclfdiv(zi)
            okey = .T.
            EXIT
        ENDIF
    ENDFOR
    IF okey OR tncont = tnLen2 &&tnlen1 tnLen2 x TnLen1 AMAA 19-03-07
        tscodpro = LEFT(ccodpro,tncont)+SPACE(tnlen1-tncont)
        SELECT to_t
        SET ORDER TO TO_T01   && DTOS(FCHDOC)+CODPRD 
        SEEK DTOS(dfecha) + tscodpro     
        IF ! FOUND()
            APPEND BLANK
        ENDIF
        DO WHILE !RLOCK()
        ENDDO
        REPLACE codprd  WITH tscodpro
        REPLACE fchdoc  WITH dfecha
        REPLACE clfdiv  WITH tsclfdiv
        **
        IF tsclfdiv=[01]  && Division
            REPLACE canobj  WITH canobj  + fcnobjot*lfundequ*lffacreg
            REPLACE canfin  WITH canfin  + fcnfinot*lfundequ*lffacreg
            REPLACE canoeq  WITH canoeq  + fcnobjot*lfundequ*lffacreg
            REPLACE canfeq  WITH canfeq  + fcnfinot*lfundequ*lffacreg
        ELSE
            REPLACE canobj  WITH canobj  + fcnobjot*lffacreg
            REPLACE canfin  WITH canfin  + fcnfinot*lffacreg
            REPLACE canoeq  WITH canoeq  + fcnobjot*lfundequ*lffacreg
            REPLACE canfeq  WITH canfeq  + fcnfinot*lfundequ*lffacreg
        ENDIF
        REPLACE batpro  WITH batpro  + fnobatot*lffacreg
        ** Valores en moneda nacional   **
        REPLACE vform1  WITH vform1  + fvformmn
        REPLACE vreal1  WITH vreal1  + fvbatcmn
        REPLACE vmerma1 WITH vmerma1 + fvmermmn
        ** Valores en moneda extranjera **
        REPLACE vform2  WITH vform2  + fvformus
        REPLACE vreal2  WITH vreal2  + fvbatcus
        REPLACE vmerma2 WITH vmerma2 + fvmermus
        UNLOCK
    ENDIF
    tncont = tncont - 1
ENDDO
SELECT (xselect)
RETURN
*: EOF: CPIPAP_T.PRG
