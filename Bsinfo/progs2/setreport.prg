PARAMETERS _ARC_FRX
USE (_ARC_FRX)
SET STEP ON 

BLANK FIELDS TAG,TAG2
REPLACE EXPR WITH STRTRAN(EXPR,"DRIVER","*DRIVER")
REPLACE EXPR WITH STRTRAN(EXPR,"DEVICE","*DEVICE")
REPLACE EXPR WITH STRTRAN(EXPR,"DEVICE","*DEVICE")
REPLACE EXPR WITH STRTRAN(EXPR,"OUTPUT","*OUTPUT")
REPLACE EXPR WITH STRTRAN(EXPR,"DEFAULTSOURCE","*DEFAULTSOURCE")
REPLACE EXPR WITH STRTRAN(EXPR,"PRINTQUALITY","*PRINTQUALITY")
REPLACE EXPR WITH STRTRAN(EXPR,"DUPLEX","*DUPLEX")
REPLACE EXPR WITH STRTRAN(EXPR,"YRESOLUTION","*YRESOLUTION")
REPLACE EXPR WITH STRTRAN(EXPR,"TTOPTION","*TTOPTION")