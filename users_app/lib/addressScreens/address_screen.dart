import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:users_app/addressScreens/address_design_widget.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/assistantMethods/total_amount.dart';
import 'package:users_app/global/global.dart';

import '../models/address.dart';
import 'save_new_address_screen.dart';

class AddressScreen extends StatefulWidget {
   AddressScreen({super.key, required this.sellerUID, required this.totalAmount});
  String? sellerUID;
  double? totalAmount;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors:
                [
                  Colors.pinkAccent,
                  Colors.purpleAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(sharedPreferences!.getString('uid')).collection("userAddress").snapshots(),
              builder: ((context, AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  if(snapshot.data.docs.length > 0){
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                         return AddressDesignWidget(
                          addressModel: Address.fromJson(snapshot.data.docs[index].data()), 
                          index: context.watch<AddressChanger>().counter, 
                          value: index, 
                          addressID: snapshot.data.docs[index].id,
                          totalAmount: widget.totalAmount!, 
                          sellerUID: widget.sellerUID!,);
                      });
                  }
                  else {
                    return Container();
                  }
                } else{
                  return const Center(child: Text("No Address Found"));
                }
              })
              )
            )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaveNewAddressScreen(sellerUID: widget.sellerUID, totalAmount: widget.totalAmount,)));
        },
        label: const Text("Add New Address"),
        icon: const Icon(Icons.add_location),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}