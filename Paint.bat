@echo off



set sizerubber=1
set pathswh=%localappdata%\ScriptingWindowsHost
if exist "%pathswh%\Paint\Draw1.swhdrw" del "%pathswh%\Paint\Draw1.swhdrw" /q
color 07
mode con: cols=120 lines=35
title Batch paint
set brush=ê
cls
if not "%1"=="" (goto params) 
:start_paint
cd /d "%tmp%"

if exist batbox.exe goto exists_batbox
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
:exists_batbox



batbox /g 0 0 /c 0x07 /d "Starting Scripting Windows Host Paint..."
echo.
batbox /g 100 11 /c 0x07 /d "êêêêêêêêêêêêêêêêêê"
batbox /g 100 12 /c 0x07 /d "êê Shadow color êê"
batbox /g 100 13 /c 0x07 /d "êêêêêêêêêêêêêêêêêê"


batbox /g 100 18 /c 0x07 /d "êêêêêêêêêêê"
batbox /g 100 19 /c 0x07 /d "êê Color êê"
batbox /g 100 20 /c 0x07 /d "êêêêêêêêêêê"
batbox /g 100 14 /c 0x01 /d "êê" & ::Blue
batbox /g 102 14 /c 0x02 /d "êê" & ::Green
batbox /g 104 14 /c 0x03 /d "êê"
batbox /g 106 14 /c 0x04 /d "êê"
batbox /g 108 14 /c 0x05 /d "êê"
batbox /g 110 14 /c 0x06 /d "êê"
batbox /g 100 15 /c 0x07 /d "êê"
batbox /g 102 15 /c 0x08 /d "êê"
batbox /g 104 15 /c 0x09 /d "êê"
batbox /g 106 15 /c 0x0a /d "êê"
batbox /g 108 15 /c 0x0b /d "êê"
batbox /g 110 15 /c 0x0c /d "êê"
batbox /g 100 16 /c 0x0d /d "êê"
batbox /g 102 16 /c 0x0e /d "êê"
batbox /g 104 16 /c 0x0f /d "êê"















batbox /g 100 18 /c 0x07 /d "êêêêêêêêêêê"
batbox /g 100 19 /c 0x07 /d "êê Color êê"
batbox /g 100 20 /c 0x07 /d "êêêêêêêêêêê"
batbox /g 100 21 /c 0x01 /d "êê" & ::Blue
batbox /g 102 21 /c 0x02 /d "êê" & ::Green
batbox /g 104 21 /c 0x03 /d "êê"
batbox /g 106 21 /c 0x04 /d "êê"
batbox /g 108 21 /c 0x05 /d "êê"
batbox /g 110 21 /c 0x06 /d "êê"
batbox /g 100 22 /c 0x07 /d "êê"
batbox /g 102 22 /c 0x08 /d "êê"
batbox /g 104 22 /c 0x09 /d "êê"
batbox /g 106 22 /c 0x0a /d "êê"
batbox /g 108 22 /c 0x0b /d "êê"
batbox /g 110 22 /c 0x0c /d "êê"
batbox /g 100 23 /c 0x0d /d "êê"
batbox /g 102 23 /c 0x0e /d "êê"
batbox /g 104 23 /c 0x0f /d "êê"
batbox /g 100 25 /c 0x07 /d "Erase"
batbox /g 100 26 /c 0x07 /d "Size of rubber:"

batbox /g 100 27 /c 0x07 /d "1x1 %selectedrubber1x1%"
batbox /g 100 28 /c 0x07 /d "3x3 %selectedrubber3x3%"
batbox /g 100 29 /c 0x07 /d "5x5 %selectedrubber5x5%"


batbox /g 100 31 /c 0x07 /d "êêêêêêêêêêêêêêêê"
batbox /g 100 32 /c 0x07 /d "êê Geometrics êê"
batbox /g 100 33 /c 0x07 /d "êêêêêêêêêêêêêêêê"
batbox /g 100 34 /c 0x07 /d "Square"

batbox /g 0 0 /c 0x07 /d "                                         "
batbox /g 0 34 /c 0x70 /d "Open file"

:paint
batbox /g 100 25 /c 0x07 /d "Erase"
batbox /g 100 0 /c 0x07 /d "Current color: " & batbox /g 115 0 /c 0x0%colordraw% /d "êê"
call :coords
if %x% geq 100 if %x% leq 101 if %y%==21 set colordraw=1 & goto paint
if %x% geq 102 if %x% leq 103 if %y%==21 set colordraw=2 & goto paint
if %x% geq 104 if %x% leq 105 if %y%==21 set colordraw=3 & goto paint
if %x% geq 106 if %x% leq 107 if %y%==21 set colordraw=4 & goto paint
if %x% geq 108 if %x% leq 109 if %y%==21 set colordraw=5 & goto paint
if %x% geq 110 if %x% leq 111 if %y%==21 set colordraw=6 & goto paint
if %x% geq 100 if %x% leq 101 if %y%==22 set colordraw=7 & goto paint
if %x% geq 102 if %x% leq 103 if %y%==22 set colordraw=8 & goto paint
if %x% geq 104 if %x% leq 105 if %y%==22 set colordraw=9 & goto paint
if %x% geq 106 if %x% leq 107 if %y%==22 set colordraw=a & goto paint
if %x% geq 108 if %x% leq 109 if %y%==22 set colordraw=b & goto paint
if %x% geq 110 if %x% leq 111 if %y%==22 set colordraw=c & goto paint
if %x% geq 100 if %x% leq 101 if %y%==23 set colordraw=d & goto paint
if %x% geq 102 if %x% leq 103 if %y%==23 set colordraw=e & goto paint
if %x% geq 104 if %x% leq 105 if %y%==23 set colordraw=f & goto paint
if %x% geq 100 if %x% leq 106 if %y%==25 set colordraw=0 & goto paint




if %x% geq 100 if %x% leq 101 if %y%==14 set colordraw=1 & goto paint
if %x% geq 102 if %x% leq 103 if %y%==14 set colordraw=2 & goto paint
if %x% geq 104 if %x% leq 105 if %y%==14 set colordraw=3 & goto paint
if %x% geq 106 if %x% leq 107 if %y%==14 set colordraw=4 & goto paint
if %x% geq 108 if %x% leq 109 if %y%==14 set colordraw=5 & goto paint
if %x% geq 110 if %x% leq 111 if %y%==14 set colordraw=6 & goto paint
if %x% geq 100 if %x% leq 101 if %y%==15 set colordraw=7 & goto paint
if %x% geq 102 if %x% leq 103 if %y%==15 set colordraw=8 & goto paint
if %x% geq 104 if %x% leq 105 if %y%==15 set colordraw=9 & goto paint
if %x% geq 106 if %x% leq 107 if %y%==15 set colordraw=a & goto paint
if %x% geq 108 if %x% leq 109 if %y%==15 set colordraw=b & goto paint
if %x% geq 110 if %x% leq 111 if %y%==15 set colordraw=c & goto paint
if %x% geq 100 if %x% leq 101 if %y%==16 set colordraw=d & goto paint
if %x% geq 102 if %x% leq 103 if %y%==16 set colordraw=e & goto paint
if %x% geq 104 if %x% leq 105 if %y%==16 set colordraw=f & goto paint






if %x% geq 100 if %x% leq 107 if %y%==34 goto make_square & goto paint
if %x% geq 0 if %x% leq 9 if %y%==34 goto Menu_Open 


batbox /g %x% %y% /c 0x0%colordraw% /d "ê"
echo /g %x% %y% /c 0x0%colordraw% /d "ê" >> %pathswh%\Paint\Draw1.swhdrw

rem :NotErase

goto paint






:make_square
batbox /g 26 0 /c 0x70 /d "Click the rectangle start point"

call :coords
batbox /g %x% %y% /c 0x%colordraw%0 /d "ê"

set squarestart_x=%x%
set squarestart_y=%y%


batbox /g 26 0 /c 0x70 /d "Click the rectangle end point"

batbox /g 55 0 /c 0x07 /d "  "

call :coords
batbox /g %x% %y% /c 0x%colordraw%0 /d "ê"


set squareend_x=%x%
set squareend_y=%y%


::if %squarestart_x% lss %squareend_x% (
::	set lss_x_square=-
::	set tmp_sq_startx=%squarestart_x%
::	set squarestart_x=%squareend_x%
::	set squareend_x=%squarestart_x%
::)

::if %squarestart_y% lss %squareend_y% (
::	set lss_y_square=-
::	set tmp_sq_starty=%squarestart_y%
::	set squarestart_y=%squareend_y%
::	set squareend_y=%squarestart_y%
::)







batbox /g %squarestart_x% %squarestart_y% /c 0x0%colordraw% /d "ê"



set end_Y_square=%y%
batbox /g 10 0 /c 0x07 /d "                                                                                  "
batbox /g 26 0 /c 0x70 /d "Creating rectangle..."

for /l %%s in (%squareend_x%,1,%squarestart_x%) DO (

	for /l %%S in (%squareend_y%,1,%squarestart_y%) DO (

		batbox /g %%s %%S /c 0x0%colordraw% /d "%brush%"
		echo /g %%s %%S /c 0x0%colordraw% /d "%brush%" >> "%pathswh%\Paint\Draw1.swhdrw"
	)
)



batbox /g 26 0 /c 0x07 /d "                               "








goto paint


:params
if exist "%~1" (goto params_open) else (goto start_paint)

:params_open
cd /d "%~dp1"
set open_edit=1
for /f "tokens=1,2* delims=," %%o in (%~n1.swhdrw) do ("%tmp%\batbox.exe" %%o)
goto start_paint



:open_notexist
echo Batch Paint - Error
echo.
echo "%~1" does not exist!
echo.
pause>nul
exit /B

:openfile
cd /d "%%~dpf"
echo "%%~dpf"
pause
exit /B




::if %x% geq 106 if %x% leq 111 if %y%==25 goto NotErase & ::(goto checkiferase) else (goto NotErase)






:checkiferase
::CheckIfErase
if %sizerubber%==1 (batbox /g %x% %y% 0x00 /d " " & goto paint)
if %sizerubber%==3 (
	::Operations needed for getting size in correct place
	set /a x_rubber_size3_min=%x%-1
	set /a y_rubber_size3_min=%y%-1
	set /a current_x_rubber_size3
	set /a x_rubber_size3_max=%x%+1
	set /a y_rubber_size3_max=%y%+1
	batbox /g %x_rubber_size3_min% %y_rubber_size3_min% /c 0x00 /d "   "
	batbox /g %x_rubber_size3_min% %y% /c 0x00 /d "   "
	batbox /g %x_rubber_size3_max% %y_rubber_size3_max% /c 0x00 /d "   "
	goto paint
)	
if %sizerubber%==5 (
	::More operations
	set /a x_rubber_size5_min2=%x%-2
	set /a y_rubber_size3_min=%y%-2


	set /a current_x_rubber_size3=1



	set /a x_rubber_size5_max=%x%+2
	set /a y_rubber_size3_max2=%y%+2
)





::


if %x% geq 100 if %x% leq 106 if %y%==27 set sizerubber=1 & batbox /g 105 27 /c 0x70 /d "X" & batbox /g 105 28 /c 0x07 /d " " & batbox /g 105 29 /c 0x07 /d " " & set colordraw=0 & goto paint
if %x% geq 100 if %x% leq 106 if %y%==28 set sizerubber=3 & batbox /g 105 28 /c 0x70 /d "X" & batbox /g 105 27 /c 0x07 /d " " & batbox /g 105 29 /c 0x07 /d " " & set colordraw=0 & goto paint
if %x% geq 100 if %x% leq 106 if %y%==29 set sizerubber=5 & batbox /g 105 29 /c 0x70 /d "X" & batbox /g 105 27 /c 0x07 /d " " & batbox /g 105 28 /c 0x07 /d " " & set colordraw=0 & goto paint


:Menu_Open

echo Function Get-FileName($initialDirectory) >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo {   >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo  [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") ^| >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo  Out-Null >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"

echo  $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo  $OpenFileDialog.initialDirectory = $initialDirectory >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo  $OpenFileDialog.filter = "SWH Draw files (*.swhdrw)| *.swhdrw" >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo  $OpenFileDialog.ShowDialog() ^| Out-Null >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo  $OpenFileDialog.filename >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
echo } #end function Get-FileName >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"

echo Get-FileName -initialDirectory "%pathswh%\Paint\MyDrawings" ^> "%pathswh%\Temp\FileDialog" >> "%pathswh%\Temp\OpenFileDialogPaint.ps1"
powershell.exe "%pathswh%\Temp\OpenFileDialogPaint.ps1"
set actcd=%cd%
cd /d "%pathswh%\Temp"
for /f "tokens=1,2* delims=," %%f in (FileDialog) do (set fileselected=%%f)
if /i not "%fileselected%"=="" goto openfile
cd /d "%actcd%"
goto paint



:coords
for /f "delims=: tokens=1,2" %%A in ('batbox.exe /M') do (
	set x=%%A
	set y=%%B
)
