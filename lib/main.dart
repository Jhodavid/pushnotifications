import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pushnotifications/screens/home_screen.dart';
import 'package:pushnotifications/screens/message_screen.dart';
import 'package:pushnotifications/services/push_notifications_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsService.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      routes: {
        'home': ( _ ) => HomeScreen(),
        'message': ( _ ) => MessageScreen(),
      },
    );
  }

  @override
  void initState() {
    super.initState();

    PushNotificationsService.messageStream.listen((message) {
      if (kDebugMode) {
        print('MyApp: $message');
      }

      navigatorKey.currentState?.pushNamed('message', arguments: message);

      final snackBar = SnackBar(
        content: Text(message),
      );

      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }
}
