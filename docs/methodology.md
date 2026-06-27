# Methodology: Phishing Simulation Campaign Playbook

> **Tujuan dokumen ini:** Memberikan panduan lengkap bagi tim IT Security atau auditor internal untuk merancang, mengeksekusi, dan menganalisis kampanye simulasi phishing secara etis dan efektif di lingkungan korporat.

> **⚠ PERINGATAN LEGAL:** Seluruh aktivitas dalam dokumen ini hanya boleh dilakukan atas izin tertulis manajemen dan dalam lingkungan yang dikontrol. Penggunaan teknik ini tanpa otorisasi adalah ilegal.

---

## Daftar Isi

1. [Fase 1 — Perencanaan & Otorisasi](#fase-1)
2. [Fase 2 — OSINT & Pengumpulan Target](#fase-2)
3. [Fase 3 — Desain Kampanye](#fase-3)
4. [Fase 4 — Setup Teknis](#fase-4)
5. [Fase 5 — Eksekusi](#fase-5)
6. [Fase 6 — Debrief & Pelaporan](#fase-6)
7. [Kerangka Etika](#etika)

---

## Fase 1 — Perencanaan & Otorisasi {#fase-1}

### 1.1 Rules of Engagement (RoE)

Sebelum satu baris konfigurasi pun ditulis, tim wajib memiliki **otorisasi tertulis** dari:

| Pemangku Kepentingan | Yang Harus Disetujui |
|----------------------|----------------------|
| C-Level / Direksi | Ruang lingkup, tanggal, departemen target |
| Legal / Compliance | Legalitas, privasi data, PDPA/UU PDP |
| HR Manager | Konsekuensi (edukasi, bukan hukuman) |
| IT Infrastructure | Tidak ada gangguan pada sistem produksi |

**Template dokumen yang diperlukan:**
- [ ] Surat Otorisasi Manajemen (tandatangan direksi)
- [ ] NDA dengan vendor/pihak ketiga jika ada
- [ ] Pernyataan bahwa tidak ada PII yang akan dikumpulkan

### 1.2 Menentukan Tujuan

Definisikan tujuan terukur sebelum kampanye:

```
Contoh OKR Kampanye:
Objective : Menurunkan tingkat klik email phishing sebesar 30% dalam 2 siklus simulasi
KR 1      : < 20% karyawan mengklik link simulasi (baseline awal biasanya 25–40%)
KR 2      : > 80% karyawan melaporkan email phishing ke IT Security
KR 3      : 100% karyawan menyelesaikan security awareness training pasca-simulasi
```

### 1.3 Scope Definition

```yaml
scope:
  included:
    - Semua karyawan aktif (email @perusahaan.co.id)
    - Departemen prioritas: Finance, HR, IT (akses tinggi ke data sensitif)
  excluded:
    - Karyawan yang sedang cuti panjang
    - Direktur yang sudah di-briefing (jika simulasi covert)
  timeline:
    start: 2025-07-14
    end: 2025-07-21
    black_out: Senin pagi jam 08:00–09:00 (peak meeting hour)
```

---

## Fase 2 — OSINT & Pengumpulan Target {#fase-2}

> **Catatan Etika:** Dalam konteks simulasi internal, Anda sudah memiliki daftar email karyawan dari sistem HRIS. Bagian ini menjelaskan teknik yang *digunakan oleh penyerang nyata* — tujuannya adalah edukasi, agar tim security memahami threat landscape.

### 2.1 Sumber OSINT yang Dieksploitasi Penyerang

#### Company Website & LinkedIn
```
Target info: Nama karyawan, posisi, departemen, email format
Tools      : theHarvester, Hunter.io, LinkedIn Sales Navigator
Pattern    : firstname.lastname@company.co.id (paling umum di Indonesia)
Contoh     : budi.santoso@ptmajubersama.co.id
```

#### Email Format Discovery
```bash
# Menggunakan theHarvester (open-source)
theHarvester -d ptmajubersama.co.id -b google,linkedin,bing

# Validasi format email dengan hunter.io API (free tier)
curl "https://api.hunter.io/v2/domain-search?domain=ptmajubersama.co.id&api_key=YOUR_KEY"
```

#### Job Postings & Annual Reports
Lowongan kerja sering menyebut: nama manajer, struktur divisi, tools yang digunakan.
Annual report: nama direksi, departemen kunci.

### 2.2 Informasi yang Membuat Email Phishing Lebih Meyakinkan

```
Tingkat keberhasilan phishing meningkat signifikan ketika email:
✓ Menyebut nama lengkap target (spear phishing)
✓ Menyebut nama atasan atau kolega yang nyata
✓ Mereferensikan proyek atau event yang sedang berjalan
✓ Menggunakan terminologi internal yang spesifik (nama sistem, kode proyek)
✓ Dikirim dari domain yang mirip (typosquatting)
```

### 2.3 Membangun Target List untuk Simulasi

Dalam konteks internal yang sah:

```python
# Contoh script Python sederhana untuk format target list Gophish
import csv

employees = [
    {"first_name": "Budi", "last_name": "Santoso", "email": "budi.santoso@ptmajubersama.co.id", "position": "Finance"},
    {"first_name": "Siti", "last_name": "Rahayu", "email": "siti.rahayu@ptmajubersama.co.id", "position": "HR"},
    # ... import dari HRIS export
]

with open("targets.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["first_name", "last_name", "email", "position"])
    writer.writeheader()
    writer.writerows(employees)

print(f"Target list siap: {len(employees)} karyawan")
```

Format CSV untuk import ke Gophish:
```csv
first_name,last_name,email,position
Budi,Santoso,budi.santoso@ptmajubersama.co.id,Finance Staff
Siti,Rahayu,siti.rahayu@ptmajubersama.co.id,HR Manager
```

---

## Fase 3 — Desain Kampanye {#fase-3}

### 3.1 Memilih Template yang Tepat

Efektivitas phishing template bergantung pada **relevance** dan **urgency**:

| Template | Target Ideal | Trigger Psikologis |
|----------|-------------|-------------------|
| `hr-policy-update.html` | Semua karyawan | Authority + Urgency |
| `ga-inventory-check.html` | Karyawan dengan aset IT | Fear of loss + Compliance |
| `it-password-reset.html` | Karyawan teknis, all-level | Fear + Authority |

**Prinsip Psikologi Sosial dalam Phishing:**

```
1. Authority    — email dari "atasan" atau divisi yang berkuasa (HR, IT, Direksi)
2. Urgency      — deadline ketat memaksa tindakan tanpa verifikasi
3. Scarcity     — "hanya berlaku 24 jam" membatasi waktu berpikir kritis
4. Social Proof — "semua karyawan diwajibkan" mengurangi kecurigaan individual
5. Fear         — konsekuensi negatif (akun diblokir, sanksi disiplin)
```

### 3.2 Customizing Templates untuk Konteks Spesifik

Spear phishing (targeted) jauh lebih efektif dari blast phishing:

```html
<!-- Generic (blast) -->
Yth. Karyawan PT Maju Bersama

<!-- Spear phishing (targeted) — gunakan variabel Gophish -->
Yth. {{.FirstName}} {{.LastName}},
Sebagai Staff {{.Position}} dengan NIK {{.RId}}, Anda diwajibkan...
```

### 3.3 Landing Page Strategy

```
Opsi 1 — Credential Harvesting Simulation:
  User mengisi form → JS intercept → redirect ke awareness page
  Gophish mencatat: email sent, opened, clicked, submitted data
  Use case: Mengukur seberapa jauh user "tertipu"

Opsi 2 — Click-Only Tracking:
  User klik link → langsung ke awareness page (tanpa form login)
  Gophish mencatat: email sent, opened, clicked
  Use case: Simulasi awal untuk organisasi yang baru memulai program
```

---

## Fase 4 — Setup Teknis {#fase-4}

### 4.1 Deploy Lab Environment

```bash
# Clone repository
git clone https://github.com/codewithtama/Phishing-Simulation-Awareness-Lab.git
cd Phishing-Simulation-Awareness-Lab

# Salin environment config
cp .env.example .env

# Edit .env sesuai kebutuhan (opsional untuk dev)
nano .env

# Start semua service
docker-compose up -d

# Verifikasi service berjalan
docker-compose ps
```

**Expected output:**
```
NAME                 STATUS          PORTS
phishlab_gophish     Up (healthy)    0.0.0.0:3333->3333/tcp, 0.0.0.0:8080->80/tcp
phishlab_mailhog     Up (healthy)    0.0.0.0:1025->1025/tcp, 0.0.0.0:8025->8025/tcp
```

### 4.2 Konfigurasi Gophish (First-Time Setup)

```
1. Buka https://localhost:3333 (terima self-signed certificate warning)
2. Login: admin / [password dari output docker logs phishlab_gophish]
3. Segera ganti password di: Account Settings > Change Password
```

**Import Sending Profile (MailHog SMTP):**
```
Name        : MailHog Local SMTP
SMTP From   : hr-noreply@ptmajubersama.co.id
Host        : mailhog:1025
```

**Import Email Template:**
```
1. Campaigns > Email Templates > New Template
2. Paste konten dari /templates/*.html
3. Centang "Add Tracking Image"
4. Subject: sesuaikan dengan konteks template
```

**Import Landing Page:**
```
1. Campaigns > Landing Pages > New Page
2. Paste konten dari /landing_pages/*.html
3. JANGAN centang "Capture Submitted Data" (zero-harm principle)
4. Redirect URL: awareness-redirect.html atau URL awareness page
```

### 4.3 Membuat Campaign

```
1. Campaigns > New Campaign
2. Name       : Q3-2025 HR Policy Simulation
3. Email      : [Template yang sudah diimport]
4. Landing    : office365-login (atau company-portal)
5. URL        : http://localhost:8080 (atau IP server Anda)
6. Launch Date: [Jadwal pengiriman]
7. Groups     : [Target group yang sudah diimport]
```

---

## Fase 5 — Eksekusi {#fase-5}

### 5.1 Pre-Launch Checklist

```
[ ] Otorisasi tertulis sudah diperoleh
[ ] Docker services sudah healthy (docker-compose ps)
[ ] Test email dikirim ke inbox pribadi (bukan target)
[ ] Landing page dapat diakses dari browser target
[ ] Awareness redirect page berfungsi dengan benar
[ ] Tracking pixel terkonfirmasi aktif
[ ] Backup data sebelum kampanye dimulai
[ ] IT Helpdesk sudah diberitahu (untuk menangani laporan karyawan)
```

### 5.2 Timing Best Practices

```
✓ Kirim email di hari kerja: Selasa–Kamis jam 09:00–11:00 WIB
  (Open rate tertinggi, orang masih fokus)

✓ Hindari:
  - Senin pagi (backlog meeting dan email weekend)
  - Jumat sore (orang sudah mode weekend)
  - Hari libur nasional atau cuti bersama
  - Periode audit atau deadline besar

✓ Stagger pengiriman (jangan blast sekaligus):
  Gunakan Gophish "Send by Date" untuk distribusi bertahap
  → Mencegah karyawan saling memberitahu sebelum semua dapat email
```

### 5.3 Monitoring Real-Time

Pantau dashboard Gophish selama kampanye berjalan:

```
Metrics yang dipantau:
├── Email Sent     : Total email terkirim ke MailHog
├── Email Opened   : Tracking pixel dimuat (user buka email)
├── Clicked Link   : User mengklik link phishing
└── Submitted Data : User berinteraksi dengan form login

Akses monitoring: https://localhost:3333 > Campaigns > [Campaign Name]
```

---

## Fase 6 — Debrief & Pelaporan {#fase-6}

### 6.1 Debrief Segera (Post-Campaign)

Dalam 24–48 jam setelah kampanye selesai:

1. **Kirim notifikasi ke semua target** — beritahu bahwa ini adalah simulasi
2. **Jangan reveal siapa yang "gagal"** — fokus pada statistik agregat
3. **Sediakan akses ke awareness material** — arahkan ke awareness-redirect.html
4. **Jadwalkan sesi edukasi** — workshop 1 jam dengan contoh nyata

### 6.2 Analisis Data

Lihat `analysis-report.md` untuk template lengkap analisis statistik Gophish.

```python
# Quick win analysis dari Gophish JSON export
import json

with open("campaign_results.json") as f:
    data = json.load(f)

results = data["results"]
total = len(results)
opened = sum(1 for r in results if r.get("opened"))
clicked = sum(1 for r in results if r.get("clicked"))
submitted = sum(1 for r in results if r.get("submitted_data"))

print(f"Total target   : {total}")
print(f"Email dibuka   : {opened} ({opened/total*100:.1f}%)")
print(f"Link diklik    : {clicked} ({clicked/total*100:.1f}%)")
print(f"Form disubmit  : {submitted} ({submitted/total*100:.1f}%)")
print(f"Click rate     : {clicked/opened*100:.1f}% dari yang membuka email")
```

---

## Kerangka Etika {#etika}

### Do's ✅
- Selalu dapatkan otorisasi tertulis sebelum memulai
- Gunakan zero-harm landing pages (tidak menyimpan kredensial)
- Fokus pada edukasi, bukan shaming atau punishment
- Anonimisasi data individual dalam laporan ke manajemen
- Berikan awareness training kepada SEMUA karyawan (bukan hanya yang "gagal")
- Simpan data simulasi dengan enkripsi dan hapus setelah retention period
- Laporkan baseline improvement dari waktu ke waktu

### Don'ts ❌
- Jangan lakukan tanpa otorisasi — ini ilegal (UU ITE Pasal 30)
- Jangan simpan credential yang dimasukkan user
- Jangan gunakan hasil untuk sanksi disiplin individual
- Jangan target karyawan yang sedang dalam kondisi stress berat (post-PHK, sakit)
- Jangan buat simulasi yang bisa menyebabkan kerugian finansial nyata
- Jangan share raw individual data ke pihak yang tidak berwenang

---

> *"The goal of security awareness training is not to catch people. It's to change behavior."*
> — Lance Spitzner, SANS Security Awareness

---

**Referensi:**
- [Gophish Documentation](https://docs.getgophish.com/)
- [SANS Security Awareness Roadmap](https://www.sans.org/security-awareness-training/)
- [NIST SP 800-50: Building an IT Security Awareness and Training Program](https://csrc.nist.gov/publications/detail/sp/800-50/final)
- [UU ITE No. 19 Tahun 2016 (Indonesia)](https://jdih.kominfo.go.id/)
- [PDPA Thailand & UU PDP Indonesia — Referensi Privasi Data](https://www.ojk.go.id/)
