import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'Customer/navbar.dart';
import './auth.dart';
import 'package:flutter/material.dart';

class landing extends StatefulWidget {
  const landing({Key? key}) : super(key: key);

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  final category = Category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(
                "==================================home page==========================================");
            print(snapshot.data);
            return HomePage();
          } else {
            print(
                "==================================fireauth==========================================");
            print(snapshot.data);
            return const fireauth();
          }
        },
      ),
    );
  }
}
