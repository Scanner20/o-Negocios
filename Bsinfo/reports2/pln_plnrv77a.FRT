  h   @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              @ORIENTATION=0
PAPERSIZE=39
PAPERLENGTH=2160
PAPERWIDTH=2150
=0
PAPERSIZE=39
PAPERLENGTH=2160
PAPERWIDTH=2150
DEF      0                         0 0                     DOS         1                                                             NROPER                                                        MS Sans Serif                                                 ..\..\CIA002\PLNMPERS.DBF                                     PERS                                                          PERS12                                                        ..\..\CIA002\PLNDMOVT.DBF                                     DMOV                                                          DMOV01                                                        ..\..\CIA002\PLNTMOV1.DBF                                     TMOV                                                          TMOV01                                                        ..\..\CIA002\PLNMTABL.DBF36        NK                      TABLY                V38        Ng                      TABL01                                                        ..\..\CIA002\PLNBLPG1.DBF                                     BPGO                                                          BPGO01                                                        MS Sans Serif                                                 pers.gra_sg                                                   MS Sans Serif                                                 pers.division                                                 MS Sans Serif                                                 	pers.area                                                     MS Sans Serif                                                 pers.codsec                                                   MS Sans Serif                                                 MS Sans Serif                                                 pers.codsec                                                   MS Sans Serif                                                 	pers.area                                                     MS Sans Serif                                                 pers.division                                                 MS Sans Serif                                                 pers.gra_sg                                                   MS Sans Serif                                                 MS Sans Serif                                                 MS Sans Serif                                                 _PRN7A+GsNomCia+_PRN7B                                        MS Sans Serif                                                 _PAGENO                                                       "####"                                                        MS Sans Serif                                                 "DE"                                                          MS Sans SerifHBEUSA FLGEST F1 MOVPINTA F0PRINT MOVP      MES(VAL(XsNroMes),1) � %�� � ��q �6 T� ��)  Impo      "@I"                                                          MS Sans Serif                                                 "CODIGO"                                                      MS Sans Serif                                                 "APELLIDOS Y NOMBRES"                                         MS Sans Serif                                                 "HORA :"                                                      MS Sans Serif                                                 TIME()                                                        MS Sans Serif                                                 	"SERVID."                                                     MS Sans Serif                                                 "DEL MES DE"                                                  MS Sans Serif                                                 	"PAGINA:"                                                     MS Sans Serif                                                 NROPER                                                        "####"                                                        MS Sans Serif                                                 "FECHA :  "                                                   MS Sans Serif                                                 DATE()                                                        MS Sans Serif                                                 _ano                                                          J                                                             MS Sans Serif                                                 ;IIF(SEEK("27"+GRA_SG,"TABL"),_PRN7A+TABL.NOMBRE+_PRN7B," ")                                                                   B                                                             MS Sans Serif                                                 codper                                                        MS Sans Serif                                                 _PRN7A+"SEDE"+_PRN7B                                          MS Sans Serif                                                 _PRN7A+"DIVISION"+_PRN7B                                      MS Sans Serif                                                 &IIF(AREA=" "," ",_PRN7A+"AREA"+_PRN7B)                        MS Sans Serif                                                 9IIF(SEEK("30"+AREA,"TABL"),_PRN7A+TABL.NOMBRE+_PRN7B," ")                                                                     B                                                             MS Sans Serif                                                 "TOTAL GENERAL --->>>>"                                       MS Sans Serif                                                 .IIF(SEEK("28"+CODSEC,"TABL"),TABL.NOMBRE," ")"                B                                                             MS Sans Serif                                                 "Servidores"                                                  MS Sans Serif                                                 "S/."                                                         MS Sans Serif                                                 "S/."                                                         MS Sans Serif                                                 "Servidores"                                                  MS Sans Serif                                                 JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "###,###.##"                                                  MS Sans Serif                                                 JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "###,###.##"                                                  MS Sans SerifEUSA: T�  ���� F� � T� �� � �      "Total Seccion    >>>> "� G(!� v�!�	 #�� �� T�       MS Sans Serif                                                 "Total Area       >>>>"                                       MS Sans Serif                                                 "Total Division   >>>>"                                       MS Sans Serif                                                 "Servidores"                                                  MS Sans Serif                                                 "Servidores"                                                  MS Sans Serif                                                 "Servidores"                                                  MS Sans Serif                                                 codper                                                        MS Sans Serif                                                 codper                                                        MS Sans Serif                                                 codper                                                        MS Sans Serif                                                 JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "##,###.##"                                                   MS Sans Serif                                                 JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "##,###.##"                                                   MS Sans Serif                                                 JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "##,###.##"                                                   MS Sans Serif                                                  IIF(CODSEC=" ","  ","SECCION-")	                              MS Sans Serif                                                 "CARGO"                                                       MS Sans Serif                                                 "Total Sede       >>>>"                                       MS Sans Serif                                                 =IIF(SEEK("29"+DIVISION,"TABL"),_PRN7A+TABL.NOMBRE+_PRN7B," ")                                                                 B                                                             MS Sans Serif                                                 MS Sans Serif                                                 "---------"                                                   MS Sans Serif                                                 "---------"                                                   MS Sans Serif                                                 "=========="                                                  MS Sans Serif                                                 /_PRN7A+"INGRESO DE HABERES DE EMPLEADOS"+_PRN7B               MS Sans Serif                                                 MS Sans Serif                                                 "FECHA"                                                       MS Sans Serif                                                 	"INGRESO"                                                     MS Sans Serif                                                 "FECHA"                                                       MS Sans Serif                                                 
"ANTERIOR"                                                    MS Sans Serif                                                 "SUELDO"                                                      MS Sans Serif                                                 VAR1                                                          valcal("CA02")                                                0                                                             MS Sans Serif                                                 VAR2                                                          valcal("CA04")                                                0                                                             MS Sans Serif                                                 VAR3                                                          VALCAL("CA05")                                                0                                                             MS Sans Serif                                                 VAR4                                                          VALCAL("CA06")                                                0                                                             MS Sans Serif                                                 VAR5                                                          VALCAL("CA09")                                                0                                                             MS Sans Serif                                                 VAR6                                                          VALCAL("CA03")                                                0                                                             MS Sans Serif                                                 TOTAL                                                         VAR1+VAR2+VAR3+VAR4+VAR5+VAR6                                 0                                                             MS Sans Serif                                                 NROPER                                                        1                                                             0                                                             MS Sans Serif                                                 MS Sans Serif                                                 MS Sans Serif                                                 dataenvironment                                               �Top = 0
Left = 0
Width = 0
Height = 0
AutoOpenTables = .T.
AutoCloseTables = .T.
InitialSelectedAlias = "PERS"
DataSource = .NULL.
Name = "dataenvironment"
                         fPROCEDURE Destroy
*- [CONVERTER] Reset tables for compatibilityTHIS.OpenTablesTHIS.Init
ENDPROC
                        ����    �   �                         d�   %   _       x      p           �  U   
 ��  � �
 ��  � � U  THIS
 OPENTABLES INIT Destroy,     ��1 � � 2                       [       )   �                    0FFF  0  0TFFFFFFF  0  0  0 0      cursor                                                        �Alias = "PERS"
Order = "PERS12"
Database = f:\o-negocios\upaca\data\p0012005.dbc
CursorSource = "plnmpers"
Name = "cursor1"
                                                                                                                             cursor                                                        �Alias = "DMOV"
Order = "DMOV01"
Database = f:\o-negocios\upaca\data\p0012005.dbc
CursorSource = "plndmovt"
Name = "cursor2"
                                                             cursor                                                        �Alias = "TMOV"
Order = "TMOV01"
Database = f:\o-negocios\upaca\data\p0012005.dbc
CursorSource = "plntmov1"
Name = "cursor3"
                                                             cursor                                                        Alias = "TABL"
Order = "TABL01"
Database = f:\o-negocios\upaca\data\cia001.dbc
CursorSource = "plnmtabl"
Name = "cursor4"
                                                               cursor                                                        �Alias = "BPGO"
Order = "BPGO01"
Database = f:\o-negocios\upaca\data\p0012005.dbc
CursorSource = "plnblpg1"
Name = "cursor5"
                                                             0                                                             VAR1+VAR2+VAR3+VAR4+VAR5+VAR6                                 TOTAL                                                         0                                                             VALCAL("CA03")                                                VAR6                                                          0                                                             VALCAL("CA09")                                                VAR5                                                          0                                                             VALCAL("CA06")                                                VAR4                                                          0                                                             VALCAL("CA05")                                                VAR3                                                          0                                                             valcal("CA04")                                                VAR2                                                          0                                                             valcal("CA02")                                                VAR1                                                          "SUELDO"                                                      
"ANTERIOR"                                                    "FECHA"                                                       	"INGRESO"                                                     "FECHA"                                                       /_PRN7A+"INGRESO DE HABERES DE EMPLEADOS"+_PRN7B               "=========="                                                  "---------"                                                   "---------"                                                   B                                                             =IIF(SEEK("29"+DIVISION,"TABL"),_PRN7A+TABL.NOMBRE+_PRN7B," ")                                                                 "Total Sede       >>>>"                                       "CARGO"                                                        IIF(CODSEC=" ","  ","SECCION-")	                              "##,###.##"                                                   JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "##,###.##"                                                   JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "##,###.##"                                                   JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    codper                                                        codper                                                        codper                                                        "Servidores"                                                  "Servidores"                                                  "Servidores"                                                  "Total Division   >>>>"                                       "Total Area       >>>>"                                       "Total Seccion    >>>> "                                      "###,###.##"                                                  JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "###,###.##"                                                  JVALCAL("RA01")+VALCAL("RB04")+VALCAL("RA15")+VALCAL("RA16")+VALCAL("RA17")                                                    "Servidores"                                                  "S/."                                                         "S/."                                                         "Servidores"                                                  B                                                             .IIF(SEEK("28"+CODSEC,"TABL"),TABL.NOMBRE," ")"                "TOTAL GENERAL --->>>>"                                       B                                                             9IIF(SEEK("30"+AREA,"TABL"),_PRN7A+TABL.NOMBRE+_PRN7B," ")                                                                     &IIF(AREA=" "," ",_PRN7A+"AREA"+_PRN7B)                        _PRN7A+"DIVISION"+_PRN7B                                      _PRN7A+"SEDE"+_PRN7B                                          codper                                                        B                                                             ;IIF(SEEK("27"+GRA_SG,"TABL"),_PRN7A+TABL.NOMBRE+_PRN7B," ")                                                                   J                                                             _ano                                                          DATE()                                                        "FECHA :  "                                                   "####"                                                        NROPER                                                        	"PAGINA:"                                                     "DEL MES DE"                                                  	"SERVID."                                                     TIME()                                                        "HORA :"                                                      "APELLIDOS Y NOMBRES"                                         "CODIGO"                                                      "@I"                                                          MES(VAL(XsNroMes),1)                                          "DE"                                                          "####"                                                        _PAGENO                                                       _PRN7A+GsNomCia+_PRN7B                                        pers.codsec                                                   	pers.area                                                     pers.division                                                 pers.gra_sg                                                   BPGO01                                                        BPGO                                                          ..\..\CIA002\PLNBLPG1.DBF                                     TABL01E    N                  OBJCODE    N                TABLUEID   C	   
               TIMESTAMP  N   
             ..\..\CIA002\PLNMTABL.DBF                                     TMOV01                                                        TMOV                                                          ..\..\CIA002\PLNTMOV1.DBF                                     DMOV01                                                        DMOV                                                          ..\..\CIA002\PLNDMOVT.DBF                                     PERS12                                                        PERS                                                          ..\..\CIA002\PLNMPERS.DBF                               