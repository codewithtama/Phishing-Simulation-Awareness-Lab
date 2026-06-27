<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=22&pause=1000&color=EF4444&center=true&vCenter=true&width=700&lines=Phishing+Simulation+Awareness+Lab;Corporate+Security+Training+Platform;Gophish+%2B+Docker+%2B+Zero-Harm+Design;Clone+and+run+in+under+5+minutes" alt="Typing SVG" />

<br/>

[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](docker-compose.yml)
[![Gophish](https://img.shields.io/badge/Engine-Gophish-EF4444?style=for-the-badge)](https://getgophish.com/)
[![MailHog](https://img.shields.io/badge/SMTP-MailHog-8B5CF6?style=for-the-badge)](https://github.com/mailhog/MailHog)
[![Zero Harm](https://img.shields.io/badge/Zero--Harm-No_Credentials_Stored-22C55E?style=for-the-badge)](#zero-harm)
[![Lang](https://img.shields.io/badge/Bahasa-Indonesia-DC2626?style=for-the-badge)](#)

<br/>

**Open-source phishing simulation lab untuk security awareness training korporat.**  
Clone → `docker-compose up` → kampanye simulasi berjalan dalam 5 menit.

</div>

---

## ⚠ Disclaimer Hukum & Etika

> Repositori ini dibuat **semata-mata untuk tujuan pendidikan dan simulasi keamanan siber yang sah**.
> Semua template, landing page, dan konfigurasi di sini dirancang untuk digunakan dalam lingkungan yang terkontrol dengan **izin eksplisit tertulis** dari manajemen organisasi.
>
> **Penggunaan teknik, template, atau konfigurasi apapun dari repositori ini terhadap individu atau sistem tanpa otorisasi adalah ILEGAL** dan dapat melanggar UU ITE No. 19 Tahun 2016 (Indonesia), CFAA (AS), serta regulasi siber lokal lainnya.
>
> Seluruh landing page mengimplementasikan **Zero-Harm Design** — tidak ada kredensial yang dikumpulkan, disimpan, atau ditransmisikan.

---

## Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Arsitektur](#arsitektur)
- [Quick Start](#quick-start)
- [Struktur Repository](#struktur-repository)
- [Template Email](#template-email)
- [Landing Pages](#landing-pages)
- [Zero-Harm Design](#zero-harm)
- [Cara Import ke Gophish](#cara-import-ke-gophish)
- [📖 Tutorial Lengkap Setelah Login](#-tutorial-lengkap-setelah-login)
  - [Step 1 — Sending Profile](#step-1--setup-sending-profile-smtp)
  - [Step 2 — Landing Page](#step-2--import-landing-page)
  - [Step 3 — Email Template](#step-3--import-email-template)
  - [Step 4 — Users & Groups](#step-4--buat-target-group)
  - [Step 5 — Launch Campaign](#step-5--buat--launch-campaign)
  - [Step 6 — Monitor & Analisis](#step-6--monitor--analisis-hasil)
- [Dokumentasi](#dokumentasi)
- [Kontribusi](#kontribusi)

---

## Fitur Utama

### 🏢 Corporate-Themed Templates (Konteks Indonesia)

Tiga template email phishing yang mencerminkan operasional kantor nyata di Indonesia:

| Template | Tema | Trigger Psikologis |
|----------|------|-------------------|
| `hr-policy-update.html` | Pembaruan Kebijakan Cuti Tahunan 2025 | Authority + Urgency |
| `ga-inventory-check.html` | Audit Inventaris Aset IT Triwulan | Fear of Loss + Compliance |
| `it-password-reset.html` | Peringatan Keamanan: Password Expired | Fear + Authority |

Template menggunakan variabel Gophish (`{{.FirstName}}`, `{{.URL}}`, dll.) untuk personalisasi otomatis.

### 🛡 Zero-Harm Design

Semua landing page menerapkan prinsip zero-harm:

```javascript
// Form submit TIDAK mengirimkan data ke server manapun
function handleSubmit(event) {
  event.preventDefault();           // Batalkan submit
  document.getElementById('...').value = ''; // Hapus input segera
  window.location.href = 'awareness-redirect.html'; // Redirect edukasi
  return false;
}
```

Gophish hanya mencatat **metadata** (siapa yang klik, kapan) — **bukan isi form**.

### 📚 Halaman Awareness yang Komprehensif

Landing page `awareness-redirect.html` adalah **mini training module** interaktif:
- Statistik ancaman siber global
- Red flags yang seharusnya diperhatikan (6 poin)
- Langkah respons yang benar (5 langkah)
- Quick tips keamanan siber
- CTA lapor ke IT Security

### 📋 Playbook & Dokumentasi Lengkap

- **`docs/methodology.md`** — Panduan kampanye 6 fase: dari otorisasi hingga debrief
- **`docs/analysis-report.md`** — Template laporan statistik siap pakai

### 🐳 One-Command Deploy

```bash
docker-compose up -d  # Gophish + MailHog berjalan dalam < 30 detik
```

---

## Arsitektur

```
┌─────────────────────────────────────────────────────────────┐
│                    PHISHING LAB NETWORK                      │
│                   (phishlab_network)                         │
│                                                             │
│  ┌─────────────────────┐    ┌─────────────────────────────┐ │
│  │      GOPHISH        │    │         MAILHOG             │ │
│  │  phishlab_gophish   │───▶│    phishlab_mailhog         │ │
│  │                     │SMTP│                             │ │
│  │  Admin: :3333 (TLS) │    │  UI:   localhost:8025       │ │
│  │  Phish: :80 → :8080 │    │  SMTP: localhost:1025       │ │
│  └─────────────────────┘    └─────────────────────────────┘ │
│           │                                                  │
│           │ serves                                           │
│           ▼                                                  │
│  ┌─────────────────────┐                                     │
│  │   LANDING PAGES     │                                     │
│  │  office365-login    │──[JS intercept]──▶ awareness-redirect│
│  │  company-portal     │                    (no data sent)   │
│  └─────────────────────┘                                     │
└─────────────────────────────────────────────────────────────┘

Host Machine
  ├── https://localhost:3333  → Gophish Admin Panel
  ├── http://localhost:8080   → Phishing Listener
  └── http://localhost:8025   → MailHog Web UI
```

**Alur Simulasi:**
```
1. Admin buat kampanye di Gophish Dashboard
2. Gophish kirim email via MailHog SMTP (localhost:1025)
3. Email muncul di MailHog Web UI (localhost:8025)
4. Target klik link → Gophish catat click event
5. Landing page muncul → JS intercept form submit
6. User redirect ke awareness-redirect.html
7. Admin pantau statistik real-time di Gophish Dashboard
```

---

## Quick Start

### Prerequisites

- [Docker Desktop](https://docs.docker.com/get-docker/) (Windows/Mac/Linux)
- [Docker Compose](https://docs.docker.com/compose/install/) v2+
- Port bebas: `3333`, `8025`, `8080`, `1025`

### Instalasi (3 Langkah)

```bash
# 1. Clone repository
git clone https://github.com/codewithtama/Phishing-Simulation-Awareness-Lab.git
cd Phishing-Simulation-Awareness-Lab

# 2. (Opsional) Salin dan edit environment config
cp .env.example .env

# 3. Jalankan semua service
docker-compose up -d
```

### Verifikasi

```bash
# Cek status container
docker-compose ps

# Output yang diharapkan:
# NAME                 STATUS          PORTS
# phishlab_gophish     Up (healthy)    0.0.0.0:3333->3333/tcp, 0.0.0.0:8080->80/tcp
# phishlab_mailhog     Up (healthy)    0.0.0.0:1025->1025/tcp, 0.0.0.0:8025->8025/tcp
```

### Akses

| Service | URL | Credentials |
|---------|-----|-------------|
| Gophish Admin | https://localhost:3333 | admin / *lihat log* |
| MailHog UI | http://localhost:8025 | Tidak perlu login |
| Phishing Listener | http://localhost:8080 | — |

```bash
# Mendapatkan password Gophish awal dari log (mode Docker)
docker logs phishlab_gophish 2>&1 | grep "Please login"

# Mendapatkan password Gophish awal dari log (mode lokal / start.ps1)
Get-Content .\bin\gophish\gophish.log | Select-String "Please login"
```

> **Penting:** Browser akan menampilkan warning "Your connection is not private" — ini normal karena Gophish menggunakan self-signed certificate. Klik **Advanced → Proceed to localhost** untuk melanjutkan.

> **Ganti password** default Gophish segera setelah login pertama via Account Settings (ikon profil pojok kanan atas).

---

## Struktur Repository

```
phishing-awareness-lab/
│
├── 📄 docker-compose.yml        # Orkestrasi Gophish + MailHog
├── 📄 .env.example              # Template environment variables
├── 📄 README.md                 # Dokumentasi ini
│
├── 📁 config/
│   └── gophish-config.json      # Konfigurasi Gophish (SMTP → MailHog)
│
├── 📁 templates/                # Email phishing templates
│   ├── hr-policy-update.html    # Pembaruan kebijakan cuti
│   ├── ga-inventory-check.html  # Audit aset IT
│   └── it-password-reset.html   # Peringatan password expired
│
├── 📁 landing_pages/            # Halaman login palsu (zero-harm)
│   ├── office365-login.html     # Klon Microsoft 365 login
│   ├── company-portal.html      # Klon portal karyawan internal
│   └── awareness-redirect.html  # ← Target redirect (halaman edukasi)
│
└── 📁 docs/
    ├── methodology.md           # Playbook kampanye 6 fase
    └── analysis-report.md       # Template laporan statistik
```

---

## Template Email

### 1. HR Policy Update (`hr-policy-update.html`)

**Skenario:** Email dari HR Division tentang pembaruan kebijakan cuti tahunan yang memerlukan tanda tangan digital karyawan.

**Kenapa efektif:**
- Menyebut nama karyawan (via `{{.FirstName}}`)
- Nomor surat resmi dan tanggal konkret
- Konsekuensi jelas jika tidak dikonfirmasi
- Desain email HR yang profesional

**Gophish Variables Used:**
```
{{.FirstName}} {{.LastName}}  — Nama target
{{.URL}}                      — Link phishing
{{.RId}}                      — Employee ID (tracking)
```

---

### 2. GA Inventory Check (`ga-inventory-check.html`)

**Skenario:** General Affairs meminta konfirmasi aset IT yang dipegang karyawan dalam rangka audit triwulanan.

**Kenapa efektif:**
- Daftar aset spesifik (laptop, mouse, ID card)
- Konsekuensi finansial (aset dianggap hilang)
- Deadline ketat (hari yang sama)
- Instruksi langkah-per-langkah yang meyakinkan

---

### 3. IT Password Reset (`it-password-reset.html`)

**Skenario:** IT Security memperingatkan karyawan bahwa password akun jaringan akan expired dalam 24 jam.

**Kenapa efektif:**
- Fear factor tinggi (akun diblokir, butuh approval manager untuk reaktivasi)
- Detail akun spesifik (email, waktu expired)
- Daftar syarat password baru menambah legitimasi
- Bahkan menyertakan "warning" anti-phishing palsu untuk mengurangi kecurigaan

---

## Landing Pages

### Office 365 Login (`office365-login.html`)

Replika pixel-faithful Microsoft 365 sign-in page:
- Logo Microsoft 4-kuadran asli (CSS, tanpa gambar)
- Form signin dengan field email + password
- "Forgot password?" dan "Create one!" links
- **Zero-harm:** Form tidak mengirim data ke manapun

### Company Portal (`company-portal.html`)

Portal SSO internal perusahaan:
- Header branding PT Maju Bersama
- Info panel fitur (desktop view)
- Form dengan NIK / email karyawan
- Tombol Microsoft SSO
- **Zero-harm:** Semua interaksi dialihkan ke awareness page

### Awareness Redirect (`awareness-redirect.html`) {#zero-harm}

**Halaman paling penting dalam lab ini.** Target yang "terkena" phishing langsung diarahkan ke halaman edukasi komprehensif:

- 📊 Statistik ancaman siber global
- 🚩 6 Red flags yang seharusnya diperhatikan
- ✅ 5 Langkah respons yang benar (jika email nyata)
- 💡 5 Quick tips keamanan siber
- 📧 CTA lapor ke IT Security

---

## Cara Import ke Gophish

### Step 1 — Import Sending Profile

```
Gophish Dashboard → Sending Profiles → New Profile

Name    : MailHog Local
From    : HR Division <hr-noreply@ptmajubersama.co.id>
Host    : localhost:1025        ← mode lokal (start.ps1 / start.bat)
          mailhog:1025          ← mode Docker (docker-compose)
Username: (kosong)
Password: (kosong)
```

### Step 2 — Import Email Template

```
Campaigns → Email Templates → New Template

Name   : [Pilih nama template]
Subject: Pembaruan Kebijakan Cuti Tahunan 2025 — Tindakan Diperlukan
HTML   : [Buka file templates/*.html → Ctrl+A → Ctrl+C → paste di tab HTML]
☑ Add Tracking Image
```

### Step 3 — Import Landing Page

```
Campaigns → Landing Pages → New Page

Name             : Office 365 Login (Simulation)
HTML             : [Buka file landing_pages/*.html → Ctrl+A → Ctrl+C → paste di tab HTML]
☐ Capture Submitted Data  ← JANGAN dicentang (zero-harm)
Redirect URL     : [URL awareness-redirect.html yang bisa diakses target]
```

### Step 4 — Import Target Group

```
Users & Groups → New Group

Import CSV format:
first_name,last_name,email,position
Budi,Santoso,budi.santoso@company.co.id,Finance
```

### Step 5 — Buat Campaign

```
Campaigns → New Campaign

Name         : Q3 2025 — HR Policy Simulation
Email        : [Template dari Step 2]
Landing Page : [Landing page dari Step 3]
URL          : http://localhost:8080
Launch Date  : [Jadwal]
Groups       : [Group dari Step 4]
```

---

## 📖 Tutorial Lengkap Setelah Login

> Panduan ini dimulai setelah lo berhasil login ke Gophish Admin Dashboard di `https://localhost:3333`.
> Ikuti **urutan step ini** karena setiap step bergantung pada step sebelumnya.

### Peta Alur Kerja

```
[Login] → [Sending Profile] → [Landing Page] → [Email Template]
                                                        ↓
              [Monitor & Analisis] ← [Campaign] ← [User Group]
```

---

### Step 0 — Jalankan Lab

**Kalau pakai mode lokal (tanpa Docker):**

Double-klik `start.bat` atau klik kanan `start.ps1` → **Run with PowerShell**.
Dua window hitam akan muncul (Gophish & MailHog). **Jangan tutup** kedua window itu.

**Kalau pakai Docker:**
```bash
docker-compose up -d
```

---

### Step 1 — Login ke Gophish

1. Buka browser → `https://localhost:3333`
2. Kalau muncul warning **"Your connection is not private"** → klik **Advanced** → **Proceed to localhost** (ini normal, Gophish pakai self-signed cert)
3. Login:
   - **Username:** `admin`
   - **Password:** lihat di window Gophish yang terbuka, baris bertulisan `Please login with the username admin and the password XXXXXXXXXXXXXXXX`
4. Setelah masuk, **ganti password** di ikon profil pojok kanan atas → **Account Settings**

---

### Step 2 — Setup Sending Profile (SMTP)

Sending Profile adalah konfigurasi "dari mana email dikirim". Untuk lab lokal ini, kita pakai **MailHog** sebagai SMTP server.

**Navigasi:** `Sending Profiles` → `+ New Profile`

| Field | Nilai | Keterangan |
|-------|-------|------------|
| **Name** | `MailHog Local` | Nama profil (bebas) |
| **From** | `HR Division <hr-noreply@ptmajubersama.co.id>` | Nama + email pengirim |
| **Host** | `localhost:1025` *(lokal)* atau `mailhog:1025` *(Docker)* | Host SMTP MailHog |
| **Username** | *(kosong)* | MailHog tidak butuh auth |
| **Password** | *(kosong)* | MailHog tidak butuh auth |

> **Catatan Host:**
> - Pakai `localhost:1025` jika menjalankan via `start.ps1` / `start.bat`
> - Pakai `mailhog:1025` jika menjalankan via `docker-compose` (Docker network internal)

**Verifikasi:**
Klik tombol **Send Test Email** → masukkan email bebas (misal `test@test.com`) → klik Send → buka `http://localhost:8025` → email harus muncul di sana.

✅ **Tanda berhasil:** Email muncul di inbox MailHog Web UI.

---

### Step 3 — Import Landing Page

Landing page adalah halaman yang muncul saat target mengklik link phishing.

**Navigasi:** `Landing Pages` → `+ New Page`

#### Cara Import:

1. Buka salah satu file dari folder `landing_pages/` di text editor (Notepad / VS Code)
2. **Ctrl+A** → **Ctrl+C** (copy semua konten)
3. Di Gophish: isi **Name**, klik tab **HTML** → **Ctrl+A** → hapus isi default → **Ctrl+V**

#### Opsi A — Office 365 Login

```
Name : Office 365 Login (Simulation)
File : landing_pages/office365-login.html
```

#### Opsi B — Company Portal

```
Name : Company Portal - PT Maju Bersama (Simulation)
File : landing_pages/company-portal.html
```

**Pengaturan penting di bagian bawah form:**

```
☐ Capture Submitted Data    ← JANGAN dicentang (zero-harm design)
☑ Redirect to:              ← Centang ini
   URL: http://localhost:8080/awareness
```

> **Kenapa tidak capture data?** Landing page sudah menggunakan JavaScript untuk memblokir pengiriman form di sisi client. Ini adalah bagian dari Zero-Harm Design.

✅ **Tanda berhasil:** Landing page muncul di daftar dengan nama yang benar.

---

### Step 4 — Import Email Template

Email template adalah isi email phishing yang akan diterima target.

**Navigasi:** `Email Templates` → `+ New Template`

#### Cara Import:

1. Buka salah satu file dari folder `templates/` di text editor
2. **Ctrl+A** → **Ctrl+C** (copy semua konten)
3. Di Gophish: klik tab **HTML** → **Ctrl+A** → **Ctrl+V**
4. Isi **Name** dan **Subject** sesuai tabel di bawah
5. Centang ☑ **Add Tracking Image**

| File | Name | Subject |
|------|------|---------|
| `hr-policy-update.html` | `HR — Pembaruan Kebijakan Cuti 2025` | `[PENTING] Konfirmasi Kebijakan Cuti Tahunan 2025 — Tindakan Diperlukan` |
| `ga-inventory-check.html` | `GA — Audit Inventaris Aset IT Q3` | `[URGENT] Konfirmasi Aset IT Anda — Batas Waktu Hari Ini` |
| `it-password-reset.html` | `IT — Peringatan Password Akan Expired` | `⚠ Peringatan Keamanan: Password Anda Expired dalam 24 Jam` |

> **Penting — Variabel Gophish:** Pastikan `{{.URL}}` ada di dalam HTML template (sudah ada di semua template). Ini adalah link yang akan diganti otomatis oleh Gophish dengan URL tracking unik per target.

**Preview:** Klik tab **Preview** untuk melihat tampilan email sebelum disimpan.

✅ **Tanda berhasil:** Template tersimpan dan terlihat di daftar Email Templates.

---

### Step 5 — Buat Target Group

User Group adalah daftar karyawan/target yang akan menerima email simulasi.

**Navigasi:** `Users & Groups` → `+ New Group`

#### Cara 1 — Import via CSV (Direkomendasikan)

Buat file CSV dengan format berikut, lalu klik **Bulk Import Users**:

```csv
First Name,Last Name,Email,Position
Budi,Santoso,budi.santoso@company.co.id,Finance Staff
Siti,Rahayu,siti.rahayu@company.co.id,HR Manager
Agus,Prasetyo,agus.prasetyo@company.co.id,IT Support
Dewi,Kurniawan,dewi.kurniawan@company.co.id,Marketing Staff
```

> **Kolom yang wajib ada:** `First Name`, `Last Name`, `Email` — kolom `Position` opsional tapi berguna untuk segmentasi laporan.

#### Cara 2 — Input Manual

Klik **+ Add** untuk menambahkan satu per satu:
```
First Name : Budi
Last Name  : Santoso
Email      : budi.santoso@company.co.id
Position   : Finance Staff
```

Isi **Name Group**, contoh: `Finance & HR Department — Q3 2025`

✅ **Tanda berhasil:** Group tersimpan dengan jumlah member yang sesuai.

---

### Step 6 — Buat & Launch Campaign

Ini adalah langkah akhir — menggabungkan semua komponen menjadi satu kampanye aktif.

**Navigasi:** `Campaigns` → `+ New Campaign`

| Field | Nilai |
|-------|-------|
| **Name** | `Q3 2025 — HR Policy Phishing Simulation` |
| **Email Template** | `HR — Pembaruan Kebijakan Cuti 2025` *(dari Step 4)* |
| **Landing Page** | `Office 365 Login (Simulation)` *(dari Step 3)* |
| **URL** | `http://localhost:8080` |
| **Launch Date** | Isi tanggal & waktu, atau kosongkan untuk langsung launch |
| **Sending Profile** | `MailHog Local` *(dari Step 2)* |
| **Groups** | `Finance & HR Department — Q3 2025` *(dari Step 5)* |

> **Field URL:** Gunakan `http://localhost:8080` untuk lab lokal. Jika target mengakses dari mesin lain di jaringan yang sama, ganti dengan IP host (contoh: `http://192.168.1.10:8080`).

**Klik `Launch Campaign`** → konfirmasi → kampanye mulai berjalan.

✅ **Tanda berhasil:** Status campaign berubah menjadi `In Progress` dan email mulai dikirim.

---

### Step 7 — Monitor & Analisis Hasil

**Navigasi:** `Campaigns` → klik nama campaign → tab **Results**

#### Dashboard Statistik Real-time

```
┌──────────────────────────────────────────────────────────┐
│  📧 Emails Sent    : 4    → Total email terkirim         │
│  📬 Emails Opened  : 3    → Buka email (tracking pixel)  │
│  🖱  Clicked Link   : 2    → Klik link phishing           │
│  📝 Submitted Data : 1    → Isi form login palsu          │
│  📧 Email Reported : 0    → Laporkan ke IT (jika diset)  │
└──────────────────────────────────────────────────────────┘
```

#### Interpretasi Metrik

| Metrik | Rumus | Benchmark Industri | Makna |
|--------|-------|--------------------|-------|
| **Open Rate** | Opened / Sent × 100 | 30–60% | Seberapa menarik subject line |
| **Click Rate** | Clicked / Sent × 100 | 15–30% | Efektivitas urgency dalam email |
| **Submit Rate** | Submitted / Clicked × 100 | 30–50% | Kualitas landing page |
| **Vulnerability Rate** | Submitted / Sent × 100 | < 5% ideal | Tingkat kerentanan organisasi |

#### Timeline View

Gophish mencatat timestamp setiap event. Perhatikan:
- Jam berapa email paling sering dibuka
- Jeda antara email dibuka dan link diklik
- Pola departemen yang paling rentan

#### Melihat Detail Per Target

Klik **Details** di baris setiap target untuk melihat:
- Semua event yang terjadi (Sent → Opened → Clicked → Submitted)
- Timestamp masing-masing event
- Status terakhir

#### Export Hasil

```
Campaigns → [Nama Campaign] → Export Results (CSV)
```

File CSV bisa langsung digunakan di template laporan `docs/analysis-report.md`.

---

#### ⚡ Cek Email di MailHog

Buka `http://localhost:8025` untuk melihat semua email yang dikirim Gophish:
- Klik email untuk melihat preview HTML
- Klik link di dalam email untuk mensimulasikan klik target
- Pastikan link mengarah ke `http://localhost:8080/...` (bukan literal `{{.URL}}`)

> **Tip:** Selalu test klik link dari MailHog sebelum campaign live untuk memastikan tracking berfungsi dan landing page tampil dengan benar.

---

### ❗ Troubleshooting per Step

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Browser warning saat buka Gophish | Self-signed certificate | Klik **Advanced → Proceed to localhost** |
| Test email gagal dikirim | Host SMTP salah | Mode lokal: `localhost:1025` / Docker: `mailhog:1025` |
| Email tidak muncul di MailHog | Service MailHog mati | Restart: `docker-compose restart mailhog` atau jalankan ulang `start.ps1` |
| Link di email tidak berfungsi | URL campaign salah | Pastikan URL diisi `http://localhost:8080` |
| Landing page tidak muncul | Port 8080 tidak terbuka | Cek `docker-compose ps` dan port mapping |
| `{{.URL}}` muncul sebagai teks | Template tidak punya variabel URL | Tambahkan `{{.URL}}` di href link/tombol |
| Campaign status stuck "Sending" | MailHog tidak reachable | Restart: `docker-compose restart` atau jalankan ulang `start.ps1` |

---

## Dokumentasi

| Dokumen | Deskripsi |
|---------|-----------|
| [docs/methodology.md](docs/methodology.md) | Panduan lengkap 6 fase kampanye: OSINT, desain, setup, eksekusi, debrief |
| [docs/analysis-report.md](docs/analysis-report.md) | Template laporan statistik siap pakai untuk presentasi ke manajemen |

---

## Troubleshooting

**Gophish tidak bisa connect ke MailHog:**
```bash
# Pastikan keduanya dalam network yang sama
docker network inspect phishlab_network

# Restart services
docker-compose restart
```

**Landing page tidak bisa diakses dari browser:**
```bash
# Cek port mapping
docker-compose ps

# Cek log Gophish
docker logs phishlab_gophish --tail 50
```

**Password Gophish awal tidak ditemukan:**
```bash
docker logs phishlab_gophish 2>&1 | grep -i "password\|login\|admin"
```

---

## Kontribusi

Pull request sangat disambut! Beberapa area yang bisa dikembangkan:

- [ ] Template tambahan (finance wire transfer, IT helpdesk impersonation)
- [ ] Template Bahasa Inggris untuk organisasi multinasional
- [ ] Skrip Python untuk analisis otomatis hasil Gophish
- [ ] GitHub Actions untuk validasi HTML template
- [ ] Dokumentasi setup dengan domain nyata (untuk lab eksternal)

---

## Tech Stack

![Gophish](https://img.shields.io/badge/Gophish-Phishing_Engine-EF4444?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker&logoColor=white)
![MailHog](https://img.shields.io/badge/MailHog-Local_SMTP-8B5CF6?style=flat-square)
![HTML5](https://img.shields.io/badge/HTML5-Templates-E34F26?style=flat-square&logo=html5&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-Zero--Harm_Logic-F7DF1E?style=flat-square&logo=javascript&logoColor=black)

---

<div align="center">

Built by [**Dimas Alfa Pratama**](https://github.com/codewithtama) · IT Security Awareness Series

*"The best security tool is an educated employee."*

[![GitHub](https://img.shields.io/badge/GitHub-codewithtama-181717?style=for-the-badge&logo=github)](https://github.com/codewithtama)

</div>
