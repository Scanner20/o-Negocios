PUSH MENU _MSYSMENU
SET SYSMENU ON
DEFINE PAD _px0106h0q OF _msysmenu PROMPT "\<Sistema"     COLOR SCHEME 3 KEY alt+s,""
DEFINE PAD _px0106h1x OF _msysmenu PROMPT "\<Editar"      COLOR SCHEME 3 KEY alt+E, ""
DEFINE PAD _px0106h1y OF _msysmenu PROMPT "\<Archivar"    COLOR SCHEME 3 KEY alt+A, ""
DEFINE PAD _qau0r8jpa OF _msysmenu PROMPT "\<Window"      COLOR SCHEME 3 KEY alt+W, ""
ON     PAD _px0106h0q OF _msysmenu ACTIVATE POPUP sistema
ON     PAD _px0106h1x OF _msysmenu ACTIVATE POPUP edita
ON     PAD _px0106h1y OF _msysmenu ACTIVATE POPUP archivo
ON     PAD _qau0r8jpa OF _msysmenu ACTIVATE POPUP _mwindow

DEFINE POPUP sistema MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _mst_about OF sistema PROMPT "\<FoxPro Info."
DEFINE BAR _mst_help  OF sistema PROMPT "\<Help..."
DEFINE BAR _mst_macro OF sistema PROMPT "\<Macros"
DEFINE BAR 3          OF sistema PROMPT "\-"
DEFINE BAR _mst_calcu OF sistema PROMPT "\<Calculadora"   KEY f12, "F12"
DEFINE BAR _mst_diary OF sistema PROMPT "Calendario/\<Diario"
DEFINE BAR 4          OF sistema PROMPT "\-"
DEFINE BAR _mst_captr OF sistema PROMPT "Ca\<pturar"


DEFINE POPUP edita  MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _med_undo  OF edita PROMPT "Undo"                   KEY ctrl+u, "^U"
DEFINE BAR _med_redo  OF edita PROMPT "Redo"                   KEY ctrl+R, "^R"
DEFINE BAR _med_sp100 OF edita PROMPT "\-"
DEFINE BAR _med_cut   OF edita PROMPT "Cut"                    KEY ctrl+x, "^X"
DEFINE BAR _med_copy  OF edita PROMPT "Copy"                   KEY ctrl+C, "^C"
DEFINE BAR _med_paste OF edita PROMPT "Paste"                  KEY ctrl+v, "^V"
DEFINE BAR _med_clear OF edita PROMPT "Clear"
DEFINE BAR _med_sp200 OF edita PROMPT "\-"
DEFINE BAR _med_slcta OF edita PROMPT "Select All"			   KEY ctrl+A, "^V"
DEFINE BAR _med_sp300 OF edita PROMPT "\-"
DEFINE BAR _med_goto  OF edita PROMPT "Goto Line..."
DEFINE BAR _med_find  OF edita PROMPT "Find..."                KEY ctrl+F, "^F"
DEFINE BAR _med_finda OF edita PROMPT "Find Again"             KEY ctrl+G, "^G"
DEFINE BAR _med_repl  OF edita PROMPT "Replace and Find Again" KEY ctrl+E, "^E"
DEFINE BAR _med_repla OF edita PROMPT "Replace All"
DEFINE BAR _med_sp400 OF edita PROMPT "\-"
DEFINE BAR _med_pref  OF edita PROMPT "Preferences..."

DEFINE POPUP archivo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _mfi_new   OF archivo PROMPT "\<Nuevo"
DEFINE BAR _mfi_open  OF archivo PROMPT "\<Apertura"
DEFINE BAR _mfi_close OF archivo PROMPT "\<Cerrar"
DEFINE BAR 4          OF archivo PROMPT "\-"
DEFINE BAR _mfi_savas OF archivo PROMPT "\<Grabar"



DEFINE POPUP _mwindow MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _mwi_hide OF _mwindow PROMPT "\<Esconder"
DEFINE BAR _mwi_hidea OF _mwindow PROMPT "\<Esconder Todo"
DEFINE BAR _mwi_showa OF _mwindow PROMPT "\<Mostrar Todo"
DEFINE BAR _mwi_clear OF _mwindow PROMPT "\<Limpiar"
DEFINE BAR _mwi_sp100 OF _mwindow PROMPT "\-"
DEFINE BAR _mwi_move OF _mwindow PROMPT "\<M\<over" ;
   KEY ctrl+f7, "^F7"
DEFINE BAR _mwi_size OF _mwindow PROMPT "\<Tama¤o" ;
   KEY ctrl+f8, "^F8"
DEFINE BAR _mwi_zoom OF _mwindow PROMPT "\<Zoom " ;
   KEY ctrl+f10, "^F10"
DEFINE BAR _mwi_min OF _mwindow PROMPT "Z\<oom " ;
   KEY ctrl+f9, "^F9"
DEFINE BAR _mwi_rotat OF _mwindow PROMPT "\<Permutar" ;
   KEY ctrl+f1, "^F1"
DEFINE BAR _mwi_color OF _mwindow PROMPT "\<Color..."
DEFINE BAR _mwi_sp200 OF _mwindow PROMPT "\-"
DEFINE BAR _mwi_debug OF _mwindow PROMPT "\<Debug"
DEFINE BAR _mwi_trace OF _mwindow PROMPT "\<Trace"
DEFINE BAR _mwi_view OF _mwindow PROMPT "\<View"
