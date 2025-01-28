
import 'dart:core';
import 'package:chatting_new_app/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';
import 'login_page.dart';


class UserProvider with ChangeNotifier{

  final  auth = FirebaseAuth.instance;
  bool isLoding = true;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  var nameController= TextEditingController();
  var emailController= TextEditingController();
  var passwordController= TextEditingController();

  List<UserModel> _userData= [];
  List<UserModel> get userData=> _userData;


  void userSignUp(BuildContext context) async{
    var name =  nameController.text.toString();
    var email = emailController.text.toString();
    var password= passwordController.text.toString();
    var token = await getDeviceTokenFromFirebase();

    if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty){

      isLoding = true;
      notifyListeners();
      try{
        var result = await auth.createUserWithEmailAndPassword(email: email, password: password);

        if(result.user!= null){
          var uid = result.user?.uid;
          DatabaseReference ref= FirebaseDatabase.instance.ref("user/$uid");
          await ref.set({
            "id":uid,
            "name":name,
            "email":email
          });
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          Fluttertoast.showToast(msg: "SignUp is successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatHomePage(uid: uid!,),));
        }
        notifyListeners();
      }
      catch(e){
        Fluttertoast.showToast(msg: "$e SignUp is Failed");
      }finally{
        isLoding = false;
        notifyListeners();
      }

    }
    else{
      Fluttertoast.showToast(msg: "Please fill the all field");
    }
  }


  void userLogin(BuildContext context) async{
    var email= emailController.text;
    var password= passwordController.text;

    if(email.isNotEmpty && password.isNotEmpty){
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      if(result.user!=null){
        var uid = result.user?.uid;
        Fluttertoast.showToast(msg: "Login is Successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatHomePage(uid: uid!,),));

        emailController.clear();
        passwordController.clear();
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please fill the all filed");
    }
  }

  void logoutUser(BuildContext context) async{
    await auth.signOut();
    Fluttertoast.showToast(msg: "logOut User");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
  }


  Future<void> fetchUserData(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("user");
    try {
      final dataSnapshot = await ref.get();
      if (dataSnapshot.exists) {
        final dataMap = Map<String, dynamic>.from(dataSnapshot.value as Map);
        final List<UserModel> tempList = dataMap.entries.map((e) {
          return UserModel.fromJson(Map<String, dynamic>.from(e.value));
        }).toList();
        _userData = tempList;
      } else {
        _userData = [];
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _userData = [];
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<String?>getDeviceTokenFromFirebase()async{
    String? token = await firebaseMessaging.getToken();
    if(token != null ){
      print("device token $token");
    }
    else{
      print("something went wrong");
    }
    return token;
  }

}
