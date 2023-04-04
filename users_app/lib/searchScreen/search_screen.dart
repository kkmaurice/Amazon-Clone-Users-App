import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:users_app/sellersScreens/sellers_ui_design_widget.dart';

import '../models/sellers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String sellerName = "";
  Future<QuerySnapshot>? storesDocumentList;

  initializeSearchStores(String textEnteredbyUser) {
    storesDocumentList = FirebaseFirestore.instance
        .collection("sellers")
        .where("name", isGreaterThanOrEqualTo: textEnteredbyUser)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        )),
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search seller here...",
            hintStyle: const TextStyle(color: Colors.white),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                initializeSearchStores(sellerName);
              },
              color: Colors.white,
              icon: const Icon(Icons.search),
            ),
          ),
          onChanged: (textEntered) {
            setState(() {
              sellerName = textEntered;
            });
            initializeSearchStores(sellerName);
          },
        ),
      ),
      body: FutureBuilder(
        future: storesDocumentList,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Sellers sellers = Sellers.fromMap(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return SellersUIDesignWidget(model: sellers);
              },
            );
          } else {
            return const Center(
              child: Text("No data found"),
            );
          }
        },
      ),
    );
  }
}
