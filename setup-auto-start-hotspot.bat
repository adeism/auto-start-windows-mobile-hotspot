@echo off
setlocal
title Auto Hotspot Task Scheduler Installer v1.1

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
echo ===============================================================
echo   Auto Hotspot Installer v1.1 - Edisi Anti Ngambek!
echo ===============================================================
echo.
echo Konfigurasi dimulai...

set "utilityPath=C:\ProgramData\AutoHotspotUtility"
set "psScriptPath=%utilityPath%\Start-Hotspot.ps1"
set "taskName=Auto Start Hotspot"
set "logPath=%utilityPath%\activity.log"

REM =================================================================
REM Bagian 2.1: Pilihan Interval Pengecekan
REM =================================================================
echo.
echo Berapa sering hotspot harus dicek?
echo.
echo [1] 5 menit  (Sangat responsif, lebih boros resource)
echo [2] 10 menit (Default, seimbang) - RECOMMENDED
echo [3] 20 menit (Hemat resource, delay lebih lama)
echo.
set /p interval="Pilihan Anda (1/2/3, tekan Enter untuk default): "

if "%interval%"=="" set interval=2
if "%interval%"=="1" (
    set minutes=5
    echo Anda memilih: 5 menit
)
if "%interval%"=="2" (
    set minutes=10
    echo Anda memilih: 10 menit
)
if "%interval%"=="3" (
    set minutes=20
    echo Anda memilih: 20 menit
)

REM Validasi input
if not defined minutes (
    echo Input tidak valid! Menggunakan default 10 menit.
    set minutes=10
)

if not exist "%utilityPath%" mkdir "%utilityPath%"

REM =================================================================
REM Bagian 3: Membuat PowerShell Script dengan Logging
REM =================================================================
echo.
echo Membuat file skrip PowerShell dengan logging di "%psScriptPath%"...
(
    echo # Auto Hotspot Script v1.1 with Logging
    echo $logFile = "%logPath%"
    echo $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    echo.
    echo # Ensure we have admin rights
    echo if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent(^)^).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"^)^) {
    echo     Add-Content -Path $logFile -Value "[$timestamp] ERROR: Script not running as Administrator"
    echo     exit 1
    echo }
    echo.
    echo try {
    echo     # Get connection profile
    echo     $connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile(^)
    echo.
    echo     if ($null -eq $connectionProfile^) {
    echo         Add-Content -Path $logFile -Value "[$timestamp] WARNING: No active internet connection profile found"
    echo         exit 0
    echo     }
    echo.
    echo     # Get tethering manager
    echo     $tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile^)
    echo.
    echo     # Check and start hotspot if needed
    echo     if ($tetheringManager.TetheringOperationalState -ne 'On'^) {
    echo         Add-Content -Path $logFile -Value "[$timestamp] INFO: Hotspot is OFF - Attempting to activate..."
    echo         $result = $tetheringManager.StartTetheringAsync(^)
    echo         $result.GetResults(^) ^| Out-Null
    echo         Add-Content -Path $logFile -Value "[$timestamp] SUCCESS: Hotspot activated successfully"
    echo     } else {
    echo         Add-Content -Path $logFile -Value "[$timestamp] INFO: Hotspot already ON - No action needed"
    echo     }
    echo }
    echo catch {
    echo     Add-Content -Path $logFile -Value "[$timestamp] ERROR: $($_.Exception.Message^)"
    echo     exit 1
    echo }
) > "%psScriptPath%"

REM =================================================================
REM Bagian 3.1: Membuat Script Verifikasi Terpisah
REM =================================================================
set "verifyScriptPath=%utilityPath%\Verify-Hotspot.ps1"
(
    echo # Simple verification script
    echo try {
    echo     $cp = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile(^)
    echo     if ($null -eq $cp^) {
    echo         Write-Host "WARNING: Tidak ada koneksi internet aktif" -ForegroundColor Yellow
    echo         exit 0
    echo     }
    echo     $tm = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($cp^)
    echo     if ($tm.TetheringOperationalState -eq 'On'^) {
    echo         Write-Host "Hotspot AKTIF!" -ForegroundColor Green
    echo     } else {
    echo         Write-Host "Hotspot TIDAK AKTIF. Coba jalankan Check-Status.bat atau lihat log." -ForegroundColor Yellow
    echo     }
    echo } catch {
    echo     Write-Host "ERROR: $_" -ForegroundColor Red
    echo }
) > "%verifyScriptPath%"

REM =================================================================
REM Bagian 4: Pembuatan Tugas di Task Scheduler
REM =================================================================
echo Menghapus tugas lama (jika ada^) untuk memastikan instalasi bersih...
schtasks /delete /TN "%taskName%" /F > nul 2>&1

echo Membuat tugas baru yang berjalan setiap %minutes% menit...

schtasks /create ^
    /TN "%taskName%" ^
    /TR "powershell.exe -ExecutionPolicy Bypass -File \"%psScriptPath%\"" ^
    /SC MINUTE ^
    /MO %minutes% ^
    /RL HIGHEST ^
    /F

if %errorlevel% equ 0 (
    echo.
    echo =================================================================
    echo Mengaktifkan hotspot untuk pertama kali...
    echo =================================================================
    echo.
    
    REM Jalankan task scheduler
    schtasks /run /TN "%taskName%"
    
    REM Tunggu beberapa detik untuk PowerShell script selesai
    echo Menunggu hotspot aktif...
    timeout /t 5 /nobreak > nul
    
    REM Verifikasi menggunakan script terpisah yang lebih sederhana
    echo Memverifikasi status hotspot...
    powershell -ExecutionPolicy Bypass -NoProfile -File "%verifyScriptPath%"
    
    echo.
    echo =================================================================
    echo  SETUP BERHASIL!
    echo.
    echo  - Tugas "%taskName%" telah dibuat di Task Scheduler
    echo  - Interval pengecekan: %minutes% menit
    echo  - Log aktivitas: %logPath%
    echo.
    echo  File utilitas tambahan tersedia:
    echo  - View-Logs.bat      : Lihat log aktivitas hotspot
    echo  - Check-Status.bat   : Cek status hotspot saat ini
    echo  - Uninstall.bat      : Hapus utilitas ini
    echo.
    echo  Tips: Jalankan Check-Status.bat untuk melihat status lengkap
    echo  Selanjutnya, status hotspot akan diperiksa secara otomatis
    echo  setiap %minutes% menit.
    echo =================================================================
) else (
    echo.
    echo !!!!! GAGAL MEMBUAT TASK SCHEDULER. !!!!!
    echo Pastikan Anda menjalankan file ini sebagai Administrator.
    echo.
    echo Jika masih gagal, lihat TROUBLESHOOTING.md untuk bantuan.
)

echo.
echo Tekan tombol apapun untuk keluar...
pause > nul
endlocal