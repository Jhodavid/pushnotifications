//SHA1: 61:CF:FA:14:54:3B:70:91:F1:D5:AD:8F:89:66:EE:A9:17:F2:A5:D0
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messageStream => _messageStream.stream;


  static Future<void> _backgroundHandler( RemoteMessage message ) async {
    // print('Background Handler ${ message.messageId}');
    print(message.data);

    _messageStream.add( message.data['producto'] ?? 'No title' );
  }

  static Future<void> _onMessageHandler( RemoteMessage message ) async {
    // print('_onMessage Handler ${ message.messageId}');
    print(message.data);

    _messageStream.add( message.data['producto'] ?? 'No title' );
  }

  static Future<void> _onMessageOpenApp( RemoteMessage message ) async {
    // print('_onMessageOpenApp Handler ${ message.messageId}');
    print(message.data);

    _messageStream.add( message.data['producto'] ?? 'No product' );
  }


  static Future initializeApp() async {

    // Push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications

  }

  static closeStreams() {
    _messageStream.close();
  }

}