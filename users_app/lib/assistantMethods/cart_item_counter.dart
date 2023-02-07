import 'package:flutter/cupertino.dart';
import 'package:users_app/global/global.dart';

class CartItemCounter extends ChangeNotifier{
   int _cartListItemCounter =  sharedPreferences!.getStringList('userCart')!.length;

  int get count => _cartListItemCounter;

  Future<void> showCartListItemsNumber() async {
    _cartListItemCounter = sharedPreferences!.getStringList('userCart')!.length;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}