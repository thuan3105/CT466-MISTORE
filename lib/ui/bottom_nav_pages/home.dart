import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/widgets/myTitle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../product_details_screen.dart';
import '../search_screen.dart';

import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  final formatter = NumberFormat('#,##0', 'en_US');
  @override
  void initState() {
    fetchCarouselImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: TextFormField(
                        controller: _searchController,
                        readOnly: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "Search products here",
                          hintStyle: TextStyle(fontSize: 15.sp),
                        ),
                        onTap: () => Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => SearchScreen())),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            AspectRatio(
              aspectRatio: 3.5,
              child: CarouselSlider(
                  items: _carouselImages
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(item),
                                      fit: BoxFit.fitWidth)),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {
                          _dotPosition = val;
                        });
                      })),
            ),
            SizedBox(
              height: 10.h,
            ),
            DotsIndicator(
              dotsCount:
                  _carouselImages.length == 0 ? 1 : _carouselImages.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColors.deep_orange,
                color: AppColors.deep_orange.withOpacity(0.5),
                spacing: EdgeInsets.all(2),
                activeSize: Size(8, 8),
                size: Size(6, 6),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something is wrong"),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1),
                          itemCount: snapshot.data == null
                              ? 0
                              : snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot _documentSnapshot =
                                snapshot.data!.docs[index];

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetails(_documentSnapshot))),
                              child: Card(
                                shadowColor: Color.fromARGB(255, 0, 0, 0),
                                color: Color.fromARGB(255, 241, 241, 241),
                                elevation: 3,
                                child: Column(
                                  children: [
                                    AspectRatio(
                                        aspectRatio: 1.7,
                                        child: Container(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: Image.network(
                                                _documentSnapshot[
                                                    "product-img"],
                                              ),
                                            ))),
                                    SizedBox(height: 15),
                                    myTitle(
                                        "${_documentSnapshot["product-name"]}",
                                        18),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${formatter.format(int.parse(_documentSnapshot["product-price"]))}đ",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 145, 10, 0)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }
}
