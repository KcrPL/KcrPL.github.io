echo %~d0%~p0
cd "%~d0%~p0"
@echo off
:1
:: Window size (Lines, columns)
set mode=126,36
mode %mode%
set s=NUL
:: Window Title
title Riiconnect24 Patcher switcher
echo please wait...
:: 1=Enable 0=Disable
:: offlinestorage - Only used while testing of Update function, default=0
:: FilesHostedOn - The website and path to where the files are hosted. WARNING! DON'T END WITH "/"
:: MainFolder/TempStorage - folder that is used to keep version.txt and whatsnew.txt. These two files are deleted every startup but if offlinestorage will be set 1, they won't be deleted.
set /a Riiconnect24Patcher_Update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://raw.githubusercontent.com/KcrPL/KcrPL.github.io/master/Patchers_Auto_Update/RiiConnect24Patcher
set MainFolder=%appdata%\Riiconnect24Patcher
set TempStorage=%appdata%\Riiconnect24Patcher\internet\temp
if not exist "%MainFolder%" md "%MainFolder%"
if not exist "%TempStorage%" md "%TempStorage%"
:: Checking if I have access to files on your computer
if exist %TempStorage%\checkforaccess.txt del /q %TempStorage%\checkforaccess.txt

echo test >>"%TempStorage%\checkforaccess.txt"
set /a file_access=1
if not exist "%TempStorage%\checkforaccess.txt" set /a file_access=0

if exist "%TempStorage%\checkforaccess.txt" del /q "%TempStorage%\checkforaccess.txt

::Cleanup
if exist 00000006-31.delta` del /q 00000006-31.delta`
if exist 00000006-80.delta` del /q 00000006-80.delta`
if exist libWiiSharp.dll` del /q libWiiSharp.dll`
if exist Sharpii.exe` del /q Sharpii.exe`
if exist WadInstaller.dll` del /q WadInstaller.dll`
if exist wget.exe` del /q wget.exe`
if exist xdelta3.exe` del /q xdelta3.exe`
if exist 00000006-31.delta del /q 00000006-31.delta
if exist 00000006-80.delta del /q 00000006-80.delta
if exist libWiiSharp.dll del /q libWiiSharp.dll
if exist Sharpii.exe del /q Sharpii.exe
if exist WadInstaller.dll del /q WadInstaller.dll
if exist wget.exe del /q wget.exe
if exist xdelta3.exe del /q xdelta3.exe

:: Delete version.txt and whatsnew.txt
if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if exist "%TempStorage%\version.txt`" del "%TempStorage%\version.txt`" /q
if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q
if exist "%TempStorage%\whatsnew.txt`" del "%TempStorage%\whatsnew.txt`" /q
powershell -c >NUL
:: Downloading the update files.
call powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/RiiConnect24Patcher.bat"', 'RiiConnect24Patcher.bat"')"

echo echo off >>temp.bat
echo ping localhost -n 2^>NUL >>temp.bat
echo del patch.bat /q >>temp.bat
echo start RiiConnect24Patcher.bat >>temp.bat
echo exit >>temp.bat
start temp.bat
exit
exit
exit
