@echo off
:: ===========================================================================
:: Update Assistant for RiiConnect24
set version=1.0.0
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2020 KcrPL, RiiConnect24 and it's (Lead) Developers
:: ===========================================================================
setlocal enableextensions
setlocal EnableDelayedExpansion

if exist temp.bat del /q temp.bat

set last_build=05.02.2020
set at=12:00
set header=Update Assistant - (C) KcrPL v%version% (Compiled on %last_build% at %at%)
::
set /a no_start=0
::

if "%1"=="-no_start" set /a no_start=1
if "%2"=="-no_start" set /a no_start=1

if "%1"=="-RC24_Patcher" goto start_download_rc24_patcher
if "%2"=="-RC24_Patcher" goto start_download_rc24_patcher

echo %file_name%
goto no_parameters

:no_parameters
echo.
echo RiiConnect24 Update Assistant for Windows.
echo Usage: update_assistant.bat [options...]
echo.
echo -RC24_Patcher        Will download latest RiiConnect24 Patcher to current dir
echo -no_start            Won't start the patcher after the download is complete 
GOTO:EOF
:start_download_rc24_patcher
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new RiiConnect24 Patcher update.
curl -s -S --insecure "%FilesHostedOn%/UPDATE/RiiConnect24Patcher.bat" --output "RiiConnect24PatcherTEMP.bat"

set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

del RiiConnect24Patcher.bat
ren "RiiConnect24PatcherTEMP.bat" "RiiConnect24Patcher.bat"

if %no_start%==0 start RiiConnect24Patcher.bat
del /q "%~n0~x0"
exit

:error_download
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Oops! There was an error while downloading the file(s).
echo.
echo Exit code: %temperrorlev%
echo.
echo Please contact KcrPL#4625 on Discord.
echo The update assistant will now return to loader or it will exit.
echo.
echo Press any button to continue.
pause>NUL
GOTO:EOF