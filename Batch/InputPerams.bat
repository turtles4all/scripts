@SETLOCAL

@SET PARAM=%~1
@IF "%PARAM%" == "" ECHO	 pARAM IS REQ AND GOTO: EOF
@ECHO %~0 was ran with param %PARAM%