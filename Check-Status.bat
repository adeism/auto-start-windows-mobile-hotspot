@echo off
title Auto Hotspot - Check Status

REM Request Administrator rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Meminta hak akses Administrator...
    powershell.exe -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===============================================================
echo   Auto Hotspot - Status Checker
echo ===============================================================
echo.

echo [1] STATUS TASK SCHEDULER
echo ---------------------------------------------------------------
schtasks /query /TN "Auto Start Hotspot" /FO LIST 2>nul

if %errorlevel% neq 0 (
    echo [ERROR] Task "Auto Start Hotspot" tidak ditemukan!
    echo.
    echo Kemungkinan utility belum diinstall atau sudah diuninstall.
    echo Jalankan setup-auto-start-hotspot.bat untuk install.
    goto :CheckHotspot
)

echo.
echo [2] STATUS MOBILE HOTSPOT
echo ---------------------------------------------------------------

:CheckHotspot
powershell -Command "try { $cp = [Windows.Networking.Connectivity.NetworkInformation]::GetInternetConnectionProfile(); if ($null -eq $cp) { Write-Host '[WARNING] Tidak ada koneksi internet aktif' -ForegroundColor Yellow } else { $tm = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager]::CreateFromConnectionProfile($cp); Write-Host 'Status Hotspot    :' $tm.TetheringOperationalState -ForegroundColor $(if($tm.TetheringOperationalState -eq 'On'){'Green'}else{'Red'}); Write-Host 'Client Count      :' $tm.ClientCount; Write-Host 'Max Client Count  :' $tm.MaxClientCount } } catch { Write-Host '[ERROR]' $_.Exception.Message -ForegroundColor Red }"

echo.
echo [3] LAST 10 LOG ENTRIES
echo ---------------------------------------------------------------

set "logFile=C:\ProgramData\AutoHotspotUtility\activity.log"
if exist "%logFile%" (
    powershell -Command "Get-Content '%logFile%' -Tail 10"
) else (
    echo [INFO] Log file belum tersedia
)

echo.
echo ===============================================================
echo.
pause