@echo off
:: ===========================================================================
:: Update Assistant
set version=1.0.0
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2022 KcrPL
:: ===========================================================================
setlocal enableextensions
setlocal EnableDelayedExpansion

if exist temp.bat del /q temp.bat

set last_build=2022/06/23
set at=20:12 CET
set header=Update Assistant - (C) KcrPL v%version% (Compiled on %last_build% at %at%)
::
set /a no_start=0
set /a beta=0
set /a preboot=0
::

if "%1"=="-no_start" set /a no_start=1
if "%2"=="-no_start" set /a no_start=1
if "%3"=="-no_start" set /a no_start=1

if "%1"=="-beta" set /a beta=1
if "%2"=="-beta" set /a beta=1
if "%3"=="-beta" set /a beta=1


if "%1"=="-preboot" set /a preboot=1
if "%1"=="-preboot" set /a preboot=1
if "%2"=="-preboot" set /a preboot=1

if "%1"=="-OpenPS2LoaderUpdater" goto openps2loaderupdater


goto no_parameters

:no_parameters
echo.
echo :---------------------------------------------:
echo : Update Assistant                            :
echo : Usage: update_assistant.bat [options...]    :
echo :---------------------------------------------:
echo.
echo -OpenPS2LoaderUpdater          Will download latest OpenPS2LoaderUpdater to current dir
echo -no_start                      Won't start the patcher after the download is complete
GOTO:EOF

:openps2loaderupdater
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new Open PS2 Loader Updater update.
curl -s -S --insecure "https://kcrpl.github.io/Patchers_Auto_Update/Open_PS2_Loader_Updater/v1/UPDATE/Open-PS2-Loader-Updater.bat" --output "Open-PS2-Loader-UpdaterTEMP.bat"
set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

del Open-PS2-Loader-Updater.bat
ren "Open-PS2-Loader-UpdaterTEMP.bat" "Open-PS2-Loader-Updater.bat"

if %no_start%==0 start Open-PS2-Loader-Updater.bat

del /q update_assistant.bat
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