@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SOURCE_EXE=%~dp0QRoBOT.exe"
set "TARGET_DIR=C:\QRoBOT"
set "TARGET_EXE=%TARGET_DIR%\QRoBOT.exe"

echo ========================================
echo QRoBOT executable deployment
echo Source: %SOURCE_EXE%
echo Target: %TARGET_EXE%
echo ========================================

if not exist "%SOURCE_EXE%" (
  echo [ERROR] Source executable was not found.
  goto :fail
)

tasklist /FI "IMAGENAME eq QRoBOT.exe" 2>nul | find /I "QRoBOT.exe" >nul
if not errorlevel 1 (
  echo [ERROR] QRoBOT is running. Close it before deployment.
  goto :fail
)

choice /C YN /N /M "Deploy QRoBOT.exe to C:\QRoBOT? [Y/N] "
if errorlevel 2 (
  echo Deployment cancelled.
  exit /b 0
)

if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
  if errorlevel 1 (
    echo [ERROR] Could not create %TARGET_DIR%.
    goto :fail
  )
)

if exist "%TARGET_EXE%" (
  for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%I"
  set "BACKUP_DIR=%TARGET_DIR%\Backup\!STAMP!"
  mkdir "!BACKUP_DIR!"
  if errorlevel 1 (
    echo [ERROR] Could not create backup folder.
    goto :fail
  )

  copy /Y "%TARGET_EXE%" "!BACKUP_DIR!\QRoBOT.exe" >nul
  if errorlevel 1 (
    echo [ERROR] Could not back up the existing executable.
    goto :fail
  )
  echo Backup: !BACKUP_DIR!\QRoBOT.exe
)

copy /Y "%SOURCE_EXE%" "%TARGET_EXE%" >nul
if errorlevel 1 (
  echo [ERROR] Copy failed. Try running this file as administrator.
  goto :fail
)

fc /B "%SOURCE_EXE%" "%TARGET_EXE%" >nul
if errorlevel 1 (
  echo [ERROR] Verification failed. The copied file is different.
  goto :fail
)

echo [SUCCESS] QRoBOT.exe was deployed and verified.
exit /b 0

:fail
echo Deployment failed.
pause
exit /b 1
