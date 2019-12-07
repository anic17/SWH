@echo off
mode con: cols=15 lines=1
title Scripting Windows Host Setup
cd /d "%tmp%"
echo $Url = "https://raw.githubusercontent.com/anic17/SWH/master/SWH_Setup.bat" > DownloadSWH_Setup.ps1
echo $output = "SWH_Setup.bat" >> DownloadSWH_Setup.ps1
echo $start_time = Get-Date >> DownloadSWH_Setup.ps1
echo Invoke-WebRequest -Uri $url -OutFile $output >> DownloadSWH_Setup.ps1
start /min PowerShell.exe "%tmp%\DownloadSWH_Setup.ps1"
echo Set WshShell = CreateObject("WScript.Shell") > SWH_SetupHidder.vbs
echo WshShell.Run "cmd.exe /C SWH_Setup.bat",vbHide >> SWH_SetupHidder.vbs
timeout /t 1 /nobreak>nul
start WScript.exe "SWH_SetupHidder.vbs"