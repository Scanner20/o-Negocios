* Create a new folder in C:\Program Files and create an INI file in it.
* Although it appears to succeed, it's actually written to:
* C:\Users\<username>\AppData\Local\VirtualStore\Program Files\VFP Vista

local lnINI, ;
	lcValue
if not directory('C:\Program Files\VFP Vista')
	md 'C:\Program Files\VFP Vista'
endif not directory('C:\Program Files\VFP Vista')
text to lcINI noshow
[SomeSection]
SomeKey=SomeValue
endtext
strtofile(lcINI, 'C:\Program Files\VFP Vista\MyApp.INI')
wait window file('C:\Program Files\VFP Vista\MyApp.INI')

* Let's try writing to HKEY_LOCAL_MACHINE in the Registry. It looks like it
* works, but try to find it using RegEdit; it'll be in
* HKEY_CLASSES_ROOT\VirtualStore\Machine instead.

#DEFINE HKEY_CURRENT_USER           -2147483647  && BITSET(0,31)+1
#DEFINE HKEY_LOCAL_MACHINE          -2147483646  && BITSET(0,31)+2
loRegistry = newobject('Registry', home() + 'FFC\Registry.vcx')
loRegistry.SetRegKey('TestKey', 'TestValue', 'Software\VFP Vista', ;
	HKEY_LOCAL_MACHINE, .T.)
loRegistry.GetRegKey('TestKey', @lcValue, 'Software\VFP Vista', ;
	HKEY_LOCAL_MACHINE)
wait window lcValue

* Now let's put the file where it really should go: C:\ProgramData for global
* read-only data, C:\Users\Public for global read-write data, and
* C:\Users\<username>\AppData\Roaming for local data.

lcPath = addbs(SpecialFolders('CommonAppData')) + 'VFP Vista'
if not directory(lcPath)
	md (lcPath)
endif not directory(lcPath)
lcFile = forcepath('MyApp.INI', lcPath)
strtofile(lcINI, lcFile)

lcPath = addbs(getenv('PUBLIC')) + 'VFP Vista'
if not directory(lcPath)
	md (lcPath)
endif not directory(lcPath)
lcFile = forcepath('MyApp.INI', lcPath)
strtofile(lcINI, lcFile)

lcPath = addbs(SpecialFolders('AppData')) + 'VFP Vista'
if not directory(lcPath)
	md (lcPath)
endif not directory(lcPath)
lcFile = forcepath('MyApp.INI', lcPath)
strtofile(lcINI, lcFile)
