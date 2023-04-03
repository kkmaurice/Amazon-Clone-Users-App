import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:users_app/functions/functions.dart';

import '../global/global.dart';

class PushNotificationSystem {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // notification arrived/recieved
  Future whenNotificationReceived(BuildContext context) async {
    //1. Terminated
    //when the app is completely closed and opened directly from the notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // open the app and show the notification
        sendNotificationWhenOpenApp(message.data['userOrderId'], context);
      }
    });

    //2. Foreground
    //when the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        // directly show the notification data
        sendNotificationWhenOpenApp(message.data['userOrderId'], context);
      }
    });

    //3. Background
    // when the app is in the background and opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        // open the app and show the notification
        
      }
    });
  }

  // device recognition token
  Future registrationToken() async {
    String? registrationDeviceToken = await _firebaseMessaging.getToken();

    // add token to database
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .update({'deviceToken': registrationDeviceToken});

    _firebaseMessaging.subscribeToTopic('allSellers');
    _firebaseMessaging.subscribeToTopic('allUsers');
  }

  sendNotificationWhenOpenApp(userOrderId,context) {
    showResuableSnackBar(context, 'Your Parcel (# $userOrderId) has been shifted successfully by the seller', );
  }
}
