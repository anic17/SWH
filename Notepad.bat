@echo off
set wr=0
set noteact=%random:~-1%
set saved=0
set written=0
mode con: cols=120 lines=30
cls
set pathswh=%localappdata%\ScriptingWindowsHost
cd /d "%tmp%"
if exist batbox.exe goto menu
for %%b in ( 
4D5343460000000007040000000000002C000000000000000301010001000000
000000004700000001000100000800000000000000006546B1AE200062617462
6F782E65786500CD6A9177B8030008434BBD555D681C55143E936443FFCC6EB3
196D91E214DA3EF421A06D404B03539368AA1B5D76B70D9442BA9B9DDD99CDEE
CC323B3129BE44362BD4BCF820F86011438A08BE06D452D1BA292DA5A13E14A9
5AA58AC82C2DD887D4F6A1CDF89D3B93660BC1F6C17A77BF3BE77CE7DC73BFFB
B3B34347A64822A2368A90E711A9ECA0A9F4E83605743C77BA83E6D72F6EFF52
8A2D6E4FE9464529DB56DE4E9794D1B4695A8E92D1147BDC540C53E97F33A994
ACACD6FDD4861D2B35E203443149A2D87777532BDC750A4B1B25E9156A87D31E
909126B03A7EB6100572A13F688ACFE7EF13B5368F7B9019B841DB16257AA6E5
3116FB1FB7EE5C31EDE0A9870241EDBEEEE6768CB7E20937BD5F56A9E03FF417
B9DB8BCE93AF77A9545DE82ADCF6E46B5195E6544EFB3B70F6C3711350DBF75E
74EAA2F2BC97FB6A13EDFB703D62E1E93DE05FCDFF7EABF193E779EE667871AF
471545FF4042A30E7AEA6D69245CEBC0FC9EEC62A6DAB7E1E9CFC1A33EBC5E5E
75B8B651849908E162D2DC561EBD846374CFA06B0D2D7442CA2574B9B94116F4
A9602F30FBBD605FE3497B0645EF0B70B9C4CBACEB3892CF87AE74FAF77C8E0D
5D745F7472E255CCDAD8CA8963484C36B1D585750DE2C0258CBB133A8ABAF7E1
866B37D0CFA6647F31BF72C64D6434AE2CC3FA0496FB0BBBE7D8BDC717DF936F
B19A79266EB0065E8FFB1B5BBC86C64708E8C79AC4DF45BA7B96E3593EA7E6D0
12572A70A559C44F9CF7E47B608631C7498EC411F142BC29B3ABFB35BBBA498D
1F9050D8E2F5ECF7CF1E63FC7B21E931318BCFDF045FEDE5008E79112573D55E
8EB7846BDFC0ABCFF4C6E19D583EFB57E49D3FF965D22AB6273E7C583FDDB47F
91BAFB345416F049A2A8E036D5BD1D5FFF88A46A882F61DBCC367ECC3C5BFB39
3CCD3FDCBAD7C3C78F2B24D2DB76566867769FF86E58FB62BF1551691EB8038C
00CA66955E026A80037C0C5C0634A0018CE5D3A3D99235A1978F9BDD998CA871
A66BB55E092F8AABF0E7A3ABDC24EC6BC0074DDCBBB04F46D7D634943CDC9748
75F7C762F4FA40E28D81D89E17844387920389159BE85430FCD4833249DD9A18
36CCAC3521DE7590D105EC0254E02850062681F781CF02D98F9B87DFABE6249D
EC60DACC1635319FE6F45966C52A6A43785F3FCCA4B449E780E3D84666DCD11E
8AF48DDB15CB8E5B15C3312C934725B47436081E34CBE3CE01CE2F6A5A798D71
07CD9C15687904BFB2134BD0BF0CAC9389B6000AB05BF657F46F31EC826D984E
8EAD91BCE68CEAC262B39436CCB49DAFC0D7260D47F06319DDB72A8EED58C5FF
FFBFE249B67F00                                                  
) Do >>t.dat (Echo.For b=1 To len^("%%b"^) Step 2
ECHO WScript.StdOut.Write Chr^(Clng^("&H"^&Mid^("%%b",b,2^)^)^) : Next)
Cscript /b /e:vbs %tmp%\t.dat>%tmp%\batbox.ex_
Expand -r %tmp%\batbox.ex_ >nul 2>&1
del "%tmp%\batbox.ex_" /q
del "%tmp%\t.dat"

:menu
echo. >> %pathswh%\Notepad\NoteFile%noteact%.tmp
set y=1234
set x=5678
cls
color f0
batbox /c 0x70 /d "File | Edit | View | Help |                                                                                             "
echo.
if %y%==0 if %x% leq 5 (
	set x=
	set y=
	batbox /c 0xf0 /d "  Save as...  "
	echo.
	batbox /c 0x70 /d "  Save        "
	echo.
	batbox /c 0x70 /d "  Quit        "
	echo x=%x% y=%y%
	call :coords
	echo x=%x% y=%y%
	if %x% geq 3 if %y%==3 if %x% leq 14 echo XD
	batbox /g 1 1 /d "Save as: " 
	set /p saveas=
	if exist %saveas% echo %saveas% already exists!
	echo.
	echo Saved
	pause>nul
)

if %y%==0 if %x% geq 6 if %x% lss 10 echo EDIT & pause
echo.
if %wr%==0 batbox /c 0x70 /d "Press any key to start writing. Type {MENU} to open menus." & set wr=1
pause>nul
cls
color f0
batbox /c 0x70 /d "File | Edit | View | Help |                                                                                             "
echo.
:write
set write=[{CRLF-SWH_NOTEPAD_id:31634mn34h8rfy789208735fh}-ENTER]
set /a written=%written%+1
set /a about_restoreclick=%written%+3
batbox /c 0xf0 /d ""
set /p "write= "
if "%write%"=="{MENU}" (goto menuson)
if "%write%"=="[{CRLF-SWH_NOTEPAD_id:31634mn34h8rfy789208735fh}-ENTER]" (echo.>> %pathswh%\Notepad\NoteFile%noteact%.tmp & goto write)
echo %write% >> %localappdata%\ScriptingWindowsHost\Notepad\NoteFile%noteact%.tmp
goto :write


:menuson
call :coords
if %y%==0 if %x% leq 5 (goto clickmenu_file)

if %x% geq 20 if %y%==0 goto clickmenu_about 
echo.

goto write





:clickmenu_file
batbox /g 0 1 /c 0x70 /d "Save as..."
echo.
batbox /g 0 2 /c 0x70 /d "Save      "
echo.
batbox /g 0 3 /c 0x70 /d "Open      "
echo.
batbox /g 0 4 /c 0x70 /d "Quit      "

call :coords
echo createObject("WScript.Shell").SendKeys "%~dp0" > "%pathswh%\Temp\NotepadPath.vbs"
if %y%==1 if %x% geq 1 if %x% leq 12 (
	:saveas
	batbox /g 0 2 /c 0xf0 /d "             "
	batbox /g 0 3 /c 0xf0 /d "             "
	batbox /g 0 1 /c 0x70 /d "Save as: "
	batbox /g 0 4 /c 0x70 /d "             "
	start WScript.exe "%pathswh%\Temp\NotepadPath.vbs"
	set /p saveas=
	copy "%pathswh%\Notepad\NoteFile%noteact%.tmp" %saveas%	
	if exist "%saveas%" (echo Saved) else (echo Error while saving)
)
if %y%==2 if %x% geq 1 if %x% leq 12 if "%saved%"=="0" (goto saveas) else (set saved=1 & copy "%localappdata%\ScriptingWindowsHost\Notepad\NoteFile%noteact%.tmp" "%saveas%">nul & batbox /g 0 1 /d "         " & batbox /g 0 2 /d "         " & batbox /g 0 3 /d "         ")
if %y%==3 if %x% geq 1 if %x% leq 12 (exit /B)
echo.
goto write

:clickmenu_about
batbox /g 20 1 /c 0x70 /d "About SWH Notepad"
call :coords
if %x% geq 20 if %x% leq 40 if %y%==1 (
	echo msgbox "Scripting Windows Host Notepad - Version 2.1"^&vbLf^&vbLf^&"By anic17"^&vbLf^&"GitHub: http://github.com/anic17/SWH",4160,"About Scripting Windows Host Notepad" > "%pathswh%\Temp\AboutNotepad.vbs"
	start /wait WScript.exe "%pathswh%\Temp\AboutNotepad.vbs"
	del "%pathswh%\Temp\AboutNotepad.vbs" /q
)
batbox /g 20 1 /c 0xf0 /d "                   "
batbox /g 0 %about_restoreclick% /d ""
goto write

:coords
for /f "delims=: tokens=1,2" %%A in ('batbox.exe /M') do (
	set x=%%A
	set y=%%B
)
