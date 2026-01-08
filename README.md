# AgroBiz Simulator - Factory Feasibility Calculator

**Project Name:** Digital Agro Systems (Student Dev Project)
**Nama Mahasiswa:** Muhammad Ijlal Senja Pratama
**Topik Pabrik:** Pakan Ternak (Feed Mill)

## Deskripsi Kasus
Aplikasi ini adalah simulasi kelayakan bisnis untuk pabrik Pakan Ternak. Pengguna dapat memasukkan parameter investasi (Capex), biaya operasional (Opex), dan target produksi untuk melihat apakah usaha tersebut layak dijalankan.

## Fitur Utama
- **Multi-platform:** Berjalan di Android (Offline) dan Web (Online).
- **Real-time Calculation:** BEP dan ROI dihitung otomatis saat input berubah.
- **Stateless:** Tidak ada data yang disimpan ke server (Privacy First).

## Rumus yang Digunakan

### 1. Break Even Point (BEP)
Menghitung titik impas dimana pendapatan menutup biaya.
- **Contribution Margin Unit** = Harga Jual - Biaya Variabel per Unit
- **BEP (Unit)** = Total Biaya Tetap / Contribution Margin Unit
- **BEP (Rupiah)** = BEP Unit × Harga Jual

### 2. Return on Investment (ROI)
Estimasi pengembalian modal dalam setahun.
- **Profit (Bulanan)** = Pendapatan - (Biaya Variabel + Biaya Tetap)
- **Profit (Tahunan)** = Profit Bulanan × 12
- **ROI (%)** = (Profit Tahunan / Total Investasi Awal) × 100%

## Cara Menggunakan
1.  **Tab Input:** Masukkan data Modal Awal, Data Produksi, dan Biaya Operasional.
2.  **Tab Hasil:** Lihat indikator kelayakan (BEP, ROI, Profit) dan grafik biaya pada dashboard.
3.  **Reset:** Tekan tombol refresh di pojok kanan atas untuk mengulang simulasi.

## Link Demo & Download
- **Live Web Demo:** [Vercel Link Here] (Akan tersedia setelah deploy)
- **Download APK:** [GitHub Releases]

## Tech Stack
- **Framework:** Flutter (Dart)
- **Charts:** fl_chart
- **Typography:** Google Fonts (Outfit)
