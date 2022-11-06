import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);
  @override
  State<signup> createState() => _signupstate();
}

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
var error = "";

// For Email text feild Widget
Widget buildEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Email',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: _email,
          onChanged: (value) {
            error = "";
          },
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black26),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

// For Password text feild Widget
Widget buildpassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Password',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: _password,
          onChanged: (value) {
            error = "";
          },
          obscureText: true,
          style: const TextStyle(color: Colors.black26),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

class _signupstate extends State<signup> {
  @override
  void dispose() {
    // _email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email.text = "";
    _password.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0x665ac18e),
                    Color(0x995ac18e),
                    Color(0xcc5ac18e),
                    Color(0xff5ac18e),
                  ])),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    buildEmail(),
                    const SizedBox(
                      height: 20,
                    ),
                    buildpassword(),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: signUp, child: const Text("Sign up")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          // Navigate to login page
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Back")),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  // set email when sign up by SharedPreferences
  setcookee() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', _email.text);
  }

  // sign p function and  after sign up redirect to main page
  signUp() async {
    setcookee();
    int x = 0;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        x = 1;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email..');
        x = 1;
      }
    } catch (e) {
      print(e);
    }
    if (x != 1) {
      Navigator.pop(context);
    }
  }
}
