============================
= Shalom Help Maker v0.6.1 =
============================
       ....................................................
       . Please note: According to the Microsoft Help     .
       . Compiler's help file, the limits are:            .
       . Topics (pages) per help file: No practical limit .
       . [BUT: one user reported a limit of 1,024 pages!] .
       ....................................................

Help compiler:

If you don't have the Microsoft help compiler on your hard disk, you can download it from this site:
http://www.danish-shareware.dk/soft/shelpmbeta/index.html

If you already has the compiler on your disk, then you just need to tell Shalom Help Maker where to find it. 
Check the program options in SHM. You *CAN NOT* make help files without the help compiler! The compiler is made up of these files:
- hcw.exe
- hcrtf.exe
- hwdll.dll
Browse for the compiler folder, select hcw.exe and click the Open button - or hit Enter.

----------------------------------------------------------------------------------------------------------------------------

Installation:

**** NOTE: Be careful NOT to let the snippet files in the new zip file OVERWRITE YOUR OWN, MODIFIED ONES!!! *****

Unzip the files to a new folder and copy the ini file and the snippet files from the old version to the new folder. Let the old snippets files overwrite the 'new' - they're the same as in version 0.5.2. (NOTE: keep the old version and the 'old' shp files until you know that the new one works ok). 
The compiler files can be placed in a separate folder. Just remember to tell Shalom Help Maker where they are (in program options).

Importing help projects (RTF and other files) from other help file making application IS NOT a feature found in Shalom Help Maker, and never will be.

----------------------------------------------------------------------------------------------------------------------------

New in version 0.6.1:

- Added search function to the Insert jump to another page and Insert jump to a target windows: Pressing F3 will find the first/next page header or target name in the list, that contains the hotspot text. 

- Color number 16 wasn't recognized by SHM. Reported by Wolfgang Ehrhardt.

----------------------------------------------------------------------------------------------------------------------------

New in version 0.6.0:

Additions to the help file:

- Added the page: How to get started, step-by-step and a menu item in the Help menu to get to it quickly.
- Added page about Link colors.
- Added notes about NOT combining underline tags and jumps to a page or a target.
- Added a page concerning compile time and file size using GIF files (instead of BMP files).
- Added a page with a description of generated files.
- Added a page with Visual Basic tips. Well, so far there is only one tip, but hand over yours, if you like! Thanks to Mike Wardle.
- Rearranged a few pages and made a couple more headers.

Additions to the application:

- Added Bitmap Information List to the File menu, that gives you a list of all bitmaps and lets you use the information in various ways.
- Added Show Bitmap... and Edit bitmap to the popup menu.
- Added: Now also the log file from a page/front page preview can be displayed.
- Added: Write multiple lines of page titles on page 1 of a new project, select the lines, press Ctrl+P and have the pages made automatically with the page title already entered in the Header text box of each page.
- Added the project option to turn off the default making of page headers (page titles), content headers and targets into K-keywords. Then they wont be listed on the Index tab.
- Added: When saving a project, the active page and line are saved. When opening a project, the formerly active page and line are reselected. Also, the caret will be displayed with an extended width for a few seconds to make it easier to spot.
- Added: When using Save as..., and an existing shp-file with the same name as the one you enter, exists in the folder, you'll be asked if you want to overwrite that file.
- Added: The lists in the windows Insert jump, Insert jump to a target and Make KLink now can be sorted and the sorting is saved and re-applied when showing the window next time.
 - Added: In the Make KLink window you can now use a popup menu to automatically add keywords or targets that contain a word you specify.
- Added two toolbar buttons for setting a bookmark and going to the bookmark. Only one bookmark can exist at a time.
- Added menu item Check Topic IDs... to the File menu. This is useful when reusing pages from other help projects or from a snippet, in which case you might happen to insert a topic ID that points to a nonexistent page.
- Added menu item Copy Project Help File To... to the File menu. Use this menu item to copy the compiled help file to another folder.
- Added menu item Compression Level to the Options menu, since when the vertical toolbar is hidden, so is the compression level drop down list...
- Added (color of) Image codes to the  Pages tab (Items to highlight) of the Program Options. This enables you to determine the color of the bitmap code.
- Added command line switch '/c' to let you compile an shp file from the command line.
- Added (color of) Comments codes to the Pages tab of Program Options, which means you can now determine how to highlight comments.
- Added tooltip pause to the Program Options. You can determine if a tooltip (the yellow strip of text) should be shown immediately, after the normal pause or not at all.
- Added Right (no line breaks) to the Insert Image window.
- Added some minor enhancements to the Keyword Editor.
- Added lines to separate pages and headers in the contents.dat file.
- Added: When applying format codes (<b>, <i>, <color=12b>,<r> etc.) to selected text, the text stay selected, in case you want to add more formatting codes.
- Added two buttons to the top of the vertical toolbar: Go to page 1 and Go to the last page.
- Added information on too long pages (topics) in status bar, when loading files.
- Added a dialog box that gives you the chance to skip loading the latest project, even if you configured SHM (in Program Options) to always load it when starting up.
- Modified the behavior of the Insert Popup Link, Insert Jump To Another Page and the Insert Jump To A Target windows. If you double-click a header in the list and the hotspot text box is empty, the header will be automatically entered as the hotspot text.
- Changed the selection of topic ID's (e.g. SHM_contents0003). Now you just have to left-click in a topic ID (not select it) and SHM will recognize it (and select it) and then add a 'Jump to page xx' to the context menu (when you subsequently right-click the page).
- Changed: When applying the add backslashes tool, the project is no longer marked as modified when it isn't.
- Changed: When double-clicking a word, the selection of it is now kept if you later Shift+Left-click to the right or below the selected word.
- Changed: Removed the bitmaps on the Snippet buttons.
- Changed: Removed: information about file version when loading an shp file (from the status bar).

Bugs fixed:

- Fixed bug: When clicking the Start new project button and then loading a project, using the Recent Projects menu, the program would sometimes freeze.
- Fixed bug: The Check if bitmaps exist feature (File menu) could give strange results when part of some image's code had been changed into hex code. This is now fixed.
- Fixed bug: You could enter 5 digits in the Project options/Front Page/Context number for front page text box, even though only numbers up to 9999 was accepted and used.
- Fixed bug: When browsing fast through the keywords (using the Keyword editor), keywords from one page could be transferred to another page.
- Fixed bug: The Fix dubs feature in the Header Editor now fixes duplicate headers.
- Fixed bug: The page number (first row) in the Header Editor could be manually changed.

Shortcut keys added:

- Press Alt+D to select the Header text box (move the cursor into the text box).
- Press Alt+F1 to toggle activation of editor window and search results (bottom list).
- Press Alt+I to select the Title text box (move the cursor into the text box).
- Press Alt+K to display the 'Keyboard Shortcuts' from this help file.
- Press Alt+M to activate the 'Copy Project Help File To...' from the 'File' menu.
- Press Alt+W to select the Keywords text box (move the cursor into the text box).
- Press F10 to open the popup/context menu of the editor window (normally displayed when right-clicking the page).
- Press Shift+Ctrl+L to select the Compression level list (activate the list).

Mouse shortcuts added:

- Left-click one of the vertical toolbars to display the previous page and right-click to display the next page.

For users of screens with a size of 640 X 480 pixels and small fonts:

- Added: Menu item Hide Top Toolbar in the Options menu.
- Changed: Moved the compression level list to the vertical toolbar, in order to make more toolbar buttons visible on small screens. When the vertical toolbar is hidden, use the Options/Compression Level menu item to select the compression level.
- Changed: The Page Jumper is located farther to the left, in order to enable display of its full width.
- Changed: The width of the help file title box is decreased to allow all toolbar buttons to be displayed.
- Changed: The Align Left/Align Center/Align Right buttons on the second toolbar has been replaced by a text align popup menu (click the remaining align button on the toolbar). This was done to decrease the width of the toolbar.
- Changed: The Bold/Italic/Underline buttons on the second toolbar has been replaced by a text format popup menu (click the remaining Bold button in the toolbar). Also done to decrease the width of the toolbar.
- Changed: I've made various other changes to ensure that you can see and use all the toolbar buttons. Let me know if you still have problems in this regard.

----------------------------------------------------------------------------------------------------------------------------
                                                                                         
     HOW TO UNINSTALL SHALOM HELP MAKER:

     There's no uninstall feature, nor any uninstallation info yet, I'm sorry               
     to say. But if you delete the SHM folder in which SHM resides and removes these        
     keys from the Registry:                                                                
     HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.shp     
     HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\shalomhelp.exe  
     HKEY_CLASSES_ROOT\Applications\shalomhelp.exe                                          
     HKEY_CLASSES_ROOT\shpfile                                                              
     you've uninstalled SHM.                                                                
     Removing these keys from the Registry isn't very important, since they only take up    
     a little room and do no harm. And you - like all others, including me - already        
     have lots of unused keys in your Registry.                                             
                                                                                         
----------------------------------------------------------------------------------------------------------------------------
                                                                                         
Finn Ekberg Christiansen
Finn@Ekberg.com
http://www.danish-shareware.dk/soft/shelpm/

----------------------------------------------------------------------------------------------------------------------------

                                                                                         