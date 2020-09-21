:: remember to pip install unidecode

echo off
	rmdir /q /s Translation_Files_CHCP_OFF
	md Translation_Files_CHCP_OFF
::		copy "Translation_Files\*.*" "Translation_Files_CHCP_OFF\"
			echo Working...
			echo.
		for /f %%f in ('dir /b Translation_Files') do (
		echo %%f
		if not "%%f"=="Language_ru-RU.bat" unidecode -e ANSI Translation_Files\%%f>>Translation_Files_CHCP_OFF\%%f
		)
	echo.
	echo Done!
	pause
