text to lcPrivileges noshow
SeCreateTokenPrivilege
SeAssignPrimaryTokenPrivilege
SeLockMemoryPrivilege
SeIncreaseQuotaPrivilege
SeUnsolicitedInputPrivilege
eMachineAccountPrivilege
SeTcbPrivilege
SeSecurityPrivilege
SeTakeOwnershipPrivilege
SeLoadDriverPrivilege
SeSystemProfilePrivilege
SeSystemtimePrivilege
SeProfileSingleProcessPrivilege
SeIncreaseBasePriorityPrivilege
SeCreatePagefilePrivilege
SeCreatePermanentPrivilege
SeBackupPrivilege
SeRestorePrivilege
SeShutdownPrivilege
SeDebugPrivilege
SeAuditPrivilege
SeSystemEnvironmentPrivilege
SeChangeNotifyPrivilege
SeRemoteShutdownPrivilege
SeUndockPrivilege
SeSyncAgentPrivilege
SeEnableDelegationPrivilege
SeManageVolumePrivilege
SeImpersonatePrivilege
SeCreateGlobalPrivilege
endtext

lnPrivileges = alines(laPrivileges, lcPrivileges)
lcText       = ''
for lnI = 1 to lnPrivileges
	lcText = lcText + transform(HasPrivilege(laPrivileges[lnI])) + ' ' + ;
		laPrivileges[lnI] + chr(13) + chr(10)
next
strtofile(lcText, 'Privileges.txt')
modify file Privileges.txt nowait
