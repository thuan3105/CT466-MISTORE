import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/widgets/myTitle.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatelessWidget {
  final List<List<Map<String, dynamic>>> data;
  final formatter = NumberFormat('#,##0', 'en_US');
  CheckoutPage({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dataUser = data[0];
    final dataCart = data[1];
    double totalPrice = 0.0;
    if (dataCart != null) {
      dataCart.forEach((item) {
        double price = double.parse(item['price']);
        int quantity = item['quantity'];
        totalPrice += price * quantity;
      });
    }
    Future<void> sendCheckoutUserData() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? currentUser = _auth.currentUser;
      print(currentUser?.email);

      final CollectionReference<Map<String, dynamic>> _collectionRef =
          FirebaseFirestore.instance.collection('users-checkout-data');

      final List<Map<String, dynamic>> products = dataCart.map((item) {
        final double price = double.parse(item['price']);
        final int quantity = item['quantity'];

        final Map<String, dynamic> product = {
          'id': item['id'],
          'name': item['name'],
          'price': price,
          'quantity': quantity,
        };

        return product;
      }).toList();

      final Map<String, dynamic> checkoutData = {
        'checkout-id': DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()),
        'checkout-name': dataUser[0]['name'],
        'checkout-phone': dataUser[0]['phone'],
        'checkout-address': dataUser[0]['address'],
        'total-price': totalPrice,
        'products': products,
      };

      return _collectionRef
          .doc(currentUser!.email)
          .collection('checkouts')
          .doc(DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()))
          .set(checkoutData)
          .then((value) {})
          .catchError((error) => print('Something went wrong: $error'));
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myTitle('Customer Information', 16),
          Divider(),
          Row(
            children: [
              Container(
                  width: 100,
                  child: Text(
                    'Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Text(dataUser[0]['name']),
            ],
          ),
          Divider(),
          Row(
            children: [
              Container(
                  width: 100,
                  child: Text(
                    'Phone: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Text(
                dataUser[0]['phone'],
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Container(
                  width: 100,
                  child: Text(
                    'Address: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Text(
                dataUser[0]['address'],
              ),
            ],
          ),
          Divider(),
          myTitle('Product List', 16),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: dataCart == null ? 0 : dataCart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    dataCart[index]['images'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(dataCart[index]['name']),
                  subtitle: Text(
                      "${formatter.format(double.parse(dataCart[index]['price']))}đ"),
                  trailing: Text('x${dataCart[index]['quantity']}'),
                );
              },
            ),
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
                      locale: "en_US",
                    ).format(totalPrice)}đ",
                    16),
                ElevatedButton(
                  onPressed: () async {
                    await sendCheckoutUserData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Checkout successful!')),
                    );
                  },
                  child: Text(
                    "Buy",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
