import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_3/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dog_society/DogSocity.dart';
import 'Dog_society/Add_poor_dog.dart';
import 'Vaccination/Vaccination.dart';
import 'my_drawer_header.dart';
import './Notes/notes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.DogSociety;

  // sign out function
  exitfunc() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.AddDog) {
      container = const AddDog();
    } else if (currentPage == DrawerSections.DogSociety) {
      container = DogSociety();
    } else if (currentPage == DrawerSections.Vaccination) {
      container = Vaccination();
    } else if (currentPage == DrawerSections.NotesPage) {
      container = NotesPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("My Dog"),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "New Dog", Icons.playlist_add_outlined,
              currentPage == DrawerSections.AddDog ? true : false),
          menuItem(2, "Dog society", Icons.people_alt_outlined,
              currentPage == DrawerSections.DogSociety ? true : false),
          menuItem(3, "Vaccination", Icons.event,
              currentPage == DrawerSections.Vaccination ? true : false),
          menuItem(4, "Memories", Icons.notes,
              currentPage == DrawerSections.NotesPage ? true : false),
          const Divider(),
          menuItem(5, "Exit", Icons.exit_to_app_outlined,
              currentPage == DrawerSections.exit ? true : false),
          const Divider(),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.AddDog;
            } else if (id == 2) {
              currentPage = DrawerSections.DogSociety;
            } else if (id == 3) {
              currentPage = DrawerSections.Vaccination;
            } else if (id == 4) {
              currentPage = DrawerSections.NotesPage;
            } else if (id == 5) {
              // sign out function
              exitfunc();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections { AddDog, DogSociety, Vaccination, NotesPage, exit }
