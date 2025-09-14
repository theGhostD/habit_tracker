import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class MyAuthScreen extends StatefulWidget {
  const MyAuthScreen({super.key});

  @override
  State<MyAuthScreen> createState() => _MyAuthScreenState();
}

class _MyAuthScreenState extends State<MyAuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();

  bool islogin = true;
  bool isloading = false;

  void userAuthHandler() async {
    try {
      if (islogin) {
        if (emailController.text.isNotEmpty &&
            emailController.text.contains('@') &&
            passwordController.text.isNotEmpty) {
          setState(() {
            isloading = true;
          });

         await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );

          if (mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Authentication Successful')),
            );
          }
        }
      }
      if (!islogin) {
        if (emailController.text.isNotEmpty &&
            emailController.text.contains('@') &&
            passwordController.text.isNotEmpty &&
            passwordController.text.length > 6 &&
            (passwordController.text == passwordController.text)) {
          setState(() {
            isloading = true;
          });
          final response = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );
          if (response.user!.uid.isNotEmpty) {
            try {
              await _firestore.collection('users').doc(response.user!.uid).set({
                'email': emailController.text,
                'Start_date': DateTime.now(),
                'user_data': [],
                'habit_list': [],
              });
            } on FirebaseException catch (error) {
               if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')),
        );
      }
            }
          }

          if (mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Authentication Successful')),
            );
          }
        }
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        isloading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        // height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffA41C37), Color.fromARGB(255, 50, 7, 34)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            // stops: [0.0, 0.59],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      islogin ? 'Hello\nSign in! ' : 'Create Your\nAccount! ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                    Icon(Icons.more_horiz, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 48, right: 48, top: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 46,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                // hintText: 'test',
                                label: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Color(0xff811E3D),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              cursorHeight: 10,
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 46,
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                  size: 18,
                                ),
                                label: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Color(0xff811E3D),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              cursorHeight: 10,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (!islogin)
                            SizedBox(
                              height: 46,
                              child: TextField(
                                obscureText: true,
                                controller: cpasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.remove_red_eye,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Confirm Password',
                                    style: TextStyle(
                                      color: Color(0xff811E3D),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                cursorHeight: 10,
                              ),
                            ),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot password ?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 56),

                          isloading
                              ? CircularProgressIndicator()
                              : Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffA41C37),
                                        Color.fromARGB(255, 50, 7, 34),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child:
                                      // if(isloading)
                                      TextButton(
                                        onPressed: userAuthHandler,
                                        child: Text(
                                          islogin ? 'SIGN IN' : 'SIGN UP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have account?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  islogin = !islogin;
                                });
                              },
                              child: Text(
                                islogin ? "Sign up" : "Sign In",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 50, 7, 34),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
