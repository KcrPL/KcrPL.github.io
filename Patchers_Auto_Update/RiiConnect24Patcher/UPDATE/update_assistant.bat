@echo off
:: ===========================================================================
:: Update Assistant for RiiConnect24
set version=1.0.4
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2020 KcrPL, RiiConnect24 and it's (Lead) Developers
:: ===========================================================================
setlocal enableextensions
setlocal EnableDelayedExpansion

if exist temp.bat del /q temp.bat

set last_build=2021/04/27
set at=01:04
set header=Update Assistant - (C) KcrPL v%version% (Compiled on %last_build% at %at%)
::
set /a no_start=0
set /a beta=0
set /a preboot=0
set FilesHostedOn=https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1
set FilesHostedOn_Beta=https://patcher.rc24.xyz/update/RiiConnect24-Patcher_BETA/v1
::

if "%1"=="-no_start" set /a no_start=1
if "%2"=="-no_start" set /a no_start=1
if "%3"=="-no_start" set /a no_start=1

if "%1"=="-beta" set /a beta=1
if "%2"=="-beta" set /a beta=1
if "%3"=="-beta" set /a beta=1


if "%1"=="-preboot" set /a preboot=1
if "%2"=="-preboot" set /a preboot=1
if "%3"=="-preboot" set /a preboot=1

if "%1"=="-RC24_Patcher" goto start_download_rc24_patcher
if "%2"=="-RC24_Patcher" goto start_download_rc24_patcher
if "%3"=="-RC24_Patcher" goto start_download_rc24_patcher

if "%1"=="-WiiWare_Patcher" goto start_download_wiiware_patcher
if "%2"=="-WiiWare_Patcher" goto start_download_wiiware_patcher
if "%3"=="-WiiWare_Patcher" goto start_download_wiiware_patcher


if "%1"=="-VFF_Downloader_Main_Exec" goto start_download_vff_downloader_main_exec
if "%1"=="-VFF_Downloader_Installer" goto start_download_vff_downloader_install
if "%1"=="-RC24_DNS_Checker" goto start_download_dns_checker
if "%2"=="-RC24_DNS_Checker" goto start_download_dns_checker

if "%1"=="-Mail-Patcher" goto start_download_mail_patcher



goto no_parameters

:no_parameters
echo.
echo :---------------------------------------------:
echo : RiiConnect24 Update Assistant for Windows.  :
echo : Usage: update_assistant.bat [options...]    :
echo :---------------------------------------------:
echo.
echo -RC24_Patcher                  Will download latest RiiConnect24 Patcher to current dir
echo -WiiWare_Patcher               Will download latest WiiWare Patcher to current dir
echo -Mail-Patcher                  Will download latest Mail Patcher to current dir
echo -VFF_Downloader_Main_Exec      Will download executable for VFF Downloader for Dolphin
echo -VFF_Downloader_Installer      Will download installer for VFF Downloader for Dolphin
echo -RC24_DNS_Checker              Will download latest version of RiiConnect24 DNS Checker to current dir
echo -no_start                      Won't start the patcher after the download is complete
GOTO:EOF
:start_download_dns_checker
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new RiiConnect24 DNS Checker update.
if exist "RiiConnect24_DNS_CheckerTEMP.bat" del /q RiiConnect24_DNS_CheckerTEMP.bat
curl -s -S --insecure "https://kcrpl.github.io/Patchers_Auto_Update/RiiConnect24_DNS_Checker/UPDATE/RiiConnect24_DNS_Checker.bat" --output "RiiConnect24_DNS_Checker.bat"

set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

if %no_start%==0 start RiiConnect24_DNS_Checker.bat
del /q "%~n0~x0"
exit

:start_download_vff_downloader_install
set mode=128,37
mode %mode%
cls
echo %header%
echo.
echo -----------------------------------------------------------------------------------------------------------------------------
echo Please wait! We are now downloading your new VFF Downloader for Dolphin update.
curl -s -S --insecure "https://patcher.rc24.xyz/update/VFF-Downloader-for-Dolphin/v1/UPDATE/Install.bat" --output "InstallTEMP.bat"

set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

del /q Install.bat
ren "InstallTEMP.bat" "Install.bat"

if %no_start%==0 start Install.bat
del /q "%~n0~x0"
exit

:start_download_vff_downloader_main_exec
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new VFF Downloader for Dolphin update.

taskkill /im VFF-Downloader-for-Dolphin.exe /f /t
taskkill /im VFF-Downloader-for-DolphinTEMP.exe /f /t

if exist VFF-Downloader-for-Dolphin.exe del /q VFF-Downloader-for-Dolphin.exe
::ren "VFF-Downloader-for-DolphinTEMP.exe" "VFF-Downloader-for-Dolphin.exe"

curl -s -S --insecure "https://patcher.rc24.xyz/update/VFF-Downloader-for-Dolphin/v1/UPDATE/VFF-Downloader-for-Dolphin.exe" --output "VFF-Downloader-for-Dolphin.exe"
set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

if %no_start%==0 start VFF-Downloader-for-Dolphin.exe
exit

:start_download_mail_patcher
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new Mail Patcher update.
curl -s -S --insecure "https://patcher.rc24.xyz/update/Mail-Patcher/v1/UPDATE/patch.bat" --output "patchTEMP.bat"
set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

del patch.bat
ren "patchTEMP.bat" "patch.bat"

if %no_start%==0 start patch.bat

del /q "%~n0~x0"
exit

:start_download_wiiware_patcher
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new WiiWare Patcher update.
curl -s -S --insecure "https://patcher.rc24.xyz/update/WiiWare-Patcher/v1/UPDATE/WiiWarePatcher.bat" --output "patcherTEMP.bat"
set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

if exist patcher.bat del patcher.bat
if exist WiiWarePatcher.bat del WiiWarePatcher.bat
ren "patcherTEMP.bat" "WiiWarePatcher.bat"

if %no_start%==0 start WiiWarePatcher.bat

del /q "%~n0~x0"
exit

:start_download_rc24_patcher
set mode=128,37
mode %mode%
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait! We are now downloading your new RiiConnect24 Patcher update.
if %beta%==0 curl -s -S --insecure "%FilesHostedOn%/UPDATE/RiiConnect24Patcher.bat" --output "RiiConnect24PatcherTEMP.bat"
if %beta%==1 curl -s -S --insecure "%FilesHostedOn_Beta%/UPDATE/RiiConnect24Patcher.bat" --output "RiiConnect24PatcherTEMP.bat"
set temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_download

del RiiConnect24Patcher.bat
ren "RiiConnect24PatcherTEMP.bat" "RiiConnect24Patcher.bat"

if %no_start%==0 if %preboot%==0 start RiiConnect24Patcher.bat

del /q "%~n0~x0"
if %preboot%==1 GOTO:EOL
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