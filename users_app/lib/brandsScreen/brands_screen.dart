import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/widgets/text_delegate_header_widget.dart';

import '../models/brands.dart';
import '../models/sellers.dart';
import '../widgets/my_drawer.dart';
import 'brands_ui_design_widget.dart';


class BrandsScreen extends StatefulWidget
{
  BrandsScreen({Key? key, required this.model}) : super(key: key);
  Sellers model;
  @override
  State<BrandsScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<BrandsScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const MyDrawer(),
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
          'iShop',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: TextDelegateHeaderWidget(title: "${widget.model.name}- Brands"), 
            pinned: true,),
          //1. write query
          //2  model
          //3. ui design widget

          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model.uid)
                .collection("brands")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot)
            {
              if(dataSnapshot.hasData) //if brands exists
              {
                //display brands
                return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index)
                    {
                      Brands brandsModel = Brands.fromDocument(
                        dataSnapshot.data.docs[index].data() as Map<String, dynamic>,
                      );

                      return BrandsUiDesignWidget(
                        model: brandsModel,
                        context: context,
                      );
                    },
                    itemCount: dataSnapshot.data.docs.length,
                );
              }
              else //if brands NOT exists
              {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No brands exists",
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
