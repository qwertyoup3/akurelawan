# Akurelawan - Mobile Application

**Akurelawan** adalah platform aplikasi mobile berbasis Flutter yang dirancang untuk menghubungkan para relawan dengan berbagai kegiatan sosial. Aplikasi ini dilengkapi dengan sistem notifikasi *real-time* menggunakan **Firebase Cloud Messaging (FCM)** dan memanfaatkan **MockAPI** sebagai *backend* simulasi untuk manajemen data pengguna serta relawan.

🔗 **Repository GitHub**: [https://github.com/qwertyoup3/akurelawan](https://github.com/qwertyoup3/akurelawan)

---

## 🚀 Fitur Utama
- **Autentikasi Pengguna**: Sistem *login* berbasis peran (*role-based*) untuk Organizer dan Relawan.
- **Push Notification (FCM)**: Integrasi Firebase Cloud Messaging dan *local notifications* untuk pengingat jadwal kegiatan sosial.
- **Manajemen Data via MockAPI**: Penggunaan REST API simulasi untuk pengelolaan data dinamis secara cepat dan efisien.

---

## 🛠️ Mengapa Menggunakan MockAPI?
Dalam pengembangan aplikasi ini, **MockAPI** dipilih karena beberapa alasan strategis:
1. **Kecepatan Pengembangan**: Memungkinkan pembuatan *endpoint* REST API (GET, POST, PUT, DELETE) secara instan tanpa harus membangun *server backend* secara manual (seperti Node.js atau Express dari nol).
2. **Fokus pada Frontend/Mobile**: Memisahkan logika *server* sehingga proses integrasi HTTP *request* di sisi Flutter dapat diuji secara langsung dengan data JSON tiruan yang stabil.
3. **Simulasi Lingkungan Nyata**: Menyediakan struktur data pengguna dan relawan layaknya *production database* sungguhan, sangat ideal untuk kebutuhan pengujian fitur *login* dan pengelolaan *state* aplikasi.

---

## 👥 Akun Uji Coba (Login Credentials)
Berikut adalah daftar akun yang dapat digunakan untuk masuk ke dalam aplikasi berdasarkan perannya masing-masing:

### 1. Akun Organizer 1 (Admin)
* **Nama**: Admin Relawan
* **Email**: `admin@gmail.com`
* **Password**: `123456`
* **Role**: `organizer`

### 2. Akun Organizer 2
* **Nama**: Indri Wahyu Setyaningrum
* **Email**: `arum@gmail.com`
* **Password**: `arumcantik`
* **Role**: `organizer`

### 3. Akun Relawan
* **Nama**: Nasrizal Sungkar
* **Email**: `nasrizal@gmail.com`
* **Password**: `bontotumi`
* **Role**: `relawan`

---

## 📱 Panduan Instalasi & Menjalankan Proyek

1. **Clone Repository**
   ```bash
   git clone [https://github.com/qwertyoup3/akurelawan.git](https://github.com/qwertyoup3/akurelawan.git)
   cd akurelawan