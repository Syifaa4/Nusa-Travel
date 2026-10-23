# NusaTravel

Aplikasi pemesanan paket wisata sederhana berbasis Flutter yang menerapkan **Navigation dan Routing**. Aplikasi dapat dijalankan di Android maupun web dengan tampilan responsif.

## Demo Aplikasi
https://youtu.be/WJ9i1ZQD1EI

## Fitur
- **Splash Screen**: logo animasi dan tombol "Mulai Eksplorasi" (`pushReplacementNamed`).
- **Home Screen**: daftar paket wisata dalam `Card` (1/2/3 kolom sesuai lebar layar), pencarian, filter kategori (Alam, Bahari, Budaya, Hiburan), dan tombol Logout.
- **Detail Screen**: informasi lengkap paket, galeri foto, rating, dan highlight. Data dikirim lewat `pushNamed` dengan `arguments`.
- **Booking Screen**: form nama, jumlah peserta, dan tanggal keberangkatan. Hasil dikembalikan lewat `Navigator.pop()`. Sebelum memesan, muncul pop-up **Rincian Pembayaran**.
- **Not Found Screen**: halaman Error 404 melalui `onUnknownRoute`.
- **PopScope** di Booking Screen: dialog konfirmasi saat tombol Back ditekan.
- **SnackBar** di Detail Screen setelah pemesanan berhasil (`await Navigator.push()`).
- **Logout** memakai `pushNamedAndRemoveUntil()` sehingga riwayat halaman terhapus.

## Konsep Navigasi yang Digunakan

| Konsep | Lokasi |
|---|---|
| `initialRoute`, `routes`, `onGenerateRoute`, `onUnknownRoute` | `lib/main.dart`, `lib/routes/app_routes.dart` |
| `pushReplacementNamed()` | Splash Screen, tombol "Mulai Eksplorasi" |
| `pushNamed()` + `arguments` | Home Screen, kartu paket menuju Detail |
| `Navigator.push()` + `await` + `Navigator.pop(result)` | Detail Screen dan Booking Screen |
| `PopScope` | Booking Screen |
| `SnackBar` | Detail Screen |
| `pushNamedAndRemoveUntil()` | Logout di Home, tombol "Kembali ke Beranda" di 404 |

## Struktur Folder

```
lib/
├── models/
│   └── tour_package.dart
├── routes/
│   └── app_routes.dart
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── detail_screen.dart
│   ├── booking_screen.dart
│   └── not_found_screen.dart
└── main.dart
assets/
└── images/
```

## Model Data

`TourPackage` memiliki field wajib `id`, `title`, `description`, `price`, dan `imageUrl`, ditambah field pelengkap seperti `location`, `duration`, `rating`, `reviews`, `category`, `originalPrice`, `images`, `highlights`, `openingHours`, dan `tags`.

## Cara Menjalankan

1. Pastikan Flutter sudah terpasang (`flutter --version`).
2. Clone repository dan masuk ke foldernya:

   ```bash
   git clone <URL-REPOSITORY>
   cd nusa_travel
   ```

3. Unduh dependency:

   ```bash
   flutter pub get
   ```

4. Jalankan aplikasi:

   ```bash
   flutter run              # emulator / HP Android
   flutter run -d chrome    # web
   ```

> Setelah menambah file di `assets/images/`, hentikan aplikasi lalu jalankan ulang (hot reload tidak membaca aset baru).

## Screenshot

### Splash Screen
<img width="959" height="414" alt="Screenshot 2026-10-23 085547" src="https://github.com/user-attachments/assets/bedf1e37-4366-4ed6-aaa7-3f51f8604f1c" />

### Home Screen
<img width="959" height="414" alt="Screenshot 2026-10-23 085603" src="https://github.com/user-attachments/assets/60eb8232-aa51-4261-b2a2-858f16ef3400" />

### Detail Screen
<img width="669" height="374" alt="image" src="https://github.com/user-attachments/assets/41d10e59-d953-4f39-ad38-779007fb3f0c" />


### Booking Screen
<img width="958" height="418" alt="Screenshot 2026-10-23 085650" src="https://github.com/user-attachments/assets/bb35e2d7-165c-4eae-a59d-c2e76698fcf2" />


### Rincian Pembayaran
<img width="358" height="374" alt="image" src="https://github.com/user-attachments/assets/ab6b34b8-7031-4e72-b755-003b015b73c1" />

### Not Found Screen (404)
<img width="475" height="414" alt="image" src="https://github.com/user-attachments/assets/19137269-0050-4fef-937d-c5042af3c0da" />

### Dialog PopScope (konfirmasi tombol Back)
<img width="304" height="160" alt="image" src="https://github.com/user-attachments/assets/fb489450-d92c-492d-ac2d-653c30be6d99" />


### SnackBar setelah pemesanan berhasil
<img width="340" height="49" alt="Screenshot 2026-10-23 085727" src="https://github.com/user-attachments/assets/c52175fd-b361-4c31-a49f-b14cf523a8a4" />


### Dialog Logout
<img width="185" height="123" alt="image" src="https://github.com/user-attachments/assets/68b59a78-c512-44a6-9f6d-cead0136f353" />

## Cara Menampilkan Halaman 404

Buka alamat yang tidak terdaftar, misalnya di web:

```
http://localhost:<port>/#/ngasal
```

Rute yang tidak dikenal akan ditangani oleh `onUnknownRoute`.
