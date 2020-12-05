@echo off
:: ===========================================================================
:: Update Assistant for WiiLink24
set version=1.0.0
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2020 KcrPL
:: ===========================================================================
setlocal enableextensions
setlocal EnableDelayedExpansion

if exist temp.bat del /q temp.bat

set last_build=2020/12/04
set at=23:21
set header=Update Assistant - (C) KcrPL v%version% (Compiled on %last_build% at %at%)
::
set /a no_start=0
set /a beta=0
set /a preboot=0
set FilesHostedOn=https://kcrpl.github.io/Patchers_Auto_Update/WiiLink24-Patcher/v1

::

if "%1"=="-no_start" set /a no_start=1
if "%2"=="-no_start" set /a no_start=1

if "%1"=="-beta" set /a beta=1
if "%2"=="-beta" set /a beta=1
if "%3"=="-beta" set /a beta=1


if "%1"=="-preboot" set /a preboot=1
if "%2"=="-preboot" set /a preboot=1
if "%3"=="-preboot" set /a preboot=1

if "%1"=="-WiiLink24_Patcher" goto start_download_wiilink24_patcher
if "%2"=="-WiiLink24_Patcher" goto start_download_wiilink24_patcher



goto no_parameters

:no_parameters
echo.
echo :---------------------------------------------:
echo : WiiLink24 Update Assistant for Windows.     :
echo : Usage: update_assistant.bat [options...]    :
echo :---------------------------------------------:
echo.
echo -WiiLink24_Patcher                Will download latest WiiLink24 Patcher to current dir
GOTO:EOF

:start_download_wiilink24_patcher
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new WiiLink24 Patcher update.
curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/WiiLink24Patcher.bat" --output "WiiLink24PatcherTEMP.bat"
set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

del WiiLink24Patcher.bat
ren "WiiLink24PatcherTEMP.bat" "WiiLink24Patcher.bat"

if %no_start%==0 start WiiLink24Patcher.bat

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