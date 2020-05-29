@echo off
setlocal EnableExtensions
chcp 65001 > nul
if "%~1"=="/?" goto help
if /i "%~1"=="commands" if /i "%~2"=="/?" goto help_commandlist
if /i "%~1"=="syntax" goto help_syntax
if /i "%~1"=="hexcolor" goto hexcolor


if /i "%~1"=="" (
	echo SWH Error: No arguments specified
	goto exit
)
if not exist "%~1" (
	echo SWH Error: No such file or directory
	goto exit
)
if "%~x1" neq ".swh" (
	echo SWH Error: Unrecognized file type
	goto exit
)

if /i ["%~2"]==["-n"] (
	set noreturn=1
)

if /i ["%~2"]==["/n"] (
	set noreturn=1
)

:start

::                        ::
::                        ::
:: Scripting Windows Host ::
:: ___---==========---___ ::
::                        ::
::                        
::Comments are # (hashtags)
::


:: <file.swh>
::  #This is a Scripting Windows Host comment
:: say "Hello world!"


set curdir=%CD%
set pathswh=%LOCALAPPDATA%\ScriptingWindowsHost
if exist "%pathswh%\Temp\SWH_Return.tmp" (del "%pathswh%\Temp\SWH_Return.tmp" /q > nul)

::
::Get user SID
::
::cd /d "%pathswh%\Temp"
::wmic useraccount where name='%username%' get sid | findstr /c:"-"> "%PATHSWH%\Temp\user.sid"
::for /f "delims=" %%S in (user.sid) do (set usersid=%%S)
::cd /d "%CURDIR%"
::
set end=0
set returncode=0
set $AppData=%APPDATA%
set $LocalAppData=%LOCALAPPDATA%
set $ProgramFiles=%PROGRAMFILES%
set $ProgramFiles(x86)=%PROGRAMFILES(x86)%
set $SystemRoot=%SYSTEMROOT%
set $Temp=%TEMP%
set $Userprofile=%USERPROFILE%
set $ProgramData=%PROGRAMDATA%
set $3DObjects=%USERPROFILE%\3D Objects
set $Desktop=%USERPROFILE%\Desktop
set $Documents=%USERPROFILE%\Documents
set $Downloads=%USERPROFILE%\Downloads
set $LocalDisk=%HOMEDRIVE%\
set $Music=%USERPROFILE%\Music
set $Pictures=%USERPROFILE%\Pictures
set $Videos=%USERPROFILE%\Videos
set $System=%SYSTEMROOT%%\System32
set $SystemStartup=%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set $SysWOW64=%SYSTEMROOT%%\SysWOW64
set $WinTemp=%SYSTEMROOT%\Temp
set $UserStartup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set $OS=%OS%
set $Ver=11.1
set $ComputerName=%COMPUTERNAME%
set $CPUArch=%PROCESSOR_ARCHITECTURE%
set $CPUCount=%NUMBER_OF_PROCESSORS%

set $FileName=%0
set $FileName_=%~0
set $WorkingDirectory=%~dp0
set $CurrentDrive=%~d0
set $CurrentHive=%~p0

set $CurrentName=%~n1
set $CurrentExt=%~x1
set $CurrentSize=%~z1

set $Arg1_=%~1
set $Arg2_=%~2
set $Arg3_=%~3
set $Arg4_=%~4
set $Arg5_=%~5
set $Arg6_=%~6
set $Arg7_=%~7
set $Arg8_=%~8
set $Arg9_=%~9

set $Arg1=%1
set $Arg2=%2
set $Arg3=%3
set $Arg4=%4
set $Arg5=%5
set $Arg6=%6
set $Arg7=%7
set $Arg8=%8
set $Arg9=%9

:readfile
for /f "tokens=1-30 eol=# usebackq" %%a in ("%~1") do if exist "%pathswh%\Temp\SWH_Return.tmp" (del "%pathswh%\Temp\SWH_Return.tmp" /q 2> nul 1>nul & goto :EOF) else call :command %%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%m %%n %%o %%p %%q %%r %%s %%t %%u %%v %%w %%x %%y %%z
:finished
if not exist "%PATHSWH%\Temp\SWH_Return.tmp" (
	set returncode=0
	goto next_finished
)
for /f "usebackq delims=" %%a in ("%PATHSWH%\Temp\SWH_Return.tmp") do (set returncode=%%a)
:next_finished
if "%noreturn%"=="1" echo %returncode% > "%PATHSWH%\Temp\RC.tmp" & goto exit
echo.
echo Process finished with error code %returncode%
echo %returncode% > "%PATHSWH%\Temp\RC.tmp"
pause>nul
goto exit
:exit
endlocal
for /f "usebackq delims=" %%a in ("%localappdata%\ScriptingWindowsHost\Temp\RC.tmp") do (set errorlevel=%%a)
exit /B %errorlevel%

:command
set command=%~1
if /i "%command%"=="file" (call :file %~2 "%~3" "%~4")
if /i "%command%"=="say" (call :say "%~2")
if /i "%command%"=="folder" (
	if exist "%~2" echo Error: '%~2' already exists & goto :EOF
	md "%~2"
)
if /i "%command%"=="title" (title %~2)
if /i "%command%"=="cd" (
	if not exist "%~2" echo Error: Cannot find '%~2' & goto :EOF
	cd /d "%~2" 2> nul 1>nul
	if errorlevel 1 (echo Error: Invalid directory & goto :EOF)
)
if /i "%command%"=="color" (color "%~2")
if /i "%command%"=="date" (date %~2/%~3/%~4)
if /i "%command%"=="time" (time %~2:%~3:%~4)


if /i "%command%"=="pause" (pause>nul)
if /i "%command%"=="clear" (cls)
if /i "%command%"=="dir" (dir /b /a %~2)
if /i "%command%"=="search" (dir /s /B "%~2")
if /i "%command%"=="copy" (call :copy "%~2" "%~3")
if /i "%command%"=="move" (call :move "%~2" "%~3")
if /i "%command%"=="input" (call :input "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9)
if /i "%command%"=="return" (call :Return %~2)
if /i "%command%"=="colortext" (call :ColorText %~2 "%~3" "%~4")
if /i "%command%"=="import" (call :import "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9)
if /i "%command%"=="if" (call :if "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9)
if /i "%command%"=="string" (call :string "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9)
if /i "%command%"=="int" (call :int "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9)
if /i "%command%"=="double" (call :double "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9)


set param2=%~2
set param3=%~3
if /i "%~2"=="0" (echo 0 & goto :EOF)
if /i "%~3"=="0" (echo 1 & goto :EOF)

if /i "%~2"=="pi" (set param2=3.1415926535897932)
if /i "%~2"=="phi" (set param2=1.6180339887498948)
if /i "%~2"=="e" (set param2=2.7182818284590452)
if /i "%~3"=="pi" (set param3=3.1415926535897932)
if /i "%~3"=="phi" (set param3=1.6180339887498948)
if /i "%~3"=="e" (set param3=2.7182818284590452)


if /i "%command%"=="exp" (call :exp %param2% %param3%)
if /i "%command%"=="sqrt" (call :sqrt %param2%)
if /i "%command%"=="cube" (call :cube %param2%)
if /i "%command%"=="square" (call :square %param2%)
if /i "%command%"=="cbrt" (call :cbrt %param2%)

goto :EOF


:say
set "say_params=%~1"
echo.%say_params%
set say_params=
goto :EOF

:exp
set exp=%~1
set exp2=%~2
set exp=%exp:,=.%
set exp2=%exp2:,=.%

echo wscript.echo (%exp%^^%exp2%) > "%PATHSWH%\Temp\exp.vbs"
cscript.exe //nologo "%PATHSWH%\Temp\exp.vbs" > "%PATHSWH%\Temp\exp.tmp"
for /f "usebackq delims=" %%E in ("%PATHSWH%\Temp\exp.tmp") do (set exp_dot=%%E)
echo %exp_dot:,=.%
goto :EOF

:cube
set cube=%~1
set cube2=%~2
set cube=%cube:,=.%
set cube2=%cube2:,=.%

echo wscript.echo (%cube%^^3) > "%PATHSWH%\Temp\cube.vbs"
cscript.exe //nologo "%PATHSWH%\Temp\cube.vbs" > "%PATHSWH%\Temp\cube.tmp"
for /f "usebackq delims=" %%E in ("%PATHSWH%\Temp\cube.tmp") do (set cube_dot=%%E)
echo %cube_dot:,=.%
goto :EOF

:sqrt
set sqrt=%~1
set sqrt2=%~2

set sqrt=%sqrt:,=.%
set sqrt2=%sqrt2:,=.%

echo wscript.echo sqr(%sqrt%) > "%PATHSWH%\Temp\sqrt.vbs"
cscript.exe //nologo "%PATHSWH%\Temp\sqrt.vbs" > "%PATHSWH%\Temp\sqrt.tmp"
for /f "usebackq delims=" %%E in ("%PATHSWH%\Temp\sqrt.tmp") do (set sqrt_dot=%%E)
echo %sqrt_dot:,=.%
goto :EOF

:square
set square=%~1
set square2=%~2

set square=%square:,=.%
set square2=%square2:,=.%

echo wscript.echo (%square%*%square%) > "%PATHSWH%\Temp\square.vbs"
cscript.exe //nologo "%PATHSWH%\Temp\square.vbs" > "%PATHSWH%\Temp\square.tmp"
for /f "usebackq delims=" %%E in ("%PATHSWH%\Temp\square.tmp") do (set square_dot=%%E)
echo %square_dot:,=.%
goto :EOF

:cbrt
set cbrt=%~1
set cbrt=%cbrt:,=.%

echo wscript.echo (%cbrt% ^^ (1/3)) > "%PATHSWH%\Temp\cbrt.vbs"
cscript.exe //nologo "%PATHSWH%\Temp\cbrt.vbs" > "%PATHSWH%\Temp\cbrt.tmp"
for /f "usebackq delims=" %%E in ("%PATHSWH%\Temp\cbrt.tmp") do (set cbrt_dot=%%E)
echo %cbrt_dot:,=.%
goto :EOF


:copy
set filecopy="%~1"
set newfilecopy="%~2"
copy %filecopy% %newfilecopy% > nul
if not exist %newfilecopy% (echo Error while copying %filecopy%)
goto :EOF

:move
set filemove="%~1"
set newfilemove="%~2"
move %filemove% %newfilemove% > nul
if not exist %newfilemove% (echo Error while moving %filemove%)
goto :EOF


:input
set input_var=%~1

if not "%~9"=="" (set "var9=%~9")
if not "%~8"=="" (set "var8=%~8 ") 
if not "%~7"=="" (set "var7=%~7 ")
if not "%~6"=="" (set "var6=%~6 ")
if not "%~5"=="" (set "var5=%~5 ")
if not "%~4"=="" (set "var4=%~4 ")
if not "%~3"=="" (set "var3=%~3 ")
if not "%~2"=="" (set "var2=%~2 ")

::%~3 %~4 %~5 %~6 %~7 %~8 %~9
set /p "%input_var%=%var2%%var3%%var4%%var5%%var6%%var7%%var8%%var9%"
goto :EOF

:file
if "%~1"=="create" (
	if exist "%~2" (echo Error: "%~2" already exists. Please use 'file overwrite' to overwrite the file & goto :EOF)
	echo %~3 > "%~2"
	goto :EOF
)
if "%~1"=="overwrite" (
	echo %~3 > "%~2"
	if not exist "%~2" (echo Error: Cannot create output file '	%~2')
	goto :EOF
)
if "%~1"=="open" (
	if not exist "%~2" (echo Error: "%~2" does not exist & goto :EOF)
	echo.%~3 >> "%~2"
	goto :EOF
)
echo Syntax error
goto :EOF


:ColorText

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
if "%~3"=="" (echo.)
if "%~3"=="1" (echo.)
goto :EOF


:return
set returncode=%~1
echo %returncode% > "%PATHSWH%\Temp\RC.tmp"
echo %returncode% > "%pathswh%\Temp\SWH_Return.tmp"
goto :EOF

:import
if /i "%~x1" neq ".swhlib" (echo SWH Import Error: Invalid library & goto :EOF)
if not exist "%~1" (
	echo SWH Import error: No such file or directory
)
set curdir=%CD%
cd /d "%~dp1"
ren "%~1" "%~n1.bat"
if exist "%~n1.bat" del "%~n1.bat" /q > nul
for %%a in (%~1) do (echo @%%a >> "%~n1.bat")
cmd /c "%~dp1%~n1.bat" %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9
if exist "%~n1.bat" del "%~n1.bat" /q > nul
cd /d "%curdir%"
set curdir=
goto :EOF

:if
setlocal EnableDelayedExpansion
echo [debug]
echo 1: %~1
echo 2: %~2
echo 3: %~3
echo 4: %~4
echo 5: %~5
echo [debug]

if not defined %~1 (
	echo %~1 not defined
	goto :EOF
)
if not defined %~3 (
	echo %~3 not defined
	goto :EOF
)
if "%~2"=="==" (set comp=equ)
if "%~2"=="!=" (set comp=neq)
if "%~2"=="<=" (set comp=leq)
if "%~2"=="=<" (set comp=leq)
if "%~2"=="<" (set comp=lss)
if "%~2"==">" (set comp=gtr)
if "%~2"==">=" (set comp=geq)
if "%~2"=="=>" (set comp=geq)

if /i "%~2"=="equ" (set comp=equ)
if /i "%~2"=="neq" (set comp=neq)
if /i "%~2"=="leq" (set comp=leq)
if /i "%~2"=="lss" (set comp=lss)
if /i "%~2"=="gtr" (set comp=gtr)
if /i "%~2"=="geq" (set comp=geq)
echo on
if /i "%comp%" neq "equ" neq "leq" neq "lss" neq "gtr" neq "geq" neq "neq" (echo Invalid comparator & goto :EOF)
if "%~5"=="else" (
	call :if_else "%~1" "%~2" "%~3" "%~4" "%~5" "%~6"
	goto :EOF
)


set dr_crnt_fldr1=%~dp0
set dr_crnt_fldr1=%dr_crnt_fldr1:~-1%
if "!%~1" %comp% "!%~3!" ("%~0" %~4)
set dr_crnt_fldr1=
set comp=
endlocal
goto :EOF

:if_else
set dr_crnt_fldr1=%~dp0
set dr_crnt_fldr1=%dr_crnt_fldr1:~-1%
if "!%~1!" %comp% "!%~3!" ("%~0" %~4) else ("%~0" %~6)
set dr_crnt_fldr1=
set comp=
echo off
endlocal
goto :EOF

:int
set _intvar_math_argv=%~2%~3%~4%~5%~6%~7%~8%~9
set _intvar_math_argv=%_intvar_math_argv:{=(%
set _intvar_math_argv=%_intvar_math_argv:}=)%

set /a _intvar_math_=%_intvar_math_argv%
set %~1=%_intvar_math_%
set _intvar_math_=
set _intvar_math_argv=
goto :EOF

:double
set _doublevar_math_argv=%~2%~3%~4%~5%~6%~7%~8%~9
set _doublevar_math_argv=%_doublevar_math_argv:{=(%
set _doublevar_math_argv=%_doublevar_math_argv:}=)%
set _doublevar_math_argv=%_doublevar_math_argv:,=.%

set _doublevar_math_argv=%_doublevar_math_argv:pi=3.1415926535897932%
set _doublevar_math_argv=%_doublevar_math_argv:phi=1.6180339887498948%
set _doublevar_math_argv=%_doublevar_math_argv:e=2.7182818284590452%

set _double_math_=%_doublevar_math_argv%
echo wscript.echo (%_double_math_%) > "%PATHSWH%\Temp\Double.vbs"

for /f "tokens=* usebackq" %%a in (`cscript.exe //nologo "%PATHSWH%\Temp\Double.vbs"`) do (set _double_math_=%%a)
set %~1=%_double_math_:,=.%
set _double_math_=
set _doublevar_math_argv=
goto :EOF


:string
set string=%~1
set "%string%=%~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9"
echo %string%
goto :EOF


:help
echo.
echo Scripting Windows Host Interpreter
echo.
echo Type 'SWH commands /?' to view all commands available
echo Type 'SWH syntax [command]'
echo.
echo To run an .swh file, type 'SWH [file.swh]'
echo.
echo.
echo Copyright (c) 2020 anic17 Software
goto exit


:help_syntax
if /i "%~2"=="color" goto syntax_color
if /i "%~2"=="cbrt" goto syntax_cbrt
if /i "%~2"=="square" goto syntax_square
if /i "%~2"=="exp" goto syntax_exp
if /i "%~2"=="cube" goto syntax_cube
if /i "%~2"=="sqrt" goto syntax_sqrt
if /i "%~2"=="import" goto syntax_import
if /i "%~2"=="copy" goto syntax_copy
if /i "%~2"=="move" goto syntax_move

if /i "%~2"=="input" goto syntax_input
if /i "%~2"=="file" goto syntax_file
if /i "%~2"=="folder" goto syntax_folder
if /i "%~2"=="dir" goto syntax_dir
if /i "%~2"=="cd" goto syntax_cd

if /i "%~2"=="search" goto syntax_search
if /i "%~2"=="return" goto syntax_return
if /i "%~2"=="say" goto syntax_say
if /i "%~2"=="title" goto syntax_title

if /i "%~2"=="pause" goto syntax_pause
if /i "%~2"=="clear" goto syntax_clear
if /i "%~2"=="time" goto syntax_time
if /i "%~2"=="date" goto syntax_date


if /i "%~2"=="colortext" goto syntax_colortext

echo SWH Error: Invalid command
goto exit

:syntax_date
echo.
echo Syntax:
echo.
echo date [day] [month] [year]
echo.
echo Example:
echo.
echo date 21 10 2018
echo Will change the date to 21 days, 10 months and the year to 2018
goto exit

:syntax_time
echo.
echo Syntax:
echo.
echo time [hours] [minutes] [seconds]
echo.
echo Example:
echo.
echo time 10 43 41
echo Will change the time to 10 hours, 43 minutes and 41 seconds
goto exit

:syntax_clear
echo.
echo Syntax:
echo.
echo clear
echo.
echo Example:
echo.
echo clear
echo Will clear the screen
goto exit

:syntax_pause
echo.
echo Syntax:
echo.
echo pause "{text to print}"
echo.
echo Examples:
echo.
echo pause
echo Will make a pause
echo.
echo pause "Press any key to continue the script"
echo Will make a pause but before that will print on screen
echo the text 'Press any key to continue the script'
goto exit

:syntax_title
echo.
echo Syntax:
echo.
echo title "[console window title]"
echo.
echo Example:
echo.
echo title "Example title"
echo Will change the console window title to 'Example title!'
goto exit





:syntax_say
echo.
echo Syntax:
echo.
echo say "[text to print]"
echo.
echo Example:
echo.
echo say "Hello world!"
echo Will print in the console 'Hello world!'
goto exit


:syntax_return
echo.
echo Syntax:
echo.
echo return [return code]
echo.
echo Example:
echo.
echo return 0
echo Quits the program with a return code of 0 stored on variable %%errorlevel%%
goto exit

:syntax_search
echo.
echo Syntax:
echo.
echo search "[file or folder]"
echo.
echo Example:
echo.
echo search "important file.txt"
echo Will search the file 'important file.txt'
goto exit

:syntax_cd
echo.
echo Syntax:
echo.
echo cd "[folder]"
echo.
echo Example:
echo.
echo cd "example folder"
echo Will change directory to 'example folder'
echo.
echo Current directory is stored inside the variable CD (%%CD%%)
goto exit



:syntax_dir
echo.
echo Syntax:
echo.
echo dir "{folder}"
echo.
echo Examples:
echo.
echo dir
echo Will list all files in current folder
echo.
echo dir "folder"
echo Will list all files inside the folder called 'folder'
goto exit

:syntax_folder
echo.
echo Syntax:
echo.
echo folder "[folder name]"
echo.
echo Example:
echo.
echo folder "test folder"
echo Will create the folder 'test folder'
goto exit

:syntax_file
echo.
echo Syntax:
echo.
echo file [create ^| open ^| overwrite] "[file]" "[content]"
echo.
echo Examples:
echo.
echo file create "myfile.txt" "Example file"
echo Will create a file 'myfile.txt' with the content 'Example file'
echo If the file exists, abort operation
echo.
echo file overwrite "myfile.txt" "Example file"
echo Same as 'file create', but overwrites the file if already exists
echo.
echo file open "myfile.txt" "Second line"
echo Will open the file 'myfile.txt' and it will add the content
echo 'Second line'
echo.
echo To create a blank line, use 'file open "myfile.txt" ""' 
goto exit

:syntax_input
echo.
echo Syntax:
echo.
echo input [variable] "[input text]"
echo.
echo Example:
echo.
echo input folder "Folder to navigate: "
echo Will prompt user for 'Folder to navigate: ' and will
echo save the result to the folder variable (%%folder%%)
goto exit

:syntax_move
echo.
echo Syntax:
echo.
echo move "[files]" "[new destination]"
echo.
echo Examples:
echo.
echo move "C:\Document.docx" "D:\My Documents"
echo Will move the file 'C:\Document.docx' to 'D:\My Documents'
echo.
echo move "C:\Holiday photos\*.*" "D:\Photos"
echo Will move all files in 'C:\Holiday photos' to 'D:\Photos'
echo.
echo move "C:\Movies and videos\*.mov" "C:\Personal"
echo Will move all files with extension .mov from 'C:\Movies and videos'
echo to 'C:\Personal'
goto exit




:syntax_copy
echo.
echo Syntax:
echo.
echo copy "[files]" "[destination]"
echo.
echo Examples:
echo.
echo copy "C:\Document.docx" "D:\My Documents"
echo Will copy the file 'C:\Document.docx' to 'D:\My Documents'
echo.
echo copy "C:\Holiday photos\*.*" "D:\Photos"
echo Will copy all files in 'C:\Holiday photos' to 'D:\Photos'
echo.
echo copy "C:\Movies and videos\*.mov" "C:\Personal"
echo Will copy all files with extension .mov from 'C:\Movies and videos'
echo to 'C:\Personal'
goto exit

:syntax_import
echo.
echo Syntax:
echo.
echo import "[library]" "{command}"
echo.
echo Examples:
echo.
echo import "lib.swhlib"
echo Will import and run the library 'lib.swhlib'
echo.
echo import "windows.swhlib" "osver"
echo Will import the library 'windows.swhlib' the value 'osver'
goto exit

:syntax_colortext
echo.
echo Syntax:
echo.
echo color "background_foreground" "Text"
echo.
echo Example:
echo.
echo colortext "41" "Colored text"
echo Will set background color 4 and foreground color 1
echo.
echo Note: Scripting Windows Host sets hexadecimal colors
echo       To view a list of hexadecimal color codes, please
echo       type 'SWH hexcolor'
goto exit


:syntax_color
echo.
echo Syntax:
echo.
echo color "background_foreground"
echo.
echo Example:
echo.
echo color "5e"
echo Will set background color 5 and foreground color e
echo.
echo Note: Scripting Windows Host sets hexadecimal colors
echo       To view a list of hexadecimal color codes, please
echo       type 'SWH hexcolor'
goto exit



:syntax_cbrt
echo.
echo Syntax:
echo.
echo cbrt [number to calculate cube root]
echo.
echo Example:
echo.
echo cbrt 64
echo Will return 4
goto exit

:syntax_square
echo.
echo Syntax:
echo.
echo square [number to calculate square]
echo.
echo Example:
echo.
echo square 4
echo Will return 16
goto exit

:syntax_exp
echo.
echo Syntax:
echo.
echo exp [first number] [second number]
echo.
echo Example:
echo.
echo exp 2 8
echo Will return 256
goto exit

:syntax_cube
echo.
echo Syntax:
echo.
echo cube [number to calculate cube]
echo.
echo Example:
echo.
echo cube 10
echo Will return 1000
goto exit

:syntax_sqrt
echo.
echo Syntax:
echo.
echo sqrt [number to calculate square root]
echo.
echo Example:
echo.
echo sqrt 100
echo Will return 10
goto exit




:hexcolor
echo.
echo List of hexadecimal colors
echo.
echo 0: Black
echo 1: Dark blue
echo 2: Green
echo 3: Aquamarin
echo 4: Dark red
echo 5: Purple
echo 6: Orangle
echo 7: Light gray
echo 8: Dark gray
echo 9: Light blue
echo a: Lime
echo b: Light aquamarin
echo c: Light red
echo d: Light purple
echo e: Yellow
echo f: While
goto exit

:help_commandlist
echo.
echo Scripting Windows Host commands:
echo.
echo cbrt: Calculates the cube root of any number
echo cd: Changes the current directory
echo clear: Clears the console
echo color: Changes the console color
echo colortext: Prints colored text within changing console color
echo copy: Copies files
echo cube: Calculates the cube of any number
echo date: Changes system date
echo dir: Shows all files in directory
echo exp: Calculates the exponent of two numbers
echo file: Creates files
echo folder: Creates folders
echo import: Imports an Scripting Windows Host library
echo input: Prompts user and stores the content into a variable
echo move: Moves files
echo pause: Makes a pause
echo return: Sets a return code and quits
echo say: Prints text at console
echo search: Searches files
echo sqrt: Calculates the square root of any number
echo square: Calculates the square of any number
echo time: Changes system time
echo title: Changes console title
goto exit