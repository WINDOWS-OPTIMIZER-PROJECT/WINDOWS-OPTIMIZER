 
Rem 	***************************************************************** 
Rem 	* !c3 WIN-OPTIMIZER 					       	* 
Rem 	* Beschleunigt Windows durch Änderungen innerhalb der Registry 	* 
Rem 	* dauerhaft 							*
Rem	***************************************************************** 
 
Rem >> CurrentVersion << 
title = "!c3 WINDOWS-OPTIMIZER " 
revision = "v.3.7.01 (Beta1) " 
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
Err.Clear
 
 
Rem >> AbortMessage <<
sub AbortMessage () 
Err.Clear 
On Error Resume Next 
if Language = "deutsch" then MsgBox "Vorgang abgebrochen... " & vbNewLine _ 
& vbNewLine & winversioncheck &" wurde nicht verändert!!! ",vbSystemModal+vbExclamation, Version 

if Language = "english" then MsgBox "Operation canceled... " & vbNewLine _ 
& vbNewLine & winversioncheck &" was not changed!!! ",vbSystemModal+vbExclamation, Version 

Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 

 
Rem >> WinVersionCheck << 
Err.Clear 
On Error Resume Next  
strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem") 
For Each objOperatingSystem in colOperatingSystems
WinVersionCheck = objOperatingSystem.Caption 
Next

Err.Clear 
On Error Resume Next  
strComputer="."
Set objWMIService=GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItem = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)
Dim objItem
For Each objItem in colItem
WinValue = Left(objItem.Version,3)
next

Err.Clear 
On Error Resume Next 
Const wbemFlagReturnImmediately = &h10 
Const wbemFlagForwardOnly = &h20 
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2") 
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", _ 
wbemFlagReturnImmediately + wbemFlagForwardOnly) 
For Each objItem In colItems 
AddressWidth = objItem.AddressWidth 
Next 

Err.Clear 
On Error Resume Next 
WinVersionCheck = WinVersionCheck & " (" & AddressWidth & "-Bit)" 

Rem >> Language-Check << 
Err.Clear 
On Error Resume Next 
Language = "english" 
lang = WSHShell.RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\MuiCached\MachinePreferredUILanguages") 
Err.Clear 
On Error Resume Next 
If LCase(lang(0)) = "de" then Language = "deutsch" 
If LCase(lang(0)) = "de-de" then Language = "deutsch" 
If LCase(lang(0)) = "" then Language = "english" 
If LCase(lang(0)) = false then Language = "english" 
Err.Clear 
On Error Resume Next 

lang = WSHShell.RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\PreferredUILanguages") 
Err.Clear 
On Error Resume Next 
If LCase(lang(0)) = "de" then Language = "deutsch" 
If LCase(lang(0)) = "de-de" then Language = "deutsch" 
If LCase(lang(0)) = "" then Language = "english" 
If LCase(lang(0)) = false then Language = "english" 
Err.Clear 
On Error Resume Next 

Rem >> auslesen phys. RAM << 
Err.Clear 
On Error Resume Next 
Speicher = 0
strComputer = "." 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2") 
Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalMemoryConfiguration",,48) 
For Each objItem in colItems 
Speicher = Int(objItem.TotalPhysicalMemory/1024) 
next 

Err.Clear 
On Error Resume Next 
If Speicher = 0 then Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _
& strComputer & "\root\cimv2")
Set colComputer = objWMIService.ExecQuery _
("Select * from Win32_ComputerSystem")
For Each objComputer in colComputer 
Speichern = int(objComputer.TotalPhysicalMemory/1024/1000/1000)
Speicher = Speichern*1024
Next 
 
If Speicher = 0 then SpeicherUser
If Speicher = "" then SpeicherUser
If Speicher = false then SpeicherUser 
Sub SpeicherUser ()
Err.Clear 
On Error Resume Next  
if Language = "deutsch" then speicher = Inputbox ("Die Größe des Arbeitsspeichers läßt sich nicht korrekt auslesen!!! " & vbNewLine _ 
& vbNewLine & "Wie viele MB Arbeitsspeicher besitzt dieses System? ", Version, "1024") 

if Language = "english" then speicher = Inputbox ("The size of the Random-Access Memory can not be read correctly !!! " & vbNewLine _ 
& vbNewLine & "How many MB of Memory does this system have? ", Version, "1024") 

If Speicher = "" then AbortMessage: WScript.quit 
If Speicher = 0 then SpeicherUser 
If Speicher = false then SpeicherUser  
end sub 

Rem >> Optimize Your Windowsversion << 
Err.Clear 
On Error Resume Next 
If Language = "deutsch" then Optimize = MsgBox (winversioncheck &" wurde erfolgreich erkannt. " _ 
& vbNewLine & Speicher &" MB RAM wurden für Windows reserviert. " & vbNewLine _ 
& vbNewLine & winversioncheck &" ist Standardmäßig nicht optimal auf " _ 
& vbNewLine & "Performance, max. Systemstabilität und Systemsicherheit " _ 
& vbNewLine & "abgestimmt... " & vbNewLine _ 
& vbNewLine & "Dieses Tool ändert das durch Anpassungen an die verbaute Hardware " _ 
& vbNewLine & "innerhalb der Registry dauerhaft - Benutzung auf eigene Gefahr !!! " & vbNewLine _ 
& vbNewLine & "Dieser Vorgang kann ein paar Minuten dauern. " & vbNewLine _ 
& vbNewLine & winversioncheck &" jetzt optimieren? ", _ 
vbSystemModal + vbOKCancel, Version) 

If Language = "english" then Optimize = MsgBox (winversioncheck &" was successfully recognized. " _ 
& vbNewLine & Speicher &" MB RAM were reserved for Windows. " & vbNewLine _ 
& vbNewLine & winversioncheck &" is not optimal configured for " _ 
& vbNewLine & "Performance, max. System-Stability and System-Security " _ 
& vbNewLine & "by default... " & vbNewLine _ 
& vbNewLine & "This Tool changes this by adapting to the installed Hardware " _ 
& vbNewLine & "within the Registry permanently - Use at your own risk !!! " & vbNewLine _ 
& vbNewLine & "This Process can take a few minutes. " & vbNewLine _ 
& vbNewLine & "Optimize " & winversioncheck &" now? ", _ 
vbSystemModal + vbOKCancel, Version) 

If Optimize <> vbOK then AbortMessage: WScript.quit 
If Optimize = vbOK then SystemOptimizer = "yes" 
 
Rem >> Systemwiederherstellungspunkt erstellen << 
sub SystemRestore ()
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore\SystemRestorePointCreationFrequency", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
strComputer = "."
Set sr = getobject("winmgmts:\\.\root\default:Systemrestore") 
If (sr.createrestorepoint("reset "& Version, 0, 100)) = 0 Then Restorepoint = "1"

If Restorepoint <> "1" and Language = "deutsch" Then _ 
noSysRestorepoint = MsgBox ("Es konnte kein System-Wiederherstellungspunkt " _ 
& vbNewLine & "erstellt werden. " & vbNewLine _ 
& vbNewLine & winversioncheck & " trotzdem jetzt optimieren? ", vbSystemModal+vbExclamation+vbOKCancel, Version) 
If noSysRestorepoint = vbCancel then AbortMessage: WScript.quit 

If Restorepoint <> "1" and Language = "english" Then _ 
noSysRestorepoint = MsgBox ("No System-Restore-Point could be created " & vbNewLine _ 
& vbNewLine & "still optimize " & winversioncheck & " now? ", vbSystemModal+vbExclamation+vbOKCancel, Version) 
If noSysRestorepoint = vbCancel then AbortMessage: WScript.quit 
 
If Restorepoint = "1" and Language = "deutsch" Then _ 
MsgBox "Für den Fall, daß durch den " & title _ 
& vbNewLine & "Probleme entstehen, wurde zur Sicherheit " _ 
& vbNewLine & "vorab ein System-Wiederherstellungspunkt " _ 
& vbNewLine & "erstellt. " & vbNewLine _ 
& vbNewLine & "Aufgelistet als: "& vbTab & "reset "& Version _ 
& vbNewLine & "Zeitpunkt: " & vbTab & Date & " - " & Time ,vbSystemModal, Version 
 
If Restorepoint = "1" and Language = "english" Then _ 
MsgBox "A System-Restore-Point was created by " _
& vbNewLine &  title & " for safety reasons. " & vbNewLine _ 
& vbNewLine & "Listet as: "& vbTab & "reset "& Version _ 
& vbNewLine & "Time: " & vbTab & Date & " - " & Time ,vbSystemModal, Version 
end sub

If Language = "deutsch" then SystemRestorepoint = MsgBox ("Möchten Sie für den Fall, daß " _ 
& vbNewLine & "durch den " & title & " Probleme entstehen " _ 
& vbNewLine & "zur Sicherheit vorab einen " & vbNewLine _ 
& vbNewLine & "System-Wiederherstellungspunkt erstellen? ", _ 
vbSystemModal + vbYesNo, Version) 

If Language = "english" then SystemRestorepoint = MsgBox ("Do You want to create a System-Restore-Point " _ 
& vbNewLine & "for safety reasons first? ", _ 
vbSystemModal + vbYesNo, Version) 

If SystemRestorepoint = vbYes then SystemRestore  
 
Rem >> !c3-NVIDIA-CoolBits 2.0 / NVTweak (Schaltet alle versteckte Optionen von NVIDIA Grafikkartentreibern frei) << 
sub CoolBits () 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\CoolBits", -1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\CinematicPageState", 255,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\DisableApplyColorsAtStartup", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NoMenus", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NoPages", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplAllowForceTVDetection", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplCustomResConfig", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplDisableRefreshRatePage", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplDisableRotateAngles", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableActiveApp", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableAdditionalInfoPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableAGPSettingsPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableClearViewPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableDesktopOverlapPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableFanControl", 3,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableFrameSyncPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableHardwarePage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnablenForcePage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableOverlaySpanControl", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnablePwrMzrOnDesktopMenu", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableRotationColorSettings", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableScreenMenuPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplEnableTroubleshootingPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplExposeWin2kDualView", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplNvThermPage", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplPhysxAuto", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplThermalSettings", 32,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\NvCplTvLocaleAutoDetect", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\OverlayPageState", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\PowermizerPreferences", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\QTwkEnableModeChangeWarning", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak\TwinViewCapsOverride", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\OpenGL\Debug\ShaderObjects", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\System\EnableAGPFW", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\System\EnableAGPSBA", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\System\EnableIrongateSBA", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\System\EnableVIASBA", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\System\TurboQueue", 1,"REG_DWORD" 
end sub 
 
 
Rem >> HD-OPTIMIZER << 
Sub HDOpt () 
Err.Clear 
On Error Resume Next  
intJobNum = "10"
Set objShell = CreateObject("WScript.Shell")
Const HKEY_LOCAL_MACHINE = &H80000002
strComputer = "."
Set objRegistry = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & strComputer & "\root\default:StdRegProv")
strRegRoot = HKEY_LOCAL_MACHINE
strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
If objRegistry.EnumKey(strRegRoot, strKey, arrKeyNames) = 0 Then
If IsNull(arrKeyNames) = False Then
For Each strKeyName In arrKeyNames
If Right(strKey, 1) = "\" Then
strFullPath = strKey & strKeyName
Else
strFullPath = strKey & "\" & strKeyName
End If
objRegistry.SetDWORDValue strRegRoot, strFullPath, "StateFlags" & Right("0000" & intJobNum, 4), 2
Next
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files\StateFlags" & Right("0000" & intJobNum, 4), 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System Restore Point\StateFlags" & Right("0000" & intJobNum, 4), 0,"REG_DWORD" 
ende = Timer 
objShell.Run "CLEANMGR /sageset:" & intJobNum, 1, True
restart = Timer 

Rem >> Dokumente bereinigen << 
Err.Clear 
On Error Resume Next  
daysago = 2 
Set wshShell = WScript.CreateObject("WScript.Shell") 
strRecent = wshShell.SpecialFolders("Recent") 
Set fso = CreateObject("Scripting.FileSystemObject") 
Set ordner = fso.GetFolder(strRecent) 
Set dateien = ordner.Files 
heute = Date() 
For Each datei In dateien 
If datei.DateLastModified < (heute - daysago) Then 
datei.Delete 
End If 
Next 

Err.Clear 
On Error Resume Next  
objShell.Run "CLEANMGR /sagerun:" & intJobNum, 1, True
For Each strKeyName In arrKeyNames
If Right(strKey, 1) = "\" Then
strFullPath = strKey & strKeyName
Else
strFullPath = strKey & "\" & strKeyName
End If 
next 
Err.Clear 
On Error Resume Next 
For Each Process in GetObject("winmgmts:"). _ 
ExecQuery ("select * from Win32_Process where name='cleanmgr.exe'") 
Process.terminate(0) 
Err.Clear 
On Error Resume Next 
objRegistry.DeleteValue strRegRoot, strFullPath, "StateFlags" & Right("0000" & intJobNum, 4) 
Err.Clear 
Next 
End If 
End If 
 
Rem >> Defrag.exe << 
WshShell.Run "dfrgui.exe", 1, false 
Err.Clear 
On Error Resume Next  
strComputer = "." 
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set colDisks = objWMIService.ExecQuery ("Select * from Win32_LogicalDisk Where DriveType = 3") 
For Each objDisk in colDisks 
WshShell.Run "Defrag.exe " & objDisk.DeviceID &  " /f /h /o /u /v", 2, True 
next 
Err.Clear 
On Error Resume Next 
For Each Process in GetObject("winmgmts:"). _ 
ExecQuery ("select * from Win32_Process where name='dfrgui.exe'") 
Process.terminate(0) 
next 
Err.Clear 
End Sub 
 
Rem >> Get Datas <<   
On Error Resume next 
strComputer = "." 
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colDisks = objWMIService.ExecQuery ("Select * from Win32_LogicalDisk Where DriveType = 3")
For Each objDisk in colDisks
If Language = "deutsch" then HD1 = HD1 & vbNewLine & objDisk.DeviceID & vbTab & "FileSystem: " & objDisk.FileSystem & vbNewLine _  
& vbTab & "Exakte physikalische Größe (GB): " & Int(objDisk.Size)/1024/1024/1024 & vbNewLine _ 
& vbTab & "Exakter freier Speicherplatz (GB): " & int(objDisk.FreeSpace)/1024/1024/1024 & vbNewLine 

If Language = "english" then HD1 = HD1 & vbNewLine & objDisk.DeviceID & vbTab & "FileSystem: " & objDisk.FileSystem & vbNewLine _  
& vbTab & "Exact physical Size (GB): " & Int(objDisk.Size)/1024/1024/1024 & vbNewLine _ 
& vbTab & "Exact free Size (GB): " & int(objDisk.FreeSpace)/1024/1024/1024 & vbNewLine 
Next

If Language = "deutsch" then HD = MsgBox ("Möchten Sie im Anschluß zusätzlich an die Anpassung " _ 
& vbNewLine & "durch den " & title & " noch alle Festplatten " _ 
& vbNewLine & "optimieren? " & vbNewLine & vbNewLine & HD1 & vbNewLine _ 
& vbNewLine & "Dieser Vorgang kann ein paar Minuten bis mehrere Stunden dauern. ", _ 
vbSystemModal + vbYesNo, Version) 
If HD = vbYes then HDOptimizer = "yes"  

If Language = "english" then HD = MsgBox ("Do you want to optimize all Harddrives after " _ 
& vbNewLine & "optimizing by " & title & " ? " & vbNewLine & vbNewLine & HD1 & vbNewLine _ 
& vbNewLine & "This Process can take a few minutes to several hours. ", _ 
vbSystemModal + vbYesNo, Version) 
If HD = vbYes then HDOptimizer = "yes"  
 
Rem >> System-Tweaks <<
Sub winOpt () 
Err.Clear 
On Error Resume Next 
Rem >> Registry-Backup << 
WshShell.Run "cmd.exe /c Systeminfo & echo off & echo "& version &" & echo optimizing - please wait....  & echo creating registry-backup: C:\REGISTRY-BACKUP.REG & REGEDIT /E /Y C:\REGISTRY-BACKUP.REG", 3, True 
Err.Clear 
On Error Resume Next 
Rem >> Alle Explorer.exe beenden << 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
For Each Process in GetObject("winmgmts:"). _ 
ExecQuery ("select * from Win32_Process where name='Explorer.exe'") 
Process.terminate(0) 
next 
Err.Clear 
On Error Resume Next 
WshShell.Run "taskkill /f /fi “status eq not responding”", 1, True
Err.Clear 

Rem >> Windows-Update << 
On Error Resume Next 
WshShell.Run "cmd.exe /c net stop bits & net stop wuauserv & net stop defragsvc & RMDIR /S /Q %windir%\SoftwareDistribution -v", 3, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching\DriverUpdateWizardWuSearchEnabled", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoRebootWithLoggedOnUsers", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowAppStoreAutoUpdate\value", 2,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching\SearchOrderConfig", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate\AutoDownload", 4,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971F918-A847-4430-9279-4A52D1EFE18D\RegisteredWithAU", 1,"REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Test\Scan\ForceUnsupportedCPU"
Err.Clear 
On Error Resume Next 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Test\Scan\ForceUnsupportedCPU", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance\MaintenanceDisabled", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\StateVariables\AlwaysAllowMeteredNetwork", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\AllowAutoWindowsUpdateDownloadOverMeteredNetwork", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\AllowMUUpdateService", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\ExcludeWUDriversInQualityUpdate", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\IsContinuousInnovationOptedIn", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\IsExpedited", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\RestartNotificationsAllowed2", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DODownloadMode", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DownloadMode_BackCompat", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings\DownloadMode", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings\DownloadModeProvider", 8,"REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup\AllowUpgradesWithUnsupportedTPMOrCPU"
Err.Clear 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\"  & " /f", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC\UpgradeEligibility"
Err.Clear 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\"  & " /f", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\HideUnsupportedHardwareNotifications"
Err.Clear 
On Error Resume Next 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup\AllowUpgradesWithUnsupportedTPMOrCPU", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassCPUCheck", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassDiskCheck", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassRAMCheck", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassSecureBootCheck", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassStorageCheck", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig\BypassTPMCheck", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC\UpgradeEligibility", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\SV1", 0, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\UnsupportedHardwareNotificationCache\SV2", 0, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\HideUnsupportedHardwareNotifications", 1, "REG_DWORD" 

Rem >> WinXP-POS-Ready-Embedded << 
Err.Clear 
On Error Resume Next   
XPEmbedded = WSHShell.Regread ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName") 
Err.Clear 
On Error Resume Next 
PosReady = WSHShell.Regread ("HKEY_LOCAL_MACHINE\SYSTEM\WPA\PosReady\Installed") 
Err.Clear 
On Error Resume Next 
ende = Timer 
if XPEmbedded = "Microsoft Windows XP" and PosReady <> "1" and Language = "deutsch" then _
XPEmbedded = MsgBox ("Der Support für " & winversioncheck & " wurde am 8. April 2014 " _ 
& vbNewLine & "Seitens Microsoft eingestellt. " & vbNewLine _ 
& vbNewLine & "Dieses Tool bietet die Möglichkeit über einen Hack " _ 
& vbNewLine & "dem Microsoft-Updateserver vorzugaukeln, daß diese " _ 
& vbNewLine & "Windowsversion eine sog. POS-Ready-Embedded-Version ist, " _ 
& vbNewLine & "was den Server dazu veranlaßt weiterhin neue " _
& vbNewLine & "Sicherheits-Updates zur Verfügung zu stellen. " & vbNewLine _ 
& vbNewLine & "Soll der Hack ´POS-Ready-Embedded´ jetzt aktiviert werden? ", _ 
vbSystemModal + vbOKCancel, Version) 

if XPEmbedded = "Microsoft Windows XP" and PosReady <> "1" and Language = "english" then _
XPEmbedded = MsgBox ("The Support for " & winversioncheck & " has been discontinued on April 8th 2014 " _ 
& vbNewLine & "from Microsoft. " & vbNewLine _ 
& vbNewLine & "This Tool offers the possibility " _ 
& vbNewLine & "to use a hack to fool the Microsoft Update-Server " _ 
& vbNewLine & "that this Version of Windows is a so-called POS Ready Embedded Version " _ 
& vbNewLine & "which causes the server to continue to provide new Security Updates " _
& vbNewLine & "for this Window-Version. " & vbNewLine _ 
& vbNewLine & "Do you want to activate the ´POS-Ready-Embedded´ Hack now? ", _ 
vbSystemModal + vbOKCancel, Version) 
restart = Timer 
If XPEmbedded = vbOK then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\WPA\PosReady\Installed", 1,"REG_DWORD" 

Rem >> Energiesparpläne << 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -restoredefaultschemes", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /s 381b4222-f694-41f0-9685-ff5bb260df2e", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /OverlaySetActive OVERLAY_SCHEME_NONE", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /change monitor-timeout-dc 12", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /change monitor-timeout-ac 0", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setdcvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /change monitor-timeout-dc 12", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /change monitor-timeout-ac 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 88ac267b-4dc0-3b86-99dc-d1094efcbc47", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg -setacvalueindex 88ac267b-4dc0-3b86-99dc-d1094efcbc47 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg -setdcvalueindex 88ac267b-4dc0-3b86-99dc-d1094efcbc47 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /s 88ac267b-4dc0-3b86-99dc-d1094efcbc47", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg -setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg -setdcvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN1 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX1 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES1 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor CPMINCORES1 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor CPINCREASETIME 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFINCTIME 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFINCTIME1 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL1 2", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL1 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP1 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP1 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PerfAutonomous 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PerfAutonomous 1", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFINCTHRESHOLD 10", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFINCTHRESHOLD1 10", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFDECTHRESHOLD 8", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor PERFDECTHRESHOLD1 8", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg -setacvalueindex scheme_current sub_processor DISTRIBUTEUTIL 0", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg /setacvalueindex scheme_current SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcb 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "Powercfg /setdcvalueindex scheme_current SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcb 100", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /change monitor-timeout-dc 12", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "powercfg /change monitor-timeout-ac 0", 1, True 
Err.Clear 
On Error Resume Next
WshShell.Run "Powercfg -setactive scheme_current", 1, True 
Err.Clear 
On Error Resume Next 

Rem >> Page-File Swap-Datei Optimieren << 
Err.Clear 
On Error Resume Next 
Page = Speicher 
If Speicher = false then Page = 1024 
If Speicher = 0 then Page = 1024 
If Speicher < 1024 then Page = 1024 
Swap = Page+(Page/2) 
If Swap < 6144 then Swap = 6144 
If Swap > 24576 then Swap = 24576 

Err.Clear 
On Error Resume Next 
strComputer = "." 
Set objWMIService = GetObject("winmgmts:" _ 
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
For Each objCS in objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem") 
on Error Resume Next 
If (objCS.AutomaticManagedPagefile) Then 
objCS.AutomaticManagedPageFile=False 
objCS.Put_ 
End If 
Next 

Err.Clear 
On Error Resume Next  
strComputer = "." 
Set objWMIService = GetObject("winmgmts:" _ 
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set colPageFiles = objWMIService.ExecQuery("Select * from Win32_PageFileSetting",,48) 
For Each objPageFile in colPageFiles 
objPageFile.InitialSize = Swap 
objPageFile.MaximumSize = Swap 
objPageFile.Put_ 
next 
 
Rem >> Erweiterter Cache- und System-Kernel-Patch << 
Err.Clear 
On Error Resume Next 
Ndu = WSHShell.Regread ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Ndu\Start")
Err.Clear 
On Error Resume Next 
If Ndu <> "2" then wshShell.Run "sc config Ndu start=auto && sc start Ndu", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue increaseuserva", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue numproc", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue onecpu", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue removememory", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue truncatememory", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue useplatformclock", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /set useplatformtick yes", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /set disabledynamictick yes", 1 , True 
Err.Clear  
On Error Resume Next 
wshShell.Run "bcdedit /set tscsyncpolicy Enhanced", 1 , True 
Err.Clear  
On Error Resume Next 
wshShell.Run "bcdedit /set recoveryenabled YES", 1 , True 
Err.Clear  
On Error Resume Next 
wshShell.Run "bcdedit /set nx OptIn", 1 , True 
Err.Clear  
On Error Resume Next  
wshShell.Run "bcdedit /set pae default", 1 , True 
Err.Clear  
On Error Resume Next  
wshShell.Run "bcdedit /set {bootmgr} timeout 30", 1 , True 
Err.Clear  
On Error Resume Next 
wshShell.Run "bcdedit /deletevalue {bootmgr} displaybootmenu", 1 , True 
Err.Clear 
On Error Resume Next 
wshShell.Run "bcdedit /set {current} bootlog No", 1 , True 
Err.Clear  
On Error Resume Next 
IOPLL = 0 
If Speicher = false then IOPLL = 0 
If Speicher = 0 then IOPLL = 0 
If Speicher < 64 then IOPLL = (Speicher-7)*1024 
If Speicher >= 64 then IOPLL = (Speicher-16)*1024 
If Speicher >= 512 then IOPLL = (Speicher-64)*1024 
If IOPLL > 4294967295 then IOPLL = -1 
DPE = 0 
If Speicher = false then DPE = 0 
If Speicher = 0 then DPE = 0 
If Speicher < 512 then DPE = 0 
If Speicher >= 512 then DPE = 1 
VRAM = 256  
If Speicher = false then VRAM = 256 
If Speicher = 0 then VRAM = 256 
If Speicher <= 256 then VRAM = 128 
If Speicher > 256 then VRAM = Speicher/2 
If VRAM > 4294967295 then VRAM = -1 
PREFETCHER = 3
If Speicher = false then PREFETCHER = 2 
If Speicher = 0 then PREFETCHER = 2 
If Speicher <= 3072 then PREFETCHER = 2 
If Speicher > 3072 then PREFETCHER = 3  
MC = "Enable-MMAgent -MemoryCompression" 
If Speicher = false then MC = "Enable-MMAgent -MemoryCompression" 
If Speicher = 0 then MC = "Enable-MMAgent -MemoryCompression" 
If Speicher < 7680 then MC = "Enable-MMAgent -MemoryCompression" 
If Speicher >= 7680 then MC = "Disable-MMAgent -MemoryCompression" 
Err.Clear 
On Error Resume Next 
wshShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command " & MC & " -v"), 1, True 
Err.Clear 
On Error Resume Next 
wshShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Enable-MMAgent -PageCombining -v"), 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\IOPageLockLimit", IOPLL, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\DisablePagingExecutive", DPE, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettings", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverride", 1024, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverrideMask", 1024, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\NonPagedPoolQuota", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\NonPagedPoolSize", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PagedPoolQuota", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PagedPoolSize", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PhysicalAddressExtension", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\SecondLevelDataCache", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\SessionPoolSize", 64, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\SessionViewSize", 128, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\SwapfileControl", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\SystemPages", -1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Quota System\EnableCpuQuota", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling\PowerThrottlingOff", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl\IRQ0Priority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl\IRQ8Priority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl\IRQ14Priority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl\IRQ15Priority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl\Win32PrioritySeparation", 38, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\InetInfo\Parameters\DisableMemoryCache", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\InetInfo\Parameters\MemCacheSize", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\InetInfo\Parameters\ThreadPoolUseIdealCpu", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\ThreadPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\ThreadPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Ndu\Start", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WOW\DefaultSeparateVDM", "yes", "REG_SZ" 
Err.Clear 
On Error Resume Next  
Const HKEY_LOCAL_MACHINE = &H80000002 
Const REG_DWORD = 4 
Set regex = CreateObject("vbscript.regexp") 
regex.IgnoreCase = True 
regex.Pattern = "^\d+$" 
Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv") 
strKeyPath = "SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" 
oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys 
For Each subkey In arrSubKeys 
If regex.Test(subkey) Then 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "Acceleration.Level", 0 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "DisableDynamicPstate", 0 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "EnableULPS", 0 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "EnableCoreSlowdown", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "EnableMClkSlowdown", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "EnableNVClkSlowdown", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "PerfLevelSrc", 13107 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "PowerMizerEnable", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "PowerMizerLevel", 2 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "PowerMizerLevelAC", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "PowerMizerDefault", 2 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "PowerMizerDefaultAC", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "DelayedDetectionForDP", 0 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "DelayedDetectionForHDMI", 0 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "DeepColorHDMIDisable", 0 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "EnableRGBFullRange", 1 
oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath & "\" & subkey, "SetDefaultFullRGBRangeOnHDMI", 1 
End If 
Next 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\HwSchMode", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\TdrDdiDelay", 20, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\TdrDelay", 20, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler\EnablePreemption", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler\VsyncIdleTimeout", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Avalon.Graphics\DisableHWAcceleration", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Avalon.Graphics\UseReferenceRasterizer", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SvcHostSplitThresholdInKB", 4718592, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TSFairShare\Disk\EnableFairShare", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TSFairShare\NetFS\EnableFairShare", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VxD\BIOS\AGPConcur", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VxD\BIOS\CPUDelayTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VxD\BIOS\CPUPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VxD\BIOS\FastDRAM", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VxD\BIOS\PCIConcur", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Intel\GMM\DedicatedSegmentSize", VRAM, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Holographic\FirstRun\AllowFailedSystemChecks", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableVirtualization", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\7zFM.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\7zFM.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\7zG.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\7zG.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\chkdsk.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\chkdsk.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\chrome.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\chrome.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cleanmgr.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cleanmgr.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Dism.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Dism.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DismHost.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DismHost.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dxwebsetup.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dxwebsetup.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dxwsetup.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dxwsetup.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefoxPortable.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefoxPortable.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gpupdate.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\gpupdate.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msiexec.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msiexec.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\OperaGXPortable.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\OperaGXPortable.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\OperaPortable.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\OperaPortable.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Safari.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Safari.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\seamonkey.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\seamonkey.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Setup.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Setup.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SetupHost.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SetupHost.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Setupprep.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Setupprep.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sfc.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sfc.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\tor.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\tor.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vivaldi.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vivaldi.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winget.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winget.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinRAR.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinRAR.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinSAT.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinSAT.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinStore.App.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinStore.App.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WSReset.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WSReset.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Windows10UpgraderApp.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Windows10UpgraderApp.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Windows11UpgraderApp.exe\PerfOptions\CpuPriorityClass", 3, "REG_DWORD" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Windows11UpgraderApp.exe\PerfOptions\IoPriority", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\MinVmVersionForCpuBasedMitigations", "1.0", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\GDIProcessHandleQuota", 16384, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\USERProcessHandleQuota", 18000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\AppHVSI\AllowVirtualGPU", 1, "REG_DWORD" 

Err.Clear 
On Error Resume Next  
Const KEY = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\SubSystems\Windows"
dim objShell, regex, str
Set objShell = CreateObject("Wscript.Shell")
Set regex = CreateObject("vbscript.regexp")
regex.IgnoreCase = True
regex.Pattern = "(SharedSection)=(\d+),(\d+),(\d+)"
str = objShell.RegRead (KEY)
str = regex.Replace(str,"$1=1024,20480,4096")
objShell.RegWrite KEY,str,"REG_EXPAND_SZ" 
Err.Clear 
On Error Resume Next  
regex.IgnoreCase = True
regex.Pattern = "(MaxRequestThreads)=(\d+)"
str = objShell.RegRead (KEY)
str = regex.Replace(str,"$1=32")
objShell.RegWrite KEY,str,"REG_EXPAND_SZ"
 
Rem >> UDMA neu setzen, Laufwerke beschleunigen << 
Err.Clear 
On Error Resume Next 
WshShell.Run "diskperf -n", 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisable8dot3NameCreation", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisableCompression", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisableEncryption", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisableLastAccessUpdate", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsEncryptPagingFile", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsMemoryUsage", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsMftZoneReservation", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Fdc\ForceFIFO", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\DiskSpaceThreshold", 5, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR\TelemetryPerformanceEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR\TelemetryErrorDataEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR\TelemetryDeviceHealthEnabled", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E965-E325-11CE-BFC1-08002BE10318}\UpperFilters" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E965-E325-11CE-BFC1-08002BE10318}\LowerFilters" 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command fsutil behavior set DisableDeleteNotify 0 -v"), 1, True 
Err.Clear 
 
On Error Resume Next 
RegPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E96A-E325-11CE-BFC1-08002BE10318}\" 
ValueName1Master = "MasterIdDataChecksum" 
ValueName1Slave = "SlaveIdDataChecksum" 
ValueName2Master = "UserMasterDeviceTimingModeAllowed" 
ValueName2Slave = "UserSlaveDeviceTimingModeAllowed" 
ValueName3 = "ResetErrorCountersOnSuccess" 
ConsecutiveMisses = 0 
For i = 0 to 999 
RegSubPath = Right("000" & i, 4) & "\" 
Err.Clear 
On Error Resume Next 
WshShell.RegRead RegPath & RegSubPath & ValueName1Master 
errMaster = Err.Number 
If errMaster = 0 Then 
On Error Resume Next 
WshShell.RegDelete RegPath & RegSubPath & ValueName1Master 
WshShell.RegDelete RegPath & RegSubPath & ValueName2Master 
WshShell.RegWrite RegPath & RegSubPath & "MasterDeviceTimingModeAllowed", -1, "REG_DWORD" 
end if 
Err.Clear 
On Error Resume Next 
WshShell.RegRead RegPath & RegSubPath & ValueName1Slave
errSlave = Err.Number 
If errSlave = 0 Then 
On Error Resume Next 
WshShell.RegDelete RegPath & RegSubPath & ValueName1Slave 
WshShell.RegDelete RegPath & RegSubPath & ValueName2Slave 
WshShell.RegWrite RegPath & RegSubPath & "SlaveDeviceTimingModeAllowed", -1, "REG_DWORD" 
end if 
If errMaster = 0 Or errSlave = 0 Then 
Err.Clear 
On Error Resume Next 
WshShell.RegWrite RegPath & RegSubPath & ValueName3, 1, "REG_DWORD" 
ChannelName = "unnamed channel " & Left(RegSubPath, 4) 
ChannelName = WshShell.RegRead(RegPath & RegSubPath & "DriverDesc") 
ConsecutiveMisses = 0 
end if 
next 
 
Rem >> Windows-Suche und Index-Optimierungen << 
Err.Clear 
On Error Resume Next 
WshShell.Run "net stop wsearch", 1, True 
Err.Clear 
On Error Resume Next 
REM WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\SetupCompletedSuccessfully", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\SystemIndexNormalization", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\UseLowPriorityConfiguration", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\Gather\Windows\SystemIndex\EnableFindMyFiles", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\Gather\Windows\SystemIndex\RespectPowerModes", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\Gathering Manager\DisableBackOff", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Search\Gathering Manager\PerformanceLevel", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences\ArchivedFiles", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences\AutoWildCard", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences\EnableNaturalQuerySyntax", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences\SystemFolders", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences\WholeFileSystem", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\IsAADCloudSearchEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\IsDeviceSearchHistoryEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\IsDynamicSearchBoxEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\IsMSACloudSearchEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\SafeSearchMode", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search\EnableDynamicContentInWSB", 0, "REG_DWORD" 
Err.Clear
On Error Resume Next 
WshShell.Run "net start wsearch", 1, True 
Err.Clear 
On Error Resume Next 
 
Rem >> Windows-Systemwiederherstellung << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore\SystemRestorePointCreationFrequency", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore\cfg\DiskPercent", 20, "REG_DWORD" 
Err.Clear 
 
Rem >> Windows-Cortana-Optimierungen << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId\State", 1, "REG_DWORD" 
Err.Clear 
On Error Resume Next 

Rem >> Bootvorgang und Prefetchoptimierungen (Bootperformance und Programmstarts werden verbessert) << 
Err.Clear 
On Error Resume Next 
WshShell.Run "sc config ""SysMain"" start=auto & sc start ""SysMain""", 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction\Enable", "Y", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\OneDrive\PreventNetworkTrafficPreUserSignIn", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout\EnableAutoLayout", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\RunLogonScriptSync", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\RunLogonScriptSync", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\RunLogonScriptSync", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\RestartApps", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\RunLogonScriptSync", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\RunStartupScriptSync", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\VerboseStatus", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DisableStatusMessages", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DisplayLastLogonInfo", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableFirstLogonAnimation", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\ShutdownWithoutLogon", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoChangingLockScreen", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoChangingStartMenuBackground", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoLockScreen", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\DisableAcrylicBackgroundOnLogon", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\DisableLogonBackgroundImage", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\DontDisplayNetworkSelectionUI", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ContentIndex\StartupDelay", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AutoChkTimeout", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager\BackupCount", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager\LastKnownGood\Enabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnableBootTrace", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnablePrefetcher", PREFETCHER, "REG_DWORD" 
Err.Clear 
On Error Resume Next   
Superfetch = WSHShell.Regread ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnableSuperfetch") 
Err.Clear 
On Error Resume Next   
If Superfetch > 0 then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnableSuperfetch", PREFETCHER, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Schedule\Start", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DelayedApps\BoxedIoPriority", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DelayedApps\BoxedPagePriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DelayedApps\BoxedPriorityClass", 16384, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DelayedApps\Delay_Sec", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize\StartupDelayInMSec", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText" 
 
Err.Clear 
On Error Resume Next 
Set oFSO = WScript.CreateObject("Scripting.FileSystemObject") 
Set WinDir = oFSO.GetSpecialFolder(0) 
Set oFolder = oFSO.GetFolder(WinDir & "\Prefetch") 
Set oFiles = oFolder.Files 
For Each oFile In oFiles 
oFSO.DeleteFile(oFile.Path) 
Next 
Set oFiles = Nothing 
Set oFolder = Nothing 
Set oFSO = Nothing 
 
Rem >> AUTOSTART-OPTIMIZER << 
Err.Clear 
On Error Resume Next 
Dim fso, MyFile
Set fso = CreateObject("Scripting.FileSystemObject")
Startup = wshShell.Specialfolders("AllUsersStartup") 
Set MyFile = fso.CreateTextFile (Startup & "\AUTOSTART-OPTIMIZER.VBS") 
MyFile.WriteLine (" ") 
MyFile.WriteLine ("rem 	********************************* ") 
MyFile.WriteLine ("rem 	* Optimiert den Systemstart !!! * ") 
MyFile.WriteLine ("rem 	********************************* ") 
MyFile.WriteLine (" ") 
MyFile.WriteLine ("On Error Resume Next ") 
MyFile.WriteLine ("Const Above_Normal = 32768 ") 
MyFile.WriteLine ("strComputer = ""."" ") 
MyFile.WriteLine ("Set objWMIService = GetObject(""winmgmts:\\"" & strComputer & ""\root\cimv2"") ") 
MyFile.WriteLine ("Set colProcesses = objWMIService.ExecQuery _ ") 
MyFile.WriteLine ("(""Select * from Win32_Process Where Name = 'Explorer.exe'"") ") 
MyFile.WriteLine ("For Each objProcess in colProcesses ") 
MyFile.WriteLine ("objProcess.SetPriority(Above_Normal) ") 
MyFile.WriteLine ("Next ") 
MyFile.WriteLine ("Err.Clear ") 
MyFile.WriteLine ("WScript.Quit ") 
MyFile.WriteLine (" ") 
MyFile.WriteLine ("rem 	******************************************************************* ") 
MyFile.WriteLine ("rem 	* !c3 AUTOSTART-OPTIMIZER is Part of the WINDOWS-OPTIMIZER 	  * ") 
MyFile.WriteLine ("rem 	* -written by 							  * ") 
MyFile.WriteLine ("rem 	* René Bengsch							  * ") 
MyFile.WriteLine ("rem 	* info/contact @ 						  * ") 
MyFile.WriteLine ("rem 	* https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER  * ") 
MyFile.WriteLine ("rem 	* https://facebook.com/groups/WindowsOptimizer			  * ") 
MyFile.WriteLine ("rem 	* e-m@il: hammanit@web.de 	 				  * ") 
MyFile.WriteLine ("rem 	******************************************************************* ") 
MyFile.WriteLine (" ")  
Set fso = Nothing 
Startup = Nothing 
Set MyFile = Nothing 
 
Err.Clear 
On Error Resume Next 
REM Const HKEY_LOCAL_MACHINE = &H80000002 
KeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder" 
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & ".\root\default:StdRegProv") 
ValueName = "AUTOSTART-OPTIMIZER.VBS" 
iValues = Array(&H02,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00) 
oReg.SetBinaryValue HKEY_LOCAL_MACHINE,KeyPath,ValueName,iValues 
Err.Clear 
 
Rem >> Windowsoberfläche optimieren << 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\srvcomment", "Optimized-System: " & version, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Console\ForceV2", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ActiveWndTrackTimeout", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ActiveWndTrkTimeout", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ClickLockTime", 1200, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\CoolSwitch", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\CoolSwitchColumns", 7, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\CoolSwitchRows", 3, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\DockMoving", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\DragFromMaximize", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\DragFullWindows", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\EnablePerProcessSystemDPI", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\FontSmoothing", 2, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\FontSmoothingGamma", 1000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\FontSmoothingType", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ForegroundFlashCount", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ForegroundLockTimeout", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\JPEGImportQuality", 100, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\MenuShowDelay", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\MonitorRemovalRecalcBehavior", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\RestorePreviousStateRecalcBehavior", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\MouseWheelRouting", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\SmoothScroll", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\SnapSizing", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\Win8DpiScaling", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WindowArrangementActive", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics\MaxAnimate", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics\MinAnimate", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics\MinArrange", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics\Shell Icon BPP", 32, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics\Shell Icon Size", 32, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\MouseHoverTime", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\System.IsPinnedToNamespaceTree", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\FavIntelliMenus", "No", "REG_SZ" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\AllowClipboardHistory" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Clipboard\ClipboardTipRequired", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Clipboard\CloudClipboardAutomaticUpload", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Clipboard\EnableClipboardHistory", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Clipboard\EnableCloudClipboard", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MobilePC\AdaptableSettings\SkipBatteryCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MobilePC\MobilityCenter\RunOnDesktop", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AltTabSettings", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\EnableAutoTray", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HoverSelectDesktops", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\AlwaysShowMenus", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\AppIconInTouchImprovement", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\AutoCheckSelect", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DesktopLivePreviewHoverTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DisablePreviewDesktop", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DisableThumbnailCache", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DontPrettyPath", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DontUsePowerShellOnWinX", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ExtendedUIHoverTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\FileExplorerInTouchImprovement", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\FolderContentsInfoTip", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideIcons", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\IconsOnly", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\IntelliMenus", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\JointResize", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\LastActiveClick", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ListviewAlphaSelect", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ListviewShadow", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\MultiTaskingAltTabFilter", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPaneExpandToCurrentFolder", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPaneShowAllCloudStates", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPaneShowAllFolders", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\SearchBoxVisibleInTouchImprovement", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\SeparateProcess", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\SharingWizardOn", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowCompColor", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowCortanaButton", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowEncryptCompressedColor", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowInfoTip", 1, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSecondsInSystemClock", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowStatusBar", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSuperHidden", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSyncProviderNotifications", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowTaskViewButton", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowTypeOverlay", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\SnapAssist", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\SnapFill", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_PowerButtonAction", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_SearchFiles", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_ShowRun", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_TrackDocs", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_TrackProgs", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\StartMenuAdminTools", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\StoreAppsOnTaskbar", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarAnimations", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarAppsVisibleInTabletMode", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarAutoHideInTabletMode", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDa", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarGlomLevel", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarSizeMove", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarSmallIcons", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ThumbnailLivePreviewHoverTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TypeAhead", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\LaunchTo", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\CapacityOfPeopleBar", 10, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\PeopleBand", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete\Append Completion", "yes", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete\AutoSuggest", "yes", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\FullPath", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\AllItemsIconView", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\StartupPage", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz\NoRun", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel\{20D04FE0-3AEA-1069-A2D8-08002B30309D}", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultitaskingView\AltTabViewHost\Wallpaper", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon\MinimizedStateTabletModeOff", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\MaxThumbSizePx", 256, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\MinThumbSizePx", 256, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\NumThumbnails", 10, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ThumbnailQuality", 100, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\VisualFXSetting", 3, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Dsh\IsPrelaunchEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Input\IsInputAppPreloadEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\ShellFeedsTaskbarContentUpdateMode", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\ShellFeedsTaskbarOpenOnHover", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\ShellFeedsTaskbarViewMode", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\ConvertibleSlateModePromptPreference", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\SignInMode", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Switcher\AppTipDesktopDelay", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Switcher\AppTipImmersiveDelay", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Switcher\CloseDwellTimeout", 300, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Switcher\MouseCloseThresholdPercent", 80, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Switcher\TouchCloseThresholdPercent", 80, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\HubsSidebarEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi\CharmsBarDesktopDelay", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi\CharmsBarImmersiveDelay", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\NOC_GLOBAL_SETTING_BADGE_ENABLED", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\NOC_GLOBAL_SETTING_GLEAM_ENABLED", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\MSEdge\Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\HideSCAPower", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search\SearchboxTaskbarMode", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\TaskManager\StartUpTab", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement\ScoobeSystemSettingEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\AllowLowResolution", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\DecreaseResolutionOnBattery", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\DisableAutoLightingOnBattery", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\DisableHDROnBattery", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\DisableHDRSupportOnBattery", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\DisableOtherEnhancementsOnBattery", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\EnableAutoEnhanceDuringPlayback", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\EnableHDRForPlayback", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\EnableOutsideModeFeature", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\HDColorQualityOnBattery", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\VideoSettings\VideoQualityOnBattery", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU Size", 8000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\ShellNoRoam\BagMRU Size", 8000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM\AnimationsShiftKey", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM\EnableAeroPeek", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM\HideBlur", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\ThemeChangesDesktopIcons", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\ThemeChangesMousePointers", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\EnableBlurBehind", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\EnableTransparency", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer\EnableLegacyBalloonNotifications", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer\DisableContextMenusInStart", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer\DisableNotificationCenter", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer\ForceStartSize", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\UseOLEDTaskbarTransparency", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\PromptOnSecureDesktop", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm\ForceEffectMode", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network\ReplaceVan", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AicEnabled", "Recommendations", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DelaySendToMenuBuild", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HubMode", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Max Cached Icons", 8192, "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\UseWin32BatteryFlyout", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\UseWin32TrayClockExperience", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher\DisableLightDismiss", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell", "explorer.exe", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shell\ActionCenter\Quick Actions\PinnedQuickActionSlotCount", 4, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderDocuments", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderDocuments_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderDownloads", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderDownloads_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderFileExplorer", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderFileExplorer_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderMusic", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderMusic_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderNetwork", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderNetwork_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderPersonalFolder", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderPersonalFolder_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderPictures", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderPictures_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderSettings", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderSettings_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderVideos", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start\AllowPinnedFolderVideos_ProviderSet", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SharePlatform\EnableNewShareFlow", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\StigRegKey\Typing\TaskbarAvoidanceEnabled\Enable", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\StigRegKey\Typing\TaskbarAvoidanceEnabled\TaskbarAvoidanceEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC\EnableMtcUvc", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\0\2093230218\EnabledState", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\0\2093230218\EnabledStateOptions", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimationEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Update\UpdateMode", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Performance Control Panel\PerfCplEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Performance Control Panel\SolutionsEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Performance Control Panel\UpsellEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Performance Control Panel\PerfCplEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Performance Control Panel\SolutionsEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Performance Control Panel\UpsellEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_USERS\.DEFAULT\Control Panel\Colors\Background", "0 0 0", "REG_SZ" 
WSHShell.RegWrite "HKEY_USERS\.DEFAULT\Control Panel\Desktop\FontSmoothing", 2, "REG_SZ" 
WSHShell.RegWrite "HKEY_USERS\.DEFAULT\Control Panel\Desktop\FontSmoothingGamma", 1000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_USERS\.DEFAULT\Control Panel\Desktop\FontSmoothingType", 2, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\IconStreams" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\PastIconsStream" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\IconStreams" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\PastIconsStream" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify\IconStreams" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify\PastIconsStream" 
Err.Clear 
On Error Resume Next 
WshShell.Run "ie4uinit -show", 1, True 
Err.Clear 

On Error Resume Next 
Const HKCU = &H80000001 
KeyPath = "Control Panel\Desktop" 
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & ".\root\default:StdRegProv") 
ValueName = "UserPreferencesMask" 
iValues = Array(&H90,&H012,&H07,&H80,&H10,&H00,&H00,&H00) 
oReg.SetBinaryValue HKCU,KeyPath,ValueName,iValues 

Rem >> Ads << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\RotatingLockScreenEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\RotatingLockScreenOverlayEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SilentInstalledAppsEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SoftLandingEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-310093Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-314563Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338387Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338388Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338389Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338393Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-353694Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-353696Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SystemPaneSuggestionsEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSyncProviderNotifications", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent\DisableWindowsSpotlightFeatures", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent\DisableWindowsSpotlightWindowsWelcomeExperience", 1, "REG_DWORD" 

Rem >> Adware, Malware und PUA Erkennung in Microsofts Virenscannern aktivieren << 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Remove-MpPreference -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -EnableControlledFolderAccess 0 -v"), 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\PUAProtection", 2,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection", 2,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine\MpEnablePus", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet\SubmitSamplesConsent", 2,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Microsoft Antimalware\MpEngine\MpEnablePus", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard\Enabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity\Enabled", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -DisableCpuThrottleOnIdleScans 1 -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -EnableFullScanOnBatteryPower 0 -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -EnableLowCpuPriority 0 -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -MAPSReporting 2 -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -PUAProtection 2 -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -ScanOnlyIfIdleEnabled 1 -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -SignatureScheduleDay Everyday -v"), 1, True 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Set-MpPreference -SubmitSamplesConsent 2 -v"), 1, True 

Rem >> Systemwiederherstellungspunkte << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore\SystemRestorePointCreationFrequency", 0, "REG_DWORD" 

Rem >> Druckaufträge beschleunigen << 
Err.Clear 
On Error Resume Next 
WshShell.Run "net stop spooler", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "cmd.exe /c del /F /S /Q %systemroot%\System32\spool\PRINTERS\*", 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\PortThreadPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\SchedulerThreadPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\SpoolerPriority", -1, "REG_DWORD" 
On Error Resume Next 
WshShell.Run "net start spooler", 1, True 
Err.Clear 

Rem >> Clock resync. << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\DelayedAutostart", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\ServiceDllUnloadOnStop", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Type", "NTP", "REG_SZ" 
Err.Clear 
On Error Resume Next 
WshShell.Run "w32tm /resync", 1, True 
Err.Clear 
  
Rem >> Kontext-Menu-Erweiterung << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32\" , "" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MultipleInvokePromptMinimum", 16, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartHigh\", "Start &High Priority", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartHigh\MUIVerb", "Öffnen mit hoher Priorität", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartHigh\MUIVerb", "Open with high Priority", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartHigh\Command\", "cmd.exe /c start ""StartHigh"" /High ""%1""", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartLow\", "Start &Low Priority", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartLow\MUIVerb", "Öffnen mit niedriger Priorität", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartLow\MUIVerb", "Open with low Priority", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\StartLow\Command\", "cmd.exe /c start ""StartLow"" /Low ""%1""", "REG_SZ" 
Err.Clear 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\"  & " /f", 1, True 
Err.Clear 
If WinValue <> "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\icon", "Control.exe", "REG_SZ" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\icon", "SystemSettingsBroker.exe", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\MUIVerb", "System-Einstellungen", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\MUIVerb", "System-Settings", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\Position", "Bottom", "REG_SZ" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\SettingsURI", "ms-settings:", "REG_SZ" 
If WinValue <> "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\command\", "control /name Microsoft.System", "REG_SZ" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Computer-Settings\command\DelegateExecute", "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control\", "@shell32.dll,-4161", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control\icon", "Control.exe", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control\Position", "Bottom", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control\command\", "control.exe", "REG_SZ" 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_CLASSES_ROOT\DesktopBackground\Shell\GodMode\"  & " /f", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control God-Mode\"  & " /f", 1, True 
Err.Clear 
On Error Resume Next
If WinValue <> "5.1" and Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control God-Mode\", "Alle Aufgaben", "REG_SZ" 
If WinValue <> "5.1" and Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control God-Mode\", "All Tasks", "REG_SZ" 
If WinValue <> "5.1" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control God-Mode\icon", "Control.exe", "REG_SZ" 
If WinValue <> "5.1" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control God-Mode\Position", "Bottom", "REG_SZ" 
If WinValue <> "5.1" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Control God-Mode\command\", "explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}", "REG_SZ" 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\"  & " /f", 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\icon", "powercpl.dll", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\MUIVerb", "Energiesparplan ändern", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\MUIVerb", "Choose a Power Plan", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Position", "Bottom", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\SubCommands", "", "REG_SZ" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\A-Ultimate Performance\icon", "powercpl.dll", "REG_SZ" 
If WinValue = "10." and Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\A-Ultimate Performance\MUIVerb", "Ultimative Leistung", "REG_SZ" 
If WinValue = "10." and Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\A-Ultimate Performance\MUIVerb", "Ultimate Performance", "REG_SZ" 
If WinValue = "10." then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\A-Ultimate Performance\Command\", "powercfg.exe /s 88ac267b-4dc0-3b86-99dc-d1094efcbc47",  "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\B-High Performance\icon", "powercpl.dll", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\B-High Performance\MUIVerb", "Höchstleistung", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\B-High Performance\MUIVerb", "High Performance", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\B-High Performance\Command\", "powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",  "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\C-Balanced\icon", "powercpl.dll", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\C-Balanced\MUIVerb", "Ausbalanciert", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\C-Balanced\MUIVerb", "Balanced", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\C-Balanced\Command\", "powercfg.exe /s 381b4222-f694-41f0-9685-ff5bb260df2e", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\D-Power Saver\icon", "powercpl.dll", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\D-Power Saver\MUIVerb", "Energiesparmodus", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\D-Power Saver\MUIVerb", "Power Saver", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\D-Power Saver\Command\", "powercfg.exe /s a1841308-3541-4fab-bc81-f71556f20b4a", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\Z-Settings\icon", "control.exe", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\Z-Settings\MUIVerb", "Einstellungen", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\Z-Settings\MUIVerb", "Settings", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\SwitchPowerScheme\Shell\Z-Settings\Command\", "Control Powercfg.cpl", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Taskmanager\icon", "taskmgr.exe", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Taskmanager\Position", "Bottom", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Taskmanager\MUIVerb", "Task-Manager", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\DesktopBackground\Shell\Taskmanager\Command\", "taskmgr.exe", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Cleanmanager\icon", "cleanmgr.exe", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Cleanmanager\MUIVerb", "Laufwerk bereinigen", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Cleanmanager\MUIVerb", "Clean up Volume", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Cleanmanager\command\", "cmd.exe /c start /High Cleanmgr.exe %1", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Defrag\icon", "defrag.exe", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Defrag\MUIVerb", "Laufwerk optimieren", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Defrag\MUIVerb", "Optimize Drive", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\Drive\shell\Defrag\command\", "cmd.exe /c start /High dfrgui.exe", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Open With\", "{09799AFB-AD67-11d1-ABCD-00C04FC30936}", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\IE.AssocFile.URL\shellex\ContextMenuHandlers\{09799AFB-AD67-11d1-ABCD-00C04FC30936}\", "REG_SZ"
WSHShell.RegWrite "HKEY_CLASSES_ROOT\InternetShortcut\shell\Öffnen in neuem Fenster\command\", "rundll32.exe shdocvw.dll,OpenURL %l", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\AllowWindowReuse", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\", "@%SystemRoot%\system32\shell32.dll,-22068", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\InfoTip", "@%SystemRoot%\system32\shell32.dll,-22580", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\System.ApplicationName", "Microsoft.WindowsUpdate", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\System.ControlPanel.Category", "5", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\System.Software.TasksFileUrl", "Internal", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\DefaultIcon\", "shell32.dll,-47", "REG_SZ" 
WSHShell.RegWrite "HKEY_CLASSES_ROOT\CLSID\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\Shell\Open\Command\", "control.exe /name Microsoft.WindowsUpdate", "REG_EXPAND_SZ"
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{36eef7db-88ad-4e81-ad49-0e313f0c35f8}\", "Windows Update", "REG_SZ" 

Rem >> Adobe Acrobat Reader DC << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\AVGeneral\aDefaultRHPViewModeL", "Collapsed", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\AVGeneral\bRHPSticky", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\AVGeneral\iDelayBeforeQuitBrowser", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Adobe\Acrobat Reader\DC\AVGeneral\iDelayBeforeQuitViewer", 0, "REG_DWORD" 

Rem >> !c3-NVIDIA-CoolBits 2.0 (Schaltet alle versteckte Optionen von NVIDIA Grafikkartentreibern frei) << 
Err.Clear 
On Error Resume Next 
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_VideoController",,48)
For Each objItem in colItems
if objItem.AdapterCompatibility = "NVIDIA" then CoolBits
Next 
  
Rem >> Runterfahren Optimieren << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\HidePowerOptions", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability\TimeStampInterval", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\PowerdownAfterShutdown", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl\AutoReboot", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl\DisplayDisabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl\DisplayParameters", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl\Overwrite", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\ClearPageFileAtShutdown", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WaitToKillService", 100, "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WaitToKillServiceTimeout", 5000, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\HungAppTimeout", 5000, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\LowLevelHooksTimeout", 5000, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WaitToKillAppTimeout", 25000, "REG_SZ" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Power\HiberbootEnabled", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /hibernate size 100", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /hibernate /type full", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "powercfg /hibernate off", 1, True 
 
Rem >> Internetbandbreite, Browser-, Up- und Download optimieren << 
Err.Clear 
On Error Resume Next 

Rem Enter PRIVATE DNS-SERVERS HERE!! 
PrivateIPv4DNSServer = ""
PrivateIPv6DNSServer = ""

Err.Clear 
On Error Resume Next 
If PrivateIPv4DNSServer <> "" Then PrivateIPv4DNS = PrivateIPv4DNSServer & ","
If PrivateIPv6DNSServer <> "" Then PrivateIPv6DNS = PrivateIPv6DNSServer & ","
Err.Clear 
On Error Resume Next 
Set objShell = CreateObject("WScript.Shell")
REM Const HKEY_LOCAL_MACHINE = &H80000002
strComputer = "."
Set objRegistry = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & strComputer & "\root\default:StdRegProv")
strRegRoot = HKEY_LOCAL_MACHINE
strKey = "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
If objRegistry.EnumKey(strRegRoot, strKey, arrKeyNames) = 0 Then
If IsNull(arrKeyNames) = False Then 
For Each strKeyName In arrKeyNames
If Right(strKey, 1) = "\" Then
strFullPath = strKey & strKeyName
Else
strFullPath = strKey & "\" & strKeyName
End If
objRegistry.SetDWORDValue strRegRoot, strFullPath, "TcpAckFrequency", 1 
objRegistry.SetDWORDValue strRegRoot, strFullPath, "TcpDelAckTicks", 0 
objRegistry.SetDWORDValue strRegRoot, strFullPath, "TCPNoDelay", 1 
objRegistry.getSTRINGValue strRegRoot, strFullPath, "DhcpNameServer", strValue
DhcpNameServer = ""
if strValue <> "" then DhcpNameServer = "," & strValue
objRegistry.SetSTRINGValue strRegRoot, strFullPath, "NameServer", PrivateIPv4DNS & "1.1.1.1,1.0.0.1,8.8.8.8,8.8.4.4" & DhcpNameServer
Next
End If
End If	
Err.Clear 
On Error Resume Next 
Set objShell = CreateObject("WScript.Shell") 
strComputer = "."
Set objRegistry = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & strComputer & "\root\default:StdRegProv")
strRegRoot = HKEY_LOCAL_MACHINE
strKey = "SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\Interfaces"
If objRegistry.EnumKey(strRegRoot, strKey, arrKeyNames) = 0 Then
If IsNull(arrKeyNames) = False Then 
For Each strKeyName In arrKeyNames
If Right(strKey, 1) = "\" Then
strFullPath = strKey & strKeyName
Else
strFullPath = strKey & "\" & strKeyName
End If
objRegistry.SetSTRINGValue strRegRoot, strFullPath, "NameServer", PrivateIPv6DNS & "2606:4700:4700::1111,2606:4700:4700::1001,2001:4860:4860::8888,2001:4860:4860::8844" 
Next
End If
End If	
Err.Clear 
On Error Resume Next 
WshShell.Run "ipconfig /release", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "ipconfig /renew", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "ipconfig /flushdns", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "ipconfig /registerdns", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "netsh winsock reset", 1, True 
Err.Clear 

On Error Resume Next 
Const ADMINISTRATIVE_TOOLS = 6
Set objShell = CreateObject("Shell.Application")
Set objFolder = objShell.Namespace(ADMINISTRATIVE_TOOLS) 
Set objFolderItem = objFolder.Self   
Set objShell = WScript.CreateObject("WScript.Shell")  
Err.Clear 
On Error Resume Next 
strDesktopFld = objFolderItem.Path
Set objURLShortcut = objShell.CreateShortcut(strDesktopFld & "\Links\Google.URL")
If Language = "deutsch" then objURLShortcut.TargetPath = "https://www.google.de/"
If Language = "english" then objURLShortcut.TargetPath = "https://www.google.com/"
objURLShortcut.Save
Err.Clear 
On Error Resume Next 
strDesktopFld = objFolderItem.Path
Set objURLShortcut = objShell.CreateShortcut(strDesktopFld & "\Links\Windows-Optimizer-Project.URL")
objURLShortcut.TargetPath = "https://www.facebook.com/groups/WindowsOptimizer"
objURLShortcut.Save
Err.Clear 
On Error Resume Next 
Set objURLShortcut = objShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows-Optimizer-Project.URL")
objURLShortcut.TargetPath = "https://www.facebook.com/groups/WindowsOptimizer"
objURLShortcut.Save
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main\Enable_Disk_Cache", "yes", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Search\SearchAssistant", "http://www.google.de/ie", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Search\SearchAssistant", "http://www.google.com/ie", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\AutoComplete\Append Completion", "yes", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Window Title", "!c3-OPTIMIZED-SYSTEM", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Search Bar", "http://www.google.de/ie", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Search Bar", "http://www.google.com/ie", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Search Page", "http://www.google.de", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Search Page", "http://www.google.com", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Start Page", "https://www.google.de/", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\Start Page", "https://www.google.com/", "REG_SZ" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\SearchURL\", "http://www.google.de/keyword/%s", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\SearchURL\", "http://www.google.com/keyword/%s", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\PlaySound", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\PopupMgr", "yes", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\UseSecBand", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MINIE\AlwaysShowMenus", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MINIE\CommandBarEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MINIE\LinksBandEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MINIE\ShowStatusBar", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\EnableNegotiate", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\MaxConnectionsPerServer", 10, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\MaxConnectionsPer1_0Server", 10, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Persistent", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Content\CacheLimit", 256000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Content\CacheLimit", 256000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\ContentLimit", 250, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\BackgroundModeEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\EfficiencyModeOnPowerEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\HardwareAccelerationModeEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\StartupBoostEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\Recommended\BackgroundModeEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\Recommended\EfficiencyModeOnPowerEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\Recommended\HardwareAccelerationModeEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge\Recommended\StartupBoostEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\MicrosoftEdge\Internet Settings\UnlockHomeButton", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main\AllowPrelaunch", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Microsoft\MicrosoftEdge\Main\AllowPrelaunch", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\MicrosoftEdge\Main\AllowPrelaunch", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Recommended\BackgroundModeEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Microsoft\MicrosoftEdge\Recommended\BackgroundModeEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Policies\Microsoft\MicrosoftEdge\Recommended\BackgroundModeEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader\PreventTabPreloading", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Microsoft\MicrosoftEdge\TabPreloader\PreventTabPreloading", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader\PreventTabPreloading", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ExperimentalFeatures\AllowRenderThrottling", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ExperimentalFeatures\BlockSpecificRenderThrottling", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ExperimentalFeatures\EnableTcpFastOpen", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Extensions\Annotations\ShowOnAddressBar", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Extensions\Downloads\ShowOnAddressBar", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Extensions\Favorites\ShowOnAddressBar", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Extensions\History\ShowOnAddressBar", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Extensions\ReadingList\ShowOnAddressBar", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Extensions\Share\ShowOnAddressBar", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\AskToCloseAllTabs", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\DoNotTrack", 1, "REG_DWORD" 
If Language = "deutsch" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\HomeButtonPage", "http://www.google.de/", "REG_SZ" 
If Language = "english" then WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\HomeButtonPage", "http://www.google.com/", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\TabbedBrowsing\ShowTabPreviewBarOnStartup", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\TabbedBrowsing\TabPeekEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\TabbedBrowsing\TabPeekHideDelay", 0, "REG_DWORD"
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\TabbedBrowsing\TabPeekShowDelay", 0, "REG_DWORD"
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER\explorer.exe", 14," REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER\iexplorer.exe", 14," REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER\explorer.exe", a, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER\iexplorer.exe", a, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSMQ\Parameters\TCPNoDelay", 1, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\BITS\"  & " /f", 1, True 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\BITS\EnableBITSMaxBandwidth", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\BITS\UseSystemMaximum", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Psched\NonBestEffortLimit", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\CacheHashTableBucketSize", 50, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\CacheHashTableSize", 384, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\MaxCacheEntryTtlLimit", 172800, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\MaxCacheTtl", 172800, "REG_DWORD"
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\MaxSOACacheEntryTtlLimit", 300, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\MaxNegativeCacheTtl", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\NegativeCacheTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\NegativeSOACacheTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\NetFailureCacheTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Dnscache\Parameters\NetFailureErrorPopupLimit", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HTTP\Parameters\EnableAggressiveMemoryUsage", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\IRPStackSize", 50, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\ServiceDllUnloadOnStop", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\Size", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SizReqBuf", 65535, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheEntriesMax", 4096, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheEntrySizeMax", 4096, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DirectoryCacheLifetime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableBandwidthThrottling", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DisableLargeMtu", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileInfoCacheEntriesMax", 32768, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileInfoCacheLifetime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileNotFoundCacheEntriesMax", 32768, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\FileNotFoundCacheLifetime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\MaxCmds", 32768, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanworkstation\parameters\MaxThreads", 255, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet\EnableActiveProbing", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NDIS\Parameters\RssBaseCpu", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NDIS\Parameters\MaxNumRssCpus" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock\MaxSockAddrLength", 16, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock\MinSockAddrLength", 16, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock\UseDelayedAcceptance", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\DefaultTTL" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\DisableTaskOffload", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableConnectionRateLimiting", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\GlobalMaxTcpWindowSize", 65535, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\MaxFreeTcbs", 65535, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\MaxUserPort", 65535, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\RssBaseCpu", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.RegDelete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\MaxNumRssCpus" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Tcp1323Opts", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpMaxConnectRetransmissions", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpMaxDataRetransmissions", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpTimedWaitDelay", 30, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\StrictTimeWaitSeqCheck", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider\DnsPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider\HostsPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider\LocalPriority", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider\NetbtPriority", 1, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.Run "netsh int tcp set global rss=enabled", 1, True 
Err.Clear  
On Error Resume Next 
WshShell.Run "netsh int tcp set global rsc=disabled", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "netsh int ipv4 set dynamicport tcp start=1025 num=64511", 1, True 
Err.Clear  
On Error Resume Next 
WshShell.Run "netsh int ipv4 set dynamicport udp start=1025 num=64511", 1, True 
Err.Clear  
On Error Resume Next 
WshShell.Run "netsh int ipv6 set dynamicport tcp start=1025 num=64511", 1, True 
Err.Clear  
On Error Resume Next 
WshShell.Run "netsh int ipv6 set dynamicport udp start=1025 num=64511", 1, True 
Err.Clear  
On Error Resume Next 
WshShell.Run "netsh int tcp set global autotuninglevel=experimental", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "netsh int tcp set supplemental internet congestionprovider=ctcp", 1, True 
Err.Clear 

Rem >> RDP << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\fAllowToGetHelp", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\fDenyTSConnections", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\DWMFRAMEINTERVAL", 15, "REG_DWORD" 
 
Rem >> Regdone << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\RegDone", 1, "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RemoteRegistry\Start", 4, "REG_DWORD"  

Rem >> Automatische Fehlerbehebung, Fehlerberichterstattung und Diagnosedaten << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting\DoReport", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PCHealth\ErrorReporting\ShowUI", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey\EnableEventTranscript", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\AllowTelemetry", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\MaxTelemetryAllowed", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Disabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsMitigation\UserPreference", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules\NumberOfSIUFInPeriod", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds", 0, "REG_DWORD" 
 
Rem >> Mouse-, Touchpad- und Tastatur-Fix (optimiert die Mousebeschleunigung, Mouse, Touchpad und Tastatur werden präziser) << 
Err.Clear 
On Error Resume Next 
rem Const HKCU = &H80000001 
KeyPath = "Control Panel\Mouse" 
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & ".\root\default:StdRegProv") 
 
ValueName = "SmoothMouseXCurve" 
iValues = Array(&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00, _ 
	&H00,&Ha0,&H00,&H00,&H00,&H00,&H00,&H00, _ 
	&H00,&H40,&H01,&H00,&H00,&H00,&H00,&H00, _ 
	&H00,&H80,&H02,&H00,&H00,&H00,&H00,&H00, _ 
	&H00,&H00,&H05,&H00,&H00,&H00,&H00,&H00) 
oReg.SetBinaryValue HKCU,KeyPath,ValueName,iValues 
 
ValueName = "SmoothMouseYCurve" 
iValues = Array(&H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00, _ 
	&H66,&Ha6,&H02,&H00,&H00,&H00,&H00,&H00, _ 
	&Hcd,&H4c,&H05,&H00,&H00,&H00,&H00,&H00, _ 
	&Ha0,&H99,&H0a,&H00,&H00,&H00,&H00,&H00, _ 
	&H38,&H33,&H15,&H00,&H00,&H00,&H00,&H00) 
oReg.SetBinaryValue HKCU,KeyPath,ValueName,iValues 
 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism\AttractionRectInsetInDIPS", 5, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism\DistanceThresholdInDIPS", 40, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism\MagnetismDelayInMilliseconds", 50, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism\MagnetismUpdateIntervalInMilliseconds", 16, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism\VelocityInDIPSPerSecond", 360, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed\CursorSensitivity", 100, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed\CursorUpdateInterval", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed\IRRemoteNavigationDelta", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\hyperkbd\Parameters\CrashOnCtrlScroll", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters\CrashOnCtrlScroll", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters\CrashOnCtrlScroll", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters\KeyboardDataQueueSize", 300, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters\MouseDataQueueSize", 300, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters\PollStatusIterations", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters\SampleRate", 200, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Kbdclass\Parameters\KeyboardDataQueueSize", 300, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Mouclass\Parameters\MouseDataQueueSize", 300, "REG_DWORD"  
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USB\DisableSelectiveSuspend", 1, "REG_DWORD"  
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\WheelScrollLines", 3, "REG_SZ" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\ActiveWindowTracking", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\DoubleClickSpeed", 400, "REG_SZ" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\MouseSensitivity", 20, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\MouseSpeed", 2, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\MouseThreshold1", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\MouseThreshold2", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Mouse\MouseTrails", 0, "REG_SZ" 
REM WSHShell.RegWrite "HKEY_USERS\.DEFAULT\Control Panel\Keyboard\InitialKeyboardIndicators", 2, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Keyboard\InitialKeyboardIndicators", 2, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Keyboard\KeyboardDelay", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Keyboard\KeyboardSpeed", 31, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\AutoRepeatDelay", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\AutoRepeatRate", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\BounceTime", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\DelayBeforeAcceptance", 0, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\Flags", 122, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\Last BounceKey Setting", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\Last Valid Delay", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\Last Valid Repeat", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response\Last Valid Wait", 1000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys\Flags", 62, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys\Flags", 506, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys\Flags", 58, "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Sound on Activation", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Accessibility\Warning Sounds", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Console\CtrlKeyShortcutsDisabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Input\IsInputAppPreloadEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Shell\USB\NotifyOnUsbErrors", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EdgeTargetDockedState", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnableAutocorrection", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnableDoubleTapSpace", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnableEmbeddedInkControl", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnableKeyAudioFeedback", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnablePredictionSpaceInsertion", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnableSpellchecking", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7\EnableTextPrediction", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad\AAPThreshold", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad\CursorSpeed", 10, "REG_DWORD" 
 
Rem >> Gaming-Performance Optimieren << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\GameBar\AllowAutoGameMode", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\GameBar\AutoGameModeEnabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR\EchoCancellationEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR\HistoricalCaptureEnabled", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\System\GameConfigStore\GameDVR_DXGIHonorFSEWindowsCompatible", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\System\GameConfigStore\GameDVR_EFSEFeatureFlags", 0, "REG_DWORD" 
REM WSHShell.RegWrite "HKEY_CURRENT_USER\System\GameConfigStore\GameDVR_Enabled", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\System\GameConfigStore\GameDVR_FSEBehavior", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\System\GameConfigStore\GameDVR_FSEBehaviorMode", 2, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\System\GameConfigStore\GameDVR_HonorUserFSEBehaviorMode", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\AlwaysOn", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\NetworkThrottlingIndex", -1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\NoLazyMode", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\SystemResponsiveness", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio\GPU Priority", 8, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio\Priority", 6, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\Affinity", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\BackgroundPriority", 8, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\GPU Priority", 8, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\Latency Sensitive", "True", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\Priority", 8, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\Scheduling Category", "High", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing\SFIO Priority", "High", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games\Affinity", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games\GPU Priority", 8, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games\Latency Sensitive", "True", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games\Priority", 6, "REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games\Scheduling Category", "High", "REG_SZ" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games\SFIO Priority", "High", "REG_SZ" 

Rem >> Windows-Media-Player optimieren << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Player\Settings\EnableDVDUI", "yes", "REG_SZ" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\AppColorBlackBackground", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\CustomBufferTime", 2000, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\MaxBandwidth", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\SendUserGUID", 0, "REG_BINARY"  
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\UsageTracking", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\UseDefaultBufferTime", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences\Volume", 100, "REG_DWORD" 

Rem >> Office Optimieren << 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Common\Graphics\DisableAnimations", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Common\Graphics\DisableHardwareAcceleration", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Common\Graphics\DisableAnimations", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Common\Graphics\DisableHardwareAcceleration", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Graphics\DisableAnimations", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Graphics\DisableHardwareAcceleration", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\18.0\Common\Graphics\DisableAnimations", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\18.0\Common\Graphics\DisableHardwareAcceleration", 1, "REG_DWORD" 
 
Rem >> Alexa ausschalten << 
Err.Clear 
On Error Resume Next 
WshShell.run "Reg Delete " & "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Extentions\c95fe080-8f5d-112d-a20b-00aa003c157a\"  & " /f" 

Rem >> Vorgaben für Cleanmgr.exe << 
Err.Clear 
On Error Resume Next 
Set objShell = CreateObject("WScript.Shell")
rem Const HKEY_LOCAL_MACHINE = &H80000002
strComputer = "."
Set objRegistry = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & strComputer & "\root\default:StdRegProv")
strRegRoot = HKEY_LOCAL_MACHINE
strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
If objRegistry.EnumKey(strRegRoot, strKey, arrKeyNames) = 0 Then
If IsNull(arrKeyNames) = False Then 
For Each strKeyName In arrKeyNames
If Right(strKey, 1) = "\" Then
strFullPath = strKey & strKeyName
Else
strFullPath = strKey & "\" & strKeyName
End If
objRegistry.SetDWORDValue strRegRoot, strFullPath, "StateFlags", 1
objRegistry.SetDWORDValue strRegRoot, strFullPath, "Priority", 300 
Next
End If
End If	
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files\StateFlags", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files\LastAccess", 2,"REG_DWORD" 
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\01", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\04", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\08", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\1024", 1,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\2048", 7,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\256", 30,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\32", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\512", 0,"REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\StoragePoliciesNotified", 1,"REG_DWORD" 
Err.Clear 
 
Rem >> %temp% delete << 
Err.Clear 
On Error Resume Next 
WshShell.Run "cmd.exe /c del /F /S /Q %temp%", 1, True 
Err.Clear  
On Error Resume Next 
WshShell.Run "cmd.exe /c del /F /S /Q %Windir%\Temp", 1, True 
Err.Clear  
 
Rem >> Explorer.exe neu starten << 
Err.Clear 
On Error Resume Next  
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell", 1, "REG_DWORD" 
WshShell.Run "gpupdate /force", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "Explorer.exe", 1, True 
Err.Clear 
 
Rem >> Store reset << 
Err.Clear 
On Error Resume Next 
For Each Process in GetObject("winmgmts:"). _ 
ExecQuery ("select * from Win32_Process where name='WinStore.App.exe'") 
Process.terminate(0) 
next 
Err.Clear 
On Error Resume Next 
WshShell.Run "cmd.exe /c net start wuauserv & net start bits", 3, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "winget source reset --force", 1, True 
Err.Clear 
On Error Resume Next 
If WinValue = "10." then WshShell.Run "winget source update", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "WSReset.exe -i", 1, True 
Err.Clear 
End Sub  

Sub DirectX ()
Err.Clear 
On Error Resume Next   
If Language = "deutsch" then DX = MsgBox ("Möchten Sie im Anschluß zusätzlich an die Anpassung " _ 
& vbNewLine & "durch den " & title & " noch alle optionalen " _ 
& vbNewLine & "DirectX-Laufzeitkomponenten Installieren und Aktualisieren?? ", _ 
vbSystemModal + vbYesNo, Version) 

If Language = "english" then DX = MsgBox ("Do you want to install and update all optional " _ 
& vbNewLine & "DirectX-Runtime-Components? ", _ 
vbSystemModal + vbYesNo, Version) 
If DX = vbYes then DXOpt
Err.Clear 
End Sub

Sub DXOpt ()
Err.Clear 
On Error Resume Next   
Downloads = WSHShell.Regread ("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\{374DE290-123F-4565-9164-39C4925E467B}") 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Start-BitsTransfer -Source https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe -Destination " & Downloads & " -v"), 1, True  
Err.Clear 

On Error Resume Next 
Dim fso, filepath
set fso = CreateObject("Scripting.FileSystemObject")
filepath = Downloads & "\dxwebsetup.exe"
if fso.FileExists(filepath) then
    WshShell.run filepath, 1, True 
End if
Err.Clear 

On Error Resume Next 
Dim fso2, deletefilepath
set fso2 = CreateObject("Scripting.FileSystemObject")
deletefilepath = Downloads & "\dxwebsetup.exe"
if fso2.FileExists(deletefilepath) then
    fso2.DeleteFile deletefilepath, True
End if 
Err.Clear 
End Sub 

Sub UpdateAllApps ()
Err.Clear 
On Error Resume Next   
If Language = "deutsch" then UpdateApps = MsgBox ("Möchten Sie im Anschluß zusätzlich an die Anpassung " _ 
& vbNewLine & "durch den " & title & " noch alle installierten Programme Aktualisieren?? " & vbNewLine _ 
& vbNewLine & "Dieser Vorgang kann mehrere Minuten dauern. ", _ 
vbSystemModal + vbYesNo, Version) 

If Language = "english" then UpdateApps = MsgBox ("Do you want to update all installed Programms? " & vbNewLine _ 
& vbNewLine & "This Process can take a few minutes. ", _ 
vbSystemModal + vbYesNo, Version) 
If UpdateApps = vbYes then WshShell.Run "winget upgrade --accept-source-agreements --all", 3, True 
Err.Clear 
End Sub 
 
Rem >> Optimize-Windows << 
Err.Clear 
On Error Resume Next 
Set objShell = CreateObject("Shell.Application")
Call objShell.MinimizeAll
Err.Clear 
On Error Resume Next 
Set objShell = WScript.CreateObject("WScript.Shell") 
Err.Clear 
start = Timer 
On Error Resume Next 
If SystemOptimizer = "yes" then winOpt 
Err.Clear 
On Error Resume Next 
ende = Timer 
DirectX
Err.Clear 
restart = Timer 
On Error Resume Next 
ende = Timer 
If WinValue = "10." then UpdateAllApps
Err.Clear 
restart = Timer 
On Error Resume Next 
If HDOptimizer = "yes" then HDOpt 
Err.Clear 

Rem >> Abschliessend alle Hintergrundprozesse Ausführen << 
On Error Resume Next 
WshShell.Run "cmd.exe /c net start wuauserv & net start bits", 3, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "wuauclt.exe /resetauthorization /detectnow", 1, True 
Err.Clear 
On Error Resume Next  
WshShell.Run "cmd.exe /c cd %ProgramFiles%\Windows Defender && MpCmdRun.exe -removedefinitions -dynamicsignatures && MpCmdRun.exe -SignatureUpdate", 1, true 
Err.Clear 
On Error Resume Next 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command Update-MpSignature -UpdateSource MicrosoftUpdateServer -v"), 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run """" & WshShell.SpecialFolders("AllUsersStartup") & "\AUTOSTART-OPTIMIZER.vbs""", 1, True 
Err.Clear 
On Error Resume Next 
WshShell.Run "Rundll32.exe advapi32.dll,ProcessIdleTasks", 1, False 
Err.Clear 
On Error Resume Next 
WshShell.Run "mschedexe.exe start", 1, False 
Err.Clear 
On Error Resume Next 
WshShell.Run "taskkill /f /fi “status eq not responding”", 1, True 
Err.Clear 

On Error Resume Next  
Const Above_Normal = 32768  
strComputer = "." 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")  
Set colProcesses = objWMIService.ExecQuery _ 
("Select * from Win32_Process Where Name = 'Explorer.exe'")  
For Each objProcess in colProcesses  
objProcess.SetPriority(Above_Normal)  
Next 
Set WshShell = Nothing 
Set objShell = Nothing 
ende = Timer 
 
 
Rem >> Finish Installation <<
Err.Clear 
On Error Resume Next 
If Language = "deutsch" Then shutdown = MsgBox (winversioncheck &" wurde erfolgreich optimiert!!! " & vbNewLine & vbNewLine & "Zeit (sec.) :" & vbTab & ende-start _ 
& vbNewLine & vbNewLine & "Das Anpassen von " & WinVersionCheck & " ist jetzt abgeschlossen und " _ 
& vbNewLine & "wird nach dem nächsten Neustart vollständig wirksam... " _ 
& vbNewLine & vbNewLine & "Besucht unsere offizielle Projekt-Gruppe unter: " _ 
& vbNewLine & "https://www.facebook.com/groups/WindowsOptimizer " _ 
& vbNewLine & vbNewLine & "Besucht unser offizielles GitHub-Projekt unter: " _ 
& vbNewLine & "https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER " _ 
& vbNewLine & vbNewLine & "Das System jetzt neu starten? ", _ 
vbSystemModal + vbOKCancel, Version) 

If Language = "english" Then shutdown = MsgBox (winversioncheck &" was optimized successfully!!! " & vbNewLine & vbNewLine & "Time (sec.) :" & vbTab & ende-start _ 
& vbNewLine & vbNewLine & "Adjusting " & WinVersionCheck & " is now complete and " _ 
& vbNewLine & "will take effect after the next reboot... " _ 
& vbNewLine & vbNewLine & "Don´t forget to visit our official Project-Group: " _ 
& vbNewLine & "https://www.facebook.com/groups/WindowsOptimizer " _ 
& vbNewLine & vbNewLine & "Don´t forget to visit our official GitHub-Project: " _ 
& vbNewLine & "https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER " _ 
& vbNewLine & vbNewLine & "Restart the System now? ", _ 
vbSystemModal + vbOKCancel, Version) 
If shutdown <> vbOK then WScript.Quit 
 
Err.Clear 
On Error Resume Next 
Set OpSysSet = GetObject("winmgmts:{(Shutdown)}//./root/cimv2").ExecQuery("select * from Win32_OperatingSystem where Primary=true") 
for each OpSys in OpSysSet 
OpSys.Reboot() 
next 
Err.Clear 
WScript.Quit 
 
 
rem 	******************************************************************* 
rem 	* WINDOWS-OPTIMIZER-PROJECT 					  * 
rem 	* -written by 							  * 
rem 	* René Bengsch							  * 
rem 	* info/contact @ 						  * 
rem 	* https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER  * 
rem 	* https://facebook.com/groups/WindowsOptimizer			  * 
rem 	* e-m@il: hammanit@web.de 	 				  * 
rem 	******************************************************************* 
 