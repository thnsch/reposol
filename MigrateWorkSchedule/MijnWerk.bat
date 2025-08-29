@echo off

REM -----------------------------------------------------------------------------
REM MijnWerk.bat
REM
REM Automates the workflow for migrating an Ikea work schedule PDF to Google Calendar.
REM
REM Steps performed:
REM   1. Checks that exactly one PDF file is present in the folder.
REM   2. Deletes all existing .txt, .ics, and .json files in the folder.
REM   3. Converts the PDF to a text file using pdftotext.
REM   4. Generates .ics and .json files from the text file using a PowerShell script.
REM   5. Updates the Google Calendar by running the Python script with the generated JSON.
REM
REM Requirements:
REM   - Windows environment
REM   - pdftotext utility in the bin\ directory
REM   - PowerShell
REM   - Python and required packages
REM   - Google Calendar API credentials
REM
REM Usage:
REM   1. Place your downloaded work schedule PDF in this folder.
REM   2. Run this batch file: MijnWerk.bat
REM -----------------------------------------------------------------------------

set home=%~dp0
set home="%home:~0,-1%"
set pdf_basename=""
set script_home=%home%\script
set python_home=%home%\..\_WPy-3710\python-3.7.1.amd64
set path=%python_home%;%python_home%\Scripts;%path%


cd /d %home%

echo check pdf file amount...
for /f %%a in ('dir /b ^| find /c ".pdf"') do set countpdf=%%a
if %countpdf% neq 1 (
	echo Found %countpdf% PDF files. 1 is expected. 
	echo. & goto END
)

echo get the PDFs basename...
for /f %%a in ('dir /b ^| find /i ".pdf"') do set pdf_basename=%%~na

echo.
echo "ATTENTION! All existing txt, ics and json files in %home% will be removed !"
echo. 
pause
del /f /q *.txt  2>nul
del /f /q *.ics  2>nul
del /f /q *.json 2>nul

echo convert pdf to txt
for /f "tokens=* delims= " %%a in ('dir /b "*.pdf"') do (
	bin\pdftotext -table %%a
)

echo create ical and json...
powershell -ExecutionPolicy bypass -File %script_home%\createIcsAndJsonFiles.ps1 %pdf_basename%.txt

echo update Google calendar...
python  %script_home%\calendarUpdate.py --schedule %pdf_basename%.json

:END
echo. & echo Finished
pause
