import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navbar.dart';

class AddDog extends StatefulWidget {
  const AddDog({Key? key}) : super(key: key);

  @override
  State<AddDog> createState() => _AddDogState();
}

class _AddDogState extends State<AddDog> {
  TextEditingController _controllerLocation = TextEditingController();
  TextEditingController _controllercontact = TextEditingController();
  TextEditingController _controllerimg = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  // create a collection ref
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Dogs');

  String imageUrl = '';
  String email = '';
  Uint8List webImage = Uint8List(8);

  // upload image to storage
  uploadImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      _controllerimg.text = "uploaded";
      // print image url when complete upload
      print("url->" + imageUrl);
    } catch (error) {}
  }

  // Get email from SharedPreferences
  getcookee() async {
    final prefs = await SharedPreferences.getInstance();
    final String? us = prefs.getString('user');
    if (us.toString() == 'null') {
    } else {
      email = us.toString();
    }
  }

  @override
  void initState() {
    getcookee();
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: key,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _controllerLocation,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Location',
                                hintText: 'Enter the location'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the location';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _controllercontact,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Contact number',
                                hintText: 'Enter your contact number'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the item quantity';
                              }

                              return null;
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Text(_controllerimg.text),
                          ),
                          IconButton(
                              onPressed: () async {
                                await uploadImage();
                              },
                              icon: const Icon(Icons.camera_alt)),
                          ElevatedButton(
                              onPressed: () async {
                                // prevent upload post without image
                                if (imageUrl.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please upload an image')));
                                  return;
                                }

                                // Map and inter data to firestore
                                Map<String, String> dogList = {
                                  "location": _controllerLocation.text,
                                  "contact": _controllercontact.text,
                                  "img": imageUrl,
                                  "mail": email
                                };
                                _reference.add(dogList).then((value) => {
                                      print("Dog added"),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                      )
                                    });
                              },
                              child: const Text('Submit'))
                        ],
                      ),
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
}
