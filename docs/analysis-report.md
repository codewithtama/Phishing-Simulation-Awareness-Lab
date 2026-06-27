# Template Laporan Analisis — Phishing Simulation Campaign

> **Cara Penggunaan:** Salin dokumen ini, isi bagian yang di-highlight `[PLACEHOLDER]`, dan sajikan ke manajemen atau tim keamanan setelah kampanye selesai. Selalu anonimisasi data individual — sajikan hanya agregat departemen.

---

## Ringkasan Eksekutif

**Nama Kampanye:** `[Nama Kampanye]`  
**Periode Kampanye:** `[Tanggal Mulai]` — `[Tanggal Selesai]`  
**Dibuat oleh:** `[Nama / Tim IT Security]`  
**Tanggal Laporan:** `[Tanggal]`  
**Klasifikasi:** `INTERNAL — CONFIDENTIAL`

---

## 1. Gambaran Umum Kampanye

| Parameter | Detail |
|-----------|--------|
| Template Email | `[hr-policy-update / ga-inventory-check / it-password-reset]` |
| Landing Page | `[office365-login / company-portal]` |
| Total Target | `[N]` karyawan |
| Departemen Tercakup | `[Daftar departemen]` |
| Metode Pengiriman | Gophish via MailHog (lokal) / SMTP eksternal |
| Jenis Simulasi | Spear Phishing / Blast Phishing |

---

## 2. Statistik Utama (Key Metrics)

### 2.1 Funnel Overview

```
Total Email Terkirim
        │
        ▼
   Email Dibuka ──────────────── Open Rate = Dibuka / Terkirim
        │
        ▼
   Link Diklik ─────────────── Click Rate = Diklik / Dibuka
        │
        ▼
   Form Disubmit ────────── Submit Rate = Submit / Diklik
```

### 2.2 Tabel Hasil

| Metrik | Jumlah | Persentase | Benchmark Industri |
|--------|--------|------------|-------------------|
| Email Terkirim | `[N]` | 100% | — |
| Email Dibuka | `[N]` | `[X]%` | 30–50% |
| Link Diklik | `[N]` | `[X]%` | 15–30% |
| Form Disubmit | `[N]` | `[X]%` | 5–15% |
| **Dilaporkan ke IT** | `[N]` | `[X]%` | Target: >20% |
| Tidak Berinteraksi | `[N]` | `[X]%` | — |

> **Catatan Interpretasi:**
> - **Open Rate** diukur via tracking pixel. Beberapa email client (Outlook Preview Pane) dapat trigger ini tanpa user membaca secara aktif.
> - **Click Rate** adalah indikator utama kerentanan.
> - **Submit Rate** menunjukkan tingkat kerentanan tertinggi — user yang benar-benar hampir menyerahkan kredensial.
> - **Report Rate** adalah metrik keberhasilan program awareness — semakin tinggi semakin baik.

---

## 3. Breakdown per Departemen

> **Privacy Note:** Tabel di bawah menampilkan data agregat departemen. Data individual TIDAK BOLEH disebarluaskan.

| Departemen | Total Target | Klik Link | Klik Rate | Submit | Submit Rate | Risk Level |
|------------|-------------|-----------|-----------|--------|-------------|------------|
| Finance | `[N]` | `[N]` | `[X]%` | `[N]` | `[X]%` | 🔴 / 🟡 / 🟢 |
| HR | `[N]` | `[N]` | `[X]%` | `[N]` | `[X]%` | 🔴 / 🟡 / 🟢 |
| IT | `[N]` | `[N]` | `[X]%` | `[N]` | `[X]%` | 🔴 / 🟡 / 🟢 |
| Operations | `[N]` | `[N]` | `[X]%` | `[N]` | `[X]%` | 🔴 / 🟡 / 🟢 |
| Marketing | `[N]` | `[N]` | `[X]%` | `[N]` | `[X]%` | 🔴 / 🟡 / 🟢 |
| **TOTAL** | `[N]` | `[N]` | **`[X]%`** | `[N]` | **`[X]%`** | — |

**Risk Level Definition:**
- 🔴 **High Risk** : Click rate > 30% — Perlu targeted training segera
- 🟡 **Medium Risk**: Click rate 15–30% — Perlu awareness reinforcement
- 🟢 **Low Risk**  : Click rate < 15% — Pertahankan, monitoring berkala

---

## 4. Timeline Analysis

### 4.1 Kapan Email Paling Banyak Dibuka?

```
Hari Pertama (D+0):  ████████████████████ [N] opens  (puncak)
Hari Kedua  (D+1):  ████████████         [N] opens
Hari Ketiga (D+2):  ████████             [N] opens
Hari Keempat(D+3):  ████                 [N] opens
Hari Kelima (D+4):  ██                   [N] opens
```

> **Insight:** `[Tuliskan insight — misal: "60% klik terjadi dalam 2 jam pertama pengiriman email, mengindikasikan target tidak mengambil waktu untuk memverifikasi"]`

### 4.2 Jam Paling Rentan

| Jam | Aktivitas Klik | Catatan |
|-----|---------------|---------|
| 07:00 – 09:00 | `[N]` klik | Pre-meeting rush |
| 09:00 – 12:00 | `[N]` klik | Peak work hours |
| 12:00 – 13:00 | `[N]` klik | Lunch break |
| 13:00 – 17:00 | `[N]` klik | Afternoon work |
| 17:00 – 20:00 | `[N]` klik | After work |

---

## 5. Analisis Perangkat & Client

| Platform | Jumlah | Persentase |
|----------|--------|------------|
| Windows Desktop (Outlook) | `[N]` | `[X]%` |
| Mobile Android | `[N]` | `[X]%` |
| Mobile iOS | `[N]` | `[X]%` |
| Web Browser | `[N]` | `[X]%` |
| macOS | `[N]` | `[X]%` |

> **Insight:** `[Misal: "Pengguna mobile 40% lebih mungkin mengklik dibanding desktop, kemungkinan karena keterbatasan melihat URL lengkap di mobile"]`

---

## 6. Perbandingan dengan Kampanye Sebelumnya

> Isi tabel ini setelah kampanye kedua dan seterusnya untuk mengukur progress program awareness.

| Kampanye | Tanggal | Click Rate | Submit Rate | Report Rate | Delta Click |
|----------|---------|-----------|-------------|-------------|-------------|
| Baseline (Q1 2025) | Jan 2025 | `[X]%` | `[X]%` | `[X]%` | — |
| Kampanye ini (Q3 2025) | Jul 2025 | `[X]%` | `[X]%` | `[X]%` | `[±X]%` |
| Target Q4 2025 | Okt 2025 | < 15% | < 5% | > 30% | — |

---

## 7. Red Flags yang Paling Sering Terlewat

Berdasarkan analisis template yang digunakan, berikut elemen yang paling efektif menipu target:

| Red Flag yang Harusnya Diperhatikan | % Target yang Tetap Klik |
|------------------------------------|--------------------------|
| Domain pengirim tidak cocok dengan domain resmi | `[X]%` |
| URL landing page bukan domain perusahaan | `[X]%` |
| Urgency "24 jam" / deadline ketat | `[X]%` |
| Tidak ada verifikasi via saluran lain (telepon/Slack) | `[X]%` |
| Permintaan input password di halaman tidak familiar | `[X]%` |

---

## 8. Temuan & Rekomendasi

### 8.1 Temuan Utama

```
[1] CRITICAL — Submit Rate [X]% melebihi threshold 10%
    → Karyawan belum memahami bahwa IT tidak pernah meminta password via email.

[2] HIGH — Report Rate [X]% di bawah target 20%
    → Karyawan tidak tahu cara melaporkan email mencurigakan ke IT Security.

[3] MEDIUM — Mobile click rate [X]% lebih tinggi dari desktop
    → Perlu awareness khusus untuk penggunaan email di perangkat mobile.

[4] LOW — Open rate hari pertama [X]%
    → Perlu pertimbangan untuk stagger pengiriman di kampanye berikutnya.
```

### 8.2 Rekomendasi Tindak Lanjut

| # | Rekomendasi | Prioritas | PIC | Target Selesai |
|---|-------------|-----------|-----|----------------|
| 1 | Mandatory security awareness training (1 jam) untuk semua karyawan | 🔴 Tinggi | HR + IT | [Tanggal] |
| 2 | Buat panduan "Cara Melaporkan Email Phishing" dan distribusikan | 🔴 Tinggi | IT Security | [Tanggal] |
| 3 | Pasang banner peringatan di email client untuk email eksternal | 🟡 Sedang | IT Infra | [Tanggal] |
| 4 | Implementasi MFA untuk semua akun karyawan | 🔴 Tinggi | IT | [Tanggal] |
| 5 | Jadwalkan kampanye simulasi Q4 dengan template berbeda | 🟡 Sedang | IT Security | [Tanggal] |
| 6 | Departemen high-risk mendapat sesi pelatihan tambahan | 🔴 Tinggi | HR + IT | [Tanggal] |
| 7 | Evaluasi konfigurasi email filtering (DMARC, SPF, DKIM) | 🟡 Sedang | IT Infra | [Tanggal] |

---

## 9. Cara Membaca Dashboard Gophish

### 9.1 Status Icons

```
📧 Email Sent      — Email berhasil terkirim ke MailHog/SMTP
👁 Email Opened    — Tracking pixel dimuat (email dibuka)
🖱 Clicked Link    — User mengklik tautan phishing
📝 Submitted Data  — User berinteraksi dengan form login
📩 Email Reported  — User melaporkan email (via Gophish report button)
```

### 9.2 Mengekspor Data

```
1. Login ke https://localhost:3333
2. Campaigns > [Nama Campaign] > View Results
3. Klik "Export CSV" untuk raw data
4. Klik "Export JSON" untuk data lengkap termasuk timestamp

Atau via API:
curl -k -H "Authorization: [API_KEY]" \
  https://localhost:3333/api/campaigns/[ID]/results
```

### 9.3 Menghitung Metrics Manual

```python
# Dari CSV export Gophish
import csv
from collections import defaultdict

results = defaultdict(int)

with open("campaign_results.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        results["total"] += 1
        if row["opened"] == "true": results["opened"] += 1
        if row["clicked"] == "true": results["clicked"] += 1
        if row["submitted_data"] == "true": results["submitted"] += 1

print(f"Open Rate   : {results['opened']/results['total']*100:.1f}%")
print(f"Click Rate  : {results['clicked']/results['total']*100:.1f}%")
print(f"Submit Rate : {results['submitted']/results['total']*100:.1f}%")
```

---

## 10. Penutup

### Pernyataan Etika

Seluruh data dalam laporan ini dikumpulkan dalam rangka **program peningkatan keamanan siber internal** yang telah mendapat otorisasi dari manajemen. Tidak ada kredensial, password, atau data sensitif individu yang dikumpulkan atau disimpan selama simulasi. Data ini digunakan semata-mata untuk keperluan edukasi dan peningkatan postur keamanan organisasi.

### Langkah Selanjutnya

- [ ] Distribusikan ringkasan eksekutif ke manajemen
- [ ] Jadwalkan sesi edukasi wajib dalam 2 minggu
- [ ] Update security policy berdasarkan temuan
- [ ] Tentukan tanggal kampanye simulasi berikutnya
- [ ] Arsipkan laporan ini dengan enkripsi

---

**Laporan dibuat oleh:** `[Nama]` — IT Security Division  
**Disetujui oleh:** `[Nama Manager/CISO]`  
**Tanggal distribusi:** `[Tanggal]`  
**Retention period:** 1 tahun dari tanggal kampanye (kemudian dihapus secara aman)

---

*Dokumen ini bersifat CONFIDENTIAL. Distribusi hanya kepada pihak yang berwenang.*
