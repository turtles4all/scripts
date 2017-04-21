@echo off
SETLOCAL
IF "%~1" == "" echo Usage: %~nx0 directory && goto :EOF

set dir=%~1
set dirout=%TEMP%\%~n0.tmp
for /f "tokens=2,3,4 delims=/ " %%i in ('DATE /T') DO SET datevar=%%k%%i%%j
set log=%~dpn0_%datevar%.log
IF exist "%log%" (
	echo %~nx0 was ran today, delete the following log
	echo %log%
	goto :EOF
)

echo starting %~nx0 at %DATE% %TIME%

dir /B /S /A:H "%dir%" > %dirout%
if errorlevel 1 echo Unable to read %dir% && GOTO :EOF
for /f "delims=" %%i in (%dirout%) do (
	attrib "%%i" >> "%log%"
)
echo Finished %~nx0 at %DATE% %TIME%
echo Review %log%