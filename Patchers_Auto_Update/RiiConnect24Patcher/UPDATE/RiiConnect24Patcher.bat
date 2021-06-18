@echo off
setlocal enableextensions
setlocal DisableDelayedExpansion
cd /d "%~dp0"
echo 	Starting up...
echo	The program is starting...
:: ===========================================================================
:: RiiConnect24 Patcher for Windows
set version=1.3.4
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2018-2020 KcrPL, RiiConnect24 and it's (Lead) Developers
:: ===========================================================================

if exist temp.bat del /q temp.bat
::if exist update_assistant.bat del /q update_assistant.bat
set /a preboot_environment=0
:script_start
echo 	.. Setting up the variables
:: Window size (Lines, columns)
set mode=128,37
mode %mode%
set s=NUL

::Beta
set /a beta=0
::This variable controls if the current version of the patcher is in the stable or beta branch. It will change updating path.
:: 0 = stable  1 = beta

set user_name=%userprofile:~9%

set /a translation_download_error=0
set /a dolphin=0
set /a first_start_lang_load=1
set /a exitmessage=1
set /a errorcopying=0
set /a tempncpatcher=0
set /a tempiospatcher=0
set /a tempevcpatcher=0
set /a tempsdcardapps=0
set /a wiiu_return=0
set /a sdcardstatus=0
set /a troubleshoot_auto_tool_notification=0
set sdcard=NUL
set tempgotonext=begin_main
set direct_install_del_done=0
set direct_install_bulk_files_error=0
For /F "Delims=" %%A In ('ver') do set "windows_version=%%A"
set post_url=https://patcher.rc24.xyz/v1/reporting.php

set mm=0
set ss=0
set cc=0
set hh=0

:: Window Title
if %beta%==0 title RiiConnect24 Patcher v%version% Created by @KcrPL
if %beta%==1 title RiiConnect24 Patcher v%version% [BETA] Created by @KcrPL
set last_build=2020/10/25
set at=14:18
:: ### Auto Update ###	
:: 1=Enable 0=Disable
:: Update_Activate - If disabled, patcher will not even check for updates, default=1
:: offlinestorage - Only used while testing of Update function, default=0
:: FilesHostedOn - The website and path to where the files are hosted. WARNING! DON'T END WITH "/"
:: MainFolder/TempStorage - folder that is used to keep version.txt and whatsnew.txt. These two files are deleted every startup but if offlinestorage will be set 1, they won't be deleted.
set /a Update_Activate=1
set /a offlinestorage=0 
if %beta%==0 set FilesHostedOn=https://kcrpl.github.io/Patchers_Auto_Update/RiiConnect24Patcher
if %beta%==1 set FilesHostedOn=https://kcrpl.github.io/Patchers_Auto_Update/RiiConnect24Patcher_Beta


if "%1"=="-preboot" set /a preboot_environment=1

:: Other patchers repositories
set FilesHostedOn_WiiWarePatcher=https://KcrPL.github.io/Patchers_Auto_Update/WiiWare-Patcher



set FilesHostedOn_Beta=https://kcrpl.github.io/Patchers_Auto_Update/RiiConnect24Patcher_Beta
set FilesHostedOn_Stable=https://kcrpl.github.io/Patchers_Auto_Update/RiiConnect24Patcher

set MainFolder=%appdata%\RiiConnect24Patcher
set TempStorage=%appdata%\RiiConnect24Patcher\internet\temp

if exist "%TempStorage%" del /s /q "%TempStorage%">NUL
if exist "%TempStorage%\announcement" rmdir /s /q "%TempStorage%\announcement">NUL

if %beta%==0 set header=RiiConnect24 Patcher - (C) KcrPL v%version% (Compiled on %last_build% at %at%)
if %beta%==1 set header=RiiConnect24 Patcher - (C) KcrPL v%version% [BETA] (Compiled on %last_build% at %at%)

set header_for_loops=RiiConnect24 Patcher - KcrPL v%version% - Compiled on %last_build% at %at%

if not exist "%MainFolder%" md "%MainFolder%"
if not exist "%TempStorage%" md "%TempStorage%"

:: Trying to prevent running from OS that is not Windows.
if not "%os%"=="Windows_NT" goto not_windows_nt


:: Generate random identifier
if not exist "%MainFolder%\random_ident.txt" (
	call :generate_identifier
	Setlocal DisableDelayedExpansion
	)


:: Read random identifier
if exist "%MainFolder%\random_ident.txt" for /f "usebackq" %%a in ("%MainFolder%\random_ident.txt") do set random_identifier=%%a

:: Load background color from file if it exists
if exist "%MainFolder%\background_color.txt" for /f "usebackq" %%a in ("%MainFolder%\background_color.txt") do color %%a


:: Check if can use chcp 65001
set /a chcp_enable=0
if %preboot_environment%==1 set /a chcp_enable=1

::if %preboot_environment%==0 ver | findstr "6.3">NUL && set /a chcp_enable=1
if %preboot_environment%==0 ver | findstr "10.0">NUL && set /a chcp_enable=1

if %chcp_enable%==1 chcp 65001>NUL

goto script_start_languages

:generate_identifier
	set lengthnumberuser=6
    Setlocal EnableDelayedExpansion
    Set _RNDLength=%lengthnumberuser%
    Set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
    Set _Str=%_Alphanumeric%987654321
:_LenLoop
    IF NOT "%_Str:~18%"=="" SET _Str=%_Str:~9%& SET /A _Len+=9& GOTO :_LenLoop
    SET _tmp=%_Str:~9,1%
    SET /A _Len=_Len+_tmp
    Set _count=0
    SET _RndAlphaNum=
:_loop
    Set /a _count+=1
    SET _RND=%Random%
    Set /A _RND=_RND%%%_Len%
    SET _RndAlphaNum=!_RndAlphaNum!!_Alphanumeric:~%_RND%,1!
    If !_count! lss %_RNDLength% goto _loop
	echo !_RndAlphaNum!>"%MainFolder%\random_ident.txt"
	Setlocal DisableDelayedExpansion
	exit /b

:script_start_languages
setlocal disableDelayedExpansion
::Load languages
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set OSLanguage=%%a

set language=English
call :set_language_english


if "%OSLanguage%"=="1046" set language=pt-BR&call :grablanguages
if "%OSLanguage%"=="1045" set language=pl-PL& call :grablanguages
if "%OSLanguage%"=="1040" set language=it-IT& call :grablanguages
if "%OSLanguage%"=="3082" set language=es-ES& call :grablanguages
if "%OSLanguage%"=="1053" set language=sv-SE& call :grablanguages
if "%OSLanguage%"=="1031" set language=de-DE& call :grablanguages
if "%OSLanguage%"=="1038" set language=hu-HU& call :grablanguages
if "%OSLanguage%"=="1036" set language=fr-FR& call :grablanguages
if "%chcp_enable%"=="1" if "%OSLanguage%"=="1049" set language=ru-RU& call :set_language_russian

goto script_start_languages_2

:script_start_languages_2
echo.
echo .. Checking for SD Card
echo   :--------------------------------------------------------------------------------:
echo   : Can you see an error box? Press `Continue`.                                    :
echo   : There's nothing to worry about, everything is going ok. This error is normal.  :
echo   :--------------------------------------------------------------------------------:
echo.
echo Checking now...
call :detect_sd_card

goto begin_main

:set_language_french_alternative

echo .. Loading language: French...

exit /b

:not_windows_nt
cls
echo.
echo Hi,
echo Please don't run RiiConnect24 Patcher in MS-DOS
echo.
echo Press any button or CTRL+C to quit.
pause
exit
goto not_windows_nt
:begin_main
cls
mode %mode%
echo %header%
echo              `..````
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+    %string1%
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.  1. %string2%
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN   2. %string3%
if not exist "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd   3. %string4%
if exist "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy   3. %string4% (%string5%)
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy   4. Troubleshooting
if exist "%appdata%\VFF-Downloader-for-Dolphin\VFF-Downloader-for-Dolphin.exe" echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+   5. %string6%
if not exist "%appdata%\VFF-Downloader-for-Dolphin\VFF-Downloader-for-Dolphin.exe" echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+   	
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+   C. Change language
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM;
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.  %string7%  
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN   %string8%
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd   
if not %sdcard%==NUL echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd   %string9% %sdcard%:\
if %sdcard%==NUL echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy     %string10%
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.    R. %string11% ^| %string12%
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`
if %beta%==0 echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy
if %beta%==0 echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys
if %beta%==0 echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-
if %beta%==0 echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm
if %beta%==0 echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+
if %beta%==0 echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm
if %beta%==0 echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+
if %beta%==0 echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm
if %beta%==0 echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/
if %beta%==0 echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy
if %beta%==0 echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`
if %beta%==0 echo                   `.              yddyo++:    `-/oymNNNNNdy+:`
if %beta%==0 echo                                   -odhhhhyddmmmmmNNmhs/:`
if %beta%==0 echo                                     :syhdyyyyso+/-`
if %beta%==1 echo ----------------------------------------------------------------------------------------------------:
if %beta%==1 echo            .sho.          
if %beta%==1 echo         .oy: :ys.          %string13%^!
if %beta%==1 echo       -sy-     -ss-      
if %beta%==1 echo    `:ss-   ...   -ss-`   
if %beta%==1 echo  `:ss-`   .ysy     -ss:`   %string14%
if %beta%==1 echo /yo.      .ysy       .oy:  %string15%
if %beta%==1 echo :yo.      .hhh       .oy:  %string16%
if %beta%==1 echo  `:ss-             -sy:` 
if %beta%==1 echo     -ss-  `\./   -ss-`     
if %beta%==1 echo       -ss-     -ss-        %string17%
if %beta%==1 echo         -sy: :ys-          %string18%
if %beta%==1 echo           .oho.            
if %beta%==1 echo.
set /p s=%string19%: 
if %s%==1 goto begin_main1
if %s%==2 goto credits
if %s%==3 goto settings_menu
if %s%==4 goto troubleshooting_menu
if %s%==5 if exist "%appdata%\VFF-Downloader-for-Dolphin\VFF-Downloader-for-Dolphin.exe" start "" "%appdata%\VFF-Downloader-for-Dolphin\VFF-Downloader-for-Dolphin.exe" -run_once
if %s%==r goto begin_main_refresh_sdcard
if %s%==R goto begin_main_refresh_sdcard
if %s%==c goto change_language
if %s%==C goto change_language
if %s%==restart goto script_start
if %s%==exit exit
goto begin_main
:change_language
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Please select your language.
echo.
echo 1. English
echo 2. French
echo 3. German
echo 4. Hungarian
echo 5. Italian
echo 6. Polish
echo 7. Portuguese (Brazilian)
echo 8. Russian
echo 9. Spanish
echo 10. Swedish
echo.
set /p s=Choose: 
if %s%==1 set language=English&call :set_language_english& goto begin_main
if %s%==2 set language=fr-FR&call :set_language_french& goto begin_main
if %s%==3 set language=de-DE&call :set_language_german& goto begin_main
if %s%==4 set language=hu-HU&call :set_language_hungarian& goto begin_main
if %s%==5 set language=it-IT&call :set_language_italian& goto begin_main
if %s%==6 set language=pl-PL&call :set_language_polish& goto begin_main
if %s%==7 set language=pt-BR&call :set_language_brazilian& goto begin_main
if %s%==8 (
			if %chcp_enable%==0 goto language_unavailable
			set language=ru-RU
			call :set_language_russian
			goto begin_main
			)
if %s%==9 set language=es-ES&call :set_language_spanish& goto begin_main
if %s%==10 set language=sv-SE&call :set_language_swedish& goto begin_main
goto change_language

:language_unavailable
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Outdated operating system. ^| Feature unavailable.
echo.
echo The language that you want to load only works on Windows 10.
echo Please select English or any other language.
echo.
echo Press any key to go back.
pause>NUL
goto change_language

:begin_main_refresh_sdcard
set sdcard=NUL
set tempgotonext=begin_main
goto detect_sd_card

:troubleshooting_menu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- %string20% ---
echo %string21%
echo.
echo 1. %string22%
echo 2. %string23%
echo 3. %string24%
echo.
echo R. %string25%
echo.
echo.
set /p s=%string26%: 
if %s%==r goto begin_main
if %s%==R goto begin_main

if %s%==1 goto troubleshooting_2
if %s%==2 goto troubleshooting_3
if %s%==3 goto troubleshooting_4
if %s%==5 goto troubleshooting_5
goto troubleshooting_menu
:troubleshooting_5
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Fixing - Renaming files error
echo.
echo [...] Flushing files
rmdir /s /q 0001000148415045v512 >NUL
rmdir /s /q 0001000148415050v512 >NUL
rmdir /s /q 0001000148414A45v512 >NUL
rmdir /s /q 0001000148414A50v512 >NUL
rmdir /s /q 0001000148415450v1792 >NUL
rmdir /s /q 0001000148415445v1792 >NUL
rmdir /s /q IOSPatcher >NUL
rmdir /s /q EVCPatcher >NUL
rmdir /s /q NCPatcher >NUL
rmdir /s /q CMOCPatcher >NUL
del /q 00000001.app >NUL
del /q 00000001_NC.app >NUL
echo [OK] Flushing files

goto troubleshooting_5_2
:troubleshooting_5_2
if "%tempgotonext%"=="2_2" goto 2_2
echo.
echo --- Testing completed ---
pause
goto troubleshooting_menu


:troubleshooting_4
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Testing - Downloading files.
echo.

echo [...] Testing PowerShell
powershell -c "[console]::beep(200,1)" 
set /a temperrorlev=%errorlevel%

if %temperrorlev%==0 echo [OK] Executing PowerShell commmand.
if not %temperrorlev%==0 echo [Error] Testing failure. Please use the "Could not start PowerShell / Error while checking for updates" option.
if not %temperrorlev%==0 goto troubleshooting_4_3

:troubleshooting_4_2
echo.
call curl -f -L -s -S --insecure "%FilesHostedOn%/version.txt" --output "%TempStorage%\version.txt"
set /a temperrorlev=%errorlevel%

if %temperrorlev%==0 if %beta%==1 echo [OK] Connection to the server on branch [BETA]
if %temperrorlev%==0 if %beta%==0 echo [OK] Connection to the server on branch [STABLE]

if not %temperrorlev%==0 echo [Error] Connection to the server. Couldn't connect to the update server. Maybe it's down.
if not %temperrorlev%==0 goto troubleshooting_4_3

:troubleshooting_4_3
echo.
echo --- Testing completed ---
pause
goto troubleshooting_menu

:troubleshooting_3
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Testing - Checking SD Card.
echo.
echo [...] Running scanning script.
set tempgotonext=troubleshooting_3_2
goto detect_sd_card
:troubleshooting_3_2
if %sdcard%==NUL echo [Error] Could not find SD Card. Please make sure that it's connected. If it is connected, make a folder called apps on it and try again.
if %sdcard%==NUL goto troubleshooting_3_3

if not %sdcard%==NUL echo [OK] SD Card found: drive letter [%sdcard%:\]. Drive opened for read/write access.
echo.
echo [...] Saving random text file to the SD Card.
echo.
echo %random% >>"%temp%\deleteME.txt"

copy "%temp%\deleteME.txt" "%sdcard%:\" >NUL
set temperrorlev=%errorlevel%
if %temperrorlev%==0 echo [OK] File saved^^!
if not %temperrorlev%==0 echo [Error] The file couldn't be saved. Looks like the drive is write protected. Unlock it and try again
if not %temperrorlev%==0 goto troubleshooting_3_3

if %temperrorlev%==0 del /q %sdcard%:\deleteME.txt
if %temperrorlev%==0 del /q "%temp%\deleteME.txt"
set /a temperrorlev=%errorlevel%

if %temperrorlev%==0 echo [OK] File deleted^^!
if not %temperrorlev%==0 echo [Error] Deleting file.
if not %temperrorlev%==0 goto troubleshooting_3_3

echo Everything is ok^^! Drive is enabled for read/write access.
goto troubleshooting_3_3
:troubleshooting_3_3
echo.
echo --- Testing completed ---
pause
goto troubleshooting_menu

:troubleshooting_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Testing - Checking SD Card.
echo.
echo [...] Running scanning script.
set tempgotonext=troubleshooting_2_2
goto detect_sd_card
:troubleshooting_2_2
echo.
if %sdcard%==NUL echo [Error] Could not find SD Card. Please make sure that it's connected. If it is connected, make a folder called apps on it and try again.
if not %sdcard%==NUL echo [OK] SD Card found: drive letter [%sdcard%:\]. Drive opened for read access only.
goto troubleshooting_2_3

:troubleshooting_2_3
echo.
echo --- Testing completed ---
pause
goto troubleshooting_menu


:troubleshooting_1
set /a repeat_1=0
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Testing - PowerShell
:troubleshooting_1_1
powershell -c "[console]::beep(200,1)" 
set /a temperrorlev=%errorlevel%
if %repeat_1%==1 if %temperrorlev%==0 echo [OK] Executing PowerShell commmand.
if %repeat_1%==1 if %temperrorlev%==0 goto troublehooting_1_4
if %repeat_1%==1 if not %temperrorlev%==0 echo [Error] Testing failure.
if %repeat_1%==1 if not %temperrorlev%==0 goto troubleshooting_1_4

if %temperrorlev%==0 echo [OK] - Testing PowerShell command&goto troubleshooting_1_3
if not %temperrorlev%==0 echo [Error] - Testing Powershell command&goto troubleshooting_1_2

goto troubleshooting_1_3

:troubleshooting_1_2
taskkill /im powershell.exe /f /t>>NUL
echo [OK] - Taskkilled PowerShell [at least tried to]
set /a repeat_1=1
goto troubleshooting_1_1

:troubleshooting_1_3
powershell -c "[console]::beep(500,1)" || echo [Error] - Executing PowerShell command&goto troubleshooting_1_4
echo [OK] - Executing PowerShell command
goto troubleshooting_1_4

:troubleshooting_1_4
echo.
echo --- Testing completed ---
pause
goto troubleshooting_menu
:settings_menu
set /a vff_settings=0
if exist "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" set /a vff_settings=1
if exist "%appdata%\VFF-Downloader-for-Dolphin\VFF-Downloader-for-Dolphin.exe" set /a vff_settings=1
::
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string27%.
echo.
echo 1. %string28%
echo 2. %string29%
if %Update_Activate%==1 echo 3. %string30%. [%string31%:  ON]
if %Update_Activate%==0 echo 3. %string30%. [%string31%: OFF]
if %preboot_environment%==0 if %beta%==0 echo 4. %string32% %string33% [%string31%: %string34%]
if %preboot_environment%==0 if %beta%==1 echo 4. %string32% %string34%. [%string31%: %string33%]
if %preboot_environment%==0 echo 5. %string35% (%string36%)
echo 6. %string504% %string505% %random_identifier%
if "%vff_settings%"=="1" echo -----------------------------------------------------------------------------------------------------------------------------
echo.
if "%vff_settings%"=="1" echo %string37%. 
if "%vff_settings%"=="1" echo.
if "%vff_settings%"=="1" echo 7. %string38%.
if "%vff_settings%"=="1" echo 8. %string39%.
if "%vff_settings%"=="1" echo 9. %string40%
if %vff_settings%==1 echo.
set /p s=Choose:
if %s%==1 goto begin_main
if %s%==2 goto change_color
if %s%==3 goto change_updating
if %preboot_environment%==0 if %s%==4 goto change_updating_branch
if %preboot_environment%==0 if %s%==5 goto update_files
if %s%==6 (
	call :generate_identifier 
	for /f "usebackq" %%a in ("%MainFolder%\random_ident.txt") do set random_identifier=%%a
	)
if %s%==7 if %vff_settings%==1 goto settings_del_config_VFF
if %s%==8 if %vff_settings%==1 goto settings_del_vff_downloader
if %s%==9 if %vff_settings%==1 goto settings_taskkill_vff


goto settings_menu
:settings_del_config_VFF
::Stop the downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f
::Delete it's direcory
rmdir /s /q "%appdata%\VFF-Downloader-for-Dolphin"
::And delete it out of the autostart dir
del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
del /q "%appdata%\VFF-Downloader-for-Dolphin\VFF-Downloader-for-Dolphin.exe"
echo Done^^!
pause
goto settings_menu

:settings_del_vff_downloader
::Stop the downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f
::And delete it out of the autostart dir
del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"

echo Done^^!
pause
goto settings_menu

:settings_taskkill_vff
::Stop the downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f

echo Done^^!
pause
goto settings_menu


:change_updating_branch
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string41%
echo.
if %beta%==1 goto change_updating_branch_stable
if %beta%==0 goto change_updating_branch_beta
goto settings_menu
:change_updating_branch_stable
set /a stable_available_check=1

	if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
	call curl -f -L -s -S --insecure "%FilesHostedOn_Stable%/UPDATE/version.txt" --output "%TempStorage%\version.txt"
	echo 1
	set /a temperrorlev=%errorlevel%
		if not %temperrorlev%==0 set /a stable_available_check=0&goto switch_to_stable
	if exist "%TempStorage%\version.txt" set /p updateversion_stable=<"%TempStorage%\version.txt"
	goto switch_to_stable	

:change_updating_branch_beta
set /a beta_available_check=0
	
	if exist "%TempStorage%\beta_available.txt" del "%TempStorage%\beta_available.txt" /q
	call curl -f -L -s -S --insecure "%FilesHostedOn_Beta%/UPDATE/beta_available.txt" --output "%TempStorage%\beta_available.txt"
		set /a temperrorlev=%errorlevel%
		if not %temperrorlev%==0 set /a beta_available_check=2&goto switch_to_beta
	if exist "%TempStorage%\beta_available.txt" set /p beta_available=<"%TempStorage%\beta_available.txt"
	
	if %beta_available%==0 set /a beta_available_check=0
	if %beta_available%==1 set /a beta_available_check=1
	
	if %beta_available_check%==0 goto switch_to_beta
	
	if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
	call curl -f -L -s -S --insecure "%FilesHostedOn_Beta%/UPDATE/version.txt" --output "%TempStorage%\version.txt"
		set /a temperrorlev=%errorlevel%
		if not %temperrorlev%==0 set /a beta_available_check=2&goto switch_to_beta
	if exist "%TempStorage%\version.txt" set /p updateversion_beta=<"%TempStorage%\version.txt"

	goto switch_to_beta
:switch_to_stable
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string42%
echo.
echo %string43%: %version% [%string33%]
if %stable_available_check%==1 echo %string44%: %updateversion_stable%
if %stable_available_check%==0 echo %string44%: %string45%
echo.
echo %string46% (%string47%)
echo.
if %stable_available_check%==1 echo 1. %string48%
if not %stable_available_check%==1 echo 1. %string49%
echo 2. %string50%
set /p s=%string26%: 
if %s%==1 (
	if %stable_available_check%==0 goto switch_to_stable
	curl -f -L -s -S --insecure "%FilesHostedOn_Stable%/UPDATE/update_assistant.bat" --output "update_assistant.bat"
	start update_assistant.bat -RC24_Patcher
	exit
)
if %s%==2 goto begin_main
goto switch_to_stable
:switch_to_beta
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string51%
echo.
echo %string43%: %version%
if %beta_available_check%==0 echo %string52%: %string53%
if %beta_available_check%==1 echo %string52%: %updateversion_beta% [BETA]
if %beta_available_check%==2 echo %string52%: %string45%
echo.
echo %string46% (%string47%)
echo.
if %beta_available_check%==1 echo 1. %string54%
if not %beta_available_check%==1 echo 1. %string55%
echo 2. %string50%
set /p s=%string26%: 
if %s%==1 (
	if not %beta_available_check%==1 goto switch_to_beta

	curl -f -L -s -S --insecure "%FilesHostedOn_Stable%/UPDATE/update_assistant.bat" --output "update_assistant.bat"
	start update_assistant.bat -RC24_Patcher -beta
	exit
	)
if %s%==2 goto begin_main
goto switch_to_beta
:change_updating
if %Update_Activate%==1 goto change_updating_warning_off
set /a Update_Activate=1
goto settings_menu
:change_updating_warning_off
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string56%^! %string57% 
echo %string58%
echo.
echo %string59%
echo.
echo %string60%
echo 1. %string61%
echo 2. %string62%
set /p s=
if %s%==1 set Update_Activate=0
if %s%==1 goto settings_menu
if %s%==2 goto settings_menu
goto change_updating_warning_off

:change_color
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string63%
echo.
echo 1. %string64%
echo 2. %string65%
echo 3. %string66%
echo 4. %string67%
echo 5. %string68%
echo 6. %string69%
echo 7. %string70%
echo.
echo E. %string28%
set /p s=%string26%: 
if %s%==1 set tempcolor=07&goto save_color
if %s%==2 set tempcolor=70&goto save_color
if %s%==3 set tempcolor=f0&goto save_color
if %s%==4 set tempcolor=6&goto save_color
if %s%==5 set tempcolor=a&goto save_color
if %s%==6 set tempcolor=c&goto save_color
if %s%==7 set tempcolor=3&goto save_color
if %s%==e goto begin_main
if %s%==E goto begin_main

goto change_color
:save_color
if exist "%MainFolder%\background_color.txt" del /q "%MainFolder%\background_color.txt"
color %tempcolor%
echo>>"%MainFolder%\background_color.txt" %tempcolor%
goto change_color

:credits
cls
echo %header%
echo              `..````
echo ---------------------------------------------------------------------------------------------------------------------------
echo RiiConnect24 Patcher for RiiConnect24 v%version% 
echo 	Created by:
echo - KcrPL
echo   Windows Patcher, WiiWare Patcher, UI, scripts.
echo.
echo - Larsenv
echo   UNIX Patcher, help with scripts, original IOS Patcher script. Overall help with scripts and commands syntax.
echo.
echo - Apfel
echo   Help with Everybody Votes Channel patching and Sharpii syntax.
echo.
echo - Brawl345
echo   Help with resolving ticket issues.
echo.
echo - unowe
echo   Wii U patching help, providing instructions and all the files.
echo.
echo - DarkMatterCore
echo   wad2bin
echo.
echo - Wiimm, Leseratte
echo   Wiimmfi, Wiimmfi Patcher.
echo.
echo  For the entire RiiConnect24 Community.
echo  Want to contact us? Mail us at support@riiconnect24.net
echo.
echo  Press any button to go back to main menu.
echo ---------------------------------------------------------------------------------------------------------------------------
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`
echo                                   -odhhhhyddmmmmmNNmhs/:`
echo                                     :syhdyyyyso+/-`
pause>NUL
goto begin_main
:begin_main_download_curl
cls
echo %header%
echo.
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`    %string71%
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd    %string72%
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs   :-------------------------:
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+   
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:   File 1 [3.5MB] out of 1
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.   0%% [          ]
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
call powershell -command (new-object System.Net.WebClient).DownloadFile('%FilesHostedOn%/curl.exe', 'curl.exe')
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto begin_main_download_curl_error

goto begin_main1
:begin_main_download_curl_error
cls
echo %header%                                                                
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
echo    /---\   %string73%              
echo   /     \  %string74%
echo  /   ^!   \ 
echo  --------- %string75%
echo            %string76%
echo.
echo       %string77%
echo ---------------------------------------------------------------------------------------------------------------------------
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
start %FilesHostedOn%/curl.exe
goto begin_main

:begin_main1
setlocal DisableDelayedExpansion
:: For whatever reason, it returns 2
curl
if not %errorlevel%==2 goto begin_main_download_curl

cls
echo %header%
echo.
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`    %string78%
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

:: Update script.
set updateversion=0.0.0
:: Delete version.txt and whatsnew.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q

if not exist "%TempStorage%" md "%TempStorage%"
:: Commands to download files from server.

if %Update_Activate%==1 if %preboot_environment%==0 if %offlinestorage%==0 call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/whatsnew.txt" --output "%TempStorage%\whatsnew.txt"
if %Update_Activate%==1 if %preboot_environment%==0 if %offlinestorage%==0 call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/version.txt" --output "%TempStorage%\version.txt"
	set /a temperrorlev=%errorlevel%

if %Update_Activate%==1 if %offlinestorage%==0 if %chcp_enable%==1 call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/Translation_Files/Language_%language%.bat" --output "%TempStorage%\Language_%language%.bat"
if %Update_Activate%==1 if %offlinestorage%==0 if %chcp_enable%==0 call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/Translation_Files_CHCP_OFF/Language_%language%.bat" --output "%TempStorage%\Language_%language%.bat"
if not %errorlevel%==0 set /a translation_download_error=1

if %chcp_enable%==1 if exist "%TempStorage%\Language_%language%.bat" call "%TempStorage%\Language_%language%.bat" -chcp
if %chcp_enable%==0 if exist "%TempStorage%\Language_%language%.bat" call "%TempStorage%\Language_%language%.bat"

set /a updateserver=1
	::Bind exit codes to errors here
	if "%temperrorlev%"=="6" goto no_internet_connection
	if not %temperrorlev%==0 set /a updateserver=0

if exist "%TempStorage%\version.txt`" ren "%TempStorage%\version.txt`" "version.txt"
if exist "%TempStorage%\whatsnew.txt`" ren "%TempStorage%\whatsnew.txt`" "whatsnew.txt"
:: Copy the content of version.txt to variable.
if exist "%TempStorage%\version.txt" set /p updateversion=<"%TempStorage%\version.txt"
if not exist "%TempStorage%\version.txt" set /a updateavailable=0
if %Update_Activate%==1 if exist "%TempStorage%\version.txt" set /a updateavailable=1
:: If version.txt doesn't match the version variable stored in this batch file, it means that update is available.
if %updateversion%==%version% set /a updateavailable=0

if exist "%TempStorage%\annoucement.txt" del /q "%TempStorage%\annoucement.txt"
curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/annoucement.txt" --output %TempStorage%\annoucement.txt"

if %Update_Activate%==1 if %updateavailable%==1 set /a updateserver=2
if %Update_Activate%==1 if %updateavailable%==1 goto update_notice

goto select_device
:update_notice
if exist "%MainFolder%\failsafe.txt" del /q "%MainFolder%\failsafe.txt"
if %updateversion%==0.0.0 goto error_update_not_available
set /a update=1
cls
echo %header%
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
echo    /---\   %string79%              
echo   /     \  %string80%
echo  /   ^!   \ 
echo  ---------  %string81%: %version%
echo             %string82%: %updateversion%
echo                       1. %string83%                      2. %string84%               3. %string85%
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
if %s%==2 goto select_device
if %s%==3 goto whatsnew
goto update_notice
:update_files
cls
echo %header%
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
echo    /---\   %string86%
echo   /     \  %string87%
echo  /   ^!   \ 
echo  --------- %string88% 
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
:update_1
curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/update_assistant.bat" --output "update_assistant.bat"
	set temperrorlev=%errorlevel%
	if not %temperrorlev%==0 goto error_updating
if %beta%==0 start update_assistant.bat -RC24_Patcher
if %beta%==1 start update_assistant.bat -RC24_Patcher -beta
exit
:error_updating
cls
echo %header%
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
echo    /---\   %string73%
echo   /     \  %string89%
echo  /   ^!   \ 
echo  --------- %sting90%
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
pause>NUL
goto begin_main
:whatsnew
cls
if not exist %TempStorage%\whatsnew.txt goto whatsnew_notexist
echo %header%
echo ------------------------------------------------------------------------------------------------------------------------------
echo.
echo %string91% %updateversion%?
echo.
type "%TempStorage%\whatsnew.txt"
pause>NUL
goto update_notice
:whatsnew_notexist
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string92%
echo.
echo %string93%
pause>NUL
goto update_notice

:open_shop_sdcarddetect
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string100%
echo %string101%
echo.
echo 1. %string102%
echo 2. %string103%
echo.
set /p s=%string26%: 
if %s%==1 set /a sdcardstatus=1& set tempgotonext=open_shop_summarysdcard& goto detect_sd_card
if %s%==2 set /a sdcardstatus=0& goto open_shop_getexecutable
goto open_shop_sdcarddetect
:open_shop_summarysdcard
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
if %sdcardstatus%==1 if %sdcard%==NUL echo %string104%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string105%
if %sdcardstatus%==1 if %sdcard%==NUL echo.
if %sdcardstatus%==1 if %sdcard%==NUL echo %string106%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string107% %sdcard%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string108%	
echo.
echo %string109%
if %sdcardstatus%==1 if %sdcard%==NUL echo 1. %string110% 2. %string111% 3. %string112%
if %sdcardstatus%==1 if not %sdcard%==NUL echo 1. %string110% 2. %string111% 3. %string112%
echo.
set /p s=Choose: 
if %s%==1 goto open_shop_getexecutable
if %s%==2 goto begin_main
if %s%==3 goto open_shop_change_drive_letter
goto open_shop_summarysdcard
:open_shop_change_drive_letter
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo [*] %string488%
echo.
echo %string113%: %sdcard%
echo.
echo %string114%
set /p sdcard=
goto open_shop_summarysdcard
:open_shop_getexecutable
cls
if exist osc-dl.exe del /q osc-dl.exe
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string115%
echo %string116%
echo.	
curl -f -L -s -S --insecure "%FilesHostedOn%/osc-dl.exe" --output "osc-dl.exe"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto open_shop_getexecutable_fail
goto open_shop_mainmenu
:open_shop_getexecutable_fail
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string117%
echo %string118%: %temperrorlev%
echo.
echo %string119%
echo.
echo %string502%

>"%MainFolder%\error_report.txt" echo RiiConnect24 Patcher v%version%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Open Shop Channel
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Date: %date%
>>"%MainFolder%\error_report.txt" echo Time: %time:~0,5%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Windows version: %windows_version%
>>"%MainFolder%\error_report.txt" echo Language: %language%
>>"%MainFolder%\error_report.txt" echo Device: %device%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Action: Downloading the executable
>>"%MainFolder%\error_report.txt" echo Module: cURL
>>"%MainFolder%\error_report.txt" echo Exit code: %temperrorlev%

curl -F "report=@%MainFolder%\error_report.txt" %post_url%?user=%random_identifier%>NUL

echo %string503%



pause>NUL
goto begin_main
:open_shop_mainmenu
setlocal disableDelayedExpansion
cls
set /a homebrew_online_var=0
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string100%
echo %string120%
echo.
echo 1. %string121%
echo 2. %string122%
echo.
echo R. %string123%
if %preboot_environment%==1 echo 3. %string489%
echo.
set /p s=%string26%: 
if %s%==1 goto open_shop_list
if %s%==2 goto open_shop_homebrew
if %preboot_environment%==1 if %s%==3 "X:\TOTALCMD.exe"
if %s%==r goto begin_main
if %s%==R goto begin_main
goto open_shop_mainmenu
:open_shop_list
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string124%
echo %header%>"Open Shop Channel Homebrew List.txt"
echo.>>"Open Shop Channel Homebrew List.txt"
echo %string125%>>"Open Shop Channel Homebrew List.txt"
echo      %string126%>>"Open Shop Channel Homebrew List.txt"
echo.>>"Open Shop Channel Homebrew List.txt"
echo %string127%:>>"Open Shop Channel Homebrew List.txt"
echo.>>"Open Shop Channel Homebrew List.txt"
osc-dl.exe list>>"Open Shop Channel Homebrew List.txt"

start "" "Open Shop Channel Homebrew List.txt"
goto open_shop_mainmenu

:open_shop_homebrew
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string128%
echo.
if %homebrew_online_var%==1 echo :-----------------------------------------------------------------------------------------------------------------------:
if %homebrew_online_var%==1 echo  "%homebrew_name%" %string129%
if %homebrew_online_var%==1 echo  %string130%
if %homebrew_online_var%==1 echo :-----------------------------------------------------------------------------------------------------------------------:
if %homebrew_online_var%==1 echo.
set /a homebrew_online_var=0
echo R. %string213%
echo.
set /p homebrew_name=Type here: 
if %homebrew_name%==r goto open_shop_mainmenu
if %homebrew_name%==R goto open_shop_mainmenu
goto open_shop_homebrew_download

:open_shop_homebrew_download
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string131%

::Check if on server
For /F "Delims=" %%A In ('osc-dl.exe query -n "%homebrew_name%" --verify') do set "homebrew_online=%%A"
if "%homebrew_online%"=="False" set /a homebrew_online_var=1&goto open_shop_homebrew

::For /F "Delims=" %%A In ('osc-dl.exe meta -n "%homebrew_name%" -t display_name') do set "homebrew_app_name=%%A"
::For /F "Delims=" %%A In ('osc-dl.exe meta -n "%homebrew_name%" -t version') do set "homebrew_version=%%A"
::For /F "Delims=" %%A In ('osc-dl.exe meta -n "%homebrew_name%" -t coder') do set "homebrew_creator=%%A"
::For /F "Delims=" %%A In ('osc-dl.exe meta -n "%homebrew_name%" -t short_description') do set "homebrew_short_description=%%A"

goto open_shop_homebrew_show_info
:open_shop_homebrew_show_info
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo %string132%
osc-dl.exe meta -n "%homebrew_name%" -t name
echo.
echo %string133%
echo.
osc-dl.exe meta -n "%homebrew_name%" -t long_description
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string134%
echo (%string135%)
echo.
echo 1. %string61%.
echo 2. %string136%
set /p s=%string26%: 
if %s%==1 goto open_shop_homebrew_download
if %s%==2 goto open_shop_mainmenu
goto open_shop_homebrew_show_info
:open_shop_homebrew_finishnosdcard
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo %string137% %homebrew_app_name%...
echo.
echo [OK] %string138%
echo.
echo %string139%
echo %string140%
echo %string141%
pause>NUL
goto open_shop_mainmenu

:open_shop_homebrew_download
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo %string137% %homebrew_app_name%...
echo.
echo [..] %string138%
osc-dl.exe get -n "%homebrew_name%" --noconfirm --output "%homebrew_name%.zip"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 set /a reason=1&goto open_shop_homebrew_download_error
if %sdcardstatus%==0 goto open_shop_homebrew_finishnosdcard
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo Downloading %homebrew_app_name%...
echo.
echo [OK] %string138%
echo [..] %string142%
curl -f -L -s -S --insecure "%FilesHostedOn%/7z.exe" --output "7z.exe"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 set /a reason=2&goto open_shop_homebrew_download_error
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo Downloading %homebrew_app_name%...
echo.
echo [OK] %string138%
echo [OK] %string142%
echo [..] %string143%
7z x "%homebrew_name%.zip" -aoa -o%sdcard%:
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 set /a reason=3&goto open_shop_homebrew_download_error
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo Downloading %homebrew_app_name%...
echo.
echo [OK] %string138%
echo [OK] %string142%
echo [OK] %string143%
echo.
echo %string139%
echo %string141%
del /q "%homebrew_name%.zip"
pause>NUL
goto open_shop_mainmenu
:open_shop_homebrew_download_error
cls
echo %header%                                                                
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
echo    /---\   %string73%
echo   /     \  %string144%
echo  /   ^!   \ 
echo  --------- 
echo.
if %reason%==1 echo %string145%
if %reason%==2 echo %string146%
if %reason%==3 echo %string147%
echo.
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

echo %string502%
>"%MainFolder%\error_report.txt" echo RiiConnect24 Patcher v%version%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Open Shop Channel
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Date: %date%
>>"%MainFolder%\error_report.txt" echo Time: %time:~0,5%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Windows version: %windows_version%
>>"%MainFolder%\error_report.txt" echo Language: %language%
>>"%MainFolder%\error_report.txt" echo Device: %device%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Action: Downloading homebrew
>>"%MainFolder%\error_report.txt" echo Reason: %reason%
>>"%MainFolder%\error_report.txt" echo Exit code: %temperrorlev%

curl -F "report=@%MainFolder%\error_report.txt" %post_url%?user=%random_identifier%>NUL

echo %string503%


pause>NUL
goto open_shop_mainmenu
:select_device
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
if exist "%TempStorage%\annoucement.txt" echo --- %string148% --- 
if exist "%TempStorage%\annoucement.txt" type "%TempStorage%\annoucement.txt"
if exist "%TempStorage%\annoucement.txt" echo.
if exist "%TempStorage%\annoucement.txt" echo -------------------
if "%translation_download_error%"=="1" if not "%language%"=="English" echo.
if "%translation_download_error%"=="1" if not "%language%"=="English" echo :-----------------------------------------------------------------------:
if "%translation_download_error%"=="1" if not "%language%"=="English" echo : There was an error while downloading the up-to-date translation.      :
if "%translation_download_error%"=="1" if not "%language%"=="English" echo : Your language was reverted to English.                                :
if "%translation_download_error%"=="1" if not "%language%"=="English" echo :-----------------------------------------------------------------------:
if "%translation_download_error%"=="1" if not "%language%"=="English" echo.
if "%translation_download_error%"=="1" if not "%language%"=="English" set /a translation_download_error=0
echo.
echo %string149%
echo %string150%
echo %string151%
echo.
echo %string152%
echo.
echo 1. Wii
echo 2. Wii U (vWii, Wii Mode)
echo 3. %string153%
echo.
set /p s=%string154%: 
if %s%==1 set device=1&goto 1
if %s%==2 set device=1_wiiu&goto 1_wiiu
if %s%==3 set device=1_dolphin&goto 1_dolphin
goto select_device

:1_dolphin
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
if exist "%TempStorage%\annoucement.txt" echo --- %string148% --- 
if exist "%TempStorage%\annoucement.txt" type "%TempStorage%\annoucement.txt"
if exist "%TempStorage%\annoucement.txt" echo.
if exist "%TempStorage%\annoucement.txt" echo --------------------
echo.
echo %string155%?
echo 1. %string156%
echo   - %string157%
echo.
echo --- %string158% ---
echo.
echo 2. %string159%
echo   - %string160%
echo.
echo 3. %string161%
echo   - %string162%
echo.
echo 4. %string163%
echo   - %string164% 
echo.	
echo 5. %string165%
echo   - %string166%
set /p s=%string26%: 
if %s%==1 goto 2_prepare_dolphin
if %s%==2 goto wadgames_patch_info
if %s%==3 goto mariokartwii_patch
if %s%==4 goto wiigames_patch
if %s%==5 goto open_shop_sdcarddetect
goto 1_dolphin
:2_prepare_dolphin
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string167% %username%, %string168%
echo.
echo %string169%
echo.
echo %string170%
pause>NUL
goto 2_download_vff

:2_download_vff
curl -f -L -s -S --insecure "https://kcrpl.github.io/Patchers_Auto_Update/VFF-Downloader-for-Dolphin/UPDATE/Install.bat" --output "Install.bat"

call Install.bat -RC24Patcher_assisted

if exist Install.bat del /q Install.bat
goto 2_after_vff
:2_after_vff
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
setlocal disableDelayedExpansion
echo %string171%
echo.
echo %string172% 
echo - %string173% 
echo   %string174%
echo.
echo - %string175%
echo   %string176%
echo.
echo %string177%
echo 1. %string178%
echo 2. %string179%
echo 3. %string180%
set /p s=%string26%: 
if %s%==1 goto 2_install_dolphin_1
if %s%==2 goto 2_prepare_dolphin
if %s%==3 goto begin_main
goto 2_after_vff
:2_install_dolphin_1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string181%
echo.
echo %string182%
echo.
echo 1. %string183%
echo 2. %string184%
set /p evcregion=%string26%: 
if "%evcregion%"=="1" goto 2_install_dolphin_2
if "%evcregion%"=="2" goto 2_install_dolphin_2

goto 2_install_dolphin_1
:2_install_dolphin_2
set /a custominstall_ios=0
set /a custominstall_evc=1
set /a custominstall_nc=0
set /a custominstall_cmoc=1
set /a custominstall_news_fore=0
set /a sdcardstatus=0
set /a errorcopying=0
set sdcard=NUL

set /a dolphin=1
goto 2_2

:2_install_dolphin_3
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
setlocal disableDelayedExpansion
echo %string185%
echo %string186%
echo.
echo %string187%
echo %string188%
echo.
echo 1. %string189%
echo 2. %string190%
set /p s=%string26%: 
if %s%==1 goto script_start
if %s%==2 goto end
goto 2_install_dolphin_3
:1_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
if exist "%TempStorage%\annoucement.txt" echo --- %string148% --- 
if exist "%TempStorage%\annoucement.txt" type "%TempStorage%\annoucement.txt"
if exist "%TempStorage%\annoucement.txt" echo.
if exist "%TempStorage%\annoucement.txt" echo -------------------
echo.
echo %string155%?
echo 1. %string191%
echo   - %string157%
echo.
echo --- %string158% ---
echo.
echo 2. %string192%
echo   - %string193%
echo.
echo 3. %string159%
echo   - %string160%
echo.
echo 4. %string161%
echo   - %string162%
echo.
echo 5. %string163%
echo   - %string164%
echo.	
echo 6. %string165%
echo   - %string166%
set /p s=%string26%: 
if %s%==1 goto 2_prepare_wiiu
if %s%==2 goto direct_install_download_binary
if %s%==3 goto wadgames_patch_info
if %s%==4 goto mariokartwii_patch
if %s%==5 goto wiigames_patch
if %s%==6 goto open_shop_sdcarddetect
goto 1_wiiu
:2_prepare_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string200%
echo.
echo %string201%
echo 1. %string202%
echo   - %string203%
echo     - %string204%
echo     - %string205%
echo     - %string206%
echo     - %string207%
echo.
echo 2. %string208%
echo   - %string209%
set /p s=
if %s%==1 goto 2_auto_wiiu
if %s%==2 goto 2_choose_custom_instal_type_wiiu
goto 2_prepare_wiiu
:2_choose_custom_instal_type_wiiu
set /a evcregion=1
set /a custominstall_news=1
set /a custominstall_evc=1
set /a custominstall_nc=1
set /a custominstall_cmoc=1
set /a sdcardstatus=0
set /a errorcopying=0
set sdcard=NUL
goto 2_choose_custom_install_type2_wiiu
:2_choose_custom_install_type2_wiiu
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string210%
echo.
echo %string201%
echo - %string208%
echo.
if %evcregion%==1 echo 1. %string211% %string183%
if %evcregion%==2 echo 1. %string211% %string184%
echo.
if %custominstall_news%==1 echo 2. [X] %string204%
if %custominstall_news%==0 echo 2. [ ] %string204%
if %custominstall_evc%==1 echo 3. [X] %string205%
if %custominstall_evc%==0 echo 3. [ ] %string205%
if %custominstall_nc%==1 echo 4. [X] %string206%
if %custominstall_nc%==0 echo 4. [ ] %string206%
if %custominstall_cmoc%==1 echo 5. [X] %string207%
if %custominstall_cmoc%==0 echo 5. [ ] %string207%
echo.
echo 6. %string212%
echo R. %string213%
set /p s=
if %s%==1 goto 2_switch_region_wiiu
if %s%==2 goto 2_switch_news_wiiu
if %s%==3 goto 2_switch_evc_wiiu
if %s%==4 goto 2_switch_nc_wiiu
if %s%==5 goto 2_switch_cmoc_wiiu
if %s%==6 goto 2_2_wiiu
if %s%==r goto begin_main
if %s%==R goto begin_main
goto 2_choose_custom_install_type2_wiiu
:2_switch_news_wiiu
if %custominstall_news%==1 set /a custominstall_news=0&goto 2_choose_custom_install_type2_wiiu
if %custominstall_news%==0 set /a custominstall_news=1&goto 2_choose_custom_install_type2_wiiu
:2_switch_region_wiiu
if %evcregion%==1 set /a evcregion=2&goto 2_choose_custom_install_type2_wiiu
if %evcregion%==2 set /a evcregion=1&goto 2_choose_custom_install_type2_wiiu
:2_switch_evc_wiiu
if %custominstall_evc%==1 set /a custominstall_evc=0&goto 2_choose_custom_install_type2_wiiu
if %custominstall_evc%==0 set /a custominstall_evc=1&goto 2_choose_custom_install_type2_wiiu
:2_switch_nc_wiiu
if %custominstall_nc%==1 set /a custominstall_nc=0&goto 2_choose_custom_install_type2_wiiu
if %custominstall_nc%==0 set /a custominstall_nc=1&goto 2_choose_custom_install_type2_wiiu
:2_switch_cmoc_wiiu
if %custominstall_cmoc%==1 set /a custominstall_cmoc=0&goto 2_choose_custom_install_type2_wiiu
if %custominstall_cmoc%==0 set /a custominstall_cmoc=1&goto 2_choose_custom_install_type2_wiiu


:2_auto_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string214% %username%, %string215%
echo.
echo %string216%
echo %string217%
echo.
echo %string218%
echo.
echo %string219% %string204%, %string205%, %string207% %string220% %string206%, %string221% 
echo %string222%
echo.
echo 1. %string183%
echo 2. %string184%
set /p s=%string223%: 
if %s%==1 set /a evcregion=1& goto 2_1_wiiu
if %s%==2 set /a evcregion=2& goto 2_1_wiiu
goto 2_auto
:2_1_wiiu
set /a custominstall_evc=1
set /a custominstall_nc=1
set /a custominstall_cmoc=1	
set /a custominstall_news=1
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string224%
echo %string225% :)
echo.
echo %string226% 
echo %string227%
echo.
echo %string228%
echo.
echo 1. %string229%
echo 2. %string230%
set /p s=
set sdcard=NUL
if %s%==1 set /a sdcardstatus=1& set tempgotonext=2_1_summary_wiiu& goto detect_sd_card
if %s%==2 set /a sdcardstatus=0& set /a sdcard=NUL& goto 2_1_summary_wiiu
goto 2_1_wiiu
:2_1_summary_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
if %sdcardstatus%==0 echo %string231%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string232%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string233%
if %sdcardstatus%==1 if %sdcard%==NUL echo.
if %sdcardstatus%==1 if %sdcard%==NUL echo %string234%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string235% %sdcard%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string236%	
echo.
echo %string237%
echo.
echo %string238%
if %sdcardstatus%==0 echo 1. %string239%  2. %string240%
if %sdcardstatus%==1 if %sdcard%==NUL echo 1. %string239% 2. %string240% 3. %string241%
if %sdcardstatus%==1 if not %sdcard%==NUL echo 1. %string239% 2. %string240% 3. %string241%

set /p s=%string26%: 
if %s%==1 goto check_for_wad_folder
if %s%==2 goto begin_main
if %s%==3 goto 2_change_drive_letter_wiiu
goto 2_1_summary_wiiu
:check_for_wad_folder
if not exist "WAD" goto 2_2_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string242%
echo %string243%
echo.
echo %string244%
echo 1. %string245%
echo 2. %string246%
set /p s=%string26%: 
if %s%==1 rmdir /s /q "WAD"
if %s%==1 goto 2_2_wiiu
if %s%==2 goto 2_1_summary_wiiu
goto check_for_wad_folder

:2_2_wiiu
cls
set /a troubleshoot_auto_tool_notification=0
set /a temperrorlev=0
set /a counter_done=0
set /a percent=0
set /a temperrorlev=0

::
set /a progress_downloading=0
set /a progress_news=0
set /a progress_ios=0
set /a progress_evc=0
set /a progress_nc=0
set /a progress_cmoc=0
set /a progress_finishing=0
set /a wiiu_return=1

goto random_funfact

:2_3_wiiu
:: Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem Get elapsed time:
set /A elapsed=end-start


rem Show elapsed time:
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=%mm%
if %ss% lss 10 set ss=%ss%
if %cc% lss 10 set cc=%cc%


if /i %percent% GTR 0 if /i %percent% LSS 10 set /a counter_done=0
if /i %percent% GTR 10 if /i %percent% LSS 20 set /a counter_done=1
if /i %percent% GTR 20 if /i %percent% LSS 30 set /a counter_done=2
if /i %percent% GTR 30 if /i %percent% LSS 40 set /a counter_done=3
if /i %percent% GTR 40 if /i %percent% LSS 50 set /a counter_done=4
if /i %percent% GTR 50 if /i %percent% LSS 60 set /a counter_done=5
if /i %percent% GTR 60 if /i %percent% LSS 70 set /a counter_done=6
if /i %percent% GTR 70 if /i %percent% LSS 80 set /a counter_done=7
if /i %percent% GTR 80 if /i %percent% LSS 90 set /a counter_done=8
if /i %percent% GTR 90 if /i %percent% LSS 100 set /a counter_done=9
if %percent%==100 set /a counter_done=10
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo  [*] %string247%

if %troubleshoot_auto_tool_notification%==1 echo :------------------------------------------------------------------------------------------------------------------------:
if %troubleshoot_auto_tool_notification%==1 echo   %string248%
if %troubleshoot_auto_tool_notification%==1 echo   %string249%
if %troubleshoot_auto_tool_notification%==1 echo :------------------------------------------------------------------------------------------------------------------------:
echo.

set /a refreshing_in=20-"%ss%">>NUL
echo ---------------------------------------------------------------------------------------------------------------------------
echo %string250%: %funfact%
echo ---------------------------------------------------------------------------------------------------------------------------
if /i %refreshing_in% GTR 0 echo %string251%... %refreshing_in% %string252%
if /i %refreshing_in% LEQ 0 echo %string252%... 0 %string252%
echo.

echo    %string253%:
if %counter_done%==0 echo :          : %percent% %%
if %counter_done%==1 echo :-         : %percent% %%
if %counter_done%==2 echo :--        : %percent% %%
if %counter_done%==3 echo :---       : %percent% %%
if %counter_done%==4 echo :----      : %percent% %%
if %counter_done%==5 echo :-----     : %percent% %%
if %counter_done%==6 echo :------    : %percent% %%
if %counter_done%==7 echo :-------   : %percent% %%
if %counter_done%==8 echo :--------  : %percent% %%
if %counter_done%==9 echo :--------- : %percent% %%
if %counter_done%==10 echo :----------: %percent% %%
echo.
if %progress_downloading%==0 echo [ ] %string254%
if %progress_downloading%==1 echo [X] %string254%
if %custominstall_news%==1 if %progress_news%==0 echo [ ] %string204%
if %custominstall_news%==1 if %progress_news%==1 echo [X] %string204%
if %custominstall_evc%==1 if %progress_evc%==0 echo [ ] %string205%
if %custominstall_evc%==1 if %progress_evc%==1 echo [X] %string205%
if %custominstall_cmoc%==1 if %evcregion%==1 if %progress_cmoc%==0 echo [ ] %string256%
if %custominstall_cmoc%==1 if %evcregion%==1 if %progress_cmoc%==1 echo [X] %string256%
if %custominstall_cmoc%==1 if %evcregion%==2 if %progress_cmoc%==0 echo [ ] %string257%
if %custominstall_cmoc%==1 if %evcregion%==2 if %progress_cmoc%==1 echo [X] %string257%
if %custominstall_nc%==1 if %progress_nc%==0 echo [ ] %string206%
if %custominstall_nc%==1 if %progress_nc%==1 echo [X] %string206%
if %progress_finishing%==0 echo [ ] %string258%
if %progress_finishing%==1 echo [X] %string258%

call :wiiu_patching_fast_travel_%percent%
goto wiiu_patching_fast_travel_100



::Download files
:wiiu_patching_fast_travel_1
if exist NewsChannelPatcher rmdir /s /q NewsChannelPatcher
if exist unpacked-temp rmdir /s /q unpacked-temp
if exist 0001000148415045v512 rmdir /s /q 0001000148415045v512
if exist 0001000148415050v512 rmdir /s /q 0001000148415050v512
if exist 0001000148414A45v512 rmdir /s /q 0001000148414A45v512
if exist 0001000148414A50v512 rmdir /s /q 0001000148414A50v512
if exist 0001000148415450v1792 rmdir /s /q 0001000148415450v1792
if exist 0001000148415445v1792 rmdir /s /q 0001000148415445v1792 
if exist IOSPatcher rmdir /s /q IOSPatcher
if exist EVCPatcher rmdir /s /q EVCPatcher
if exist NCPatcher rmdir /s /q NCPatcher
if exist CMOCPatcher rmdir /s /q CMOCPatcher
if exist "apps/ftpiuu-cbhc" rmdir /s /q "apps/ftpiuu-cbhc"
if exist "apps/WiiModLite" rmdir /s /q "apps/WiiModLite"
if exist "apps/WiiXplorer" rmdir /s /q "apps/WiiXplorer"
if exist "apps/Mail-Patcher" rmdir /s /q "apps/Mail-Patcher"
if exist "apps/ww-43db-patcher" rmdir /s /q "apps/ww-43db-patcher"



del /q 0001000248414745v7.wad
del /q 0001000248414750v7.wad
del /q 00000001.app
del /q source.app
del /q 00000004.app
del /q 00000001_NC.app


if %percent%==1 if not exist "WAD" md WAD
goto wiiu_patching_fast_travel_100
::EVC
:wiiu_patching_fast_travel_4
if not exist EVCPatcher/patch md EVCPatcher\patch
if not exist EVCPatcher/dwn md EVCPatcher\dwn
if not exist EVCPatcher/dwn/0001000148414A45v512 md EVCPatcher\dwn\0001000148414A45v512
if not exist EVCPatcher/dwn/0001000148414A50v512 md EVCPatcher\dwn\0001000148414A50v512
if not exist EVCPatcher/pack md EVCPatcher\pack
if not exist "EVCPatcher/patch/Europe.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/patch/Europe.delta" --output EVCPatcher/patch/Europe.delta

set /a temperrorlev=%errorlevel%	
set modul=Downloading Europe Delta
if not %temperrorlev%==0 goto error_patching
if not exist "EVCPatcher/patch/USA.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/patch/USA.delta" --output EVCPatcher/patch/USA.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading USA Delta
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_7
if not exist "EVCPatcher/NUS_Downloader_Decrypt.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/NUS_Downloader_Decrypt.exe" --output EVCPatcher/NUS_Downloader_Decrypt.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading decrypter
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_8
if not exist "EVCPatcher/patch/xdelta3.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/patch/xdelta3.exe" --output EVCPatcher/patch/xdelta3.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe
if not %temperrorlev%==0 goto error_patching

if %processor_architecture%==x86 if not exist "EVCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/pack/libWiiSharp.dll" --output "EVCPatcher/pack/libWiiSharp.dll"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/pack/libWiiSharp_x64.dll" --output "EVCPatcher/pack/libWiiSharp.dll"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching

if %processor_architecture%==x86 if not exist "EVCPatcher/pack/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/pack/Sharpii.exe" --output EVCPatcher/pack/Sharpii.exe
if %processor_architecture%==AMD64 if not exist "EVCPatcher/pack/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/pack/Sharpii_x64.exe" --output EVCPatcher/pack/Sharpii.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
if %processor_architecture%==x86 if not exist "EVCPatcher/dwn/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/dwn/Sharpii.exe" --output EVCPatcher/dwn/Sharpii.exe
if %processor_architecture%==AMD64 if not exist "EVCPatcher/dwn/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/dwn/Sharpii_x64.exe" --output EVCPatcher/dwn/Sharpii.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_9
if %processor_architecture%==x86 if not exist "EVCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/dwn/libWiiSharp.dll" --output EVCPatcher/dwn/libWiiSharp.dll
if %processor_architecture%==AMD64 if not exist "EVCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/dwn/libWiiSharp_x64.dll" --output EVCPatcher/dwn/libWiiSharp.dll
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_10
if not exist "EVCPatcher/dwn/0001000148414A45v512/cetk" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/dwn/0001000148414A45v512/cetk" --output EVCPatcher/dwn/0001000148414A45v512/cetk
set /a temperrorlev=%errorlevel%
set modul=Downloading USA CETK
if not %temperrorlev%==0 goto error_patching

if not exist "EVCPatcher/dwn/0001000148414A50v512/cetk" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/dwn/0001000148414A50v512/cetk" --output EVCPatcher/dwn/0001000148414A50v512/cetk
set /a temperrorlev=%errorlevel%
set modul=Downloading EUR CETK
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

::CMOC
:wiiu_patching_fast_travel_11
if not exist CMOCPatcher/patch md CMOCPatcher\patch
if not exist CMOCPatcher/dwn md CMOCPatcher\dwn
if not exist CMOCPatcher/dwn/0001000148415045v512 md CMOCPatcher\dwn\0001000148415045v512
if not exist CMOCPatcher/dwn/0001000148415050v512 md CMOCPatcher\dwn\0001000148415050v512
if not exist CMOCPatcher/pack md CMOCPatcher\pack
if not exist "CMOCPatcher/patch/00000001_Europe.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000001_Europe.delta" --output CMOCPatcher/patch/00000001_Europe.delta
if not exist "CMOCPatcher/patch/00000004_Europe.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000004_Europe.delta" --output CMOCPatcher/patch/00000004_Europe.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_12
if not exist "CMOCPatcher/patch/00000001_USA.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000001_USA.delta" --output CMOCPatcher/patch/00000001_USA.delta
if not exist "CMOCPatcher/patch/00000004_USA.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000004_USA.delta" --output CMOCPatcher/patch/00000004_USA.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading USA Delta
if not %temperrorlev%==0 goto error_patching
if not exist "CMOCPatcher/NUS_Downloader_Decrypt.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/NUS_Downloader_Decrypt.exe" --output CMOCPatcher/NUS_Downloader_Decrypt.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading decrypter
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_13
if not exist "CMOCPatcher/patch/xdelta3.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/patch/xdelta3.exe" --output CMOCPatcher/patch/xdelta3.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_14
if %processor_architecture%==x86 if not exist "CMOCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/pack/libWiiSharp.dll" --output "CMOCPatcher/pack/libWiiSharp.dll"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/pack/libWiiSharp_x64.dll" --output "CMOCPatcher/pack/libWiiSharp.dll"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_15
if %processor_architecture%==x86 if not exist "CMOCPatcher/pack/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/pack/Sharpii.exe" --output CMOCPatcher/pack/Sharpii.exe
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/pack/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/pack/Sharpii_x64.exe" --output CMOCPatcher/pack/Sharpii.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_16
if %processor_architecture%==x86 if not exist "CMOCPatcher/dwn/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/Sharpii.exe" --output CMOCPatcher/dwn/Sharpii.exe
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/dwn/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/Sharpii_x64.exe" --output CMOCPatcher/dwn/Sharpii.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_17
if %processor_architecture%==x86 if not exist "CMOCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/libWiiSharp.dll" --output CMOCPatcher/dwn/libWiiSharp.dll
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/libWiiSharp_x64.dll" --output CMOCPatcher/dwn/libWiiSharp.dll
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_18
if not exist "CMOCPatcher/dwn/0001000148415045v512/cetk" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415045v512/cetk" --output CMOCPatcher/dwn/0001000148415045v512/cetk
if not exist "CMOCPatcher/dwn/0001000148415045v512/cert" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415045v512/cert" --output CMOCPatcher/dwn/0001000148415045v512/cert
set /a temperrorlev=%errorlevel%
set modul=Downloading USA CETK
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_19
if not exist "CMOCPatcher/dwn/0001000148415050v512/cetk" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415050v512/cetk" --output CMOCPatcher/dwn/0001000148415050v512/cetk
if not exist "CMOCPatcher/dwn/0001000148415050v512/cert" curl -f -L -s -S --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415050v512/cert" --output CMOCPatcher/dwn/0001000148415050v512/cert
set /a temperrorlev=%errorlevel%
set modul=Downloading EUR CETK
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100


::NC
:wiiu_patching_fast_travel_20
if not exist NCPatcher/patch md NCPatcher\patch
if not exist NCPatcher/dwn md NCPatcher\dwn
if not exist NCPatcher/dwn/0001000148415450v1792 md NCPatcher\dwn\0001000148415450v1792
if not exist NCPatcher/dwn/0001000148415445v1792 md NCPatcher\dwn\0001000148415445v1792
if not exist NCPatcher/pack md NCPatcher\pack
if not exist "NCPatcher/patch/Europe.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/patch/Europe.delta" --output NCPatcher/patch/Europe.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta [NC]
if not %temperrorlev%==0 goto error_patching

if not exist "NCPatcher/patch/USA.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/patch/USA.delta" --output NCPatcher/patch/USA.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading USA Delta [NC]
if not %temperrorlev%==0 goto error_patching

if not exist "NCPatcher/NUS_Downloader_Decrypt.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/NUS_Downloader_Decrypt.exe" --output NCPatcher/NUS_Downloader_Decrypt.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Decrypter
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_21
if not exist "NCPatcher/patch/xdelta3.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/patch/xdelta3.exe" --output NCPatcher/patch/xdelta3.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe
if not %temperrorlev%==0 goto error_patching

if %processor_architecture%==x86 if not exist "NCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/pack/libWiiSharp.dll" --output NCPatcher/pack/libWiiSharp.dll
if %processor_architecture%==AMD64 if not exist "NCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/pack/libWiiSharp_x64.dll" --output NCPatcher/pack/libWiiSharp.dll
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching

if %processor_architecture%==x86 if not exist "NCPatcher/pack/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/pack/Sharpii.exe" --output NCPatcher/pack/Sharpii.exe
if %processor_architecture%==AMD64 if not exist "NCPatcher/pack/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/pack/Sharpii_x64.exe" --output NCPatcher/pack/Sharpii.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_22
if %processor_architecture%==x86 if not exist "NCPatcher/dwn/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/dwn/Sharpii.exe" --output NCPatcher/dwn/Sharpii.exe
if %processor_architecture%==AMD64 if not exist "NCPatcher/dwn/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/dwn/Sharpii_x64.exe" --output NCPatcher/dwn/Sharpii.exe
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_23
if %processor_architecture%==x86 if not exist "NCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/dwn/libWiiSharp.dll" --output NCPatcher/dwn/libWiiSharp.dll
if %processor_architecture%==AMD64 if not exist "NCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/dwn/libWiiSharp_x64.dll" --output NCPatcher/dwn/libWiiSharp.dll
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_24
if not exist "NCPatcher/dwn/0001000148415445v1792/cetk" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/dwn/0001000148415445v1792/cetk" --output NCPatcher/dwn/0001000148415445v1792/cetk
set /a temperrorlev=%errorlevel%
set modul=Downloading USA CETK
if not %temperrorlev%==0 goto error_patching

if not exist "NCPatcher/dwn/0001000148415450v1792/cetk" curl -f -L -s -S --insecure "%FilesHostedOn%/NCPatcher/dwn/0001000148415450v1792/cetk" --output NCPatcher/dwn/0001000148415450v1792/cetk
set /a temperrorlev=%errorlevel%
set modul=Downloading EUR CETK
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

::Everything else
:wiiu_patching_fast_travel_25
if %percent%==25 if not exist apps md apps
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_26
if not exist apps/WiiModLite md apps\WiiModLite
if not exist "apps/WiiModLite/boot.dol" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/boot.dol" --output apps/WiiModLite/boot.dol
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching

if not exist "apps/WiiModLite/database.txt" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/database.txt" --output apps/WiiModLite/database.txt
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_27
if not exist "apps/WiiModLite/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/icon.png" --output apps/WiiModLite/icon.png
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching

if not exist "apps/WiiModLite/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/icon.png" --output apps/WiiModLite/icon.png
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_28
if not exist apps/ww-43db-patcher md apps\ww-43db-patcher
if not exist "apps/WiiModLite/meta.xml" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/meta.xml" --output apps/WiiModLite/meta.xml
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
if not exist "apps/WiiModLite/wiimod.txt" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/wiimod.txt" --output apps/WiiModLite/wiimod.txt
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching

if not exist "apps/ww-43db-patcher/meta.xml" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/ww-43db-patcher/meta.xml" --output apps/ww-43db-patcher/meta.xml
set /a temperrorlev=%errorlevel%
set modul=Downloading ww-43db-patcher
if not %temperrorlev%==0 goto error_patching
if not exist "apps/ww-43db-patcher/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/ww-43db-patcher/icon.png" --output apps/ww-43db-patcher/icon.png
set /a temperrorlev=%errorlevel%
set modul=Downloading ww-43db-patcher
if not %temperrorlev%==0 goto error_patching
if not exist "apps/ww-43db-patcher/boot.dol" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/ww-43db-patcher/boot.dol" --output apps/ww-43db-patcher/boot.dol
set /a temperrorlev=%errorlevel%
set modul=Downloading ww-43db-patcher
if not %temperrorlev%==0 goto error_patching







goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_29
if not exist "apps/ConnectMii" md "apps\ConnectMii"
	if not exist "apps/ConnectMii/meta.xml" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/ConnectMii/meta.xml" --output apps/ConnectMii/meta.xml
set /a temperrorlev=%errorlevel%
set modul=Downloading ConnectMii
if not %temperrorlev%==0 goto error_patching
	if not exist "apps/ConnectMii/boot.dol" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/ConnectMii/boot.dol" --output apps/ConnectMii/boot.dol
set /a temperrorlev=%errorlevel%
set modul=Downloading ConnectMii
if not %temperrorlev%==0 goto error_patching
	if not exist "apps/ConnectMii/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/ConnectMii/icon.png" --output apps/ConnectMii/icon.png
set /a temperrorlev=%errorlevel%
set modul=Downloading ConnectMii
if not %temperrorlev%==0 goto error_patching


goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_30
if not exist "EVCPatcher/patch/Europe.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/patch/Europe.delta" --output EVCPatcher/patch/Europe.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_31
if not exist "EVCPatcher/patch/USA.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/EVCPatcher/patch/USA.delta" --output EVCPatcher/patch/USA.delta
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_32
if not exist "WAD/IOS31 Wii U (IOS) (RiiConnect24).wad" curl -f -L -s -S --insecure "http://164.132.44.106/RiiConnect24_Patcher/IOS31_vwii.wad" --output "WAD/IOS31 Wii U (IOS) (RiiConnect24).wad"
set /a temperrorlev=%errorlevel%
set modul=Downloading IOS31
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_33
if not exist NewsChannelPatcher md NewsChannelPatcher

if not exist "NewsChannelPatcher\00000001.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/NewsChannelPatcher/00000001.delta" --output "NewsChannelPatcher/00000001.delta"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_34
if not exist "NewsChannelPatcher\libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/NewsChannelPatcher/libWiiSharp.dll" --output "NewsChannelPatcher/libWiiSharp.dll"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_35
if not exist "NewsChannelPatcher\Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NewsChannelPatcher/Sharpii.exe" --output "NewsChannelPatcher/Sharpii.exe"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

:wiiu_patching_fast_travel_36
if not exist "NewsChannelPatcher\WadInstaller.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/NewsChannelPatcher/WadInstaller.dll" --output "NewsChannelPatcher/WadInstaller.dll"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching

if not exist "NewsChannelPatcher\xdelta3.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/NewsChannelPatcher/xdelta3.exe" --output "NewsChannelPatcher/xdelta3.exe"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching

	set /a progress_downloading=1
goto wiiu_patching_fast_travel_100





::News Channel
:wiiu_patching_fast_travel_37
if %evcregion%==1 call NewsChannelPatcher\sharpii.exe nusd -id 0001000248414750 -v 7 -wad>NUL
	if %evcregion%==1 set /a temperrorlev=%errorlevel%
	if %evcregion%==1 set modul=Downloading News Channel
	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %evcregion%==2 call NewsChannelPatcher\sharpii.exe nusd -id 0001000248414745 -v 7 -wad>NUL
	if %evcregion%==2 set /a temperrorlev=%errorlevel%
	if %evcregion%==2 set modul=Downloading News Channel
	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_38

if %evcregion%==1 call NewsChannelPatcher\sharpii.exe wad -u 0001000248414750v7.wad unpacked-temp/
	if %evcregion%==1 set /a temperrorlev=%errorlevel%
	if %evcregion%==1 set modul=Unpacking News Channel
	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %evcregion%==2 call NewsChannelPatcher\sharpii.exe wad -u 0001000248414745v7.wad unpacked-temp/
	if %evcregion%==2 set /a temperrorlev=%errorlevel%
	if %evcregion%==2 set modul=Unpacking News Channel
	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_39
ren unpacked-temp\00000001.app source.app
	set /a temperrorlev=%errorlevel%
	set modul=Moving News Channel 0000001.app
	if not %temperrorlev%==0 goto error_patching
call NewsChannelPatcher\xdelta3 -d -f -s unpacked-temp\source.app NewsChannelPatcher\00000001.delta unpacked-temp\00000001.app
	set /a temperrorlev=%errorlevel%
	set modul=Patching News Channel delta
	if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_40
if %evcregion%==1 NewsChannelPatcher\sharpii.exe wad -p unpacked-temp/ "WAD\News Channel Wii U (Europe) (Channel) (RiiConnect24).wad"
	if %evcregion%==1 set /a temperrorlev=%errorlevel%
	if %evcregion%==1 set modul=Packing News Channel
	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %evcregion%==2 NewsChannelPatcher\sharpii.exe wad -p unpacked-temp/ "WAD\News Channel Wii U (USA) (Channel) (RiiConnect24).wad"
	if %evcregion%==2 set /a temperrorlev=%errorlevel%
	if %evcregion%==2 set modul=Packing News Channel
	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
set progress_news=1
goto wiiu_patching_fast_travel_100

::EVC Patcher
:wiiu_patching_fast_travel_42
if %custominstall_evc%==1 if not exist 0001000148414A50v512 md 0001000148414A50v512
if %custominstall_evc%==1 if not exist 0001000148414A45v512 md 0001000148414A45v512
if %custominstall_evc%==1 if not exist 0001000148414A50v512\cetk copy /y "EVCPatcher\dwn\0001000148414A50v512\cetk" "0001000148414A50v512\cetk"

if %custominstall_evc%==1 if not exist 0001000148414A45v512\cetk copy /y "EVCPatcher\dwn\0001000148414A45v512\cetk" "0001000148414A45v512\cetk"

goto wiiu_patching_fast_travel_100
::USA
:wiiu_patching_fast_travel_43
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\dwn\sharpii.exe NUSD -ID 0001000148414A45 -v 512 -encrypt>NUL
::PAL
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\dwn\sharpii.exe NUSD -ID 0001000148414A50 -v 512 -encrypt>NUL
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Downloading EVC
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_45
if %custominstall_evc%==1 if %evcregion%==1 copy /y "EVCPatcher\NUS_Downloader_Decrypt.exe" "0001000148414A50v512"
if %custominstall_evc%==1 if %evcregion%==2 copy /y "EVCPatcher\NUS_Downloader_Decrypt.exe" "0001000148414A45v512"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Copying NDC.exe
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_47
if %custominstall_evc%==1 if %evcregion%==1 ren "0001000148414A50v512\tmd.512" "tmd"
if %custominstall_evc%==1 if %evcregion%==2 ren "0001000148414A45v512\tmd.512" "tmd"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Renaming files [Delete everything except RiiConnect24Patcher.bat]
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_50
if %custominstall_evc%==1 if %evcregion%==1 cd 0001000148414A50v512
if %custominstall_evc%==1 if %evcregion%==1 call NUS_Downloader_Decrypt.exe >NUL
if %custominstall_evc%==1 if %evcregion%==2 cd 0001000148414A45v512
if %custominstall_evc%==1 if %evcregion%==2 call NUS_Downloader_Decrypt.exe >NUL
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Decrypter error
if %custominstall_evc%==1 if not %temperrorlev%==0 cd..& goto error_patching
if %custominstall_evc%==1 cd..
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_60
if %custominstall_evc%==1 if %evcregion%==1 move /y "0001000148414A50v512\HAJP.wad" "EVCPatcher\pack"
if %custominstall_evc%==1 if %evcregion%==2 move /y "0001000148414A45v512\HAJE.wad" "EVCPatcher\pack"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=move.exe
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_62
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\pack\Sharpii.exe WAD -u EVCPatcher\pack\HAJP.wad EVCPatcher\pack\unencrypted >NUL
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\pack\Sharpii.exe WAD -u EVCPatcher\pack\HAJE.wad EVCPatcher\pack\unencrypted >NUL
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_63
if %custominstall_evc%==1 move /y "EVCPatcher\pack\unencrypted\00000001.app" "00000001.app"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=move.exe
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_65
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\patch\xdelta3.exe -f -d -s 00000001.app EVCPatcher\patch\Europe.delta EVCPatcher\pack\unencrypted\00000001.app
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\patch\xdelta3.exe -f -d -s 00000001.app EVCPatcher\patch\USA.delta EVCPatcher\pack\unencrypted\00000001.app
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=xdelta.exe EVC
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_67
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\pack\Sharpii.exe WAD -p "EVCPatcher\pack\unencrypted" "WAD\Everybody Votes Channel (Europe) (Channel) (RiiConnect24)" -f 
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\pack\Sharpii.exe WAD -p "EVCPatcher\pack\unencrypted" "WAD\Everybody Votes Channel (USA) (Channel) (RiiConnect24)" -f
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Packing EVC WAD
if %custominstall_evc%==1 set /a progress_evc=1
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100

::CMOC
:wiiu_patching_fast_travel_68
if %custominstall_cmoc%==1 if not exist 0001000148415050v512 md 0001000148415050v512
if %custominstall_cmoc%==1 if not exist 0001000148415045v512 md 0001000148415045v512
if %custominstall_cmoc%==1 if not exist 0001000148415050v512\cetk copy /y "CMOCPatcher\dwn\0001000148415050v512\cetk" "0001000148415050v512\cetk"

if %custominstall_cmoc%==1 if not exist 0001000148415045v512\cetk copy /y "CMOCPatcher\dwn\0001000148415045v512\cetk" "0001000148415045v512\cetk"

goto wiiu_patching_fast_travel_100
::USA
:wiiu_patching_fast_travel_70
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415045 -v 512 -encrypt >NUL
::PAL
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415050 -v 512 -encrypt >NUL
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Downloading CMOC
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_71
if %custominstall_cmoc%==1 if %evcregion%==1 copy /y "CMOCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415050v512"
if %custominstall_cmoc%==1 if %evcregion%==2 copy /y "CMOCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415045v512"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Copying NDC.exe
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_72
if %custominstall_cmoc%==1 if %evcregion%==1 ren "0001000148415050v512\tmd.512" "tmd"
if %custominstall_cmoc%==1 if %evcregion%==2 ren "0001000148415045v512\tmd.512" "tmd"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Renaming files [Delete everything except RiiConnect24Patcher.bat]
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching

if %custominstall_cmoc%==1 if %evcregion%==1 cd 0001000148415050v512
if %custominstall_cmoc%==1 if %evcregion%==1 call NUS_Downloader_Decrypt.exe >NUL
if %custominstall_cmoc%==1 if %evcregion%==2 cd 0001000148415045v512
if %custominstall_cmoc%==1 if %evcregion%==2 call NUS_Downloader_Decrypt.exe >NUL
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Decrypter error
if %custominstall_cmoc%==1 if not %temperrorlev%==0 cd..& goto error_patching
if %custominstall_cmoc%==1 cd..
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_74
if %custominstall_cmoc%==1 if %evcregion%==1 move /y "0001000148415050v512\HAPP.wad" "CMOCPatcher\pack"
if %custominstall_cmoc%==1 if %evcregion%==2 move /y "0001000148415045v512\HAPE.wad" "CMOCPatcher\pack"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=move.exe
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_75
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\pack\Sharpii.exe WAD -u CMOCPatcher\pack\HAPP.wad CMOCPatcher\pack\unencrypted >NUL
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\pack\Sharpii.exe WAD -u CMOCPatcher\pack\HAPE.wad CMOCPatcher\pack\unencrypted >NUL
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_76
if %custominstall_cmoc%==1 move /y "CMOCPatcher\pack\unencrypted\00000001.app" "00000001.app"
if %custominstall_cmoc%==1 move /y "CMOCPatcher\pack\unencrypted\00000004.app" "00000004.app"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=move.exe
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_77
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000001.app CMOCPatcher\patch\00000001_Europe.delta CMOCPatcher\pack\unencrypted\00000001.app
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000004.app CMOCPatcher\patch\00000004_Europe.delta CMOCPatcher\pack\unencrypted\00000004.app
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000001.app CMOCPatcher\patch\00000001_USA.delta CMOCPatcher\pack\unencrypted\00000001.app
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000004.app CMOCPatcher\patch\00000004_USA.delta CMOCPatcher\pack\unencrypted\00000004.app
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=xdelta.exe CMOC
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_79
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\pack\Sharpii.exe WAD -p "CMOCPatcher\pack\unencrypted" "WAD\Mii Contest Channel (Europe) (Channel) (RiiConnect24)" -f 
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\pack\Sharpii.exe WAD -p "CMOCPatcher\pack\unencrypted" "WAD\Check Mii Out Channel (USA) (Channel) (RiiConnect24)" -f
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Packing CMOC WAD
if %custominstall_cmoc%==1 set /a progress_cmoc=1
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100










::NC

:wiiu_patching_fast_travel_81
if %custominstall_nc%==1 if %percent%==81 if not exist 0001000148415450v1792 md 0001000148415450v1792
if %custominstall_nc%==1 if %percent%==81 if not exist 0001000148415445v1792 md 0001000148415445v1792
if %custominstall_nc%==1 if %percent%==81 if not exist 0001000148415450v1792\cetk copy /y "NCPatcher\dwn\0001000148415450v1792\cetk" "0001000148415450v1792\cetk"

if %custominstall_nc%==1 if %percent%==81 if not exist 0001000148415445v1792\cetk copy /y "NCPatcher\dwn\0001000148415445v1792\cetk" "0001000148415445v1792\cetk"

:wiiu_patching_fast_travel_85
::USA
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==2 call NCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415445 -v 1792 -encrypt >NUL
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==2 set modul=Downloading NC
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==2	 if not %temperrorlev%==0 goto error_patching
::PAL
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==1 call NCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415450 -v 1792 -encrypt >NUL
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==1 set modul=Downloading NC
if %custominstall_nc%==1 if %percent%==85 if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_86
if %custominstall_nc%==1 if %percent%==86 if %evcregion%==1 copy /y "NCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415450v1792"
if %custominstall_nc%==1 if %percent%==86 if %evcregion%==2 copy /y "NCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415445v1792"
if %custominstall_nc%==1 if %percent%==86 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==86 set modul=Copying NDC.exe
if %custominstall_nc%==1 if %percent%==86 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_87
if %custominstall_nc%==1 if %percent%==87 if %evcregion%==1 ren "0001000148415450v1792\tmd.1792" "tmd"
if %custominstall_nc%==1 if %percent%==87 if %evcregion%==2 ren "0001000148415445v1792\tmd.1792" "tmd"
if %custominstall_nc%==1 if %percent%==87 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==87 set modul=Renaming files
if %custominstall_nc%==1 if %percent%==87 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_88
if %custominstall_nc%==1 if %percent%==88 if %evcregion%==1 cd 0001000148415450v1792
if %custominstall_nc%==1 if %percent%==88 if %evcregion%==1 call NUS_Downloader_Decrypt.exe >NUL
if %custominstall_nc%==1 if %percent%==88 if %evcregion%==2 cd 0001000148415445v1792
if %custominstall_nc%==1 if %percent%==88 if %evcregion%==2 call NUS_Downloader_Decrypt.exe >NUL
if %custominstall_nc%==1 if %percent%==88 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==88 set modul=Decrypter error
if %custominstall_nc%==1 if %percent%==88 if not %temperrorlev%==0 cd..& goto error_patching
if %custominstall_nc%==1 if %percent%==88 cd..
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_89
if %custominstall_nc%==1 if %percent%==89 if %evcregion%==1 move /y "0001000148415450v1792\HATP.wad" "NCPatcher\pack"
if %custominstall_nc%==1 if %percent%==89 if %evcregion%==2 move /y "0001000148415445v1792\HATE.wad" "NCPatcher\pack"
if %custominstall_nc%==1 if %percent%==89 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==89 set modul=move.exe
if %custominstall_nc%==1 if %percent%==89 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_90
if %custominstall_nc%==1 if %percent%==90 if %evcregion%==1 call NCPatcher\pack\Sharpii.exe WAD -u NCPatcher\pack\HATP.wad NCPatcher\pack\unencrypted >NUL
if %custominstall_nc%==1 if %percent%==90 if %evcregion%==2 call NCPatcher\pack\Sharpii.exe WAD -u NCPatcher\pack\HATE.wad NCPatcher\pack\unencrypted >NUL
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_93
if %custominstall_nc%==1 if %percent%==93 move /y "NCPatcher\pack\unencrypted\00000001.app" "00000001_NC.app"
if %custominstall_nc%==1 if %percent%==93 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==93 set modul=move.exe
if %custominstall_nc%==1 if %percent%==93 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_94
if %custominstall_nc%==1 if %percent%==94 if %evcregion%==1 call NCPatcher\patch\xdelta3.exe -f -d -s 00000001_NC.app NCPatcher\patch\Europe.delta NCPatcher\pack\unencrypted\00000001.app
if %custominstall_nc%==1 if %percent%==94 if %evcregion%==2 call NCPatcher\patch\xdelta3.exe -f -d -s 00000001_NC.app NCPatcher\patch\USA.delta NCPatcher\pack\unencrypted\00000001.app
if %custominstall_nc%==1 if %percent%==94 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==94 set modul=xdelta.exe NC
if %custominstall_nc%==1 if %percent%==94 if not %temperrorlev%==0 goto error_patching
goto wiiu_patching_fast_travel_100
:wiiu_patching_fast_travel_95
if %custominstall_nc%==1 if %percent%==95 if %evcregion%==1 call NCPatcher\pack\Sharpii.exe WAD -p "NCPatcher\pack\unencrypted" "WAD\Nintendo Channel (Europe) (Channel) (RiiConnect24)" -f 
if %custominstall_nc%==1 if %percent%==95 if %evcregion%==2 call NCPatcher\pack\Sharpii.exe WAD -p "NCPatcher\pack\unencrypted" "WAD\Nintendo Channel (USA) (Channel) (RiiConnect24)" -f
if %custominstall_nc%==1 if %percent%==95 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 if %percent%==95 set modul=Packing NC WAD
if %custominstall_nc%==1 if %percent%==95 if not %temperrorlev%==0 goto error_patching
if %custominstall_nc%==1 if %percent%==95 set /a progress_nc=1
goto wiiu_patching_fast_travel_100


:wiiu_patching_fast_travel_99
if %percent%==99 if not %sdcard%==NUL echo.&echo Don't worry^! It might take some time... Now copying files to your SD Card...
if %percent%==99 if not %sdcard%==NUL xcopy /y "WAD" "%sdcard%:\WAD" /e|| set /a errorcopying=1
if %percent%==99 if not %sdcard%==NUL xcopy /y "apps" "%sdcard%:\apps" /e|| set /a errorcopying=1
if %percent%==99 if not %sdcard%==NUL xcopy /y "wiiu" "%sdcard%:\wiiu" /e|| set /a errorcopying=1

if %percent%==99 if exist 0001000148415045v512 rmdir /s /q 0001000148415045v512
if %percent%==99 if exist 0001000148415050v512 rmdir /s /q 0001000148415050v512
if %percent%==99 if exist 0001000248414745v7 rmdir /s /q 0001000248414745v7
if %percent%==99 if exist 0001000248414750v7 rmdir /s /q 0001000248414750v7

if %percent%==99 if exist 0001000148414A45v512 rmdir /s /q 0001000148414A45v512
if %percent%==99 if exist 0001000148414A50v512 rmdir /s /q 0001000148414A50v512
if %percent%==99 if exist 0001000148415450v1792 rmdir /s /q 0001000148415450v1792
if %percent%==99 if exist 0001000148415445v1792 rmdir /s /q 0001000148415445v1792 
if %percent%==99 if exist 48414745 rmdir /s /q 48414745 
if %percent%==99 if exist 48414750 rmdir /s /q 48414750
if %percent%==99 if exist unpacked-temp rmdir /s /q unpacked-temp
if %percent%==99 if exist IOSPatcher rmdir /s /q IOSPatcher
if %percent%==99 if exist NewsChannelPatcher rmdir /s /q NewsChannelPatcher
if %percent%==99 if exist EVCPatcher rmdir /s /q EVCPatcher
if %percent%==99 if exist NCPatcher rmdir /s /q NCPatcher
if %percent%==99 if exist CMOCPatcher rmdir /s /q CMOCPatcher
if %percent%==99 del /q 00000001.app
if %percent%==99 del /q 0001000248414745v7.wad
if %percent%==99 del /q 0001000248414750v7.wad
if %percent%==99 del /q 00000004.app
if %percent%==99 del /q 00000001_NC.app
if %percent%==99 set /a progress_finishing=1
goto wiiu_patching_fast_travel_100


:wiiu_patching_fast_travel_100

if %percent%==100 goto 2_4_wiiu
::ping localhost -n 1 >NUL

if /i %ss% GEQ 20 goto random_funfact
set /a percent=%percent%+1
goto 2_3_wiiu

:2_4_wiiu
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string259%
if %sdcardstatus%==1 if not %sdcard%==NUL if %errorcopying%==0 echo %string260%
if %sdcardstatus%==1 if not %sdcard%==NUL if %errorcopying%==1 echo %string261%

if %sdcardstatus%==0 echo %string262%
echo.
echo %string263%
echo.
echo %string264%
echo.
echo %string265%
echo %string266%
echo.
echo %string267%
pause>NUL
goto 2_7_wiiu
:2_7_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string268%
echo.
echo %string269%
echo.
echo %string270%
echo.
echo 1. %string271%
echo 2. %string272%
if %preboot_environment%==1 echo 3. %string489%
set /p s=%string26%: 
if %s%==1 goto script_start
if %s%==2 goto end
if %preboot_environment%==1 if %s%==3 "X:\TOTALCMD.exe"
goto 2_7_wiiu

:1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
if exist "%TempStorage%\annoucement.txt" echo --- %string148% --- 
if exist "%TempStorage%\annoucement.txt" type "%TempStorage%\annoucement.txt"
if exist "%TempStorage%\annoucement.txt" echo.
if exist "%TempStorage%\annoucement.txt" echo -------------------
echo.
echo %string155%?
echo 1. %string273%
echo   - %string157%
echo.
echo 2. %string274%
echo   - %string275%
echo.
echo --- %string158% ---
echo.
echo 3. %string192%
echo   - %string193%
echo.
echo 4. %string159%
echo   - %string160%
echo.
echo 5. %string161%
echo   - %string162%
echo.
echo 6. %string163%
echo   - %string164% 
echo.
echo 7. %string165%
echo   - %string166%
echo.
set /p s=%string26%: 
if %s%==1 goto 2_prepare
if %s%==2 goto 2_prepare_uninstall
if %s%==3 goto direct_install_download_binary
if %s%==4 goto wadgames_patch_info
if %s%==5 goto mariokartwii_patch
if %s%==6 goto wiigames_patch
if %s%==7 goto open_shop_sdcarddetect
goto 1

:direct_install_sdcard
if not exist "%MainFolder%\WiiKeys\device.cert" goto direct_install_sdcard_configuration
if not exist "%MainFolder%\WiiKeys\keys.txt" goto direct_install_sdcard_configuration

goto direct_install_sdcard_main_menu

:direct_install_sdcard_configuration
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string278% %username%^^!
echo %string279%
echo.
echo %string280%
echo %string281%
echo.
echo %string282%
echo.
echo 1. %string283%
echo 2. %string284%
set /p s=%string26%: 
if %s%==1 set tempgotonext=direct_install_sdcard_configuration_summary& goto detect_sd_card
if %s%==2 goto direct_install_sdcard_nosdcard_access
goto direct_install_sdcard_configuration
:direct_install_sdcard_nosdcard_access
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string285%
echo %string286%
echo.
echo %string287%
pause>NUL
goto begin_main
:direct_install_sdcard_configuration_summary
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
if %sdcard%==NUL echo %string104%
if %sdcard%==NUL echo %string105%
if %sdcard%==NUL echo.
if %sdcard%==NUL echo %string288%
if not %sdcard%==NUL echo %string107% %sdcard%
if not %sdcard%==NUL echo %string289%
echo.
echo %string238%
if %sdcard%==NUL echo 1. %string290%  2. %string112%  2. %string111%
if not %sdcard%==NUL echo 1. %string110% 2. %string111% 3. %string112%
echo.
set /p s=Choose: 

	if %sdcard%==NUL if %s%==1 set tempgotonext=direct_install_sdcard_configuration_summary& goto detect_sd_card
	if %sdcard%==NUL if %s%==2 goto direct_install_sdcard_configuration_drive_letter
	if %sdcard%==NUL if %s%==2 goto begin_main

	if not %sdcard%==NUL if %s%==1 goto direct_install_sdcard_configuration_xazzy
	if not %sdcard%==NUL if %s%==1 goto begin_main
	if not %sdcard%==NUL if %s%==1 goto direct_install_sdcard_configuration_drive_letter
goto direct_install_sdcard_configuration_summary
:direct_install_sdcard_configuration_drive_letter
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string113%: %sdcard%
echo.
echo %string114%
set /p sdcard=
goto direct_install_sdcard_configuration_summary

:direct_install_sdcard_configuration_xazzy
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string291%
md "%sdcard%:\apps\xyzzy-mod"

curl -f -L -s -S --insecure "%FilesHostedOn%/apps/xyzzy-mod/boot.dol" --output "%sdcard%:\apps\xyzzy-mod\boot.dol"
	if not %errorlevel%==0 goto direct_install_sdcard_configuration_xazzy_download_error

curl -f -L -s -S --insecure "%FilesHostedOn%/apps/xyzzy-mod/icon.png" --output "%sdcard%:\apps\xyzzy-mod\icon.png"
	if not %errorlevel%==0 goto direct_install_sdcard_configuration_xazzy_download_error
	
curl -f -L -s -S --insecure "%FilesHostedOn%/apps/xyzzy-mod/meta.xml" --output "%sdcard%:\apps\xyzzy-mod\meta.xml"
		if not %errorlevel%==0 goto direct_install_sdcard_configuration_xazzy_download_error

goto direct_install_sdcard_configuration_xazzy_wait

:direct_install_sdcard_configuration_xazzy_download_error
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string292%
echo.
echo %string293%
echo %string294%
pause>NUL
goto begin_main
:direct_install_sdcard_configuration_xazzy_wait
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string295%
echo.
echo %string296%
echo %string297%
echo.
echo %string298%
echo %string299%
echo.
echo %string300%
echo.
echo 1. %string301%
echo 2. %string302%
echo.
set /p s=%string26%: 
if %s%==1 goto direct_install_sdcard_configuration_xazzy_find
if %s%==2 goto begin_main

goto direct_install_sdcard_configuration_xazzy_wait

:direct_install_sdcard_configuration_xazzy_find
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string87%
md "%MainFolder%\WiiKeys"
copy /y "%sdcard%:\device.cert" "%MainFolder%\WiiKeys\device.cert"
if not exist "%sdcard%:\device.cert" goto direct_install_sdcard_configuration_xazzy_error
copy /y "%sdcard%:\keys.txt" "%MainFolder%\WiiKeys\keys.txt"
if not exist "%sdcard%:\keys.txt" goto direct_install_sdcard_configuration_xazzy_error

rmdir /s /q "%sdcard%:\apps\xyzzy-mod"

goto direct_install_sdcard_configuration_xazzy_done

:direct_install_sdcard_configuration_xazzy_error
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string303%
echo %string304%
echo.
echo 1. %string305%
echo 2. %string306%
echo.
set /p s=%string26%: 
if %s%==1 goto direct_install_sdcard_configuration_xazzy_find
if %s%==2 goto direct_install_sdcard_configuration_xazzy_wait

goto direct_install_sdcard_configuration_xazzy_error
:direct_install_sdcard_configuration_xazzy_done
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string307%
echo %string308%
echo.
echo %string309%
pause>NUL
goto direct_install_sdcard_main_menu
:direct_install_sdcard_auto_not_found
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string310%
echo %string311%
echo.
echo 1. %string283%
echo 2. %string312%
echo 3. %string306%
set /p s=%string26%: 
if %s%==1 goto direct_install_sdcard_main_menu
if %s%==2 goto direct_install_sdcard_set
if %s%==3 goto begin_main
goto direct_install_sdcard_auto_not_found

:direct_install_sdcard_set
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string113%: %sdcard%
echo.
echo %string114%
set /p sdcard=
goto direct_install_sdcard_main_menu
:direct_install_download_binary
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string116%
echo %string313%

curl -f -L -s -S --insecure "%FilesHostedOn%/wad2bin.exe" --output "wad2bin.exe"
set /a temperrorlev=%errorlevel%

if not %temperrorlev%==0 goto direct_install_download_binary_error

goto direct_install_sdcard_main_menu

:direct_install_download_binary_error
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string314%
echo %string118%: %temperrorlev%
echo.
echo %string287%
pause>NUL
goto begin_main


:direct_install_sdcard_main_menu

if not exist "%MainFolder%\WiiKeys\device.cert" goto direct_install_sdcard_configuration
if not exist "%MainFolder%\WiiKeys\keys.txt" goto direct_install_sdcard_configuration

if %sdcard%==NUL set tempgotonext=direct_install_sdcard_main_menu2&call :detect_sd_card
:direct_install_sdcard_main_menu2
if %sdcard%==NUL goto direct_install_sdcard_auto_not_found

if not exist "wad2bin.exe" goto direct_install_download_binary

set /a file_not_exist=0

cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string278% %username%^! %string315%
if %direct_install_del_done%==1 echo.
if %direct_install_del_done%==1 echo :------------------------------------------:
if %direct_install_del_done%==1 echo  %string316%
if %direct_install_del_done%==1 echo :------------------------------------------:
set /a direct_install_del_done=0

echo.
echo 1. %string317%
echo 2. %string318%
echo 3. %string319%
echo.
echo 4. %string320%
echo 5. %string321%
if %preboot_environment%==1 echo 6. %string489%
echo.
set /p s=%string26%: 
if %s%==1 goto direct_install_bulk
::if %s%==2 goto direct_install_dlc
:: If you're reading this, you know what you're doing.
:: There's an issue with wad2bin that needs to be sorted out. Coming soon.

if %s%==3 goto direct_install_sdcard_configuration
if %s%==4 goto direct_install_delete_bogus
if %s%==5 goto begin_main
if %preboot_environment%==1 if %s%==6 "X:\TOTALCMD.exe"
goto direct_install_sdcard_main_menu

:direct_install_dlc
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
if not exist "wad2bin" md wad2bin
if %direct_install_bulk_files_error%==1 echo :-------------------------------------------------------:
if %direct_install_bulk_files_error%==1 echo  %string322%
if %direct_install_bulk_files_error%==1 echo :-------------------------------------------------------:
if %direct_install_bulk_files_error%==1 echo.
set /a direct_install_bulk_files_error=0

echo We're now going to install WAD DLC files to your SD Card.
echo I created a folder called wad2bin next to the RiiConnect24 Patcher.bat. Please put all of the files that you want to
echo install in that folder.
echo.
echo :----------------------------------------------------------------------:
echo : NOTE: You will be asked about every game during the installation.    :
echo :----------------------------------------------------------------------:
echo.
echo Are the files all in place?
echo.
echo 1. Yes, start installing.
echo 2. No, go back.
set /p s=Choose: 
if %s%==1 goto direct_install_bulk_scan_dlc
if %s%==2 goto direct_install_sdcard_main_menu

goto direct_install_dlc

:direct_install_bulk_scan_dlc
if exist "wad2bin\*.wad" goto direct_install_bulk_install_dlc
set /a direct_install_bulk_files_error=1
goto direct_install_dlc

:direct_install_bulk_install_dlc
set /a file_counter=0
for %%f in ("wad2bin\*.wad") do set /a file_counter+=1
set /a patching_file=1

	
setlocal disableDelayedExpansion
cd wad2bin
powershell -c "get-childitem *.WAD | foreach { rename-item $_ $_.Name.Replace('!', '') }"
powershell -c "get-childitem *.WAD | foreach { rename-item $_ $_.Name.Replace('&', '') }"
cd..
setlocal enableDelayedExpansion
setlocal enableextensions

for %%a in ("wad2bin\*.wad") do (
set file_path=%%a

cls
echo %header_for_loops%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [.] Install DLC files directly to the SD Card - wad2bin.
echo   ^> %string277%
echo.
echo Instaling file [!patching_file!] out of [%file_counter%]
echo File name: %%~na
echo.
echo What's the game's name for the file that you're installing?
echo.
echo 1. Just Dance 2
echo 2. Just Dance 3
echo 3. Just Dance 4
echo 4. Just Dance 2014
echo 5. Just Dance 2015
echo 6. Rock Band 2
echo 7. Rock Band 3
echo 8. The Beatles - Rock Band
echo 9. Green Day - Rock Band
echo 10. Guitar Hero: World Tour
echo 11. Guitar Hero 5
echo 12. Guitar Hero: Warriors of Rock
echo.
echo 13. The game is not listed. Skip installation for this file.
set dlc_id=NUL
echo.
set /p game_dlc=Choose: 
if !game_dlc!==1 set dlc_id=00010000534432
if !game_dlc!==2 set dlc_id=00010000534A44
if !game_dlc!==3 set dlc_id=00010000534A58
if !game_dlc!==4 set dlc_id=00010000534A4F
if !game_dlc!==5 set dlc_id=00010000534533
if !game_dlc!==6 set dlc_id=00010000535A41
if !game_dlc!==7 set dlc_id=00010000535A42
if !game_dlc!==8 set dlc_id=0001000052394A
if !game_dlc!==9 set dlc_id=00010000535A41
if !game_dlc!==10 set dlc_id=00010000535841
if !game_dlc!==11 set dlc_id=00010000535845
if !game_dlc!==12 set dlc_id=00010000535849
echo.
if not !dlc_id!==NUL echo Region?
if not !dlc_id!==NUL echo 1. Europe 
if not !dlc_id!==NUL echo 2. USA
if not !dlc_id!==NUL set /p region_dlc=Choose: 
if not !dlc_id!==NUL if !region_dlc!==1 set dlc_id=!dlc_id!50
if not !dlc_id!==NUL if !region_dlc!==2 set dlc_id=!dlc_id!45
echo.
echo Alright, installing...

if not "!dlc_id!"=="NUL" wad2bin "%MainFolder%\WiiKeys\keys.txt" "%MainFolder%\WiiKeys\device.cert" "%%a" "%sdcard%:\" !dlc_id!
echo off
pause
	set /a temperrorlev=!errorlevel!
	if not !temperrorlev!==0 goto direct_install_single_fail

move /Y "%sdcard%:\*_bogus.wad" "%sdcard%:\WAD\">NUL

set /a patching_file=!patching_file!+1
)
del /q wad2bin_output.txt
echo.
echo Installation complete^! 
echo  Now, please start your WAD Manager (Wii Mod Lite, if you installed RiiConnect24) and please install the WAD file called
echo  (numbers)_bogus.wad on your Wii.
echo.
echo  NOTE: You will get a -1022 error - don't worry! The WAD is empty but all we need is the TMD and ticket.
echo  After you're done installing the WAD, you can later plug in the SD Card in and choose the option to delete bogus WAD's
echo  in the main menu.
echo.
echo Press any key to go back.

pause>NUL
goto direct_install_sdcard_main_menu


























:direct_install_bulk
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
if not exist "wad2bin" md wad2bin
if %direct_install_bulk_files_error%==1 echo :-------------------------------------------------------:
if %direct_install_bulk_files_error%==1 echo  %string322%
if %direct_install_bulk_files_error%==1 echo :-------------------------------------------------------:
if %direct_install_bulk_files_error%==1 echo.
set /a direct_install_bulk_files_error=0

echo %string323%
echo %string324%
echo %string325%
echo.
echo :-----------------------------------------------------:
echo   %string326%
echo :-----------------------------------------------------:
echo.
echo %string327%
echo.
echo 1. %string328%
echo 2. %string329%
set /p s=%string26%: 
if %s%==1 goto direct_install_bulk_scan
if %s%==2 goto direct_install_sdcard_main_menu

goto direct_install_bulk

:direct_install_bulk_scan
if exist "wad2bin\*.wad" goto direct_install_bulk_install
set /a direct_install_bulk_files_error=1
goto direct_install_bulk

:direct_install_bulk_install
set /a file_counter=0
for %%f in ("wad2bin\*.wad") do set /a file_counter+=1
set /a patching_file=1


setlocal disableDelayedExpansion
cd wad2bin
powershell -c "get-childitem *.WAD | foreach { rename-item $_ $_.Name.Replace('!', '') }"
powershell -c "get-childitem *.WAD | foreach { rename-item $_ $_.Name.Replace('&', '') }"
cd..
setlocal enableDelayedExpansion

if exist installation_error_log.txt del /q installation_error_log.txt
set /a error_count=0

if not exist "%sdcard%:\WAD" md "%sdcard%:\WAD">NUL


for %%f in ("wad2bin\*.wad") do (

cls
echo %header_for_loops%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [.] %string276%
echo   ^> %string277%
echo.
echo %string330% [!patching_file!] %string331% [%file_counter%]
echo %string332%: %%~nf
call wad2bin.exe "%MainFolder%\WiiKeys\keys.txt" "%MainFolder%\WiiKeys\device.cert" "%%f" %sdcard%:\>wad2bin_output.txt
	set /a temperrorlev=!errorlevel!
	if not !temperrorlev!==0 set /a error_count+=1& echo [%time:~0,8%] [%date%] [%string482%: !errorlevel!] %string490% %%~nf>>installation_error_log.txt

move /Y "%sdcard%:\*_bogus.wad" "%sdcard%:\WAD\">NUL

set /a patching_file=!patching_file!+1
)
del /q wad2bin_output.txt
echo.
echo %string333%
echo  %string334%
echo  %string335%
echo.
echo  %string336%
echo  %string337%
echo  %string338%
echo.
setlocal disableDelayedExpansion
if not "%error_count%"=="0" echo %string491% %error_count% %string492%
if not "%error_count%"=="0" echo %string493%
if not "%error_count%"=="0" pause>NUL
if not "%error_count%"=="0" start "" "installation_error_log.txt"
if not "%error_count%"=="0" goto direct_install_sdcard_main_menu

echo %string294%




pause>NUL
goto direct_install_sdcard_main_menu
:direct_install_delete_bogus
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo [*] %string276%
echo   ^> %string277%
echo.
echo %string339%
echo %string340%
echo.
echo %string341%
echo.
echo 1. %string245%
echo 2. %string329%
set /p s=Choose: 
if %s%==1 del /q "%sdcard%:\WAD\*_bogus.wad"&set /a direct_install_del_done=1&goto direct_install_sdcard_main_menu
if %s%==2 goto direct_install_sdcard_main_menu
goto direct_install_delete_bogus

:direct_install_single_fail
cls
echo %header%                                                                
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   %string73%
echo   /     \  %string342%
echo  /   ^^!   \ 
echo  --------- %string343%: %temperrorlev%
if %temperrorlev%==-1 echo            ERROR: Invalid arguments
if %temperrorlev%==-2 echo            ERROR: Memory allocation for internal path buffers failed
if %temperrorlev%==-3 echo            ERROR: (Windows only) UTF-8 to UTF-16 conversion failed
if %temperrorlev%==-4 echo            ERROR: Failed to load console-specific keydata
if %temperrorlev%==-5 echo            ERROR: Failed to unpack input WAD
if %temperrorlev%==-6 echo            ERROR: Failed to realign loaded certificate chain buffer
if %temperrorlev%==-7 echo            ERROR: Failed to realign loaded ticket buffer
if %temperrorlev%==-8 echo            ERROR: Failed to realign loaded TMD buffer
if %temperrorlev%==-9 echo            ERROR: Input WAD is a DLC WAD from a game that doesn't support loading data from a SD card
if %temperrorlev%==-10 echo            ERROR: Failed to generate indexed bin files from unpacked DLC WAD
if %temperrorlev%==-11 echo            ERROR: Failed to generate content.bin file from unpacked non-DLC WAD
if %temperrorlev%==-12 echo            ERROR: Failed to generate bogus WAD
echo.
echo            %string344%
echo.
echo       1. %string345%
echo       2. %string346%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
set /p s=%string26%: 
if %s%==1 goto direct_install_sdcard_main_menu
if %s%==2 call "wad2bin_output.txt"
goto direct_install_single_fail
:wiigames_patch
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string347%
echo %string348%
echo.
echo %string253%:

set tempCD=%cd%

if exist Wiimmfi-Patcher rmdir /s /q Wiimmfi-Patcher
md Wiimmfi-Patcher
echo 25%%
curl -f -L -s -S --insecure "https://download.wiimm.de/wiimmfi/patcher/wiimmfi-patcher-v4.7z" --output "Wiimmfi-Patcher\wiimmfi-patcher-v4.7z"
echo 50%%
curl -f -L -s -S --insecure "%FilesHostedOn%/7z.exe" --output "Wiimmfi-Patcher\7z.exe"
echo 75%%
cd Wiimmfi-Patcher
7z.exe x wiimmfi-patcher-v4.7z>NUL

cd ..

echo 100%%
goto wiigames_patch_ask

:wiigames_patch_ask
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string349%
echo %string350%
echo.
if exist "*.ISO" echo %string351%: %string353%
if not exist "*.ISO" echo %string351%: %string354%
if exist "*.WBFS" echo %string352%: %string353%
if not exist "*.WBFS" echo %string352%: %string354%
echo.
echo 1. %string355%
echo 2. %string356%
set /p s=%string26%: 
if %s%==1 goto start_wiimmfi-patcher
if %s%==2 rmdir /s /q Wiimmfi-Patcher&goto begin_main
goto wiigames_patch_ask
:start_wiimmfi-patcher
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.

if exist "*.WBFS" copy "*.WBFS" "Wiimmfi-Patcher\wiimmfi-patcher-v4\Windows"
if exist "*.ISO" copy "*.ISO" "Wiimmfi-Patcher\wiimmfi-patcher-v4\Windows"

cd "Wiimmfi-Patcher\wiimmfi-patcher-v4\Windows"

@echo off

wit cp . --DEST ../wiimmfi-images/ --update --psel=data --wiimmfi -vv

cd ..
cd ..
cd ..

if not exist wiimmfi-images md wiimmfi-images
move "Wiimmfi-Patcher\wiimmfi-patcher-v4\wiimmfi-images\*.iso" "wiimmfi-images"
move "Wiimmfi-Patcher\wiimmfi-patcher-v4\wiimmfi-images\*.wbfs" "wiimmfi-images"
ping localhost -n 2>NUL
rmdir Wiimmfi-Patcher
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string357% 
echo %string358%
echo.
echo %string359%
pause>NUL

goto script_start

:mariokartwii_patch
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string360%
echo %string348%
echo.
echo %string253%:
set tempCD=%cd%
if exist MKWii-Patcher rmdir /s /q MKWii-Patcher
md MKWii-Patcher
echo 25%%
curl -f -L -s -S --insecure "https://download.wiimm.de/wiimmfi/patcher/mkw-wiimmfi-patcher-v6.zip" --output "MKWii-Patcher\mkw-wiimmfi-patcher-v6.zip"
echo 50%%
curl -f -L -s -S --insecure "%FilesHostedOn%/7z.exe" --output "MKWii-Patcher\7z.exe"
echo 75%%
cd MKWii-Patcher
7z.exe x mkw-wiimmfi-patcher-v6.zip>NUL
cd..
echo 100%%
goto mariokartwii_patch_ask

:mariokartwii_patch_ask
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string361%
echo %string362%
echo.
if exist "*.ISO" echo %string351%: %string353%
if not exist "*.ISO" echo %string351%: %string354%
if exist "*.WBFS" echo %string352%: %string353%
if not exist "*.WBFS" echo %string352%: %string354%
echo.
echo 1. %string363%
echo 2. %string356%
set /p s=Choose: 
if %s%==1 goto start_mkwii-patcher
if %s%==2 rmdir /s /q MKWii-Patcher&goto begin_main
goto mariokartwii_patch_ask
:start_mkwii-patcher
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
set tempCD=%cd%
if exist "*.WBFS" copy "*.WBFS" "MKWii-Patcher\mkw-wiimmfi-patcher-v6\"
if exist "*.ISO" copy "*.ISO" "MKWii-Patcher\mkw-wiimmfi-patcher-v6\"

cd MKWii-Patcher\mkw-wiimmfi-patcher-v6

@echo off

::Actual patching
set PATH=bin\cygwin;%PATH%
bash ./patch-wiimmfi.sh %1 %2 %3 %4 %5 %6 %7 %8 %9

cd ..
cd ..

if not exist wiimmfi-images md wiimmfi-images
move "MKWii-Patcher\mkw-wiimmfi-patcher-v6\wiimmfi-images\*.iso" "wiimmfi-images"
move "MKWii-Patcher\mkw-wiimmfi-patcher-v6\wiimmfi-images\*.wbfs" "wiimmfi-images"
rmdir MKWii-Patcher

cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string357%
echo %string364%
echo.
echo %tempCD%
echo %string359%
pause>NUL

goto script_start



:wadgames_patch_info
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string365%
echo %string348%
echo.
echo %string253%:
if exist WiiWare-Patcher rmdir /s /q WiiWare-Patcher
md WiiWare-Patcher
echo 14%%
curl -f -L -s -S --insecure "%FilesHostedOn_WiiWarePatcher%/libWiiSharp.dll" --output WiiWare-Patcher/libWiiSharp.dll
echo 28%%
curl -f -L -s -S --insecure "%FilesHostedOn_WiiWarePatcher%/lzx.exe" --output WiiWare-Patcher/lzx.exe
echo 42%%
curl -f -L -s -S --insecure "%FilesHostedOn_WiiWarePatcher%/patcher.bat" --output WiiWare-Patcher/patcher.bat
echo 57%%
curl -f -L -s -S --insecure "%FilesHostedOn_WiiWarePatcher%/Sharpii.exe" --output WiiWare-Patcher/Sharpii.exe
echo 71%%
curl -f -L -s -S --insecure "%FilesHostedOn_WiiWarePatcher%/WadInstaller.dll" --output WiiWare-Patcher/WadInstaller.dll
echo 85%%
curl -f -L -s -S --insecure "%FilesHostedOn_WiiWarePatcher%/WiiwarePatcher.exe" --output WiiWare-Patcher/WiiwarePatcher.exe
echo 100%%
goto wadgames_patch_ask
:wadgames_patch_ask
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string366%
echo.
echo 1. %string367%
echo 2. %string356%
set /p s=%string26%: 
if %s%==1 goto start_wiiware-patcher
if %s%==2 rmdir /s /q WiiWare-Patcher&goto begin_main

:start_wiiware-patcher
if exist WiiWare-Patcher\RC24PATCHER_START_PATCHING_SCRIPT del /q WiiWare-Patcher\RC24PATCHER_START_PATCHING_SCRIPT
echo 1>>WiiWare-Patcher\RC24PATCHER_START_PATCHING_SCRIPT
::
cd WiiWare-Patcher
call patcher
cd..
::
cls
echo %string368%
if exist WiiWare-Patcher\backup-wads md backup-wads
if exist WiiWare-Patcher\wiimmfi-wads md wiimmfi-wads
if exist WiiWare-Patcher\backup-wads move "WiiWare-Patcher\backup-wads\*.wad" "backup-wads\"
if exist WiiWare-Patcher\wiimmfi-wads move "WiiWare-Patcher\wiimmfi-wads\*.wad" "wiimmfi-wads\"

cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string369%
echo %string370%
echo.
echo %string371%
pause>NUL
goto script_start


:2_uninstall
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo :-------------------------------------------------------------------------------------------------------------------:
echo  %string372%
echo  %string373%
echo :-------------------------------------------------------------------------------------------------------------------:
echo.
echo %string374%
echo %string375%
echo - %string20$%
echo - %string376%
echo - %string377%
echo.
echo %string378%
echo.
echo %string379%
echo 1. %string245%
echo 2. %string329%
echo.
set /p s=%string26%: 
if %s%==1 goto 2_uninstall_1
if %s%==2 goto 1
goto 2_uninstall
:2_uninstall_1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string380%
echo %string381%
echo.
echo 1. %string245%
echo 2. %string246%
set /p uninstall_2_1=%string26%: 
if %uninstall_2_1%==1 goto 2_uninstall_2
if %uninstall_2_1%==2 goto 2_uninstall_3
goto 2_uninstall_1
:2_uninstall_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string382%
echo %string383%
echo %string384%
echo.
echo 1. %string385%
echo 2. %string246%
set /p uninstall_2_2=%string26%: 
if %uninstall_2_2%==1 goto 2_uninstall_2_1
if %uninstall_2_2%==2 goto 2_uninstall_3
goto 2_uninstall_2
:2_uninstall_2_1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string386%
echo %string387%
echo %string388%
echo %string389%
echo.
echo %string390%
echo %string391%
echo.
echo %string392%
ping localhost -n 2 >NUL
pause>NUL
goto 2_uninstall_3
:2_uninstall_3
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string393%
echo.
echo %string394%
echo.
echo 1. %string229%
echo 2. %string230%
set sdcard=NUL
set /p sdcard=%string26%: 
if %sdcard%==1 set /a sdcardstatus=1& set tempgotonext=2_uninstall_3_summary& goto detect_sd_card
if %sdcard%==2 set /a sdcardstatus=0& set /a sdcard=NUL& goto 2_uninstall_3_summary
goto 2_uninstall_3
:2_uninstall_3_summary
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
if %sdcardstatus%==0 echo %string231%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string232%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string233%
if %sdcardstatus%==1 if %sdcard%==NUL echo.
if %sdcardstatus%==1 if %sdcard%==NUL echo %string234%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string235% %sdcard%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string236%
echo.
echo %string395%
echo.
echo %string109%
if %sdcardstatus%==0 echo 1. %string239%  2. %string240%
if %sdcardstatus%==1 if %sdcard%==NUL echo 1. %string239% 2. %string240% 3. %string241%
if %sdcardstatus%==1 if not %sdcard%==NUL echo 1. %string239% 2. %string240% 3. %string241%
set /p s=%string26%: 
if %s%==1 goto 2_uninstall_4
if %s%==2 goto begin_main
if %s%==3 goto 2_uninstall_change_drive_letter
goto 2_uninstall_3_summary
:2_uninstall_4
cls
set /a percent=%percent%+1

if /i %percent% GTR 0 if /i %percent% LSS 10 set /a counter_done=0
if /i %percent% GTR 10 if /i %percent% LSS 20 set /a counter_done=1
if /i %percent% GTR 20 if /i %percent% LSS 30 set /a counter_done=2
if /i %percent% GTR 30 if /i %percent% LSS 40 set /a counter_done=3
if /i %percent% GTR 40 if /i %percent% LSS 50 set /a counter_done=4
if /i %percent% GTR 50 if /i %percent% LSS 60 set /a counter_done=5
if /i %percent% GTR 60 if /i %percent% LSS 70 set /a counter_done=6
if /i %percent% GTR 70 if /i %percent% LSS 80 set /a counter_done=7
if /i %percent% GTR 80 if /i %percent% LSS 90 set /a counter_done=8
if /i %percent% GTR 90 if /i %percent% LSS 100 set /a counter_done=9
if %percent%==100 set /a counter_done=10
if %percent%==100 goto 2_uninstall_5
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo  [*] %string396%
echo.
echo    %string253%: 
if %counter_done%==0 echo :          : %percent% %%
if %counter_done%==1 echo :-         : %percent% %%
if %counter_done%==2 echo :--        : %percent% %%
if %counter_done%==3 echo :---       : %percent% %%
if %counter_done%==4 echo :----      : %percent% %%
if %counter_done%==5 echo :-----     : %percent% %%
if %counter_done%==6 echo :------    : %percent% %%
if %counter_done%==7 echo :-------   : %percent% %%
if %counter_done%==8 echo :--------  : %percent% %%
if %counter_done%==9 echo :--------- : %percent% %%
if %counter_done%==10 echo :----------: %percent% %%

::Download files
if %percent%==1 if not exist IOSPatcher md IOSPatcher
if %percent%==1 if not exist "IOSPatcher/00000006-31.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/00000006-31.delta" --output IOSPatcher/00000006-31.delta
if %percent%==1 set /a temperrorlev=%errorlevel%
if %percent%==1 set modul=Downloading 06-31.delta
if %percent%==1 if not %temperrorlev%==0 goto error_patching

if %percent%==3 if not exist "IOSPatcher/00000006-80.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/00000006-80.delta" --output IOSPatcher/00000006-80.delta
if %percent%==3 set /a temperrorlev=%errorlevel%
if %percent%==3 set modul=Downloading 06-80.delta
if %percent%==3 if not %temperrorlev%==0 goto error_patching

if %percent%==6 if not exist "IOSPatcher/00000006-80.delta" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/00000006-80.delta" --output IOSPatcher/00000006-80.delta
if %percent%==6 set /a temperrorlev=%errorlevel%
if %percent%==6 set modul=Downloading 06-80.delta
if %percent%==6 if not %temperrorlev%==0 goto error_patching

if %percent%==9 if not exist "IOSPatcher/libWiiSharp.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/libWiiSharp.dll" --output IOSPatcher/libWiiSharp.dll
if %percent%==9 set /a temperrorlev=%errorlevel%
if %percent%==9 set modul=Downloading libWiiSharp.dll
if %percent%==9 if not %temperrorlev%==0 goto error_patching

if %percent%==12 if not exist "IOSPatcher/Sharpii.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/Sharpii.exe" --output IOSPatcher/Sharpii.exe
if %percent%==12 set /a temperrorlev=%errorlevel%
if %percent%==12 set modul=Downloading Sharpii.exe
if %percent%==12 if not %temperrorlev%==0 goto error_patching

if %percent%==15 if not exist "IOSPatcher/WadInstaller.dll" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/WadInstaller.dll" --output IOSPatcher/WadInstaller.dll
if %percent%==15 set /a temperrorlev=%errorlevel%
if %percent%==15 set modul=Downloading WadInstaller.dll
if %percent%==15 if not %temperrorlev%==0 goto error_patching

if %percent%==17 if not exist "IOSPatcher/xdelta3.exe" curl -f -L -s -S --insecure "%FilesHostedOn%/IOSPatcher/xdelta3.exe" --output IOSPatcher/xdelta3.exe
if %percent%==17 set /a temperrorlev=%errorlevel%
if %percent%==17 set modul=Downloading xdelta3.exe
if %percent%==17 if not %temperrorlev%==0 goto error_patching


if %percent%==20 if not exist apps md apps

if %percent%==23 if not exist apps/WiiModLite md apps\WiiModLite
if %percent%==23 if not exist apps/WiiXplorer md apps\WiiXplorer
if %percent%==23 if not exist "apps/WiiModLite/boot.dol" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/boot.dol" --output apps/WiiModLite/boot.dol
if %percent%==23 set /a temperrorlev=%errorlevel%
if %percent%==23 set modul=Downloading Wii Mod Lite
if %percent%==23 if not %temperrorlev%==0 goto error_patching

if %percent%==25 if not exist "apps/WiiModLite/database.txt" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/database.txt" --output apps/WiiModLite/database.txt
if %percent%==25 set /a temperrorlev=%errorlevel%
if %percent%==25 set modul=Downloading Wii Mod Lite
if %percent%==25 if not %temperrorlev%==0 goto error_patching

if %percent%==27 if not exist "apps/WiiModLite/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/icon.png" --output apps/WiiModLite/icon.png
if %percent%==27 set /a temperrorlev=%errorlevel%
if %percent%==27 set modul=Downloading Wii Mod Lite
if %percent%==27 if not %temperrorlev%==0 goto error_patching

if %percent%==30 if not exist "apps/WiiModLite/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/icon.png" --output apps/WiiModLite/icon.png
if %percent%==30 set /a temperrorlev=%errorlevel%
if %percent%==30 set modul=Downloading Wii Mod Lite
if %percent%==30 if not %temperrorlev%==0 goto error_patching

if %percent%==32 if not exist "apps/WiiModLite/meta.xml" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/meta.xml" --output apps/WiiModLite/meta.xml"
if %percent%==32 set /a temperrorlev=%errorlevel%
if %percent%==32 set modul=Downloading Wii Mod Lite
if %percent%==32 if not %temperrorlev%==0 goto error_patching

if %percent%==34 if not exist "apps/WiiModLite/wiimod.txt" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/wiimod.txt" --output apps/WiiModLite/wiimod.txt
if %percent%==34 set /a temperrorlev=%errorlevel%
if %percent%==34 set modul=Downloading Wii Mod Lite
if %percent%==34 if not %temperrorlev%==0 goto error_patching

if %percent%==36 if not exist "apps/WiiXplorer/boot.dol" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiXplorer/boot.dol" --output apps/WiiXplorer/boot.dol
if %percent%==36 set /a temperrorlev=%errorlevel%
if %percent%==36 set modul=Downloading WiiXplorer
if %percent%==36 if not %temperrorlev%==0 goto error_patching

if %percent%==38 if not exist "apps/WiiXplorer/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiXplorer/icon.png" --output apps/WiiXplorer/icon.png
if %percent%==38 set /a temperrorlev=%errorlevel%
if %percent%==38 set modul=Downloading WiiXplorer
if %percent%==38 if not %temperrorlev%==0 goto error_patching

if %percent%==39 if not exist "apps/WiiXplorer/meta.xml" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiXplorer/meta.xml" --output apps/WiiXplorer/meta.xml
if %percent%==39 set /a temperrorlev=%errorlevel%
if %percent%==39 set modul=Downloading WiiXplorer
if %percent%==39 if not %temperrorlev%==0 goto error_patching

if %percent%==40 if %uninstall_2_1%==1 if not exist "apps/WiiXplorer/meta.xml" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/meta.xml" --output apps/WiiModLite/meta.xml
if %percent%==40 if %uninstall_2_1%==1 set /a temperrorlev=%errorlevel%
if %percent%==40 if %uninstall_2_1%==1 set modul=Downloading WiiXplorer
if %percent%==40 if %uninstall_2_1%==1 if not %temperrorlev%==0 goto error_patching

if %percent%==45 if %uninstall_2_1%==1 if not exist "apps/WiiXplorer/icon.png" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/meta.xml" --output apps/WiiModLite/meta.xml
if %percent%==45 if %uninstall_2_1%==1 set /a temperrorlev=%errorlevel%
if %percent%==45 if %uninstall_2_1%==1 set modul=Downloading WiiXplorer
if %percent%==45 if %uninstall_2_1%==1 if not %temperrorlev%==0 goto error_patching

if %percent%==48 if %uninstall_2_1%==1 if not exist "apps/WiiXplorer/boot.dol" curl -f -L -s -S --insecure "%FilesHostedOn%/apps/WiiModLite/meta.xml" --output apps/WiiModLite/meta.xml
if %percent%==48 if %uninstall_2_1%==1 set /a temperrorlev=%errorlevel%
if %percent%==48 if %uninstall_2_1%==1 set modul=Downloading WiiXplorer
if %percent%==48 if %uninstall_2_1%==1 if not %temperrorlev%==0 goto error_patching

if %percent%==50 if not exist "WAD" md "WAD"
if %percent%==50 call IOSPatcher\Sharpii.exe NUSD -IOS 31 -v latest -o "wad\IOS31 Wii Only (IOS) (Original).wad" -wad >NUL
if %percent%==50 set /a temperrorlev=%errorlevel%
if %percent%==50 set modul=Sharpii.exe
if %percent%==50 if not %temperrorlev%==0 goto error_patching

if %percent%==80 call IOSPatcher\Sharpii.exe NUSD -IOS 80 -v latest -o "wad\IOS80 Wii Only (IOS) (Original).wad" -wad >NUL
if %percent%==80 set /a temperrorlev=%errorlevel%
if %percent%==80 set modul=Sharpii.exe
if %percent%==80 if not %temperrorlev%==0 goto error_patching

if %percent%==95 if not %sdcard%==NUL set /a errorcopying=0
if %percent%==95 if not %sdcard%==NUL if not exist "%sdcard%:\WAD" md "%sdcard%:\WAD"
if %percent%==95 if not %sdcard%==NUL if not exist "%sdcard%:\apps" md "%sdcard%:\apps"

if %percent%==98 if not %sdcard%==NUL xcopy /y "WAD" "%sdcard%:\WAD" /e >NUL || set /a errorcopying=1
if %percent%==98 if not %sdcard%==NUL xcopy /y "apps" "%sdcard%:\apps" /e >NUL || set /a errorcopying=1

if %percent%==99 if exist "IOSPatcher" rmdir /s /q "IOSPatcher"
if %percent%==100 goto 2_4
ping localhost -n 1 >NUL
goto 2_uninstall_4
:2_uninstall_5
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string397%
echo.
if %sdcard%==NUL echo - %string398%
if %sdcard%==NUL echo.
echo %string399%
echo 1. %string400%
echo 2. %string401%
echo 3. %string402%
echo 4. %string403%
echo.
echo %string404%
echo 1. %string405% 2. %string302%
set /p s=%string26%: 
if %s%==1 goto 2_uninstall_5_2
if %s%==2 goto begin_main
goto 2_uninstall_5
:2_uninstall_5_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string406%
echo.
echo 1. %string407%
echo 2. %string408%
echo    - %string409%
echo 3. %string410%
echo 4. %string411%
echo 5. %string412%
echo 6. %string413%
echo.
echo %string404%
echo 1. %string414% 2. %string405% 3. %string240%
set /p s=%string26%: 
if %s%==1 goto 2_uninstall_5
if %s%==2 goto 2_uninstall_5_3
if %s%==3 goto begin_main
goto 2_uninstall_5_2
:2_uninstall_5_3
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string415%
echo.
echo 1. %string416%
echo 2. %string417%
echo 3. %string418%
echo 4. %string419%
echo 5. %string420%
echo 6. %string421%
echo 7. %string422%
echo 8. %string423%
echo 9. %string424%
echo.
echo %string404%
echo 1. %string414% 2. %string405% 3. %sting240%
set /p s=%string26%: 
if %s%==1 goto 2_uninstall_5
if %s%==2 goto 2_uninstall_5_4
if %s%==3 goto begin_main
goto 2_uninstall_5_3
:2_uninstall_5_4
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string425%
echo %string426%
echo.
echo %string427%
set /a exitmessage=0
pause>NUL
goto end
:2_uninstall_change_drive_letter
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo [*] SD Card
echo.
echo %string113%: %sdcard%
echo.
echo %string114%
set /p sdcard=
goto 2_uninstall_3_summary
:error_NUS_DOWN
cls
echo %header%                                                                
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   %string73%
echo   /     \  %string428%
echo  /   ^!   \ 
echo  --------- %string429%
echo            %string430%
echo.
echo       %string90%
echo ---------------------------------------------------------------------------------------------------------------------------

echo %string502%
>"%MainFolder%\error_report.txt" echo RiiConnect24 Patcher v%version%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Main Menu
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Date: %date%
>>"%MainFolder%\error_report.txt" echo Time: %time:~0,5%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Windows version: %windows_version%
>>"%MainFolder%\error_report.txt" echo Language: %language%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Action: Starting the patcher
>>"%MainFolder%\error_report.txt" echo Module: NUS Check Script. NUS Down.

curl -F "report=@%MainFolder%\error_report.txt" %post_url%?user=%random_identifier%>NUL


pause>NUL
goto begin_main
:2_prepare_uninstall
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string116%
echo %string431%
:: Check if NUS is up
if %preboot_environment%==0 curl -i -s http://nus.cdn.shop.wii.com/ccs/download/0001000248414741/tmd | findstr "HTTP/1.1" | findstr "500 Internal Server Error"
if %preboot_environment%==0 if %errorlevel%==0 goto error_NUS_DOWN


:: If returns 0, 500 HTTP code it is
goto 2_uninstall

:2_prepare
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string116%
echo %string431%
:: Check if NUS is up
if %preboot_environment%==0 curl -i -s http://nus.cdn.shop.wii.com/ccs/download/0001000248414741/tmd | findstr "HTTP/1.1" | findstr "500 Internal Server Error"
if %preboot_environment%==0 if %errorlevel%==0 goto error_NUS_DOWN
:: If returns 0, 500 HTTP code it is
goto 2_auto_ask


:2_auto_ask
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string432%
echo.
echo %string201%
echo 1. %string202%
echo   - %string433%
echo     - %string204%
echo     - %string376%
echo     - %string205%
echo     - %string377%
echo     - %string206%
echo     - %string207%
echo.
echo 2. %string208%
echo   - %string209%
set /p s=
if %s%==1 goto 2_auto
if %s%==2 goto 2_choose_custom_instal_type
goto 2_auto_ask


:2_choose_custom_instal_type
set /a evcregion=1
set /a custominstall_ios=1
set /a custominstall_evc=1
set /a custominstall_nc=1
set /a custominstall_cmoc=1
set /a custominstall_news_fore=1
set /a sdcardstatus=0
set /a errorcopying=0
set sdcard=NUL
goto 2_choose_custom_install_type2

:2_choose_custom_install_type2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string432%
echo.
echo %string201%
echo - %string208%
echo.
if %evcregion%==1 echo 1. %string211% %string183%
if %evcregion%==2 echo 1. %string211% %string184%
echo.
if %custominstall_ios%==1 echo 2. [X] %string434%
if %custominstall_ios%==0 echo 2. [ ] %string434%
if %custominstall_news_fore%==1 echo 3. [X] %string435%
if %custominstall_news_fore%==0 echo 3. [ ] %string435%
if %custominstall_evc%==1 echo 4. [X] %string205%
if %custominstall_evc%==0 echo 4. [ ] %string205%
if %custominstall_nc%==1 echo 5. [X] %string206%
if %custominstall_nc%==0 echo 5. [ ] %string206%
if %custominstall_cmoc%==1 echo 6. [X] %string207%
if %custominstall_cmoc%==0 echo 6. [ ] %string207%
echo.
echo 7. %string212%
echo R. %string213%
set /p s=
if %s%==1 goto 2_switch_region
if %s%==2 goto 2_switch_fore-news-wiimail
if %s%==3 goto 2_switch_fore_news
if %s%==4 goto 2_switch_evc
if %s%==5 goto 2_switch_nc
if %s%==6 goto 2_switch_cmoc
if %s%==7 goto 2_2
if %s%==r goto begin_main
if %s%==R goto begin_main
goto 2_choose_custom_install_type2
:2_switch_fore_news
if %custominstall_news_fore%==1 set /a custominstall_news_fore=0&goto 2_choose_custom_install_type2
if %custominstall_news_fore%==0 set /a custominstall_news_fore=1&goto 2_choose_custom_install_type2
:2_switch_region
if %evcregion%==1 set /a evcregion=2&goto 2_choose_custom_install_type2
if %evcregion%==2 set /a evcregion=1&goto 2_choose_custom_install_type2
:2_switch_fore-news-wiimail
if %custominstall_ios%==1 set /a custominstall_ios=0&goto 2_choose_custom_install_type2
if %custominstall_ios%==0 set /a custominstall_ios=1&goto 2_choose_custom_install_type2
:2_switch_evc
if %custominstall_evc%==1 set /a custominstall_evc=0&goto 2_choose_custom_install_type2
if %custominstall_evc%==0 set /a custominstall_evc=1&goto 2_choose_custom_install_type2
:2_switch_nc
if %custominstall_nc%==1 set /a custominstall_nc=0&goto 2_choose_custom_install_type2
if %custominstall_nc%==0 set /a custominstall_nc=1&goto 2_choose_custom_install_type2
:2_switch_cmoc
if %custominstall_cmoc%==1 set /a custominstall_cmoc=0&goto 2_choose_custom_install_type2
if %custominstall_cmoc%==0 set /a custominstall_cmoc=1&goto 2_choose_custom_install_type2
	



:2_auto
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string214% %username%, %string215%
echo.
echo %string216%
echo %string217%
echo.
echo %string218%
echo.
echo %string219% %string204%, %string205%, %string207% %string220% %string206%, %string221% 
echo %string222%
echo.
echo 1. %string183%
echo 2. %string184%
set /p s=%string223%: 
if %s%==1 set /a evcregion=1& goto 2_1
if %s%==2 set /a evcregion=2& goto 2_1
goto 2_auto
:2_1
set /a custominstall_ios=1
set /a custominstall_evc=1
set /a custominstall_nc=1
set /a custominstall_cmoc=1
set /a custominstall_news_fore=1	
setlocal disableDelayedExpansion
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string224%
echo %string225% :)
echo.
echo %string226% 
echo %string227%
echo.
echo %string436%
echo.
echo 1. %string229%
echo 2. %string230%
set /p s=
set sdcard=NUL
if %s%==1 set /a sdcardstatus=1& set tempgotonext=2_1_summary& goto detect_sd_card
if %s%==2 set /a sdcardstatus=0& set /a sdcard=NUL& goto 2_1_summary
goto 2_1
:detect_sd_card
setlocal enableDelayedExpansion
set sdcard=NUL
set counter=-1
set letters=ABDEFGHIJKLMNOPQRSTUVWXYZ
set looking_for=
:detect_sd_card_2
set /a counter=%counter%+1
set looking_for=!letters:~%counter%,1!
if exist %looking_for%:/apps (
set sdcard=%looking_for%
call :%tempgotonext%
exit
exit
)

if %looking_for%==Z (
set sdcard=NUL
setlocal disableDelayedExpansion
call :%tempgotonext%
exit
exit
)
goto detect_sd_card_2

:2_1_summary
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
if %sdcardstatus%==0 echo %string231%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string232%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string233%
if %sdcardstatus%==1 if %sdcard%==NUL echo.
if %sdcardstatus%==1 if %sdcard%==NUL echo %string234%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string235% %sdcard%
if %sdcardstatus%==1 if not %sdcard%==NUL echo %string236%	
echo.
echo %string437%
echo.

echo %string109%
if %sdcardstatus%==0 echo 1. %string239%  2. %string240%
if %sdcardstatus%==1 if %sdcard%==NUL echo 1. %string239% 2. %string240% 3. %string241%
if %sdcardstatus%==1 if not %sdcard%==NUL echo 1. %string239% 2. %string240% 3. %string241%

set /p s=%string26%: 
if %s%==1 goto check_for_wad_folder_wii
if %s%==2 goto begin_main
if %s%==3 goto 2_change_drive_letter
goto 2_1_summary
:check_for_wad_folder_wii
if not exist "WAD" goto 2_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string242%
echo %string243%
echo.
echo %string244%
echo 1. %string245%
echo 2. %string246%
set /p s=%string26%: 
if %s%==1 rmdir /s /q "WAD"
if %s%==1 goto 2_2
if %s%==2 goto 2_1_summary
goto check_for_wad_folder_wii

:2_change_drive_letter
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo [*] SD Card
echo.
echo %string113%: %sdcard%
echo.
echo %string114%
set /p sdcard=
goto 2_1_summary
:2_change_drive_letter_wiiu
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo [*] SD Card
echo.
echo %string113%: %sdcard%
echo.
echo %string114%
set /p sdcard=
goto 2_1_summary_wiiu
:2_2
cls
set /a troubleshoot_auto_tool_notification=0
set /a temperrorlev=0
set /a counter_done=0
set /a percent=0
set /a temperrorlev=0

::
set /a progress_downloading=0
set /a progress_ios=0
set /a progress_news_fore=0
set /a progress_evc=0
set /a progress_nc=0
set /a progress_cmoc=0
set /a progress_finishing=0
set /a wiiu_return=0

>"%MainFolder%\patching_output.txt" echo Begin saving output.
>>"%MainFolder%\patching_output.txt" echo.

goto random_funfact
:random_funfact

:: Get start time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
set /a funfact_number=%random% %% (1 + 30)
if /i %funfact_number% LSS 1 goto random_funfact
if /i %funfact_number% GTR 30 goto random_funfact
if %funfact_number%==1 set funfact=%string438%
if %funfact_number%==2 set funfact=%string439%
if %funfact_number%==3 set funfact=%string440%
if %funfact_number%==4 set funfact=%string441%
if %funfact_number%==5 set funfact=%string442%
if %funfact_number%==6 set funfact=%string443%
if %funfact_number%==7 set funfact=%string444%
if %funfact_number%==8 set funfact=%string445%
if %funfact_number%==9 set funfact=%string446%
if %funfact_number%==10 set funfact=%string447%
if %funfact_number%==11 set funfact=%string448%
if %funfact_number%==12 set funfact=%string449%
if %funfact_number%==13 set funfact=%string450%
if %funfact_number%==14 set funfact=%string451%
if %funfact_number%==15 set funfact=%string452%
if %funfact_number%==16 set funfact=%string453%
if %funfact_number%==17 set funfact=%string454%
if %funfact_number%==18 set funfact=%string455%
if %funfact_number%==19 set funfact=%string456%
if %funfact_number%==20 set funfact=%string457%
if %funfact_number%==21 set funfact=%string458%
if %funfact_number%==22 set funfact=%string459%
if %funfact_number%==23 set funfact=%string460%
if %funfact_number%==24 set funfact=%string461%
if %funfact_number%==25 set funfact=%string462%
if %funfact_number%==26 set funfact=%string463%
if %funfact_number%==27 set funfact=%string464%
if %funfact_number%==28 set funfact=%string465%
if %funfact_number%==29 set funfact=%string466%
if %funfact_number%==30 set funfact=%string467%


set /a percent=%percent%+1
if %wiiu_return%==1 goto 2_3_wiiu
goto 2_3
:2_3
:: Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem Get elapsed time:
set /A elapsed=end-start


rem Show elapsed time:
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=%mm%
if %ss% lss 10 set ss=%ss%
if %cc% lss 10 set cc=%cc%


if /i %percent% GTR 0 if /i %percent% LSS 10 set /a counter_done=0
if /i %percent% GTR 10 if /i %percent% LSS 20 set /a counter_done=1
if /i %percent% GTR 20 if /i %percent% LSS 30 set /a counter_done=2
if /i %percent% GTR 30 if /i %percent% LSS 40 set /a counter_done=3
if /i %percent% GTR 40 if /i %percent% LSS 50 set /a counter_done=4
if /i %percent% GTR 50 if /i %percent% LSS 60 set /a counter_done=5
if /i %percent% GTR 60 if /i %percent% LSS 70 set /a counter_done=6
if /i %percent% GTR 70 if /i %percent% LSS 80 set /a counter_done=7
if /i %percent% GTR 80 if /i %percent% LSS 90 set /a counter_done=8
if /i %percent% GTR 90 if /i %percent% LSS 100 set /a counter_done=9
if %percent%==100 set /a counter_done=10
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo  [*] %string247%

if %troubleshoot_auto_tool_notification%==1 echo :------------------------------------------------------------------------------------------------------------------------:
if %troubleshoot_auto_tool_notification%==1 echo   %string248%
if %troubleshoot_auto_tool_notification%==1 echo   %string249%
if %troubleshoot_auto_tool_notification%==1 echo :------------------------------------------------------------------------------------------------------------------------:
echo.

set /a refreshing_in=20-"%ss%">>NUL
echo ---------------------------------------------------------------------------------------------------------------------------
echo %string250%: %funfact%
echo ---------------------------------------------------------------------------------------------------------------------------
if /i %refreshing_in% GTR 0 echo %string251%... %refreshing_in% %string252%
if /i %refreshing_in% LEQ 0 echo %string251%... 0 %string252%
echo.
echo    %string253%:
if %counter_done%==0 echo :          : %percent% %%
if %counter_done%==1 echo :-         : %percent% %%
if %counter_done%==2 echo :--        : %percent% %%
if %counter_done%==3 echo :---       : %percent% %%
if %counter_done%==4 echo :----      : %percent% %%
if %counter_done%==5 echo :-----     : %percent% %%
if %counter_done%==6 echo :------    : %percent% %%
if %counter_done%==7 echo :-------   : %percent% %%
if %counter_done%==8 echo :--------  : %percent% %%
if %counter_done%==9 echo :--------- : %percent% %%
if %counter_done%==10 echo :----------: %percent% %%
echo.
if %progress_downloading%==0 echo [ ] %string254%
if %progress_downloading%==1 echo [X] %string254%
if %custominstall_ios%==1 if %progress_ios%==0 echo [ ] %string468%
if %custominstall_ios%==1 if %progress_ios%==1 echo [X] %string468%
if %custominstall_news_fore%==1 if %progress_news_fore%==0 echo [ ] %string469%
if %custominstall_news_fore%==1 if %progress_news_fore%==1 echo [X] %string469%
if %custominstall_evc%==1 if %progress_evc%==0 echo [ ] %string205%
if %custominstall_evc%==1 if %progress_evc%==1 echo [X] %string205%
if %custominstall_cmoc%==1 if %evcregion%==1 if %progress_cmoc%==0 echo [ ] %string256%
if %custominstall_cmoc%==1 if %evcregion%==1 if %progress_cmoc%==1 echo [X] %string256%
if %custominstall_cmoc%==1 if %evcregion%==2 if %progress_cmoc%==0 echo [ ] %string257%
if %custominstall_cmoc%==1 if %evcregion%==2 if %progress_cmoc%==1 echo [X] %string257%
if %custominstall_nc%==1 if %progress_nc%==0 echo [ ] %string206%
if %custominstall_nc%==1 if %progress_nc%==1 echo [X] %string206%
if %progress_finishing%==0 echo [ ] %string258%
if %progress_finishing%==1 echo [X] %string258%

>>"%MainFolder%\patching_output.txt" echo [%time:~0,8% / %date%] - %percent%%%

call :patching_fast_travel_%percent%
goto patching_fast_travel_100

::Download files
:patching_fast_travel_1
if exist 0001000148415045v512 rmdir /s /q 0001000148415045v512
if exist 0001000148415050v512 rmdir /s /q 0001000148415050v512

if exist 0001000148414A45v512 rmdir /s /q 0001000148414A45v512
if exist 0001000148414A50v512 rmdir /s /q 0001000148414A50v512
if exist 0001000148415450v1792 rmdir /s /q 0001000148415450v1792
if exist 0001000148415445v1792 rmdir /s /q 0001000148415445v1792 
if exist unpacked-temp rmdir /s /q unpacked-temp
if exist IOSPatcher rmdir /s /q IOSPatcher
if exist EVCPatcher rmdir /s /q EVCPatcher
if exist NCPatcher rmdir /s /q NCPatcher
if exist CMOCPatcher rmdir /s /q CMOCPatcher
if exist NewsChannelPatcher rmdir /s /q NewsChannelPatcher
if exist 00000001.app del /q 00000001.app
if exist 0001000248414650v7.wad del /q 0001000248414650v7.wad
if exist 0001000248414645v7.wad del /q 0001000248414645v7.wad
if exist 0001000248414750v7.wad del /q 0001000248414750v7.wad
if exist 0001000248414745v7.wad del /q 0001000248414745v7.wad
if exist 00000004.app del /q 00000004.app
if exist 00000001_NC.app del /q 00000001_NC.app


if not exist WAD md WAD
if exist NewsChannelPatcher rmdir /s /q NewsChannelPatcher
if not exist NewsChannelPatcher md NewsChannelPatcher
if not exist IOSPatcher md IOSPatcher
if not exist "IOSPatcher/00000006-31.delta" call curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/00000006-31.delta" --output IOSPatcher/00000006-31.delta >>"%MainFolder%\patching_output.txt"

set /a temperrorlev=%errorlevel%
set modul=Downloading 06-31.delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
if not exist "IOSPatcher/00000006-80.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/00000006-80.delta" --output IOSPatcher/00000006-80.delta>>"%MainFolder%\patching_output.txt"

set /a temperrorlev=%errorlevel%
set modul=Downloading 06-80.delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_2
if not exist "IOSPatcher/00000006-80.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/00000006-80.delta" --output IOSPatcher/00000006-80.delta>>"%MainFolder%\patching_output.txt"

set /a temperrorlev=%errorlevel%
set modul=Downloading 06-80.delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_3
if %processor_architecture%==x86 if not exist "IOSPatcher/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/libWiiSharp.dll" --output IOSPatcher/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "IOSPatcher/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/libWiiSharp_x64.dll" --output IOSPatcher/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"	
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "IOSPatcher/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/Sharpii.exe" --output IOSPatcher/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "IOSPatcher/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/Sharpii_x64.exe" --output IOSPatcher/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_4
if %processor_architecture%==x86 if not exist "IOSPatcher/WadInstaller.dll" curl -f -L -s -S  -s -S --insecure "%FilesHostedOn%/IOSPatcher/WadInstaller.dll" --output IOSPatcher/WadInstaller.dll>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "IOSPatcher/WadInstaller.dll" curl -f -L -s -S  -s -S --insecure "%FilesHostedOn%/IOSPatcher/WadInstaller_x64.dll" --output IOSPatcher/WadInstaller.dll>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading WadInstaller.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_5
if %processor_architecture%==x86 if not exist "IOSPatcher/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/xdelta3.exe" --output IOSPatcher/xdelta3.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "IOSPatcher/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/IOSPatcher/xdelta3_x64.exe" --output IOSPatcher/xdelta3.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
::EVC
:patching_fast_travel_6
if not exist EVCPatcher/patch md EVCPatcher\patch
if not exist EVCPatcher/dwn md EVCPatcher\dwn
if not exist EVCPatcher/dwn/0001000148414A45v512 md EVCPatcher\dwn\0001000148414A45v512
if not exist EVCPatcher/dwn/0001000148414A50v512 md EVCPatcher\dwn\0001000148414A50v512
if not exist EVCPatcher/pack md EVCPatcher\pack
if not exist "EVCPatcher/patch/Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/patch/Europe.delta" --output EVCPatcher/patch/Europe.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "EVCPatcher/patch/USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/patch/USA.delta" --output EVCPatcher/patch/USA.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading USA Delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_7
if %processor_architecture%==x86 if not exist "EVCPatcher/NUS_Downloader_Decrypt.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/NUS_Downloader_Decrypt.exe" --output EVCPatcher/NUS_Downloader_Decrypt.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/NUS_Decryptor_x64.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/NUS_Decryptor_x64.exe" --output EVCPatcher/NUS_Decryptor_x64.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading decrypter
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100

:patching_fast_travel_8
if %processor_architecture%==x86 if not exist "EVCPatcher/patch/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/patch/xdelta3.exe" --output EVCPatcher/patch/xdelta3.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/patch/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/patch/xdelta3_x64.exe" --output EVCPatcher/patch/xdelta3.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe

if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "EVCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/pack/libWiiSharp.dll" --output "EVCPatcher/pack/libWiiSharp.dll">>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/pack/libWiiSharp_x64.dll" --output "EVCPatcher/pack/libWiiSharp.dll">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "EVCPatcher/pack/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/pack/Sharpii.exe" --output EVCPatcher/pack/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/pack/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/pack/Sharpii_x64.exe" --output EVCPatcher/pack/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==x86 if not exist "EVCPatcher/dwn/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/dwn/Sharpii.exe" --output EVCPatcher/dwn/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/dwn/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/dwn/Sharpii_x64.exe" --output EVCPatcher/dwn/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_9
if %processor_architecture%==x86 if not exist "EVCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/dwn/libWiiSharp.dll" --output EVCPatcher/dwn/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "EVCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/dwn/libWiiSharp_x64.dll" --output EVCPatcher/dwn/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_10
if not exist "EVCPatcher/dwn/0001000148414A45v512/cetk" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/dwn/0001000148414A45v512/cetk" --output EVCPatcher/dwn/0001000148414A45v512/cetk>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading USA CETK
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "EVCPatcher/dwn/0001000148414A50v512/cetk" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/dwn/0001000148414A50v512/cetk" --output EVCPatcher/dwn/0001000148414A50v512/cetk>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading EUR CETK
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100

::CMOC
:patching_fast_travel_11
if not exist CMOCPatcher/patch md CMOCPatcher\patch
if not exist CMOCPatcher/dwn md CMOCPatcher\dwn
if not exist CMOCPatcher/dwn/0001000148415045v512 md CMOCPatcher\dwn\0001000148415045v512
if not exist CMOCPatcher/dwn/0001000148415050v512 md CMOCPatcher\dwn\0001000148415050v512
if not exist CMOCPatcher/pack md CMOCPatcher\pack
if not exist "CMOCPatcher/patch/00000001_Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000001_Europe.delta" --output CMOCPatcher/patch/00000001_Europe.delta>>"%MainFolder%\patching_output.txt"
if not exist "CMOCPatcher/patch/00000004_Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000004_Europe.delta" --output CMOCPatcher/patch/00000004_Europe.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_12
if not exist "CMOCPatcher/patch/00000001_USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000001_USA.delta" --output CMOCPatcher/patch/00000001_USA.delta>>"%MainFolder%\patching_output.txt"
if not exist "CMOCPatcher/patch/00000004_USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/patch/00000004_USA.delta" --output CMOCPatcher/patch/00000004_USA.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading USA Delta
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==x86 if not exist "CMOCPatcher/NUS_Downloader_Decrypt.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/NUS_Downloader_Decrypt.exe" --output CMOCPatcher/NUS_Downloader_Decrypt.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/NUS_Decryptor_x64.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/NUS_Decryptor_x64.exe" --output CMOCPatcher/NUS_Decryptor_x64.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading decrypter
if not %temperrorlev%==0 goto error_patching

echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_13
if %processor_architecture%==x86 if not exist "CMOCPatcher/patch/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/patch/xdelta3.exe" --output CMOCPatcher/patch/xdelta3.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/patch/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/patch/xdelta3_x64.exe" --output CMOCPatcher/patch/xdelta3.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "CMOCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/pack/libWiiSharp.dll" --output "CMOCPatcher/pack/libWiiSharp.dll">>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/pack/libWiiSharp_x64.dll" --output "CMOCPatcher/pack/libWiiSharp.dll">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "CMOCPatcher/pack/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/pack/Sharpii.exe" --output CMOCPatcher/pack/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/pack/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/pack/Sharpii_x64.exe" --output CMOCPatcher/pack/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "CMOCPatcher/dwn/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/Sharpii.exe" --output CMOCPatcher/dwn/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/dwn/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/Sharpii_x64.exe" --output CMOCPatcher/dwn/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==x86 if not exist "CMOCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/libWiiSharp.dll" --output CMOCPatcher/dwn/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "CMOCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/libWiiSharp_x64.dll" --output CMOCPatcher/dwn/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100

:patching_fast_travel_14
if not exist NewsChannelPatcher md NewsChannelPatcher

if not exist "NewsChannelPatcher/00000001_Forecast_Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/URL_Patches/Europe/00000001_Forecast.delta" --output "NewsChannelPatcher/00000001_Forecast_Europe.delta">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Forecast Channel files
echo cURL OK>>"%MainFolder%\patching_output.txt"
if not exist "NewsChannelPatcher/00000001_Forecast_USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/URL_Patches/USA/00000001_Forecast.delta" --output "NewsChannelPatcher/00000001_Forecast_USA.delta">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Forecast Channel files
echo cURL OK>>"%MainFolder%\patching_output.txt"
if not exist "NewsChannelPatcher/00000001_News_Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/URL_Patches/Europe/00000001_News.delta" --output "NewsChannelPatcher/00000001_News_Europe.delta">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
echo cURL OK>>"%MainFolder%\patching_output.txt"
if not exist "NewsChannelPatcher/00000001_News_USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/URL_Patches/USA/00000001_News.delta" --output "NewsChannelPatcher/00000001_News_USA.delta">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100

:patching_fast_travel_15
if %processor_architecture%==x86 if not exist "NewsChannelPatcher\libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/libWiiSharp.dll" --output "NewsChannelPatcher/libWiiSharp.dll">>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NewsChannelPatcher\libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/libWiiSharp_x64.dll" --output "NewsChannelPatcher/libWiiSharp.dll">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100

:patching_fast_travel_16
if %processor_architecture%==x86 if not exist "NewsChannelPatcher\Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/Sharpii.exe" --output "NewsChannelPatcher/Sharpii.exe">>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NewsChannelPatcher\Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/Sharpii_x64.exe" --output "NewsChannelPatcher/Sharpii.exe">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100

:patching_fast_travel_17
if %processor_architecture%==x86 if not exist "NewsChannelPatcher\WadInstaller.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/WadInstaller.dll" --output "NewsChannelPatcher/WadInstaller.dll">>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NewsChannelPatcher\WadInstaller.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/WadInstaller_x64.dll" --output "NewsChannelPatcher/WadInstaller.dll">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==x86 if not exist "NewsChannelPatcher\xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/xdelta3.exe" --output "NewsChannelPatcher/xdelta3.exe">>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NewsChannelPatcher\xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NewsChannelPatcher/xdelta3_x64.exe" --output "NewsChannelPatcher/xdelta3.exe">>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading News Channel files
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100

:patching_fast_travel_18
if not exist "CMOCPatcher/dwn/0001000148415045v512/cetk" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415045v512/cetk" --output CMOCPatcher/dwn/0001000148415045v512/cetk>>"%MainFolder%\patching_output.txt"
if not exist "CMOCPatcher/dwn/0001000148415045v512/cert" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415045v512/cert" --output CMOCPatcher/dwn/0001000148415045v512/cert>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading USA CETK
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_19
if not exist "CMOCPatcher/dwn/0001000148415050v512/cetk" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415050v512/cetk" --output CMOCPatcher/dwn/0001000148415050v512/cetk>>"%MainFolder%\patching_output.txt"
if not exist "CMOCPatcher/dwn/0001000148415050v512/cert" curl -f -L -s -S  --insecure "%FilesHostedOn%/CMOCPatcher/dwn/0001000148415050v512/cert" --output CMOCPatcher/dwn/0001000148415050v512/cert>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading EUR CETK
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100


::NC
:patching_fast_travel_20
if not exist NCPatcher/patch md NCPatcher\patch
if not exist NCPatcher/dwn md NCPatcher\dwn
if not exist NCPatcher/dwn/0001000148415450v1792 md NCPatcher\dwn\0001000148415450v1792
if not exist NCPatcher/dwn/0001000148415445v1792 md NCPatcher\dwn\0001000148415445v1792
if not exist NCPatcher/pack md NCPatcher\pack
if not exist "NCPatcher/patch/Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/patch/Europe.delta" --output NCPatcher/patch/Europe.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta [NC]
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "NCPatcher/patch/USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/patch/USA.delta" --output NCPatcher/patch/USA.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading USA Delta [NC]
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "NCPatcher/NUS_Downloader_Decrypt.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/NUS_Downloader_Decrypt.exe" --output NCPatcher/NUS_Downloader_Decrypt.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NCPatcher/NUS_Decryptor_x64.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/NUS_Decryptor_x64.exe" --output NCPatcher/NUS_Decryptor_x64.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Decrypter
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_21
if %processor_architecture%==x86 if not exist "NCPatcher/patch/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/patch/xdelta3.exe" --output NCPatcher/patch/xdelta3.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NCPatcher/patch/xdelta3.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/patch/xdelta3_x64.exe" --output NCPatcher/patch/xdelta3.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading xdelta3.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "NCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/pack/libWiiSharp.dll" --output NCPatcher/pack/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NCPatcher/pack/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/pack/libWiiSharp_x64.dll" --output NCPatcher/pack/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if %processor_architecture%==x86 if not exist "NCPatcher/pack/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/pack/Sharpii.exe" --output NCPatcher/pack/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NCPatcher/pack/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/pack/Sharpii_x64.exe" --output NCPatcher/pack/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_22
if %processor_architecture%==x86 if not exist "NCPatcher/dwn/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/dwn/Sharpii.exe" --output NCPatcher/dwn/Sharpii.exe>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NCPatcher/dwn/Sharpii.exe" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/dwn/Sharpii_x64.exe" --output NCPatcher/dwn/Sharpii.exe>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Sharpii.exe
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_23
if %processor_architecture%==x86 if not exist "NCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/dwn/libWiiSharp.dll" --output NCPatcher/dwn/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
if %processor_architecture%==AMD64 if not exist "NCPatcher/dwn/libWiiSharp.dll" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/dwn/libWiiSharp_x64.dll" --output NCPatcher/dwn/libWiiSharp.dll>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading libWiiSharp.dll
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_24
if not exist "NCPatcher/dwn/0001000148415445v1792/cetk" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/dwn/0001000148415445v1792/cetk" --output NCPatcher/dwn/0001000148415445v1792/cetk>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading USA CETK
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "NCPatcher/dwn/0001000148415450v1792/cetk" curl -f -L -s -S  --insecure "%FilesHostedOn%/NCPatcher/dwn/0001000148415450v1792/cetk" --output NCPatcher/dwn/0001000148415450v1792/cetk>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading EUR CETK
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100

::Everything else
:patching_fast_travel_25
if not exist apps md apps
if not exist apps/Mail-Patcher md apps\Mail-Patcher
if not exist "apps/Mail-Patcher/boot.dol" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/Mail-Patcher/boot.dol" --output apps/Mail-Patcher/boot.dol>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Mail Patcher
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"


if not exist "apps/Mail-Patcher/icon.png" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/Mail-Patcher/icon.png" --output apps/Mail-Patcher/icon.png>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Mail Patcher
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"


if not exist "apps/Mail-Patcher/meta.xml" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/Mail-Patcher/meta.xml" --output apps/Mail-Patcher/meta.xml>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Mail Patcher
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100


:patching_fast_travel_26
if not exist apps/WiiModLite md apps\WiiModLite
if not exist apps/Mail-Patcher md apps\Mail-Patcher
if not exist "apps/WiiModLite/boot.dol" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/WiiModLite/boot.dol" --output apps/WiiModLite/boot.dol>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "apps/WiiModLite/database.txt" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/WiiModLite/database.txt" --output apps/WiiModLite/database.txt>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_27
if not exist "apps/WiiModLite/icon.png" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/WiiModLite/icon.png" --output apps/WiiModLite/icon.png>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "apps/WiiModLite/icon.png" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/WiiModLite/icon.png" --output apps/WiiModLite/icon.png>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100

:patching_fast_travel_28
if not exist "apps/WiiModLite/meta.xml" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/WiiModLite/meta.xml" --output apps/WiiModLite/meta.xml>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "apps/WiiModLite/wiimod.txt" curl -f -L -s -S  --insecure "%FilesHostedOn%/apps/WiiModLite/wiimod.txt" --output apps/WiiModLite/wiimod.txt>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_29
if not exist "EVCPatcher/patch/Europe.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%EVCPatcher/patch/Europe.delta" --output EVCPatcher/patch/Europe.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Europe Delta
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
:patching_fast_travel_30
if not exist "EVCPatcher/patch/USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/patch/USA.delta" --output EVCPatcher/patch/USA.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "EVCPatcher/patch/USA.delta" curl -f -L -s -S  --insecure "%FilesHostedOn%/EVCPatcher/patch/USA.delta" --output EVCPatcher/patch/USA.delta>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set modul=Downloading Wii Mod Lite
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"

if not exist "cert.sys" curl -f -L -s -S  --insecure "%FilesHostedOn%/cert.sys" --output cert.sys>>"%MainFolder%\patching_output.txt"
set /a temperrorlev=%errorlevel%
set /a progress_downloading=1
set modul=Downloading cert.sys
if not %temperrorlev%==0 goto error_patching
echo cURL OK>>"%MainFolder%\patching_output.txt"



goto patching_fast_travel_100

::IOS Patcher
:patching_fast_travel_31
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe NUSD -IOS 31 -v latest -o IOSPatcher\IOS31-old.wad -wad>>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe NUSD -IOS 80 -v latest -o IOSPatcher\IOS80-old.wad -wad>>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe WAD -u IOSPatcher\IOS31-old.wad IOSPatcher/IOS31/ >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe WAD -u IOSPatcher\IOS80-old.wad IOSPatcher\IOS80/ >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 move /y IOSPatcher\IOS31\00000006.app IOSPatcher\00000006.app >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=move.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_32
if %custominstall_ios%==1 call IOSPatcher\xdelta3.exe -f -d -s IOSPatcher\00000006.app IOSPatcher\00000006-31.delta IOSPatcher\IOS31\00000006.app >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=xdelta.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_33
if %custominstall_ios%==1 move /y IOSPatcher\IOS80\00000006.app IOSPatcher\00000006.app >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=move.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 call IOSPatcher\xdelta3.exe -f -d -s IOSPatcher\00000006.app IOSPatcher\00000006-80.delta IOSPatcher\IOS80\00000006.app >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=xdelta3.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 if not exist IOSPatcher\WAD mkdir IOSPatcher\WAD
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=mkdir.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_34
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe WAD -p IOSPatcher\IOS31\ "WAD\IOS31 Wii Only (IOS) (RiiConnect24).wad" -fs -es -np -vp >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe WAD -p IOSPatcher\IOS80\ "WAD\IOS80 Wii Only (IOS) (RiiConnect24).wad" -fs -es -np -vp >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
:patching_fast_travel_35
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe IOS "WAD\IOS31 Wii Only (IOS) (RiiConnect24).wad" -fs -es -np -vp >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe Adding vulns to IOS31
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching

if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe IOS "WAD\IOS80 Wii Only (IOS) (RiiConnect24).wad" -fs -es -np -vp >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe Adding vulns to IOS80
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching


if %custominstall_ios%==1 del IOSPatcher\00000006.app /q >NUL
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=del.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 del IOSPatcher\IOS31-old.wad /q >NUL
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=del.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 del IOSPatcher\IOS80-old.wad /q >NUL
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=del.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 if exist IOSPatcher\IOS31 rmdir /s /q IOSPatcher\IOS31 >NUL
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=rmdir.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_ios%==1 if exist IOSPatcher\IOS80 rmdir /s /q IOSPatcher\IOS80 >NUL
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=rmdir.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_36
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe IOS "WAD\IOS31 Wii Only (IOS) (RiiConnect24).wad" -fs -es -np -vp >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_37
if %custominstall_ios%==1 call IOSPatcher\Sharpii.exe IOS "WAD\IOS80 Wii Only (IOS) (RiiConnect24).wad" -fs -es -np -vp >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 set /a temperrorlev=%errorlevel%
if %custominstall_ios%==1 set modul=Sharpii.exe
if %custominstall_ios%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_38
if %custominstall_ios%==1 if not exist WAD md WAD
if %custominstall_ios%==1 move "IOSPatcher\WAD\IOS31 Wii Only (IOS) (RiiConnect24).wad" "WAD" >>"%MainFolder%\patching_output.txt"
if %custominstall_ios%==1 move "IOSPatcher\WAD\IOS80 Wii Only (IOS) (RiiConnect24).wad" "WAD" >>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_39
if %custominstall_ios%==1 if exist IOSPatcher rmdir /s /q IOSPatcher 
if %custominstall_ios%==1 set /a progress_ios=1
goto patching_fast_travel_100

::News/Forecast Channel
::News
:patching_fast_travel_40
if %custominstall_news_fore%==1 if not exist NewsChannelPatcher md NewsChannelPatcher
if %custominstall_news_fore%==1 if %evcregion%==1 call NewsChannelPatcher\sharpii.exe nusd -ID 0001000248414750 -v 7 -wad >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==1 set modul=Downloading News Channel
if %custominstall_news_fore%==1 	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==2 call NewsChannelPatcher\sharpii.exe nusd -ID 0001000248414745 -v 7 -wad >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==2 set modul=Downloading News Channel
if %custominstall_news_fore%==1 	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_42

if %custominstall_news_fore%==1 if %evcregion%==1 call NewsChannelPatcher\sharpii.exe wad -u 0001000248414750v7.wad unpacked-temp/ >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==1 set modul=Unpacking News Channel
if %custominstall_news_fore%==1 	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==2 call NewsChannelPatcher\sharpii.exe wad -u 0001000248414745v7.wad unpacked-temp/ >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==2 set modul=Unpacking News Channel
if %custominstall_news_fore%==1 	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_43
if %custominstall_news_fore%==1 move "unpacked-temp\00000001.app" "source.app"
if %custominstall_news_fore%==1 	set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	set modul=Moving News Channel 0000001.app
if %custominstall_news_fore%==1 	if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==1 call NewsChannelPatcher\xdelta3 -d -f -s source.app NewsChannelPatcher\00000001_News_Europe.delta unpacked-temp\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 if %evcregion%==2 call NewsChannelPatcher\xdelta3 -d -f -s source.app NewsChannelPatcher\00000001_News_USA.delta unpacked-temp\00000001.app >>"%MainFolder%\patching_output.txt"

if %custominstall_news_fore%==1 	set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	set modul=Patching News Channel delta
if %custominstall_news_fore%==1 	if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_44
if %custominstall_news_fore%==1 if %evcregion%==1 NewsChannelPatcher\sharpii.exe wad -p unpacked-temp/ "WAD\News Channel (Europe) (Channel) (RiiConnect24).wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==1 set modul=Packing News Channel
if %custominstall_news_fore%==1 	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==2 NewsChannelPatcher\sharpii.exe wad -p unpacked-temp/ "WAD\News Channel (USA) (Channel) (RiiConnect24).wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==2 set modul=Packing News Channel
if %custominstall_news_fore%==1 	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 	rmdir /s /q unpacked-temp
goto patching_fast_travel_100

::Forecast
:patching_fast_travel_45
if %custominstall_news_fore%==1 if %evcregion%==1 call NewsChannelPatcher\sharpii.exe nusd -ID 0001000248414650 -v 7 -wad >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==1 set modul=Downloading Forecast Channel
if %custominstall_news_fore%==1 	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==2 call NewsChannelPatcher\sharpii.exe nusd -ID 0001000248414645 -v 7 -wad >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==2 set modul=Downloading Forecast Channel
if %custominstall_news_fore%==1 	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_46

if %custominstall_news_fore%==1 if %evcregion%==1 call NewsChannelPatcher\sharpii.exe wad -u 0001000248414650v7.wad unpacked-temp >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==1 set modul=Unpacking Forecast Channel
if %custominstall_news_fore%==1 	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==2 call NewsChannelPatcher\sharpii.exe wad -u 0001000248414645v7.wad unpacked-temp/ >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==2 set modul=Unpacking Forecast Channel
if %custominstall_news_fore%==1 	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_47
if %custominstall_news_fore%==1 ren unpacked-temp\00000001.app source.app
if %custominstall_news_fore%==1 	set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	set modul=Moving Forecast Channel 0000001.app
if %custominstall_news_fore%==1 	if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==1 call NewsChannelPatcher\xdelta3 -d -f -s unpacked-temp\source.app NewsChannelPatcher\00000001_Forecast_Europe.delta unpacked-temp\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 if %evcregion%==2 call NewsChannelPatcher\xdelta3 -d -f -s unpacked-temp\source.app NewsChannelPatcher\00000001_Forecast_USA.delta unpacked-temp\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	set modul=Patching Forecast Channel delta
if %custominstall_news_fore%==1 	if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_49
if %custominstall_news_fore%==1 if %evcregion%==1 NewsChannelPatcher\sharpii.exe wad -p unpacked-temp/ "WAD\Forecast Channel (Europe) (Channel) (RiiConnect24).wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==1 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==1 set modul=Packing Forecast Channel
if %custominstall_news_fore%==1 	if %evcregion%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_news_fore%==1 if %evcregion%==2 NewsChannelPatcher\sharpii.exe wad -p unpacked-temp/ "WAD\Forecast Channel (USA) (Channel) (RiiConnect24).wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_news_fore%==1 	if %evcregion%==2 set /a temperrorlev=%errorlevel%
if %custominstall_news_fore%==1 	if %evcregion%==2 set modul=Packing Forecast Channel
if %custominstall_news_fore%==1 	if %evcregion%==2 if not %temperrorlev%==0 goto error_patching
set /a progress_news_fore=1
goto patching_fast_travel_100

::EVC Patcher
:patching_fast_travel_50
if %custominstall_evc%==1 if not exist 0001000148414A50v512 md 0001000148414A50v512
if %custominstall_evc%==1 if not exist 0001000148414A45v512 md 0001000148414A45v512
if %custominstall_evc%==1 if not exist 0001000148414A50v512\cetk copy /y "EVCPatcher\dwn\0001000148414A50v512\cetk" "0001000148414A50v512\cetk" >>"%MainFolder%\patching_output.txt"

if %custominstall_evc%==1 if not exist 0001000148414A45v512\cetk copy /y "EVCPatcher\dwn\0001000148414A45v512\cetk" "0001000148414A45v512\cetk" >>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
::USA
:patching_fast_travel_52
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\dwn\sharpii.exe NUSD -ID 0001000148414A45 -v 512 -encrypt >>"%MainFolder%\patching_output.txt"
::PAL
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\dwn\sharpii.exe NUSD -ID 0001000148414A50 -v 512 -encrypt >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Downloading EVC
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_54
if %custominstall_evc%==1 if %evcregion%==1 if %processor_architecture%==x86 copy /y "EVCPatcher\NUS_Downloader_Decrypt.exe" "0001000148414A50v512"&copy "cert.sys" "0001000148414A50v512" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 if %processor_architecture%==x86 copy /y "EVCPatcher\NUS_Downloader_Decrypt.exe" "0001000148414A45v512"&copy "cert.sys" "0001000148414A45v512" >>"%MainFolder%\patching_output.txt"

if %custominstall_evc%==1 if %evcregion%==1 if %processor_architecture%==AMD64 copy /y "EVCPatcher\NUS_Decryptor_x64.exe" "0001000148414A50v512"&copy "cert.sys" "0001000148414A50v512" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 if %processor_architecture%==AMD64 copy /y "EVCPatcher\NUS_Decryptor_x64.exe" "0001000148414A45v512"&copy "cert.sys" "0001000148414A45v512" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Copying NDC.exe
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_56
if %custominstall_evc%==1 if %evcregion%==1 ren "0001000148414A50v512\tmd.512" "tmd" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 ren "0001000148414A45v512\tmd.512" "tmd" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Renaming files [Delete everything except RiiConnect24Patcher.bat]
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_57
if %custominstall_evc%==1 if %evcregion%==1 cd 0001000148414A50v512
if %custominstall_evc%==1 if %processor_architecture%==x86 if %evcregion%==1 call NUS_Downloader_Decrypt.exe >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %processor_architecture%==AMD64 if %evcregion%==1 call NUS_Decryptor_x64.exe cetk >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 cd 0001000148414A45v512
if %custominstall_evc%==1 if %processor_architecture%==x86 if %evcregion%==2 call NUS_Downloader_Decrypt.exe >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %processor_architecture%==AMD64 if %evcregion%==2 call NUS_Decryptor_x64.exe cetk >>"%MainFolder%\patching_output.txt"

if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Decrypter error
if %custominstall_evc%==1 if not %temperrorlev%==0 cd..& goto error_patching
if %custominstall_evc%==1 cd..
goto patching_fast_travel_100
:patching_fast_travel_60
if %custominstall_evc%==1 if %evcregion%==1 ren "0001000148414A50v512\*.wad" "HAJP.wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 ren "0001000148414A45v512\*.wad" "HAJE.wad" >>"%MainFolder%\patching_output.txt"


if %custominstall_evc%==1 if %evcregion%==1 move /y "0001000148414A50v512\HAJP.wad" "EVCPatcher\pack" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 move /y "0001000148414A45v512\HAJE.wad" "EVCPatcher\pack" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=move.exe
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_62
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\pack\Sharpii.exe WAD -u EVCPatcher\pack\HAJP.wad EVCPatcher\pack\unencrypted >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\pack\Sharpii.exe WAD -u EVCPatcher\pack\HAJE.wad EVCPatcher\pack\unencrypted >>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_63
if %custominstall_evc%==1 move /y "EVCPatcher\pack\unencrypted\00000001.app" "00000001.app" >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=move.exe
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_65
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\patch\xdelta3.exe -f -d -s 00000001.app EVCPatcher\patch\Europe.delta EVCPatcher\pack\unencrypted\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\patch\xdelta3.exe -f -d -s 00000001.app EVCPatcher\patch\USA.delta EVCPatcher\pack\unencrypted\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=xdelta.exe EVC
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_67
if %custominstall_evc%==1 if %evcregion%==1 call EVCPatcher\pack\Sharpii.exe WAD -p "EVCPatcher\pack\unencrypted" "WAD\Everybody Votes Channel (Europe) (Channel) (RiiConnect24)" -f >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 if %evcregion%==2 call EVCPatcher\pack\Sharpii.exe WAD -p "EVCPatcher\pack\unencrypted" "WAD\Everybody Votes Channel (USA) (Channel) (RiiConnect24)" -f >>"%MainFolder%\patching_output.txt"
if %custominstall_evc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_evc%==1 set modul=Packing EVC WAD
if %custominstall_evc%==1 set /a progress_evc=1
if %custominstall_evc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100

::CMOC
:patching_fast_travel_68
if %custominstall_cmoc%==1 if not exist 0001000148415050v512 md 0001000148415050v512
if %custominstall_cmoc%==1 if not exist 0001000148415045v512 md 0001000148415045v512
if %custominstall_cmoc%==1 if not exist 0001000148415050v512\cetk copy /y "CMOCPatcher\dwn\0001000148415050v512\cetk" "0001000148415050v512\cetk" >>"%MainFolder%\patching_output.txt"

if %custominstall_cmoc%==1 if not exist 0001000148415045v512\cetk copy /y "CMOCPatcher\dwn\0001000148415045v512\cetk" "0001000148415045v512\cetk" >>"%MainFolder%\patching_output.txt"

goto patching_fast_travel_100
::USA
:patching_fast_travel_70
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415045 -v 512 -encrypt >>"%MainFolder%\patching_output.txt"
::PAL
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415050 -v 512 -encrypt >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Downloading CMOC
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_71
if %custominstall_cmoc%==1 if %processor_architecture%==x86 if %evcregion%==1 copy /y "CMOCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415050v512" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %processor_architecture%==x86 if %evcregion%==2 copy /y "CMOCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415045v512" >>"%MainFolder%\patching_output.txt"

if %custominstall_cmoc%==1 if %processor_architecture%==AMD64 if %evcregion%==1 copy /y "CMOCPatcher\NUS_Decryptor_x64.exe" "0001000148415050v512"&copy "cert.sys" "0001000148415050v512" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %processor_architecture%==AMD64 if %evcregion%==2 copy /y "CMOCPatcher\NUS_Decryptor_x64.exe" "0001000148415045v512"&copy "cert.sys" "0001000148415045v512" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Copying NDC.exe
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_72
if %custominstall_cmoc%==1 if %evcregion%==1 ren "0001000148415050v512\tmd.512" "tmd" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 ren "0001000148415045v512\tmd.512" "tmd" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Renaming files [Delete everything except RiiConnect24Patcher.bat]
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching

if %custominstall_cmoc%==1 if %evcregion%==1 cd 0001000148415050v512
if %custominstall_cmoc%==1 if %processor_architecture%==x86 if %evcregion%==1 call NUS_Downloader_Decrypt.exe >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %processor_architecture%==AMD64 if %evcregion%==1 call NUS_Decryptor_x64.exe cetk >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 cd 0001000148415045v512
if %custominstall_cmoc%==1 if %processor_architecture%==x86 if %evcregion%==2 call NUS_Downloader_Decrypt.exe >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %processor_architecture%==AMD64 if %evcregion%==2 call NUS_Decryptor_x64.exe cetk >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Decrypter error
if %custominstall_cmoc%==1 if not %temperrorlev%==0 cd..& goto error_patching
if %custominstall_cmoc%==1 cd..
goto patching_fast_travel_100
:patching_fast_travel_74
if %custominstall_cmoc%==1 if %evcregion%==1 ren "0001000148415050v512\*.wad" "HAPP.wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 ren "0001000148415045v512\*.wad" "HAPE.wad" >>"%MainFolder%\patching_output.txt"


if %custominstall_cmoc%==1 if %evcregion%==1 move /y "0001000148415050v512\HAPP.wad" "CMOCPatcher\pack" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 move /y "0001000148415045v512\HAPE.wad" "CMOCPatcher\pack" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=move.exe
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_75
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\pack\Sharpii.exe WAD -u CMOCPatcher\pack\HAPP.wad CMOCPatcher\pack\unencrypted >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\pack\Sharpii.exe WAD -u CMOCPatcher\pack\HAPE.wad CMOCPatcher\pack\unencrypted >>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_76
if %custominstall_cmoc%==1 move /y "CMOCPatcher\pack\unencrypted\00000001.app" "00000001.app" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 move /y "CMOCPatcher\pack\unencrypted\00000004.app" "00000004.app" >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=move.exe
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_77
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000001.app CMOCPatcher\patch\00000001_Europe.delta CMOCPatcher\pack\unencrypted\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000004.app CMOCPatcher\patch\00000004_Europe.delta CMOCPatcher\pack\unencrypted\00000004.app >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000001.app CMOCPatcher\patch\00000001_USA.delta CMOCPatcher\pack\unencrypted\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\patch\xdelta3.exe -f -d -s 00000004.app CMOCPatcher\patch\00000004_USA.delta CMOCPatcher\pack\unencrypted\00000004.app >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=xdelta.exe CMOC
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_79
if %custominstall_cmoc%==1 if %evcregion%==1 call CMOCPatcher\pack\Sharpii.exe WAD -p "CMOCPatcher\pack\unencrypted" "WAD\Mii Contest Channel (Europe) (Channel) (RiiConnect24)" -f >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 if %evcregion%==2 call CMOCPatcher\pack\Sharpii.exe WAD -p "CMOCPatcher\pack\unencrypted" "WAD\Check Mii Out Channel (USA) (Channel) (RiiConnect24)" -f >>"%MainFolder%\patching_output.txt"
if %custominstall_cmoc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_cmoc%==1 set modul=Packing CMOC WAD
if %custominstall_cmoc%==1 set /a progress_cmoc=1
if %custominstall_cmoc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100

::NC

:patching_fast_travel_81
if %custominstall_nc%==1 if not exist 0001000148415450v1792 md 0001000148415450v1792
if %custominstall_nc%==1 if not exist 0001000148415445v1792 md 0001000148415445v1792
if %custominstall_nc%==1 if not exist 0001000148415450v1792\cetk copy /y "NCPatcher\dwn\0001000148415450v1792\cetk" "0001000148415450v1792\cetk" >>"%MainFolder%\patching_output.txt"

if %custominstall_nc%==1 if not exist 0001000148415445v1792\cetk copy /y "NCPatcher\dwn\0001000148415445v1792\cetk" "0001000148415445v1792\cetk" >>"%MainFolder%\patching_output.txt"

:patching_fast_travel_85
::USA
if %custominstall_nc%==1 if %evcregion%==2 call NCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415445 -v 1792 -encrypt >>"%MainFolder%\patching_output.txt"
::PAL
if %custominstall_nc%==1 if %evcregion%==1 call NCPatcher\dwn\sharpii.exe NUSD -ID 0001000148415450 -v 1792 -encrypt >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=Downloading NC
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_86
if %custominstall_nc%==1 if %processor_architecture%==x86 if %evcregion%==1 copy /y "NCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415450v1792" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %processor_architecture%==AMD64 if %evcregion%==1 copy /y "NCPatcher\NUS_Decryptor_x64.exe" "0001000148415450v1792"& copy "cert.sys" "0001000148415450v1792" >>"%MainFolder%\patching_output.txt"

if %custominstall_nc%==1 if %processor_architecture%==x86 if %evcregion%==2 copy /y "NCPatcher\NUS_Downloader_Decrypt.exe" "0001000148415445v1792" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %processor_architecture%==AMD64 if %evcregion%==2 copy /y "NCPatcher\NUS_Decryptor_x64.exe" "0001000148415445v1792"& copy "cert.sys" "0001000148415445v1792" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=Copying NDC.exe
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_87
if %custominstall_nc%==1 if %evcregion%==1 ren "0001000148415450v1792\tmd.1792" "tmd" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %evcregion%==2 ren "0001000148415445v1792\tmd.1792" "tmd" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=Renaming files
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_88
if %custominstall_nc%==1 if %evcregion%==1 cd 0001000148415450v1792
if %custominstall_nc%==1 if %evcregion%==2 cd 0001000148415445v1792
if %custominstall_nc%==1 if %processor_architecture%==x86 call NUS_Downloader_Decrypt.exe >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %processor_architecture%==AMD64 call NUS_Decryptor_x64.exe cetk >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=Decrypter error
if %custominstall_nc%==1 if not %temperrorlev%==0 cd..& goto error_patching
if %custominstall_nc%==1 cd..
goto patching_fast_travel_100
:patching_fast_travel_89
if %custominstall_nc%==1 if %evcregion%==1 ren "0001000148415450v1792\*.wad" "HATP.wad" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %evcregion%==2 ren "0001000148415445v1792\*.wad" "HATE.wad" >>"%MainFolder%\patching_output.txt"

if %custominstall_nc%==1 if %evcregion%==1 move /y "0001000148415450v1792\HATP.wad" "NCPatcher\pack" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %evcregion%==2 move /y "0001000148415445v1792\HATE.wad" "NCPatcher\pack" >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=move.exe
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_90
if %custominstall_nc%==1 if %evcregion%==1 call NCPatcher\pack\Sharpii.exe WAD -u NCPatcher\pack\HATP.wad NCPatcher\pack\unencrypted >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %evcregion%==2 call NCPatcher\pack\Sharpii.exe WAD -u NCPatcher\pack\HATE.wad NCPatcher\pack\unencrypted >>"%MainFolder%\patching_output.txt"
goto patching_fast_travel_100
:patching_fast_travel_93
if %custominstall_nc%==1 move /y "NCPatcher\pack\unencrypted\00000001.app" "00000001_NC.app"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=move.exe
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_94
if %custominstall_nc%==1 if %evcregion%==1 call NCPatcher\patch\xdelta3.exe -f -d -s 00000001_NC.app NCPatcher\patch\Europe.delta NCPatcher\pack\unencrypted\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %evcregion%==2 call NCPatcher\patch\xdelta3.exe -f -d -s 00000001_NC.app NCPatcher\patch\USA.delta NCPatcher\pack\unencrypted\00000001.app >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=xdelta.exe NC
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
goto patching_fast_travel_100
:patching_fast_travel_95
if %custominstall_nc%==1 if %evcregion%==1 call NCPatcher\pack\Sharpii.exe WAD -p "NCPatcher\pack\unencrypted" "WAD\Nintendo Channel (Europe) (Channel) (RiiConnect24)" -f >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 if %evcregion%==2 call NCPatcher\pack\Sharpii.exe WAD -p "NCPatcher\pack\unencrypted" "WAD\Nintendo Channel (USA) (Channel) (RiiConnect24)" -f >>"%MainFolder%\patching_output.txt"
if %custominstall_nc%==1 set /a temperrorlev=%errorlevel%
if %custominstall_nc%==1 set modul=Packing NC WAD
if %custominstall_nc%==1 if not %temperrorlev%==0 goto error_patching
if %custominstall_nc%==1 set /a progress_nc=1
goto patching_fast_travel_100

::Final commands
:patching_fast_travel_98
if not %sdcard%==NUL set /a errorcopying=0
if not %sdcard%==NUL if not exist "%sdcard%:\WAD" md "%sdcard%:\WAD" 
if not %sdcard%==NUL if not exist "%sdcard%:\apps" md "%sdcard%:\apps"
goto patching_fast_travel_100

:patching_fast_travel_99
echo.&echo %string470%
if not %sdcard%==NUL xcopy /y "WAD" "%sdcard%:\WAD" /e || set /a errorcopying=1
if not %sdcard%==NUL xcopy /y "apps" "%sdcard%:\apps" /e|| set /a errorcopying=1

if exist 0001000148415045v512 rmdir /s /q 0001000148415045v512
if exist 0001000148415050v512 rmdir /s /q 0001000148415050v512

if exist 0001000148414A45v512 rmdir /s /q 0001000148414A45v512
if exist 0001000148414A50v512 rmdir /s /q 0001000148414A50v512
if exist 0001000148415450v1792 rmdir /s /q 0001000148415450v1792
if exist 0001000148415445v1792 rmdir /s /q 0001000148415445v1792 
if exist unpacked-temp rmdir /s /q unpacked-temp
if exist IOSPatcher rmdir /s /q IOSPatcher
if exist EVCPatcher rmdir /s /q EVCPatcher
if exist NCPatcher rmdir /s /q NCPatcher
if exist CMOCPatcher rmdir /s /q CMOCPatcher
if exist NewsChannelPatcher rmdir /s /q NewsChannelPatcher
del /q source.app
del /q cert.sys
del /q 00000001.app
del /q 0001000248414650v7.wad
del /q 0001000248414645v7.wad
del /q 0001000248414750v7.wad
del /q 0001000248414745v7.wad
del /q 00000004.app
del /q 00000001_NC.app
set /a progress_finishing=1
goto patching_fast_travel_100


:patching_fast_travel_100

if %percent%==100 if %dolphin%==1 goto 2_install_dolphin_3
if %percent%==100 goto 2_4
::ping localhost -n 1 >NUL

if /i %ss% GEQ 20 goto random_funfact
set /a percent=%percent%+1
goto 2_3
:2_4
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo %string268%
echo.
if %sdcardstatus%==0 echo %string471%
if %sdcardstatus%==1 if %sdcard%==NUL echo %string471%

if %sdcardstatus%==1 if not %sdcard%==NUL if %errorcopying%==0 echo %string472%
if %sdcardstatus%==1 if not %sdcard%==NUL if %errorcopying%==1 echo %string473%
echo.
echo %string474%
echo.
echo %string188%
echo.
echo 1. %string189%
echo 2. %string190%
echo 3. %string506%
if %preboot_environment%==1 echo 4. %string489%
echo.
set /p s=%string26%: 
if %s%==1 goto script_start
if %s%==2 goto end
if %s%==3 goto feedback_respond
if %preboot_environment%==1 if %s%==3 "X:\TOTALCMD.exe"
goto 2_4

:feedback_respond
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string507%
echo.
echo %string508%
echo.
echo 1. %string509%
echo 2. %string510%
echo 3. %string511%
echo 4. %string512%
echo 5. %string513%
echo.
set /p report1=%string26%: 

if %report1%==1 goto feedback_respond2
if %report1%==2 goto feedback_respond2
if %report1%==3 goto feedback_respond2
if %report1%==4 goto feedback_respond2
if %report1%==5 goto feedback_respond2
goto feedback_respond
:feedback_respond2
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string507%
echo.
echo %string514%
echo.
echo 1. %string515%
echo 2. %string516%
echo 3. %string517%
echo 4. %string518%
echo 5. %string519%
echo 6. %string520%
echo.
set /p report2=%string26%: 

if %report2%==1 goto feedback_respond2
if %report2%==2 goto feedback_respond2
if %report2%==3 goto feedback_respond2
if %report2%==4 goto feedback_respond2
if %report2%==5 goto feedback_respond2
if %report2%==6 goto feedback_respond2
goto feedback_respond2
:feedback_respond2
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string507%
echo.
echo %string521%
echo.
echo 1. %string522%
echo 2. %string523%
echo 3. %string61%.
echo.
set /p report3=%string26%: 
if %report3%==1 goto feedback_respond3
if %report3%==2 goto feedback_respond3
if %report3%==3 goto feedback_respond3
goto feedback_respond2
:feedback_respond3
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string507%
echo.
echo %string524%
echo.
echo 1. %string498%
echo 2. %string525%

set /p message_confirm=%string26%: 
if %message_confirm%==1 goto feedback_respond_write_message
if %message_confirm%==2 goto feedback_send
goto feedback_respond3

:feedback_respond_write_message
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string526%
echo %string527%
echo.
set /p message_content=
goto feedback_respond_write_message_confirm
:feedback_respond_write_message_confirm
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string528%
echo %message_content%
echo.
echo %string529%
echo.
echo 1. %string61%
echo 2. %string62%
set /p s=%string26%: 
if "%s%"=="1" goto feedback_send 
if "%s%"=="2" goto feedback_respond3
goto feedback_respond_write_message_confirm

:feedback_send
cls
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string530%

>"%MainFolder%\error_report.txt" echo RiiConnect24 Patcher v%version%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Patching successful, sending feedback.
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Date: %date%
>>"%MainFolder%\error_report.txt" echo Time: %time:~0,5%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Windows version: %windows_version%
>>"%MainFolder%\error_report.txt" echo Language: %language%
>>"%MainFolder%\error_report.txt" echo Processor architecture: %processor_architecture%
>>"%MainFolder%\error_report.txt" echo Device: %device%
>>"%MainFolder%\error_report.txt" echo.
if "%report1%"=="1" >>"%MainFolder%\error_report.txt" echo Which one best fits the app: The app is bad
if "%report1%"=="2" >>"%MainFolder%\error_report.txt" echo Which one best fits the app: I encountered a lot of issues when patching
if "%report1%"=="3" >>"%MainFolder%\error_report.txt" echo Which one best fits the app: Not intuitive
if "%report1%"=="4" >>"%MainFolder%\error_report.txt" echo Which one best fits the app: It's alright
if "%report1%"=="5" >>"%MainFolder%\error_report.txt" echo Which one best fits the app: The app is really easy to use
if "%report2%"=="1" >>"%MainFolder%\error_report.txt" echo How did you find out about RC24: I've heard about it from my friend
if "%report2%"=="2" >>"%MainFolder%\error_report.txt" echo How did you find out about RC24: I've heard about it on Discord
if "%report2%"=="3" >>"%MainFolder%\error_report.txt" echo How did you find out about RC24: YouTube
if "%report2%"=="4" >>"%MainFolder%\error_report.txt" echo How did you find out about RC24: wii.guide
if "%report2%"=="5" >>"%MainFolder%\error_report.txt" echo How did you find out about RC24: I found out about it on Google
if "%report2%"=="6" >>"%MainFolder%\error_report.txt" echo How did you find out about RC24: Other
if "%report3%"=="1" >>"%MainFolder%\error_report.txt" echo Ever used another features: No, I don't plan to
if "%report3%"=="2" >>"%MainFolder%\error_report.txt" echo Ever used another features: No, I plan to
if "%report3%"=="3" >>"%MainFolder%\error_report.txt" echo Ever used another features: Yes
>>"%MainFolder%\error_report.txt" echo.
if "%message_confirm%"=="1" >>"%MainFolder%\error_report.txt" echo Message: %message_content%


if "%message_confirm%"=="2" curl -F "report=@%MainFolder%\error_report.txt" %post_url%?user=%random_identifier%_feedback>NUL
if "%message_confirm%"=="1" curl -F "report=@%MainFolder%\error_report.txt" %post_url%?user=%random_identifier%_feedback_message>NUL
goto end




:end
set /a exiting=10
set /a timeouterror=1
timeout 1 /nobreak >NUL && set /a timeouterror=0
goto end1
:end1
setlocal disableDelayedExpansion
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo  [*] %string475%
echo.
if %exitmessage%==1 echo %string476%
echo %string477%
echo.
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

:troubleshooting_auto_tool
if "%modul%"=="Renaming files [Delete everything except RiiConnect24Patcher.bat]" set tempgotonext=2_2&set /a troubleshoot_auto_tool_notification=1& goto troubleshooting_5
if "%modul%"=="Decrypter error" set tempgotonext=2_2&set /a troubleshoot_auto_tool_notification=1& goto troubleshooting_5
if "%modul%"=="move.exe" set tempgotonext=2_2&set /a troubleshoot_auto_tool_notification=1& goto troubleshooting_5
if "%percent%"=="1" set tempgotonext=2_2&set /a troubleshoot_auto_tool_notification=1& goto troubleshooting_5


set /a modul=0
goto error_patching


:no_internet_connection
cls
echo %header%                                                                
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   %string73%
echo   /     \  %string478%
echo  /   ^!   \ 
echo  --------- %string479% 
echo            %string480%
echo.
echo       %string90%
echo ---------------------------------------------------------------------------------------------------------------------------
pause>NUL
goto begin_main

:error_patching
if "%temperrorlev%"=="6" goto no_internet_connection
if "%temperrorlev%"=="7" goto no_internet_connection
if "%modul%"=="Decrypter error" if "%processor_architecture%"=="AMD64" if "%temperrorlev%"=="-1" goto install_vc_plus_plus_redist
if "%modul%"=="Renaming files [Delete everything except RiiConnect24Patcher.bat]" goto troubleshooting_auto_tool
if "%percent%"=="1" goto troubleshooting_auto_tool
cls
echo %header%                                                                
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
echo    /---\   %string73%
echo   /     \  %string481%
echo  /   ^!   \ %string482%: %temperrorlev%
echo  --------- %string483%: %modul% / %percent%
echo.
echo %string484%
if %temperrorlev%==-532459699 echo %string485%
if %temperrorlev%==23 echo %string486%
if %temperrorlev%==-2146232576 echo %string487%  
echo       %string90%
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
echo %string502%
>"%MainFolder%\error_report.txt" echo RiiConnect24 Patcher v%version%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Install RiiConnect24 Patcher
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Date: %date%
>>"%MainFolder%\error_report.txt" echo Time: %time:~0,5%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Windows version: %windows_version%
>>"%MainFolder%\error_report.txt" echo Language: %language%
>>"%MainFolder%\error_report.txt" echo Processor architecture: %processor_architecture%
>>"%MainFolder%\error_report.txt" echo Device: %device%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Action: Patching
>>"%MainFolder%\error_report.txt" echo Region: %evcregion%
>>"%MainFolder%\error_report.txt" echo Module: %modul%
>>"%MainFolder%\error_report.txt" echo Progress: %percent%%
>>"%MainFolder%\error_report.txt" echo Exit code: %temperrorlev%
>>"%MainFolder%\error_report.txt" echo.
>>"%MainFolder%\error_report.txt" echo Attaching output:
>>"%MainFolder%\error_report.txt" type "%MainFolder%\patching_output.txt"

curl -F "report=@%MainFolder%\error_report.txt" %post_url%?user=%random_identifier%

echo %string503%

pause>NUL
goto begin_main

:install_vc_plus_plus_redist
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string494%
echo %string495%
echo.
echo %string496%
echo.
echo %string497%
echo.
echo 1. %string498% (%string499%)
echo 2. %string500%
echo.
set /p s=%string26%:
if %s%==1 goto install_vc_plus_plus_redist_2
if %s%==2 goto begin_main

goto install_vc_plus_plus_redist

:install_vc_plus_plus_redist_2
cls
echo.
echo %header%
echo ---------------------------------------------------------------------------------------------------------------------------
echo.
echo %string87%
echo %string501%...
curl -f -L -s -S --insecure "%FilesHostedOn%/VC_redist.x64.exe" --output VC_redist.x64.exe

"VC_redist.x64.exe" /install /passive /norestart>NUL

del /q "VC_redist.x64.exe"


goto 2_2








:: The end - what did you expect? Join our Discord server! https://discord.gg/b4Y7jfD 
:: Find me as KcrPL#4625 ;)

:grablanguages
set Counter=1
curl %FilesHostedOn%\%language%.bin --output %Temp%\GloomParser.lang.bin
for /f %%x in (%Temp%\GloomParser.lang.bin) do (
  set "string!Counter!=%%x"
  set /a Counter+=1
)
set /a NumLines=Counter - 1
exit /b
