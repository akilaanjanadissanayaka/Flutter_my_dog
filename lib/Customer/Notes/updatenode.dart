import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/Database.dart';

class UpdateRecord extends StatefulWidget {
  final String id;
  final String Title;
  final String Des;
  const UpdateRecord({
    Key? key,
    required this.id,
    required this.Title,
    required this.Des,
  }) : super(key: key);

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final TitleController = TextEditingController();
  final desController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMemoryData();
  }

  // get memory title & description
  void getMemoryData() async {
    TitleController.text = '${widget.Title}';
    desController.text = '${widget.Des}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updating Memories'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Love Dog',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: TitleController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'Enter title',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: desController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Enter Description',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  onPressed: () {
                    // Edit note, call to database function
                    Database().EditNote(
                        widget.id, TitleController.text, desController.text);
                    Navigator.pop(context, 'refresh');
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
