import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/admin/product_manager/product_add_screen.dart';

import 'package:flutter_ecommerce/widgets/myTitle.dart';

import 'product_details_screen.dart';
import 'product_edit_screen.dart';

class ProductAdminManager extends StatefulWidget {
  ProductAdminManager({Key? key}) : super(key: key);

  @override
  State<ProductAdminManager> createState() => _ProductAdminManagerState();
}

class _ProductAdminManagerState extends State<ProductAdminManager> {
  @override
  Widget build(BuildContext context) {
    // print(_products.length);
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => AddProductScreen()));
              },
              icon: Icon(
                Icons.add,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 30,
              )),
        ],
        backgroundColor: Colors.white,
        title: myTitle('Product Manager', 24),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something is wrong"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProductDetailsAdminScreen(
                                    _documentSnapshot))),
                        child: ListTile(
                          leading: Image.network(
                            _documentSnapshot['product-img'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(_documentSnapshot['product-name']),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => EditProductScreen(
                                              _documentSnapshot)),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 83, 83, 83),
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    final User? currentUser = _auth.currentUser;

                                    List productid = [];
                                    print(currentUser?.email);
                                    print(_documentSnapshot['product-id']);

                                    CollectionReference checkoutRef =
                                        FirebaseFirestore.instance
                                            .collection("users-checkout-data")
                                            .doc(currentUser!.email)
                                            .collection('checkouts');

                                    checkoutRef.get().then((querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        List<dynamic> products =
                                            doc.get('products');

                                        // Duyệt qua tất cả các sản phẩm trong mảng 'products'
                                        for (var product in products) {
                                          String productId = product['id'];
                                          // Truy cập các trường của sản phẩm

                                          // print(productId);
                                          productid.add(productId);
                                        }
                                      });

                                      if (productid.contains(
                                          _documentSnapshot['product-id'])) {
                                        print("Xóa sản phẩm thất bại!");
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection("products")
                                            .doc(_documentSnapshot.id)
                                            .delete()
                                            .then((value) => print(
                                                "Xóa sản phẩm thành công!"))
                                            .catchError((error) => print(
                                                "Xóa sản phẩm thất bại: $error"));
                                      }
                                    }).catchError((error) =>
                                        print("something is wrong. $error"));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 83, 83, 83),
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
