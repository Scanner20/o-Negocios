* Program-ID...: BuildAccessCursor.PRG
* Purpose......: Builds access cursor for group and user based on logon

Temp1 = [X] + RIGHT(SYS(3),4)
a=INKEY(.1)		&& Might be necessary on a fast computer
Temp2 = [X] + RIGHT(SYS(3),4)
CREATE CURSOR Access ( Process Char(60), State L )

 Cmd = [SELECT * FROM GRPPRJOIN WHERE GroupName = '] + GoEntorno.User.GroupName + [' INTO Table ]  + Temp1
&Cmd

 Cmd = [SELECT * FROM USRPRJOIN WHERE UserID    = '] + GoEntorno.User.UserID    + [' INTO Table ] + Temp2
&Cmd

SELECT &Temp1
DELETE FROM &Temp1 WHERE Process IN ( SELECT Process FROM &Temp2 )
SET DELETED OFF

SELECT Access
APPEND FROM &Temp1 FOR NOT DELETED()
APPEND FROM &Temp2

SET DELETED ON 

USE IN &Temp1
USE IN &Temp2
ERASE  &Temp1..DBF
ERASE  &Temp2..DBF

INDEX ON UPPER ( Process ) TAG Process

IF USED ( [GRPPRJOIN] )
   USE IN  GRPPRJOIN
ENDIF
IF USED ( [USRPRJOIN] )
   USE IN  USRPRJOIN
ENDIF

