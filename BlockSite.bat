@echo off
color a
setlocal enabledelayedexpansion
cls
title BlockSite
call :check
cd /d C:\Windows\system32\drivers\etc
call :check
attrib -r hosts
call :check
echo Blocked Sites:
for /f "eol=# tokens=1,2 delims= " %%i in (hosts) do (
if "%%i"=="0.0.0.0" echo %%j
if "%%i"=="127.0.0.1" echo %%j
)
call :check
echo:
echo Choose your option:
echo 1. Add to blocklist
echo 2. Remove form blocklist
:select
set /p sel="Select > "
if "%sel%"=="1" goto pr1
if "%sel%"=="2" goto pr2
echo Invalid choice
goto select

:check
if not errorlevel 0 (
echo An error has occured.
pause >nul
exit
)
exit /b 0

:pr1
set /p input="Enter a new site to add to the list > "
call :check
echo 0.0.0.0 %input% >> hosts
echo Site added to blocklist. Press any key to exit...
attrib +r hosts
pause >nul
exit

:pr2
set /p input="Enter a site to remove to the list > "
call :check
set err=1
for /f "eol=# tokens=1,2 delims= " %%i in (hosts) do (
if "%%i %%j"=="0.0.0.0 %input%" set err=0
if "%%i %%j"=="127.0.0.1 %input%" set err=0
)
if "%err%"=="1" (
echo Site not found in blocklist.
pause >nul
exit
)
call :check
call :confirm
type hosts | findstr /v %input% > blocksite
type blocksite > hosts
echo Site removed from blocklist. Press any key to exit...
attrib +r hosts
pause >nul
exit

:confirm
set pw=%random%%random%%random%%random%%random%
echo Write down this password: %pw%
pause
cls
set /p in="Enter the given password > "
if not "%in%"=="%pw%" (
echo Incorrect.
pause >nul
exit
)
exit /b 0
