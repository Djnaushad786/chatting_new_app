import 'package:chatting_new_app/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    var provider= Provider.of<UserProvider>(context,listen: false);

    return Scaffold(
        body: Stack(
            children: [
              // Background container
              Container(
                color: Colors.black,
                alignment: Alignment.topLeft,
              ),
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "SignUP",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: provider.nameController,
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: provider.emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: provider.passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  provider.userSignUp(context);
                                },
                                child: Text("Sign Up"),
                              ),
                            ),
                          ],
                        ),
                        TextButton(onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                        }, child: Text("All ready Account"))
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, top: 80),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ),
        );
    }
}