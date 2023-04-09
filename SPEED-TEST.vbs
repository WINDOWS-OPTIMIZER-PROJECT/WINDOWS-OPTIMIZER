 
Rem 	************************************************* 
Rem 	* !c3 SPEED-TEST 				* 
Rem 	* Dieses Tool testet die Leistung des Computers * 
Rem	************************************************* 
 
Rem >> CurrentVersion << 
title = "!c3 SPEED-TEST "
revision = "v.1.3.01 (Beta1) "
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
if Language = "deutsch" then MsgBox "Vorgang abgebrochen... ",vbSystemModal+vbExclamation, Version 
if Language = "english" then MsgBox "Operation canceled... ",vbSystemModal+vbExclamation, Version 
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

Rem >> SPEED-TEST << 
Err.Clear 
On Error Resume Next 
If Language = "deutsch" then SPEEDTEST = MsgBox (winversioncheck &" wurde erfolgreich erkannt. " _ 
& vbNewLine & Speicher &" MB RAM wurden für Windows reserviert. " & vbNewLine _ 
& vbNewLine & "Dieses Tool testet die Leistung des Computers - Dieser Vorgang kann ein paar Minuten dauern. " & vbNewLine _ 
& vbNewLine & "Leistungstest jetzt starten? ", _ 
vbSystemModal + vbOKCancel, Version) 
If Language = "english" then SPEEDTEST = MsgBox (winversioncheck &" was successfully recognized. " _ 
& vbNewLine & Speicher &" MB RAM were reserved for Windows. " & vbNewLine _ 
& vbNewLine & "This tool tests the performance of the Computer - This may take a few minutes. " & vbNewLine _ 
& vbNewLine & "Start the Performance-Test now? ", _ 
vbSystemModal + vbOKCancel, Version) 
If SPEEDTEST <> vbOK then AbortMessage: WScript.quit 
If SPEEDTEST = vbOK then Performancetest

Sub Performancetest ()
Rem >> Minimize All << 
Err.Clear 
On Error Resume Next 
Set objShell = CreateObject("Shell.Application")
Call objShell.MinimizeAll
Err.Clear 
On Error Resume Next 
Set objShell = WScript.CreateObject("WScript.Shell") 
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
start = Timer 
objShell.Run ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command winsat formal -v -restart clean"), 3, True 
ende = Timer
Err.Clear 
On Error Resume Next 
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell", 1, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
WshShell.Run "Explorer.exe", 1, True 
Err.Clear 
On Error Resume Next 
CPUScore = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT\CPUScore")
Err.Clear 
On Error Resume Next 
MemoryScore = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT\MemoryScore")
Err.Clear 
On Error Resume Next 
GraphicsScore = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT\DWMScore")
Err.Clear 
On Error Resume Next 
D3DScore = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT\D3DScore")
Err.Clear 
On Error Resume Next 
DiskScore = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT\DiskScore")
Err.Clear 
On Error Resume Next 
WinSPRLevel = WSHShell.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT\WinCRSScore")
Err.Clear 
On Error Resume Next 

If Language = "deutsch" Then shutdown = MsgBox (winversioncheck &" wurde erfolgreich getestet!!! " & vbNewLine _ 
& vbNewLine & "Zeit (sec.) :" & vbTab & vbTab & ende-start _ 
& vbNewLine & vbNewLine & "Gesamtbewertung: " & vbTab & WinSPRLevel/10 & vbNewLine _ 
& vbNewLine & "Komponente " & vbTab & vbTab & "Teilbewertung" _ 
& vbNewLine & "Prozessor: " & vbTab & vbTab & CPUScore/10 _ 
& vbNewLine & "Arbeitsspeicher (RAM): " & vbTab & MemoryScore/10 _ 
& vbNewLine & "Grafik: " & vbTab & vbTab & vbTab & GraphicsScore/10 _ 
& vbNewLine & "Direct3D: " & vbTab & vbTab & D3DScore/10 _ 
& vbNewLine & "Primäre Festplatte: " & vbTab & DiskScore/10 _ 
& vbNewLine & vbNewLine & "Besucht unsere offizielle Projekt-Gruppe unter: " _ 
& vbNewLine & "https://www.facebook.com/groups/WindowsOptimizer " _ 
& vbNewLine & vbNewLine & "Besucht unser offizielles GitHub-Projekt unter: " _ 
& vbNewLine & "https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER " _ 
& vbNewLine & vbNewLine & "Test wiederholen? ", _ 
vbSystemModal + vbOKCancel, Version) 
If Language = "english" Then shutdown = MsgBox (winversioncheck &" was tested successfully!!! " & vbNewLine _ 
& vbNewLine & "Time (sec.) :" & vbTab & vbTab & ende-start _ 
& vbNewLine & vbNewLine & "System Base-Score: " & vbTab & WinSPRLevel/10 & vbNewLine _ 
& vbNewLine & "Component " & vbTab & vbTab & "Subscore" _ 
& vbNewLine & "Processor: " & vbTab & vbTab & CPUScore/10 _ 
& vbNewLine & "Memory (RAM): " & vbTab  & vbTab & MemoryScore/10 _ 
& vbNewLine & "Graphics: " & vbTab & vbTab & GraphicsScore/10 _ 
& vbNewLine & "Direct3D: " & vbTab & vbTab & D3DScore/10 _ 
& vbNewLine & "Primary hard drive: " & vbTab & DiskScore/10 _ 
& vbNewLine & vbNewLine & "Don´t forget to visit our official Project-Group: " _ 
& vbNewLine & "https://www.facebook.com/groups/WindowsOptimizer " _ 
& vbNewLine & vbNewLine & "Don´t forget to visit our official GitHub-Project: " _ 
& vbNewLine & "https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER " _ 
& vbNewLine & vbNewLine & "Repeat Performance-Test? ", _ 
vbSystemModal + vbOKCancel, Version) 
If shutdown <> vbOK then WScript.Quit 
If shutdown = vbOK then Performancetest
end sub

Set WshShell = Nothing 
Set objShell = Nothing 
Err.Clear 
WScript.Quit 
 
 
rem 	******************************************************************* 
rem 	* !c3 WINDOWS-OPTIMIZER 					  * 
rem 	* -written by 							  * 
rem 	* René Bengsch							  * 
rem 	* info/contact @ 						  * 
rem 	* https://github.com/WINDOWS-OPTIMIZER-PROJECT/WINDOWS-OPTIMIZER  * 
rem 	* facebook.com/groups/WindowsOptimizer				  * 
rem 	* e-m@il: hammanit@web.de 	 				  * 
rem 	******************************************************************* 
 