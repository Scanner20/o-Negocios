*==============================================================================
* Program:				WHICHONE.PRG
* Purpose:				Which one of the files throws an error when building?
* Author:				Ted Roche
* Modifications:		Barbara Peisch
* Copyright:			(c) 2002
* Last revision:		08/01/02
*						(Additional comments by Mike Lewis, July 2003)
*==============================================================================
*
* This program attempts to compile all the "metadata" files in a given projet,
* (that is, DBC, form, report, label and class library files). As it does so,
* the name of the file is displayed in a Wait window. If the compilation fails
* for any reason, the Wait window will tell you the name of the file that caused
* the problem. In addition, errors are written to a cursor and displayed in a
* Browse window at the end of the process.

* The program is especially useful for identifying files that cause "Cannot
* update the cursor" errors. These errors typically occur because a file
* is flagged as read-only or is damaged in some way.

* To use the program, first open the project that you want to build. Then run
* the program, for example from the command window (if no project is open when
* you launch the program, you will be prompted to open one). Note that the program
* does not actually build an executable or APP file; it simply compiles the 
* metadata files within the project.

#INCLUDE "FoxPro.H"
LOCAL lcCurDir, lcHomeDir, lcOldOnError, lcLastCompile, llError
lcCurDir = SYS(5)+CURDIR()

IF type('_vfp.ActiveProject.Name') <> 'C'
  MODIFY PROJECT ? nowait
  IF type('_vfp.ActiveProject.Name') <> 'C'
    MESSAGEBOX("You must have a project open!",48,"No project open")
    RETURN 
  ENDIF
ENDIF 

lcOldOnError = ON('Error')

CREATE CURSOR CompProbs (ProgramName C (50), ErrMessage C (100))

USE (_vfp.ActiveProject.Name) AGAIN IN 0 ALIAS theproject NOUPDATE
SELECT theproject
lcHomeDir = ADDBS(ALLTRIM(theproject.HomeDir))
CD (lcHomeDir)
SELECT PADR(ALLTRIM(name),128) as cName, ;
  type as cType;
  FROM theproject ;
  WHERE type in (FILETYPE_DATABASE , ;
  FILETYPE_FORM, ;
  FILETYPE_REPORT, ;
  FILETYPE_LABEL, ;
  FILETYPE_CLASSLIB) ;
  INTO CURSOR filelist 
  		&& modified by M.L, Aug 03. Removed Readwrite clause from this SELECT
  		
SELECT filelist
USE IN theproject
SCAN
  lcLastCompile = cName
  llError = .F.
  ON ERROR llError = .T.

  WAIT WINDOW NOWAIT "Compiling "+cName
  DO case
    CASE cType = FILETYPE_DATABASE
      COMPILE DATABASE (cName)
    CASE cType = FILETYPE_FORM
      COMPILE FORM (cName)
    CASE cType = FILETYPE_REPORT OR cType = FILETYPE_LABEL
      COMPILE REPORT (cName)
    CASE cType = FILETYPE_CLASSLIB
      * Clear the classlibrary from memory, first
      CLEAR CLASSLIB (cName)
      COMPILE CLASSLIB (cName)
    OTHERWISE
      * No action - not compilable
  ENDCASE
  WAIT CLEAR 
  
  ON ERROR &lcOldOnError
  IF llError
    INSERT INTO CompProbs VALUES (lcLastCompile, MESSAGE())
  ENDIF 
ENDSCAN

SELECT CompProbs
IF RECCOUNT() > 0
  ACTIVATE SCREEN 
  BROWSE LAST 
ELSE
  MESSAGEBOX("No problems found during compile",64,"Success!")
ENDIF 

USE IN CompProbs
USE IN filelist
CD (lcCurDir)
