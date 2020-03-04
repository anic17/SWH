cls
@echo off
:SWH_InitFirst
echo [%date% %time%] - SWH Started in %computername% > %localappdata%\ScriptingWindowsHost\StartLog.log
set execdate=%date%
set exectime=%time%
set execdir=%cd%
set execname=%~nx0

mode con: cols=120 lines=30
set moreCMD=0
set pathswh=%localappdata%\ScriptingWindowsHost
if "%os%"=="Windows_NT" (goto startingWindowsNT)

echo SWH is not compatible with this version of Windows
echo.
echo SWH is compatible with Windows Vista and next (Recomended Windows 10)
echo Would you run SWH anyways knowing this version of Windows is not compatible? (Y/N)
choice /c:NY /N
if errorlevel 2 (goto startingWindowsNT)
if errorlevel 1 (exit /B)
if exist "%pathswh%\SWH.bat" (goto chkifinstalled) else (set installedswh=0 & goto startingWindowsNT)

:chkifinstalled
if exist "%pathswh%\Installed.swhtmp" (set installedswh=1) else (set installedswh=0)


:startingWindowsNT
md "%localappdata%\ScriptingWindowsHost">nul
cls
md "%localappdata%\ScriptingWindowsHost\Temp"
cls
md "%programfiles%\SWH\.config"
cls
md "%programfiles%\SWH\ApplicationData"
cls
md "%pathswh%\OldSWH"
cls
md "%pathswh%\SWHZip"
cls
md "%pathswh%\pkg"
cls
md "%pathswh%\Icon"
cls
md "%pathswh%\MyProjects"
cls
::md "%pathswh%\Settings"
md "%pathswh%\SWHZip"
cls
set execdir_cd=0
goto regYesBlockCHK
reg add HKEY_CURRENT_USER\Software\ScriptingWindowsHost\Settings /f>nul
reg add HKEY_CURRENT_USER\Software\ScriptingWindowsHost /f>nul
cls
reg query HKEY_CURRENT_USER\Software\ScriptingWindowsHost\DisableSWH
if errorlevel 1 (reg add HKCU\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f)



if exist "%pathswh%\D.sys" (attrib +h +s "%pathswh%\D.sys")

if exist %pathswh%\resetstartlog.opt (
	for /f "tokens=1,2* delims=," %%L in (%pathswh%\resetstartlog.opt) do (set resetstartlog_=%%L)
) else (
	set resetstartlog_=1
)
cls

FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\Software\ScriptingWindowsHost" /v DisableSWH`) DO (
    set regdisableswh=%%A %%B
)

if %errorlevel%==1 (
	echo [%date% %time%] - Cannot find HKCU\Software\ScriptingWindowsHost\DisableSWH >> %pathswh%\StartLog.log
	title %~dpnx0 - Cannot find HKEY_CURRENT_USER\Software\ScriptingWindowsHost\DisableSWH
	echo Error! Cannot find HKEY_CURRENT_USER\Software\ScriptingWindowsHost\DisableSWH
	pause>nul
	reg add HKEY_CURRENT_USER\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f
	cls
)



if %regdisableswh%==0x0 (goto regYesBlockCHK)
if %regdisableswh%==0x1 (goto swhdisabledreg) else (
	echo [%date% %time%] - Invalid registry key at HKCU\Software\ScriptingWindowsHost\DisableSWH >> %pathswh%\StartLog.log
	title %~dpnx0 - Invalid registry key at HKEY_CURRENT_USER\Software\ScriptingWindowsHost\DisableSWH
	echo Error! Invalid registry key at HKEY_CURRENT_USER\Software\ScriptingWindowsHost\DisableSWH
	echo Possible values are 0 or 1
	echo.
	echo Press any key to try again...
	pause>nul
	reg add HKEY_CURRENT_USER\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f
	echo.
	goto regYesBlockCHK
)



if not "%regdisableswh%"=="0x1" goto regYesBlockCHK

:swhdisabledreg
echo [%date% %time%] - SWH Disabled by Registry >> %pathswh%\StartLog.log
title %~dpnx0 - SWH disabled by Registry
cls
echo SWH has been disabled by an administrator
echo.
echo Press any key to exit SWH...
pause>nul
exit /b

:regYesBlockCHK
echo [%date% %time%] - RegistryDisabled=0 >> %pathswh%\StartLog.log
if not exist "%homedrive%\Program Files\SWH\ApplicationData\BU.dat" (
	echo [%date% %time%] - BlockUsers=0 >> %pathswh%\StartLog.log
	goto checkingPassword
)

:chkblockusers
echo [%date% %time%] - BlockUsers=1 >> %pathswh%\StartLog.log
for /f "tokens=1,2* delims=," %%b in (%programfiles%\SWH\ApplicationData\BU.dat) do (set onlyusernotblock=%%b)
cls
if /i "%username%"=="%onlyusernotblock%" (goto checkingPassword)
echo.
title %~dpnx0 - SWH blocked for this user
echo Your SWH access was blocked because you not have the requested privileges to start it.
echo.
echo Press any key to exit SWH...
echo.
pause>nul
exit /b
:checkingPassword
if exist "%programfiles%\SWH\ApplicationData\PS.dat" (goto swhpassword) else (
	set psd=[{CLSID:8t4tvry4893tvy2nq4928trvyn14098vny84309tvny493q8tvn0943tyvnu0q943t8vn204vmy10vn05}]
	goto params_slash
)

:swhpassword
cls
:params_slash
::Parameters receptor
::if exist "%programfiles%\SWH\ApplicationData\PS.dat" (call :putpassword)
if /I "%1"=="/?" (goto usageParams_Slash)
if /I "%1"=="/h" (goto usageParams_Slash)
if /I "%1"=="/admin" (goto runSWH_Admin)
if /I "%1"=="/execdir" (goto execdir_ChangeCD)
if /I "%1"=="/c" (set next_exit=1 & goto params_Command) else (set nonexistparams=1 & goto startingswhpassword)
:params_command
echo.
set cmd="%2"
goto other1cmd

:usageParams_Slash
echo.
::Parameters help
echo Usage:
echo.
echo "%~nx0" /?                         ^| Same as /h. Shows SWH parameters help
echo "%~nx0" /admin                     ^| Runs SWH as administrator
echo "%~nx0" /c ^<command^>               ^| Executes a SWH command
echo "%~nx0" /h                         ^| Same as /?. Shows SWH parameters help
echo "%~nx0" /execdir ^<directory^>       ^| Starts SWH in a specified directory
echo.
echo Examples:
echo.
echo "%~nx0" /execdir %systemdrive%\               ^| This command will run SWH in default directory %systemdrive%\
echo "%~nx0" /c powershell              ^| This command will open Windows PowerShell
::echo "%~nx0" /p ^<password^>   ^| If the password is existent, type the password and access SWH. (Creating)
echo.
exit /B



:runSWH_Admin
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %pathswh%\Temp\AdminSWH.vbs
echo If WScript.Arguments.Length = 0 Then >> %pathswh%\Temp\AdminSWH.vbs
echo   Set ObjShell = CreateObject("Shell.Application") >> %pathswh%\Temp\AdminSWH.vbs
echo   ObjShell.ShellExecute "wscript.exe" _ >> %pathswh%\Temp\AdminSWH.vbs
echo     , """" ^& WScript.ScriptFullName ^& """ /admin", , "RunAs",1 >> %pathswh%\Temp\AdminSWH.vbs
echo   WScript.Quit >> %pathswh%\Temp\AdminSWH.vbs
echo End if >> %pathswh%\Temp\AdminSWH.vbs
echo Set ObjShell = CreateObject("WScript.Shell") >> %pathswh%\Temp\AdminSWH.vbs
echo objShell.Run "cmd.exe /c %pathswh%\SWH.bat" >> %pathswh%\Temp\AdminSWH.vbs
echo.
start wscript.exe "%pathswh%\Temp\AdminSWH.vbs"
echo.
exit /B
:nonexist_PARAMSWH
echo Error! Type "%~nx0" /? to get help about how to start SWH with parameters
echo.
goto swh

:putpassword
echo [%date% %time%] - Password=1 >> %pathswh%\StartLog.log
title %~dpnx0 - Enter the password to start SWH
set password=[{CLSID:5378cv5t593vyn539n58tv2598ty5btvy3y9vn53439t57y483wv95ntvy54tn9v5y4vtn58tvu8}]
set /p password=Password to start SWH: 

::Read encrypted password
cd /d "%programfiles%\SWH\ApplicationData"
if not exist "%pathswh%\Temp\PS.dat" (goto TryingRemovePSD)
for /f "tokens=1,2* delims=," %%P in (PS.dat) do (set cryptpassword=%%P) 
cd /d "%pathswh%\Temp"
goto firstPSDchk

:TryingRemovePSD
cd /d "%pathswh%\Temp"
echo %date%> "%pathswh%\Temp\D.sys"
attrib -h -s "%pathswh%\Temp\D.sys"
for /f "tokens=1,2* delims=," %%y in (D.sys) do (set dateBlock=%%y)
attrib +h +s "%pathswh%\Temp\D.sys"
cls

title %~dpnx0 - You are blocked from SWH! Reason: Trying to steal passwords.
echo You are blocked from SWH! Reason: Trying to steal passwords.
echo.
echo Why my SWH access is blocked?
echo.
echo 1) You tried to remove SWH password
echo 2) You tried to change it
echo.
echo So, no I will not able to start SWH?
echo.
echo Yes, you will be able to use SWH, but you need to wait 1 day

if not "%date%"=="%dateBlock%" (goto waitedday) else (goto infiniteLoop)
:infiniteLoop
pause>nul
goto infiniteLoop

:waitedday
attrib -h -s "%pathswh%\Temp\D.sys"
del "%pathswh%\Temp\D.sys" /q
goto SWH_InitFirst

:firstPSDchk
::Decrypt Password
if exist Decrypt.txt del Decrypt.txt /q
if exist Decrypt.vbs del Decrypt.vbs /q
echo Option Explicit > Decrypt.vbs
echo Dim temp, key, objShell >> Decrypt.vbs
echo Dim objFSO, Dcrypt >> Decrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Decrypt.vbs
echo temp = "%cryptpassword%" >> Decrypt.vbs
echo key = "4Ou8fa94pfx3WV3AsnhoAz7xWbtkA5T36SMX7sOB9I8WazaCirdOT1HfhBJBKvZlQDMRIGEH49vPK5KTDPTaIPVT8h3F57QW3RYbJ0WrT90Fxk3EBcMCz0APGZebZWkZH2JvGuFqs8mvICYG4uZW2MYnXwPmnVa8S4HCEgeQRPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4IRQ0261QCeJHPBj71LKIqGDbWBTrLBh8wPONCYVM0F4RPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4" >> Decrypt.vbs
echo temp = Decrypt(temp,key) >> Decrypt.vbs
echo Set objFSO = createobject("scripting.filesystemobject") >> Decrypt.vbs
echo Set Dcrypt = objfso.createtextfile("Decrypt.txt",true)  >> Decrypt.vbs
echo Dcrypt.writeline "" ^&temp >> Decrypt.vbs
echo Dcrypt.close >> Decrypt.vbs
echo Function encrypt(Str, key) >> Decrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str = StrReverse(str) >> Decrypt.vbs
echo  For x = 1 To LenStr >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = keypos+1 >> Decrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Decrypt.vbs
echo  Next >> Decrypt.vbs
echo  encrypt = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
echo Function Decrypt(str,key) >> Decrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str=StrReverse(str) >> Decrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = KeyPos+1 >> Decrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Decrypt.vbs
echo       Next >> Decrypt.vbs
echo       Newstr=StrReverse(Newstr) >> Decrypt.vbs
echo       Decrypt = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
start /Wait WScript.exe "%pathswh%\Temp\Decrypt.vbs"


cd /d "%pathswh%\Temp"
for /f "tokens=1,2* delims=," %%F in (Decrypt.txt) do (set DecryptPSD=%%F)
if "%password%"=="%DecryptPSD%" (goto startingswhpassword) else (goto failedpassword)>nul

set password2="%password%"
if %password2%=="%psd%" (goto startingswhpassword) else (goto failedpassword)>nul


:failedpassword
echo.
del "%pathswh%\Temp\Decrypt.txt" /q>nul
del "%pathswh%\Temp\Decrypt.vbs" /q>nul
echo Incorrect password! Press any key to try again...
echo [%date% %time%] Failed to access SWH. Reason: Incorrect Password: %password% >> %pathswh%\StartLog.log

pause>nul
cls
goto putpassword

:execdir_ChangeCD
set cdirectory="%~2"
set execdir_cd=1
goto next_CD_execdir

:startingswhpassword

cd /d "%programfiles%\SWH\ApplicationData"
echo [%date% %time%] - Password=0 >> %pathswh%\StartLog.log
for /f "tokens=1,2* delims=," %%p in (PS.dat) do (set psd=%%p)
rem Help more
rem Directory %localappdata%\ScriptingWindowsHost
cd /d "%pathswh%"

set cdirectory=%userprofile%
set executiondir_established=%userprofile%

set firstDirCD_=%cd%
:next_CD_execdir
if %execdir_cd%==1 (
	set cdirectory="%~2"
	set executiondir_established="%~2"
	cd /d "%~2"
)
::echo %cdirectory%

set syspathvar=0
mode cols=120 lines=30
copy %0 "%pathswh%\SWH.bat">nul
set /a sizeSWHkB=%~z0/1024
echo SWH_TestFileAdmin > "%WinDir%\SWH_TestFileAdmin.tmp"
if exist "%Windir%\SWH_TestFileAdmin.tmp" (
	set admin=1
	del "%windir%\SWH_TestFileAdmin.tmp" /q
) else (set admin=0)
set commandtoexecute=SWH: 
cls

title Starting Scripting Windows Host Console...
echo Starting Scripting Windows Host Console...

color 07
set incotext=This command does not exist. Type "help" to see the commands available
set userblock=0
set sizeverify=0
set colmodesize=0
set linemodesize=0

title Scripting Windows Host Console
cd /d "%localappdata%\ScriptingWindowsHost"
if not exist SWH_History.txt (
	echo Creating History... > SWH_History.txt
	echo Creating History... Please wait.
)

:startswh
set a=X
set g=Y
set t=Z
set r=123
set z=456
rem Start SWH
cd /d "%pathswh%\Settings"
mode con: cols=120 lines=30
if exist Size.opt (
	for /f "tokens=1,2* delims=," %%s in (Size.opt) do (mode con: %%s)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\Size.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\Size.opt >> %pathswh%\StartLog.log
)
if exist ConsoleText.opt (
	for /f "tokens=1,2* delims=," %%c in (ConsoleText.opt) do (set commandtoexecute=%%c)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\ConsoleText.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\ConsoleText.opt >> %pathswh%\StartLog.log
)
if exist DefaultTitle.opt (
	for /f "tokens=1,2* delims=," %%t in (DefaultTitle.opt) do (set title=%%t &title %title%)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\DefaultTitle.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\DefaultTitle.opt >> %pathswh%\StartLog.log
	if "%username%"=="SYSTEM" (set title= %title% - Running as NT AUTHORITY\SYSTEM) else (set title=%title%)
)
if exist DefaultDirectory.opt (
	for /f "tokens=1,2* delims=," %%d in (DefaultDirectory.opt) do (cd /d %%d &set cdirectory=%%d)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\DefaultDirectory.opt >> %pathswh%\StartLog.log
	set cdirectory=%%d
) else (
	set cdirectory=%userprofile%
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\DefaultDirectory.opt >> %pathswh%\StartLog.log
)
if exist IncorrectCommand.opt (
	for /f "tokens=1,2* delims=," %%e in (IncorrectCommand.opt) do (set incotext=%%e)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\IncorrectCommand.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\IncorrectCommand.opt >> %pathswh%\StartLog.log
)
set cmd=Enter{VD-FF24F4FV54F-TW5THW5-4Y5Y-245UNW-54NYUW}
set ver=10.5
set securever=%ver%
cls
if not "%executiondir_established%"=="%userprofile%" (cd /d "%~2") else (cd /d "%cdirectory%")
echo [%date% %time%] - SWH: Running SWH on user %username% in directory %~dp0 >> %pathswh%\StartLog.log
echo Welcome to the Scripting Windows Host Console. %xdiskcomp%
echo.
set /p cmd=%cd% %commandtoexecute%
set cmd2=%cmd%
set cmd="%cmd2%"
goto other1cmd

:cmdhelp
rem Help command More
echo. > "%pathswh%\Temp\MoreHelp"
echo Commands: >> "%pathswh%\Temp\MoreHelp"
echo.>> "%pathswh%\Temp\MoreHelp"
echo alias: Shows command aliases >> "%pathswh%\Temp\MoreHelp"
echo audiovolume: Sets the Windows audio volume >> "%pathswh%\Temp\MoreHelp"
echo base64decode: Encodes a string using Base64 >> "%pathswh%\Temp\MoreHelp"
echo base64decodefile: Decodes a file using Base64 >> "%pathswh%\Temp\MoreHelp"
echo base64encode: Decodes a string using Base64  >> "%pathswh%\Temp\MoreHelp"
echo base64encodefile: Encodes a file using Base64 >> "%pathswh%\Temp\MoreHelp"
echo blockusers: Blocks SWH if the user is not "%username%" ">> %pathswh%\Temp\MoreHelp"
echo bootmode: Starts SWH with compatibility with X: drive (Not recomended for normal use) >> "%pathswh%\Temp\MoreHelp"
echo bugs: Can see the bugs of SWH >> "%pathswh%\Temp\MoreHelp"
echo calc (or calculator): Starts SWH calculator >> "%pathswh%\Temp\MoreHelp"
echo cancelshutdown: Cancels the programmed shutdown >> "%pathswh%\Temp\MoreHelp"
echo cd: Go to a specific directory >> "%pathswh%\Temp\MoreHelp"
echo checkprocess: Checks if a specified process is running on system >> "%pathswh%\Temp\MoreHelp"
echo clear: Clears the screen of SWH >> "%pathswh%\Temp\MoreHelp"
echo clearhistory: Clears the SWH command history >> "%pathswh%\Temp\MoreHelp"
echo cleartemp: Clears the temporary files of your computer in %tmp% >> "%pathswh%\Temp\MoreHelp"
echo clearwintemp: Clears the Windows temporary files in %Systemroot%\Temp >> "%pathswh%\Temp\MoreHelp"
echo clipboard: Copies a text in the clipboard >> "%pathswh%\Temp\MoreHelp"
echo cmd: Starts Command Prompt in the current directory >> "%pathswh%\Temp\MoreHelp"
echo command: Starts MS-DOS command prompt (command.com) >> "%pathswh%\Temp\MoreHelp"
echo contact: Shows the contact information >> "%pathswh%\Temp\MoreHelp"
echo copy: Copies files of the computer >> "%pathswh%\Temp\MoreHelp"
echo credits: Shows the credits of SWH >> "%pathswh%\Temp\MoreHelp"
echo date: Changes the date of the computer >> "%pathswh%\Temp\MoreHelp"
echo decompressfile: Decompresses a file compressed with SWHZip >> "%pathswh%\Temp\MoreHelp"
echo decrypttext: Decrypts a text >> "%pathswh%\Temp\MoreHelp"
echo del: Removes a file >> "%pathswh%\Temp\MoreHelp"
echo dir (or directory): Shows the current directory >> "%pathswh%\Temp\MoreHelp"
echo disableswh: Disables SWH for current user >> "%pathswh%\Temp\MoreHelp"
echo download: Downloads an Internet file, website, photo or video. >> "%pathswh%\Temp\MoreHelp"
echo editswh: Edits source code of SWH in GitHub. To make changes, developper will check it >> "%pathswh%\Temp\MoreHelp"
echo email: Sends a mail message >> "%pathswh%\Temp\MoreHelp"
echo encrypttext: Encrypts a text >> "%pathswh%\Temp\MoreHelp"
echo endtask: Finish an active process >> "%pathswh%\Temp\MoreHelp"
echo execinfo: Shows the information of the execution of SWH >> "%pathswh%\Temp\MoreHelp"
echo execute (or exec): Starts a file of the computer >> "%pathswh%\Temp\MoreHelp"
echo faq: Shows the frequent asked questions list >> "%pathswh%\Temp\MoreHelp"
echo file: Creates a file >> "%pathswh%\Temp\MoreHelp"
echo filesize: Shows the size of a file >> "%pathswh%\Temp\MoreHelp"
echo folder: Makes a directory >> "%pathswh%\Temp\MoreHelp"
echo google: Searchs in Google >> "%pathswh%\Temp\MoreHelp"
echo help: Shows this help message >> "%pathswh%\Temp\MoreHelp"
echo history: Views the commands history >> "%pathswh%\Temp\MoreHelp"
echo ipconfig: Shows the IP and his configuration >> "%pathswh%\Temp\MoreHelp"
echo invertcolors: Inverts colors of the screen (Classic inversion) >> "%pathswh%\Temp\MoreHelp"
echo more: Makes a pause in a long text every time the page ends >> "%pathswh%\Temp\MoreHelp"
echo msg: Makes a message box on the screen >> "%pathswh%\Temp\MoreHelp"
echo networkconnections: Shows the network connections >> "%pathswh%\Temp\MoreHelp"
echo networkmsg: Chats with a computer on the same network than you >> "%pathswh%\Temp\MoreHelp"
echo passwordkey: Generates a new key for the password AES encryption (Beta) >> "%pathswh%\Temp\MoreHelp"
echo path: Changes the actual path of SWH >> "%pathswh%\Temp\MoreHelp"
echo pkg: Installs/Removes SWH packages >> "%pathswh%\Temp\MoreHelp"
echo powershell: Starts Windows PowerShell in the current directory >> "%pathswh%\Temp\MoreHelp"
echo preventprocess: Prevents and stops a process to don't let start it >> "%pathswh%\Temp\MoreHelp"
echo project: Makes a programmation script with Scripting Windows Host (Coming soon) >> "%pathswh%\Temp\MoreHelp"
echo prompt: Changes the text of the SWH command line >> "%pathswh%\Temp\MoreHelp"
echo read: Shows the text of a file >> "%pathswh%\Temp\MoreHelp"
echo removefolder: Removes an existing folder (empty) >> "%pathswh%\Temp\MoreHelp"
echo removepassword: Removes the actual password >> "%pathswh%\Temp\MoreHelp"
echo rename: Renames a file or a folder >> "%pathswh%\Temp\MoreHelp"
echo resetsettings: Resets the actual settings >> "%pathswh%\Temp\MoreHelp"
echo resetstartlog: Resets the start log each time SWH starts >> "%pathswh%\Temp\MoreHelp"
echo restartswh: Restarts SWH >> "%pathswh%\Temp\MoreHelp"
echo reversetext: Reverses a text >> "%pathswh%\Temp\MoreHelp"
echo run: Runs a program, file or Internet ressource >> "%pathswh%\Temp\MoreHelp"
echo runasadmin: Starts a program as administrator >> "%pathswh%\Temp\MoreHelp"
echo say: Says a text in SWH Console >> "%pathswh%\Temp\MoreHelp"
echo scanvirus: Scans a file and looks for threats and viruses >> "%pathswh%\Temp\MoreHelp"
echo search: Searchs a file or a folder >> "%pathswh%\Temp\MoreHelp"
echo setpassword: Sets a password for SWH Console >> "%pathswh%\Temp\MoreHelp"
echo setup: Starts SWH Setup (Install/Uninstall) >> "%pathswh%\Temp\MoreHelp"
echo size: Changes the size of SWH Console >> "%pathswh%\Temp\MoreHelp"
echo shutdown: Shuts down the computer >> "%pathswh%\Temp\MoreHelp"
echo swh: Starts a new session of Scripting Windows Host Console >> "%pathswh%\Temp\MoreHelp"
echo swhadmin: Runs SWH as administrator >> "%pathswh%\Temp\MoreHelp"
echo swhdiskcleaner: Starts SWH Disk Cleaner >> "%pathswh%\Temp\MoreHelp"
echo swhzip: Starts SWHZip (SWH File compressor) >> "%pathswh%\Temp\MoreHelp"
echo systeminfo: Shows the system information >> "%pathswh%\Temp\MoreHelp"
echo tasklist: Shows active processes >> "%pathswh%\Temp\MoreHelp"
echo taskmgr: Opens Task Manager >> "%pathswh%\Temp\MoreHelp"
echo t-rex: Starts T-Rex game >> "%pathswh%\Temp\MoreHelp"
echo updateswh: Shows SWH Updates >>" %pathswh%\Temp\MoreHelp"
echo userinfo: Shows the information of a user >> "%pathswh%\Temp\MoreHelp"
echo version (or ver): Shows the version of SWH >>" %pathswh%\Temp\MoreHelp"
echo viewstartlog: Shows the start SWH log file >> "%pathswh%\Temp\MoreHelp"
echo voice: Makes a voice >> "%pathswh%\Temp\MoreHelp"
echo website: Opens Scripting Windows Host Internet website >> "%pathswh%\Temp\MoreHelp"
echo widedir: Shows the current directory in wide mode. >> "%pathswh%\Temp\MoreHelp"
echo winver: Shows the Windows Version >> "%pathswh%\Temp\MoreHelp"
echo. >> "%pathswh%\Temp\MoreHelp"
echo Press any key to continue... >> "%pathswh%\Temp\MoreHelp"

if %moreCMD%==1 (goto moreHelp) else (goto normalHelp)
:morehelp
more /E %pathswh%\Temp\MoreHelp
pause>nul
echo.
goto swh


:normalHelp
echo.
echo help >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
rem Help command
echo Commands:
echo.
echo alias: Shows command aliases
echo audiovolume: Sets the Windows audio volume
echo base64decode: Encodes a string using Base64
echo base64decodefile: Decodes a file using Base64
echo base64encode: Decodes a string using Base64
echo base64encodefile: Encodes a file using Base64
echo blockusers: Blocks SWH if the user is not "%username%"
echo bootmode: Starts SWH with compatibility with X: drive (No recomended for normal use)
echo bugs: Can see the bugs of SWH
echo calc (or calculator): Starts SWH calculator
echo cancelshutdown: Cancels the scheduled shutdown
echo cd: Go to a specific directory
echo checkprocess: Checks if a specified process is running on system
echo clear: Clears the screen of SWH
echo clearhistory: Clears the SWH command history
echo cleartemp: Clears the temporary files of your computer in %tmp%
echo clearwintemp: Clears the Windows temporary files in %Systemroot%\Temp
echo clipboard: Copies a text in the clipboard
echo cmd: Starts Command Prompt in the current directory
echo command: Starts MS-DOS command prompt (command.com)
echo contact: Shows the contact information
echo copy: Copies files of the computer
echo credits: Shows the credits of SWH
echo date: Changes the date of the computer
echo decompressfile: Decompresses a file compressed with SWHZip
echo decrypttext: Decrypts a text
echo del: Removes a file
echo dir (or directory): Shows the current directory
echo disableswh: Disables SWH for current user
echo download: Downloads an Internet file, website, photo or video
echo editswh: Edits source code of SWH in GitHub. To make changes, developper will check it
echo email: Sends a mail message
echo encrypttext: Encrypts a text
echo endtask: Finish an active process
echo execinfo: Shows the information of the execution of SWH
echo execute (or exec): Starts a file of the computer
echo faq: Shows the frequent asked questions list
echo file: Creates a file
echo filesize: Shows the size of a file
echo firmware: Enters the computer firmware (UEFI/BIOS)
echo folder: Makes a directory
echo google: Searchs in Google
echo help: Shows this help message
echo history: Views the commands history
echo invertcolors: Inverts colors of the screen (Classic inversion)
echo ipconfig: Shows the IP and his configuration
echo more: Makes a pause in a long text every time the page ends
echo msg: Makes a message box on the screen
echo networkconnections: Shows the network connections
echo networkmsg: Chats with a computer on the same network than you
echo news: Shows the news of SWH %ver%
echo passwordkey: Generates a new key for the password AES encryption (Beta)
echo path: Changes the actual path of SWH
echo pkg: Installs/Removes SWH packages
echo powershell: Starts Windows PowerShell in the current directory
echo project: Makes a programmation script with Scripting Windows Host (Coming soon)
echo prompt: Changes the text of the SWH command line
echo read: Shows the text of a file
echo removefolder: Removes an existing folder (empty)
echo removepassword: Removes the actual password
echo rename: Renames a file or a folder
echo resetsettings: Resets the actual settings
echo resetstartlog: Resets the start log each time SWH starts
echo restartswh: Restarts SWH
echo reversetext: Reverses a text
echo run: Runs a program, file or Internet ressource
echo runasadmin: Starts a program as administrator
echo say: Says a text in SWH Console
echo scanvirus: Scans a file and looks for threats and viruses
echo search: Searchs a file or a folder
echo setpassword: Sets a password for SWH Console
echo setup: Starts SWH Setup (Install/Uninstall)
echo size: Changes the size of SWH Console
echo shutdown: Shuts down the computer
echo swh: Starts a new session of Scripting Windows Host Console
echo swhadmin: Runs SWH as administrator
echo swhdiskcleaner: Starts SWH Disk Cleaner
echo swhzip: Starts SWHZip (SWH File compressor)
echo systeminfo: Shows the system information
echo tasklist: Shows active processes
echo taskmgr: Opens Task Manager
echo t-rex: Starts T-Rex game
echo updateswh: Shows SWH Updates
echo userinfo: Shows the information of a user
echo version (or ver): Shows the version of SWH
echo viewstartlog: Shows the start SWH log file
echo voice: Makes a voice
echo website: Opens Scripting Windows Host Internet website
echo widedir: Shows the current directory in wide mode.
echo winver: Shows the Windows Version
echo.
echo Press any key to continue...
pause>nul
echo.
goto swh

:helpproject
echo HelpProject >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
echo How to create your own project:
echo.
echo To create a project, type "project" on the Scripting Windows Host Console.
echo The commands are writting in Scripting Windows Host, but it transforms it to other languages
echo To exit the project maker, type "exitproject" on project maker
echo.
goto swh

:other1cmd
rem "" antibug
if /i %cmd%=="help" (goto cmdhelp)
if /i %cmd%=="Enter{VD-FF24F4FV54F-TW5THW5-4Y5Y-245UNW-54NYUW}" (
	echo Enter >> "%pathswh%\SWH_History.txt"
	goto swh
)
if /i %cmd%=="execute" (goto start)
if /i %cmd%=="exec" (goto start)
if /i %cmd%=="folder" (goto mkdir)
if /i %cmd%=="shutdown" (goto shutdown)
if /i %cmd%=="cd" (goto cd)
if /i %cmd%=="title" (goto title)
if /i %cmd%=="file" (goto file)
if /i %cmd%=="cls" (goto cls)
if /i %cmd%=="clear" (goto cls)
if /i %cmd%=="del" (goto del)
if /i %cmd%=="color" (goto color)
if /i %cmd%=="endtask" (goto taskkill)
if /i %cmd%=="tasklist" (goto tasklist)
if /i %cmd%=="taskmgr" (goto taskmgr)
if /i %cmd%=="removefolder" (goto rfolder)
if /i %cmd%=="exit" (echo.&echo Exiting SWH...& title %windir%\System32\cmd.exe & exit /b)
if /i %cmd%=="copy" (goto copyfiles)
if /i %cmd%=="cmd" (goto cmdscreen)
if /i %cmd%=="swh" (goto startswh)
if /i %cmd%=="msg" (goto msgbox)
if /i %cmd%=="date" (goto chdate)
if /i %cmd%=="time" (goto chtime)
if /i %cmd%=="say" (goto echosay)
if /i %cmd%=="credits" (goto credits)
if /i %cmd%=="directory" (goto dir)
if /i %cmd%=="dir" (goto dir)
if /i %cmd%=="cancelshutdown" (goto cancelshutdown)
if /i %cmd%=="rename" (goto rename)
if /i %cmd%=="history" (goto history)
if /i %cmd%=="clearhistory" (goto clearhistory)
if /i %cmd%=="calc" (goto calc)
if /i %cmd%=="calculator" (goto calc)
if /i %cmd%=="size" (goto consize)
if /i %cmd%=="project" (goto scriptproject)
if /i %cmd%=="helpproject"(goto HelpProject2)
if /i %cmd%=="voice" (goto voice)
if /i %cmd%=="networkconnections" (goto networkconnections)
if /i %cmd%=="prompt" (goto consoleinput)
if /i %cmd%=="t-rex" (goto trexgame)
if /i %cmd%=="search" (goto searchfiles)
if /i %cmd%=="powershell" (goto :PowerShell)
if /i %cmd%=="url" (goto url)
if /i %cmd%=="systemconfig" (goto bootconfig)
if /i %cmd%=="variable" (goto variable)
if /i %cmd%=="swhvariables" (goto swhvariables)
if /i %cmd%=="vol" (goto vol)
if /i %cmd%=="settings" (goto settings)
if /i %cmd%=="run" (goto SWHrunDialog)
rem "not swh" antibug
if /i %cmd%=="""not swh""" (goto incommand)
if /i %cmd%=="swhzip" (goto swhzip)
if /i %cmd%=="helpsettings" (goto hsettings)
if /i %cmd%=="ipconfig" (goto ipconfig)
if /i %cmd%=="random" (goto randomnumber)
if /i %cmd%=="resetsettings" (goto resetsettings)
if /i %cmd%=="systeminfo" (goto SysInfo)
if /i %cmd%=="restartswh" (goto abstartswh)
if /i %cmd%=="path" (goto chPath)
if /i %cmd%=="faq" (goto FAQ)
if /i %cmd%=="systempath" (goto Syspath)
if /i %cmd%=="command" (goto commandCom)
if /i %cmd%=="execinfo" (goto execinfo)
if /i %cmd%=="cd.." (goto cdBack)
if /i %cmd%=="cd\" (goto cdDisk)
if /i %cmd%=="clearwintemp" (goto clsWinTMP)
if /i %cmd%=="cleartemp" (goto clsTemp)
if /i %cmd%=="swhdiskcleaner" (goto SWHdiskCleaner)
if /i %cmd%=="encrypttext" (goto encrypttext)
if /i %cmd%=="updateswh" (goto updateswh)
if /i %cmd%=="more" (goto moreWalk)
if /i %cmd%=="read" (goto read)
if /i %cmd%=="ver" (goto swhver)
if /i %cmd%=="version" (goto swhver)
if /i %cmd%=="setpassword" (goto setpassword)
if /i %cmd%=="removepassword" (goto removepassword)
if /i %cmd%=="blockusers" (goto accessonlyuser)
if /i %cmd%=="winver" (goto winver)
if /i %cmd%=="clipboard" (goto cmdClip)
if /i %cmd%=="decrypttext" (goto decrypttext)
if /i %cmd%=="userinfo" (goto userinfo)
if /i %cmd%=="viewstartlog" (goto viewstartlog)
if /i %cmd%=="resetstartlog" (goto resetstartlog)
if /i %cmd%=="bootmode" (goto xdiskbootask)
if /i %cmd%=="widedir" (goto widedir)
if /i %cmd%=="firmware" (goto firmwareaccess)
if /i %cmd%=="news" (goto newsSWH)
if /i %cmd%=="setup" (goto startSetup)
if /i %cmd%=="base64encode" (goto base64encode)
if /i %cmd%=="base64decode" (goto base64decode)
if /i %cmd%=="contact" (goto swhcontact)
if /i %cmd%=="swhadmin" (goto swh_admin)
if /i %cmd%=="download" (goto download_internet)
if /i %cmd%=="editswh" (goto editswh_github)
if /i %cmd%=="networkmsg" (goto networkmsg)
if /i %cmd%=="checkprocess" (goto checkprocess)
if /i %cmd%=="pkg" (goto pkg)
if /i %cmd%=="pkg install" (goto pkg_install)
if /i %cmd%=="pkg install calc" (goto pkg_install_calc)
if /i %cmd%=="pkg install trex" (goto pkg_install_trex)
if /i %cmd%=="pkg list" (goto pkglist)
if /i %cmd%=="pkg remove calc" (goto pkgremovecalc)
if /i %cmd%=="pkg remove trex" (goto pkgremovetrex)
if /i %cmd%=="pkg listinstall" (goto pkg_listinstall)
if /i %cmd%=="scanvirus" (goto scanvirus)
if /i %cmd%=="google" (goto searchgoogle)
if /i %cmd%=="filesize" (goto filesize)
if /i %cmd%=="invertcolors" (goto invertcolors)
if /i %cmd%=="passwordkey" (goto passwordkey)
if /i %cmd%=="disableswh" (goto disableswh)
if /i %cmd%=="reversetext" (goto reversetext)
if /i %cmd%=="runasadmin" (goto runasadmin)
if /i %cmd%=="if!" (goto if_condition)
if /i %cmd%=="base64encodefile" (goto base64encodefile)
if /i %cmd%=="base64decodefile" (goto base64decodefile)
if /i %cmd%=="email" (goto email)
if /i %cmd%=="decompressfile" (goto decompressfile)
if /i %cmd%=="compressfile" (goto compressfile)
if /i %cmd%=="encryptfile" (goto encryptfile)
if /i %cmd%=="alias" (goto alias)
if /i %cmd%=="ls" (goto dir)
if /i %cmd%=="website" (start https://anic17.github.io/SWHConsole & echo. & goto swh)
if /i %cmd%=="man" (goto cmdhelp)
if /i %cmd%=="quit" (echo.&echo Exiting SWH...& title %windir%\System32\cmd.exe & exit /b)
if /i %cmd%=="mail" (goto email)
if /i %cmd%=="audiovol" (goto audiovol)
if /i %cmd%=="audiovolume" (goto audiovol)
if /i %cmd%=="preventprocess" (goto preventprocess)

if /i %cmd%=="pkg install notepad" (goto pkg_install_notepad)
if /i %cmd%=="pkg install paint" (goto pkg_install_paint)



if /i %cmd%=="bugs" (goto bugs) else (goto incommand)

:swh
if "%next_exit%"=="1" (set next_exit=0 & exit /B)
if not exist "\" (echo. & set errordisk_=%cd% & goto errornotdisk)
set cmd=Enter{VD-FF24F4FV54F-TW5THW5-4Y5Y-245UNW-54NYUW}
echo SWH:Automatic >> "%pathswh%\SWH_History.txt"
set /p cmd=%cd% %commandtoexecute%
set cmd2=%cmd%
set cmd="%cmd2%"
if %cmd%=="help" (goto cmdhelp) else (goto other1cmd)

:foundedpassword_gotoswh
if "%psd%"=="[{CLSID:8t4tvry4893tvy2nq4928trvyn14098vny84309tvny493q8tvn0943tyvnu0q943t8vn204vmy10vn05}]"
set /p enterpassword_gotoswh=Enter SWH password please: 
goto swh

:runasadmin
echo.
if %admin%==1 (
	echo SWH is running as administrator; you don't need to use this command
	echo.
	goto swh
)
echo Executable files are: .COM, .EXE, .BAT, .CMD
echo.
set /p runasadminprog=Executable to run as administrator: 
if exist "%runasadminprog%" (set runasadminprog=%runasadminprog% & goto exist_runasadmin)
if exist "%WINDIR%\%runasadminprog%" (set runasadminprog=%WinDir%\%runasadminprog% & goto exist_runasadmin)
if exist "%userprofile%\%runasadminprog%" (set runasadminprog=%userprofile%\%runasadminprog% & goto exist_runasadmin)
if exist "%WINDIR%\System32\WindowsPowerShell\v1.0\%runasadminprog%" (set runasadminprog=%WINDIR%\System32\WindowsPowerShell\v1.0\%runasadminprog% & goto exist_runasadmin)
if exist "%WINDIR%\SysWOW64\WindowsPowerShell\v1.0\%runasadminprog%" (set runasadminprog=%WINDIR%\SysWOW64\WindowsPowerShell\v1.0\%runasadminprog% & goto exist_runasadmin)
if exist "%WINDIR%\System32\%runasadminprog%" (set runasadminprog=%WinDir%\System32\%runasadminprog% & goto exist_runasadmin)
if exist "%WinDir%\SysWOW64\%runasadminprog%" (set runasadminprog=%WinDir%\SysWOW64\%runasadminprog% & goto exist_runasadmin)
if exist "%runasadminprog%" (set runasadminprog=%WinDir%\System32\%runasadminprog% & goto exist_runasadmin)
echo.
echo Cannot find %runasadminprog%
echo.
goto swh

:exist_runasadmin
echo.
echo CreateObject("Shell.Application").ShellExecute "%runasadminprog%",,,"RunAS",1 > "%pathswh%\Temp\RunAs.vbs"
start /wait WScript.exe "%pathswh%\Temp\RunAs.vbs"
goto swh



:disableswh
if %admin%==0 goto adminpermission
echo.
set /p suredisableswh_reg=Are you sure you want to disable SWH? (y/n): 
if /i "%suredisableswh_reg%"=="y" (
	reg add HKCU\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 1 /f>nul
	echo.
	echo SWH has been blocked. Please run the following command to unblock SWH:
	echo.
	echo CMD.exe /k REG ADD HKCU\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f
	echo.
	echo When you press a key, you will not be able to start SWH
	pause>nul
	echo.
	echo Exiting SWH... Reason: SWH blocked
	echo.
	exit /B
) else (
	echo.
	goto swh
)



:pkg
echo.
echo Syntax:
echo.
echo pkg install ^<package^> : Installs a package
echo pkg remove ^<package^> : Removes a package
echo pkg list : Lists all avaiable packages
echo pkg listinstall : Lists all installed packages
echo.
echo Examples:
echo.
echo pkg install calc
echo pkg remove calc
echo pkg list
echo pkg listinstall
echo.
goto swh

:pkg_install
echo.
echo Syntax:
echo.
echo pkg install ^<package^>
echo.
echo Example:
echo.
echo pkg install calc
echo.
goto swh

:pkg_install_calc
echo.
if exist "%pathswh%\pkg\SWH_Calc.exe" (goto chkpkginstallcalc)
:installing_pkg_calc
echo Installing calculator package...
echo.
echo $url = "https://raw.githubusercontent.com/anic17/SWH/data/SWH_Calc.exe" > %pathswh%\Temp\PackCalc.ps1
echo $output = "%pathswh%\pkg\SWH_Calc.exe" >> %pathswh%\Temp\PackCalc.ps1
echo Invoke-WebRequest -Uri $url -OutFile $output >> %pathswh%\Temp\PackCalc.ps1
powershell.exe "%pathswh%\Temp\PackCalc.ps1"
if exist "%pathswh%\pkg\SWH_Calc.exe" (
	echo msgbox "Calculator package has been successfully installed on your computer",4160,"Calculator package has been successfully installed" > %pathswh%\Temp\Scalcpkg.vbs
	start /wait wscript.exe "%pathswh%\Temp\Scalcpkg.vbs"
) else (
	echo msgbox "Error installing calculator package",4112,"Error installing calculator package" > %pathswh%\Temp\ErrCalcPkg.vbs
	start /wait wscript.exe "%pathswh%\Temp\ErrCalcPkg.vbs"
	echo.
	goto swh
)
echo Calculator package has been successfully installed on your computer.
echo.
goto swh


:chkpkginstallcalc
cd /d "%pathswh%\pkg"
for %%a in (SWH_Calc.exe) do (set pkgcalcsize=%%~za)
if not "%pkgcalcsize%"=="2358" (goto installing_pkg_calc)
echo Calculator package is already installed on your computer
echo.
cd /d "%cdirectory%"
goto swh

:pkg_install_trex
::https://raw.githubusercontent.com/anic17/SWH/data/T-RexGame.html
echo.
echo Installing T-Rex Game package...
echo.
:installing_pkg_trex
echo $url = "https://raw.githubusercontent.com/anic17/SWH/data/T-RexGame.html" > %pathswh%\Temp\PackTrex.ps1
echo $output = "%pathswh%\pkg\T-RexGame.html" >> %pathswh%\Temp\PackTrex.ps1
echo Invoke-WebRequest -Uri $url -OutFile $output >> %pathswh%\Temp\PackTrex.ps1
powershell.exe %pathswh%\Temp\PackTrex.ps1
if exist "%pathswh%\pkg\T-RexGame.html" (
	echo msgbox "T-Rex game package has been successfully installed on your computer",4160,"T-Rex game package has been successfully installed" > %pathswh%\Temp\Strexpkg.vbs
	start /wait wscript.exe "%pathswh%\Temp\Strexpkg.vbs"
) else (
	echo msgbox "Error installing T-Rex game package",4112,"Error installing T-Rex game package" > %pathswh%\Temp\ErrTrexPkg.vbs
	start /wait wscript.exe "%pathswh%\Temp\ErrTrexPkg.vbs"
	echo.
	goto swh
)
echo T-Rex game package has been successfully installed on your computer.
echo.
goto swh
:chkpkginstallcalc
cd /d "%pathswh%\pkg"
for %%A in (T-RexGame.html) do (set pkgtrexsize=%%~zA)
if not "%pkgtrexsize%"=="121452" (goto installing_pkg_trex)
echo T-Rex Game package is already installed on your computer
echo.
cd /d "%cdirectory%"
goto swh
:pkglist
echo.
echo Avaiable packages:
echo.
echo T-Rex game (pkg install trex)
echo SWH Calculator (pkg install calc)
echo SWH Paint (pkg install paint)
echo SWH Notepad (pkg install notepad)
echo.
goto swh
:pkgremovecalc
echo.
set /p sureremovepackcalc=Are you sure you want to remove calculator package? (y/n): 
if /i "%sureremovepackcalc%"=="Y" (goto removingpkgcalc) else (
	echo.
	goto swh
)
:removingpkgcalc
if not exist "%pathswh%\pkg\SWH_Calc.exe" (
	echo.
	echo Cannot remove calculator package: calculator isn't installed.
	echo.
	goto swh
)
echo.
echo Removing calculator package...
del "%pathswh%\pkg\SWH_Calc.exe" /q>nul
if exist "%pathswh%\pkg\SWH_Calc.exe" (
	echo.
	echo msgbox "Error removing calculator package",4112,"Error removing calculator package" > %pathswh%\Temp\ErrRemCalcPkg.vbs
	start /wait wscript.exe "%pathswh%\Temp\ErrRemCalcPkg.vbs"
	echo Error removing calculator package!
	echo.
	goto swh
)
echo.
echo msgbox "Calculator package has been successfully removed from your computer",4160,"Calculator package has been successfully removed from your computer" > %pathswh%\Temp\Sremcalcpkg.vbs
start /wait wscript.exe "%pathswh%\Temp\Sremcalcpkg.vbs"
echo Calculator package has been successfully removed from your computer.
echo.
goto swh
:pkgremovetrex
echo.
set /p sureremovepacktrex=Are you sure you want to remove T-Rex Game package? (y/n): 
if /i "%sureremovepacktrex%"=="Y" (goto removingpkgtrex) else (
	echo.
	goto swh
)
:removingpkgtrex
if not exist "%pathswh%\pkg\T-RexGame.html" (
	echo.
	echo Cannot remove T-Rex Game package: calculator isn't installed.
	echo.
	goto swh
)
echo.
echo Removing T-Rex Game package...
del %pathswh%\T-RexGame.html /q>nul
if exist "%pathswh%\pkg\T-RexGame.html" (
	echo.
	echo msgbox "Error removing T-Rex Game package",4112,"Error removing T-Rex Game package" > %pathswh%\Temp\ErrRemTrexPkg.vbs
	start /wait wscript.exe "%pathswh%\Temp\ErrRemTrexPkg.vbs"
	echo Error removing T-Rex Game package!
	echo.
	goto swh
)
echo.
echo msgbox "T-Rex Game package has been successfully removed from your computer",4160,"T-Rex Game package has been successfully removed from your computer" > %pathswh%\Temp\Sremtrexpkg.vbs
start /wait wscript.exe "%pathswh%\Temp\Sremtrexpkg.vbs"
echo T-Rex Game package has been successfully removed from your computer.
echo.
goto swh


:pkg_listinstall
echo.
cd /d "%pathswh\pkg%"
if not exist SWH_Calc.exe goto next1listins_PKG

for %%i in (SWH_Calc.exe) do (set calclistinspkgsize=%%~zi)

set /a sizekbcalcpkg=%calclistinspkgsize%/1024
if "%calclistinspkgsize%"=="2358" (echo SWH Calculator. Size: %sizekbcalcpkg% kB)

:next1listins_PKG
if not exist T-RexGame.html (goto swh)
for %%I in (T-RexGame.html) do (set trexlistinspkgsize=%%~zI)

set /a sizekbtrexpkg=%trexlistinspkgsize%/1024
if "%calclistinspkgsize%"=="121452" (echo T-Rex Game. Size: %sizekbtrexpkg% kB)
echo.
cd /d "%cdirectory%"
goto swh


:pkg_install_paint
if exist "%pathswh%\pkg\SWH_Paint.bat" (
	echo.
	echo Paint package is already installed on your computer
	echo.
	goto swh
)
echo.
echo Downloading Paint package...
echo.

powershell.exe -Command Invoke-WebRequest -Uri "https://raw.githubusercontent.com/anic17/SWH/data/Paint.bat" -OutFile "%pathswh%\pkg\SWH_Paint.bat"
if not exist "%pathswh%\pkg\SWH_Paint.bat" (
	echo Error while installing Paint package
	echo msgbox "Error installing Paint package",4112,"Error installing Paint package" > %pathswh%\Temp\ErrSWH_drwPkg.vbs
	start /wait WScript.exe "%pathswh%\Temp\ErrSWH_drwPkg.vbs"
) else (
	echo Paint package has been successfully installed on your computer
	echo msgbox "Paint package has been successfully installed on your computer",4160,"Paint package has been successfully installed on your computer" > %pathswh%\Temp\SdrwPkg.vbs
	start /wait WScript.exe "%pathswh%\Temp\SdrwPkg.vbs"
)
echo.
goto swh







:preventprocess
echo.
echo Note: Preventing a system process to start may cause damage to your system
echo.
set /p sureprev_ss=Are you sure you want to prevent processes to start? (y/n): 
if /i not "%sureprev_ss%"=="Y" (echo. & goto swh)
echo.
set /p ss_prevstart=Process to prevent to start: 
start cmd.exe /c "%pathswh%\SWH.bat"
mode 15,1


:prevssrun
taskkill /f /im %ss_prevstart%
goto prevssrun
if /i "%ss_prevstart%"=="csrss.exe" (goto accessdeniedprev_ss)
if /i "%ss_prevstart%"=="System" (goto accessdeniedprev_ss)
if /i "%ss_prevstart%"=="Registry" (goto accessdeniedprev_ss)
if /i "%ss_prevstart%"=="wininit.exe" (goto accessdeniedprev_ss)
if /i "%ss_prevstart%"=="MsMpEng.exe" (goto accessdeniedprev_ss)

if /i "%ss_prevstart%"=="winlogon.exe" (goto accessdeniedprev_ss)

if /i "%ss_prevstart%"=="taskmgr.exe" (echo. & echo Cannot prevent to start TaskMgr.exe & echo. & echo This action has been blocked to evit possible malware & echo. & goto swh)

if /i "%ss_prevstart%"=="svchost.exe" (goto accessdeniedprev_ss)

if /i "%ss_prevstart%"=="winlogon.exe" (goto accessdeniedprev_ss)









:accessdeniedprev_ss
echo.
echo Access denied on %ss_prevstart%
echo Reason: This is a system critical process. Cannot prevent to start it
echo.
goto swh




:base64encodefile
echo.
set /p base64encodefile=File to encode into Base64: 



echo ' https://stackoverflow.com/questions/496751/base64-encode-string-in-vbscript > "%pathswh%\Temp\base64_encodefile.vbs"
echo ' code using encoding abilities of MSXml2.DOMDocument object and saves >> "%pathswh%\Temp\base64_encodefile.vbs"
echo ' the resulting data to encoded.txt file >> "%pathswh%\Temp\base64_encodefile.vbs"

echo Option Explicit >> "%pathswh%\Temp\base64_encodefile.vbs"

echo Const fsDoOverwrite     = true  ' Overwrite file with base64 code >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Const fsAsASCII         = false ' Create base64 code file as ASCII file >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Const adTypeBinary      = 1     ' Binary file is encoded >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Variables for writing base64 code to file >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Dim objFSO >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Dim objFileOut >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Variables for encoding >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Dim objXML >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Dim objDocElem >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Variable for reading binary picture >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Dim objStream >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Open data stream from picture >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objStream = CreateObject("ADODB.Stream") >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objStream.Type = adTypeBinary >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objStream.Open() >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objStream.LoadFromFile("%base64encodefile%") >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Create XML Document object and root node >> "%pathswh%\Temp\base64_encodefile.vbs"
echo ' that will contain the data >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objXML = CreateObject("MSXml2.DOMDocument") >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objDocElem = objXML.createElement("Base64Data") >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objDocElem.dataType = "bin.base64" >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Set binary value >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objDocElem.nodeTypedValue = objStream.Read() >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Open data stream to base64 code file >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objFileOut = objFSO.CreateTextFile("%base64encodefile%.base64", fsDoOverwrite, fsAsASCII) >> "%pathswh%\Temp\base64_encodefile.vbs"

echo ' Get base64 value and write to file >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objFileOut.Write objDocElem.text >> "%pathswh%\Temp\base64_encodefile.vbs"
echo objFileOut.Close() >> "%pathswh%\Temp\base64_encodefile.vbs"
echo ' Clean all >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objFSO = Nothing >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objFileOut = Nothing >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objXML = Nothing >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objDocElem = Nothing >> "%pathswh%\Temp\base64_encodefile.vbs"
echo Set objStream = Nothing >> "%pathswh%\Temp\base64_encodefile.vbs"
echo.
start /wait WScript.exe "%pathswh%\Temp\base64_encodefile.vbs"
echo File has been saved with the name of %base64encodefile%.base64
echo.
goto swh


:base64decodefile
echo.
set /p base64decodefile=File to decode into Base64: 

echo ' This script reads base64 encoded picture from file named encoded.txt, > "%pathswh%\Temp\base64_decodefile.vbs"
echo ' converts it in to back to binary reprisentation using encoding abilities >> "%pathswh%\Temp\base64_decodefile.vbs"
echo ' of MSXml2.DOMDocument object and saves data to SuperPicture.jpg file >> "%pathswh%\Temp\base64_decodefile.vbs"

echo Option Explicit >> "%pathswh%\Temp\base64_decodefile.vbs"

echo Const foForReading          = 1 ' Open base 64 code file for reading >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Const foAsASCII             = 0 ' Open base 64 code file as ASCII file >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Const adSaveCreateOverWrite = 2 ' Mode for ADODB.Stream >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Const adTypeBinary          = 1 ' Binary file is encoded >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Variables for reading base64 code from file >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Dim objFSO >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Dim objFileIn >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Dim objStreamIn >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Variables for decoding >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Dim objXML >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Dim objDocElem >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Variable for write binary picture >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Dim objStream >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Open data stream from base64 code filr >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objFileIn   = objFSO.GetFile("%base64decodefile%") >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objStreamIn = objFileIn.OpenAsTextStream(foForReading, foAsASCII) >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Create XML Document object and root node >> "%pathswh%\Temp\base64_decodefile.vbs"
echo ' that will contain the data >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objXML = CreateObject("MSXml2.DOMDocument") >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objDocElem = objXML.createElement("Base64Data") >> "%pathswh%\Temp\base64_decodefile.vbs"
echo objDocElem.DataType = "bin.base64" >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Set text value >> "%pathswh%\Temp\base64_decodefile.vbs"
echo objDocElem.text = objStreamIn.ReadAll() >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Open data stream to picture file >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objStream = CreateObject("ADODB.Stream") >> "%pathswh%\Temp\base64_decodefile.vbs"
echo objStream.Type = adTypeBinary >> "%pathswh%\Temp\base64_decodefile.vbs"
echo objStream.Open() >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Get binary value and write to file >> "%pathswh%\Temp\base64_decodefile.vbs"
echo objStream.Write objDocElem.NodeTypedValue >> "%pathswh%\Temp\base64_decodefile.vbs"
echo objStream.SaveToFile "%base64decodefile%.decoded", adSaveCreateOverWrite >> "%pathswh%\Temp\base64_decodefile.vbs"

echo ' Clean all >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objFSO = Nothing >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objFileIn = Nothing >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objStreamIn = Nothing >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objXML = Nothing >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objDocElem = Nothing >> "%pathswh%\Temp\base64_decodefile.vbs"
echo Set objStream = Nothing >> "%pathswh%\Temp\base64_decodefile.vbs"
echo.
start /wait WScript.exe "%pathswh%\Temp\base64_decodefile.vbs"
echo File has been saved with the name of %base64encodefile%.decoded
echo.
goto swh

:alias
echo.
echo Aliases:
echo.
echo Original command ^| Alias
echo.
echo calc             ^| calculator
echo cd ^>^> \          ^| cd\
echo cd ^>^> :          ^| cd..
echo cls              ^| clear
echo dir              ^| ls ^& directory
echo email            ^| mail
echo exec             ^| execute
echo exit             ^| quit
echo help             ^| man
echo ver              ^| version
echo.
goto swh







:email
echo.
set /p frommail=From: 
set /p tomail=To: 
set /p subjectmail=Subject: 
set /p bodymail=Body: 
::set /p attachmentmail=Attachment (Type "None" to don't send an attachment): 
::if "%attachmentmail%"=="None"
set "psCommand=powershell -Command "$pword = read-host 'Password' -AsSecureString ; ^
     $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
                 [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set passwordmail=%%p



echo $EmailFrom = "%frommail%" > "%pathswh%\Temp\E-Mail.ps1"
echo $EmailTo = "%tomail%" >> "%pathswh%\Temp\E-Mail.ps1"
echo $Subject = "%subjectmail%" >> "%pathswh%\Temp\E-Mail.ps1"
echo $Body = "%bodymail%" >> "%pathswh%\Temp\E-Mail.ps1"
echo $SMTPServer = "smtp.gmail.com" >> "%pathswh%\Temp\E-Mail.ps1"
echo $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) >> "%pathswh%\Temp\E-Mail.ps1"
echo $SMTPClient.EnableSsl = $true >> "%pathswh%\Temp\E-Mail.ps1"
echo $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("%frommail%", "%passwordmail%"); >> "%pathswh%\Temp\E-Mail.ps1"
echo $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body) >> "%pathswh%\Temp\E-Mail.ps1"
echo.
echo Sending E-Mail... 
powershell.exe "%pathswh%\Temp\E-Mail.ps1"
echo.
echo Mail sent
echo.
echo 01010100011010000110100101110011001000000110011001101001011011000110010100100000011010000110000101110011001000000110001001100101011001010110111000100000011011110111011001100101011100100111011101110010011010010111010001110100011001010110111000100000011001100110111101110010001000000111000001100001011100110111001101110111011011110111001001100100001000000111000001110010011011110111010001100101011000110111010001101001011011110110111000101110 > "%pathswh%\Temp\E-Mail.ps1"
del "%pathswh%\Temp\E-Mail.ps1" /q /f
set passwordmail=00000000
goto swh



:reversetext
echo.
set /p str_reverse=String to reverse: 

echo On Error Resume Next > "%pathswh%\Temp\ReverseStr.vbs"
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> "%pathswh%\Temp\ReverseStr.vbs"
echo Set reversetext = objFSO.createtextfile("%pathswh%\Temp\ReverseStr.txt") >> "%pathswh%\Temp\ReverseStr.vbs"
echo SWH_StrRev = StrReverse("%str_reverse%") >> "%pathswh%\Temp\ReverseStr.vbs"
echo reversetext.writeline SWH_StrRev >> "%pathswh%\Temp\ReverseStr.vbs"
echo reversetext.close >> "%pathswh%\Temp\ReverseStr.vbs"
echo WScript.Quit() >> "%pathswh%\Temp\ReverseStr.vbs"
start /wait wscript.exe "%pathswh%\Temp\ReverseStr.vbs"
echo.
more "%pathswh%\Temp\ReverseStr.txt"
echo.
goto swh


:if_condition
echo.

echo.
echo If syntax:
echo.
echo If
echo var_1
echo =
echo var_2
echo command
echo.
set /p ifsyntax_var1=First variable?: 
set /p ifsyntax_var2=Second variable?: 
set /p ifsyntax_command=Command?: 

if %ifsyntax_var1%==%ifsyntax_var2% (
	set cmd="%ifsyntax_command%"
	echo True
) else (
	echo False
)
echo.
goto other1cmd


:audiovol
set /p volumeaudio=Volume to put audio sound: 
echo Function Set-Speaker($Volume){$wshShell = new-object -com wscript.shell;1..50 ^| %% {$wshShell.SendKeys([char]174)};1..$Volume ^| %% {$wshShell.SendKeys([char]175)}} > "%pathswh%\Temp\AudioVol.ps1"
if "%volumeaudio%"=="0" (
	echo Set-Speaker -Volume 0 >> "%pathswh%\Temp\AudioVol.ps1"
	powershell.exe "%pathswh%\Temp\AudioVol.ps1"
	echo.
	goto swh
)
set /a volumeaudio=%volumeaudio%/2
if "%volumeaudio%" gtr "50" (
	echo Set-Speaker -Volume 50 >> "%pathswh%\Temp\AudioVol.ps1"
	powershell.exe "%pathswh%\Temp\AudioVol.ps1"
	echo.
	goto swh
)

echo Set-Speaker -Volume %volumeaudio% >> "%pathswh%\Temp\AudioVol.ps1"
powershell.exe "%pathswh%\Temp\AudioVol.ps1"
echo.
goto swh


:searchgoogle
echo.
set /p searchgoogle_=Search to Google: 
echo Set objShell = WScript.CreateObject("WScript.Shell") > "%pathswh%\Temp\SearchGoogle.vbs"
echo Google = "%searchgoogle_%" >> "%pathswh%\Temp\SearchGoogle.vbs"
echo objShell.Run "cmd.exe /c start www.google.com",vbHide,True >> "%pathswh%\Temp\SearchGoogle.vbs"
echo WScript.Sleep(1150) >> "%pathswh%\Temp\SearchGoogle.vbs"
echo objShell.SendKeys Google >> "%pathswh%\Temp\SearchGoogle.vbs"
echo objShell.SendKeys "{ENTER}" >> "%pathswh%\Temp\SearchGoogle.vbs"
echo WScript.Quit >> "%pathswh%\Temp\SearchGoogle.vbs"
start /wait "WScript.exe" "%pathswh%\Temp\SearchGoogle.vbs"
echo.
goto swh


:invertcolors
echo Set objShell = WScript.CreateObject("WScript.Shell") > "%pathswh%\Temp\InvertColors.vbs"
echo objShell.Run "cmd.exe /c start /min %systemroot%\System32\magnify.exe",vbHide >> "%pathswh%\Temp\InvertColors.vbs"
echo WScript.Sleep(1000) >> "%pathswh%\Temp\InvertColors.vbs"
echo wscript.echo "pressing..." >> "%pathswh%\Temp\InvertColors.vbs"
echo objShell.SendKeys "^%%I" >> "%pathswh%\Temp\InvertColors.vbs"
echo WScript.Quit >> "%pathswh%\Temp\InvertColors.vbs"
start "wscript.exe" "%pathswh%\Temp\InvertColors.vbs"
echo.
goto swh

:passwordkey
if %admin%==0 (call :adminpermission)
echo.
echo IMPORTANT: If you have a password and you change the key, you will be NOT able to start SWH.
echo.
set /p surechangepasswordkey=Change key anyway? (y/n): 
if /i "%surechangepasswordkey%"=="Y" goto changingpasswordkey


:changingpasswordkey
echo Generating new key for password...
cd /d "%pathswh%\Temp"
:generatepasswordkey
set randomKey1=%random:~-1%%random:~-1%%random:~-1%%random:~-1%%random:~-1%
set randomKey2=%random:~-1%%random:~-1%%random:~-1%%random:~-1%%random:~-1%
set randomKey3=%random:~-1%%random:~-1%%random:~-1%%random:~-1%
set randomKey4=%random:~-1%%random:~-1%%random:~-1%%random:~-1%
set randomKey5=%random:~-1%%random:~-1%%random:~-1%%random:~-1%
set randomKey6=%random:~-1%%random:~-1%%random:~-1%%random:~-1%


set randomGen1=(%randomKey1%*%randomKey2%)/2
set randomGen2=(%randomKey3%*%randomKey4%)/2
set randomGen3=(%randomKey5%*%randomKey6%)/2

set randomkeypassword=%randomKey1%-%randomKey2%-%randomKey3%
echo %randomkeypassword% >> "%pathswh%\Temp\KeyPSD"
for %%D in (KeyPSD) do (set lenghtkeypsd=%%~zD)
if "%lenghtkeypsd%"=="19" (cd /d "%cdirectory%" & goto changedpasswordkey)

:changedpasswordkey
echo.
del "%pathswh%\Temp\KeyPSD" /q /f
set /p viewnewkeypassword=Do you want to view current key? (y/n): 
if /i "%viewnewkeypassword%"=="Y" (goto credentialchangedpasswordkey)

:credentialchangedpasswordkey
echo.
set /p userswh=Username: 
if /i not "%userswh%"=="%username%" (
	echo.
	echo Incorrect user
	echo.
	goto swh
)
set /p passwordSWH=SWH Password: 
if "%passwordSWH%"=="%DecryptPSD%" (
	echo New password key: %randomkeypassword%
	echo.
	goto swh
) else (
	echo.
	echo Incorrect SWH password
	echo.
	goto swh
)






:scanvirus
echo.
if not exist "%programfiles%\Windows Defender\MpCmdRun.exe" (goto errornowindowsdefender)
set /p filetoscanav=File to be scanned with Windows Defender: 
if not exist %filetoscanav% (
	echo.
	echo Cannot find %filetoscanav%
	echo.
	goto swh
)
echo.
echo %filetoscanav% > %pathswh%\Temp\ScanVirus.txt
cd /d "%pathswh%\Temp"
for /f "tokens=1,2* delims=," %%V in (ScanVirus.txt) do (set pathscanvirus=%%~V)

"%programfiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -File "%pathscanvirus%"
echo.
cd /d "%cdirectory%"
goto swh




:errornowindowsdefender
echo Cannot find Windows Defender Command Line Scan %programfiles%\Windows Defender\MpCmdRun.exe
echo.
goto swh



:filesize
echo.
set /p filesize=File to have his size: 


Dim fso:Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Dim oFile:Set oFile = fso.GetFile("%filesize%")
Wscript.Echo oFile.Name ^& " : " ^& round(oFile.Size/1024/1024,2)







if not exist "%filesize%" (goto notexistfile_size)
for %%a in (%filesize%) do (set sizefileB=%%~za)
echo.
if "%sizefileB%" geq 
set /a sizefileKB=%sizefileB%/1024
if %sizefileKB% leq 1 (
	echo Size of %filesize%: %sizefileB% Bytes, less than 1 kB
	echo.
	goto swh
)
echo Size of %filesize%: %sizefileB% Bytes, %sizefileKB% kB
echo.
goto swh

:notexistfile_size
echo.
echo Cannot find %filesize%
echo.
goto swh






:resetstartlog
if %resetstartlog_%==1 (
	if exist %pathswh%\resetstartlog.opt del %pathswh%\resetstartlog.opt /q
	echo 0 > %pathswh%\resetstartlog.opt
	echo Each time that SWH starts the log file will not be cleared
	echo.
	goto swh
)
if %resetstartlog_%==0 (
	if exist %pathswh%\resetstartlog.opt del %pathswh%\resetstartlog.opt /q
	echo 1 > %pathswh%\resetstartlog.opt
	echo Each time that SWH starts the log file will be cleared.
	echo.
	goto swh
)


:swh_admin
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %pathswh%\Temp\AdminSWH.vbs
echo If WScript.Arguments.Length = 0 Then >> %pathswh%\Temp\AdminSWH.vbs
echo   Set ObjShell = CreateObject("Shell.Application") >> %pathswh%\Temp\AdminSWH.vbs
echo   ObjShell.ShellExecute "wscript.exe" _ >> %pathswh%\Temp\AdminSWH.vbs
echo     , """" ^& WScript.ScriptFullName ^& """ /admin", , "RunAs",1 >> %pathswh%\Temp\AdminSWH.vbs
echo   WScript.Quit >> %pathswh%\Temp\AdminSWH.vbs
echo End if >> %pathswh%\Temp\AdminSWH.vbs
echo Set ObjShell = CreateObject("WScript.Shell") >> %pathswh%\Temp\AdminSWH.vbs
echo objShell.Run "cmd.exe /c %pathswh%\SWH.bat" >> %pathswh%\Temp\AdminSWH.vbs
echo.
start WScript.exe "%pathswh%\Temp\AdminSWH.vbs"
goto swh

:download_internet
echo.
set download_ps1=%pathswh%\Temp\DownloadInternetSWH.ps1
echo Note: A website URL will download the website itself. To download, type for example, https://bit.ly/2DKAjxF (SWH Source code)
echo Download will be saved in: %pathswh%\Downloads
set /p downloadinternet=URL: 
set /p namesavedownloadinternet=Name to save your downloaded file (A file name cannot contain these characters: ^> ^< ^| : "" / * \ ?): 
echo $url = "%downloadinternet%" > %download_ps1%
echo $output = "%pathswh%\Downloads\%namesavedownloadinternet%" >> %download_ps1%
echo $start_time = Get-Date >> %download_ps1%
echo Invoke-WebRequest -Uri $url -OutFile $output >> %download_ps1%
PowerShell.exe "%download_ps1%"
echo.
if exist "%pathswh%\Downloads\%namesavedownloadinternet%" (echo File has been successfully downloaded & echo. & goto opendownloaddirY_N) else (
	echo Error downloading file! Try this:
	echo.
	echo    - Check your Internet connection
	echo    - Make sure that you have Windows PowerShell on your computer
	echo    - Check that the website is existent or available
	echo    - Check that you haven't writted a special symbol in list
	echo.
	goto swh
)
:opendownloaddirY_N
set /p opendownloaddir=Open SWH Downloads directory? (y/n): 
if /i "%opendownloaddir%"=="y" (start explorer.exe "%pathswh%\Downloads" &echo. &goto swh)
if /i "%opendownloaddir%"=="n" (echo. &goto swh) else (
	echo.
	echo Select a valid option!
	echo.
	goto swh
)

:errornotdisk
cd /d "%homedrive%\%homepath%"
choice /c:rf /n /m "Error reading current drive. Retry or fail?"
if errorlevel 2 goto failnotdisk
if errorlevel 1 goto retrynotdisk


:retrynotdisk
if not exist "%errordisk_%" goto errornotdisk
cd /d "%errordisk_%"
echo.
goto swh

:failnotdisk
echo.
echo Changing to a local drive...
cd /d "%homedrive%\"
echo.
goto swh


:editswh_github
echo.
echo E-Mail to contact with SWH developper (anic17) to make changes 
echo.
echo SWH.Console@gmail.com
echo.
echo Visit our project on GitHub!
timeout /t 2 /nobreak>nul
start https://github.com/anic17/SWH/
echo.
goto swh
:swhcontact
echo.
set /p subject_contact=Subject: 
set /p msgbody_contact=Message: 
echo $EmailFrom = "swh.usercontact@gmail.com" > %pathswh%\Temp\ContactSWH.ps1
echo $EmailTo = "SWH.Console@gmail.com" >> %pathswh%\Temp\ContactSWH.ps1
echo $Subject = "%subject_contact%" >> %pathswh%\Temp\ContactSWH.ps1
echo $Body = "%msgbody_contact%     - Sent from computer: %computername% , user: %username%." >> %pathswh%\Temp\ContactSWH.ps1
echo $SMTPServer = "smtp.gmail.com" >> %pathswh%\Temp\ContactSWH.ps1 >> %pathswh%\Temp\ContactSWH.ps1
echo $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) >> %pathswh%\Temp\ContactSWH.ps1
echo $SMTPClient.EnableSsl = $true >> %pathswh%\Temp\ContactSWH.ps1
echo $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("swh.usercontact@gmail.com", "SWH_%r%%z%%a%%g%%t%"); >> %pathswh%\Temp\ContactSWH.ps1
echo $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body) >> %pathswh%\Temp\ContactSWH.ps1
powershell.exe "%pathswh%\Temp\ContactSWH.ps1"
echo.
echo Message sent
echo.
echo Contact >> %pathswh%\SWH_History.txt
goto swh

:checkprocess
echo.
echo Note: A permanent check will use some computer ressources.
echo.
set /p chkss_permanenetornot=Permanent check (1) or instant check (2): 
if "%chkss_permanenetornot%"=="1" goto permanentchk_SS
if "%chkss_permanenetornot%"=="2" (goto instantchk_SS) else (
	echo.
	echo Please choose a valid option
	echo.
	goto swh
)

:permanentchk_SS
echo.
set /p permanent_chkss=Process to check: 
echo.
:permanent_Process_Loop
tasklist /fi "imagename eq %permanent_chkss%" > %pathswh%\Temp\CheckProcessPermanent.chk
cd /d "%pathswh%\Temp"
for %%i in (checkprocesspermanent.chk) do (set permanent_processCHK_size=%%~zi)
if %permanent_processCHK_size% gtr 100 (echo Founded process: %permanent_chkss%) else (echo Cannot find process %permanent_chkss%)
timeout /t 1 /nobreak>nul
cd /d "%cdirectory%"
goto permanent_Process_Loop


:instantchk_SS
echo.
set /p instant_chkss=Process to check: 
tasklist /fi "imagename eq %instant_chkSS%" > %pathswh%\Temp\CheckProcessInstant.chk
cd /d "%pathswh%\Temp"
echo.
for %%i in (CheckProcessInstant.chk) do (set instant_processCHK_size=%%~zi)
if %instant_processCHK_size% gtr 100 (echo Founded process: %instant_chkss%) else (echo Cannot find process %instant_chkss%)
cd /d "%cdirectory%"
echo.
goto swh


:networkmsg
echo.
echo Note: Two computers will need SWH in message mode and needs administrator permission the first time
echo.
set /p networkchatcomputer=Computer to send message: 
net share SWH_Chat=%pathswh% & echo Sharing SWH chat directory...

echo Message (Type "Send" to send message): 
:ntworkmsg_text
set networkchatmsg=[{CLSID:SWH-SendMessage-Key:g438tfhqon57wg4rejonwr8og5ut9w430ntung805-ENTER}]
set /p networkchatmsg=
if "%networkchatmsg%"=="[{CLSID:SWH-SendMessage-Key:g438tfhqon57wg4rejonwr8og5ut9w430ntung805-ENTER}]" (echo. >> "%pathswh%\Temp\Chat%networkchatcomputer%")
if "%networkchatmsg%"=="Send" (goto sendnetwork_msg) else (echo %networkchatmsg% >> "%pathswh%\Temp\Chat%networkchatcomputer%")

:sendnetwork_msg
copy "%pathswh%\Temp\Chat%networkchatcomputer%" "\\%networkchatcomputer%\SWH_Chat\Sended%networkchatcomputer%">nul
if exist "\\%networkchatcomputer%\SWH_Chat\Sended%networkchatcomputer%" (echo Message sent &goto ntworkmsg_text)






if exist "%pathswh%\Temp\Sended%networkchatcomputer%" (goto received_msg_chat)
:received_msg_chat
echo.
type "%pathswh%\Temp\Sended%networkchatcomputer%"
echo.
goto ntworkmsg_text






:viewstartlog
echo.
type %pathswh%\StartLog.log
echo.
goto swh


:newsSWH
echo.
echo What's new on Scripting Windows Host Console %ver%?
echo.
echo Encrypted password:
echo In previous versions, the password was visible in his password file.
echo Now it is encrypted, making Scripting Windows Host Console access only for people that know the password.
echo.
echo More functions, less size:
echo Scripting Windows Host Console Version %ver% tries to be more accessible with only %sizeSWHkB% kB, and with a lot of functions.
echo.
echo Added parameters:
echo Now you can run Scripting Windows Host Console with parameters like %~nx0 /admin or %~nx0 /c ^<command^>
echo This is very useful to automatize tasks.
echo.
echo Encrypt/Decrypt:
echo In previous versions, your encryption wasn't very safe if a person has your encrypted string and Scripting Windows Host Console.
echo Now you will create a key for add more security at your encryption.
echo To decrypt, you will need the key.
echo.
echo File Encryption/Decryption:
echo Now you can safely encrypt your personal files to make it innaccessible for other users, but accessible for you
echo.
echo More commands, more graphical:
echo Now Scripting Windows Host Console has 2 more packages:
echo     - Notepad (pkg install notepad)
echo     - Paint (pkg install paint)
echo Notepad has been created with intentions of replacing the command "file", because it will have more 
echo functions and it will be more graphical (Menus, mouse clicking...)
echo.
echo Fastest than never:
echo Scripting Windows Host Console start time has been reduced. In version 9 it takes 0,19 seconds to load
echo With the newest modifications, it takes only 0,08 seconds
echo.
echo Messaging and E-Mails
echo We have a command to send E-Mails without opening your E-mail program. And to receive E-Mails, to!


echo.
goto swh


:base64decode
echo.
echo Note: A invalid string will not be decoded, this function needs Windows PowerShell
echo.
echo Base64 Decoder: Decoding "U1dI" will be "SWH"
echo.
set /p base64decode=String to decode in Base64: 

cd /d %pathswh%\Temp

powershell "[Text.Encoding]::UTF8.GetString([convert]::FromBase64String(\"%base64decode%\"))" > "%pathswh%\Temp\DecodedBase64.txt"
type "%pathswh%\Temp\DecodedBase64.txt"
for /f "tokens=1,2* delims=," %%f in (DecodedBase64.txt) do (set decodedStringBase64=%%f)
echo.
set /p clipbase64decode=Copy decoded text to the clipboard? (y/n): 
if /i "%clipbase64decode%"=="y" (goto clipbase64decodeG) else (goto afterClipBase64Decode)
:clipbase64decodeG
clip < DecodedBase64.txt
:afterClipBase64Decode
echo Decoded "%base64decode%" to "%decodedStringBase64%"
echo.
cd /d "%cdirectory%"
goto swh

:base64encode
echo.
echo Note: This function needs Windows PowerShell
echo.
echo Base64 Encoder: Encoding "SWH" will be "U1dI"
echo.
set /p base64encode=String to encode in Base64: 
cd /d %pathswh%\Temp
powershell "[convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(\"%base64encode%\"))" > "%pathswh%\Temp\EncodedBase64.txt"
type "%pathswh%\Temp\EncodedBase64.txt"
for /f "tokens=1,2* delims=," %%q in (EncodedBase64.txt) do (set encodedStringBase64=%%q)
echo.
set /p clipbase64encode=Copy encoded text to the clipboard? (y/n): 
if /i "%clipbase64encode%"=="y" (goto clipbase64encodeG) else (goto afterClipBase64Encode)
:clipbase64encodeG
clip < EncodedBase64.txt
:afterClipBase64Encode
echo Encoded "%base64encode%" to "%encodedStringBase64%"
echo.
cd /d "%cdirectory%"
goto swh










:startSetup
echo.
echo Starting Scripting Windows Host Setup...
cd /d "%pathswh%\Temp"
echo $Url = "https://raw.githubusercontent.com/anic17/SWH/master/SWH_Setup.bat" > DownloadSWH_Setup.ps1
echo $output = "%pathswh%\Temp\SWH_Setup.bat" >> DownloadSWH_Setup.ps1
echo Invoke-WebRequest -Uri $url -OutFile $output >> DownloadSWH_Setup.ps1
PowerShell.exe "%pathswh%\Temp\DownloadSWH_Setup.ps1"
start cmd.exe /c "%pathswh%\Temp\SWH_Setup.bat"
cd /d "%cdirectory%"
echo.
goto swh


:widedir
dir /w
echo.
goto swh

:xdiskbootask
choice /c:NY /m "Are you sure you want to start SWH in boot mode? (y/n)" /n
if errorlevel 2 goto xdiskboot 
if errorlevel 1 echo.&goto swh


:xdiskboot
echo Starting SWH with X: drive compatibility...
echo.
set /p localdisk=Letter of the disk where Windows is installed (Ex: C): 
set localdisk2=%localdisk%:
set /p localappdataboot=Location of directory LocalAppData: 
set /p surelocalappdata=Make sure that %localappdataboot% is the correct name. To continue, type Y. To change, type N: 
if /i "%surelocalappdata%"=="y" (
	:startingbootmode
	set localappdata=%localappdataboot%
	set pathswh=%localappdata%\ScriptingWindowsHost
	mkdir %pathswh%>nul
	mkdir %pathswh%\Settings>nul
	mkdir %pathswh%\Temp>nul
	echo. > %pathswh%\SWH_History.txt
	echo SWH was configured to run on boot mode
	set xdiskcomp=(Disk compatibility)
	pause>nul
	echo.
	goto startswh
) else (
	set /p correctlocalappdatanamebootask=Correct name of %localappdataboot%: 
	goto surecorrectlocalappdata
)


:surecorrectlocalappdata
set /p correctlocalappdatanameboot=This time %localappdata% is %correctlocalappdatanamebootask%? (y/n): 
if /i "%correctlocalappdatanameboot%"=="y" (goto startingbootmode) else (
	echo You will be changed to SWH (Normal mode)
	echo.
	goto swh
)


echo.
goto swh

:firmwareaccess
if %admin%==0 (goto errornotadminBIOS)
set /p sureenterbios=Are you sure do you want to enter computer firmware? The computer will be restarted (y/n): 
set sureenterbios2="%sureenterbios%"
if /i %sureenterbios2%=="y" (goto enteringBIOS) else (
	echo.
	goto swh
)
:enteringBIOS
echo Entering computer firmware... (UEFI/BIOS)
shutdown -r -t 0 -fw
echo.
goto swh

:errornotadminBIOS
echo swh=msgbox("To access computer firmware you will need administrator privileges",4112,"Access denied. Run SWH as administrator") > %pathswh%\Temp\FW_ErrorAdmin.vbs
start /wait wscript.exe "%pathswh%\Temp\FW_ErrorAdmin.vbs"
echo.
goto swh

:userinfo
set /p userinfo_=User that you would to have his information: 
net user %userinfo_%
echo.
goto swh

:incommand
echo Incorrect command: %cmd% >> "%pathswh%\SWH_History.txt"
echo %incotext%
echo.
goto swh

:cmdClip
set /p texttclip=Text to copy in the clipboard: 
echo %texttclip% | clip
echo.
echo %texttclip% copied to the clipboard
echo.
goto swh

:winver
ver
echo.
goto swh

:accessonlyuser
if %admin%==0 (goto adminpermission)
echo.
if %userblock%==0 (
	set %userblock%=1
	goto blockusers
)
if %userblock%==1 (
	set userblock=0
	goto unblockusers
)
:blockusers
set /p userblock=Are you sure you want to block SWH for all users except "%username%"? (y/n): 
if /i "%userblock%"=="y" (
	echo %username%> "%programfiles%\SWH\ApplicationData\BU.dat"
	echo All users except "%username%" have been blocked
	echo.
	goto swh
) else (
	echo.
	goto swh
)

:unblockusers
set /p userunblock=Are you sure you want to unblock SWH for all users? (y/n): 
if /i %userunblock%==y (
	del %programfiles%\SWH\ApplicationData\BU.dat /q
	echo All users has been unblocked
	echo.
	goto swh
) else (
	echo.
	goto swh
)


:setpassword
if %admin%==0 goto adminpermission
echo.
if "%psd%"=="[{CLSID:8t4tvry4893tvy2nq4928trvyn14098vny84309tvny493q8tvn0943tyvnu0q943t8vn204vmy10vn05}]" (goto notpasswordsettet)
set /p enterpassword2setit=Enter the current password to change it: 
set enterpassword2setit="%enterpassword2setit%" 
if not "%psd%"==""%enterpassword2setit%"" (goto errorremovingpsd)
:notpasswordsettet
set /p setpassword1=Password to set in SWH: 
if /i "%setpassword1%"=="" (goto swh)
set password2qwerty="%setpassword1%"
if /i %password2qwerty%=="qwerty" (goto easypassword)
if /i %password2qwerty%=="123456" (goto easypassword)
if /i %password2qwerty%=="qwertz" (goto easypassword)
if /i %password2qwerty%=="azerty" (goto easypassword)
if /i %password2qwerty%=="654321" (goto easypassword)
if /i %password2qwerty%=="123123" (goto easypassword)
if /i %password2qwerty%=="password" (goto easypassword)
if /i %password2qwerty%=="12345678" (goto easypassword)
if /i %password2qwerty%=="1234567" (goto easypassword)
if /i %password2qwerty%=="12345" (goto easypassword)
if /i %password2qwerty%=="abcdef" (goto easypassword)
if /i %password2qwerty%=="qwertyuiop" (goto easypassword)
if /i %password2qwerty%=="abc123" (goto easypassword)
if /i %password2qwerty%=="passw0rd" (goto easypassword)
if /i %password2qwerty%=="login" (goto easypassword)
if /i %password2qwerty%=="abcdefghi" (goto easypassword)
if /i %password2qwerty%=="000000" (goto easypassword)
if /i %password2qwerty%=="100000" (goto easypassword)
if /i %password2qwerty%=="010101" (goto easypassword)
if /i %password2qwerty%=="111111" (goto easypassword)
if /i %password2qwerty%=="191919" (goto easypassword)
if /i %password2qwerty%=="poiuytrewq" (goto easypassword)
if /i %password2qwerty%=="asdfghjklñ" (goto easypassword)
if /i %password2qwerty%=="zxcvbnm" (goto easypassword)
if /i %password2qwerty%=="mnbvcxz" (goto easypassword)
if /i %password2qwerty%=="ñlkjhgfdsa" (goto easypassword)
if /i %password2qwerty%=="abcde" (goto easypassword)
if /i %password2qwerty%=="abcd" (goto easypassword)
if /i %password2qwerty%=="abc" (goto easypassword)
if /i %password2qwerty%=="ab" (goto easypassword)
if /i %password2qwerty%=="a" (goto easypassword)
if /i %password2qwerty%=="xyz" (goto easypassword)
if /i %password2qwerty%=="321" (goto easypassword)
if /i %password2qwerty%=="987654321" (goto easypassword)
if /i %password2qwerty%=="121212" (goto easypassword)
if /i %password2qwerty%=="1" (goto easypassword)
if /i %password2qwerty%=="2" (goto easypassword)
if /i %password2qwerty%=="3" (goto easypassword)
if /i %password2qwerty%=="4" (goto easypassword)
if /i %password2qwerty%=="5" (goto easypassword)
if /i %password2qwerty%=="6" (goto easypassword)
if /i %password2qwerty%=="7" (goto easypassword)
if /i %password2qwerty%=="8" (goto easypassword)
if /i %password2qwerty%=="9" (goto easypassword)
if /i %password2qwerty%=="10" (goto easypassword)
if /i %password2qwerty%=="11" (goto easypassword)
if /i %password2qwerty%=="letmein" (goto easypassword)
if /i %password2qwerty%=="baseball" (goto easypassword)
if /i %password2qwerty%=="monkey" (goto easypassword)
if /i %password2qwerty%=="internet" (goto easypassword)
if /i %password2qwerty%=="swh" (goto easypassword)
if /i %password2qwerty%=="trustno1" (goto easypassword)
if /i %password2qwerty%=="log1n" (goto easypassword)
if /i %password2qwerty%=="dragon" (goto easypassword)
if /i %password2qwerty%=="superman" (goto easypassword)
if /i %password2qwerty%=="welcome" (goto easypassword)
if /i %password2qwerty%=="1234" (goto easypassword)
if /i %password2qwerty%=="0" (goto easypassword)
if /i %password2qwerty%=="cheese" (goto easypassword)
if /i %password2qwerty%=="lifehack" (goto easypassword)
if /i %password2qwerty%=="11" (goto easypassword)
if /i %password2qwerty%=="666666" (goto easypassword)
if /i %password2qwerty%=="98654321" (goto easypassword)
if /i %password2qwerty%=="jordan" (goto easypassword)
if /i %password2qwerty%=="consumer" (goto easypassword)
if /i %password2qwerty%=="pepper" (goto easypassword)
if /i %password2qwerty%=="pokemon" (goto easypassword)
if /i %password2qwerty%=="batman" (goto easypassword)
if /i %password2qwerty%=="gizmodo" (goto easypassword)
if /i %password2qwerty%=="%username%" (goto easypassword)
if /i %password2qwerty%=="adobe123" (goto easypassword)
if /i %password2qwerty%=="iloveyou" (goto easypassword)
if /i %password2qwerty%=="raspberry" (goto easypassword)
if /i %password2qwerty%=="admin" (goto easypassword)
if /i %password2qwerty%=="ubnt" (goto easypassword)
if /i %password2qwerty%=="test" (goto easypassword)
if /i %password2qwerty%=="user" (goto easypassword)
if /i %password2qwerty%=="blink182" (goto easypassword)
if /i %password2qwerty%=="password1" (goto easypassword)
if /i %password2qwerty%=="myspace1" (goto easypassword)
if /i %password2qwerty%=="sunshine" (goto easypassword)
if /i %password2qwerty%=="princess" (goto easypassword)
if /i %password2qwerty%=="football" (goto easypassword)
if /i %password2qwerty%=="!@#$%^&*" (goto easypassword)
if /i %password2qwerty%=="aa123456" (goto easypassword)
if /i %password2qwerty%=="donald" (goto easypassword)
if /i %password2qwerty%=="qwerty123" (goto easypassword)
if /i %password2qwerty%=="123456789" (goto easypassword)
if /i %password2qwerty%=="000" (goto easypassword)
if /i %password2qwerty%=="windows" (goto easypassword)
if /i %password2qwerty%=="mypc" (goto easypassword)
if /i %password2qwerty%=="computer" (goto easypassword)
if /i %password2qwerty%=="bypass" (goto easypassword)
if /i %password2qwerty%=="diamond" (goto easypassword)
if /i %password2qwerty%=="l0gin" (goto easypassword)
if /i %password2qwerty%=="l0g1n" (goto easypassword)
if /i %password2qwerty%=="google" (goto easypassword)
if /i %password2qwerty%=="hello" (goto easypassword)
if /i %password2qwerty%=="hi" (goto easypassword)
if /i %password2qwerty%=="access" (goto easypassword)
if /i %password2qwerty%=="sure" (goto easypassword)
if /i %password2qwerty%=="321qwerty" (goto easypassword)
if /i %password2qwerty%=="321azerty" (goto easypassword)
if /i %password2qwerty%=="321qwertz" (goto easypassword)
if /i %password2qwerty%=="123" (goto easypassword)
cd /d "%pathswh%\Temp"
echo %password2qwerty% > "%pathswh%\Temp\ckps"
for %%P in (ckps) do (set psdlenght=%%~zP)
::if exist "%pathswh%\Temp\ckps" del "%pathswh%\Temp\ckps" /q /f 
set /a psdlenght_=%psdlenght%-3
cd /d "%cdirectory%"
if "%psdlenght_%" leq "5" (goto easypassword)







set /p setpassword2=Repeat password: 
if "%setpassword2%"=="%setpassword1%" (goto changingpassword) else (goto errorchangingpassword)

:easypassword
echo.
echo This password is too easy to know. Please choose another password
echo.
goto swh

:errorchangingpassword
echo.
echo Two passwords are not the same
echo.
goto swh

:changingpassword


cd /d "%pathswh%\Temp"



echo Option Explicit > Encrypt.vbs
echo Dim temp, key, objShell, objFSO, crypt >> Encrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Encrypt.vbs
echo temp = "%setpassword2%" >> Encrypt.vbs
echo key = "4Ou8fa94pfx3WV3AsnhoAz7xWbtkA5T36SMX7sOB9I8WazaCirdOT1HfhBJBKvZlQDMRIGEH49vPK5KTDPTaIPVT8h3F57QW3RYbJ0WrT90Fxk3EBcMCz0APGZebZWkZH2JvGuFqs8mvICYG4uZW2MYnXwPmnVa8S4HCEgeQRPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4IRQ0261QCeJHPBj71LKIqGDbWBTrLBh8wPONCYVM0F4RPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4" >> Encrypt.vbs
echo temp = Encrypt(temp,key) >> Encrypt.vbs

echo Set objFSO = createobject("scripting.filesystemobject") >> Encrypt.vbs
echo Set crypt = objfso.createtextfile("PS.dat",true)  >> Encrypt.vbs
echo crypt.writeline "" ^&temp >> Encrypt.vbs
echo crypt.close >> Encrypt.vbs

echo temp = Decrypt(temp,key) >> Encrypt.vbs
echo Function encrypt(Str, key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str = StrReverse(str) >> Encrypt.vbs
echo  For x = 1 To LenStr >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = keypos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  Next >> Encrypt.vbs
echo  encrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
echo Function Decrypt(str,key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str=StrReverse(str) >> Encrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = KeyPos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs
echo       Next >> Encrypt.vbs
echo       Newstr=StrReverse(Newstr) >> Encrypt.vbs
echo       Decrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
if exist "%programfiles%\SWH\ApplicationData\PS.dat" (del "%programfiles%\SWH\ApplicationData\PS.dat" /q)
start /wait WScript.exe "%pathswh%\Temp\Encrypt.vbs"
move "%pathswh%\Temp\PS.dat" "%programfiles%\SWH\ApplicationData\PS.dat">nul


echo.
cd /d "%cdirectory%"
echo New password is %setpassword1%
echo.
if exist "%pathswh%\Temp\Encrypt.vbs" (del "%pathswh%\Temp\Encrypt.vbs" /q)
goto swh

:removepassword
echo.
set /p removingpasswordchk=To remove the password you need to enter it first: 
if "%removingpasswordchk%"=="%psd%" (goto removingpsd) else (goto errorremovingpsd)
:removingpsd
del "%programfiles%\SWH\ApplicationData\PS.dat" /q
echo.
echo Password successfully removed
echo.
goto swh

:errorremovingpsd
echo.
echo Incorrect password
echo.
goto swh

:adminpermission
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

rem Please run SWH as administrator


echo.
call :ColorText 0C "P"
call :ColorText 0C "l"
call :ColorText 0C "e"
call :ColorText 0C "a"
call :ColorText 0C "s"
call :ColorText 0C "e "
call :ColorText 0C " r"
call :ColorText 0C "u"
call :ColorText 0C "n "
call :ColorText 0C " S"
call :ColorText 0C "W"
call :ColorText 0C "H "
call :ColorText 0C " a"
call :ColorText 0C "s "
call :ColorText 0C " a"
call :ColorText 0C "d"
call :ColorText 0C "m"
call :ColorText 0C "i"
call :ColorText 0C "n" 
call :ColorText 0C "i"
call :ColorText 0C "s"
call :ColorText 0C "t"
call :ColorText 0C "r"
call :ColorText 0C "a"
call :ColorText 0C "t"
call :ColorText 0C "o"
call :ColorText 0C "r"
echo.
echo. & goto swh

:swhver
echo.
if "%securever%"=="%ver%" (echo SWH Version: %ver%) else (set ver=%securever% & echo SWH Version: %ver%)
echo.
goto swh

:read
if %moreCMD%==1 (goto ReadMore)
set /p read=File to read: 
echo.
type %read%
echo.
echo.
goto swh
:ReadMore
set /p readMore=File to read: 
echo.
more %readMore%
echo.
echo.
goto swh

:moreWalk
echo.
if %moreCMD%==1 (
	set moreCMD=0
	echo More has been disabled.
	goto swh
)
if %moreCMD%==0 ( 
	set moreCMD=1
	echo More has been enabled.
	goto swh
)


:scriptproject2
echo.
echo Projects will come soon. To install it in the future, please install each SWH update
echo.
goto swh

:cdDisk
cd\
echo.
goto swh

:cdBack
cd..
echo.
goto swh


:updateswh
echo.


echo $url = "https://raw.githubusercontent.com/anic17/SWH/master/SWH.bat" > %pathswh%\Temp\UpdateSWH.ps1
echo $output = "%pathswh%\Temp\SWH.bat" >> %pathswh%\Temp\UpdateSWH.ps1
echo $start_time = Get-Date >> %pathswh%\Temp\UpdateSWH.ps1
echo Invoke-WebRequest -Uri $url -OutFile $output >> %pathswh%\Temp\UpdateSWH.ps1
echo Dowloading SWH...
powershell.exe "%pathswh%\Temp\UpdateSWH.ps1"
if exist "%pathswh%\Temp\SWH.bat" (goto supdated) else (goto errorupdatingswh)

:errorupdatingswh
echo.
echo Error: Cannot update SWH! Check your Internet connection
:supdated
move "%pathswh%\SWH.bat" "%pathswh%\OldSWH\SWH.bat">nul
move "%pathswh%\Temp\SWH.bat" "%pathswh%\SWH.bat">nul
echo SWH has been updated!
echo swh=Msgbox("SWH has successfully been updated",4160,"SWH has successfully been updated") > "%pathswh%\Temp\SUpdated.vbs"
start wscript.exe "%pathswh%\Temp\SUpdated.vbs"
echo.
goto swh




:decrypttext
echo.
echo Note: SWH only can decrypt text encrypted by it
echo.
set /p texttodecrypt=Text to decrypt: 
set /p keydecrypt=Key to decrypt your string: 
cd /d "%pathswh%\Temp"
echo Option Explicit > Decrypt.vbs
echo On Error Resume Next >> Decrypt.vbs
echo Dim temp, key, objShell, objFSO, decrypt >> Decrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Decrypt.vbs
echo temp = "%texttodecrypt%" >> Decrypt.vbs
echo key = "%keydecrypt%" >> Decrypt.vbs
echo temp = DecryptING(temp,key) >> Decrypt.vbs
echo Set objFSO = createobject("scripting.filesystemobject") >> Decrypt.vbs 
echo Set decrypt = objfso.createtextfile("decrypt.txt",true) >> Decrypt.vbs
echo decrypt.writeline "" ^&temp >> Decrypt.vbs
echo decrypt.close >> Decrypt.vbs
echo temp = DecryptING(temp,key) >> Decrypt.vbs
echo Function encrypt(Str, key) >> Decrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str = StrReverse(str) >> Decrypt.vbs
echo  For x = 1 To LenStr >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = keypos+1 >> Decrypt.vbs
echo       If KeyPos > lenKey Then KeyPos = 1 >> Decrypt.vbs
echo  Next >> Decrypt.vbs
echo  Decrypt = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
echo Function DecryptING(str,key)>> Decrypt.vbs 
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str=StrReverse(str) >> Decrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = KeyPos+1 >> Decrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Decrypt.vbs 
echo       Next >> Decrypt.vbs
echo       Newstr=StrReverse(Newstr)>> Decrypt.vbs 
echo       DecryptING = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
start /wait wscript.exe "%pathswh%\Temp\Decrypt.vbs"
echo.
echo.
type "%pathswh%\Temp\Decrypt.txt"
echo.
cd /d "%cdirectory%"
goto swh














:encrypttext

if exist %pathswh%\Temp\encrypt.txt (del %pathswh%\Temp\encrypt.txt /q>nul)
if exist %pathswh%\Temp\encrypt.vbs (del %pathswh%\Temp\encrypt.vbs /q>nul)
echo.
set /p texttoencrypt=Text to encrypt: 
set /p keyencrypt=Key to encrypt your string (Key is needed for decryption): 
if "%keyencrypt%"=="" (goto generateencryptkey) else (goto nextencryptkey)

:generateencryptkey
set key_del2min=%pathswh%\Key_%random:~-1%.txt
	set randomKey_=%random:~-1%%random:~-1%%random:~-1%%random:~-1%%random:~-1%
	set randomKey2_=%random:~-1%%random:~-1%%random:~-1%%random:~-1%%random:~-1%
	set randomKey3_=%random:~-1%%random:~-1%%random:~-1%%random:~-1%%random:~-1%
	set randomKey4_=%random:~-1%%random:~-1%%random:~-1%%random:~-1%%random:~-1%
	set keyencrypt=%randomKey_%-%randomKey2_%-%randomKey3_%-%randomKey4_%
	echo.
	echo Random key for decryption: %keyencrypt%
	echo.
	echo Key has been saved as: %key_del2min%
	echo In 2 minutes private key will be deleted
	echo Key for decryption:> "%key_del2min%"
	echo.>> "%key_del2min%"
	echo %keyencrypt%>> "%key_del2min%"

	echo WScript.Sleep(120000) > "%pathswh%\Temp\DelKey.vbs"
	echo CreateObject("WScript.Shell").Run "cmd.exe /c del %key_del2min% /q",vbHide >> "%pathswh%\Temp\DelKey.vbs"
	start WScript.exe "%pathswh%\Temp\DelKey.vbs"
:nextencryptkey
cd /d "%pathswh%\Temp"

echo Option Explicit > Encrypt.vbs
echo On Error Resume Next >> Encrypt.vbs
echo Dim temp, key, objShell, objFSO, crypt >> Encrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Encrypt.vbs
echo temp = "%texttoencrypt%" >> Encrypt.vbs
echo key = "%keyencrypt%" >> Encrypt.vbs
echo temp = Encrypt(temp,key) >> Encrypt.vbs

echo Set objFSO = createobject("scripting.filesystemobject") >> Encrypt.vbs
echo Set crypt = objfso.createtextfile("encrypt.txt",true)  >> Encrypt.vbs
echo crypt.writeline "" ^&temp >> Encrypt.vbs
echo crypt.close >> Encrypt.vbs

echo temp = Decrypt(temp,key) >> Encrypt.vbs
echo Function encrypt(Str, key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str = StrReverse(str) >> Encrypt.vbs
echo  For x = 1 To LenStr >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = keypos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs
echo  Next >> Encrypt.vbs
echo  encrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
echo Function Decrypt(str,key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str=StrReverse(str) >> Encrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = KeyPos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs
echo       Next >> Encrypt.vbs
echo       Newstr=StrReverse(Newstr) >> Encrypt.vbs
echo       Decrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
start /wait wscript.exe "%pathswh%\Temp\encrypt.vbs"
echo.
echo.
type "%pathswh%\Temp\encrypt.txt"
echo.
echo.
set /p encryptcopyclip=Copy encrypted text to the clipboard (y/n): 
if /i "%encryptcopyclip%"=="y" (
	clip < "%pathswh%\Temp\encrypt.txt"
)
echo.
echo.
set texttoencrypt=
set keyencrypt=
cd /d "%cdirectory%"
goto swh








:SWHdiskCleaner
if not %admin%==0 (goto correctdiskcleaner)
echo.
echo Please run SWH Disk Cleaner as administrator
echo swh=msgbox("Please run SWH Disk Cleaner as administrator",4112,"Please run SWH Disk Cleaner as administrator") > %pathswh%\Temp\RunDiskAdmin.vbs
start /wait wscript.exe "%pathswh%\Temp\RunDiskAdmin.vbs"
echo.
goto swh


:correctdiskcleaner



rem SWH Disk Cleaner
echo.
title Scripting Windows Host Disk Cleaner
echo Welcome to the Scripting Windows Host Disk Cleaner
echo.
echo Press "C" to clear disk space, press "Q" to quit
choice /c:QC /N>nul
if errorlevel 2 goto clsDisk
if errorlevel 1 goto swh

:clsDisk
echo.
echo Searching junk...
if not exist *.* (
	set sizeJunkWinTemp=0
	goto passedWinTempJunk
)
cd /d %SystemRoot%\Temp
copy *.* JunkWinTemp>nul
for %%W in (JunkWinTemp) do (set sizeJunkWinTemp=%%~zW)
:passedWinTempJunk
cd /d "%tmp%"
if not exist *.* (
	set sizeJunkTemp=0
	goto passedDownloadsTemp
)
copy *.* JunkTemp>nul
for %%T in (JunkTemp) do (set sizeJunkTemp=%%~zT)
:passedDownloadsTemp
cd /d "%userprofile%\Downloads"
if not exist *.* (
	set sizeJunkDownloads=0
	goto passedDownloadsJunk
)
copy *.* JunkDownloads>nul
for %%D in (JunkDownloads) do (set sizeJunkDownloads=%%~zD)
timeout /t 1 /nobreak>nul
cd /d "%pathswh%\Temp"
copy *.* JunkSWHTemp>nul
for %%S in (JunkSWHTemp) do (set sizeJunkSWHtemp=%%~zS)

:passedDownloadsJunk



set /a totalJunkSWH_DiskCleaner=%sizeJunkWinTemp%+%sizeJunkTemp%+%sizeJunkDownloads%+%sizeJunkSWHtemp%

set /a totalJunkKB=%totalJunkSWH_DiskCleaner%/1024

rem Size on kB of Rubbish
set /a swhtempJunkKB=%sizeJunkSWHtemp%/1024
set /a wintempJunkKB=%sizeJunkWinTemp%/1024
set /a downloadsJunkKB=%sizeJunkDownloads%/1024
set /a tempJunkKB=%sizeJunkTemp%/1024


echo.
echo A total space of %totalJunkSWH_DiskCleaner% bytes can be cleaned (%totalJunkKB% kB)
echo.
echo Downloads: %sizeJunkDownloads% Bytes (%downloadsJunkKB% kB)
echo Temp: %sizeJunkTemp% Bytes (%tempJunkKB% kB)
echo Windows Temp: %sizeJunkWinTemp% Bytes (%wintempJunkKB% kB)
echo SWH Temp files: %sizeJunkSWHtemp% Bytes (%swhtempJunkKB% kB)
echo.
del "%userprofile%\Downloads\JunkDownloads" /q>nul
del "%SystemRoot%\Temp\JunkWinTemp" /q /s>nul
del "%tmp%\JunkTemp" /q /s>nul
set /p surecleardiskspace=Clear all this files? (%totalJunkSWH_DiskCleaner% Bytes will be cleaned, %totalJunkKB% kB) (y/n): 
if /i "%surecleardiskspace%"=="y" (
	echo Clearing Downloads...
	del %userprofile%\Downloads /s /q>nul
	echo Clearing Temp...
	del %tmp% /s /q>nul
	echo Clearing Windows Temp...
	del %systemroot%\Temp /s /q>nul
	echo Clearing SWH Temp files...
	del %pathswh%\Temp /q>nul
	echo.
	echo Cleaned %totalJunkKB% kB!
)
echo.
cd /d %cdirectory%
goto swh














:settings
echo.
set /p settingssave=Settings (Type "helpsettings" in SWH Console to see the available settings): 
set settingssave2="%settingssave%"
set settingssave=%settingssave2%
if %settingssave%=="size" (goto SettingsSize)
if %settingssave%=="consoletext" (goto SettingContext) else (goto incosetting)
:incosetting
echo.
echo This setting does not exist. Type "helpsettings" to see the settings avaiable.
echo.
goto swh
:SettingsSize
set /p settingssizesave=Are you sure that you would change the default console size? (y/n): 
if "%settingssizesave%"=="y" (goto savingsettingssize1) else (
	echo.
	goto swh
)
:settingcontext
set /p commandtoexecute4=New text on console line: 
set cmdte4="%commandtoexecute4%"
if "%cmdte4%"=="%commandtoexecute%"  (
	echo You need to change the console line
	echo.
	goto swh
) else (
	set /p surecontextnew=Are you sure that you would change the default console text? (y/n): 
	if "%surecontextnew%"=="y" (goto changingconsoletext) else (goto nochangingcontext)
)

:hsettings
echo.
echo Settings:
echo.
echo prompt: Changes the %commandtoexecute% text
echo size: Changes the default size
echo 
echo.
goto swh

:changingconsoletext
echo %commandtoexecute4% > "%pathswh%\ScriptingWindowsHost\Settings\ConsoleText.opt"
echo.
goto swh

:nochangingcontext
echo.
goto swh

:abstartswh
if not exist "%pathswh%\SWH.*" (
	echo.
	echo Please install SWH to use this function
	echo.
	echo You can install it with the command "setup"
	echo Note: Install SWH requires administrator privileges
	echo.
	goto swh
)

echo @echo off > "%pathswh%\Temp\CommandSWH.bat"
echo mode con: cols=15 lines=1 >> "%pathswh%\Temp\CommandSWH.bat"
echo start conhost.exe "%pathswh%\%~nx0" >> "%pathswh%\Temp\CommandSWH.bat"
echo exit >> "%pathswh%\Temp\CommandSWH.bat"
cd /d %pathswh%\Temp
start conhost.exe CommandSWH.bat
exit /b

:clsTemp
echo.
set /p sureclstmp=Are you sure would remove temporal files? (y/n): 
if /i "%sureclstmp%"=="y" (
	del %tmp% /s /q /f >nul
	rd %tmp% /s /q >nul
	echo.
	goto swh
) else (
	echo.
	goto swh
)
:clsWinTMP
echo.
echo Note: Clear Windows temporal files in %windir%\Temp requires administrator permission
echo.
set /p sureclsWinTMP=Are you sure would remove Windows tempotal files in %SystemRoot%\Temp? (y/n): 
if /i "sureclsWinTMP"=="y" (
	del %Systemroot%\Temp /s /q /f>nul
	echo.
	goto swh
) else (
	echo.
	goto swh
)


:execinfo
echo.
echo SWH executed at: %execdate% %exectime%
echo Executed with the name of "%~nx0", in directory "%execdir%"
echo SWH size: %~z0 Bytes (%sizeSWHkB% kB)
echo SWH modification date: %~t0
echo SWH version: %ver%
if %admin%==1 (echo SWH is running with administrator privileges) else (echo SWH is not running with administrator privileges)
:execinfoCHKifinstalled_
if "%~dpnx0"=="%pathswh%\%~nx0" (echo Using the installed version) else (goto execinfoCHKinstall)
echo.
goto swh

:execinfoCHKinstall
if exist "%pathswh%\%~nx0" (
	echo SWH is installed, using portable version
	echo.
	goto swh
)
:CHKinstallexecinfo
if not exist "%Localappdata%\%~nx0" (
	echo SWH is not installed, using portable version.
	echo.
	goto swh
)


:resetsettings
echo.
set /p rsettings=Are you sure that you would reset ALL settings? (y/n): 
if /i "%rsettings%"=="Y" (goto rstingset) else (
	echo.
	goto swh
)
:rstingset
cd /d %pathswh%
rd Settings /s /q
md Settings
echo.
cd %cdirectory%
goto swh

:faq
echo.
echo Frequent asked questions
echo.
echo.
echo 1)
echo Why if I change the path it adds %Windir% and %Windir%\System32?
echo.
echo It adds it automatically because many SWH functions work with this path.
echo.
echo.
echo 2)
echo Can I remove this two paths (%Windir% and %Windir%\System32)?
echo.
echo Yes, you can change it with the command "systempath"
echo.
echo.
echo 3) If I typed "systempath", how I add the %windir% and %windir%\System32 variables?
echo.
echo You need to type "systempath" if the system path is disabled.
echo.
echo 4)
echo With what method of encryption my password is ensured?
echo.
echo SWH uses a self-created encryption method. We cannot say it, because decrypting the password will be easier.
goto swh

:commandCom
if not exist %Windir%\System32\command.com (goto commandcom_NotExist)
cd /d "%Windir%\System32"
start command.com
cd /d "%cdirectory%"
goto swh
:commandcom_NotExist
echo swh=MsgBox("SWH can't find the file %windir%\System32\command.com",4112,"SWH can't find the file %windir%\System32\command.com") > %pathswh%\Temp\ErrorCommand.vbs
start /wait wscript.exe "%pathswh%\Temp\ErrorCommand.vbs"
echo.
goto swh


:SysInfo
echo.
%windir%\System32\systeminfo.exe
echo.
goto swh

:Syspath
if %syspathvar%==1 goto aftersyspathvar
set syspathvar=1
:RsysPathvar
echo.
echo Path stablished only %path%
echo.
echo.
echo Note that setting an incorrect path will make SWH not work good.
goto swh

:aftersyspathvar
set syspathvar=0
goto RsysPathvar

:chPath
echo.
echo Note: Changing incorrectelly the path can do that SWH don't work!
echo.
if %syspathvar%==1 (
	echo Path won't add %Windir% and %Windir%\System32 because systempath is disabled.
	echo.
)
if %syspathvar%==0 (
	echo Path will add %Windir% and %Windir%\System32 because systempath is enabled.
	echo.
)
echo Press Y to change path, press N to return to SWH
choice /c:NY /N>nul
if errorlevel==2 (goto changingpath)
if errorlevel==1 (
	echo.
	goto swh
)
goto swh
:changingpath
set oldpath=%path%
set /p newpath=New path: 
path=%newpath%
echo Path %oldpath% changed to %newpath%
if %syspathvar%==1 (goto swh)
path=%newpath%;%Windir%;%Windir%\System32
goto swh


:randomnumber
echo.
echo Note: SWH cannot generate random numbers bigger than 32757
echo.
set /p ranksmallest=Smallest possible random number: 
set /p rankbiggest=Biggest possible random number: 
echo.
set /a ResultRandom=(%RANDOM%*%rankbiggest%/32768)+%ranksmallest%
echo %ResultRandom%
echo.
goto swh

:ipconfig
echo.
ipconfig
echo.
goto swh

:swhzip
echo.
title Scripting Windows Host File Compressor
echo Welcome to the Scripting Windows Host file compressor.
:startcompress123
set direc=%cd%

echo Set wShell=CreateObject("WScript.Shell") > "%pathswh%\Temp\SelectFileSWHZip.vbs"
echo Set oExec=wShell.Exec("mshta.exe ""about:<title>Select file</title><input type=file id=FILE><script>FILE.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);close();resizeTo(0,0);</script>""") >> "%pathswh%\Temp\SelectFileSWHZip.vbs"
echo sFileSelected = oExec.StdOut.ReadLine >> "%pathswh%\Temp\SelectFileSWHZip.vbs"


echo Set objFSO= createObject("Scripting.FileSystemObject") >> "%pathswh%\Temp\SelectFileSWHZip.vbs"
echo Set swhzipselect = objfso.createtextfile("%pathswh%\Temp\SelectFileSWHZip.txt",true) >> "%pathswh%\Temp\SelectFileSWHZip.vbs"
echo swhzipselect.writeline sFileSelected >> "%pathswh%\Temp\SelectFileSWHZip.vbs"
echo swhzipselect.close >> "%pathswh%\Temp\SelectFileSWHZip.vbs"


start /wait WScript.exe "%pathswh%\Temp\SelectFileSWHZip.vbs"
cd /d "%pathswh%\Temp"
for /f "tokens=1,2* delims=," %%a in (SelectFileSWHZip.txt) do (set ftc=%%a)
set ext=swhzip
goto cmprssing

:cmprssing
echo.
if "%ftc%"=="" (
	echo.
	echo You must specify a file to compress
	echo.
	cd /d "%cdirectory%"
	goto swh
)
echo Compressing... Please wait

@md "%pathswh%\SWHZip\%ftc%"


powershell -Command Compress-Archive %ftc% %ftc%.zip>nul

ren %ftc%.zip %ftc%.swhzip


copy "%ftc%" "%localappdata%\ScriptingWindowsHost\SwhZip\%ftc%">nul
echo %ftc% is compressed to the name %ftc%.%ext%
echo.
echo Press any key to exit SWHZip...
pause>nul
echo.
if "%username%"=="SYSTEM" (title Scripting Windows Host Console - Running as NT AUTHORITY\SYSTEM) else (title Scripting Windows Host Console)
goto swh

:impocmprs
echo.
echo "%surecmpr%" is not a valid option.
echo.
echo Press any key to exit SWHZip...
pause>nul
if "%username%"=="SYSTEM" (title Scripting Windows Host Console - Running as NT AUTHORITY\SYSTEM) else (title Scripting Windows Host Console)
goto swh
:cancelcmprs
echo.
echo "%ftc%" compression canceled.
echo.
echo Press any key to exit SWHZip...
pause>nul
if "%username%"=="SYSTEM" (title Scripting Windows Host Console - Running as NT AUTHORITY\SYSTEM) else (title Scripting Windows Host Console)
goto swh


:compressfile
echo.
echo Please use SWHZip to compress files
echo.
goto swh


:decompressfile
echo.

echo Add-Type -AssemblyName System.Windows.Forms > "%pathswh%\Temp\SelectFileDecompress.ps1"
echo $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ >> "%pathswh%\Temp\SelectFileDecompress.ps1"
echo     InitialDirectory = [Environment]::GetFolderPath('Desktop') >> "%pathswh%\Temp\SelectFileDecompress.ps1"
echo     Filter = 'SWHZip files (*.swhzip)^| *.swhzip' >> "%pathswh%\Temp\SelectFileDecompress.ps1"
echo } >> "%pathswh%\Temp\SelectFileDecompress.ps1"
echo $null = $FileBrowser.ShowDialog() >> "%pathswh%\Temp\SelectFileDecompress.ps1"
echo echo $FileBrowser.ShowDialog ^> "%pathswh%\Temp\SelectFileDecompress.txt" >> "%pathswh%\Temp\SelectFileDecompress.ps1"


if not exist "%pathswh%\Temp\SelectFileDecompress.txt" (
	echo.
	echo Unknown error
	echo.
	goto swh
)
cd /d "%pathswh%\Temp"
for /f "tokens=1,2* delims=," %%D in (SelectFileDecompress.txt) do (set decompressfilecontent=%%D)
cd /d "%cdirectory%"
if "%decompressfilecontent%"=="" (echo. & goto swh)


if not exist %decompressfilecontent% (
	echo "%decompressfilecontent%" does not exist!
	echo.
	goto swh
)
ren %decompressfilecontent% %decompressfilecontent%.zip
powershell -c Expand-Archive %decompressfilecontent%.zip %decompressfilecontent%>nul
echo.
goto swh





















:savingsettingssize1
echo cols=%colmodesize% lines=%linemodesize% > %localappdata%\ScriptingWindowsHost\Settings\Size.opt
echo.
goto swh
:SWHrunDialog
echo.
set runfile=0{SWH-RUN-KEY______RUN.Antibug_DeteCtor}
set /p runfile=Folder, file or Internet ressource to open: 
set runfile2="%runfile%"
set runfile=%runfile2%
if %runfile%=="0{SWH-RUN-KEY______RUN.Antibug_DeteCtor}" (goto errorRunning)
start %runfile%
echo.
goto swh

:errorRunning
echo.
echo You need to enter the name of the file, folder or Internet ressource that you would open
cd /d %userprofile%\AppData\Local\ScriptingWindowsHost
echo swh=MsgBox("You need to write the name, you can't put on blank",4112,"You need to write the name, you can't put on blank") > %pathswh%\Temp\ErrorRun.vbs
start /wait wscript.exe ErrorRun.vbs
cd /d %cdirectory%
echo.
goto swh

:title
set /p titlecon=Title of SWH Console: 
if "%username%"=="SYSTEM" (title %titlecon% - Running as NT AUTHORITY\SYSTEM) else (title %titlecon%)
echo.
echo Title: %titlecon% >> "%pathswh%\SWH_History.txt"
goto swh

:vol
vol
echo.
echo Volume >> "%pathswh%\SWH_History.txt"
goto swh

:variable
echo.
echo Note: changing SWH variables can do SWH that doesn't work correctly.
echo See "swhvariables" for info of the variables that you mustn't change
echo.
set /a varcount=%varcount%+1
set /p variablename=Variable name: 
set /p variabletext=Variable text: 
echo.
echo Variable saved as "%variablename%_%varcount%"
set %variablename%_%varcount%=%variabletext%
echo.
echo Variable: variablename:%variablename%; variabletext:%variabletext% >> "%pathswh%\SWH_History.txt"
goto swh

:swhvariables
echo.
echo SWH variables:
echo.
echo cd: Sets the %cd% text. Changing will do that SWH don't change the directory
echo cdirectory: cdirectory is the second directory variable, used for internal commands
echo cmd: cmd is the command variable. Changing it could make that commands don't work correctly.
echo commandtoexecute: It is the %commandtoexecute% text. It can be changed by "prompt".
echo localappdata: Changing LocalAppData will make many errors of the correct working of SWH
echo ver: Ver is the variable that shows the SWH Version. Changing will not show the actual version.
echo.
echo SwhVariables >> "%pathswh%\SWH_History.txt"
goto swh

:bugs
echo Bugs >> "%pathswh%\SWH_History.txt"
echo Fixed bugs:
echo 0xe0000001: If you write "not swh" it closes automatically
echo 0xe0000002: If you write ">", "<", "&" or "|" it closes automatically
echo.
goto swh

:bootconfig
start %SystemRoot%\System32\msconfig.exe
echo.
echo SystemConfig: %SystemRoot%\System32\msconfig.exe >> "%pathswh%\SWH_History.txt"
goto swh


:consoleinput
echo Note: To put special symbols ^< ^> ^& ^| please type ^^ before the symbol
set /p commandtoexecute=New text of the console line: 
echo.
echo Consoleinput: %commandtoexecute% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:PowerShell
start powershell.exe
echo.
echo PowerShell >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:networkconnections
echo Loading... Please wait.
echo.
net view
echo.
echo NetworkConnections: net view >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:searchfiles
set cdirectory=%cd%
set /p searchfiles=File or folder to search: 
echo.
echo Searching %searchfiles%... Please wait.
echo.
dir /s /b %searchfiles% > %pathswh%\Temp\Search.tmp
echo.
cd /d "%pathswh%\Temp"
for %%a in (Search.tmp) do (set searchTmpSize=%%~za)
if %searchTmpSize% lss 100 (
	echo Cannot find %searchfiles%
	echo.
	echo Search %searchfiles% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	cd /d "%cdirectory%"
	goto swh
)
for /f "tokens=1,2* delims=," %%a in (Search.tmp) do (echo Founded result: %%a)
cd /d "%cdirectory%"
echo.
echo Search %searchfiles% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:url
set /p url=URL to access: 
iexplore.exe %url%
echo.
echo URL: %url% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:history
if %moreCMD%==1 (goto moreHist)
echo.
type %pathswh%\SWH_History.txt
:sizeHistoryBytes
for %%H in (%pathswh%\SWH_History.txt) do (set sizeHistory=%%~zH)
echo.
echo Size of SWH history: %sizeHistory% Bytes
echo History:VIEWED >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
goto swh

:moreHist
echo.
more %pathswh%\SWH_History.txt
echo.
goto sizeHistoryBytes

:clearhistory
echo OptionsCanHistoryCleared:ClearHistory >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %pathswh%\Temp
set /p clearhist=Are you sure that you would clear the history? (y/n): 
if /i "%clearhist%"=="y" (goto clearhist) else (
	echo.
	cd /d %cdirectory%
	goto swh
)
:clearhist
del %pathswh%\SWH_History.txt /q>nul
echo SWH=MsgBox("History was successfully cleared",4160,"Done!") > SWHClHist.vbs
start /wait SWHClHist.vbs
echo History:CLEARED >> %pathswh%\SWH_History.txt
cd /d "%cdirectory%"
echo.
goto swh

:trexgame
if exist %pathswh%\pkg\T-RexGame.html (
	goto CHKchromeins
	start %pathswh%\pkg\T-RexGame.html
	echo.
	echo T-RexGame.html: played >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	goto nostartTREX
)

:nostartTREX
echo T-Rex: Error: %pathswh%\pkg\T-RexGame.html not founded >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo Error! File %pathswh%\pkg\T-RexGame.html not founded. To install T-Rex Game, use the following command: pkg install trex
echo SWH=MsgBox("File %pathswh%\pkg\T-RexGame.html not founded"^&vblf^&vbLf^&"To install T-Rex Game, use the following command:"^&vbLf^&"pkg install trex",4112,"SWH can't found the T-rex Game file") > "%pathswh%\Temp\ErrorT-Rex.vbs"
start /wait wscript.exe "%pathswh%\Temp\ErrorT-Rex.vbs"
echo.
goto swh

:CHKchromeins
if not exist "%programfiles(x86)%\Google\Chrome\Application\chrome.exe" (
	echo.
	echo Cannot play the game: This game requires Google Chrome.
	echo.
	goto swh
)
start chrome.exe "%pathswh%\pkg\T-RexGame.html"
echo.
goto swh


:cancelshutdown
echo cancelshutdown >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
shutdown /a
echo.
goto swh
:cmdscreen
echo cmd.exe >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
start
echo.
goto swh

:cd
set /p cdirectory=Directory to access: 
if exist %cdirectory% (
	cd /d %cdirectory%
	set cdirectory=%cd%
	echo.
	goto swh
) else (
	echo Directory "%cdirectory%" not founded!
	set cdirectory=%cd%
	echo cd %cdirectory% does not exist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
)
echo.
echo cd %cdirectory% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:voice
set /p voicetext=Text to pronounce: 
echo dim speech > C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
echo SWH="%voicetext%" >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
echo set speech=CreateObject("sapi.SpVoice") >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
echo speech.speak SWH >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
start wscript.exe "C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs"
echo.
echo Voice: %voicetext% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:mkdir
set /p foldername=Folder name: 
mkdir %foldername%
echo.
echo folder %foldername% Location: %cdirectory% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:start
set /p startexec=Program or file to execute: 
set /p startexecprog=Program to open "%startexec%" (Write "None" to execute %startexec% without programs): 
if /i "%startexecprog%"=="None" (
	start %startexec%
	echo execute %startexec% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
) else (
	start "%startexecprog%" "%startexec%"
	echo.
	echo execute %startexec% %startexecprog% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
)

:file
echo.
set /p namefile=Name of the file: 
set /p filecreation=Text to the file: 
echo %filecreation% > %namefile%
echo.
echo file:%namefile% text:%filecreation% location:%cdirectory% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:shutdown
set /p resetorshutdown=Restart (1) or shutdown (2): 
if "%resetorshutdown%"=="1" (goto resettime)
if "%resetorshutdown%"=="2" (goto rshutdowntime) else (
	echo "%resetorshutdown%" is not a possible option.
	echo Shutdown %resetorshutdown% is not possible option.
	echo Valid options are 1 and 2
	echo.
	goto swh
)

:rshutdowntime
set /p shutdowntime=Time to shut down computer: 
set /p commentshutdown=Comment (Press "Enter" to don't say a comment): 
if "%commentshutdown%"=="None" (
	shutdown -s -t %shutdowntime%
	echo.
	goto swh
) else (
	shutdown -s -t %shutdowntime% -c "%commentshutdown%"
)
echo.
echo shutdown-shutdown %shutdowntime% %commentshutdown% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo Shutting down...
echo.
goto swh

:resettime
set resettime=30
set /p resettimepc=Time to restart computer: 
set commentreset=PC will shutdown in %resettimepc%
set /p commentreset=Comment (Press "Enter" to don't say a comment): 
shutdown -s -t %resettimepc% -c "%commentreset%"

echo shutdown-reset %resettimepc% %commentreset%>> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
goto swh


:cls
cls
echo Clear >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:color
set /p textcolor=Color of text: 
set /p backgroundcolor=Color of background: 
if /I "%backgroundcolor%"=="%textcolor%" (
	echo.
	echo Two colors cannot be the same.
	echo Use different colors
	echo.
	goto swh
)
color %backgroundcolor%%textcolor%
echo.
goto swh


:del
echo.
echo Warning! Use with precaution!
echo.
set /p delfile=File to delete: 
if not exist %delfile% (
	echo.
	echo %delfile% does not exist. Check that %delfile% is the correct name.
	echo.
	goto swh
)
set /p suredelete=Are you sure that do you want to delete %delfile%? (y/n) 
if "%suredelete%"=="y" (
	del %delfile%
	echo del %delfile% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
) else (
	echo.
	goto swh
)

:tasklist
echo tasklist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
%windir%\System32\tasklist.exe
echo.
goto swh

:taskmgr
echo taskmgr >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
start taskmgr.exe "%systemroot%\System32\TaskMgr.exe"
echo.
goto swh


:taskkill
set taskkillpidim=0
set /p taskkillpidim=By PID (1) or process name (IM) (2): 
if "%taskkillpidim%"=="1" (goto tskillPID_FnoF)
if "%taskkillpidim%"=="2" (goto tskillIM_FnoF) else (
	echo.
	echo "%taskkillpidim%" is not a possible option
	echo.
	goto swh
)

:tskillPID_FnoF
set /p taskkillPIDFnoF=Forced (1) or not forced (2): 
if "%taskkillPIDFnoF%"=="1" (goto tskillyfPID)
if "%taskkillPIDFnoF%"=="2" (goto tskillnfPID) else (
	echo.
	echo "%taskkillPIDFnoF%" is not a possible option
	echo.
	goto swh
)

:tskillIM_FnoF
set /p taskkillIMFnoF=Forced (1) or not forced (2): 
if "%taskkillIMFnoF%"=="1" (goto tskillyfIM)
if "%taskkillIMFnoF%"=="2" (goto tskillnfIM) else (
	echo.
	echo "%taskkillIMFnoF%" is not a possible option
	echo.
	goto swh
)
:tskillyfIM
set /p taskkillprocessf=Process to finish (IM):
if /i "%taskkillprocessf%"=="csrss.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="lsass.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="winlogon.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="wininit.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="System" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="Registry" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="svchost.exe" (echo Access denied) else (taskkill /f /im %taskkillprocessf%)
echo.
echo EndTask:%taskkillprocessf% Forced >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh
:tskillnfIM
set /p taskkillprocessnf=Process to finish (IM): 
if /i "%taskkillprocessnf%"=="csrss.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="lsass.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="winlogon.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="wininit.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="System" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="Registry" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="svchost.exe" (echo Access denied) else (taskkill /im %taskkillprocessnf%)
echo.
echo EndTask:%taskkillprocessnf% No forced >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:accessdeniedEndTask
echo Access denied
echo.
goto swh
:tskillyfPID
set /p taskkillprocessPIDf=Process to finish (PID): 
taskkill.exe /f /pid %taskkillprocessPIDf%
echo.
echo EndTask:%taskkillprocessPIDf% Forced >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh
:tskillnfPID
set /p taskkillprocessPIDnf=Process to finish (PID): 
taskkill /pid %taskkillprocessPIDnf%
echo.
echo EndTask:%taskkillprocessPIDnf% No forced >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh


:rfolder
set /p removefolder=Folder to remove: 
set removefolderexist="%removefolder%"
if not exist "%removefolder%" (
	echo "%removefolder%" does not exist. Check that you writted the correct folder name
	echo.
	goto swh
)
set /p surerfolder=Are you sure that do you want to remove %removefolder%? (y/n): 
if /i "%surerfolder%"=="y" (
	:removefl235
	rd %removefolder%
	echo removefolder: %removefolder% > %pathswh%\SWH_History.txt
	echo.
	goto swh
) else (
	echo.
	goto swh
)

:copyfiles
echo.
echo Note: If the file has spaces, please type ""
set /p copyfiles1rt=Files to copy: 
set /p copyfiles2rt=Destination of copied files (If you type a filename, the file will be renamed): 
set copyfiles2=
set copyfiles1=
copy %copyfiles1rt% %copyfiles2rt%
echo.
echo Copy: %copyfiles1% -- %copyfiles2% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:msgbox
cd /d "%pathswh%\Temp"
set /p whatmsg=Message: With any symbol (1), with a red cross (2), with a question mark (3), with a danger symbol (4) or with an information symbol (5): 
if "%whatmsg%"=="1" (goto msg1)
if "%whatmsg%"=="2" (goto msg2)
if "%whatmsg%"=="3" (goto msg3)
if "%whatmsg%"=="4" (goto msg4)
if "%whatmsg%"=="5" (goto msg5) else (goto inmsg)
:inmsg
echo "%whatmsg%" is not a possible option.
echo.
echo ErrorMsg:%whatmsg% >> %homedrive%\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d "%cdirectory%"
goto swh
:msg1
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",0,"%titlemsgbox%") > SwhMsgBox0.vbs
start /wait SwhMsgBox0.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%,0,SwhMsgBox0.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
:msg2
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",16,"%titlemsgbox%") > SwhMsgBox16.vbs
start /wait SwhMsgBox16.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%,16,SwhMsgBox16.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
:msg3
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",32,"%titlemsgbox%") > SwhMsgBox32.vbs
start /wait SwhMsgBox32.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%,32,SwhMsgBox.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
echo
:msg4
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",48,"%titlemsgbox%") > SwhMsgBox48.vbs
start /wait SwhMsgBox48.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%, SwhMsgBox48.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh

:msg5
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",64,"%titlemsgbox%") > SwhMsgBox64.vbs
start /wait SwhMsgBox64.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%, SwhMsgBox64.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
echo

:chdate
echo.
echo Date: %date%
echo.
echo Note: change date requires administrator permission
echo.
set /p newdateday=Day: 
set /p newdatemonth=Month: 
set /p newdateyear=Year: 
echo.
set /p surenewdate=Are you sure that you would change the date? (y/n) 
if "%surenewdate%"=="y" (
	date %newdateday%-%newdatemonth%-%newdateyear%
	echo.
	echo Date:%newdateday%-%newdatemonth%-%newdateyear% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	echo.
	goto swh
)
:chtime
echo.
echo Time: %time%
echo.
echo Note: change time requires administrator permission
echo.
set /p newhourS=Seconds: 
set /p newhourMIN=Minutes: 
set /p newhourH=Hours: 
echo surenewhour=Are you sure that you would change the hour? (y/n) 
if "%surenewhour%"=="y" (
	time %newhourH%:%newhourMIN%:%newhourS%
	echo.
	echo Time:%newhourH%:%newhourMIN%:%newhourS%>> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	echo.
	goto swh
)

:echosay
set /p say=Text to say: 
echo.
echo %say%
echo.
echo Say:%say% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:credits
echo.
echo Credits:
echo.
echo Developper: anic17
echo Coded with: Batch, VBScript, PowerShell
echo.
echo Credits >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo (c) Copyright 2019 - 2020 SWH. All rights reserved
pause>nul
echo.
goto swh

:dir
if not exist "\" (echo. & set errordisk_=%cd% & goto errornotdisk)
dir
echo.
echo dir:%cd% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:rename
set /p filetorename=File to rename: 
if not exist %filetorename% (
	echo %filetorename% does not exist!
	echo Please verify that %filetorename% is in the correct location.
	echo.
	echo Rename: Error: %filetorename% does not exist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	goto yesrename
)
:yesrename
set /p newnamefile=New name of %filetorename%: 
if "%filetorename%"=="%newnamefile%" (
	echo The two names are the same.
	echo Please write different names.
	echo.
	echo Rename: Error: Two names are the same (%newnamefile%) >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
) else (
	ren %filetorename% %newnamefile%
	echo Rename: %filetorename% --^> %newnamefile%
	echo.
	goto swh
)

:calc
if not exist "%pathswh%\pkg\SWH_Calc.exe" (goto errorcalculator)
cd /d "%pathswh%\pkg"
ren "SWH_Calc.exe" "SWH_Calc.hta"
start mshta.exe %pathswh%\pkg\SWH_Calc.hta

timeout /t 1 /nobreak>nul
ren "SWH_Calc.hta" "SWH_Calc.exe"


cd /d "%cdirectory%"
echo.
goto swh

:errorcalculator
echo err=MsgBox("SWH cannot find the file %pathswh%\pkg\SWH_Calc.exe"^&vbLf^&vbLf^&"You can install this with the following command:"^&vbLf^&"pkg install calc",4112,"SWH cannot find the calculator file") > %pathswh%\Temp\ErrCalc.vbs
start /wait wscript.exe "%pathswh%\Temp\ErrCalc.vbs"
echo.
echo SWH cannot find the file %pathswh%\SWH_Calc.exe
echo You can install SWH_Calc.exe with the following command: pkg install calc
echo.
goto swh


:consize
set /p colmodesize=Columns of SWH console: 
set /p linemodesize=Lines of SWH console: 
mode con: cols=%colmodesize% lines=%linemodesize%
echo.
if %colmodesize%==0 (goto settingssizemodecon1)
echo Console:Cols:%colmodesize%,Line:%linemodesize% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:scriptproject
cls
echo Welcome to the Scripting Windows Host Project Creator
title Scripting Windows Host Project Maker
echo If you need help, you can type on SWH Console "helpproject"
echo.
echo This project will be created in C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects
set /p projectname=Project name: 
echo.
echo @echo off > C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd

:commandPROJECT
set /p commandsproject=Commands to do the project: 
:other1PROJECT
if %commandsproject%==execute (goto startPROJECT)
if %commandsproject%==folder (goto mkdirPROJECT)
if %commandsproject%==shutdown (goto shutdownPROJECT)
if %commandsproject%==cd (goto cdPROJECT)
if %commandsproject%==file (goto filePROJECT)
if %commandsproject%==clear (goto clsPROJECT)
if %commandsproject%==del (goto delPROJECT)
if %commandsproject%==color (goto colorPROJECT)
if %commandsproject%==endtask (goto taskkillPROJECT)
if %commandsproject%==tasklist (goto tasklistPROJECT)
if %commandsproject%==taskmgr (goto taskmgrPROJECT)
if %commandsproject%==removefolder (goto rfolderPROJECT)
if %commandsproject%==exit (exitPROJECT)
if %commandsproject%==copy (goto copyfilesPROJECT)
if %commandsproject%==cmd (goto cmdscreenPROJECT)
if %commandsproject%==swh (goto startswhPROJECT)
if %commandsproject%==msg (goto msgboxPROJECT)
if %commandsproject%==date (goto chdatePROJECT)
if %commandsproject%==time (goto chtimePROJECT)
if %commandsproject%==say (goto echosayPROJECT)
if %commandsproject%==credits (goto creditsPROJECT)
if %commandsproject%==directory (goto dirPROJECT)
if %commandsproject%==dir (goto dirPROJECT)
if %commandsproject%==cancelshutdown (goto cancelshutdownPROJECT)
if %commandsproject%==renamefile (goto renamePROJECT)
if %commandsproject%==history (goto historyPROJECT)
if %commandsproject%==clearhistory (goto clearhistoryPROJECT)
if %commandsproject%==calc (goto calcPROJECT)
if %commandsproject%==calculator (goto calcPROJECT)
if %commandsproject%==size (goto consizePROJECT)
if %commandsproject%==project (goto scriptprojectPROJECT)
if %commandsproject%==helpproject (goto HelpProjectPROJECT)
if %commandsproject%==exit (goto goingswh) else (goto incommandPROJECT)

:goingswh
echo.
cls
goto startswh
:startPROJECT
set /p startexecPROJECT=Program or file to execute (%projectname%): 
echo start %startexecPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT

:incommandPROJECT
echo "%commandsproject%" don't exist or is it unavaiable for SWH Projects!
echo.
goto swh
:mkdirPROJECT
echo Location of the folder (%projectname%): 
set /p foldername=Folder name: 
echo mkdir %foldername% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
:shutdownPROJECT
set /p sdORrst=Shutdown (1) or restart (2) (%projectname%): 
if %sdORrst%==1 (goto shutdownPROJECTsd) else (goto restartPROJECTrst)
:restartPROJECTrst
set /p timerstPROJECT=Time to restart computer (%projectname%): 
echo shutdown -r -t %timerstPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
goto commandPROJECT
:shutdownPROJECTsd
set /p timesdPROJECT=Time to shut down computer (%projectname%): 
echo shutdown -s -t %timesdPROJECT >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
goto commandPROJECT

:cdPROJECT
set /p cdPROJECT=Directory to access (%projectname%): 
echo cd %cdPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
goto commandPROJECT
:filePROJECT
set /p filenamePROJECT=Name of the file (%projectname%): 
:filetextPROJECT
set /p textPROJECT=Text of the file (Write "None" to stop writing the file): 
if %textPROJECT%==None (goto filecreatedPROJECT) else (goto filetextPROJECT)
echo %textPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
:filecreatedPROJECT
echo.
goto commandPROJECT
:scriptprojectPROJECT
echo "project" can't be executed as a project file.
echo.
goto swh
:clsPROJECT
echo cls >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:delPROJECT
set /p delPROJECT=File to delete (%projectname%): 
echo del %delPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:colorPROJECT
set /p textcolor=Color of text (%projectname%): 
set /p backgroundcolor=Color of background (%projectname%): 
echo color %backgroundcolor%%textcolor% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:taskkillPROJECT
set /p taskkillPROJECT=Process to finish (%projectname%): 
echo taskkill /f /im %projectname% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:tasklistPROJECT
echo tasklist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:rfolderPROJECT
set /p removefolderPROJECT=Folder to remove (%projectname%): 
echo rd %projectname% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:exitswhPROJECT
echo.
goto swh
:copyfilesPROJECT
set /p copyfiles1rtPROJECT=Files to copy (%projectname%): 
set /p copyfiles2rtPROJECT=Files to move (%projectname%): 
echo copy "%copyfiles1rtPROJECT%" "%copyfiles2rtPROJECT%" >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:cmdscreenPROJECT
echo start >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:startswhPROJECT
echo "startswh" is not a valid optin for SWH Projects
echo.
goto commandPROJECT

:ColorText
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
