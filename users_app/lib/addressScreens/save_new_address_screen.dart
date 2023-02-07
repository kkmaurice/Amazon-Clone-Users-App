import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/addressScreens/text_field_address_widget.dart';
import 'package:users_app/global/global.dart';
import 'package:uuid/uuid.dart';

class SaveNewAddressScreen extends StatefulWidget {

  String? sellerUID;
  double? totalAmount;
   SaveNewAddressScreen({
    Key? key,
    required this.sellerUID,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<SaveNewAddressScreen> createState() => _SaveNewAddressScreenState();
}

class _SaveNewAddressScreenState extends State<SaveNewAddressScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController phonNumber = TextEditingController();
  TextEditingController streetNumber = TextEditingController();
  TextEditingController flatHouseNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController stateCountry = TextEditingController();
  

  String completeAddress = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    phonNumber.dispose();
    streetNumber.dispose();
    flatHouseNumber.dispose();
    city.dispose();
    stateCountry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: SingleChildScrollView(
        child: Column(
          children:  [
             const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text('Save New Address',style: TextStyle(color: Colors.grey,fontSize: 22,fontWeight: FontWeight.bold),),
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldAddressWidget(hint: "Name", controller: name),
                  TextFieldAddressWidget(hint: "Phone Number", controller: phonNumber),
                  TextFieldAddressWidget(hint: "Street Number", controller: streetNumber),  
                  TextFieldAddressWidget(hint: "Flat / House Number", controller: flatHouseNumber),
                  TextFieldAddressWidget(hint: "City", controller: city),               
                  TextFieldAddressWidget(hint: "State / Country", controller: stateCountry), 
                ],
              )
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if(_formKey.currentState!.validate()){

            completeAddress = "${name.text}, ${phonNumber.text}, ${streetNumber.text}, ${flatHouseNumber.text}, ${city.text}, ${stateCountry.text}";

            FirebaseFirestore.instance.collection("users").doc(sharedPreferences!.getString("uid")).collection("userAddress").doc(const Uuid().v4()).set({
              "name": name.text.trim(),
              "phone": phonNumber.text.trim(),
              "streetNumber": streetNumber.text.trim(),
              "flatHouseNumber": flatHouseNumber.text.trim(),
              "city": city.text.trim(),
              "stateCountry": stateCountry.text.trim(),
              "completeAddress": completeAddress.trim(), 
            }).then((value) {
              Fluttertoast.showToast(msg: "New Address Saved Successfully");
              _formKey.currentState!.reset();
            });
          }
        },
        label: const Text("Save Now"),
        icon: const Icon(Icons.save),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}