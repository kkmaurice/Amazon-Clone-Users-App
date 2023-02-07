import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../itemsScreens/items_screen.dart';
import '../models/brands.dart';
import '../splashScreen/my_splash_screen.dart';

class BrandsUiDesignWidget extends StatefulWidget {

  Brands model;
  BuildContext context;

  BrandsUiDesignWidget({
    Key? key,
    required this.model,
    required this.context,
  }) : super(key: key);

  @override
  State<BrandsUiDesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<BrandsUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsScreen(model: widget.model)));
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                  child: Image.network(widget.model.thumbnailUrl, height: 220, fit: BoxFit.fill,width: MediaQuery.of(context).size.width,)),
                const SizedBox(height: 1,),
                Text(widget.model.brandTitle.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent, letterSpacing: 3),),
              ],
            )
          ),
          ),
      ),
    );
  }
}