import 'package:firebase_messaging/firebase_messaging.dart';


import '../library_page.dart';
import '../main.dart';

Future backgroundHandler(RemoteMessage msg) async {
  print('Title: ${msg.notification?.title}');
  print('Body: ${msg.notification?.body}');
  print('Data: ${msg.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print(token);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? msg) {
    if(msg == null) return;
    navigatorKey.currentState?.pushNamed(LibraryPage.route);
  }
  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage((message) => backgroundHandler(message));
  }
}
