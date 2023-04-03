import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:users_app/ratingScreen/rate_seller_screen.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

import '../global/global.dart';
import '../models/address.dart';

class AddressDesign extends StatelessWidget {
  Address model;
  String orderStatus;
  String orderId;
  String? sellerId;
  String? orderByUser;
  AddressDesign({
    Key? key,
    required this.model,
    required this.orderStatus,
    required this.orderId,
    this.sellerId,
    this.orderByUser,
  }) : super(key: key);


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
          'Dear Seller, Parcel (# $orderId) has received successfully by user $userName. \nPleas check now',
      'title': 'Parcel Received By User',
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
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Shipping Details',
            style: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.name,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.phone,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model.completeAddress,
            textAlign: TextAlign.justify,
            style: const TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        GestureDetector(
          onTap: () {
            if (orderStatus == 'normal') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MySplashScreen()));
            } else if (orderStatus == 'shifted') {
              // implement parcel delivered and received
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(orderId)
                  .update({'status': 'ended'}).whenComplete(() =>
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(orderByUser)
                          .collection('orders')
                          .doc(orderId)
                          .update({'status': 'ended'}));
              // Send notification to the seller that the order has been received
              sendNotificationToSeller(sellerId!, orderId);

              Fluttertoast.showToast(msg: 'Confirmed Successfully');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MySplashScreen()));
            } else if (orderStatus == 'ended') {
              // implement Rate this seller
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RateSellerScreen(sellerId: sellerId!)));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MySplashScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: orderStatus == 'ended'
                    ? 60
                    : MediaQuery.of(context).size.height * 0.07,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.purpleAccent],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )),
                child: Center(
                  child: Text(
                    orderStatus == 'ended'
                        ? 'Do you want to rate this seller?'
                        : orderStatus == 'shifted'
                            ? 'Parcel Received, \nClick to confirm'
                            : orderStatus == 'normal'
                                ? 'Go Back'
                                : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
