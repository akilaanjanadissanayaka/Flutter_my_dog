import 'package:flutter/services.dart';
import 'signup.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class fireauth extends StatefulWidget {
  const fireauth({Key? key}) : super(key: key);
  @override
  State<fireauth> createState() => _fireauthstate();
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
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
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

//Set cookies when signin
setcookee() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', _email.text);
}

// Sign in function
signin() async {
  setcookee();
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

// for login button widget
Widget buidLoginbtn() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: const ElevatedButton(onPressed: signin, child: Text("Sign In")),
  );
}

class _fireauthstate extends State<fireauth> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // _email.dispose();
    super.dispose();
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
                      'Sign In',
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
                    buidLoginbtn(),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: signUp, child: const Text("Sign up")),
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

  // Navigate to sign up page
  signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const signup()),
    );
  }

  //get email from SharedPreferences if available
  getcookee() async {
    final prefs = await SharedPreferences.getInstance();
    final String? us = prefs.getString('user');
    if (us.toString() == 'null') {
    } else {
      _email.text = us.toString();
    }
    _password.text = "";
  }

  @override
  void initState() {
    getcookee();
    super.initState();
  }

  // Google sign in but nott added , It provide 0Auth error
  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }
}
