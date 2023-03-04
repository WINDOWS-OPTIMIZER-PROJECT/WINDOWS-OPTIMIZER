
Rem >> CurrentVersion << 
title = "!c3 THE DARK LIGHT "
revision = "v.1.1 (Beta1) " 
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
MsgBox "WELL DONE... " ,vbSystemModal+vbExclamation, Version 
Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 

sub ItsGettinDark () 
Err.Clear 
On Error Resume Next 
DARKSIDE = MsgBox ("COME TO THE DARK SIDE!! ", vbSystemModal + vbOKCancel, Version) 
If DARKSIDE <> vbOK then AbortMessage: WScript.quit 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\SystemUsesLightTheme", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 0, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\Theme", 1, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
MsgBox "DONE... " ,vbSystemModal+vbExclamation, Version 
Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 

sub ItsGettinBright () 
Err.Clear 
On Error Resume Next 
LIGHTSIDE = MsgBox ("FOLLOW ME INTO THE LIGHT!! ", vbSystemModal + vbOKCancel, Version) 
If LIGHTSIDE <> vbOK then AbortMessage: WScript.quit 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\SystemUsesLightTheme", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 1, "REG_DWORD" 
WSHShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\Theme", 0, "REG_DWORD" 
Err.Clear 
On Error Resume Next 
MsgBox "DONE... " ,vbSystemModal+vbExclamation, Version 
Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit 
end Sub 
 
Key1 = WSHShell.RegRead ("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\SystemUsesLightTheme")
Key2 = WSHShell.RegRead ("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme")

If Key1 <> 0 or Key2 <> 0 then ItsGettinDark 
If Key1 = 0 and Key2 = 0 then ItsGettinBright

Set WshShell = Nothing 
Set objShell = Nothing 
WScript.Quit
 
 
rem 	***************************************** 
rem 	* !c3 THE DARK LIGHT 	 	    	* 
rem 	* -written by 			    	* 
rem 	* René Bengsch 			    	* 
rem 	* info/contact @ 		    	* 
rem 	* facebook.com/groups/WindowsOptimizer 	* 
rem 	* e-m@il: senseless-creature@web.de 	* 
rem 	***************************************** 
 
