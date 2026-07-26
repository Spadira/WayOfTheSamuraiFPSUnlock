@echo off
setlocal enabledelayedexpansion
set "G=%~dp0"
set "ACT=%G%Common\Character\Action"
title WotS4 Framerate Selector
:menu
cls
echo ==================================================
echo    Way of the Samurai 4  -  Framerate Selector
echo ==================================================
echo    Close the game before switching.
echo.
echo     1 = 30 fps   (stock / original)
echo     2 = 60 fps   [RECOMMENDED - fully polished]
echo     3 = 90 fps   (experimental*)
echo     4 = 120 fps  (experimental*)
echo.
echo    Gameplay (movement/animation/camera/combat) is
echo    correct at every rate. *At 90/120, menus run a
echo    bit fast and some action sounds play long - the
echo    game's own engine limits; 60 is the sweet spot.
echo.
echo     Q = Quit
echo.
set "EXE=" & set "DAT=" & set "FPS="
set /p "c=Select [1-4, Q]: "
if /i "%c%"=="Q" exit /b
if "%c%"=="1" ( set "EXE=WayOfTheSamurai4.exe.orig"   & set "DAT=MotionDatabase.l.orig_bak" & set "FPS=30" )
if "%c%"=="2" ( set "EXE=WayOfTheSamurai4.exe.fps60"  & set "DAT=MotionDatabase.l.fps60"    & set "FPS=60" )
if "%c%"=="3" ( set "EXE=WayOfTheSamurai4.exe.fps90"  & set "DAT=MotionDatabase.l.fps90"    & set "FPS=90" )
if "%c%"=="4" ( set "EXE=WayOfTheSamurai4.exe.fps120" & set "DAT=MotionDatabase.l.fps120"   & set "FPS=120" )
if not defined EXE ( echo Invalid choice. & timeout /t 1 >nul & goto menu )
if not exist "%G%%EXE%" ( echo ERROR: %EXE% missing. & pause & goto menu )
copy /Y "%G%%EXE%" "%G%WayOfTheSamurai4.exe" >nul 2>&1
if errorlevel 1 ( echo ERROR: could not write exe - is the game still running? & pause & goto menu )
copy /Y "%ACT%\%DAT%" "%ACT%\MotionDatabase.l" >nul 2>&1
if errorlevel 1 ( echo ERROR: could not write MotionDatabase.l & pause & goto menu )
echo.
echo   ^>^>^>  Set to %FPS% fps.  Launch the game normally.  ^<^<^<
echo.
choice /c YN /m "Launch the game now"
if errorlevel 2 goto menu
start "" "%G%WayOfTheSamurai4.exe"
exit /b
