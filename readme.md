# 📡 Always-On Windows Hotspot Utility

Sebuah skrip dan panduan sederhana untuk membuat fitur Mobile Hotspot di Windows 11 agar selalu aktif, bahkan setelah komputer di-restart atau saat tidak ada perangkat yang terhubung.

---

## ⚠️ Masalah yang Dipecahkan

Fitur Mobile Hotspot bawaan Windows 11 seringkali mati secara otomatis untuk menghemat daya. Hal ini terjadi karena dua alasan utama:
1.  Pengaturan **Power Saving** bawaan yang mematikan hotspot jika tidak ada perangkat terhubung.
2.  Pengaturan **Power Management** pada adapter Wi-Fi yang mengizinkan sistem untuk mematikan perangkat keras sepenuhnya.

Proyek ini menyediakan solusi otomatis untuk mengatasi kedua masalah tersebut dan memastikan hotspot Anda selalu siap digunakan.

## 🚀 Fitur Utama

-   ✅ **Otomatis Nyala Saat Login**: Hotspot akan aktif secara otomatis setiap kali Anda masuk ke Windows.
-   🔋 **Mencegah Hotspot Mati**: Mengatasi pengaturan hemat daya yang sering mematikan hotspot.
-   🔄 **Pemeriksaan Berkala**: Skrip akan memeriksa status hotspot setiap 10 menit dan menyalakannya kembali jika ditemukan dalam keadaan mati.
-   🛠️ **Instalasi Mudah**: Cukup dengan satu skrip PowerShell dan satu tugas di Task Scheduler.

## 📋 Prasyarat

-   **Sistem Operasi**: Windows 11 (Mungkin berfungsi di Windows 10, tetapi belum diuji).
-   **Hak Akses**: Administrator untuk mengatur Task Scheduler dan Device Manager.

## ⚙️ Panduan Instalasi

Ikuti 3 langkah berikut untuk membuat hotspot Anda selalu aktif.

### 1️⃣ Langkah 1: Konfigurasi Manual Windows

Langkah ini penting untuk mencegah Windows mematikan perangkat keras Wi-Fi Anda.

-   **Nonaktifkan Power Saving Hotspot**:
    -   Buka **Settings > Network & internet > Mobile hotspot**.
    -   Matikan (set ke **Off**) pilihan **Power saving**.

-   **Nonaktifkan Power Management Adapter Wi-Fi**:
    -   Buka **Device Manager** (Klik kanan Start Menu > Device Manager).
    -   Buka `Network adapters`, klik kanan pada adapter Wi-Fi Anda (misal: *Intel(R) Wi-Fi*).
    -   Pilih **Properties**, lalu buka tab **Power Management**.
    -   Hilangkan centang pada kotak **"Allow the computer to turn off this device to save power"**.
    -   Klik **OK**.

### 2️⃣ Langkah 2: Siapkan Skrip PowerShell

1.  Unduh atau buat file `Start-Hotspot.ps1` dari repositori ini.
2.  Letakkan file tersebut di lokasi yang tidak akan Anda hapus, misalnya: `C:\Scripts\Start-Hotspot.ps1`.

    **Isi file `Start-Hotspot.ps1`:**
    ```powershell
    try {
        $connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile()
        $tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

        if ($tetheringManager.TetheringOperationalState -ne 'On') {
            $tetheringManager.StartTetheringAsync() | Out-Null
        }
    }
    catch {
        # Skrip akan berhenti jika ada error (misal: tidak ada koneksi internet)
    }
    ```

### 3️⃣ Langkah 3: Buat Tugas di Task Scheduler

Tugas ini akan menjalankan skrip secara otomatis.

1.  Buka **Task Scheduler** (cari di Start Menu).
2.  Di panel kanan, klik **Create Task...**.
3.  **Tab General**:
    -   **Name**: `Auto Start Hotspot`
    -   Centang **Run with highest privileges**.
4.  **Tab Triggers**:
    -   Klik **New...**.
    -   Begin the task: **At log on**.
    -   Centang **Repeat task every** `10 minutes` for a duration of **Indefinitely**.
    -   Klik **OK**.
5.  **Tab Actions**:
    -   Klik **New...**.
    -   Program/script: `powershell.exe`
    -   Add arguments (optional): `-ExecutionPolicy Bypass -File "C:\Scripts\Start-Hotspot.ps1"`
        *(Pastikan path file ini sesuai dengan lokasi Anda menyimpan skrip)*.
    -   Klik **OK**.
6.  **Tab Conditions**:
    -   Hilangkan centang pada **Start the task only if the computer is on AC power**.
7.  Klik **OK** untuk menyimpan.

## 💡 Cara Penggunaan

Setelah instalasi selesai, Anda tidak perlu melakukan apa-apa lagi. Cukup restart komputer Anda, dan Mobile Hotspot akan menyala secara otomatis setelah Anda login.

## 🔧 Troubleshooting

-   **Hotspot tidak menyala?** Pastikan path file skrip di Task Scheduler (Tab Actions) sudah benar.
-   **Akses Ditolak?** Pastikan Anda mencentang "Run with highest privileges" saat membuat tugas.

## 📜 Lisensi

Proyek ini dilisensikan di bawah [Lisensi MIT](LICENSE.md).
