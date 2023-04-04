import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/functions/functions.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/models/sellers.dart';
import 'package:users_app/sellersScreens/sellers_ui_design_widget.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';

import '../push_notification/push_notifications_system.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  restrictBlockedUsersFromUsingUserApp() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((value) {
      if (value.data()!["status"] != "approved") {
        showResuableSnackBar(context, "you are blocked by admin");
        showResuableSnackBar(context, "contact admin: admin2@admin.com");

        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MySplashScreen();
        }));
      } else {
        cartMethods.clearCart(context);
      }
    });
  }

  @override
  void initState() {
    PushNotificationSystem pushNotificationsSystem = PushNotificationSystem();
    pushNotificationsSystem.whenNotificationReceived(context);
    pushNotificationsSystem.registrationToken();

    restrictBlockedUsersFromUsingUserApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.purpleAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          //image slider
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .9,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: itemsImagesList.map((index) {
                    return Builder(builder: (BuildContext c) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            index,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),

          //query
          //model
          //design widget

          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("sellers").snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot) {
              if (dataSnapshot.hasData) {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Sellers model = Sellers.fromMap(
                        dataSnapshot.data.docs[index].data()
                            as Map<String, dynamic>);

                    return SellersUIDesignWidget(
                      model: model,
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No Sellers Data exists.",
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
