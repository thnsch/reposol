@echo off


set home=%~dp0
set home=%home:~0,-1%
set outfile=%home%\mail.txt

set path=%home%\..\_WPy-3710\python-3.7.1.amd64;C:\Program Files\Notepad++;%path%


REM python myMail.py  &&  goto END

python GetContentOfOutlookMails.py  >"%outfile%"

notepad++.exe "%outfile%"

set /p dummy="Press enter to delete %outfile% ..." 
del /f /q %outfile%

:END
REM pause
