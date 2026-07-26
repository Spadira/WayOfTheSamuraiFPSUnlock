@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "EXE=WayOfTheSamurai3.exe"
set "B30=%EXE%.orig"
set "B60=%EXE%.60fps_v9"
set "B90=%EXE%.90fps_v9"
set "B120=%EXE%.120fps_v9"

if not exist "%EXE%" goto no_exe
if not exist "%B30%" goto make_orig
goto menu


:no_exe
echo.
echo   ERROR: "%EXE%" not found. Put this file in the game folder.
echo.
pause
exit /b 1


rem ---- first run: snapshot the untouched exe as .orig -----------------------
rem NOTE: label calls are done at top level, never inside a parenthesised
rem block - cmd cannot resolve "call :label" from inside one.
:make_orig
echo.
echo   No "%B30%" found - creating one from the current exe.
echo.
set "BAD="
call :is_same "%B60%"
if not errorlevel 1 set "BAD=60 fps"
call :is_same "%B90%"
if not errorlevel 1 set "BAD=90 fps"
call :is_same "%B120%"
if not errorlevel 1 set "BAD=120 fps"
if defined BAD goto refuse_orig
copy /y "%EXE%" "%B30%" >nul
if errorlevel 1 goto orig_failed
echo   Created "%B30%" - this is now your way back to stock.
echo.
pause
goto menu

:refuse_orig
echo   REFUSING: the installed exe is the !BAD! patched build, not the
echo   original. Creating "%B30%" from it would destroy your only way back.
echo.
echo   Restore the stock exe first ^(reinstall or verify the game^), then
echo   run this again.
echo.
pause
exit /b 1

:orig_failed
echo   Could not create "%B30%" - check the folder is writable.
echo.
pause
exit /b 1


:menu
cls
echo ==================================================
echo    Way of the Samurai 3  -  framerate switcher
echo ==================================================
echo.
call :show_current
echo.
echo    All options run CUTSCENES AT 30 FPS, which is the
echo    rate they were authored for. Only gameplay changes.
echo.
echo      [1]   30 fps  - original, completely unmodified
echo      [2]   60 fps  - recommended
echo      [3]   90 fps  - EXPERIMENTAL, not play-tested
echo      [4]  120 fps  - EXPERIMENTAL, not play-tested
echo.
echo      [Q]  quit
echo.
set "c="
set /p "c=Choose: "
if /i "%c%"=="1" call :switch "%B30%"  "30 fps (original)"      & goto menu
if /i "%c%"=="2" call :switch "%B60%"  "60 fps"                 & goto menu
if /i "%c%"=="3" call :switch "%B90%"  "90 fps (experimental)"  & goto menu
if /i "%c%"=="4" call :switch "%B120%" "120 fps (experimental)" & goto menu
if /i "%c%"=="q" exit /b 0
goto menu


rem ---- errorlevel 0 when EXE is byte-identical to %1 ------------------------
:is_same
if not exist "%~1" exit /b 1
fc /b "%EXE%" "%~1" >nul 2>&1
exit /b %errorlevel%


:show_current
set "CUR=unrecognised (some other build)"
call :match "%B30%"  "30 fps (original)"
call :match "%B60%"  "60 fps"
call :match "%B90%"  "90 fps (experimental)"
call :match "%B120%" "120 fps (experimental)"
echo    Currently installed:  !CUR!
goto :eof

:match
call :is_same "%~1"
if not errorlevel 1 set "CUR=%~2"
goto :eof


:switch
echo.
if not exist "%~1" goto no_build

tasklist /fi "IMAGENAME eq WayOfTheSamurai3.exe" 2>nul | find /i "WayOfTheSamurai3.exe" >nul
if not errorlevel 1 goto still_running

copy /y "%~1" "%EXE%" >nul
if errorlevel 1 goto copy_failed
echo    Switched to %~2
echo.
pause
goto :eof

:no_build
echo    Missing build file:  %~1
echo.
pause
goto :eof

:still_running
echo    The game is still running - close it first, then try again.
echo    ^(Windows will not let the exe be replaced while it is open.^)
echo.
pause
goto :eof

:copy_failed
echo    Copy FAILED. The file may be read-only, or the game is still closing.
echo.
pause
goto :eof
