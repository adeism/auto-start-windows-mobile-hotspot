@echo off
setlocal
title Auto Hotspot Task Scheduler Installer v2

REM =================================================================
REM Bagian 1: Meminta Hak Akses Administrator Secara Otomatis
REM =================================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Meminta hak akses Administrator...
    powershell.exe -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM =================================================================
REM Bagian 2: Konfigurasi dan Pembuatan File
REM =================================================================
echo Konfigurasi dimulai...

set "utilityPath=C:\ProgramData\AutoHotspotUtility"
set "psScriptPath=%utilityPath%\Start-Hotspot.ps1"
set "taskName=Auto Start Hotspot"

if not exist "%utilityPath%" mkdir "%utilityPath%"

echo Membuat file skrip PowerShell di "%psScriptPath%"...
(
    echo try {
    echo     $connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile^(\^)
    echo     $tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile^($connectionProfile^)
    echo.
    echo     if ^($tetheringManager.TetheringOperationalState -ne 'On'^) {
    echo         $tetheringManager.StartTetheringAsync^(\^) ^| Out-Null
    echo     }
    echo }
    echo catch {}
) > "%psScriptPath%"

REM =================================================================
REM Bagian 3: Pembuatan Tugas di Task Scheduler (Versi Perbaikan)
REM =================================================================
echo Menghapus tugas lama (jika ada) untuk memastikan instalasi bersih...
schtasks /delete /TN "%taskName%" /F > nul 2>&1

echo Membuat tugas baru yang berjalan setiap 10 menit...

REM Perintah yang valid: Menjalankan tugas setiap 10 menit.
schtasks /create ^
    /TN "%taskName%" ^
    /TR "powershell.exe -ExecutionPolicy Bypass -File \"%psScriptPath%\"" ^
    /SC MINUTE ^
    /MO 10 ^
    /RL HIGHEST ^
    /F

if %errorlevel% equ 0 (
    echo Menjalankan tugas untuk pertama kali agar hotspot langsung aktif...
    schtasks /run /TN "%taskName%" > nul
    echo.
    echo =================================================================
    echo  SETUP BERHASIL!
    echo.
    echo  - Tugas "%taskName%" telah dibuat di Task Scheduler.
    echo  - Hotspot Anda sekarang sudah aktif.
    echo.
    echo  Selanjutnya, status hotspot akan diperiksa secara otomatis
    echo  setiap 10 menit.
    echo =================================================================
) else (
    echo.
    echo !!!!! GAGAL MEMBUAT TASK SCHEDULER. !!!!!
    echo Pastikan Anda menjalankan file ini sebagai Administrator.
)

echo.
pause
endlocal
