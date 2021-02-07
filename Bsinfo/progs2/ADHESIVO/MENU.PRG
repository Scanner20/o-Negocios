CLEAR
SET SYSMENU SAVE
SET SYSMENU TO
DEFINE MENU ventas  BAR AT LINE 1

DEFINE PAD maes     OF ventas PROMPT 'Clientes'
DEFINE PAD pedi     OF ventas PROMPT 'Pedidos'
DEFINE PAD fact     OF ventas PROMPT 'Facturaci¢n'
DEFINE PAD repo     OF ventas PROMPT 'Reportes'
DEFINE PAD esta     OF ventas PROMPT 'Estad¡sticas'
DEFINE PAD mant     OF ventas PROMPT 'Mantenimiento'
DEFINE PAD util     OF ventas PROMPT 'Utilitarios'

ON PAD maes         OF ventas ACTIVATE POPUP mmaes
ON PAD pedi         OF ventas ACTIVATE POPUP mpedi
ON PAD fact         OF ventas ACTIVATE POPUP mfact
ON PAD repo         OF ventas ACTIVATE POPUP mrepo
ON PAD esta         OF ventas ACTIVATE POPUP mesta
ON PAD mant         OF ventas ACTIVATE POPUP mmant
ON PAD util         OF ventas ACTIVATE POPUP mutil

DEFINE POPUP mmaes MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF conversion PROMPT 'Ar\<ea' ;
DEFINE BAR 2 OF conversion PROMPT '\<Length' ;
DEFINE BAR 3 OF conversion PROMPT 'Ma\<ss' ;
DEFINE BAR 4 OF conversion PROMPT 'Spee\<d' ;
DEFINE BAR 5 OF conversion PROMPT '\<Temperature' ;
DEFINE BAR 6 OF conversion PROMPT 'T\<ime' ;
DEFINE BAR 7 OF conversion PROMPT 'Volu\<me' ;

ON SELECTION POPUP conversion;
	DO choice IN defimenu WITH PROMPT(), POPUP()

DEFINE POPUP cardinfo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF cardinfo PROMPT '\<View Charges' ;
	KEY ALT+V, ''
DEFINE BAR 2 OF cardinfo PROMPT 'View \<Payments' ;
	KEY ALT+P, ''
DEFINE BAR 3 OF cardinfo PROMPT 'Vie\<w Users' ;
	KEY ALT+W, ''
DEFINE BAR 4 OF cardinfo PROMPT '\-'
DEFINE BAR 5 OF cardinfo PROMPT '\<Charges '

ON SELECTION POPUP cardinfo;
	DO choice IN defimenu WITH PROMPT(), POPUP()

ACTIVATE MENU example

DEACTIVATE MENU example
RELEASE MENU example EXTENDED
SET SYSMENU TO DEFAULT
ON KEY LABEL ESC


