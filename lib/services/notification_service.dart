import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();


  Future<void> requestNotificationPermission()async{
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print('user granted permission');
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print('user granted  provisional permission');
    }
    else{
      AppSettings.openAppSettings();
      print('user denied permission');
    }

  }
  Future<String>getServerKey()async{
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client= await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "flutternewprojects-68879",
          "private_key_id": "3ba455f4c6f51c90d649f1d89a087ed90f3f8019",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCMuSNUxIW6XkC4\na5gXx3AUxTsomyKMq4SSEgrUEBSPGGjyZe1B3uv4XE2PVfysriBrygPhV5g/ffzr\n1QtLXpRH5nO6iA7XGGtL3QsrDBf/E3TCSw7pCq8kUDWV7rBBJWtBlWTaHCKHBuxm\nZekFr1sRhSUSia0pYtlI/+Ipwv22TYXJWRtCzP2TY6v+MIj4raopSzMngc+/7pMH\nRFCH5yA0QrgviCir98TCzCakcFovoyxPTITLzBYu+OeTHSkFXb3U4DATVJ8jsAlQ\n/rcbjN00pEMNIzupPP/HiyTxOCuiJGzB7RHl1+jraR9aFSTuSYqHEjo2SjN+GHiO\nd8I1G//dAgMBAAECggEAEOU/kTNhLO2ZDqtYYO6AjfXaMvdhUAtdyN3ir/BYT4/q\nNcQ4FrMJmNGYPE/iHOdxHA/upFUMgf8B6Vy0VPG/ktxf47LnOTsE0uBwsVPr46O1\n3of9e8xdF9qLfHtibQftlzu1FpzPJnAV3Pt6XUTfBbz7JP0jrbbhCKs0P7haFtON\nWT8qXLAIHLzH6YrXCVPUQTeo8XmLRfO9yGHTp1+Crowf/ruYZwCmtxksjrMe8SzE\niRA8DTGwox+fKLNTAaNZ+ZBo58AtQw6LRDAaRk5djD9kwMstu2Oha6RCsFxL7oP4\ndSaSegjBk07A8JwvGXyGO66ofde0m4AOaEJt3/PqsQKBgQDBdInka40UwXrDXfJT\nZnmJCpYLGWYRE53vDLikfEeHGXrh2Azzja1ll+iIoc7pQ7VT6V0rQeTUQi/7iaK6\noxC9AnGZXfX/lE+chJQVTmx7GQ/1zwU/QJK7wmeIf086ei9N0E1qN1vQEaltPwL4\n726fmlV6W0NzZ+ycmwlrbcdQJQKBgQC6ODHS2ZRPq4GGR25bskmNBSNYuQfCqKNa\nRGE2hfLq+f3ooYLhnVZOD/hejiZ4o5TGQ/njJZtkUf3+S3nB6xTo2LsxX6dvjCEm\njGBFW0yJpmxl1TX+7ZcoX3dP986tS2xxbo5oTOOaWm3xqrltKDxBLxyfseVfC36d\nS33i4JWnWQKBgFSSB74Nrm1Gb858gXUoNTVNpW5Quif49XANlaKCmhpbbzbP5kmK\nxCTHleY1JmkfKmP2fr5sXgbUsHk8ICGLK8QVD2hGhUYnpe38n2f5Er91o16IE/kk\n14CxaeVoElC0HX3c9Brc/IwnTHPvufLtaOTo6TlGMGSBKBUGScXnBdzpAoGACMb3\nSjnpLKwnyb16LSZFIzl3xgnKnNk4AdwxPNGpdnvcBOf/9ERnOfy0tzg6Bfun2oR/\ntb4jCeJ3d1H1Zjd/X84/XH9ms/JF6bw6GWrJO7+1YkNfbSmjs0p0pDdI7ZAdh2cv\nnSjqnW7fucFTRhrcZDIlRj2rUwSGrkFNqLDvPNkCgYBvixQKTLoaSwZ/80AGRder\nX5BUqwCbB+/+K4vPoA0bc/YSuq4XAQI9kfP8InTnZESFVpLzh8dOOp5WXSXcuRAY\nxPYzUURhMv3+4Y1wKfJI42S34jPEcy3EsfPFNruO7Ru/80rlypHoa+DTVqQjJWYW\nZkcWr4Kk3Vcs688fFnshqg==\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-smyot@flutternewprojects-68879.iam.gserviceaccount.com",
          "client_id": "111689840604826130493",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-smyot%40flutternewprojects-68879.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
        ),scopes
    );
    final serverKey=client.credentials.accessToken.data;
    print("serverKey=$serverKey");
    return serverKey;
    }
    Future<void>getDeviceToken()async{
      String? token=await messaging.getToken();
      if(token!=null){
        print(" Device Token $token");
      }
    }

  Future<void>initApp()async{
    AndroidInitializationSettings androidInitializationSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings=InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void>showNotification(RemoteMessage message)async  {
    AndroidNotificationDetails androidNotificationDetails=const AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'Channel description',
        importance: Importance.max,
        priority: Priority.high
    );
    int notificationId=1;
    NotificationDetails notificationDetails=NotificationDetails(android:androidNotificationDetails );
    await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'Not Present'
    );
  }

  void sendOrderNotification({required String message,required String token,required String senderName })async{
    print('token id :$token');
    final serverKey=await getServerKey();
    try{
      final response=await http.post(Uri.parse('https://fcm.googleapis.com/v1/projects/flutterfirebaseauth-439e4/messages:send'),
          headers: <String,String>{
            'Content-Type':'application/json',
            'Authorization':'Bearer $serverKey  '
          },
          body: jsonEncode(<String, dynamic>{
            "message":{
              "token":token,
              "data":{},
              "notification":{
                "title":senderName,
                "body":message
              }
            }
          })
      );
      if(response.statusCode==200){
      }else{
        print('failed to send notification,Status code:${response.statusCode}');
        Fluttertoast.showToast(msg: 'Failed to send notification');
      }
    }catch(ex){
      print('error sending notification: $ex');
      Fluttertoast.showToast(msg: 'error sending notification');
    }
    }

}