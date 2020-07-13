@echo off
setlocal EnableDelayedExpansion
if "%~1"=="/?" goto help
if /i "%~1"=="--help" goto help

if /i "%~1"=="commands" goto help_commandlist
if /i "%~1"=="syntax" goto help_syntax
if /i "%~1"=="hexcolor" goto hexcolor
if /i "%~1"=="--command" if "%~2"=="" (
	echo SWH Error: Cannot run an empty command
	goto exit
) else (
	goto runcommand
)
if /i "%~1"=="" (
	echo SWH Error: No arguments specified. Try with '%~n0 --help'
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

:start

set "pathswh=%LOCALAPPDATA%\ScriptingWindowsHost"

set end=0
set returncode=0
set returning=null

set $Arg1=%2
set $Arg2=%3
set $Arg3=%4
set $Arg4=%5
set $Arg5=%6
set $Arg6=%7
set $Arg7=%8
set $Arg8=%9
if not "%~9"=="" (
	shift
	set $Arg9=%9
)

set __open_brackets__=0

:readfile
for /f "tokens=1-25* eol=# usebackq" %%a in ("%~1") do if "!returning!" neq "null" (goto exit) else call :command %%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%m %%n %%o %%p %%q %%r %%s %%t %%u %%v %%w %%x %%y %%z
:exit
endlocal & exit /B %returncode%
exit /B !errorlevel!

:command
set "command=%~1"


if "!_if_!"=="1" (set "command=%~1" & set "_if_=0")
if /i "%command%"=="if" (call :if %*)
if /i "%command%"=="{" (
	if "!__if__!"=="true" call :syntaxerror

)
if /i "%command%"=="echo" (
	echo.%~2
	exit /B
)
if /i "%command%"=="echol" (
	<nul set /p "=%~2"
	exit /B
)

if /i "%command%"=="input" (
	set var=%~2
	set /p "%~2=%~3"
	exit /B

)

if /i "%command%"=="int" (
	if "%~2"=="" goto missing_param
	for /f "tokens=1 delims=1234567890+-*/%%" %%A in ("%~3") do (
		<nul set /p "=Not an integer."
		set "returncode=1"
		goto exit
	)
	set "__intvar_math_argv__=%~3%~4%~5%~6%~7%~8%~9"
	set "__intvar_math_argv__=!__intvar_math_argv__:{=(!"
	set "__intvar_math_argv__=!__intvar_math_argv__:}=)!"

	set /a "%~2=!__intvar_math_argv__!"
	exit /B
)


if /i "%command%"=="string" (

	set "__string_swh_tmpvar__=%~2"
	set "!__string_swh_tmpvar__!=%~3"
	echo off
	exit /B
	
)

if /i "%command%"=="double" (call :double "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9 & exit /B)
if /i "%command%"=="bool" (
	if "%~2"=="" goto missing_param
	if /i "%~2"=="true" set "%~1=true" & exit /B
	if /i "%~2"=="false" set "%~1=false" & exit /B
	echo Invalid boolean value
	exit /B
)

if /i "%command%"=="loadenv" (call :loadenv "%~2" & exit /B)
if /i "%command%"=="file" (call :file %~2 "%~3" "%~4" & exit /B)
if /i "%command%"=="folder" (
	if exist "%~2" echo Error: '%~2' already exists & exit /B
	md "%~2"
	exit /B
)
if /i "%command%"=="title" (title %~2 & exit /B)
if /i "%command%"=="cd" (
	if not exist "%~2" echo Error: Cannot find '%~2' & exit /B
	cd /d "%~2" 2> nul 1>nul
	if errorlevel 1 echo Error: Invalid directory
	exit /B
)
if /i "%command%"=="color" (color "%~2" & exit /B)
if /i "%command%"=="date" (date %~2/%~3/%~4 > nul & exit /B)
if /i "%command%"=="time" (time %~2:%~3:%~4 & exit /B)
if /i "%command%"=="array" (
	call :array %*
	exit /B
)
if /i "%command%"=="getlen" (call :getlen "%~2" %~3 & exit /B)
if /i "%command%"=="pause" (pause>nul & exit /B)
if /i "%command%"=="clear" (cls & exit /B)
if /i "%command%"=="dir" (dir /b /a "%~2" & exit /B)
if /i "%command%"=="search" (dir /s /a /B "%~2" & exit /B)
if /i "%command%"=="copy" (call :copy "%~2" "%~3" & exit /B)
if /i "%command%"=="move" (call :move "%~2" "%~3" & exit /B)
if /i "%command%"=="return" (call :Return %~2 & exit /B)
if /i "%command%"=="colortext" (call :ColorText %~2 "%~3" "%~4" & exit /B)
if /i "%command%"=="import" (call :import "%~2" %~3 %~4 %~5 %~6 %~7 %~8 %~9 & exit /B)
if /i "%command%"=="gettitle" (call :gettitle "%~2" & exit /B)
if /i "%command%"=="reg" (call :reg "%~2" "%~3" "%~4" "%~5" & exit /B)

if /i "%command%"=="abs" (call :abs "%~2" "%~3" & exit /B)

if /i "%command%"=="" (exit /B)

if /i "%~2"=="0" (echo 0 & exit /B)
if /i "%~3"=="0" (echo 1 & exit /B)

if /i "%command%"=="exp" (call :exp %~2 %~3 %~4 & exit /B)
if /i "%command%"=="sqrt" (call :sqrt %~2 %~3 & exit /B)
if /i "%command%"=="cube" (call :cube %~2 %~3 & exit /B)
if /i "%command%"=="square" (call :square %~2 %~3 & exit /B)
if /i "%command%"=="cbrt" (call :cbrt %~2 %~3 & exit /B)
if "!_if_!"=="1" set "_if_=0" & exit /B
echo Incorrect command: %command% & goto exit
exit /B

:getlen
if "%~1"=="" call :missing_param & exit /B

set "__getlen_tmp_var__=%~1#"
for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!__getlen_tmp_var__:~%%P,1!" NEQ "" ( 
        set /a "__getlen_SWH__+=%%P"
        set "__getlen_tmp_var__=!__getlen_tmp_var__:~%%P!"
    )
)
if "%~2"=="" (
	echo !__getlen_SWH__!
) else ( 
	set "%~2=!__getlen_SWH__!"
)
exit /B

:exp
set exp=%~1
set exp2=%~2
set exp=%exp:,=.%
set exp2=%exp2:,=.%
if "%~3"=="" (

echo wscript.echo (%exp%^^%exp2%) > "%PATHSWH%\Temp\exp.vbs"

for /f "delims=" %%E in ('cscript.exe //nologo "%PATHSWH%\Temp\exp.vbs"') do (set "exp_dot=%%E")
echo;%exp_dot:,=.%
exit /B

:cube
echo wscript.echo (%~1^^3) > "%PATHSWH%\Temp\cube.vbs"
exit /B 

:sqrt
set sqrt=%~1
set sqrt2=%~2

echo wscript.echo sqr(%sqrt%) > "%PATHSWH%\Temp\sqrt.vbs"
cscript.exe //nologo "%PATHSWH%\Temp\sqrt.vbs" > "%PATHSWH%\Temp\sqrt.tmp"
for /f "usebackq delims=" %%E in ("%PATHSWH%\Temp\sqrt.tmp") do (set sqrt_dot=%%E)
echo %sqrt_dot:,=.%
exit /B

:square
set square=%~1
set square2=%~2

echo wscript.echo (%square%*%square%) > "%PATHSWH%\Temp\square.vbs"

for /f "usebackq delims=" %%E in ("cscript.exe //nologo "%PATHSWH%\Temp\square.vbs") do (
	set "square_dot=%%A"
	echo !square_dot:,=.!
)

:cbrt
set cbrt=%~1
set cbrt=%cbrt:,=.%

echo wscript.echo (%cbrt% ^^ (1/3)) > "%PATHSWH%\Temp\cbrt.vbs"


for /f "delims=" %%A in ('cscript.exe //nologo "%PATHSWH%\Temp\cbrt.vbs"') do (
	set "cbrt_dot=%%A"
	echo !cbrt_dot:,=.!
)
exit /B


::if not exist "%~1" echo %1: No such file or directory & exit /B
::if "%~2"=="" del "%~2" /a /q 2>nul 1>nul & exit /B
::if "%~2"=="subdirectories" del "%~2" /s /a 2>nul 1>nul & exit /B
::if "%~2"=="confirm" (
::	set /p "__del__confirm__=Are you sure you want to delete %1? (y/n): 
::	if /i "!__del__confirm__!"=="y" del "%~2" /q /a >nul & exit /B
::	if /i "!__del__confirm__!"=="n" exit /B
::)
::goto syntaxerror

exit /B


:copy
set filecopy="%~1"
set newfilecopy="%~2"
copy %filecopy% %newfilecopy% > nul
if not exist %newfilecopy% (echo Error while copying %filecopy%)
exit /B

:move
set filemove="%~1"
set newfilemove="%~2"
move %filemove% %newfilemove% > nul
if not exist %newfilemove% (echo Error while moving %filemove%)
exit /B


:file
if "%~1"=="create" (
	if exist "%~2" (echo Error: "%~2" already exists. Please use 'file overwrite' to overwrite the file & exit /B)
	echo %~3 > "%~2"
	exit /B
)
if "%~1"=="overwrite" (
	echo %~3 > "%~2"
	if not exist "%~2" (echo Error: Cannot create output file '	%~2')
	exit /B
)
if "%~1"=="open" (
	if not exist "%~2" (echo Error: "%~2" does not exist & exit /B)
	echo.%~3 >> "%~2"
	exit /B
)
if "%~1"=="blank" (
	if exist "%~2" (Error: "%~2" already exists. & exit /B)
	<nul set /p "=" > "%~2"
	exit /B
)
set "expected=Expected [create ^| overwrite ^| open ^| blank], but specified '%~1'"
goto syntaxerror


:ColorText

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "__colortext__findstr__=%%a"

<nul set /p ".=%__colortext__findstr__%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
if "%~3"=="" (echo.)
if "%~3"=="1" (echo.)
exit /B


:math
set "pi=3.1415926535897932"
set "phi=1.6180339887498948"
set "e=2.7182818284590452"
exit /B

:abs
if "%~2"=="" goto missing_param
set /a "__math__operation__abs__SWH__absolute__value__math__=%~2 %~4 %~5 %~6 %~7 %~8 %~9"

if !__math__operation__abs__SWH__absolute__value__math__! lss 0 (
	set /a "%~1=!__math__operation__abs__SWH__absolute__value__math__!"
	set "__math__operation__abs__SWH__absolute__value__math__=!__math__operation__abs__SWH__absolute__value__math__:~1!"
	set "%~1=!__math__operation__abs__SWH__absolute__value__math__!"
) else (
	set "%~1=!__math__operation__abs__SWH__absolute__value__math__!"
)
exit /B

:return
set returncode=%~1
set "returning=%~1"
exit /B

:import

if /i "%~x1" neq ".cmd" if not "%~n1"=="%~nx1" (echo SWH Import Error: Invalid library & exit /B)

if exist "%~n1.cmd" call "%~n1.cmd" %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 & exit /B
if exist "%~nx1" call "%CD%\lib\%~n1.cmd" %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 & exit /B
if exist "%CD%\lib\%~n1.cmd" call "%CD%\lib\%~n1.cmd" %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 & exit /B
if exist "%CD%\lib\%~nx1" call "%CD%\lib\%~n1.cmd" %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 & exit /B

echo SWH Import error: No such file or directory

exit /B

:if

if /i "%~3"=="equ" (set comp=equ)
if /i "%~3"=="neq" (set comp=neq)
if /i "%~3"=="leq" (set comp=leq)
if /i "%~3"=="lss" (set comp=lss)
if /i "%~3"=="gtr" (set comp=gtr)
if /i "%~3"=="geq" (set comp=geq)

::Filter
set passed=0

if %passed%==0 if /i "%comp%"=="neq" (set passed=1)
if %passed%==0 if /i "%comp%"=="equ" (set passed=1)
if %passed%==0 if /i "%comp%"=="leq" (set passed=1)
if %passed%==0 if /i "%comp%"=="lss" (set passed=1)
if %passed%==0 if /i "%comp%"=="gtr" (set passed=1)
if %passed%==0 if /i "%comp%"=="geq" (set passed=1)
if %passed%==0 exit /B


set "_if_=1"
set _if_varcomp_1=%~2
set _if_varcomp_2=%~4
if "!_if_varcomp_1!" %comp% "!_if_varcomp_2!" (
	if "%~5" neq "{" (
		set "expected=Expected '{' at 'if %~2 %comp% %~4' ^<-- here"
		call :syntaxerror
	)
	set "__if_correct__=true"
	set "__open_brackets__=true"
	set "__if__=true"
)
set 
call :command "%~5" "%~6" "%~7" "%~8" "%~9"
exit /B 

exit /B

:open_brackets_if

call :command


:else
echo arribat
call :command %*
exit /B 


:double
set "_doublevar_math_argv=%~2%~3%~4%~5%~6%~7%~8%~9"
set "_doublevar_math_argv=%_doublevar_math_argv:{=(%"
set "_doublevar_math_argv=%_doublevar_math_argv:}=)%"
set "_doublevar_math_argv=%_doublevar_math_argv:,=.%"

set _doublevar_math_argv=%_doublevar_math_argv:pi=3.1415926535897932%
set _doublevar_math_argv=%_doublevar_math_argv:phi=1.6180339887498948%
set _doublevar_math_argv=%_doublevar_math_argv:e=2.7182818284590452%

set _double_math_=%_doublevar_math_argv%
echo wscript.echo (%_double_math_%) > "%PATHSWH%\Temp\Double.vbs"

for /f "delims=" %%a in ('cscript.exe //nologo "%PATHSWH%\Temp\Double.vbs"') do (set "_double_math_=%%a")
set "%~1=%_double_math_:,=.%"
set _double_math_=
set _doublevar_math_argv=
exit /B

:gettitle

set "_window_title__bin_=0"
if not "%~1"=="" (set "_window_title__bin_=1") else (set "_window_title__rename_variable_=%~1")
wmic process get parentprocessid,name|find "WMIC" > "%PATHSWH%\Temp\proc.lis"
for /f "usebackq tokens=1* delims= " %%A in ("%PATHSWH%\Temp\proc.lis") do (set "__window_title_PID__=%%B")


For /f "tokens=1* delims=:" %%A In ('tasklist /fi "pid eq %__window_title_PID__%" /v /fo list') do (set "_windowtitle_=%%B")
if "%_window_title__bin_%"=="1" (
	set "%~1=%_windowtitle_:~2%"
	exit /B
)


set _windowtitle_=%_windowtitle_:~2%
echo %_windowtitle_%
set _windowtitle_=
exit /B



For /f "tokens=1* delims=:" %%A In ('tasklist /fi "pid eq %__window_title_PID__%" /v /fo list') do (call :get_title_manipulate %%B)
exit /B



:get_title_manipulate
set _badwintitle_=%1
Set "_window_title__rename_variable_=%_badwintitle_:~1%
if "!_window_title__bin_!"=="1" (
	echo %_window_title__rename_variable_%
	set __window_title_PID__=
	set _window_title__bin_=
	set _window_title__rename_variable_=
	exit /B
)
set _window_title__bin_=
set "%_window_title__rename_variable_%=%_window_title__rename_variable_%"
exit /B




:loadenv
if "%~2"=="" call :full_loadenv & exit /B
if /i "%~2"=="full" call :full_loadenv & exit /B

if /i "%~2"=="args" call :args_loadenv & exit /B
if /i "%~2"=="shell" call :shell_loadenv & exit /B
if /i not "%~2"=="extended" (echo Invalid environment loading & exit /B) else call :full_loadenv & exit /B

exit /B


:full_loadenv

for /f "tokens=3* delims= " %%A in ('reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOwner"') do set "$RegisteredOwner=%%A %%B"
for /f "tokens=3* delims= " %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop') do set "$Desktop=%%a"
for /f "tokens=3* delims= " %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Startup') do set "$Startup=%%a"
call :args_loadenv
call :shell_loadenv
exit /B


:args_loadenv
set "$Arg1_=%$Arg1:"=%"
set "$Arg2_=%$Arg2:"=%"
set "$Arg3_=%$Arg3:"=%"
set "$Arg4_=%$Arg4:"=%"
set "$Arg5_=%$Arg5:"=%"
set "$Arg6_=%$Arg6:"=%"
set "$Arg7_=%$Arg7:"=%"
set "$Arg8_=%$Arg8:"=%"
set "$Arg9_=%$Arg1:"=%"
exit /B

:shell_loadenv
set $3DObjects=%USERPROFILE%\3D Objects
set $Documents=%USERPROFILE%\Documents
set $Downloads=%USERPROFILE%\Downloads
set $LocalDisk=%HOMEDRIVE%\
set $Music=%USERPROFILE%\Music
set $Pictures=%USERPROFILE%\Pictures
set $Videos=%USERPROFILE%\Videos
set $System=%SYSTEMROOT%%\System32
set $SysWOW64=%SYSTEMROOT%%\SysWOW64
set $WinTemp=%SYSTEMROOT%\Temp
set $Ver=2.1
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
exit /B

:reg
echo off
if /i "%~1"=="get" (
	if "%~3"=="" (goto missing_param)
	if "%~4"=="" (
		for /f "tokens=3* delims= " %%r in ('reg query "%~3"') do (
			if !errorlevel! equ 0 (
				set "%~2=%%r"
				exit /B
			) else (
				echo Could not find registry key '%3'
			)
		)
	) else (
		for /f "tokens=3* delims= " %%r in ('reg query "%~3" /v "%~4"') do (
			if !errorlevel! equ 0 (
				set "%~2=%%r"
				exit /B
			) else (
				echo Could not find registry key '%3'
			)
		)
	)
)

if /i "%~1"=="add" (


%2 = "root\blah"
%3 = keyname
%4 = type
%5 = data


	if "%~3"=="" goto syntaxerror
	if "%~4"=="" (
		for /f "tokens=3* delims= " %%r in ('reg query "%~3"') do (
			if !errorlevel! equ 0 (
				set "%~2=%%r"
				exit /B
			) else (
				echo Could not find registry key '%3'
			)
		)
	) else (
		for /f "tokens=3* delims= " %%r in ('reg query "%~3" /v "%~4"') do (
			if !errorlevel! equ 0 (
				set "%~2=%%r"
				exit /B
			) else (
				echo Could not find registry key '%3'
			)
		)
	)
)


rem reg query "%~2"
exit /B

:brackets_open



echo All is: %*
exit /B



:: That will be functions for the program
:function_%function1%-
echo.
exit /B

:function_%function2%-
exit /B

:function_%function3%-
exit /B

:function_%function4%-
exit /B

:function_%function5%-
exit /B

:function_%function6%-
exit /B

:function_%function7%-
exit /B

:function_%function8%-
exit /B

:function_%function9%-
exit /B

:function_%function10%-
exit /B

:function_%function11%-
exit /B

:function_%function12%-
exit /B

:function_%function13%-
exit /B

:function_%function14%-
exit /B

:function_%function15%-
exit /B

:function_%function16%-
exit /B









:array



:getsid
::
::Get user SID
::
::cd /d "%pathswh%\Temp"
::wmic useraccount where name='%username%' get sid | findstr /c:"-"> "%PATHSWH%\Temp\user.sid"
::for /f "delims=" %%S in (user.sid) do (set usersid=%%S)
::cd /d "%CURDIR%"
::

:missing_param
echo;Missing parameter.
call :return 1
exit /B

:syntaxerror
echo;Syntax error. %expected%
call :return 1
exit /B

:failed
echo;Failed.
call :return 1
exit /B

:internal_error
echo;Internal error.
call :return 1
exit /B

:invalid_comparator
echo Invalid comparator.
call :return 1
exit /B

:help
echo.
echo Scripting Windows Host Interpreter
echo.
echo Type 'SWH commands /?' to view all commands available
echo Type 'SWH syntax [command]' to get the syntax of a command
echo Type 'SWH --command [command]' to run a command within an .swh file
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
if /i "%~2"=="echo" goto syntax_echo
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





:syntax_echo
echo.
echo Syntax:
echo.
echo echo "[text to print]"
echo.
echo Example:
echo.
echo echo "Hello world!"
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
echo file [create ^| open ^| overwrite ^| blank] "[file]" "[content]"
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
echo file blank "myfile.txt"
echo Will create the empty file 'myfile.txt'
echo.
echo To create a blank line, use 'file open "myfile.txt" ""' 
goto exit

:syntax_input
echo.
echo Syntax:
echo.
echo input [variable] = "[input text]"
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
echo import "lib.cmd"
echo Will import and run the library 'lib.cmd'
echo.
echo import "windows.cmd" "osver"
echo Will import the library 'windows.cmd' the value 'osver'
goto exit

:syntax_colortext
echo.
echo Syntax:
echo.
echo color "background_foreground" "Text" [0 ^| 1]
echo.
echo Example:
echo.
echo colortext "41" "Colored text" 0
echo Will set background color 4 and foreground color 1, without a new line
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
:: string
:: int
:: bool
:: if
:: echol
:: loadenv
:: gettitle
:: double
:: getlen
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

:runcommand
call :command "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8" "%~9"
exit /B
