echo %~d0%~p0
cd "%~d0%~p0"

chcp 437
@echo off
:: ===========================================================================
:: Password Generator for Windows
set version=1.0.0
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2018 KcrPL
:: ===========================================================================
if exist temp.bat del /q temp.bat
:1
:: Window size (Lines, columns)
set mode=126,37
mode %mode%

set s=NUL
:: Window Title
title Password Generator v%version%  Created by @KcrPL
set last_build=2018/04/01
set at=00:26

set header=Password Generator - (C) KcrPL v%version% (Compiled on %last_build% at %at%)

set /a Update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://raw.githubusercontent.com/KcrPL/KcrPL.github.io/master/Patchers_Auto_Update/Password_Generator
set MainFolder=%appdata%\PasswordGenerator
set TempStorage=%appdata%\PasswordGenerator\internet\temp

if not exist "%MainFolder%" md "%MainFolder%"
if not exist "%TempStorage%" md "%TempStorage%"

:: Checking if I have access to files on your computer
if exist %TempStorage%\checkforaccess.txt del /q %TempStorage%\checkforaccess.txt

echo test >>"%TempStorage%\checkforaccess.txt"
set /a file_access=1
if not exist "%TempStorage%\checkforaccess.txt" set /a file_access=0

if exist "%TempStorage%\checkforaccess.txt" del /q "%TempStorage%\checkforaccess.txt"

::set variables to defaults
set /a contain_small_letters=1
set /a contain_large_letters=1
set /a contain_numbers=1

set /a howmanypasswords=5
set /a howmanycharacters=9

set /a save_password=0

::Detect language
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set OSLanguage=%%a
set password=English

if %OSLanguage%==1046 set language=Brazilian&goto set_language_brazilian
if %OSLanguage%==1036 set language=French& goto set_language_french
if %OSLanguage%==1045 set language=Polish& goto set_language_polish
if %OSLanguage%==0413 set language=Dutch& goto set_language_dutch
goto set_language_english
:set_language_brazilian
set mode=144,37
mode %mode%
set string1=Generador De Senhas
set string2=Escreva um numero e aperte na tecla ENTER
set string3=Iniciar
set string5=Escolher
set string6=Modo Seguro
set string7=O ultimo BootUp foi malsucedido. Lancando no modo de seguranca.
set string8=Secao de atualizacao foi pulada.
set string9=Pressione Qualquer Tecla Para Continuar.
set string10=Inciando powershell
set string11=Procurando por atualizacoes..
set string12=Uma atualizacao esta disponivel!
set string13=Uma atualizacao esta disponivel. Recomendamos atualizar a senha do generador de senhas para a ultima versao.
set string14=Versao Atual
set string15=Nova versao
set string16=Atualizar
set string17=Dispensar
set string18=O Que tem na nova versao?
set string19=Atualizando..
set string20=Por favor espere..
set string21=O Generador de senhas sera reiniciado em breve.
set string22=O Que tem de novo nessa atualizacao
set string23=Erro. O Que tem de novo nao esta disponivel.
set string24=Seja bem-vindo ao generador de senhas!
set string25=Quantos senhas eu posso generar
set string26=Quantas letras ela deve conter
set string27=Eles devem conter letras pequenas
set string28=Eles devem conter letras grandes
set string29=Eles devem conter numeros
set string44=Eles devem conter simbolos
set string30=Salvar a senha em um arquivo .txt? [Ele sera salvo na mesma pasta onde este programa e]
set string31=Generar Senhas!
set string32=Quantos caracteres cada senha deve ter?
set string33=Configuracoes invalidas!
set string34=Por favor volte e mude as configuracoes.
set string35=Generando Senhas com essas configuracoes
set string36=Criando
set string37=senhas, cada
set string38=caracteres longos
set string39=Senhas geradas
set string40=Todas as senhas foram generadas com sucesso.
set string41=Todas as senhas foram salvas com sucesso.
set string42=Menu principal
set string43=Sair
set string45=Tentativa de carregar caracteres diacriticos [nao funciona no Windows 7]

set language=Brazilian
set /a diacritic_show=1
goto begin_main
:set_language_brazilian_diacritic
set mode=126,37
mode %mode%
set string1=Generador De Senhas
set string2=Escreva um numero e aperte na tecla ENTER
set string3=Iniciar
set string5=Escolher
set string6=Modo Seguro
set string7=O último BootUp foi malsucedido. Lançando no modo de segurança.
set string8=Seçao de atualizaçăo foi pulada.
set string9=Pressione Qualquer Tecla Para Continuar.
set string10=Inciando powershell
set string11=Procurando por atualizaçőes..
set string12=Uma atualizaçăo esta disponivel!
set string13=Uma atualizaçăo esta disponivel. Recomendamos atualizar a senha do generador de senhas para a ultima versăo.
set string14=Versăo Atual
set string15=Nova versăo
set string16=Atualizar
set string17=Dispensar
set string18=O Que tem na nova versăo?
set string19=Atualizando..
set string20=Por favor espere..
set string21=O Generador de senhas será reiniciado em breve.
set string22=O Que tem de novo nessa atualizaçao
set string23=Erro. O Que tem de novo nao esta disponivel.
set string24=Seja bem-vindo ao generador de senhas!
set string25=Quantos senhas eu posso generar
set string26=Quantas letras ela deve conter
set string27=Eles devem conter letras pequenas
set string28=Eles devem conter letras grandes
set string29=Eles devem conter números
set string44=Eles devem conter símbolos
set string30=Salvar a senha em um arquivo .txt? [Ele será salvo na mesma pasta onde este programa é]
set string31=Generar Senhas!
set string32=Quantos caracteres cada senha deve ter?
set string33=Configuraçőes invalidas!
set string34=Por favor volte e mude as configuraçőes.
set string35=Generando Senhas com essas configuraçőes
set string36=Criando
set string37=senhas, cada
set string38=caracteres longos
set string39=Senhas geradas
set string40=Todas as senhas foram generadas com sucesso.
set string41=Todas as senhas foram salvas com sucesso.
set string42=Menu principal
set string43=Sair
set string45=Tentativa de carregar caracteres diacríticos [năo funciona no Windows 7]

set language=Brazilian
set /a diacritic_show=0
goto begin_main

:set_language_dutch
set string1=Wachtwoordgenerator
set string2=Typ een nummer en druk op ENTER
set string3=Start
set string5=Kies
set string6=Veilige Modus
set string7=Laatste startup was onsuccesvol. Starten in veilige modus...
set string8=Update onderdeel is overgeslagen.
set string9=Druk op een toets om door te gaan.
set string10=Powershell aan het starten...
set string11=Aan het checken voor updates...
set string12=Een update is beschikbaar!
set string13=Een update voor dit proramma is beschikbaar. Wij adviseren om de wachtwoordgenerator te updaten naar de laatste versie.
set string14=Huidige versie
set string15=Nieuwe versie
set string16=Update
set string17=Negeer
set string18=Wat is nieuw in deze update?
set string19=Updaten...
set string20=Wacht a.u.b.
set string21=De wachtwoordgenerator zal zich spoedig herstarten.
set string22=Wat is nieuw in de update
set string23=Error! Wat is nieuw is niet beschikbaar op dit moment.
set string24=Welkom bij de wachtwoordgenerator!
set string25=Hoeveel wachtwoorden zal ik genereren?
set string26=Uit hoeveel karakters moet het wachtwoord bestaan?
set string27=Moeten ze kleine letters bevatten?
set string28=Moeten ze grote letters bevatten?
set string29=Moeten ze nummers bevatten?
set string44=Moeten ze symbolen bevatten?
set string30=Wachtwoorden opslaan in een .txt bestand?? [Het zal worden opgeslagen in dezelfde map waar dit progrmma is]
set string31=Genereer wachtwoorden!
set string32=Hoeveel karakters moet ieder wachtwoord hebben?
set string33=Ongeldige instellingen
set string34=Ga a.u.b. terug en pas de instellingen aan.
set string35=Genereer wachtwoorden met de volgende instellingen
set string36=None
set string37=wachtwoorden aan het genereren, waarvan elk
set string38=karakters lang

set string39=Gegenereerde wachtwoorden

set string40=Alle wachtwoorden zijn met success gegenereerd.
set string41=Alle wachtwoorden zijn met success opgeslagen.
set string42=Hoofdmenu
set string43=Afsluiten
set string45=Probeer diakritische karakters te laden [Windows 8.1/10]

set language=Dutch
set /a diacritic_show=0
goto begin_main

:set_language_english
set mode=126,37
mode %mode%
set string1=Password Generator
set string2=Type in a number and hit ENTER
set string3=Start
set string5=Choose
set string6=Safe mode
set string7=Last BootUp was unsuccessfull. Launching in safe mode.
set string8=Update section has been skipped.
set string9=Press any key to continue.
set string10=Launching powershell
set string11=Checking for updates
set string12=An Update is available
set string13=An Update for this program is available. We suggest updating the Password Generator to the latest version.
set string14=Current version
set string15=New version
set string16=Update
set string17=Dismiss
set string18=What's new in this update?
set string19=Updating.
set string20=Please wait
set string21=Password Generator will restart shortly
set string22=What's new in update
set string23=Error. What's new is not available at the moment.
set string24=Welcome to the password generator!
set string25=How many passwords should I generate
set string26=How many characters should they contain
set string27=Should they contain small letters
set string28=Should they contain large letters
set string29=Should they contain numbers
set string44=Should they contain symbols
set string30=Save the password to a .txt file? [It will be saved in the same folder where this program is]
set string31=Generate passwords!
set string32=How many characters should every password have
set string33=Invalid settings
set string34=Please go back and change settings.
set string35=Generating passwords with following settings
set string36=Creating
set string37=passwords, each
set string38=characters long
set string39=Generated passwords
set string40=All passwords has been generated successfully.
set string41=All passwords have been saved successfully.
set string42=Main menu
set string43=Exit
set string45=Attempt to load diacritic characters [Windows 8.1/10]

set language=English
set /a diacritic_show=0
goto begin_main
:set_language_french
set mode=137,37
mode %mode%
set string1=Password Generator
set string2=Entrez un numero et appuyez sur Entree
set string3=Demarrer
set string5=Choisir
set string6=Mode sans echec
set string7=Le dernier demarrage a echoue. Lancement en mode sans echec.
set string8=La verification des mises a jour a ete ignoree.
set string9=appuyez sur n'importe quelle touche.
set string10=Lancement de Powershell
set string11=Verification des mises a jour
set string12=Une mise a jour est disponible
set string13=Une mise a jour est disponible. Nous vous recommandons d'utiliser la derniere version de Password Generator.
set string14=Version actuelle
set string15=Nouvelle version
set string16=Mettre a jour
set string17=Cacher
set string18=Quoi de neuf ?
set string19=Mise a jour.
set string20=Veuillez patienter
set string21=Password Generator va redemarrer prochainement
set string22=Quoi de neuf dans la mise a jour ?
set string23=Error. Le changelog n'est pas disponible pour le moment.
set string24=Bienvenue dans Password Generator !
set string25=Combien de mots de passe dois-je generer
set string26=Combien de caracteres doivent-ils contenir
set string27=Devraient-ils contenir des lettres minuscules
set string28=Devraient-ils contenir des lettres majuscules
set string29=Devraient-ils contenir des nombres
set string44=Devraient-ils contenir des symboles
set string30=Sauvegardez les changements dans un fichier .txt ? [Ce sera sauvegarde dans le meme dossier que celui du programme]
set string31=Generation des mots de passe !
set string32=Combien de caracteres les mots de passe doivent-ils avoir ?
set string33=Parametres invalides
set string34=Retournez en arriere et changez les parametres.
set string35=Generation des mots de passe avec les parametres suivants
set string36=Creation de
set string37=mots de passe, chacun fait
set string38=caracteres de long
set string39=Mots de passe generes
set string40=Tous les mots de passe ont ete generes avec succes.
set string41=Tous les mots de passe ont ete sauvegardes avec succes.
set string42=Menu principal
set string43=Sortir
set string45=Entative de chargement de catacteres diacritiques [Windows 8.1/10]

set language=French
set /a diacritic_show=1
goto begin_main
:set_language_french_diacritic
set mode=126,37
mode %mode%
chcp 65001
set string1=Password Generator
set string2=Entrez un numéro et appuyez sur Entrée
set string3=Démarrer
set string5=Choisir
set string6=Mode sans échec
set string7=Le dernier démarrage a échoué. Lancement en mode sans échec.
set string8=La vérification des mises à jour a été ignorée.
set string9=Appuyez sur n'importe quelle touche.
set string10=Lancement de Powershell
set string11=Vérification des mises à jour
set string12=Une mise à jour est disponible
set string13=Une mise à jour est disponible. Nous vous recommandons d'utiliser la dernière version de Password Generator.
set string14=Version actuelle
set string15=Nouvelle version
set string16=Mettre à jour
set string17=Cacher
set string18=Quoi de neuf ?
set string19=Mise à jour.
set string20=Veuillez patienter
set string21=Password Generator va redémarrer prochainement
set string22=Quoi de neuf dans la mise à jour ?
set string23=Error. Le changelog n'est pas disponible pour le moment.
set string24=Bienvenue dans Password Generator !
set string25=Combien de mots de passe dois-je générer
set string26=Combien de caractères doivent-ils contenir
set string27=Devraient-ils contenir des lettres minuscules
set string28=Devraient-ils contenir des lettres majuscules
set string29=Devraient-ils contenir des nombres
set string44=Devraient-ils contenir des symboles
set string30=Sauvegardez les changements dans un fichier .txt ? [Ce sera sauvegardé dans le même dossier que celui du programme]
set string31=Génération des mots de passe !
set string32=Combien de caractères les mots de passe doivent-ils avoir ?
set string33=Paramètres invalides
set string34=Retournez en arrière et changez les paramètres.
set string35=Génération des mots de passe avec les paramètres suivants
set string36=Création de
set string37=mots de passe, chacun fait
set string38=caractères de long
set string39=Mots de passe générés
set string40=Tous les mots de passe ont été générés avec succès.
set string41=Tous les mots de passe ont été sauvegardés avec succès.
set string42=Menu principal
set string43=Sortir
set string45=Entative de chargement de catactères diacritiques [Windows 8.1/10]

set language=French
set /a diacritic_show=0
goto begin_main
:set_language_polish_diacritic
set mode=126,37
mode %mode%
chcp 65001
set string1=Generator Haseł
set string2=Wpisz numer i wciśnij ENTER
set string3=Start
set string5=Wybierz
set string6=Tryb awaryjny
set string7=Ostatnie uruchomienie zakończyło się niepowodzeniem. Uruchamianie w trybie awaryjnym.
set string8=Aktualizacja została pominięta.
set string9=Wciśnij dowolny przycisk aby kontynuować.
set string10=Uruchamianie Powershell
set string11=Sprawdzanie aktualizacji
set string12=Aktualizacja jest dostępna
set string13=Aktualizacja dla tego programu jest dostępna. Sugerujemy aktualizowanie Generatora Haseł do najnowszej wersji.
set string14=Obecna wersja
set string15=Nowa wersja
set string16=Aktualizuj
set string17=Opuść
set string18=Co nowego w tej aktualizacji?
set string19=Aktualizowanie.
set string20=Proszę czekać
set string21=Generator Haseł zostanie wkrótce uruchomiony ponownie.
set string22=Co nowego w tej aktualizacji?
set string23=Błąd. Co nowego jest chwilowo nie dostępne.
set string24=Witaj w generatorze haseł!
set string25=Ile haseł powinienem stworzyć
set string26=Ile znaków każde hasło powinno mieć
set string27=Czy hasła powinny zawierać małe litery
set string28=Czy hasła powinny zawierać duże litery
set string29=Czy hasła powinny zawierać liczby
set string44=Czy hasła powinny zawierać symbole
set string30=Zapisać hasła do pliku .txt? [Hasła zostaną zapisane do tego samego folderu gdzie Generator Haseł jest]
set string31=Wygeneruj hasła!
set string32=Ile znaków powinno każde hasło mieć
set string33=Nieprawidłowe ustawienia
set string34=Cofnij się i zmień ustawienia
set string35=Generowanie haseł z poniższymi ustawieniami
set string36=Tworzenia
set string37=haseł, każde ma
set string38=znaków
set string39=Wytworzone hasła
set string40=Wszystkie hasła zostały wygenerowane z powodzeniem.
set string41=Wszystkie hasła zostały zapisane z powodzeniem.
set string42=Główne menu
set string43=Wyjdź
set string45=Spróbuj załadować znaki diakrytyczne [Windows 8.1/10]

set language=Polish
set /a diacritic_show=0
goto begin_main
:set_language_polish
set mode=126,37
mode %mode%
set string1=Generator Hasel
set string2=Wpisz numer i wcisnij ENTER
set string3=Start
set string5=Wybierz
set string6=Tryb awaryjny
set string7=Ostatnie uruchomienie zakonczylo sie niepowodzeniem. Uruchamianie w trybie awaryjnym.
set string8=Aktualizacja zostala pominieta.
set string9=Wcisnij dowolny przycisk aby kontynuowac.
set string10=Uruchamianie Powershell
set string11=Sprawdzanie aktualizacje
set string12=Aktualizacja jest dostepna
set string13=Aktualizacja dla tego programu jest dostepna. Sugerujemy aktualizowanie Generatora Hasel do najnowszej wersji.
set string14=Obecna wersja
set string15=Nowa wersja
set string16=Aktualizuj
set string17=Opusc
set string18=Co nowego w tej aktualizacji?
set string19=Aktualizowanie.
set string20=Prosze czekac
set string21=Generator Hasel zostanie wkrotce uruchomiony ponownie.
set string22=Co nowego w tej aktualizacji?
set string23=Blad. Co nowego jest chwilowo nie dostepne.
set string24=Witaj w generatorze hasel!
set string25=Ile hasel powinienem stworzyc
set string26=Ile znakow kazde haslo powinno miec
set string27=Czy hasla powinny zawierac male litery
set string28=Czy hasla powinny zawierac duze litery
set string29=Czy hasla powinny zawierac liczby
set string44=Czy hasla powinny zawierac symbole
set string30=Zapisac hasla do pliku .txt? [Hasla zostana zapisane do tego samego folderu gdzie Generator Hasel jest]
set string31=Wygeneruj hasla!
set string32=Ile znakow powinno kazde haslo miec
set string33=Nieprawidlowe ustawienia
set string34=Cofnij sie i zmien ustawienia
set string35=Generowanie hasel z ponizszymi ustawieniami
set string36=Tworzenia
set string37=hasel, kazde ma
set string38=znakow
set string39=Wytworzone hasla
set string40=Wszystkie hasla zostaly wygenerowane z powodzeniem.
set string41=Wszystkie hasla zostaly zapisane z powodzeniem.
set string42=Glowne menu
set string43=Wyjdz
set string45=Sprobuj zaladowac znaki diakrytyczne [Windows 8.1/10]

set language=Polish
set /a diacritic_show=1
goto begin_main
:load_diacritic
if %language%==Polish goto set_language_polish_diacritic
if %language%==French goto set_language_french_diacritic
if %language%==Brazilian goto set_language_brazilian_diacritic

goto begin_main

:begin_main
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:        %string1%    
echo            +mMMmy+//////////////////////////////////+ymMMm+       %string2%
echo          +NMMho////////////////////////////////////////ohMMN+     1. %string3%
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   2. Change your language [%language%]   
if %diacritic_show%==1 echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy` 3. %string45% 
if %diacritic_show%==0 echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo  `dMMo////////////////////sMMM+////////+MMMs////////////////////oMMd` 
echo  oMMy/////////////////////sMMM+////////+MMMs/////////////////////yMMo 
echo `NMN+///////////////////++sMMMo++++++++oMMMs++///////////////////+NMN`
echo +MMy//////////////////smMMMMMMMMMMMMMMMMMMMMMMms//////////////////yMM+
echo dMM+/////////////////+MMMMMMMMMMMMMMMMMMMMMMMMMM+/////////////////oMMd
echo NMM+//////////oo+////+MMMMMMMMMMMMMMMMMMMMMMMMMM+////+oo//////////+MMN
echo MMN+/////////+NMNy///+MMMMMMMMMMMMmmMMMMMMMMMMMM+//+yNMN+/////////+NMM
echo NMM+//////////+sdMh//+MMMMMMMMMMm+//+NMMMMMMMMMM+//hMds+//////////+MMN
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`                       
set /p s=%string5%: 
if %s%==1 goto begin_main1
if %s%==2 goto choose_language
if %s%==3 goto load_diacritic
goto begin_main
:choose_language
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo Change your language
echo.
echo 1. English (Author: KcrPL)
echo 2. Polish (Author: KcrPL)
echo 3. French (Author: iDroid)
echo 4. Dutch (Author: DismissedGuy)
echo 5. Brazilian (Author: Lucas7)
set /p s=Choose: 
if %s%==1 goto set_language_english
if %s%==2 goto set_language_polish
if %s%==3 goto set_language_french
if %s%==4 goto set_language_dutch
if %s%==5 goto set_language_brazilian
goto choose_language

:begin_main1
if exist "%MainFolder%/failsafe.txt" goto failsafe_trigger

set /a errorwinxp=0
timeout -0 /nobreak >NUL || set /a errorwinxp=1


echo BootUp>>%MainFolder%/failsafe.txt
goto startup_script
:failsafe_trigger
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string6%
echo %string7%
echo.
echo %string8%. %string9%
pause>NUL
del /q "%MainFolder%\failsafe.txt"
set /a updateserver=3
goto startup_script_files_check
:startup_script
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:        :-------------------------:
echo            +mMMmy+//////////////////////////////////+ymMMm+       %string10%...
echo          +NMMho////////////////////////////////////////ohMMN+    :-------------------------:
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   
echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`     
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo  `dMMo////////////////////sMMM+////////+MMMs////////////////////oMMd` 
echo  oMMy/////////////////////sMMM+////////+MMMs/////////////////////yMMo 
echo `NMN+///////////////////++sMMMo++++++++oMMMs++///////////////////+NMN`
echo +MMy//////////////////smMMMMMMMMMMMMMMMMMMMMMMms//////////////////yMM+
echo dMM+/////////////////+MMMMMMMMMMMMMMMMMMMMMMMMMM+/////////////////oMMd
echo NMM+//////////oo+////+MMMMMMMMMMMMMMMMMMMMMMMMMM+////+oo//////////+MMN
echo MMN+/////////+NMNy///+MMMMMMMMMMMMmmMMMMMMMMMMMM+//+yNMN+/////////+NMM
echo NMM+//////////+sdMh//+MMMMMMMMMMm+//+NMMMMMMMMMM+//hMds+//////////+MMN
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`              

if %file_access%==0 goto startup_script_files_check

powershell -c >NUL
goto check_for_update

:check_for_update
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:        :-------------------------:
echo            +mMMmy+//////////////////////////////////+ymMMm+       %string11%...
echo          +NMMho////////////////////////////////////////ohMMN+    :-------------------------:
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   
echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`     
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo  `dMMo////////////////////sMMM+////////+MMMs////////////////////oMMd` 
echo  oMMy/////////////////////sMMM+////////+MMMs/////////////////////yMMo 
echo `NMN+///////////////////++sMMMo++++++++oMMMs++///////////////////+NMN`
echo +MMy//////////////////smMMMMMMMMMMMMMMMMMMMMMMms//////////////////yMM+
echo dMM+/////////////////+MMMMMMMMMMMMMMMMMMMMMMMMMM+/////////////////oMMd
echo NMM+//////////oo+////+MMMMMMMMMMMMMMMMMMMMMMMMMM+////+oo//////////+MMN
echo MMN+/////////+NMNy///+MMMMMMMMMMMMmmMMMMMMMMMMMM+//+yNMN+/////////+NMM
echo NMM+//////////+sdMh//+MMMMMMMMMMm+//+NMMMMMMMMMM+//hMds+//////////+MMN
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`              

:: We don't support Windows XP anymore. Windows XP don't have timeout command, it means that if that command will be runned on Windows XP it will return exit code 1.

:: Update script.
set updateversion=0.0.0
:: Delete version.txt and whatsnew.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\version.txt`" del "%TempStorage%\version.txt`" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt`" del "%TempStorage%\whatsnew.txt`" /q

if not exist "%TempStorage%" md "%TempStorage%"
:: Commands to download files from server.

if %Update_Activate%==1 if %offlinestorage%==0 call powershell -command (new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/whatsnew.txt"', '"%TempStorage%\whatsnew.txt"')
if %Update_Activate%==1 if %offlinestorage%==0 call powershell -command (new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/version.txt"', '"%TempStorage%\version.txt"')
	set /a temperrorlev=%errorlevel%

set /a updateserver=1
	::Bind error codes to errors here
	if not %temperrorlev%==0 set /a updateserver=0

if exist "%TempStorage%\version.txt`" ren "%TempStorage%\version.txt`" "version.txt"
if exist "%TempStorage%\whatsnew.txt`" ren "%TempStorage%\whatsnew.txt`" "whatsnew.txt"
:: Copy the content of version.txt to variable.
if exist "%TempStorage%\version.txt" set /p updateversion=<"%TempStorage%\version.txt"
if not exist "%TempStorage%\version.txt" set /a updateavailable=0
if %Update_Activate%==1 if exist "%TempStorage%\version.txt" set /a updateavailable=1
:: If version.txt doesn't match the version variable stored in this batch file, it means that update is available.
if %updateversion%==%version% set /a updateavailable=0
if %Update_Activate%==1 if %updateavailable%==1 set /a updateserver=2
if %Update_Activate%==1 if %updateavailable%==1 goto update_notice

goto startup_script_files_check
:startup_script_files_check
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:       
echo            +mMMmy+//////////////////////////////////+ymMMm+   
echo          +NMMho////////////////////////////////////////ohMMN+ 
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   
echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`     
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo  `dMMo////////////////////sMMM+////////+MMMs////////////////////oMMd` 
echo  oMMy/////////////////////sMMM+////////+MMMs/////////////////////yMMo 
echo `NMN+///////////////////++sMMMo++++++++oMMMs++///////////////////+NMN`
echo +MMy//////////////////smMMMMMMMMMMMMMMMMMMMMMMms//////////////////yMM+
echo dMM+/////////////////+MMMMMMMMMMMMMMMMMMMMMMMMMM+/////////////////oMMd
echo NMM+//////////oo+////+MMMMMMMMMMMMMMMMMMMMMMMMMM+////+oo//////////+MMN
echo MMN+/////////+NMNy///+MMMMMMMMMMMMmmMMMMMMMMMMMM+//+yNMN+/////////+NMM
echo NMM+//////////+sdMh//+MMMMMMMMMMm+//+NMMMMMMMMMM+//hMds+//////////+MMN
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`              
if exist "%MainFolder%\failsafe.txt" del /q "%MainFolder%\failsafe.txt"
goto main_fade_out
:update_notice
if exist "%MainFolder%\failsafe.txt" del /q "%MainFolder%\failsafe.txt"
if %updateversion%==0.0.0 goto error_update_not_available
set /a update=1
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:       
echo            +mMMmy+//////////////////////////////////+ymMMm+   
echo          +NMMho////////////////////////////////////////ohMMN+ 
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   
echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`     
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo -----------------------------------------------------------------------------------------------------------------------------
echo    /---\   %string12%
echo   /     \  %string13%
echo  /   !   \
echo  ---------  %string14%: %version%
echo             %string15%: %updateversion%
echo                       1. %string16%                      2. %string17%               3. %string18%
echo -----------------------------------------------------------------------------------------------------------------------------
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`              
set /p s=
if %s%==1 goto update_files
if %s%==2 goto 3
if %s%==3 goto whatsnew
goto update_notice
:update_files
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:       
echo            +mMMmy+//////////////////////////////////+ymMMm+   
echo          +NMMho////////////////////////////////////////ohMMN+ 
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   
echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`     
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo -----------------------------------------------------------------------------------------------------------------------------
echo    /---\   %string19%
echo   /     \  %string20%...
echo  /   !   \
echo  --------- %string21%...
echo.
echo.
echo -----------------------------------------------------------------------------------------------------------------------------
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`              
echo INFO: Begining update process>>"%MainFolder%/IOSPatcherLogs.txt"
:: Deleting the temp files if they exist.
if exist password_generator.bat` del 00000006-31.delta` /q 2> nul

:: Downloading the update files. 
call powershell -command "(new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/password_generator.bat"', 'password_generator.bat`"')"

:: If download failed
if %update%==1 if not exist password_generator` goto error_update_not_available

:: Patch.bat cannot be overwritten while running so i'm creating a small script
echo echo off >>temp.bat
echo ping localhost -n 2^>NUL >>temp.bat
echo del password_generator.bat /q >>temp.bat
echo ren password_generator.bat` password_generator.bat >>temp.bat
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
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string22% %updateversion%?
echo.
type "%TempStorage%\whatsnew.txt"
pause>NUL
goto update_notice
:whatsnew_notexist
cls
echo %header%
echo ----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string23%
echo.
echo %string9%
pause>NUL
goto update_notice
:main_fade_out
cls
echo %header%
echo                         `-/oshdmmNMMMMNmmdhs+/-`                       
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo              :yMMMmyo+//////////////////////////+oymMMMy:       
echo            +mMMmy+//////////////////////////////////+ymMMm+   
echo          +NMMho////////////////////////////////////////ohMMN+ 
echo        :mMMh+/////////////////+oyhhhhyo+/////////////////+hMMm:   
echo      `yMMmo/////////////////+hNMMMMMMMMNh+/////////////////omMMy`     
echo     .mMMy+/////////////////sNMMmyo++oymMMNs/////////////////+yMMm.    
echo    .NMNo//////////////////+NMMh+//////+hMMN+//////////////////oNMN.   
echo   .NMNo///////////////////sMMM+////////+MMMs///////////////////oNMN.  
echo  `dMMo////////////////////sMMM+////////+MMMs////////////////////oMMd` 
echo  oMMy/////////////////////sMMM+////////+MMMs/////////////////////yMMo 
echo `NMN+///////////////////++sMMMo++++++++oMMMs++///////////////////+NMN`
echo +MMy//////////////////smMMMMMMMMMMMMMMMMMMMMMMms//////////////////yMM+
echo dMM+/////////////////+MMMMMMMMMMMMMMMMMMMMMMMMMM+/////////////////oMMd
echo NMM+//////////oo+////+MMMMMMMMMMMMMMMMMMMMMMMMMM+////+oo//////////+MMN
echo MMN+/////////+NMNy///+MMMMMMMMMMMMmmMMMMMMMMMMMM+//+yNMN+/////////+NMM
echo NMM+//////////+sdMh//+MMMMMMMMMMm+//+NMMMMMMMMMM+//hMds+//////////+MMN
echo dMMo/////////////omo/+MMMMMMMMMMd///+NMMMMMMMMMM+/omo/////////////oMMd
echo +MMy//////////////+o/+MMMMMMMMMMMy//hMMMMMMMMMMM+/o+//////////////yMM+
echo `NMN+////////////////+MMMMMMMMMyo+//+odMMMMMMMMM+////////////////+NMN`
echo  oMMy////+yhhhyo+////+MMMMMMMMMdyssssydMMMMMMMMM+////+oyhhhy+////yMMo 
echo  `dMMo///mMMNmmmdho//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//ohmmmmNMMm///oMMd` 
echo   .NMNo//+++/////++//+MMMMMMMMMMMMMMMMMMMMMMMMMM+//++/////+++//oNMN.  
echo    .NMNo/////////////+dMMMMMMMMMMMMMMMMMMMMMMMMd+/////////////oNMN.   
echo     .mMMy+/////////////oyhhhhhhhhhhhhhhhhhhhhyo/////////////+yMMm.    
echo      `yMMmo////////////////////////////////////////////////omMMy`     
echo        :mMMh+////////////////////////////////////////////+hMMm:       
echo          +NMMho////////////////////////////////////////ohMMN+         
echo            +mMMmy+//////////////////////////////////+ymMMm+           
echo              :yMMMmyo+//////////////////////////+oymMMMy:             
echo                `/yNMMNdhso+////////////////+oshdNMMNy/`               
echo                    .+ymMMMMNmddhhyyyyhhddmNMMMMmy+.                   
echo                        `-/+shdmmNMMMMNmmdhs+/-`              
ping localhost -n 3 >NUL
goto 2

:2
cls
set /a temp_passwords_created=0
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string24%
echo.
echo 1. %string25%: [%howmanypasswords%]
echo 2. %string26%: [%howmanycharacters%]
echo.
if %contain_small_letters%==0 echo 3. %string27%? [ ]
if %contain_small_letters%==1 echo 3. %string27%? [X]
if %contain_large_letters%==0 echo 4. %string28%? [ ]
if %contain_large_letters%==1 echo 4. %string28%? [X]
if %contain_numbers%==0 echo 5. %string29%? [ ]
if %contain_numbers%==1 echo 5. %string29%? [X]
echo.
if %save_password%==0 echo 6. %string30% [ ]
if %save_password%==1 echo 6. %string30% [X]
echo.
echo 7. %string31%
echo.
set /p s=
if %s%==1 goto how_many_passwords_choose
if %s%==2 goto how_many_characters_choose
if %s%==3 goto contain_small_letters
if %s%==4 goto contain_large_letters
if %s%==5 goto contain_numbers
if %s%==6 goto save_password
if %s%==7 goto check_for_invalid_settings
goto 2
:how_many_passwords_choose
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string25%? [Current: %howmanypasswords%]
echo.
set /p howmanypasswords=Choose: 
goto 2
:how_many_characters_choose
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string32%? [Current: %howmanycharacters%]
echo.
set /p howmanycharacters=%string5%: 
goto 2
:contain_small_letters
if %contain_small_letters%==0 set /a contain_small_letters=1 & goto 2
if %contain_small_letters%==1 set /a contain_small_letters=0 & goto 2

:contain_large_letters
if %contain_large_letters%==0 set /a contain_large_letters=1 & goto 2
if %contain_large_letters%==1 set /a contain_large_letters=0 & goto 2

:contain_numbers
if %contain_numbers%==0 set /a contain_numbers=1 & goto 2
if %contain_numbers%==1 set /a contain_numbers=0 & goto 2

:save_password
if %save_password%==0 set /a save_password=1 & goto 2
if %save_password%==1 set /a save_password=0 & goto 2

:check_for_invalid_settings
cls
set /a tempcheck=0
if %contain_small_letters%==1 set /a tempcheck=%tempcheck%+1
if %contain_large_letters%==1 set /a tempcheck=%tempcheck%+1
if %contain_numbers%==1 set /a tempcheck=%tempcheck%+1

if %tempcheck%==0 goto invalid_settings

if %howmanypasswords%==0 goto invalid_settings
if %howmanycharacters%==0 goto invalid_settings

goto generate_passwords
:invalid_settings
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string33%
echo %string34%
echo.
echo %string9%
pause>NUL
goto 2

:generate_passwords
if %save_password%==1 echo. >>passwords.txt
if %save_password%==1 echo %header% >>passwords.txt
if %save_password%==1 echo --------------------------- >>passwords.txt
if %save_password%==1 echo %string35%: >>passwords.txt
if %save_password%==1 if %contain_small_letters%==0 echo %string27% - No >>passwords.txt
if %save_password%==1 if %contain_small_letters%==1 echo %string27% - Yes >>passwords.txt
if %save_password%==1 if %contain_large_letters%==0 echo %string28% - No >>passwords.txt
if %save_password%==1 if %contain_large_letters%==1 echo %string28% - Yes >>passwords.txt
if %save_password%==1 if %contain_numbers%==0 echo %string29% - No >>passwords.txt
if %save_password%==1 if %contain_numbers%==1 echo %string29% - Yes >>passwords.txt
if %save_password%==1 echo. >>passwords.txt
if %save_password%==1 echo %string36% [%howmanypasswords%] %string37% [%howmanycharacters%] %string38%] >>passwords.txt
if %save_password%==1 echo. >>passwords.txt

set /a temp_passwords_created=0
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo %string39%:
echo.


:generate_passwords_phase1
::Generate random numbers for every character
set /a number_parse=1
set /a temporary_number=0
set /a tempnumbertogo=%howmanycharacters%+1

:generate_passwords_phase1_2
if %number_parse%==%tempnumbertogo% goto generate_passwords_phase2
set /a temporary_number=%random% %% (63 + 1)
::Check for settings
if %contain_small_letters%==0 if %temporary_number%==1 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==3 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==6 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==8 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==10 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==12 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==14 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==16 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==18 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==20 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==22 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==24 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==26 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==28 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==30 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==32 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==34 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==36 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==38 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==40 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==42 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==44 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==46 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==48 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==50 goto generate_passwords_phase1_2
if %contain_small_letters%==0 if %temporary_number%==52 goto generate_passwords_phase1_2

if %contain_large_letters%==0 if %temporary_number%==2 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==4 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==5 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==7 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==9 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==11 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==13 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==15 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==17 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==19 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==21 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==23 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==25 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==27 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==29 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==31 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==33 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==35 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==37 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==39 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==41 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==43 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==45 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==47 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==49 goto generate_passwords_phase1_2
if %contain_large_letters%==0 if %temporary_number%==51 goto generate_passwords_phase1_2

if %contain_numbers%==0 if %temporary_number%==53 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==54 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==55 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==56 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==57 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==58 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==59 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==60 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==61 goto generate_passwords_phase1_2
if %contain_numbers%==0 if %temporary_number%==62 goto generate_passwords_phase1_2

::Save into variable for later for parser
set cache%number_parse%=%temporary_number%
title Password Generator v%version%  Created by @KcrPL - Generating password - Randomizing the password (%number_parse% out of %howmanycharacters%)
set /a number_parse=%number_parse%+1
goto generate_passwords_phase1_2

:generate_passwords_phase2
set /a number_parse=1
set /a temporary_number=0

goto generate_passwords_phase2_2
:generate_passwords_phase2_2
if %number_parse%==%tempnumbertogo% goto check_end
set /a temporary_number=cache%number_parse%
title Password Generator v%version%  Created by @KcrPL - Generating password - Parsing password (%number_parse% out of %howmanycharacters%)
if %temporary_number%==1 set password%number_parse%letter=a
if %temporary_number%==2 set password%number_parse%letter=A
if %temporary_number%==3 set password%number_parse%letter=b
if %temporary_number%==4 set password%number_parse%letter=B
if %temporary_number%==5 set password%number_parse%letter=C
if %temporary_number%==6 set password%number_parse%letter=c
if %temporary_number%==7 set password%number_parse%letter=D
if %temporary_number%==8 set password%number_parse%letter=d
if %temporary_number%==9 set password%number_parse%letter=E
if %temporary_number%==10 set password%number_parse%letter=e
if %temporary_number%==11 set password%number_parse%letter=F
if %temporary_number%==12 set password%number_parse%letter=f
if %temporary_number%==13 set password%number_parse%letter=G
if %temporary_number%==14 set password%number_parse%letter=g
if %temporary_number%==15 set password%number_parse%letter=H
if %temporary_number%==16 set password%number_parse%letter=h
if %temporary_number%==17 set password%number_parse%letter=I
if %temporary_number%==18 set password%number_parse%letter=i
if %temporary_number%==19 set password%number_parse%letter=J
if %temporary_number%==20 set password%number_parse%letter=j
if %temporary_number%==21 set password%number_parse%letter=K
if %temporary_number%==22 set password%number_parse%letter=k
if %temporary_number%==23 set password%number_parse%letter=L
if %temporary_number%==24 set password%number_parse%letter=l
if %temporary_number%==25 set password%number_parse%letter=M
if %temporary_number%==26 set password%number_parse%letter=m
if %temporary_number%==27 set password%number_parse%letter=N
if %temporary_number%==28 set password%number_parse%letter=n
if %temporary_number%==29 set password%number_parse%letter=O
if %temporary_number%==30 set password%number_parse%letter=o
if %temporary_number%==31 set password%number_parse%letter=P
if %temporary_number%==32 set password%number_parse%letter=p
if %temporary_number%==33 set password%number_parse%letter=Q
if %temporary_number%==34 set password%number_parse%letter=q
if %temporary_number%==35 set password%number_parse%letter=R
if %temporary_number%==36 set password%number_parse%letter=r
if %temporary_number%==37 set password%number_parse%letter=S
if %temporary_number%==38 set password%number_parse%letter=s
if %temporary_number%==39 set password%number_parse%letter=T
if %temporary_number%==40 set password%number_parse%letter=t
if %temporary_number%==41 set password%number_parse%letter=U
if %temporary_number%==42 set password%number_parse%letter=u
if %temporary_number%==43 set password%number_parse%letter=V
if %temporary_number%==44 set password%number_parse%letter=v
if %temporary_number%==45 set password%number_parse%letter=W
if %temporary_number%==46 set password%number_parse%letter=w
if %temporary_number%==47 set password%number_parse%letter=X
if %temporary_number%==48 set password%number_parse%letter=x
if %temporary_number%==49 set password%number_parse%letter=Y
if %temporary_number%==50 set password%number_parse%letter=y
if %temporary_number%==51 set password%number_parse%letter=Z
if %temporary_number%==52 set password%number_parse%letter=z
if %temporary_number%==53 set password%number_parse%letter=0
if %temporary_number%==54 set password%number_parse%letter=1
if %temporary_number%==55 set password%number_parse%letter=2
if %temporary_number%==56 set password%number_parse%letter=3
if %temporary_number%==57 set password%number_parse%letter=4
if %temporary_number%==58 set password%number_parse%letter=5
if %temporary_number%==59 set password%number_parse%letter=6
if %temporary_number%==60 set password%number_parse%letter=7
if %temporary_number%==61 set password%number_parse%letter=8
if %temporary_number%==62 set password%number_parse%letter=9

set /a number_parse=%number_parse%+1
goto generate_passwords_phase2_2

:check_end
if %save_password%==1 echo %password1letter%%password2letter%%password3letter%%password4letter%%password5letter%%password6letter%%password7letter%%password8letter%%password9letter%%password10letter%%password11letter%%password12letter%%password13letter%%password14letter%%password15letter%%password16letter%%password17letter%%password18letter%%password19letter%%password20letter%%password21letter%%password22letter%%password23letter%%password24letter%%password25letter%%password26letter%%password27letter%%password28letter%%password29letter%%password30letter%%password31letter%%password32letter%%password33letter%%password34letter%%password35letter%%password36letter%%password37letter%%password38letter%%password39letter%%password40letter%%password41letter%%password42letter%%password43letter%%password44letter%%password45letter%%password46letter%%password47letter%%password48letter%%password49letter%%password50letter%%password51letter%%password52letter%%password53letter%%password54letter%%password55letter%%password56letter%%password57letter%%password58letter%%password59letter%%password60letter%%password61letter%%password62letter%%password63letter%%password64letter%%password65letter%%password66letter%%password67letter%%password68letter%%password69letter%%password70letter%%password71letter%%password72letter%%password73letter%%password74letter%%password75letter%%password76letter%%password77letter%%password78letter%%password79letter%%password80letter%%password81letter%%password82letter%%password83letter%%password84letter%%password85letter% >>passwords.txt
echo %password1letter%%password2letter%%password3letter%%password4letter%%password5letter%%password6letter%%password7letter%%password8letter%%password9letter%%password10letter%%password11letter%%password12letter%%password13letter%%password14letter%%password15letter%%password16letter%%password17letter%%password18letter%%password19letter%%password20letter%%password21letter%%password22letter%%password23letter%%password24letter%%password25letter%%password26letter%%password27letter%%password28letter%%password29letter%%password30letter%%password31letter%%password32letter%%password33letter%%password34letter%%password35letter%%password36letter%%password37letter%%password38letter%%password39letter%%password40letter%%password41letter%%password42letter%%password43letter%%password44letter%%password45letter%%password46letter%%password47letter%%password48letter%%password49letter%%password50letter%%password51letter%%password52letter%%password53letter%%password54letter%%password55letter%%password56letter%%password57letter%%password58letter%%password59letter%%password60letter%%password61letter%%password62letter%%password63letter%%password64letter%%password65letter%%password66letter%%password67letter%%password68letter%%password69letter%%password70letter%%password71letter%%password72letter%%password73letter%%password74letter%%password75letter%%password76letter%%password77letter%%password78letter%%password79letter%%password80letter%%password81letter%%password82letter%%password83letter%%password84letter%%password85letter%

set /a temp_passwords_created=%temp_passwords_created%+1

::Reset variables
set /a temp_number_parse=%number_parse%
set /a number_parse=0
set /a loop=0

:check_end_2
::skipping, I will use it in case of *something*

goto check_end_3
::loop to delete password up to 256 just to make sure that everything is clean
set "password%loop%letter="
set /a loop=%loop%+1
if %loop%==63 goto check_end_3
goto check_end_2
:check_end_3
if %temp_passwords_created%==%howmanypasswords% goto password_generator_done
goto generate_passwords_phase1
:password_generator_done
title Password Generator v%version%  Created by @KcrPL - Generating password - done!
echo.
echo %string40%
echo.
if %save_password%==1 echo %string41%
echo 1. %string42% 2. %string43%
set /p s=
if %s%==1 goto 2
if %s%==2 exit
goto password_generator_done








