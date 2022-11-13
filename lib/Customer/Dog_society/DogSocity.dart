// ignore_for_file: unnecessary_new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DogSociety extends StatefulWidget {
  @override
  _DogSocietyState createState() => new _DogSocietyState();
}

// Get email from SharedPreferences
String email = "";
getcookee() async {
  final prefs = await SharedPreferences.getInstance();
  final String? us = prefs.getString('user');
  if (us.toString() == 'null') {
  } else {
    email = us.toString();
  }
}

class _DogSocietyState extends State<DogSociety> {
  @override
  void initState() {
    // get mail in initial state
    getcookee();
    // fetch dog posts in initial state
    fetchlistDogs();
    super.initState();
  }

  // fetch Dog posts and save it in doglist
  List doglist = [];
  Future fetchlistDogs() async {
    dynamic result = await Database().readDogdetails();
    if (result != null) {
      setState(() {
        doglist = result;
      });
    }
    // print(doglist);
  }

  // Delete Dog post by post owners
  Future deleteDogDetails(id) async {
    CollectionReference collectionReference =
        await FirebaseFirestore.instance.collection("Dogs");
    return collectionReference
        .doc(id)
        .delete()
        .then((value) =>
            {fetchlistDogs(), print("Dog post deleted successfully")})
        .catchError((e) => {print(e)});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Dogs").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: doglist.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 11,
                      margin: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                // Show if there is an image
                                image: doglist[index]["img"] != null
                                    ? DecorationImage(
                                        image:
                                            NetworkImage(doglist[index]["img"]),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: NetworkImage('urlImage'),
                                      )),
                          ),
                          ListTile(
                            title: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 10),
                                      child: Text(
                                        doglist[index]["location"],
                                      )),
                                  // Compare login email with post email
                                  // and give permission to delete post for owners
                                  (email == doglist[index]["mail"])
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red[700],
                                          onPressed: () {
                                            deleteDogDetails(
                                                doglist[index]["id"]);
                                          },
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            subtitle: Expanded(
                                child: Container(
                                    height: 35,
                                    padding: const EdgeInsets.only(bottom: 5),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        doglist[index]["contact"],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ))),
                          ),
                        ],
                      ),
                    ));
              });
        }
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.red,
            ),
          ),
        );
      },
    ));
  }
}
