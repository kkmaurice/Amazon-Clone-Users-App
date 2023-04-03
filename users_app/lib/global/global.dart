import 'package:shared_preferences/shared_preferences.dart';

import '../assistantMethods/cart_methods.dart';

SharedPreferences? sharedPreferences;

final itemsImagesList = [
  "assets/images/slider/0.jpg",
  "assets/images/slider/1.jpg",
  "assets/images/slider/2.jpg",
  "assets/images/slider/3.jpg",
  "assets/images/slider/4.jpg",
  "assets/images/slider/5.jpg",
  "assets/images/slider/6.jpg",
  "assets/images/slider/7.jpg",
  "assets/images/slider/8.jpg",
  "assets/images/slider/9.jpg",
  "assets/images/slider/10.jpg",
  "assets/images/slider/11.jpg",
  "assets/images/slider/12.jpg",
  "assets/images/slider/13.jpg",
];

CartMethods cartMethods = CartMethods();
double countStarRating = 0.0;
String titleStarRating = '';

String fcmServerToken =
    "key=AAAAqS_OLT0:APA91bFZ2QE59ve-Fvb9R-7yD3ZfMEZNa4Qdb9Sna61AOgQLJ2xG9AJm_xmemJj4ROiE4Il1GmpySk5C-N9m29VJ2IV9NkM0ySPZxYJdxa7vOgD_tSvHbajmoq93ZvO0dtBNfwkN6Frh";
