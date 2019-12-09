@echo off
mode con: cols=15 lines=1
echo SWH_TestFileAdmin > %windir%\SWH_TestFileAdmin.tmp
if not exist %windir%\SWH_TestFileAdmin.tmp (set admin=0) else (
	set admin=1 & del "%WinDir%\SWH_TestFileAdmin.tmp" /q /f 
	echo MsgBox "Starting SWH Setup...",4160,"Starting SWH Setup..." > "%tmp%\startset.vbs"
	start WScript.exe "%tmp%\startset.vbs"
)
if not %admin%==0 (goto startSetup)
:RunSWHSetupAsAdmin
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\AdminSWH.vbs
echo If WScript.Arguments.Length = 0 Then >> %tmp%\AdminSWH.vbs
echo   Set ObjShell = CreateObject("Shell.Application") >> %tmp%\AdminSWH.vbs
echo   ObjShell.ShellExecute "wscript.exe" _ >> %tmp%\AdminSWH.vbs
echo     , """" ^& WScript.ScriptFullName ^& """ /admin", , "RunAs",1 >> %tmp%\AdminSWH.vbs
echo   WScript.Quit >> %tmp%\AdminSWH.vbs
echo End if >> %tmp%\AdminSWH.vbs
echo Set ObjShell = CreateObject("WScript.Shell") >> %tmp%\AdminSWH.vbs
echo objShell.Run "cmd.exe /c %~0",vbHide >> %tmp%\AdminSWH.vbs
start "WScript.exe" "%tmp%\AdminSWH.vbs"
timeout /t 2 /nobreak>nul
exit /B
:startSetup
set route=%tmp%
cd /d %route%
 
if exist "%tmp%\cancelswh.tmp" (del "%tmp%\cancelswh.tmp" /q)
set nx=%~nx0
set dp=%~dp0
md %tmp%\SWH_Setup
if exist Setup.vbs (del Setup.vbs /q)
rem Scripting Windows Host Setup
rem Made by anic17
set swhPath=%localappdata%\ScriptingWindowsHost
set dir=%~dp0
title Scripting Windows Host Installer
if exist %localappdata%\ScriptingWindowsHost\SWH.* (goto uninstall)
:install
cd /d "%tmp%"
rem Cancel button
echo taskkill /f /im wscript.exe > "%tmp%\RestartSWHSetup.bat"
echo start wscript.exe "%tmp%\Setup.vbs" >> "%tmp%\RestartSWHSetup.bat"
echo exit >> "%tmp%\RestartSWHSetup.bat"


set download_ps1=%tmp%\SWH_Setup\DownloadSWH.ps1

echo $Url = "https://raw.githubusercontent.com/anic17/SWH/master/SWH.bat" > %download_ps1%
echo $output = "%swhPath%\SWH.bat" >> %download_ps1%
echo $start_time = Get-Date >> %download_ps1%
echo Invoke-WebRequest -Uri $url -OutFile $output >> %download_ps1%



rem Setup Starts
rem Setup.vbs



echo @taskkill /f /fi "windowtitle eq Starting SWH Setup..."^>nul > KillMsgStartSetup.bat






echo Set oFSO = CreateObject("Scripting.FileSystemObject") >> Setup.vbs
echo Set oLogFile = oFSO.OpenTextFile("IResult.txt", 2, True) >> Setup.vbs
echo Set oShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo strHost = "www.google.com" >> Setup.vbs
echo strPingCommand = "ping -n 1 -w 1000 " ^& strHost >> Setup.vbs
echo ReturnCode = oShell.Run(strPingCommand, 0 , True) >> Setup.vbs
echo If ReturnCode ^<^> 0 Then  >> Setup.vbs
echo 	oLogFile.WriteLine "Internet=Disconnected"  >> Setup.vbs
echo 	Set objShell = CreateObject("WScript.Shell") >> Setup.vbs
echo 	objShell.Run "cmd.exe /c KillMsgStartSetup.bat",vbHide >> Setup.vbs
echo 	nointernet=msgbox("Error! Cannot connect to the Internet. SWH Setup downloads the files to ensure that you install the newest version",4112,"Cannot connect to the Internet") >> Setup.vbs
echo End If >> Setup.vbs
echo oLogFile.Close >> Setup.vbs


if exist IResult.txt del IResult.txt
start /wait "wscript.exe" "Setup.vbs"
for %%i in (IResult.txt) do (if %%~zi gtr 20 taskkill /f /fi "windowtitle eq Starting SWH Setup..." & exit)
del Setup.vbs /q
del IResult.txt /q
del KillMsgStartSetup.bat /q


:alreadycheckedinternetconnection
echo strScriptHost = LCase(Wscript.FullName) >> Setup.vbs
echo If Right(strScriptHost, 11) ^<^> "wscript.exe" Then >> Setup.vbs
echo 	cscript=msgbox("Please run SWH Setup with wscript.exe",4112,"Please run SWH Setup with wscript.exe") >> Setup.vbs
echo 	CScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo Dim FSO >> Setup.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo setupfirst=msgbox("Welcome to the Scripting Windows Host setup."^&vbLf^&vbLf^&"This wizard will install Scripting Windows Host on your computer."^&vbLf^&"Click OK to install Scripting Windows Host"^&vbLf^&vbLf^&vbLf^&"Created by anic17."^&vbLf^&"https://github.com/anic17/SWH",4353,"Scripting Windows Host Setup") >> Setup.vbs
echo if setupfirst = vbCancel then >> Setup.vbs
echo 	cancelFirstSetup=msgbox("Are you sure you want to close SWH Setup?",4148,"Close SWH Setup?") >> Setup.vbs
echo 	if cancelFirstSetup = vbYes Then >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo 	If cancelFirstSetup = vbNo Then >> Setup.vbs
echo 		Set objFSO = createobject("scripting.filesystemobject")  >> Setup.vbs
echo 		Set exitYN = objfso.createtextfile("cancelswh.tmp",true) >> Setup.vbs  
echo 		exitYN.writeline "Cancel=0" >> Setup.vbs
echo 		exitYN.close >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		objShell.Run "cmd.exe /c del %tmp%\cancelswh.tmp /q",vbHide >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs
echo license=Msgbox("To install SWH you must agree the license. By clicking OK you agree the terms of condition."^&vbLf^&""^&vbLf^&"Scripting Windows Host License:"^&vbLf^&vbLf^&"You can modify SWH and his sub-tools, but only to make SWH better for everyone."^&vbLf^&"If you don't know what you are installing, you need to know that you are installing a terminal, like CMD, PowerShell, Bash..."^&vbLf^&"But the thing that makes SWH special is that is the easiest way to use a terminal."^&vbLf^&"If you need help when you are using SWH, type 'help' to view command list."^&vbLf^&""^&vblf^&"2019, anic17",4353,"By clicking OK you agree terms of condition") >> Setup.vbs
echo if license = vbCancel Then >> Setup.vbs
echo 	nolic=Msgbox("You must to accept the license to install SWH",4112,"You need to accept the license to install SWH") >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo do >> Setup.vbs
echo installing=Msgbox("Click OK to install SWH in your computer."^&vbLf^&"The program will be installed in:"^&vbLf^&"%localappdata%\ScriptingWindowsHost"^&vbLf^&vbLf^&vbLf^&"System requeirements:"^&vbLf^&vbLf^&"    - An operating system of Windows Vista or next."^&vbLf^&"    - Windows PowerShell Version 5.0"^&vbLf^&"    - File execution in PowerShell enabled",4097,"Click OK to install SWH") >> Setup.vbs
echo if installing = vbOK Then >> Setup.vbs
echo 	CreateObject("WScript.Shell").Popup "Creating SWH directories and Keys.."^&vblf^&"13%% completed", 1, "Creating SWH directories and Keys...",4096 >> Setup.vbs
echo 	objShell.Run "reg.exe add HKCU\Software\ScriptingWindowsHost",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKCU\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Settings",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\SWHZip",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\MyProjects",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Temp",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Downloads",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\OldSWH",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %tmp%\SWH_Setup",vbHide >> Setup.vbs
echo 	objShell.Run "powershell.exe %download_ps1%",vbHide >> Setup.vbs
echo 	CreateObject("WScript.Shell").Popup "Downloading SWH..."^&vblf^&"54%% completed", 1, "Downloading SWH...",4096 >> Setup.vbs
echo 	objShell.Run "xcopy %~0 %tmp%\SWH_Setup /o /x /k /q /y",vbHide >> Setup.vbs
echo 	CreateObject("WScript.Shell").Popup "Installing SWH... 76%%", 1, "Installing SWH...",4096 >> Setup.vbs
echo 	objShell.Run "cmd /c copy %~0 %swhPath%\Uninstall.bat",vbHide >> Setup.vbs
echo 	WScript.Sleep(100) >> Setup.vbs
echo 	Set FSO = CreateObject("Scripting.FileSystemObject") >> Setup.vbs
echo 	If fso.FileExists("%swhPath%\SWH.bat") Then >> Setup.vbs
echo 		finish=MsgBox("SWH was successfully installed on your computer",4160,"SWH was successfully installed on your computer") >> Setup.vbs
echo		launch=MsgBox("Start SWH",4132,"Start SWH") >> Setup.vbs
echo 		if launch = vbYes Then >> Setup.vbs
echo 			objShell.Run "cmd.exe /c %swhPath%\SWH" >> Setup.vbs
echo 			objShell.Run "taskkill.exe /f /im reg.exe",vbHide >> Setup.vbs
echo 			objShell.Run "taskkill.exe /f /im xcopy.exe",vbHide >> Setup.vbs
echo 			WScript.Quit >> Setup.vbs
echo 		Else >> Setup.vbs
echo 			WScript.Quit >> Setup.vbs
echo 		End If >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		notinstall=MsgBox("Error installing SWH!"^&vbLf^&"Try this:"^&vbLf^&vbLf^&"    - Check your Internet connection. SWH Setup downloads all       necessary files from the Internet, to ensure that you're               installing the newest SWH version."^&vbLf^&vbLf^&"    - Check if during installation process do you haven't                    deleted any setup file."^&vbLf^&vbLf^&"    - Check if you have WindowsPowerShell in your computer,          and if script execution is enabled. If scripts execution are           disabled, open PowerShell as administrator and type this:"^&vbLf^&vbLf^&"      Set-ExecutionPolicy Unrestricted"^&vbLf^&vbLf^&"If after all of this steps SWH didn't work, download SWH with this URL:"^&vbLf^&"https://github.com/anic17/SWH",4112,"Error installing SWH") >> Setup.vbs
echo 		WScript.Quit>> Setup.vbs
echo 		End If >> Setup.vbs
echo Else >> Setup.vbs
echo 	cancelins=MsgBox("Cancel SWH installation?",4132,"Cancel SWH installation?") >> Setup.vbs
echo 	If cancelins = vbYes Then >> Setup.vbs
echo 		cancelledtrueinstall=MsgBox("SWH installation cancelled",4160,"SWH installation cancelled") >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs >> Setup.vbs
echo End if >> Setup.vbs
echo loop >> Setup.vbs

rem Clean Temporary SWH files
:startSetupVBS
taskkill /f /fi "windowtitle eq Starting SWH Setup..."
start /wait wscript.exe Setup.vbs
taskkill /im notepad.exe
if exist "%tmp%\cancelswh.tmp" (
	del "%tmp%\cancelswh.tmp" /q
	goto startSetupVBS
)
del "%tmp%\Setup.vbs" /q
del "%tmp%\RestartSWHSetup.bat" /q
del "%download_ps1%" /q
exit /b

:uninstall
rem SWH is already installed. Uninstall?
taskkill /f /fi "windowtitle eq Starting SWH Setup..."
echo strScriptHost = LCase(Wscript.FullName) > Setup.vbs
echo If Right(strScriptHost, 11) ^<^> "wscript.exe" Then >> Setup.vbs
echo 	cscript=msgbox("Please run SWH Setup with wscript.exe",4112,"Please run SWH Setup with wscript.exe") >> Setup.vbs
echo 	CScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo already=msgbox("SWH is already installed in your computer. Do you want to uninstall it?",4388,"SWH is already installed. Uninstall?") >> Setup.vbs
echo if already = vbNo Then >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo Else >> Setup.vbs
echo 	sureunins=msgbox("Are you sure you want to uninstall SWH? and all of his components?"^&vbLf^&"Setup will remove:"^&vbLf^&vbLf^&"%swhPath%"^&vbLf^&"    - SWH Settings, programs, downloads and logs"^&vbLf^&vbLf^&"%programfiles%\SWH"^&vbLf^&"    - SWH Databases"^&vbLf^&vbLf^&vbLf^&"Uninstalling SWH will delete all of this files!"^&vbLf^&vbLf^&"Proceed with SWH uninstallation?",4388,"Are you sure you want to uninstall SWH?") >> Setup.vbs
echo 		if sureunins = vbYes Then >> Setup.vbs
echo 		objShell.Run "cmd.exe /c rd %localappdata%\ScriptingWindowsHost /s /q",vbHide >> Setup.vbs
echo 		objShell.Run "reg.exe delete HKCU\Software\ScriptingWindowsHost /f",vbHide >> Setup.vbs
echo 		objShell.Run "cmd.exe /c rd %programfiles%\SWH /s /q",vbHide >> Setup.vbs
echo 		unins=msgbox("SWH was successfully removed from your computer",4160,"SWH was successfully removed from your computer") >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs
start /wait wscript.exe Setup.vbs
taskkill /f /im xcopy.exe
taskkill /f /im reg.exe
timeout /t 5 /nobreak>nul
del RestartSWHSetup.bat /q>nul
exit /B
