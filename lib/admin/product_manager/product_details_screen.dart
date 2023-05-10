import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../widgets/myTitle.dart';

class ProductDetailsAdminScreen extends StatefulWidget {
  var _product;
  ProductDetailsAdminScreen(this._product);
  @override
  _ProductDetailsAdminScreenState createState() =>
      _ProductDetailsAdminScreenState();
}

class _ProductDetailsAdminScreenState extends State<ProductDetailsAdminScreen> {
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
              "\$${formatter.format(int.parse(widget._product["product-price"]))}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
            ),
            Divider(),
          ],
        ),
      )),
    );
  }
}
