import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/brandsScreen/brands_screen.dart';
import 'package:users_app/models/sellers.dart';

class SellersUIDesignWidget extends StatefulWidget {
  SellersUIDesignWidget({super.key, required this.model});
  Sellers model;

  @override
  State<SellersUIDesignWidget> createState() => _SellersUIDesignWidgetState();
}

class _SellersUIDesignWidgetState extends State<SellersUIDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BrandsScreen(model: widget.model)));
      },
      child: Card(
        color: Colors.black54,
        elevation: 20,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.model.photoUrl,
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  widget.model.name,
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SmoothStarRating(
                    allowHalfRating: true,
                    // onRatingChanged: (v) {
                    //   rating = v;
                    //   setState(() {});
                    // },
                    starCount: 5,
                    rating: widget.model.rating == null
                        ? 0.0
                        : 2, //double.parse(widget.model.rating),
                    size: 25.0,
                    //filledIconData: Icons.blur_off,
                    //halfFilledIconData: Icons.blur_on,
                    color: Colors.pinkAccent,
                    borderColor: Colors.pinkAccent,
                    spacing: 0.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
