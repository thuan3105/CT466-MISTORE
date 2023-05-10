import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/myTitle.dart';

class EditProductScreen extends StatefulWidget {
  var product;
  EditProductScreen(this.product);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product['product-name'];
    _descriptionController.text = widget.product['product-description'];
    _priceController.text = widget.product['product-price'];
    _imageUrlController.text = widget.product['product-img'];
  }

  updateProduct(String productId, Map<String, dynamic> dataToUpdate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("products")
          .where("product-id", isEqualTo: productId)
          .get();
      final updatedProduct = {
        'name': dataToUpdate['product-name'],
        'price': dataToUpdate['product-price'],
        'images': dataToUpdate['product-img'],
      };
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.update(dataToUpdate);
        updateFavourite(productId, updatedProduct);
        updateCart(productId, updatedProduct);

        print("Product updated successfully");
      } else {
        print("No product found with ID: $productId");
      }
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  updateFavourite(String productId, Map<String, dynamic> dataToUpdate) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(productId)
        .update(dataToUpdate)
        .then((value) => print("Added to favourite"));
  }

  updateCart(String productId, Map<String, dynamic> dataToUpdate) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    DocumentReference _docRef = FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(currentUser!.email)
        .collection("items")
        .doc(productId);
    _docRef.update(dataToUpdate).then((value) => print("Added to cart"));
  }

  Widget build(BuildContext context) {
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
        title: myTitle('Edit Product', 24),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product price';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Product Image URL',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product image URL';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedProduct = {
                          'product-name': _nameController.text.trim(),
                          'product-description':
                              _descriptionController.text.trim(),
                          'product-price': (_priceController.text.trim()),
                          'product-img': _imageUrlController.text.trim(),
                        };
                        await updateProduct(
                            widget.product['product-id'], updatedProduct);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
