# 🔧 Troubleshooting Guide

Panduan lengkap untuk mengatasi masalah yang mungkin Anda temui.

---

## ❌ Masalah Umum

### 1. Setup Gagal: "GAGAL MEMBUAT TASK SCHEDULER"

**Penyebab:**
- Script tidak dijalankan sebagai Administrator
- Task Scheduler service tidak berjalan
- Group Policy memblok pembuatan scheduled task

**Solusi:**
```batch
# Pastikan menjalankan sebagai Administrator:
1. Klik kanan setup-auto-start-hotspot.bat
2. Pilih "Run as administrator"
3. Klik "Yes" pada UAC prompt

# Cek Task Scheduler service:
1. Tekan Win + R
2. Ketik: services.msc
3. Cari "Task Scheduler"
4. Pastikan status "Running" dan Startup type "Automatic"
```

---

### 2. Hotspot Masih Mati Setelah Install

**Diagnosis:**
Jalankan `Check-Status.bat` untuk melihat:
- Apakah task scheduler berjalan?
- Apakah ada error di log?

**Kemungkinan Penyebab & Solusi:**

#### A. WiFi Adapter Tidak Support Hosted Network
```cmd
# Cek support:
netsh wlan show drivers

# Cari baris:
Hosted network supported : Yes/No
```

**Jika "No":**
- Update driver WiFi ke versi terbaru
- Ganti WiFi adapter yang support (USB WiFi dongle misalnya)
- Gunakan WiFi eksternal yang support hosted network

#### B. Driver WiFi Bermasalah
```cmd
# Reinstall driver WiFi:
1. Device Manager > Network adapters
2. Klik kanan WiFi adapter > Uninstall device
3. Restart PC
4. Windows akan auto-install driver
5. Atau download driver terbaru dari website manufacturer
```

#### C. Mobile Hotspot Disabled di Windows
```cmd
# Enable Mobile Hotspot:
1. Settings > Network & Internet > Mobile hotspot
2. Pastikan toggle ON
3. Set SSID dan Password
4. Jalankan ulang setup-auto-start-hotspot.bat
```

---

### 3. Error: "No active internet connection profile found"

**Arti:** PC tidak terdeteksi memiliki koneksi internet aktif.

**Solusi:**
```cmd
# Hotspot memerlukan koneksi internet aktif untuk dishare.
# Pastikan Anda terhubung ke:
- Ethernet/LAN cable
- WiFi (jika punya 2 WiFi adapter)
- Mobile data via USB tethering

# Cek koneksi:
1. Buka Command Prompt
2. Ketik: ipconfig
3. Pastikan ada adapter dengan IP address
```

---

### 4. Script Berjalan Tapi Hotspot Tidak Menyala

**Diagnosis:**
```cmd
# Lihat detail error di log:
1. Jalankan View-Logs.bat
2. Cari baris dengan "ERROR"
```

**Error Umum:**

#### "Access Denied"
- Task Scheduler tidak berjalan dengan hak yang cukup
- Reinstall dengan menjalankan setup sebagai Admin

#### "TetheringManager not available"
- Windows version terlalu lama (< Windows 10 v1607)
- Update Windows ke versi terbaru

#### "WiFi adapter not found"
- WiFi adapter disabled
- Enable di Device Manager

---

### 5. Log File Tidak Terbuat

**Penyebab:**
- Task belum pernah berjalan (tunggu sesuai interval)
- Permission error saat menulis log

**Solusi:**
```cmd
# Force run task:
1. Buka Task Scheduler
2. Cari "Auto Start Hotspot"
3. Klik kanan > Run
4. Tunggu beberapa detik
5. Jalankan View-Logs.bat lagi

# Jika masih tidak ada log:
1. Cek folder C:\ProgramData\AutoHotspotUtility
2. Pastikan folder ada dan writable
3. Reinstall utility
```

---

## 🔍 Advanced Troubleshooting

### Debugging PowerShell Script

Jalankan script secara manual untuk melihat error real-time:

```powershell
# Buka PowerShell sebagai Administrator
Set-ExecutionPolicy Bypass -Scope Process
cd C:\ProgramData\AutoHotspotUtility
.\Start-Hotspot.ps1

# Lihat output dan error yang muncul
```

### Cek Event Viewer

Melihat error Windows yang lebih detail:

```cmd
1. Tekan Win + R
2. Ketik: eventvwr.msc
3. Buka: Windows Logs > Application
4. Cari error dari "Task Scheduler" atau "PowerShell"
```

### Test Manual Mobile Hotspot API

Test apakah API hotspot berfungsi:

```powershell
# Jalankan di PowerShell Admin:
$cp = [Windows.Networking.Connectivity.NetworkInformation]::GetInternetConnectionProfile()
$tm = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager]::CreateFromConnectionProfile($cp)
$tm.TetheringOperationalState

# Output:
# - "On" = Hotspot menyala
# - "Off" = Hotspot mati
# - Error = Ada masalah dengan API
```

---

## 🛡️ Compatibility Issues

### Windows Versions

| Windows Version | Status | Notes |
|---|---|---|
| Windows 11 24H2 | ✅ Tested | Fully working |
| Windows 11 23H2 | ✅ Compatible | Should work |
| Windows 11 22H2 | ✅ Compatible | Should work |
| Windows 10 22H2 | ✅ Compatible | Should work |
| Windows 10 21H2 | ✅ Compatible | Should work |
| Windows 10 < 1607 | ❌ Not supported | Update Windows |
| Windows 8.1 | ❌ Not supported | Mobile Hotspot N/A |

### Known Incompatible WiFi Adapters

- Beberapa WiFi adapter USB murah tidak support hosted network
- Realtek adapters generasi lama (pre-2015)
- Virtual network adapters (VirtualBox, VMware)

**Rekomendasi:** 
- Intel Wireless adapters (mayoritas support)
- TP-Link USB WiFi adapters
- ASUS USB-AC adapters

---

## 🔄 Reset & Reinstall

### Clean Reinstall

Jika semua solusi di atas gagal:

```cmd
1. Jalankan Uninstall.bat
2. Restart PC
3. Reset Mobile Hotspot:
   - Settings > Network & Internet > Mobile hotspot
   - Turn OFF
   - Turn ON
   - Set SSID dan password baru
4. Jalankan setup-auto-start-hotspot.bat lagi
5. Pilih interval 10 menit
6. Tunggu 10 menit
7. Cek dengan Check-Status.bat
```

### Reset Mobile Hotspot Windows

```cmd
# Sebagai Administrator:
netsh wlan stop hostednetwork
netsh wlan set hostednetwork mode=disallow
netsh wlan set hostednetwork mode=allow ssid="YourSSID" key="YourPassword"
netsh wlan start hostednetwork
```

---

## 📞 Getting Help

### Jika Masih Bermasalah

1. **Kumpulkan Informasi:**
   - Screenshot output dari `Check-Status.bat`
   - Copy isi log dari `View-Logs.bat`
   - Versi Windows (Win + R > winver)
   - Model WiFi adapter

2. **Buka Issue di GitHub:**
   - [Create New Issue](https://github.com/adeism/auto-start-windows-mobile-hotspot/issues/new)
   - Sertakan informasi di atas
   - Jelaskan langkah-langkah yang sudah Anda coba

3. **Community Support:**
   - Cek existing issues yang mirip
   - Mungkin sudah ada solusinya

---

## ✅ Checklist Troubleshooting

Sebelum meminta bantuan, pastikan Anda sudah:

- [ ] Menjalankan setup sebagai Administrator
- [ ] WiFi adapter support hosted network (`netsh wlan show drivers`)
- [ ] Driver WiFi sudah update terbaru
- [ ] Mobile Hotspot bisa dinyalakan manual
- [ ] Task Scheduler service berjalan
- [ ] Melihat log dengan `View-Logs.bat`
- [ ] Mencoba reinstall clean
- [ ] Reboot PC minimal 1x

Semoga masalah Anda terselesaikan! 🎉