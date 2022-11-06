import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/Customer/Notes/updatenode.dart';
import 'package:flutter_application_3/Database.dart';

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String title = "";
  String description = "";
  @override
  void initState() {
    // fetch Notes data when initial state
    fetchlistMyMemories();
    super.initState();
  }

  // Load Notes
  List mynotes = [];
  Future fetchlistMyMemories() async {
    dynamic result = await Database().readmyNotes();
    if (result != null) {
      setState(() {
        mynotes = result;
      });
    }
  }

  // To add new memory
  Future AddMemories() async {
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MyNotes");

    Map<String, String> todoList = {
      "NoteTitle": title,
      "NoteDesc": description
    };

    collectionReference.add(todoList).whenComplete(
        () => {fetchlistMyMemories(), print("Note added successfully")});
  }

  // To Delete memory
  Future deleteMemory(id) async {
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MyNotes");
    return collectionReference
        .doc(id)
        .delete()
        .then((value) =>
            {fetchlistMyMemories(), print("Note deleted successfully")})
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("MyNotes")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: mynotes.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 11,
                        margin: const EdgeInsets.all(14.0),
                        child: ListTile(
                          title: Text(mynotes[index]["NoteTitle"]),
                          subtitle: Text(mynotes[index]["NoteDesc"]),
                          trailing: Wrap(
                            spacing: 12,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Theme.of(context).primaryColor,
                                onPressed: () async {
                                  String refresh = await Navigator.push(
                                      context,
                                      // pass memory id,title & description
                                      // to update page
                                      MaterialPageRoute(
                                          builder: (_) => UpdateRecord(
                                                id: mynotes[index]["id"],
                                                Title: mynotes[index]
                                                    ["NoteTitle"],
                                                Des: mynotes[index]["NoteDesc"],
                                              )));
                                  if (refresh == 'refresh') {
                                    fetchlistMyMemories();
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red[700],
                                onPressed: () {
                                  deleteMemory(mynotes[index]["id"]);
                                },
                              ),
                            ],
                          ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Note"),
                  content: SingleChildScrollView(
                    child: Container(
                      width: 300,
                      height: 150,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (String value) {
                              title = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: (String value) {
                              description = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            AddMemories();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add"))
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
