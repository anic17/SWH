@echo off
if "%~1"=="" goto help

set "__char1__=%~1"
set "__char1__=%__char1__:~0,1%"

if not defined pathswh set pathswh=%LOCALAPPDATA%\ScriptingWindowsHost
if /i "%__char1__%"=="v" goto version
if /i "%__char1__%"=="k" goto kernelversion
if /i "%__char1__%"=="b" goto build
if /i "%__char1__%"=="r" goto release


if /i "%__char1__%"=="s" goto sid
echo Could not find '%1' entry in Windows.cmd
goto :EOF



:help
echo.
echo Syntax:
echo.
echo import windows parameter [variable] [import options]
echo.
echo Examples:
echo.
echo import windows version winver
echo Will import that library with version option, and save the result into variable 'winver'
echo.
echo import windows sid %username% usersid
echo Will set the variable 'usersid' to the sid of %username%
goto :EOF

:version
for /f "tokens=3* delims= " %%A in ('reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do if "%~2"=="" (echo %%A %%B) else (set "%~2=%%A %%B")

goto :EOF


:sid


if "%~3"=="" (set "_____Usr__swh__=%username%") else (set "_____Usr__swh__=%~3")
wmic useraccount where name="%_____Usr__swh__%" get sid | findstr /c:"-" > "%pathswh%\Temp\user.sid"
for /f "usebackq" %%A in ("%pathswh%\Temp\user.sid") do if not "%~2"=="" (set "%~2=%%A") else (echo %%A)
goto :EOF


:kernelversion
for /f "usebackq tokens=4-6 delims=] " %%I in (`ver`) do for /f "tokens=1,2 delims=." %%J in ("%%I") do if not "%~2"=="" (set "%~2=%%I") else (echo %%I)
exit /B

:build
for /f "tokens=3* delims= " %%A in ('reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do if "%~2"=="" (echo %%A %%B) else (set "%~2=%%A %%B")
exit /B

:release
for /f "tokens=3* delims= " %%A in ('reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId"') do if "%~2"=="" (echo %%A %%B) else (set "%~2=%%A")
exit /B