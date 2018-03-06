echo %~d0%~p0
cd "%~d0%~p0"
:startup_begin
@echo off
if exist temp.bat del /q temp.bat
:: ===========================================================================
:: Wii Mail Patcher for Windows
set version=1.1.0
:: AUTHORS: KcrPL, Spotlight
:: ***************************************************************************
:: Copyright (c) 2017 RiiConnect24, and it's (Lead) Developers
:: ===========================================================================
title RiiConnect24 Mail Patcher.
set last_build=2018/03/06
set at=23:18

set mode=126,36
mode %mode%
title Mail Patcher for RiiConnect24 v.%version%  Created by @KcrPL, @Spotlight, @Seriel

set /a rep=1

set /a update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://raw.githubusercontent.com/KcrPL/KcrPL.github.io/master/Patchers_Auto_Update/Mail-Patcher
set MainFolder=%appdata%\Mail-Patcher
set TempStorage=%appdata%\Mail-Patcher\internet\temp

if %os%=="" goto not_windows_nt
if not %os%==Windows_NT goto not_windows_nt

if exist "%MainFolder%\requirerestart.txt" goto reqrestart

set /a patherror=0
if "%cd%"=="%windir%\system32" set /a patherror=1
if %patherror%==0 if not exist patch.bat set /a patherror=2

goto begin_main
:not_windows_nt
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo.
echo Please don't run our Mail Patcher in MS-DOS :P.
echo Run it only on Windows Vista+ computer. :)
pause>NUL	
exit
:reqrestart
del /q "%MainFolder%\requirerestart.txt"
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo.
echo We will now continue the Ruby installation.
echo Please wait...

:begin_main
mode %mode%
set /a uninstalruby=0
set /a customerror=0
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
if %patherror%==0 echo              `..````                                                  
if %patherror%==0 echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
if %patherror%==0 echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
if %patherror%==0 echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd               

if %patherror%==1 echo :----------------------------------------------------------------:                
if %patherror%==1 echo : Warning: Please run this application without admin privilages. :               
if %patherror%==1 echo :----------------------------------------------------------------:

if %patherror%==2 echo :------------------------------------------------------------------------------------------------------:                
if %patherror%==2 echo : Warning: patch.bat not found. You may be running this application from unknown and untrusted source. :               
if %patherror%==2 echo :------------------------------------------------------------------------------------------------------:

echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+    RiiConnect your Wii.       
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN   Press any button to begin                 
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd    (Please mail us at support@riiconnect24.net if you have problems)
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:                 
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.                 
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN                  
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd                  
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy                  
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.                 
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.                 
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
pause>NUL

if %patherror%==1 goto begin_main

set /a errorwinxp=0
timeout -0 /nobreak >NUL || set /a errorwinxp=1
if %errorwinxp%==1 goto winxp_notice

goto startup_script
:winxp_notice
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------              
echo    /---\   Windows XP Support Ended.
echo   /     \  Thanks for using the program but support for any system older than Windows 7 has been ended.
echo  /   !   \ You cannot use this program.
echo  --------- Feel free to join our Discord chat and let our bot patch it for you!
echo.
echo            Press any key to continue.
echo ------------------------------------------------------------------------------------------------------------------------------    
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
pause>NUL
goto begin_main
:startup_script
cls
echo.                                                        
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`   : Launching powershell... :          
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd   :-------------------------:                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:                 
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.                 
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN                  
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd                  
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy                  
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.                 
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.                 
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
powershell -c >NUL
goto check_for_update
:check_for_update
cls
echo.                                                                       
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`   : Checking for updates... :          
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd   :-------------------------:     
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:                 
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.                 
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN                  
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd                  
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy                  
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.                 
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.                 
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
set /a updateavailable=0 
:: We don't support Windows XP anymore. Windows XP don't have timeout command, it means that if that command will be runned on Windows XP it will return exit code 1. 

:: Update script.
set updateversion=0.0.0
:: Delete version.txt and whatsnew.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q

if not exist %TempStorage% md %TempStorage%
:: Commands to download files from server.
if %Update_Activate%==1 if %offlinestorage%==0 powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/whatsnew.txt"', '"%TempStorage%/whatsnew.txt"')"
if %Update_Activate%==1 if %offlinestorage%==0 powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/version.txt"', '"%TempStorage%/version.txt"')"

	set /a temperrorlev=%errorlevel%
	
	::Bind error codes to errors here

if %Update_Activate%==1 if not %errorlevel%==0 goto error_update_not_available
	

:: Copy the content of version.txt to variable.
if exist "%TempStorage%\version.txt" set /p updateversion=<"%TempStorage%\version.txt"
if not exist "%TempStorage%\version.txt" set /a updateavailable=0
if %Update_Activate%==1 if exist "%TempStorage%\version.txt" set /a updateavailable=1
:: If version.txt doesn't match the version variable stored in this batch file, it means that update is available.
if %Update_Activate%==1 if %updateversion%==%version% set /a updateavailable=0 
if %Update_Activate%==1 if %updateavailable%==1 goto update_notice
goto startup_script_files_check
:startup_script_files_check
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:                 
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.                 
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN                  
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd                  
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy                  
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.                 
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.                 
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
echo                                                                        Please wait...
:: Important check for files. We need them to patch Mail
if not exist mailparse.rb goto error_runtime_error
set filcheck=1

goto check_system
:error_runtime_error
set /a update=0
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------              
echo    /---\   ERROR.              
echo   /     \  Some files needed to run this program weren't found.
echo  /   !   \ Press any button to download these files.
echo  ---------              
echo ------------------------------------------------------------------------------------------------------------------------------    
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
pause>NUL
goto update_files
:check_system
cls
echo.                                                                       
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`   : Checking your system... :          
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd   :-------------------------:     
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:                 
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.                 
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN                  
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd                  
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy                  
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.                 
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.                 
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`

set rubyavailable=0
set rubyversion=INCORECT
set bindata=0

::
call ruby -v && set /a rubyavailable=1
::
if exist "%TempStorage%\rubyversion.txt" del "%TempStorage%\rubyversion.txt" /q
call ruby -v >>"%TempStorage%\rubyversion.txt"

if exist "%TempStorage%\rubyversion.txt" findstr /c:"ruby 2.5.0p0" "%TempStorage%\rubyversion.txt"
set temperrorlev=%errorlevel%
if %errorlevel%==0 set rubyversion=OK

if exist "%TempStorage%\bindata.txt" del "%TempStorage%\bindata.txt" /q
call gem list >>"%TempStorage%\bindata.txt"
if exist "%TempStorage%\bindata.txt" findstr /c:"bindata" "%TempStorage%\bindata.txt"
if %errorlevel%==0 set bindata=1

goto main_fade_out


:error_update_not_available
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------              
echo    /---\   Error.              
echo   /     \  An Update server is not available.
echo  /   !   \ 
echo  ---------  If you can't get it to work, please mail us at support@riiconnect24.net. We will answer you and patch your
echo.            nwc24msg.cfg file.
echo            Press any button to continue.
echo ------------------------------------------------------------------------------------------------------------------------------    
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
pause>NUL
goto begin_main
:update_notice
if %updateversion%==0.0.0 goto error_update_not_available
set /a update=1
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------              
echo    /---\   An Update is available.              
echo   /     \  An Update for this program is available. We suggest updating the Mail Patcher to the latest version.
echo  /   !   \ 
echo  ---------  Current version: %version%
echo             New version: %updateversion%
echo                       1. Update                      2. Dismiss               3. What's new in this update?
echo ------------------------------------------------------------------------------------------------------------------------------    
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
set /p s=
if %s%==1 goto update_files
if %s%==2 goto startup_script_files_check
if %s%==3 goto whatsnew
goto update_notice
:update_files
cls
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------              
echo    /---\   Updating.
echo   /     \  Please wait...
echo  /   !   \ 
echo  --------- Mail Patcher will restart shortly... 
echo.             
echo.
echo ------------------------------------------------------------------------------------------------------------------------------    
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
:: Deleting the temp files if they exist.
if exist mailparse.rb` del mailparse.rb` /q 2> nul

:: Downloading the update files. In future i'm gonna add something called "Files Version" (at least i call it that way). Because most of the time the patch.bat is only updated
powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/mailparse.rb"', '"mailparse.rb"`')"
powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/patch.bat"', '"patch.bat"`')"

:: If download failed
if %update%==1 if not exist patch.bat` goto error_update_not_available
if %update%==1 if not exist mailparse.rb` goto error_update_not_available

:: Delete the original files
if %update%==1 if exist mailparse.rb del mailparse.rb /q

:: Renaming the temp files to original names
ren mailparse.rb` mailparse.rb

:: Patch.bat cannot be overwritten while running so i'm creating a small script
echo echo off >>temp.bat
echo ping localhost -n 2^>NUL >>temp.bat
echo del patch.bat /q >>temp.bat
echo ren patch.bat` patch.bat >>temp.bat
echo start patch.bat >>temp.bat
echo exit >>temp.bat
:: Running the script and exiting patch.bat
start temp.bat
exit	
exit
exit
:whatsnew
cls
if not exist "%TempStorage%\whatsnew.txt" goto whatsnew_notexist
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------              
echo.
echo What's new in update %updateversion%?
echo.
type "%TempStorage%\whatsnew.txt"
pause>NUL
goto update_notice
:whatsnew_notexist
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo -----------------------------------------------------------------------------------------------------------------------------              
echo.
echo Error. What's new file is not available.
echo.
echo Press any button to go back.
pause>NUL
goto update_notice

:main_fade_out
cls

echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+                
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN                 
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:                 
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.                 
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN                  
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd                  
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy                  
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.                 
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.                 
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`                 
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy                  
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
echo. 
ping localhost -n 3 >NUL
goto 1
:1
if %rubyavailable%==1 set rubyavailablemessage=Yes
if %rubyavailable%==0 set rubyavailablemessage=No
if %rubyversion%==INCORECT set rubyversionmessage=No (Doesn't matter)
if %rubyversion%==OK set rubyversionmessage=Yes
if %bindata%==0 set bindatamessage=No
if %bindata%==1 set bindatamessage=Yes
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo This patcher is for patching nwc24msg.cfg file in order to make RiiConnect24 Mail work on your Wii!
echo.
echo This won't work on Wii U, but we're working on it!
echo.
echo This computer status:
echo Is ruby installed on your computer?: %rubyavailablemessage%
echo Is the ruby version correct?: %rubyversionmessage%
echo Is bindata installed along with ruby?: %bindatamessage%
echo.
echo If you see "No" answer, we will fix that in a moment.
echo.
echo 1. Continue
if %uninstalruby%==1 echo 2. [X] Uninstall Ruby after successful patching.
if %uninstalruby%==0 echo 2. [ ] Uninstall Ruby after successful patching.
set /p s=Type the number and hit ENTER: 
if %s%==1 goto 2_redirect
if %s%==2 goto 1_switch
goto 1
:1_switch
if %uninstalruby%==1 goto set_uninstalruby_0
if %uninstalruby%==0 goto set_uninstalruby_1
goto 1
:set_uninstalruby_0
set /a uninstalruby=0
goto 1
:set_uninstalruby_1
set /a uninstalruby=1
goto 1

:2_redirect
if %rubyavailable%==0 goto 2_download_ruby
if %rubyavailable%==1 if %bindata%==0 goto bindata_download
goto 2_patch_script

:bindata_download
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo Please wait... we are now downloading and installing a missing library.
echo Patching should start after the installation.
call gem install bindata
set actionerrordeb=Installing gem
if not %errorlevel%==0 goto error_download
echo.
if exist "%TempStorage%\bindata.txt" del "%TempStorage%\bindata.txt" /q
call gem list >>"%TempStorage%\bindata.txt"
if exist "%TempStorage%\bindata.txt" findstr /c:"bindata" "%TempStorage%\bindata.txt"
if %errorlevel%==0 set bindata=1
goto 2_redirect
:2_download_ruby
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo Now, we will fix the problem with ruby version.
echo We need ruby in order to run the patching script.
echo.
echo We will now download the Ruby installer and we will install it in background so you can sit and relax ;)
echo.
echo Press any button. (The downloaded file will be 8.6MB)
pause>NUL
goto 2_downloading_ruby
:error_download
cls
mode %mode%
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   ERROR.              
echo   /     \  There was an error while: %actionerrordeb%
echo  /   !   \ 
echo  --------- Error code: %temperrorlev%
echo.
echo.
echo       Press any key to return to main menu.
echo ---------------------------------------------------------------------------------------------------------------------------
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
pause>NUL
goto begin_main
:2_downloading_ruby
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo Downloading and installing ruby.
echo Please wait... it might take a while
echo.
echo 1/4 Checking your CPU architecture...
echo Done!: %processor_architecture%
echo.
echo 2/4 Downloading ruby installer!...
if exist "%TempStorage%\rubyinstaller-2.5.0-1-x86.exe" del /q "%TempStorage%\rubyinstaller-2.5.0-1-x86.exe"
if exist "%TempStorage%\rubyinstaller-2.5.0-1-x64.exe" del /q "%TempStorage%\rubyinstaller-2.5.0-1-x64.exe"
if %processor_architecture%==x86 powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/rubyinstaller-2.5.0-1-x86.exe"', '%TempStorage%\rubyinstaller-2.5.0-1-x86.exe"')"
if %processor_architecture%==AMD64 powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/rubyinstaller-2.5.0-1-x64.exe"', '%TempStorage%\rubyinstaller-2.5.0-1-x64.exe"')" 
set actionerrordeb=Downloading Ruby
if not %errorlevel%==0 goto error_download
echo Done!
echo.
echo 3/4 Installing Ruby in background. This can take a moment or two.
if not exist "%appdata%\Ruby25" md "%appdata%\Ruby25"
if %processor_architecture%==x86 call "%TempStorage%\rubyinstaller-2.5.0-1-x86.exe" /verysilent /dir="%appdata%\Ruby25" /tasks="assocfiles,modpath"
if %processor_architecture%==AMD64 call "%TempStorage%\rubyinstaller-2.5.0-1-x64.exe" /verysilent /dir="%appdata%\Ruby25" /tasks="assocfiles,modpath"
set actionerrordeb=Installing Ruby.
if not %errorlevel%==0 goto error_download
echo Refreshing PATH from registry...
for /f "tokens=3*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set syspath=%%A%%B
for /f "tokens=3*" %%A in ('reg query "HKCU\Environment" /v Path') do set userpath=%%A%%B
set PATH=%userpath%;%syspath%
echo 4/4 Installing gem.
call gem install bindata
set actionerrordeb=Installing gem
if not %errorlevel%==0 goto error_download
echo.
echo Done! Patching will start in 5 seconds.
timeout 5 /nobreak >NUL
goto 2_patch_script

pause
goto after_install_restart
:after_install_restart
cls
echo .>>"%MainFolder%\requirerestart.txt"
exit
:2_patch_script
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo In order to patch Mail configuration file, I need that file.
echo So, if you can please copy the nwc24msg.cfg file to this directory where I am.
echo.
if %rep%==1 if exist "nwc24msg.cfg" set /a cor=1
if %rep%==1 if exist "nwc24msg.cfg" goto 3
if %rep%==1 echo Waiting for nwc24msg.cfg file.
if %rep%==2 echo Waiting for nwc24msg.cfg file..
if %rep%==3 echo Waiting for nwc24msg.cfg file...
if %rep%==4 echo Waiting for nwc24msg.cfg file....
if %rep%==4 set /a rep=0
set /a rep=%rep%+1
ping localhost -n 3 >NUL
goto 2_patch_script
:error_patching
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
mode %mode%
cls
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   ERROR.              
echo   /     \  There was an error while patching.
echo  /   !   \ 
echo  --------- Operation: %module%             
echo            Error code: %temperrorlev%
if %customerror%==1 echo We detected an error during a routine check before patching. Please restart the patcher.
echo.
echo       Press any key to return to main menu.
echo ---------------------------------------------------------------------------------------------------------------------------
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
pause>NUL
goto begin_main
:3
set /a error_routine_check=0

set /a bindata=0
set /a rubyavailable=0
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo We are now making a routine check to avoid errors...
::
call ruby -v && set /a rubyavailable=1
::
if exist "%TempStorage%\rubyversion.txt" del "%TempStorage%\rubyversion.txt" /q
call ruby -v >>"%TempStorage%\rubyversion.txt"

if exist "%TempStorage%\rubyversion.txt" findstr /c:"ruby 2.5.0p0" "%TempStorage%\rubyversion.txt"
set temperrorlev=%errorlevel%
if %errorlevel%==0 set rubyversion=OK

if exist "%TempStorage%\bindata.txt" del "%TempStorage%\bindata.txt" /q
call gem list >>"%TempStorage%\bindata.txt"
if exist "%TempStorage%\bindata.txt" findstr /c:"bindata" "%TempStorage%\bindata.txt"
if %errorlevel%==0 set bindata=1

if %bindata%==0 set /a error_routine_check=1
if %rubyavailable%==0 set /a error_routine_check=1

if %error_routine_check%==1 set module=Routine failsafe check
if %error_routine_check%==1 set temperrorlev=failsafe
if %error_routine_check%==1 set /a customerror=1
if %error_routine_check%==1 goto error_patching

goto 3_patch

:3_patch
if not exist backup-configuration md backup-configuration
copy "nwc24msg.cfg" "backup-configuration\nwc24msg_%date%.cfg" /y
set /a temperrorlev=0
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo.
echo Patching nwc24msg.cfg...
set actionerrordeb=Patching
ruby mailparse.rb
set /a temperrorlev=%errorlevel%

if %temperrorlev%==0 goto end

if %temperrorlev%==2 set module=Opening file failed
if %temperrorlev%==2 goto error_patching

if %temperrorlev%==3 set module=Could not find any patterns in your nwc24msg.cfg file.
if %temperrorlev%==3 goto error_patching

if not %temperrorlev%==0 set module=Unknown patching failure.
if not %temperrorlev%==0 goto error_patching

goto end
:end
set /a exiting=10
set /a timeouterror=1
timeout 1 /nobreak >NUL && set /a timeouterror=0
if %uninstalruby%==1 goto uninstalruby
goto end1
:uninstalruby
cls
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ----------------------------------------------------------------------------------------------------------------------------- 
echo.
echo We are now uninstalling Ruby...
"%appdata%\Ruby25\unins000.exe" /verysilent
set /a uninstalruby=0 
goto end
:end1
mode %mode%
cls
echo.
echo RiiConnect24 Mail Patcher - (C) KcrPL, (C) Spotlight v%version% (Compiled on %last_build% at %at%)
echo ------------------------------------------------------------------------------------------------------------------------------ 
echo  [*] Thanks for using the Patcher! :)
echo.
echo Patching is done.
echo.
echo.
echo Exiting the patcher in...
if %exiting%==10 echo :----------: 10
if %exiting%==9 echo :--------- : 9
if %exiting%==8 echo :--------  : 8
if %exiting%==7 echo :-------   : 7
if %exiting%==6 echo :------    : 6
if %exiting%==5 echo :-----     : 5
if %exiting%==4 echo :----      : 4
if %exiting%==3 echo :---       : 3
if %exiting%==2 echo :--        : 2
if %exiting%==1 echo :-         : 1
if %exiting%==0 echo :          :
if %exiting%==0 exit
if %timeouterror%==0 timeout 1 /nobreak >NUL
if %timeouterror%==1 ping localhost -n 2 >NUL
set /a exiting=%exiting%-1
goto end1