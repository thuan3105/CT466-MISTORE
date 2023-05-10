import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../widgets/myTitle.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future<void> addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    DocumentReference _docRef = FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(currentUser!.email)
        .collection("items")
        .doc(widget._product["product-id"]);

    bool exists = await _docRef.get().then((docSnapshot) => docSnapshot.exists);
    if (exists) {
      _docRef.update({"quantity": FieldValue.increment(1)});
    } else {
      _docRef.set({
        "id": widget._product["product-id"],
        "name": widget._product["product-name"],
        "price": widget._product["product-price"],
        "images": widget._product["product-img"],
        "quantity": 1,
      }).then((value) => print("Added to cart"));
    }
  }

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(widget._product["product-id"])
        .set({
      "id": widget._product["product-id"],
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
    }).then((value) => print("Added to favourite"));
  }

  Future<bool> isFavorite(String id) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users-favourite-items')
        .doc(currentUser!.email)
        .collection('items')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isCart(String id) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users-cart-items')
        .doc(currentUser!.email)
        .collection('items')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  final formatter = NumberFormat('#,##0', 'en_US');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .where("name", isEqualTo: widget._product['product-name'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: AppColors.deep_orange,
                  child: IconButton(
                    onPressed: () async {
                      var isFav = await isFavorite(widget._product[
                          'product-id']); // itemId là id của sản phẩm được ấn nút yêu thích
                      if (isFav) {
                        print("Already Added");
                      } else {
                        addToFavourite();
                      }
                    },
                    icon: FutureBuilder<bool>(
                      future: isFavorite(widget._product['product-id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else if (snapshot.data == true) {
                          return Icon(Icons.favorite_outline,
                              color: Colors.white);
                        } else {
                          return Icon(Icons.favorite, color: Colors.white);
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(255, 208, 208, 208),
                ),
                child: Image.network(
                  widget._product["product-img"],
                )),
            SizedBox(
              height: 20,
            ),
            myTitle('${widget._product['product-name']}', 25),
            Text(widget._product['product-description']),
            SizedBox(
              height: 10,
            ),
            Text(
              "${formatter.format(int.parse(widget._product["product-price"]))}đ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
            ),
            Divider(),
            SizedBox(
              width: 1.sw,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => addToCart(),
                child: Text(
                  "Add to cart",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.deep_orange,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
