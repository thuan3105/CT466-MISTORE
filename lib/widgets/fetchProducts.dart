// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/widgets/myTitle.dart';
import 'package:intl/intl.dart';
import '../ui/checkout_screen.dart';

final formatter = NumberFormat('#,##0', 'en_US');

Widget fetchDataFavorite(String collectionName) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text("Something is wrong"),
        );
      }

      return ListView.builder(
          itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
          itemBuilder: (_, index) {
            DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];

            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(_documentSnapshot['images']),
                    title: Row(
                      children: [
                        Container(
                            width: 120,
                            child: myTitle(_documentSnapshot['name'], 14)),
                        SizedBox(width: 5),
                        Text(
                          "${formatter.format(int.parse(_documentSnapshot['price']))}đ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: AppColors.deep_orange,
                      ),
                      child: GestureDetector(
                        child: Icon(Icons.clear, color: Colors.white),
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection(collectionName)
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .doc(_documentSnapshot.id)
                              .delete();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    },
  );
}

Widget fetchDataCart(String collectionName) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text("Something is wrong"),
        );
      }

      // Tính tổng số tiền của các mặt hàng trong giỏ hàng
      double totalPrice = 0.0;
      if (snapshot.hasData) {
        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          double price = double.parse(document['price']);
          int quantity = document['quantity'];
          totalPrice += price * quantity;
        });
      }
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount:
                    snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot _documentSnapshot =
                      snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: Image.network(_documentSnapshot['images']),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            myTitle(_documentSnapshot['name'], 14),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "\$${formatter.format(int.parse(_documentSnapshot['price']))}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 3, 3, 3)),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  "X${_documentSnapshot['quantity']}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 2, 2, 2)),
                                ),
                                SizedBox(width: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: AppColors.deep_orange,
                                      ),
                                      child: IconButton(
                                        iconSize: 15,
                                        color: Colors.white,
                                        onPressed: () {
                                          if (_documentSnapshot['quantity'] >
                                              1) {
                                            // Giảm số lượng
                                            FirebaseFirestore.instance
                                                .collection(collectionName)
                                                .doc(FirebaseAuth.instance
                                                    .currentUser!.email)
                                                .collection("items")
                                                .doc(_documentSnapshot.id)
                                                .update({
                                              'quantity': _documentSnapshot[
                                                      'quantity'] -
                                                  1
                                            });
                                          } else {
                                            // Xóa item
                                            FirebaseFirestore.instance
                                                .collection(collectionName)
                                                .doc(FirebaseAuth.instance
                                                    .currentUser!.email)
                                                .collection("items")
                                                .doc(_documentSnapshot.id)
                                                .delete();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                        ),
                                      ),
                                      constraints: BoxConstraints.tightFor(
                                          width: 30, height: 30),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: AppColors.deep_orange,
                                      ),
                                      child: IconButton(
                                        iconSize: 15,
                                        color: Colors.white,
                                        onPressed: () {
                                          // Tăng số lượng
                                          FirebaseFirestore.instance
                                              .collection(collectionName)
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.email)
                                              .collection("items")
                                              .doc(_documentSnapshot.id)
                                              .update({
                                            'quantity':
                                                _documentSnapshot['quantity'] +
                                                    1
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                        ),
                                      ),
                                      constraints: BoxConstraints.tightFor(
                                          width: 30, height: 30),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: AppColors.deep_orange,
                          ),
                          child: GestureDetector(
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection(collectionName)
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection("items")
                                  .doc(_documentSnapshot.id)
                                  .delete();
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                myTitle(
                    "Total Price: ${NumberFormat.currency(
                      symbol: "",
                      decimalDigits: 0,
                    ).format(totalPrice)}đ",
                    16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
                    );
                  },
                  child: Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}
