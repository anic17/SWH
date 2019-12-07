@echo off
:startSetup
if exist "%tmp%\cancelswh.tmp" (del "%tmp%\cancelswh.tmp" /q)
set nx=%~nx0
set dp=%~dp0
md %tmp%\SWH_Setup
set route=%tmp%
cd /d %route%
mode con: cols=15 lines=1
if exist Setup.vbs (del Setup.vbs /q)
rem Scripting Windows Host Setup
rem Made by anic17
rem Copyright 2019 SWH 
set swhPath=%localappdata%\ScriptingWindowsHost
set dir=%~dp0
title Scripting Windows Host Installer
echo SWH_TestFileAdmin > %windir%\SWH_TestFileAdmin.tmp
if not exist %windir%\SWH_TestFileAdmin.tmp (goto erroradmin) else (del %windir%\SWH_TestFileAdmin.tmp /q /f)
if exist %localappdata%\ScriptingWindowsHost\SWH.* (goto uninstall)
:install
cd /d %tmp%

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

echo strScriptHost = LCase(Wscript.FullName) > Setup.vbs
echo If Right(strScriptHost, 11) ^<^> "wscript.exe" Then >> Setup.vbs
echo 	cscript=msgbox("Please run SWH Setup with wscript.exe",4112,"Please run SWH Setup with wscript.exe") >> Setup.vbs
echo 	CScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo setupfirst=msgbox("Welcome to the Scripting Windows Host setup. This wizard will install SWH on your computer. Click OK to install SWH.",4353,"Scripting Windows Host Setup") >> Setup.vbs
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

echo startlic=Msgbox("Please read carefully the license",4096,"Please read carefully the license") >> Setup.vbs
echo license=Msgbox("To install SWH you must agree the license. By clicking OK you agree the terms of condition."^&vbLf^&""^&vbLf^&"Scripting Windows Host License:"^&vbLf^&""^&vbLf^&"To install SWH, you must agree terms of service of SWH"^&vblf^&"Terms of service:"^&vbLf^&""^&vbLf^&"You can modify SWH and his sub-tools, but only to make SWH better for everyone."^&vbLf^&"If you don't know what you are installing, you need to know that you are installing a terminal, like CMD, PowerShell, Bash..."^&vbLf^&"But the thing that makes SWH special is that is the easiest way to use a terminal."^&vbLf^&"If you need help when you are using SWH, type 'help' to view command list."^&vbLf^&""^&vblf^&"2019, anic17",4353,"By clicking OK you agree terms of condition") >> Setup.vbs
echo if license = vbCancel Then >> Setup.vbs
echo 	nolic=Msgbox("You must to accept the license to install SWH",4112,"You need to accept the license to install SWH") >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo installing=Msgbox("Click OK to install SWH in your computer."^&vbLf^&"The program will be installed in :"^&vbLf^&"%localappdata%\ScriptingWindowsHost",4097,"Click OK to install SWH") >> Setup.vbs
echo if installing = vbOK Then >> Setup.vbs
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
echo 	WScript.Sleep(100) >> Setup.vbs
echo 	objShell.Run "powershell.exe %download_ps1%",vbHide >> Setup.vbs
echo 	objShell.Run "xcopy %~0 %tmp%\SWH_Setup /o /x /k /q /y",vbHide >> Setup.vbs
echo 	objShell.Run "xcopy %~0 %swhPath%\Uninstall.%~x0 /o /x /k /q /y",vbHide >> Setup.vbs
echo 	WScript.Sleep(750) >> Setup.vbs
echo 	finish=MsgBox("SWH was succefully installed on your computer",4160,"SWH was succefully installed on your computer") >> Setup.vbs
echo 	launch=MsgBox("Launch SWH",4132,"Launch SWH") >> Setup.vbs
echo 	if launch = vbYes Then >> Setup.vbs
echo 		objShell.Run "cmd.exe /c %swhPath%\SWH" >> Setup.vbs
echo 		objShell.Run "taskkill.exe /f /im reg.exe" >> Setup.vbs
echo 		objShell.Run "taskkill.exe /f /im xcopy.exe" >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo Else >> Setup.vbs
echo 	cancelins=MsgBox("SWH installation cancelled",4160,"SWH installation cancelled") >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo End if >> Setup.vbs

rem Clean Temporary SWH files
:startSetupVBS
start /wait wscript.exe Setup.vbs
taskkill /im notepad.exe
if exist "%tmp%\cancelswh.tmp" (
	del "%tmp%\cancelswh.tmp" /q
	goto startSetupVBS
)
del %tmp%\Setup.vbs /q
del %tmp%\license.txt /q
del %tmp%\RestartSWHSetup.bat
exit /b

:erroradmin
echo erroradmin=Msgbox("Please run SWH Setup as administrator",4112,"Please run SWH Setup as administrator") > erroradmin.vbs
start /wait wscript.exe erroradmin.vbs
del erroradmin.vbs /q
exit /b

:uninstall
rem SWH is already installed. Uninstall?

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
echo 	sureunins=msgbox("Are you sure you want to uninstall SWH?",4388,"Are you sure you want to uninstall SWH?") >> Setup.vbs
echo 		if sureunins = vbYes Then >> Setup.vbs
echo 		objShell.Run "cmd.exe /c rd %localappdata%\ScriptingWindowsHost /s /q",vbHide >> Setup.vbs
echo 		objShell.Run "reg.exe delete HKCU\Software\ScriptingWindowsHost /f",vbHide
echo 		unins=msgbox("SWH was succefully removed from your computer",4160,"SWH was succefully removed from your computer") >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs
start /wait wscript.exe Setup.vbs
taskkill /f /im xcopy.exe
taskkill /f /im reg.exe
del Setup.vbs /q>nul
del RestartSWHSetup.bat /q>nul
exit /B



