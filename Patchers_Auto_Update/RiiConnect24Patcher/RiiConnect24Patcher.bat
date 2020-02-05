@echo off
cls
echo Please wait...
set FilesHostedOn=https://kcrPL.github.io/Patchers_Auto_Update/RiiConnect24Patcher

curl -s -S --insecure "%FilesHostedOn%/UPDATE/update_assistant.bat" --output "update_assistant.bat"

update_assistant.bat -RC24_Patcher

exit