@echo off
title Auto Hotspot - View Activity Logs

set "logFile=C:\ProgramData\AutoHotspotUtility\activity.log"

echo ===============================================================
echo   Auto Hotspot - Activity Logs
echo ===============================================================
echo.

if not exist "%logFile%" (
    echo [INFO] Log file belum ada.
    echo.
    echo Kemungkinan penyebab:
    echo  - Task scheduler belum pernah berjalan
    echo  - Utility belum diinstall
    echo  - Ini adalah instalasi lama tanpa logging
    echo.
    echo Tunggu beberapa menit setelah instalasi agar task scheduler
    echo berjalan dan membuat log pertama.
    echo.
    pause
    exit /b
)

echo File log ditemukan: %logFile%
echo.
echo Menampilkan 50 baris terakhir:
echo ---------------------------------------------------------------
echo.

powershell -Command "Get-Content '%logFile%' -Tail 50"

echo.
echo ---------------------------------------------------------------
echo.
echo Tips:
echo  - Log disimpan di: %logFile%
echo  - Untuk melihat semua log, buka file tersebut dengan Notepad
echo  - Log format: [Tanggal Waktu] STATUS: Pesan
echo.
pause