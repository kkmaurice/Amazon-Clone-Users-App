// ignore_for_file: avoid_print, must_be_immutable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:users_app/global/global.dart';
import 'package:uuid/uuid.dart';

import '../sellersScreens/home_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlaceOrderScreen({super.key, 
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderTime = DateTime.now().millisecondsSinceEpoch.toString();
  String orderId = const Uuid().v4();

  orderDetails() {
    saveOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash On Delivery",
      "orderTime": orderTime,
      "orderId": orderId,
      "sellerUID": widget.sellerUID,
      "isSuccess": true,
      "status": "normal",
    }).whenComplete(() {
      saveOrderDetailsForSeller({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "productIDs": sharedPreferences!.getStringList("userCart"),
        "paymentDetails": "Cash On Delivery",
        "orderTime": orderTime,
        "orderId": orderId,
        "sellerUID": widget.sellerUID,
        "isSuccess": true,
        "status": "normal",
      }).whenComplete(() {
        cartMethods.clearCart(context);

        //send push notification to seller about new order which is placed by user
        sendNotificationToSeller(widget.sellerUID.toString(), orderId);

        Fluttertoast.showToast(
            msg: "Congratulations, Order has been placed successfully.");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));

        orderId = "";
      });
    });
  }

  saveOrderDetailsForUser(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  saveOrderDetailsForSeller(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  sendNotificationToSeller(sellerUID, orderId) async {
    String deviceToken = '';
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .get()
        .then((value) {
      if (value.data()!['deviceToken'] != null) {
        deviceToken = value.data()!['deviceToken'];
      }
    });
    notificationFormat(
        deviceToken, orderId, sharedPreferences!.getString("name"));
  }

  notificationFormat(sellerDeviceToken, orderID, userName) {
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken
    };

    Map bodyNotification = {
      'body':
          'Dear Seller, You have a new order (# $orderId) has been placed successfully from user $userName. \nPleas check now',
      'title': 'New Order Placed',
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'userOrderId': orderId,
    };

    Map officialNotification = {
      'notification': bodyNotification,
      'priority': 'high',
      'data': dataMap,
      'to': sellerDeviceToken
    };

    post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headerNotification, body: jsonEncode(officialNotification));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/delivery.png"),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            onPressed: () {
              orderDetails();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Place Order Now"),
          ),
        ],
      ),
    );
  }
}
