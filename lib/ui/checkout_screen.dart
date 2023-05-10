// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/widgets/fetchProducts.dart';
import 'package:flutter_ecommerce/widgets/myTitle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'checkout_page.dart';

class CheckoutScreen extends StatelessWidget {
  Future<List<List<Map<String, dynamic>>>> getData() async {
    List<List<Map<String, dynamic>>> data = [];

    try {
      final collectionRefUser =
          FirebaseFirestore.instance.collection('users-form-data');
      final querySnapshotUser = await collectionRefUser.get();
      List<Map<String, dynamic>> dataUser = [];
      querySnapshotUser.docs.forEach((doc) {
        dataUser.add(doc.data());
      });
      data.add(
          dataUser); // Thêm mảng dữ liệu của users-form-data vào danh sách data

      final collectionRefCart = FirebaseFirestore.instance
          .collection('users-cart-items')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items");
      final querySnapshotCart = await collectionRefCart.get();
      List<Map<String, dynamic>> dataCart = [];
      querySnapshotCart.docs.forEach((doc) {
        dataCart.add(doc.data());
      });
      data.add(
          dataCart); // Thêm mảng dữ liệu của users-cart-items vào danh sách data
    } catch (e) {
      print(e.toString());
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<List<Map<String, dynamic>>>> data = getData();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 0, 0, 0),
              )),
        ),
        backgroundColor: Colors.white,
        title: myTitle('Checkout', 24),
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Nếu đã lấy được dữ liệu, truyền vào widget ProductListWidget
            return CheckoutPage(data: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
