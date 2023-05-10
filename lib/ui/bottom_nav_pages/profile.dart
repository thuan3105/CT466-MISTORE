import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/widgets/myTitle.dart';

import '../../widgets/drawer.dart';
import '../bottom_nav_controller.dart';
import '../splash_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;
  TextEditingController? _genderController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  setDataToTextField(data) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Card(
          shadowColor: Color.fromARGB(255, 112, 112, 112),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _nameController =
                            TextEditingController(text: data['name']),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Phone: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _phoneController =
                            TextEditingController(text: data['phone']),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Gender: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _genderController =
                            TextEditingController(text: data['gender']),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Age: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _ageController =
                            TextEditingController(text: data['age']),
                      ),
                    ),
                  ],
                ),
                Divider(),
                ElevatedButton(
                    onPressed: () => updateData(), child: Text("Update")),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (user!.uid == 'TBHAuLUDxCWRUizbynwK0OSjhZZ2')
                        Center(
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.build,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                              ),
                              myTitle('Admin Manager', 12),
                            ],
                          ),
                        )
                      else
                        Center(
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.exit_to_app,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => SplashScreen()));
                                },
                              ),
                              myTitle('Logout', 12),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    print(FirebaseAuth.instance.currentUser!.email);
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "gender": _genderController!.text,
      "age": _ageController!.text,
    }).then((value) => print("Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: InfoDrawer(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDataToTextField(data);
          },
        ),
      )),
    );
  }
}
