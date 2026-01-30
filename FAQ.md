# FAQ (Frequently Asked Questions)

## ❓ Pertanyaan Umum

### 1. Apakah utility ini aman digunakan?
**Ya, 100% aman!** Utility ini hanya menggunakan Windows API resmi yang disediakan oleh Microsoft. Tidak ada malware, tidak ada backdoor, dan semua source code terbuka untuk Anda review.

### 2. Kenapa hotspot masih mati walaupun sudah install?
Beberapa kemungkinan:
- **WiFi adapter tidak support**: Beberapa WiFi adapter tidak mendukung fitur Hosted Network. Cek dengan command: `netsh wlan show drivers` dan lihat baris "Hosted network supported".
- **Driver WiFi outdated**: Update driver WiFi adapter Anda ke versi terbaru.
- **Windows Firewall blocking**: Pastikan Windows Firewall tidak memblok koneksi.
- **Interval terlalu lama**: Jika Anda pilih interval 20 menit, ada delay sebelum hotspot menyala lagi.

**Solusi**: Jalankan `Check-Status.bat` untuk melihat status detail dan `View-Logs.bat` untuk melihat error yang mungkin terjadi.

### 3. Apakah ini akan membuat baterai laptop cepat habis?
Tidak signifikan. Script ini hanya berjalan setiap beberapa menit (5-20 menit tergantung pilihan Anda) dan hanya mengecek status + menyalakan hotspot jika mati. Konsumsi resource sangat minimal.

Yang membuat baterai cepat habis adalah **hotspot itu sendiri yang menyala terus**, bukan script ini.

### 4. Bisakah saya mengubah interval pengecekan setelah install?
**Bisa!** Jalankan ulang `setup-auto-start-hotspot.bat` dan pilih interval baru. Script akan otomatis menghapus konfigurasi lama dan membuat yang baru dengan interval pilihan Anda.

### 5. Apakah bisa digunakan di Windows 10?
**Ya!** Utility ini kompatibel dengan Windows 10 dan Windows 11. Fitur Mobile Hotspot tersedia sejak Windows 10 Anniversary Update (versi 1607).

### 6. Apa bedanya dengan mengaktifkan hotspot manual?
Jika Anda aktifkan hotspot manual, Windows akan mematikannya otomatis ketika:
- Tidak ada device yang terhubung dalam waktu tertentu
- Laptop/PC di-restart
- Windows Update
- Driver WiFi error/restart

Utility ini akan **otomatis menyalakan kembali** hotspot dalam situasi-situasi tersebut.

### 7. Apakah akan conflict dengan VPN?
Tidak, utility ini tidak mengubah routing network atau konfigurasi VPN. Hotspot dan VPN bisa berjalan bersamaan.

### 8. Bagaimana cara melihat log aktivitas?
Jalankan file `View-Logs.bat` yang tersedia di folder instalasi. Log disimpan di `C:\ProgramData\AutoHotspotUtility\activity.log`.

Format log:
```
[2026-01-30 08:15:00] INFO: Hotspot already ON - No action needed
[2026-01-30 08:25:00] INFO: Hotspot is OFF - Attempting to activate...
[2026-01-30 08:25:02] SUCCESS: Hotspot activated successfully
```

### 9. Apakah perlu antivirus dimatikan saat install?
Tidak perlu. Namun beberapa antivirus overprotective mungkin memblok karena script meminta hak Administrator. Anda bisa whitelist file `.bat` ini di antivirus Anda.

### 10. Bagaimana cara uninstall?
Jalankan file `Uninstall.bat` yang tersedia, atau:
1. Buka Task Scheduler
2. Hapus task "Auto Start Hotspot"
3. Hapus folder `C:\ProgramData\AutoHotspotUtility`

---

## 🔧 Pertanyaan Teknis

### Apa yang dilakukan script ini di background?
Script ini membuat scheduled task yang:
1. Berjalan setiap X menit (sesuai pilihan Anda)
2. Mengecek status Mobile Hotspot via Windows API
3. Jika OFF, menyalakan kembali
4. Mencatat semua aktivitas di log file

### Apakah script ini mengubah registry Windows?
Tidak sama sekali. Script ini hanya:
- Membuat file di `C:\ProgramData\AutoHotspotUtility`
- Membuat task di Windows Task Scheduler
- Tidak menyentuh registry

### Kenapa butuh hak Administrator?
Karena:
1. Membuat scheduled task memerlukan admin rights
2. Menyalakan Mobile Hotspot memerlukan elevated privileges
3. Menulis file di `C:\ProgramData` memerlukan admin access

### Bisakah saya modifikasi interval di Task Scheduler langsung?
**Bisa!** Tapi lebih mudah jalankan ulang installer. Jika Anda mau manual:
1. Buka Task Scheduler
2. Cari task "Auto Start Hotspot"
3. Klik kanan > Properties
4. Tab "Triggers" > Edit > Ubah interval

---

## 💡 Tips & Tricks

### Mengoptimalkan Battery Life
Jika Anda ingin hotspot tetap auto-on tapi hemat baterai:
- Pilih interval 20 menit saat install
- Set power plan ke "Balanced" atau "Power Saver"
- Di pengaturan hotspot, batasi jumlah device yang bisa connect

### Monitoring yang Lebih Aktif
Jika Anda ingin monitoring real-time:
- Pilih interval 5 menit
- Bookmark file `Check-Status.bat` untuk quick access
- Buat shortcut `View-Logs.bat` di desktop

### Kombinasi dengan Startup Programs
Jika Anda ingin hotspot langsung ON saat Windows boot:
- Script ini sudah otomatis via Task Scheduler
- Tapi jika ingin lebih cepat, Anda bisa set task untuk trigger "At startup"

---

## 📞 Masih Ada Pertanyaan?

Jika pertanyaan Anda belum terjawab:
1. Cek file `TROUBLESHOOTING.md` untuk solusi masalah umum
2. Lihat log di `View-Logs.bat` untuk detail error
3. Buka issue di [GitHub Repository](https://github.com/adeism/auto-start-windows-mobile-hotspot/issues)

Selamat menikmati internet tanpa gangguan! 🎉