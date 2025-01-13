import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMHelper {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // handleNotificationTap(response as String?);
      },
    );

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          showNotification(message);
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          // handleNotificationTap(
          //   message.data['screen'],
          // );
        },
      );

      RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        // handleNotificationTap(
        //   initialMessage.data['screen'],
        // );
      }

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    // handleNotificationTap(
    //   message.data['screen'],
    // );
  }

  static void showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      final BigTextStyleInformation bigTextStyleInformation =
          BigTextStyleInformation(
        notification.body ?? '',
        contentTitle: notification.title ?? '',
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
      );

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'default_channel',
        'Default Notifications',
        channelDescription:
            'This channel is used for important notifications and alerts',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
        icon: '@mipmap/ic_launcher',
        sound: const RawResourceAndroidNotificationSound('notification_sound'),
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      String? screen = message.data['screen'];

      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: screen,
      );
    }
  }

  // static Future<void> handleNotificationTap(String? screen) async {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) async {
  //       await Future.delayed(
  //         const Duration(
  //           seconds: 1,
  //         ),
  //       );
  //       String? token = await _storage.read(
  //         key: 'token',
  //       );

  //       if (token != null && token.isNotEmpty) {
  //         handleScreenNavigation(screen);
  //       } else {
  //         Get.offAllNamed('/authentication');
  //       }
  //     },
  //   );
  // }

  // static void handleScreenNavigation(String? screen) {
  //   switch (screen) {
  //     case 'profile':
  //       Get.toNamed('/profile');
  //       break;
  //     case 'enquiries':
  //       Get.toNamed('/enquiries');
  //       break;
  //     case 'home':
  //       Get.toNamed('/home');
  //       break;
  //     case 'lockReport':
  //       Get.toNamed('/lock-report');
  //       break;
  //     case 'unlockLogin':
  //       Get.toNamed('/unlock-login');
  //       break;
  //     case 'orders':
  //       Get.toNamed('/orders');
  //       break;
  //     default:
  //       print("Unhandled screen type: $screen");
  //   }
  // }
}
