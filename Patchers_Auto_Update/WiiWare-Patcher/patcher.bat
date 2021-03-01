@echo off
cls
echo Please wait...
set FilesHostedOn=https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1

curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/update_assistant.bat" --output "update_assistant.bat"
if not "%errorlevel%"=="0" goto download_failed
update_assistant.bat -WiiWare_Patcher
exit

:download_failed
cls
echo Download failed.
echo Please visit https://github.com/RiiConnect24/auto-wiiware-patcher/releases to get the latest version.
echo.
echo Fatal error, halting.
pause>NUL
goto download_failed