# rpl_keamanan

Praktikum Pemrograman Mobile (ST407) – Pertemuan 6: Prinsip RPL & Keamanan Kode.

## Penerapan

- **Repository pattern**: `lib/repositories/` (`UserRepository`, `PostRepository` + implementasinya). UI hanya bergantung pada abstraksi.
- **Tanpa hardcoded credential**: `BASE_URL` dan `API_KEY` dibaca dari `.env` lewat `AppConfig`. `.env` ada di `.gitignore`.
- **Validasi & sanitasi input**: `lib/utils/validators.dart`.
- **Logging aman**: `lib/utils/logger.dart` (hanya mode debug, nilai sensitif disamarkan).
- **Dependency injection sederhana**: `lib/config/dependency_injector.dart`.
- **Dartdoc** (`///`) pada class dan method publik.

## Menjalankan

```bash
cp .env.example .env     # lalu isi nilainya
flutter pub get
flutter run
flutter test
```
