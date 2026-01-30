@echo off
title Auto Hotspot Uninstaller

REM Request Administrator rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Meminta hak akses Administrator...
    powershell.exe -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===============================================================
echo   Auto Hotspot Uninstaller
echo ===============================================================
echo.
echo Script ini akan menghapus:
echo  - Task Scheduler "Auto Start Hotspot"
echo  - Semua file di C:\ProgramData\AutoHotspotUtility
echo.
set /p confirm="Lanjutkan uninstall? (Y/N): "

if /i not "%confirm%"=="Y" (
    echo Uninstall dibatalkan.
    pause
    exit /b
)

echo.
echo Menghapus task scheduler...
schtasks /delete /TN "Auto Start Hotspot" /F

if %errorlevel% equ 0 (
    echo [OK] Task scheduler berhasil dihapus
) else (
    echo [INFO] Task scheduler tidak ditemukan atau sudah dihapus
)

echo.
echo Menghapus file utilitas...
if exist "C:\ProgramData\AutoHotspotUtility" (
    rmdir /S /Q "C:\ProgramData\AutoHotspotUtility"
    echo [OK] Folder AutoHotspotUtility berhasil dihapus
) else (
    echo [INFO] Folder AutoHotspotUtility tidak ditemukan
)

echo.
echo =================================================================
echo  UNINSTALL SELESAI!
echo.
echo  Auto Hotspot telah dihapus dari sistem Anda.
echo  Hotspot tidak akan lagi otomatis menyala.
echo =================================================================
echo.
pause