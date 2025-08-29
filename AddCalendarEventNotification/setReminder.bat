@echo off

rem
rem 1. Import Afvalkalender.ics to the Google-Calendar via browser
rem 2. Set the reminder with this script
rem 

set home=%~dp0
set home="%home:~0,-1%"
set python_home=%home%\..\_WPy-3710\python-3.7.1.amd64
set path=%python_home%;%python_home%\Scripts;%path%


cd /d %home%

echo set reminder...
python  .\setReminder.py

:END
echo. & echo Finished
pause
