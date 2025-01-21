import 'package:chatting_new_app/services/notification_service.dart';
import 'package:chatting_new_app/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_page.dart';


class ChatHomePage extends StatefulWidget {
  final String uid;
  const ChatHomePage({super.key, required this.uid});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  void initState() {
    super.initState();
    NotificationService notificationService=NotificationService();
    notificationService.requestNotificationPermission();
    notificationService.getServerKey();
    notificationService.getDeviceToken();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchUserData(widget.uid);
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // getUserData();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          if (message.data['_id'] != null) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => Stays()),
            // );
          }
        }
      },
    );
    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          notificationService.showNotification(message);
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    // Future.microtask(() {
    //   Provider.of<UserViewModel>(context, listen: false).fetchUserData(widget.uid);
    //   NotificationService notificationService=NotificationService();
    //   notificationService.requestPermission();
    //   // notificationService.getDeviceToken();
    //   notificationService.generateSecretKey();
    // });
    }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Chat Home"),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).logoutUser(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoding) {
              return Center(child: CircularProgressIndicator());
            } else if (userProvider.userData.isEmpty) {
              return Center(child: Text("No users found"));
            } else {
              return ListView.builder(
                itemCount: userProvider.userData.length,
                itemBuilder: (context, index) {
                  var user = userProvider.userData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MassagePage(otherUid: user.id.toString()),));
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading:  CircleAvatar(child: Icon(Icons.person),),
                        title: Text("${user.name}"),
                        subtitle: Text("${user.email}"),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        );
    }
}