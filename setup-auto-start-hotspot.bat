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

REM Gunakan PowerShell untuk membuat file PS1 (hindari masalah escaping)
powershell -Command "$content = @'
# Auto Hotspot Script v1.1 with Logging
$logFile = '%logPath%'
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# Ensure we have admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Add-Content -Path $logFile -Value "[$timestamp] ERROR: Script not running as Administrator"
    exit 1
}

try {
    # Get connection profile
    $connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile()

    if ($null -eq $connectionProfile) {
        Add-Content -Path $logFile -Value "[$timestamp] WARNING: No active internet connection profile found"
        exit 0
    }

    # Get tethering manager
    $tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

    # Check and start hotspot if needed
    if ($tetheringManager.TetheringOperationalState -ne 'On') {
        Add-Content -Path $logFile -Value "[$timestamp] INFO: Hotspot is OFF - Attempting to activate..."
        $result = $tetheringManager.StartTetheringAsync()
        $result.GetResults() | Out-Null
        Add-Content -Path $logFile -Value "[$timestamp] SUCCESS: Hotspot activated successfully"
    } else {
        Add-Content -Path $logFile -Value "[$timestamp] INFO: Hotspot already ON - No action needed"
    }
}
catch {
    Add-Content -Path $logFile -Value "[$timestamp] ERROR: $($_.Exception.Message)"
    exit 1
}
'@; Set-Content -Path '%psScriptPath%' -Value $content -Encoding UTF8"

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
    
    REM Jalankan script PowerShell LANGSUNG
    echo Menjalankan script aktivasi...
    powershell.exe -ExecutionPolicy Bypass -File "%psScriptPath%"
    
    REM Tunggu sebentar
    timeout /t 2 /nobreak > nul
    
    REM Verifikasi status dengan Check-Status.bat
    echo.
    echo Memverifikasi status hotspot...
    echo.
    
    REM Cek apakah Check-Status.bat ada di folder yang sama
    if exist "%~dp0Check-Status.bat" (
        call "%~dp0Check-Status.bat"
    ) else (
        echo [INFO] Check-Status.bat tidak ditemukan di folder ini.
        echo Anda bisa download dari repository untuk cek status lengkap.
        echo.
        echo Menggunakan verifikasi sederhana...
        powershell -Command "try { $cp = [Windows.Networking.Connectivity.NetworkInformation]::GetInternetConnectionProfile(); if ($cp) { $tm = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager]::CreateFromConnectionProfile($cp); if ($tm.TetheringOperationalState -eq 'On') { Write-Host 'Hotspot AKTIF!' -ForegroundColor Green } else { Write-Host 'Hotspot TIDAK AKTIF' -ForegroundColor Yellow } } else { Write-Host 'Tidak ada koneksi internet' -ForegroundColor Yellow } } catch { Write-Host 'Error: $_' -ForegroundColor Red }"
    )
    
    echo.
    echo =================================================================
    echo  SETUP BERHASIL!
    echo.
    echo  - Tugas "%taskName%" telah dibuat di Task Scheduler
    echo  - Interval pengecekan: %minutes% menit
    echo  - Log aktivitas: %logPath%
    echo.
    echo  File utilitas tambahan tersedia di repository:
    echo  - View-Logs.bat      : Lihat log aktivitas hotspot
    echo  - Check-Status.bat   : Cek status hotspot saat ini
    echo  - Uninstall.bat      : Hapus utilitas ini
    echo.
    echo  Download semua file dari:
    echo  https://github.com/adeism/auto-start-windows-mobile-hotspot
    echo.
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