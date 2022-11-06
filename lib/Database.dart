import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // reade Notes
  Future readmyNotes() async {
    QuerySnapshot querySnapshot;
    List notelist = [];
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    querySnapshot =
        await db.collection("Users").doc(uid).collection("MyNotes").get();
    for (var doc in querySnapshot.docs.toList()) {
      Map a = {
        "id": doc.id,
        "NoteDesc": doc['NoteDesc'],
        "NoteTitle": doc['NoteTitle'],
      };
      notelist.add(a);
    }
    return notelist;
  }

  // read vaccination details
  Future readVaccines() async {
    QuerySnapshot querySnapshot;
    List vaccinelist = [];
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    querySnapshot =
        await db.collection("Vaccine").doc(uid).collection("MyVaccine").get();
    for (var doc in querySnapshot.docs.toList()) {
      Map a = {
        "id": doc.id,
        "VName": doc['VName'],
        "VDate": doc['VDate'],
        "VNextDate": doc['VNextDate'],
      };
      vaccinelist.add(a);
    }
    return vaccinelist;
  }

  // Edit Dog notes
  Future EditNote(id, title, dec) async {
    CollectionReference collectionReference;
    List vaccinelist = [];
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    collectionReference =
        await db.collection("Users").doc(uid).collection("MyNotes");

    return collectionReference
        .doc(id)
        .update({
          "NoteTitle": title,
          "NoteDesc": dec,
        })
        .then((value) => print("updated "))
        .catchError((error) => print(error));
  }

  // Read dog details
  Future readDogdetails() async {
    QuerySnapshot querySnapshot;
    List doglist = [];
    querySnapshot = await db.collection("Dogs").get();
    for (var doc in querySnapshot.docs.toList()) {
      Map a = {
        "id": doc.id,
        "location": doc['location'],
        "contact": doc['contact'],
        "img": doc['img'],
        "mail": doc['mail'],
      };
      doglist.add(a);
    }
    return doglist;
  }
}
