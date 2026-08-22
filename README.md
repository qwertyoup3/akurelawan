# akurelawan

Aplikasi mobile platform kerelawanan untuk menghubungkan relawan dengan berbagai kegiatan sosial.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Architecture Decision Record (ADR)
**Status:** Mock API Implemented

Dikarenakan tidak adanya akses ke *live server/endpoint* API dari penyelenggara selama masa tes, aplikasi ini mengimplementasikan **Mock API Service** pada layer `ApiService`. 

Keputusan arsitektur ini diambil untuk:
1. Menjaga prinsip *Separation of Concerns* (memisahkan UI dan Data Layer).
2. Memastikan seluruh fungsionalitas UI (Login & Event List) tetap dapat diuji dan didemonstrasikan.
3. Aplikasi sudah *plug-and-play*. Jika API Production sudah tersedia, cukup mengganti `Future.delayed` di `api_service.dart` dengan HTTP Client tanpa perlu merombak UI.

Fitur **Firebase Cloud Messaging (FCM)** tetap berjalan secara **Native & Live** (Foreground, Background, Terminated) sesuai dengan spesifikasi wajib.
