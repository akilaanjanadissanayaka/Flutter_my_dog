import 'package:flutter/material.dart';

// Side nav bar headre
class MyHeaderDrawer extends StatelessWidget {
  const MyHeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/app-3-adb8e.appspot.com/o/images%2F1667739647593?alt=media&token=a7434f4f-ec34-4315-bcc4-2ed2a330b1b7")),
            ),
          ),
          const Text(
            "DoggY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "doginfo@gmail.com",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
