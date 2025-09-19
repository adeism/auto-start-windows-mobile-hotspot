# Windows Auto Hotspot - Edisi Anti Ngambek! ⚡

Pernah kesal karena **Mobile Hotspot** di Windows 11 tiba-tiba mati sendiri? Lagi asyik tethering untuk kerja atau main game, eh koneksi putus di tengah jalan. Tentu menyebalkan.

Skrip ini adalah solusi untuk hotspot Anda. Cukup jalankan sekali, dan biarkan skrip ini menjadi "pawang" yang memastikan hotspot Anda tetap menyala, apapun yang terjadi. Anggap saja ini solusi agar hotspot-nya tidak gampang nonaktif.

## ✨ Fitur Unggulan

* 💻 **Instalasi Sekali Klik**: Cukup jalankan sebagai Administrator, sisanya serahkan pada skrip ini. Tidak perlu pusing membuka-buka pengaturan.
* 🤖 **Otomatis Penuh**: Skrip akan membuat *Task Scheduler* yang akan mengecek dan menyalakan kembali hotspot Anda setiap **10 menit** (jika sangat penting silakan ganti durasinya).
* 💪 **Anti Padam & Keras Kepala**: Walaupun tidak ada perangkat yang terhubung, PC baru dinyalakan, atau saat Windows sedang tidak stabil, hotspot akan tetap dipaksa hidup kembali.
* 🧹 **Instalasi Bersih**: Menjalankan skrip ini lagi? Tenang, skrip akan otomatis menghapus konfigurasi lama sebelum memasang yang baru. Jadi selalu bersih dan rapi.

## 🚀 Cara Pakai (Sangat Mudah)

1.  📥 **Unduh**: _Download_ file `setup-auto-start-hotspot.bat` dari repositori ini.
2.  🖱️ **Jalankan sebagai Admin**: **Klik kanan** pada file `setup-auto-start-hotspot.bat`, lalu pilih "**Run as administrator**". Langkah ini sangat penting agar skrip dapat berjalan dengan benar.
3.  ✅ **Selesai & Nikmati**: Sebuah jendela _command prompt_ akan muncul, melakukan prosesnya dalam beberapa detik, dan selesai! Hotspot Anda kini akan selalu aktif saat dibutuhkan.

Itu saja! Anda tidak perlu melakukan apa-apa lagi.

## 🔧 Cara Kerja (Untuk yang Ingin Tahu)

Penasaran bagaimana cara kerjanya? Cukup sederhana.

Skrip `setup-auto-start-hotspot.bat` ini sebenarnya adalah sebuah **installer**. Tugas utamanya adalah:
1.  **Membuat Skrip Pekerja**: Dia akan membuat sebuah file skrip kecil (PowerShell `Start-Hotspot.ps1`) di folder `C:\ProgramData\AutoHotspotUtility`. File inilah yang memiliki perintah untuk menyalakan hotspot.
2.  **Membuat Jadwal Otomatis**: Kemudian, installer ini mendaftarkan tugas pada **Task Scheduler** (penjadwal tugas bawaan Windows) untuk menjalankan skrip pekerja tadi setiap 10 menit.

Jadi, jika hotspot nonaktif, penjadwal tugas akan otomatis bertindak dan menyalakannya lagi.

## 🗑️ Cara Menghapus (Jika Sudah Tidak Dibutuhkan)

Sudah tidak memerlukan fitur ini lagi? Mudah saja.

1.  Buka **Task Scheduler** (cari saja di Start Menu).
2.  Di panel kiri, klik "**Task Scheduler Library**".
3.  Cari tugas bernama `Auto Start Hotspot`.
4.  Klik kanan pada tugas itu, lalu pilih **Delete**.
5.  **(Opsional)** Hapus folder `C:\ProgramData\AutoHotspotUtility` untuk menghilangkan sisa file.

Selesai! Komputer Anda kembali seperti semula.

---

Dibuat dengan sedikit kekesalan dan banyak baris kode. Semoga bermanfaat dan selamat menikmati internet tanpa gangguan! 🎉
