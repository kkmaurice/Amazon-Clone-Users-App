// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

class RateSellerScreen extends StatefulWidget {
  String sellerId;
  RateSellerScreen({
    Key? key,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<RateSellerScreen> createState() => _RateSellerScreenState();
}

class _RateSellerScreenState extends State<RateSellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        backgroundColor: Colors.white60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white54, borderRadius: BorderRadius.circular(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  "Rate this seller",
                  style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Divider(
                  height: 4,
                  thickness: 4,
                ),
                const SizedBox(
                  height: 22,
                ),
                SmoothStarRating(
                    allowHalfRating: true,
                    onRatingChanged: (value) {
                      countStarRating = value;
                      //setState(() {});
                      if (countStarRating == 1) {
                        setState(() {
                          titleStarRating = "Very Bad";
                        });
                      }
                      if (countStarRating == 2) {
                        setState(() {
                          titleStarRating = "Bad";
                        });
                      }
                      if (countStarRating == 3) {
                        setState(() {
                          titleStarRating = "Good";
                        });
                      }
                      if (countStarRating == 4) {
                        setState(() {
                          titleStarRating = "Very Good";
                        });
                      }
                      if (countStarRating == 5) {
                        setState(() {
                          titleStarRating = "Excellent";
                        });
                      }
                    },
                    starCount: 5,
                    rating: countStarRating,
                    size: 46.0,
                    //filledIconData: Icons.blur_off,
                    //halfFilledIconData: Icons.blur_on,
                    color: Colors.purpleAccent,
                    borderColor: Colors.purpleAccent,
                    spacing: 0.0),
                const SizedBox(
                  height: 22,
                ),
                Text(
                  titleStarRating,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('sellers')
                        .doc(widget.sellerId)
                        .get()
                        .then((snap) {
                      if (snap.data()!['ratings'] == null) {
                        // seller not yet received rating from any user
                        FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(widget.sellerId)
                            .update({'ratings': countStarRating.toString()});
                      } else {
                        // Seller has already received rating from any user
                        double pastRating =
                            double.parse(snap.data()!['ratings'].toString());
                        double newRating = (pastRating + countStarRating) / 2;
                        FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(widget.sellerId)
                            .update({'ratings': newRating.toString()});
                      }
                      Fluttertoast.showToast(msg: 'Rated successfully');
                      setState(() {
                        countStarRating = 0.0;
                        titleStarRating = '';
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MySplashScreen()));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 74)),
                  child: const Text('Submit'),
                )
              ],
            )),
      ),
    );
  }
}
