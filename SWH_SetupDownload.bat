@echo off

title Scripting Windows Host Setup
cd /d "%tmp%"



PowerShell -Command Invoke-WebRequest -Uri "https://raw.githubusercontent.com/anic17/SWH/master/SWH_Setup.bat" -OutFile "%CD%\SWH_Setup.bat"
start /min PowerShell.exe "%tmp%\DownloadSWH_Setup.ps1"
echo Set WshShell = CreateObject("WScript.Shell") > SWH_SetupHidder.vbs
echo WshShell.Run "cmd.exe /C SWH_Setup.bat",vbHide >> SWH_SetupHidder.vbs
timeo
CScript.exe "SWH_SetupHidder.vbs" //nologo //b
