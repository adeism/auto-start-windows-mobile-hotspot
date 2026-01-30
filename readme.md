# Windows Auto Hotspot - Edisi Anti Ngambek! ⚡

[![GitHub release](https://img.shields.io/github/v/release/adeism/auto-start-windows-mobile-hotspot)](https://github.com/adeism/auto-start-windows-mobile-hotspot/releases)
[![GitHub stars](https://img.shields.io/github/stars/adeism/auto-start-windows-mobile-hotspot)](https://github.com/adeism/auto-start-windows-mobile-hotspot/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/adeism/auto-start-windows-mobile-hotspot)](https://github.com/adeism/auto-start-windows-mobile-hotspot/issues)
[![GitHub license](https://img.shields.io/github/license/adeism/auto-start-windows-mobile-hotspot)](https://github.com/adeism/auto-start-windows-mobile-hotspot/blob/main/LICENSE)

Pernah kesal karena **Mobile Hotspot** di Windows 11 tiba-tiba mati sendiri? Lagi asyik tethering untuk kerja atau main game, eh koneksi putus di tengah jalan. Tentu menyebalkan.

Skrip ini adalah solusi untuk hotspot Anda. Cukup jalankan sekali, dan biarkan skrip ini menjadi "pawang" yang memastikan hotspot Anda tetap menyala, apapun yang terjadi. Anggap saja ini solusi agar hotspot-nya tidak gampang nonaktif.

## ✨ Fitur Unggulan

* 💻 **Instalasi Sekali Klik**: Cukup jalankan sebagai Administrator, sisanya serahkan pada skrip ini. Tidak perlu pusing membuka-buka pengaturan.
* ⚙️ **Interval yang Dapat Dikustomisasi**: Pilih sendiri seberapa sering hotspot dicek (5, 10, atau 20 menit) sesuai kebutuhan Anda.
* 🤖 **Otomatis Penuh**: Skrip akan membuat *Task Scheduler* yang akan mengecek dan menyalakan kembali hotspot Anda secara berkala.
* 💪 **Anti Padam & Keras Kepala**: Walaupun tidak ada perangkat yang terhubung, PC baru dinyalakan, atau saat Windows sedang tidak stabil, hotspot akan tetap dipaksa hidup kembali.
* 📝 **Logging System**: Semua aktivitas dicatat dalam log file untuk memudahkan troubleshooting dan monitoring.
* 🧹 **Instalasi Bersih**: Menjalankan skrip ini lagi? Tenang, skrip akan otomatis menghapus konfigurasi lama sebelum memasang yang baru. Jadi selalu bersih dan rapi.
* 🛠️ **Utility Scripts**: Dilengkapi dengan tools untuk cek status, lihat logs, dan uninstall dengan mudah.

## 🚀 Cara Pakai (Sangat Mudah)

1.  📥 **Unduh**: _Download_ file `setup-auto-start-hotspot.bat` dari repositori ini.
2.  🖱️ **Jalankan sebagai Admin**: **Klik kanan** pada file `setup-auto-start-hotspot.bat`, lalu pilih "**Run as administrator**". Langkah ini sangat penting agar skrip dapat berjalan dengan benar.
3.  ⚙️ **Pilih Interval**: Pilih seberapa sering hotspot akan dicek (5, 10, atau 20 menit). Pilih default (10 menit) jika tidak yakin.
4.  ✅ **Selesai & Nikmati**: Sebuah jendela _command prompt_ akan muncul, melakukan prosesnya dalam beberapa detik, dan selesai! Hotspot Anda kini akan selalu aktif saat dibutuhkan.

Itu saja! Anda tidak perlu melakukan apa-apa lagi.

## 🛠️ Utility Scripts

Setelah instalasi, Anda akan memiliki akses ke beberapa utility scripts:

### `Check-Status.bat`
🔍 Cek status real-time dari:
- Task Scheduler
- Mobile Hotspot (ON/OFF)
- Jumlah device yang terhubung
- 10 log entries terakhir

### `View-Logs.bat`
📋 Lihat activity log untuk:
- Monitoring kapan hotspot mati dan dinyalakan
- Troubleshooting jika ada masalah
- Melihat 50 baris log terakhir

### `Uninstall.bat`
🗑️ Hapus utility dengan mudah:
- Menghapus Task Scheduler
- Menghapus semua file utility
- One-click uninstall

## 🔧 Cara Kerja (Untuk yang Ingin Tahu)

Penasaran bagaimana cara kerjanya? Cukup sederhana.

Skrip `setup-auto-start-hotspot.bat` ini sebenarnya adalah sebuah **installer**. Tugas utamanya adalah:
1.  **Membuat Skrip Pekerja**: Dia akan membuat sebuah file skrip kecil (PowerShell `Start-Hotspot.ps1`) di folder `C:\ProgramData\AutoHotspotUtility`. File inilah yang memiliki perintah untuk menyalakan hotspot.
2.  **Membuat Jadwal Otomatis**: Kemudian, installer ini mendaftarkan tugas pada **Task Scheduler** (penjadwal tugas bawaan Windows) untuk menjalankan skrip pekerja tadi sesuai interval yang Anda pilih.
3.  **Logging Aktivitas**: Setiap kali script berjalan, aktivitas dicatat di `activity.log` untuk monitoring.

Jadi, jika hotspot nonaktif, penjadwal tugas akan otomatis bertindak dan menyalakannya lagi.

## 📊 Format Log

Log disimpan di `C:\ProgramData\AutoHotspotUtility\activity.log` dengan format:

```
[2026-01-30 08:15:00] INFO: Hotspot already ON - No action needed
[2026-01-30 08:25:00] INFO: Hotspot is OFF - Attempting to activate...
[2026-01-30 08:25:02] SUCCESS: Hotspot activated successfully
[2026-01-30 08:35:00] ERROR: No active internet connection profile found
```

## 🗑️ Cara Menghapus (Jika Sudah Tidak Dibutuhkan)

### Cara Mudah (Recommended)
Jalankan file `Uninstall.bat` yang tersedia di repository ini.

### Cara Manual
1.  Buka **Task Scheduler** (cari saja di Start Menu).
2.  Di panel kiri, klik "**Task Scheduler Library**".
3.  Cari tugas bernama `Auto Start Hotspot`.
4.  Klik kanan pada tugas itu, lalu pilih **Delete**.
5.  **(Opsional)** Hapus folder `C:\ProgramData\AutoHotspotUtility` untuk menghilangkan sisa file.

Selesai! Komputer Anda kembali seperti semula.

## 📚 Dokumentasi Lengkap

- **[FAQ](FAQ.md)** - Pertanyaan yang sering ditanyakan
- **[TROUBLESHOOTING](TROUBLESHOOTING.md)** - Panduan mengatasi masalah

## 🔄 Update Interval

Ingin mengubah interval pengecekan? Jalankan ulang `setup-auto-start-hotspot.bat` dan pilih interval baru. Script akan otomatis update konfigurasi.

## 🖥️ Kompatibilitas

- ✅ Windows 11 (Semua versi)
- ✅ Windows 10 (Version 1607 atau lebih baru)
- ❌ Windows 8.1 dan dibawahnya (Mobile Hotspot tidak tersedia)

## ⚠️ Catatan Penting

1. **Koneksi Internet Diperlukan**: Mobile Hotspot memerlukan koneksi internet aktif (Ethernet/WiFi/USB Tethering) untuk bisa dishare.
2. **WiFi Adapter Compatibility**: Pastikan WiFi adapter Anda support "Hosted Network". Cek dengan command: `netsh wlan show drivers`
3. **Administrator Rights**: Script memerlukan hak Administrator untuk:
   - Membuat Task Scheduler
   - Mengaktifkan Mobile Hotspot
   - Menulis file di `C:\ProgramData`

## 📂 Struktur File

Setelah instalasi, struktur file akan seperti ini:

```
C:\ProgramData\AutoHotspotUtility\
├── Start-Hotspot.ps1       # PowerShell script utama
└── activity.log             # Log file (dibuat otomatis)

Repository Files:
├── setup-auto-start-hotspot.bat  # Installer
├── Uninstall.bat                 # Uninstaller
├── Check-Status.bat              # Status checker
├── View-Logs.bat                 # Log viewer
├── FAQ.md                        # FAQ dokumentasi
├── TROUBLESHOOTING.md            # Troubleshooting guide
└── readme.md                     # File ini
```

## 🤝 Contributing

Kontribusi selalu welcome! Jika Anda menemukan bug atau punya ide fitur baru:

1. Fork repository ini
2. Buat branch untuk fitur Anda (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

Atau cukup buka [Issue](https://github.com/adeism/auto-start-windows-mobile-hotspot/issues) untuk melaporkan bug atau request fitur.

## 📝 License

Project ini menggunakan lisensi MIT. Silakan lihat file `LICENSE` untuk detail lengkap.

## 🙏 Acknowledgments

- Terima kasih untuk semua yang sudah star repository ini ⭐
- Terima kasih untuk contributors yang membantu improve utility ini
- Dibuat karena frustrasi dengan Mobile Hotspot yang suka mati sendiri 😤

## 💡 Tips Penggunaan

### Untuk Battery Life Optimal
- Pilih interval 20 menit
- Set power plan ke "Balanced" atau "Power Saver"

### Untuk Monitoring Aktif
- Pilih interval 5 menit
- Bookmark `Check-Status.bat` untuk quick access
- Buat shortcut `View-Logs.bat` di desktop

### Troubleshooting
Jika hotspot masih mati:
1. Jalankan `Check-Status.bat` untuk diagnosis
2. Lihat `View-Logs.bat` untuk melihat error
3. Baca `TROUBLESHOOTING.md` untuk solusi detail
4. Buka issue di GitHub jika masih bermasalah

---

**Versi**: 1.1  
**Last Updated**: January 2026

Dibuat dengan sedikit kekesalan dan banyak baris kode. Semoga bermanfaat dan selamat menikmati internet tanpa gangguan! 🎉