import 'package:chatting_new_app/services/notification_service.dart';
import 'package:chatting_new_app/signup_page.dart';
import 'package:chatting_new_app/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_view_model.dart';
import 'firebase_options.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage((message) async{
    print(message.data.toString());
    print(message.notification!.title);
  },);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
    var notificationService = NotificationService();
    notificationService.initApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider(),),
    ChangeNotifierProvider(create: (context) => ChatViewModel(),),
  ],child: MyApp(),));

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home:SignupPage(), );
    }



}
