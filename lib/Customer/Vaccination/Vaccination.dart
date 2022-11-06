import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/Database.dart';
import 'package:intl/intl.dart';

class Vaccination extends StatefulWidget {
  @override
  _VaccinationState createState() => _VaccinationState();
}

class _VaccinationState extends State<Vaccination> {
  String VName = "";
  TextEditingController _Vdate = TextEditingController();
  TextEditingController _NVdate = TextEditingController();
  @override
  void initState() {
    fetchlistMyvaccine();
    super.initState();
  }

  // fetch vaccination details
  List myvaccine = [];
  Future fetchlistMyvaccine() async {
    dynamic result = await Database().readVaccines();
    if (result != null) {
      setState(() {
        myvaccine = result;
      });
    }
  }

  // add new vaccine data
  Future createVaccine() async {
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection("Vaccine")
        .doc(uid)
        .collection("MyVaccine");

    Map<String, String> vaccineList = {
      "VName": VName,
      "VDate": _Vdate.text,
      "VNextDate": _NVdate.text
    };

    collectionReference.add(vaccineList).whenComplete(
        () => {fetchlistMyvaccine(), print("vaccine added successfully")});
  }

  //delete vaccine data
  Future deleteVaccine(id) async {
    final uid = await FirebaseAuth.instance.currentUser?.uid;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection("Vaccine")
        .doc(uid)
        .collection("MyVaccine");
    return collectionReference
        .doc(id)
        .delete()
        .then((value) =>
            {fetchlistMyvaccine(), print("vaccine deleted successfully")})
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
                itemCount: myvaccine.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 11,
                        margin: const EdgeInsets.all(14.0),
                        child: ListTile(
                          title: Text(myvaccine[index]["VName"]),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("From - " + myvaccine[index]["VDate"]),
                              Text("to - " + myvaccine[index]["VNextDate"])
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                deleteVaccine(myvaccine[index]["id"]);
                              });
                            },
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
          //Vaccin add UI
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Vaccine Book"),
                  content: SizedBox(
                    width: 340,
                    height: 230,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (String value) {
                              VName = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Vaccine Name',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _Vdate,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today_rounded),
                                labelText: "select vaccined date"),
                            onTap: () async {
                              DateTime? pickeddate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));

                              if (pickeddate != null) {
                                setState(() {
                                  _Vdate.text = DateFormat('yyyy-MM-dd')
                                      .format(pickeddate);
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _NVdate,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today_rounded),
                                labelText: "select next vaccine date"),
                            onTap: () async {
                              DateTime? pickeddate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));

                              if (pickeddate != null) {
                                setState(() {
                                  _NVdate.text = DateFormat('yyyy-MM-dd')
                                      .format(pickeddate);
                                });
                              }
                            },
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
                            createVaccine();
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
