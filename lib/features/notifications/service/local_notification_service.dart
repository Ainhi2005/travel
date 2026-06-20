import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Xử lý khi người dùng nhấn vào thông báo
      },
    );

    // Yêu cầu quyền thông báo trên Android (Android 13+)
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // Khởi tạo và lắng nghe Firebase Messaging
    await _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // 1. Yêu cầu quyền thông báo từ Firebase (đặc biệt quan trọng với iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    developer.log(
      'Quyền thông báo Firebase: ${settings.authorizationStatus}',
      name: 'NotificationService',
    );

    // 2. Lấy FCM Token và hiển thị ra log để copy
    try {
      String? token = await messaging.getToken();

      developer.log(
        '====================================================',
        name: 'NotificationService',
      );
      developer.log('🔥 FCM TOKEN: $token', name: 'NotificationService');

      developer.log(
        '====================================================',
        name: 'NotificationService',
      );
    } catch (e) {
      developer.log('Lỗi lấy FCM Token: $e', name: 'NotificationService');
    }

    // 3. Lắng nghe tin nhắn khi app đang mở (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log(
        'Nhận FCM ở foreground: ${message.notification?.title}',
        name: 'NotificationService',
      );
      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // 4. Lắng nghe khi click vào thông báo từ background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log(
        'Nhấn vào thông báo FCM: ${message.notification?.title}',
        name: 'NotificationService',
      );
    });
  }

  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final notificationId =
        id ?? (DateTime.now().millisecondsSinceEpoch % 100000);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel_id',
          'Default Channel',
          channelDescription: 'Kênh thông báo mặc định',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }
}
