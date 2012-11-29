@echo off
setlocal enableextensions enabledelayedexpansion
set mcdir=%appdata%\.minecraft
set x=0
set y=0
FOR /F "tokens=2 skip=1 delims=()" %%a IN ('FIND /V "http://" "urls.txt"') DO call :tag "%%a"
FOR /F "tokens=* skip=2" %%i IN ('FIND /V "[" "urls.txt"') DO call :url "%%i"
goto ex
endlocal
:tag
set tag[%y%]=%~1
set tlist=%tlist% %~1
set /a y+=1
goto:eof
:url
set curl=%~1
call set ctag=%%tag[%x%]%%
echo %curl%>url.txt
findstr /m "simon816" url.txt
if %errorlevel%==0 (
wget "%curl%" -O "%ctag%.txt"
set /p curl=<%ctag%.txt
)
wget "%curl%" -O "%ctag%.zip" --no-check-certificate
set /a x+=1
del url.txt
del %ctag%.txt
goto:eof
:confirm
IF NOT EXIST "%mcdir%\bin\minecraft.jar" (echo ####################
echo minecraft doesn't exist here
echo please specify a valid location of minecraft
goto confedit)
echo Finalise Configuration:
echo minecraft folder = %mcdir%
set /p conf=Configuration correct? y/n  
if "%conf%"=="n" goto confedit
if "%conf%"=="y" goto ex
cls
goto confirm
:confedit
echo --------------------------------------------
set /p mcdir= Where is your .minecraft folder?  
goto confirm
:ex
title Extracting...
FOR %%i IN (%tlist%) DO (
md %%i
cd %%i
..\7za.exe x ..\%%i.zip
if %%i==spc (move "WorldEdit.jar" "..\WorldEdit.jar"
del "readme.txt")
if %%i==frg (del "minecraftforge_credits.txt")
if %%i==plapi (del "changelog.txt"
del "readme.txt")
if %%i==spcptch (del "changelog.txt"
del "readme.txt")
if %%i==wecui (cd WorldEditCUI-1.4.5
xcopy "classes" "..\" /e /c
cd ..\
rd WorldEditCUI-1.4.5 /S /Q
)
cd ..\
)
cls
title Creating...
SET /p comp=compile into one folder? 
if "%comp%"=="y" (goto comp)
if "%comp%"=="yes" (goto comp)
if "%comp%"=="ok" (goto comp)
exit
:comp
md compilation
FOR %%i IN (%tlist%) DO (
xcopy %%i "compilation" /e /c
)
cls
title Installing...
:top
IF NOT EXIST "%mcdir%\bin\minecraft.jar" (echo ####################
echo minecraft doesn't exist here
echo please specify a valid location of minecraft
goto confedit)
echo Finalise Configuration:
echo minecraft folder = %mcdir%
set /p conf=Configuration correct? y/n  
if "%conf%"=="n" goto confedit
if "%conf%"=="y" goto next
cls
goto top
:next
set /p apply=Apply these mods to minecraft (in %mcdir%)?
if "%apply%"=="y" (goto apply)
if "%apply%"=="yes" (goto apply)
if "%apply%"=="ok" (goto apply)
exit
:apply
cls
set /p bck=backup Minercaft.jar? y/n  
if "%bck%"=="y" (goto bck)
:add
7za a "%mcdir%\bin\minecraft.jar" .\compilation\*
7za d "%mcdir%\bin\minecraft.jar" META-INF
copy "%CD%\WorldEdit.jar" "%mcdir%\bin"
cls
title Finalising
set /p zip=keep original downloaded zips? y/n  
if "%zip%"=="n" (goto delZip)
:a
cls
set /p ext=keep separate extracted files from zips? y/n  
if "%ext%"=="n" (goto delExt)
:b
cls
set /p all=keep the compilation source files? y/n  
if "%all%"=="n" (
rd "%CD%\compilation" /Q /S
)
:finish
title Done!
cls
pause
exit
:bck
md "%mcdir%\backup"
copy "%mcdir%\bin\minecraft.jar" "%mcdir%\backup\minecraft.jar"
goto add
:delZip
FOR %%i IN (%tlist%) DO (
del "%CD%\%%i.zip" /Q /S
)
goto a
:delExt
FOR %%i IN (%tlist%) DO (
rd "%CD%\%%i" /Q /S
)
goto b

:confedit
echo --------------------------------------------
set /p mcdir= Where is your .minecraft folder?  
goto top