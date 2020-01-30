@echo off
mode con: cols=15 lines=1

set execNumber=%execNumber%+1
set route=%tmp%
cd /d %route%

if /i "%~x0"==".EXE" set extsetup=exe
if /i "%~x0"==".BAT" set extsetup=bat
if /i "%~x0"==".COM" set extsetup=com
if /i "%~x0"==".CMD" set extsetup=cmd
if /i "%~x0"==".PIF" set extsetup=pif

setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set winversion=%%i.%%j

if "%winversion%" == "5.2" (goto notcompatiblewindows)
if "%winversion%" == "5.1" (goto notcompatiblewindows)
endlocal
set swhPath=%localappdata%\ScriptingWindowsHost
if "%1"=="/repair" (goto repair)


echo SWH_TestFileAdmin > %windir%\SWH_TestFileAdmin.tmp
if not exist %windir%\SWH_TestFileAdmin.tmp (set admin=0) else (
	set admin=1 & del "%WinDir%\SWH_TestFileAdmin.tmp" /q /f 
	echo MsgBox "Starting SWH Setup...",4160,"Starting SWH Setup..." > "%tmp%\startset.vbs"
	start WScript.exe "%tmp%\startset.vbs"
)
if %admin%==1 if %execNumber%==1 goto RunSWHSetupAsAdmin
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
echo objShell.Run "cmd.exe /c %~0 %quietunins%",vbHide >> %tmp%\AdminSWH.vbs
start "WScript.exe" "%tmp%\AdminSWH.vbs"
exit /B

:startSetup 
if exist "%tmp%\cancelswh.tmp" (del "%tmp%\cancelswh.tmp" /q)
set nx=%~nx0
set dp=%~dp0
md "%tmp%\SWH_Setup"
if exist Setup.vbs (del Setup.vbs /q)
rem Scripting Windows Host Setup
rem Made by anic17
set dir=%~dp0
if "%1"=="/quietunins" (goto quietuninstall & set quietunins=/quietunins)
title Scripting Windows Host Setup - Do not close this window
if exist "%localappdata%\ScriptingWindowsHost\SWH*.bat" if exist "%swhPath%\Installed.swhtmp" (goto uninstallchk)
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

set download_icon=%tmp%\SWH_Setup\DownloadIcon.ps1

echo $Url = "https://raw.githubusercontent.com/anic17/SWH/data/IconSWH.ico" > %download_icon%
echo $output = "%swhPath%\Icon\IconSWH.ico" >> %download_icon%
echo $start_time = Get-Date >> %download_icon%
echo Invoke-WebRequest -Uri $url -OutFile $output >> %download_icon%

set download_setup=%tmp%\UpdateSWH_Setup.ps1

echo $Url = "https://raw.githubusercontent.com/anic17/SWH/master/SWH_Setup.bat" > %download_setup%
echo $output = "%tmp%\UpdateSWH_Setup.bat" >> %download_setup%
echo $start_time = Get-Date >> %download_setup%
echo Invoke-WebRequest -Uri $url -OutFile $output >> %download_setup%



::https://raw.githubusercontent.com/anic17/SWH/data/IconSWH.ico


set download_calc=%tmp%\SWH_Setup\DownloadCalculator.ps1

echo $Url = "https://raw.githubusercontent.com/anic17/SWH/data/SWH_Calc.exe" > %download_calc%
echo $output = "%swhPath%\pkg\SWH_Calc.exe" >> %download_calc%
echo $start_time = Get-Date >> %download_calc%
echo Invoke-WebRequest -Uri $url -OutFile $output >> %download_calc%



echo Invoke-WebRequest -Uri "https://raw.githubusercontent.com/anic17/SWH/VBSlib_VBSedit.Toolkit/vbsedit32.dll" -OutFile "%swhPath%\DLL\vbsedit32.dll" > "%tmp%\SWH_Setup\OpenMenuDLL.ps1"
echo Invoke-WebRequest -Uri "https://raw.githubusercontent.com/anic17/SWH/VBSlib_VBSedit.Toolkit/vbsedit64.dll" -OutFile "%swhPath%\DLL\vbsedit64.dll" >> "%tmp%\SWH_Setup\OpenMenuDLL.ps1"


::https://raw.githubusercontent.com/anic17/SWH/data/SWH_Calc.exe


rem Setup Starts
rem Setup.vbs
copy %0 "%tmp%\SWH_Setup.bat">nul




echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console" /f^>nul > ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console" /v Icon /t REG_SZ /d "%swhPath%\Icon\IconSWH.ico" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console\command" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console\command" /d "%swhPath%\SWH.bat" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console" /v ExtendedSubCommandsKey /t REG_SZ /d "Directory\ContextMenus\Scripting Windows Host Console" ^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console" /v MUIVerb /t REG_SZ /d "Scripting Windows Host Console"
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\openswh\command" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\openswh" /v Icon /t REG_SZ /d "%swhPath%\Icon\IconSWH.ico" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\openswh" /v MUIVerb /t REG_SZ /d "Open Scripting Windows Host Console here" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\openswh\command" /d "%windir%\System32\cmd.exe /c %swhPath%\SWH.bat /execdir %%%%V" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\runas" /v MUIVerb /t REG_SZ /d "Open Scripting Windows Host Console here as administrator" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\runas\command" /d "%windir%\System32\cmd.exe /c %swhPath%\SWH.bat /execdir %%%%V" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\runas" /v Icon /t REG_SZ /d "%swhPath%\Icon\IconSWH.ico" /f^>nul >> ContextMenuSWH.bat
echo @reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console\shell\runas" /v HasLUAShield /t REG_SZ /f^>nul >> ContextMenuSWH.bat







echo @cd /d "%userprofile%\Desktop%"
echo @ren "SWH Console.lnk" "SWH.lnk" > LnkSWH.bat
echo @timeout /t 2 /nobreak^>nul >> LnkSWH.bat
echo @ren "SWH.lnk" "SWH Console.lnk" >> LnkSWH.bat

echo @taskkill /f /fi "windowtitle eq Starting SWH Setup..."^>nul > KillMsgStartSetup.bat



echo #Do NOT modify this file, this file contains installation information;: InstallDir=C:\Users\andre\AppData\Local\ScriptingWindowsHost; UninstallSWH=C:\Users\andre\AppData\Local\ScriptingWindowsHost\Uninstall.bat; Version=bat version ^> %swhPath%\Installed.swhtmp > %tmp%\SWH_Setup\Install.bat


echo Set oFSO = CreateObject("Scripting.FileSystemObject") > Setup.vbs
echo Set oLogFile = oFSO.OpenTextFile("IResult.txt", 2, True) >> Setup.vbs
echo Set oShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo strHost = "www.google.com" >> Setup.vbs
echo strPingCommand = "ping -n 2 -w 1000" ^& strHost >> Setup.vbs
echo ReturnCode = oShell.Run(strPingCommand, 0 , True) >> Setup.vbs
echo WScript.Sleep(500) >> Setup.vbs
echo If ReturnCode ^<^> 0 Then  >> Setup.vbs
echo 	oLogFile.WriteLine "Internet=Disconnected"  >> Setup.vbs
echo 	Set objShell = CreateObject("WScript.Shell") >> Setup.vbs
echo 	objShell.Run "cmd.exe /c KillMsgStartSetup.bat",vbHide >> Setup.vbs
echo 	nointernet=msgbox("Error! Cannot connect to the Internet. SWH Setup downloads the files to ensure that you install the newest version."^&vbLf^&"If you are connected to the Internet, try running SWH Setup another time."^&vbLf^&vbLf^&"If you have already the portable version, you can install it. Do you want to browse for SWH?",4116,"Cannot connect to the Internet") >> Setup.vbs
echo 	If nointernet = vbNo Then WScript.Quit >> Setup.vbs
echo 	Set wShell=CreateObject("WScript.Shell")  >> Setup.vbs
echo 	Set oExec=wShell.Exec("mshta.exe ""about:<title>Select file</title><input type=file id=FILE><script>FILE.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);close();resizeTo(0,0);</script>""")  >> Setup.vbs
echo 	sFileSelected = oExec.StdOut.ReadLine >> Setup.vbs
echo 	If Not oFSO.FileExists(sFileSelected) Then >> Setup.vbs
echo 		msgbox "SWH Setup cannot find the following file:"^&vbLf^&sFileSelected^&"SWH Setup cannot find the following file:"
echo 	Else >> Setup.vbs
echo 		oFSO.CopyFile sFileSelected, "%tmp%\SWH.bat" >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs
echo oLogFile.Close >> Setup.vbs

if exist IResult.txt del IResult.txt
start /wait "wscript.exe" "Setup.vbs"
for /f "tokens=1,2* delims=," %%I in (IResult.txt) do (set iresultcontent=%%I)
for %%i in (IResult.txt) do (if %%~zi gtr 20 taskkill /f /fi "windowtitle eq Starting SWH Setup...")
del Setup.vbs /q
del IResult.txt /q
del KillMsgStartSetup.bat /q
if /i "%iresultcontent%"=="Internet=Disconnected" if not exist "%tmp%\SWH.bat" exit /B

echo @reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v DisplayName /t REG_SZ /d "Scripting Windows Host Console" /f > RegDisplayNameSWH.bat



:alreadycheckedinternetconnection
echo strScriptHost = LCase(Wscript.FullName) > Setup.vbs
echo If Right(strScriptHost, 11) ^<^> "wscript.exe" Then >> Setup.vbs
echo 	cscript=msgbox("Please run SWH Setup with wscript.exe",4112,"Please run SWH Setup with wscript.exe") >> Setup.vbs
echo 	CScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo Dim FSO >> Setup.vbs



echo setupfirst=msgbox("Welcome to the Scripting Windows Host setup."^&vbLf^&vbLf^&"This wizard will %rebadinstall%install Scripting Windows Host on your computer."^&vbLf^&"Click OK to %rebadinstall%install Scripting Windows Host. %badinstall%"^&vbLf^&vbLf^&"It is recomended to close all applications before %rebadinstall%installing"^&vbLf^&"Scripting Windows Host."^&vbLf^&vbLf^&vbLf^&"Created by anic17."^&vbLf^&"https://github.com/anic17/SWH",4353,"Scripting Windows Host Setup") >> Setup.vbs
echo if setupfirst = vbCancel then >> Setup.vbs
echo 	cancelFirstSetup=msgbox("Are you sure you want to close SWH Setup?",4148,"Close SWH Setup?") >> Setup.vbs
echo 	if cancelFirstSetup = vbYes Then >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo 	If cancelFirstSetup = vbNo Then >> Setup.vbs
echo 		Set objfso = CreateObject("Scripting.FileSystemObject") >> Setup.vbs
echo 		Set exitYN = objfso.createtextfile("cancelswh.tmp",true) >> Setup.vbs  
echo 		exitYN.writeline "Cancel=0" >> Setup.vbs
echo 		exitYN.close >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		objShell.Run "cmd.exe /c del %tmp%\cancelswh.tmp /q",vbHide >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs
if "%rebadinstall%"=="re" goto nextBadIns1
echo license=Msgbox("To install Scripting Windows Host you must agree the license. By clicking OK and installing Scripting Windows Host you agree the terms of condition."^&vbLf^&""^&vbLf^&"Scripting Windows Host License:"^&vbLf^&vbLf^&"You can modify SWH and his sub-tools, but only to make SWH better for everyone."^&vbLf^&"If you don't know what you are installing, you need to know that you are installing a terminal, like CMD, PowerShell, Bash..."^&vbLf^&"But the thing that makes SWH special is that is the easiest way to use a terminal."^&vbLf^&"If you need help when you are using SWH, type 'help' to view command list."^&vbLf^&"To view more information about Scripting Windows Host Console, please look at the file called %~dp0SWH_Info.txt"^&vbLf^&vbLf^&"2019 - 2020, anic17",4353,"By clicking OK you agree terms of condition") >> Setup.vbs
echo if license = vbCancel Then >> Setup.vbs
echo 	nolic=Msgbox("You must to agree the license to install SWH",4112,"You must agree the license to install SWH") >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
:nextBadIns1
echo do >> Setup.vbs
echo installing=Msgbox("Click OK to %rebadinstall%install SWH in your computer."^&vbLf^&"The program will be %rebadinstall%installed in:"^&vbLf^&"%localappdata%\ScriptingWindowsHost"^&vbLf^&vbLf^&vbLf^&"System requeirements:"^&vbLf^&vbLf^&"    - An operating system of Windows Vista or earlier."^&vbLf^&"    - Windows PowerShell Version 5.0"^&vbLf^&"    - File execution in PowerShell enabled"^&vbLf^&vbLf^&"After %rebadinstall%installation, 1065 kB of disk space will be used.",4097,"Click OK to %rebadinstall%install SWH") >> Setup.vbs
echo if installing = vbOK Then >> Setup.vbs
if "%rebadinstall%"=="re" goto nextBadIns2:nextBadIns2
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo 	objShell.Run "reg.exe add HKCU\Software\ScriptingWindowsHost",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKCU\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v InstallLocation /t REG_SZ /d %localappdata%\ScriptingWindowsHost /f",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c %tmp%\RegDisplayNameSWH.bat",vbHide >> Setup.vbs




echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v NoRepair /t REG_DWORD /d 1 /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v NoModify /t REG_DWORD /d 1 /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v DisplayVersion /t REG_SZ /d 10.2.2 /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v UninstallString /t REG_SZ /d %localappdata%\ScriptingWindowsHost\Uninstall.%extsetup% /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v QuietUninstallString /t REG_SZ /d %localappdata%\ScriptingWindowsHost\Uninstall.%extsetup% /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v Publisher /t REG_SZ /d anic17 /f",vbHide >> Setup.vbs
echo 	objShell.Run "reg.exe add HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /v DisplayIcon /t REG_SZ /d %localappdata%\ScriptingWindowsHost\Icon\IconSWH.ico /f",vbHide >> Setup.vbs

echo 	objShell.Run "cmd.exe /c %tmp%\ContextMenuSWH.bat",vbHide,True >> Setup.vbs

echo 	objShell.Run "cmd.exe /c mkdir %swhPath%",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Settings",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\SWHZip",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\MyProjects",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Temp",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Downloads",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\OldSWH",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\Icon",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\DLL",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %swhPath%\pkg",vbHide >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %tmp%\SWH_Setup",vbHide >> Setup.vbs
echo 	Set FSO = CreateObject("Scripting.FileSystemObject")
echo 	FSO.CreateFolder("%programfiles%\SWH\")
echo 	FSO.CreateFolder("%programfiles%\SWH\.config")
echo 	FSO.CreateFolder("%programfiles%\SWH\ApplicationData")
echo 	FSO.CreateFolder("%programdata%\Microsoft\Windows\Start Menu\Programs\ScriptingWindowsHost")
echo 	objShell.Run "powershell.exe %download_calc%",vbHide,True >> Setup.vbs
echo 	Set FSO = CreateObject("Scripting.FileSystemObject") >> Setup.vbs
echo 	If FSO.FileExists("%tmp%\SWH.bat") Then  >> Setup.vbs
echo 		FSO.CopyFile "%tmp%\SWH.bat","%swhPath%\SWH.bat" >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		objShell.Run "powershell.exe %download_ps1%",vbHide,True >> Setup.vbs
echo 	End If >> Setup.vbs
if "%rebadinstall%"=="re" goto nextBadIns3
echo 	CreateObject("WScript.Shell").Popup "Downloading SWH from "^&vblf^&"https://github.com/anic17/SWH/blob/master/SWH.bat...", 1, "Downloading SWH...",4096 >> Setup.vbs
:nextBadIns3
echo 	objShell.Run "powershell.exe %download_icon%",vbHide,True >> Setup.vbs
echo 	objShell.Run "xcopy %~0 %tmp%\SWH_Setup /o /x /k /q /y",vbHide,True >> Setup.vbs
if "%rebadinstall%"=="re" goto nextBadIns4
echo 	CreateObject("WScript.Shell").Popup "Installing SWH in %swhPath%..."^&vblf^&"", 1, "Installing SWH...",4096 >> Setup.vbs
:nextBadIns4
echo 	objShell.Run "cmd /c copy %~0 %swhPath%\Uninstall.%extsetup%",vbHide >> Setup.vbs
echo 	If fso.FileExists("%localappdata%\ScriptingWindowsHost\SWH.bat") Then >> Setup.vbs
echo    	Set lnk = objShell.CreateShortcut("%userprofile%\Desktop\SWH Console.lnk") >> Setup.vbs
echo    	lnk.TargetPath = "%swhPath%\SWH.bat" >> Setup.vbs
echo    	lnk.Arguments = "" >> Setup.vbs
echo    	lnk.Description = "Scripting Windows Host Console" >> Setup.vbs
echo    	lnk.IconLocation = "%swhPath%\Icon\IconSWH.ico, 0" >> Setup.vbs
echo    	lnk.WindowStyle = "1" >> Setup.vbs
echo    	lnk.WorkingDirectory = "%swhPath%" >> Setup.vbs
echo   		lnk.Save >> Setup.vbs
echo    	Set lnk = Nothing >> Setup.vbs


echo    	Set lnk = objShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ScriptingWindowsHost\SWH Console.lnk") >> Setup.vbs
echo    	lnk.TargetPath = "%swhPath%\SWH.bat" >> Setup.vbs
echo    	lnk.Arguments = "" >> Setup.vbs
echo   		lnk.Description = "Scripting Windows Host Console" >> Setup.vbs
echo    	lnk.IconLocation = "%swhPath%\Icon\IconSWH.ico, 0" >> Setup.vbs
echo   		lnk.WindowStyle = "1" >> Setup.vbs
echo   		lnk.WorkingDirectory = "%swhPath%" >> Setup.vbs
echo   		lnk.Save >> Setup.vbs
echo   		Set lnk = Nothing >> Setup.vbs

echo 			FSO.CopyFile "%userprofile%\Desktop\SWH Console.lnk", "%swhPath%\SWH.lnk" >> Setup.vbs
echo 			objShell.Run "cmd.exe /c %tmp%\SWH_Setup\Install.bat",vbHide >> Setup.vbs
echo 		finish=MsgBox("SWH was successfully %rebadinstall%installed on your computer",4160,"SWH was successfully %rebadinstall%installed on your computer") >> Setup.vbs
echo		launch=MsgBox("Start SWH",4132,"Start SWH") >> Setup.vbs
echo 		if launch = vbYes Then >> Setup.vbs
echo 			objShell.Run "cmd.exe /c %tmp%\LnkSWH.bat",vbHide >> Setup.vbs
echo 			objShell.Run "%swhPath%\SWH.lnk" >> Setup.vbs
echo 			objShell.Run "taskkill.exe /f /im reg.exe",vbHide >> Setup.vbs
echo 			objShell.Run "taskkill.exe /f /im xcopy.exe",vbHide >> Setup.vbs
echo 			WScript.Sleep(500) >> Setup.vbs 
echo 			FSO.DeleteFile "%swhPath%\SWH.lnk" >> Setup.vbs
echo 			WScript.Quit >> Setup.vbs
echo 		Else >> Setup.vbs
echo 			WScript.Quit >> Setup.vbs
echo 		End If >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		notinstall=MsgBox("Error installing SWH!"^&vbLf^&"Try this:"^&vbLf^&vbLf^&"    - Check your Internet connection. SWH Setup downloads all       necessary files from the Internet, to ensure that you're               installing the newest SWH version."^&vbLf^&vbLf^&"    - Check if during installation process do you haven't                    deleted any setup file."^&vbLf^&vbLf^&"    - Check if you have WindowsPowerShell in your computer,          and if script execution is enabled. If scripts execution are           disabled, open PowerShell as administrator and type this:"^&vbLf^&vbLf^&"      Set-ExecutionPolicy Unrestricted"^&vbLf^&vbLf^&"If after all of this steps SWH didn't work, download SWH with this URL:"^&vbLf^&"https://github.com/anic17/SWH",4112,"Error installing SWH") >> Setup.vbs
echo 		WScript.Quit>> Setup.vbs
echo 	End If >> Setup.vbs
echo Else >> Setup.vbs
echo 	cancelins=MsgBox("Cancel SWH %rebadinstall%installation?",4132,"Cancel SWH %rebadinstall%installation?") >> Setup.vbs
echo 	If cancelins = vbYes Then >> Setup.vbs
echo 		cancelledtrueinstall=MsgBox("SWH %rebadinstall%installation cancelled",4160,"SWH %rebadinstall%installation cancelled") >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs >> Setup.vbs
echo End if >> Setup.vbs
echo loop >> Setup.vbs

rem Clean Temporary SWH files
:startSetupVBS
taskkill /f /fi "windowtitle eq Starting SWH Setup..."

FOR /F "usebackq tokens=3*" %%A IN (`reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy`) DO (
    set pwsh_filepermission=%%A %%B
)
echo %pwsh_filepermission%

if /i not "%pwsh_filepermission%"=="Unrestricted" (
	reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d "Unrestricted" /f
)
echo %pwsh_filepermission% > %tmp%\pwsh_filepermission.txt
for /f "tokens=1,2* delims=," %%U in (pwsh_filepermission.txt) do (set restrictedPWSH=%%U)

start /wait wscript.exe Setup.vbs



if /i not "%restrictedPWSH%"=="Unrestricted" (
	reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d "Restricted" /f
)






if exist "%tmp%\cancelswh.tmp" (
	del "%tmp%\cancelswh.tmp" /q
	goto startSetupVBS
)
del "%tmp%\Setup.vbs" /q
del "%tmp%\RestartSWHSetup.bat" /q
del "%download_ps1%" /q
del *SWH*.vbs /q>nul
del *SWH*.ps1 /q>nul
del RegDisplayNameSWH.bat /q>nul
del startset.vbs /q>nul
del AdminSWH.vbs /q>nul
del LnkSWH.bat /q>nul
exit /b


:uninstallchk
if not "%cd%"=="%swhPath%" (cd /d "%swhPath%")
for /f "tokens=1,2* delims=," %%D in (Installed.tmp) do (set contentinstalled=%%D)
for %%d in (Installed.swhtmp) do (set installfilesizeswh=%%~zd)

if %installfilesizeswh% gtr 200 (goto uninstall) else (
	set rebadinstall=re
	set badinstall=SWH is installed, but some files are damaged. A reinstallation is required for use of SWH.	goto install
)

:uninstall
rem SWH is already installed. Uninstall?
cd /d "%tmp%"


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
echo 		objShell.Run "cmd.exe /c %tmp%\DelSWHlnk.bat",vbHide >> Setup.vbs
echo 		objShell.Run "cmd.exe /c %tmp%\UninstallContextMenuSWH.bat",vbHide,True >> Setup.vbs
echo 		objShell.Run "reg.exe delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ScriptingWindowsHost /f",vbHide >> Setup.vbs
echo 		unins=msgbox("SWH was successfully removed from your computer",4160,"SWH was successfully removed from your computer") >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs

echo @del "%userprofile%\Desktop\SWH*.lnk" /q > DelSWHlnk.bat
taskkill /f /fi "windowtitle eq Starting SWH Setup..."

echo @reg.exe delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Scripting Windows Host Console" /f^>nul > UninstallContextMenuSWH.bat
echo @reg.exe delete "HKEY_CLASSES_ROOT\Directory\ContextMenus\Scripting Windows Host Console" /f^>nul >> UninstallContextMenuSWH.bat
 





start /wait wscript.exe Setup.vbs
taskkill /f /im xcopy.exe
taskkill /f /im reg.exe
timeout /t 3 /nobreak>nul
del RestartSWHSetup.bat /q>nul
del *SWH*.vbs /q>nul
del *SWH*.ps1 /q>nul
del startset.vbs /q>nul
del Setup.vbs /q>nul
exit /B


:quietuninstall
if not exist "%localappdata%\ScriptingWindowsHost\Installed.swhtmp" goto cannotquietunins
rd "%localappdata%\ScriptingWindowsHost" /s /q
echo quietunins=MsgBox("SWH has been successfully uninstalled",4160,"SWH has been successfully uninstalled") > Setup.vbs
start /wait setup.vbs
exit /B


:cannotquietunins
echo notinstalled=MsgBox("Cannot uninstall SWH: SWH isn't installed",4112,"Cannot uninstall SWH") > Setup.vbs
start /wait setup.vbs
exit /B


:repair
cd /d "%tmp%"
echo.
echo repair=Msgbox("Do you want to check if the installation of Scripting Windows Host has errors?",4132,"Do you want to check if the installation of Scripting Windows Host has errors") > Setup.vbs
echo if repair = vbNo Then >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo End If >> Setup.vbs


echo Set FSO = CreateObject("Scripting.FileSystemObject") >> Setup.vbs
echo Set objShell = CreateObject("WScript.Shell") >> Setup.vbs
echo If not FSO.FileExists("%swhPath%\SWH.bat") Then >> Setup.vbs >> Setup.vbs
echo 	errornotfoundswh=MsgBox("Founded error: Cannot find"^&vbLf^&"%swhPath%\SWH.bat"^&vbLf^&"A SWH reinstallation is required. Would you run Scripting Windows Host Setup another time to repair it?",4132,"Cannot find SWH.bat - A reinstallation is required") >> Setup.vbs
echo 	If errornotfoundswh = vbYes Then >> Setup.vbs
echo 		objShell.Run "cmd.exe /c %tmp%\SWH_Setup.bat" >> Setup.vbs
echo 		WScript.Sleep(2000) >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 	End If >> Setup.vbs
echo ElseIf not FSO.FileExists("%swhPath%\Uninstall.bat") Then >> Setup.vbs
echo 	FSO.CopyFile "%~0", "%swhPath%\Uninstall.bat" >> Setup.vbs
echo End If >> Setup.vbs
echo finishrepair=msgbox("SWH has finished searching errors: No errors were found",4160,"SWH has finished searching errors: No errors were found") >> Setup.vbs
echo WScript.Quit >> Setup.vbs
start /wait WScript.exe "%tmp%\Setup.vbs"
del Setup.vbs /q>nul
exit /B





::Script to check errors



:notcompatiblewindows
echo.
echo notcompatiblewindows=MsgBox("Cannot install Scripting Windows Host Console:"^&vbLf^&"This version of Windows is incompatible. "^&vbLf^&"Please use Windows Vista or a earlier version to install Scripting Windows Host Console",4112,"Cannot install Scripting Windows Host Console") > ErrSWH_OS.vbs
start wscript.exe ErrSWH_OS.vbs
exit /B


