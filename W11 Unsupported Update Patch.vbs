
Rem >> CurrentVersion << 
title = "W-O-P W11 Unsupported Update Patch "
revision = "v.1.2 (Beta1) " 
version = title & revision
 
Rem >> Get Rights <<
Set objShell = WScript.CreateObject("WScript.Shell") 
Set WSHShell = WScript.CreateObject("WScript.Shell") 
 
On Error Resume Next  
Sub RunAsAdmin
If CreateObject("WScript.Shell").Run("%ComSpec% /C NET FILE", 0, True) <> 0 Then
ArgsList = ""
For i = 1 To WScript.Arguments.Count
ArgsList = ArgsList & """ """ & WScript.Arguments(i - 1)
Next
CreateObject("Shell.Application").ShellExecute WScript.FullName, """" & WScript.ScriptFullName & ArgsList & """", , "runas", 5
WScript.Quit
End If
End Sub 
RunAsAdmin

Rem >> AbortMessage <<
sub AbortMessage () 
Err.Clear 
On Error Resume Next 
MsgBox "Nothing was Changed... " ,vbSystemModal+vbExclamation, Version 
Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 

sub DisableUpdateHack () 
Err.Clear 
On Error Resume Next 
DARKSIDE = MsgBox ("Do You want to Disable Upgrades With Unsupported TPM Or CPU ?", vbSystemModal + vbOKCancel, Version) 
If DARKSIDE <> vbOK then AbortMessage: WScript.quit 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup\AllowUpgradesWithUnsupportedTPMOrCPU"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassCPUCheck"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassDiskCheck"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassRAMCheck"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassSecureBootCheck"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassStorageCheck"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassTPMCheck"
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC\UpgradeEligibility"
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\SV1", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\SV2", 1, "REG_DWORD" 
Err.Clear 
On Error Resume Next  
WshShell.Run "gpupdate /force", 1, True 
Err.Clear 
On Error Resume Next 
Disabled = MsgBox ("Unsupported Update Patch is DISABLED... " _ 
& vbNewLine & vbNewLine & "Visit our official Project-Group: " _ 
& vbNewLine & "https://www.facebook.com/groups/WindowsOptimizer " _ 
& vbNewLine & vbNewLine & "Visit our official GitHub-Project: " _ 
& vbNewLine & "https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER " ,vbSystemModal+vbExclamation, Version) 
Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 

sub EnableUpdateHack () 
Err.Clear 
On Error Resume Next 
LIGHTSIDE = MsgBox ("Do You want to Enable Upgrades With Unsupported TPM Or CPU ? ", vbSystemModal + vbOKCancel, Version) 
If LIGHTSIDE <> vbOK then AbortMessage: WScript.quit 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup\AllowUpgradesWithUnsupportedTPMOrCPU", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassCPUCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassDiskCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassRAMCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassSecureBootCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassStorageCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassTPMCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC\UpgradeEligibility", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\SV1", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\SV2", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next  
WshShell.Run "gpupdate /force", 1, True 
Err.Clear 
On Error Resume Next 
Enabled = MsgBox ("Unsupported Update Patch is ENABLED... " _ 
& vbNewLine & vbNewLine & "Visit our official Project-Group: " _ 
& vbNewLine & "https://www.facebook.com/groups/WindowsOptimizer " _ 
& vbNewLine & vbNewLine & "Visit our official GitHub-Project: " _ 
& vbNewLine & "https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER " ,vbSystemModal+vbExclamation, Version) 
Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 
 
Err.Clear 
On Error Resume Next 
Key1 = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup\AllowUpgradesWithUnsupportedTPMOrCPU") 
Key2 = WSHShell.RegRead ("HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC\UpgradeEligibility") 
Err.Clear 
On Error Resume Next 
If Key1 <> 1 or Key2 <> 1 then EnableUpdateHack
If Key1 = 1 and Key2 = 1 then DisableUpdateHack
Err.Clear 

Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit
 
 
rem 	******************************************************************* 
rem 	* W-O-P WINDOWS-OPTIMIZER-PROJECT 				  * 
rem 	* -written by 							  * 
rem 	* René Bengsch							  * 
rem 	* info/contact @ 						  * 
rem 	* https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER  * 
rem 	* facebook.com/groups/WindowsOptimizer				  * 
rem 	* e-m@il: hammanit@web.de 	 				  * 
rem 	******************************************************************* 
 
