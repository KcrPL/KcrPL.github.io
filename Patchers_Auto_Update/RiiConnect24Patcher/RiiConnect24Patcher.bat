@echo off
cls
echo Please wait...
set FilesHostedOn=https://kcrPL.github.io/Patchers_Auto_Update/RiiConnect24Patcher

curl -s -S --insecure "%FilesHostedOn%/UPDATE/update_assistant.bat" --output "update_assistant.bat"

echo echo off >>temp.bat
echo ping localhost -n 2^>NUL >>temp.bat
echo start update_assistant.bat /q >>temp.bat
echo exit >>temp.bat

start temp.bat
exit