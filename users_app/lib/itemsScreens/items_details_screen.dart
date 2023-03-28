// ignore_for_file: implementation_imports, must_be_immutable

import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/widgets/appbar_cart_badge.dart';

import '../global/global.dart';
import '../models/items.dart';

class ItemsDetailsScreen extends StatefulWidget {
  ItemsDetailsScreen({super.key, required this.model});
  Items model;
  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  int counterLimit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBarWithCartBadge(
          sellerUID: widget.model.sellerID,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.model.thumbnailUrl,
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CartStepperInt(
                    value: counterLimit,
                    size: 40,
                    //style: CartStepperTheme.of(context).copyWith(activeForegroundColor: Colors.pinkAccent,),
                    didChangeCount: (count) {
                      if (count < 1) {
                        Fluttertoast.showToast(
                            msg: "The quantity cannot be less than 1",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        setState(() {
                          counterLimit = count;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${widget.model.itemTitle.toUpperCase()} :',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.model.longDescription,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '\$${widget.model.itemPrice}',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 2,
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.pinkAccent,
                  indent: 5,
                  endIndent: 320,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (() {
              int itemCounter = counterLimit;

              List<String> itemsIDsList =
                  cartMethods.separateItemIDsFromUserCartList();
              // 1.check if item is already in cart
              if (itemsIDsList.contains(widget.model.itemID)) {
                Fluttertoast.showToast(
                    msg: "Item is already in cart",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              } else {
                cartMethods.addItemToCart(
                    widget.model.itemID, itemCounter, context);
              }
              // 2. add item to cart
            }),
            label: const Text("Add to Cart"),
            icon: const Icon(Icons.add_shopping_cart),
            backgroundColor: Colors.purpleAccent));
  }
}
