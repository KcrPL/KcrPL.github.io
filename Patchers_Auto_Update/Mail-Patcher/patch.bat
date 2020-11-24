@echo off
cls
echo Please wait...
set FilesHostedOn=https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1

curl -s -S --insecure "%FilesHostedOn%/UPDATE/update_assistant.bat" --output "update_assistant.bat"

update_assistant.bat -Mail-Patcher

exit