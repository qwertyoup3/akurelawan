import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import '../screens/detail_screen.dart';

// Background handler (Wajib top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Pesan diterima di background: ${message.messageId}");
}

class FcmService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // 1. Request izin notifikasi (untuk Android 13+ / iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Izin notifikasi diberikan!');
    }

    // 2. Ambil & Simpan FCM Token ke SharedPreferences (agar bisa tampil di Settings)
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      debugPrint('FCM Token: $token');
    }

    // Listener untuk token yang di-refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', newToken);
    });

    // 3. Setup Local Notification Channel (High Importance untuk Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel ini digunakan untuk notifikasi penting.',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Inisialisasi plugin local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle ketika notifikasi lokal di-tap
        _handleDeepLink(response.payload, navigatorKey);
      },
    );

    // 4. Handle Foreground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final prefs = await SharedPreferences.getInstance();
      bool isNotifEnabled = prefs.getBool('notif_enabled') ?? true;

      // Jika toggle "Terima Notifikasi" di Settings sedang OFF, jangan tampilkan notifikasi
      if (!isNotifEnabled) return;

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          payload: message.data['event_id'], // Ambil event_id untuk deep-link
        );
      }
    });

    // 5. Handle Background & Terminated State saat notifikasi di-klik
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Ketika aplikasi dibuka dari keadaan Terminated karena mengklik notifikasi
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      String? eventId = initialMessage.data['event_id'];
      if (eventId != null) {
        // Beri sedikit jeda agar navigator siap
        Future.delayed(const Duration(seconds: 1), () {
          _navigateToEventDetail(eventId, navigatorKey);
        });
      }
    }

    // Ketika aplikasi di background lalu di-klik notifikasinya
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String? eventId = message.data['event_id'];
      if (eventId != null) {
        _handleDeepLink(eventId, navigatorKey);
      }
    });
  }

  static void _handleDeepLink(
    String? eventId,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    if (eventId != null && eventId.isNotEmpty) {
      _navigateToEventDetail(eventId, navigatorKey);
    }
  }

  static void _navigateToEventDetail(
    String eventId,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    debugPrint("Deep-link terpanggil ke Event ID: $eventId");
    final event = await ApiService.getEventById(eventId);
    if (event != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => DetailScreen(event: event)),
      );
    } else {
      debugPrint("Event dengan ID $eventId tidak ditemukan");
    }
  }
}
