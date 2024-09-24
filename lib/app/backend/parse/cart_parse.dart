/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

import 'package:user/app/backend/api/api.dart';
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/util/constant.dart';

class CartParser {
  final ApiService apiService;
  final SharedPreferencesManager sharedPreferencesManager;

  CartParser({required this.apiService, required this.sharedPreferencesManager});

  void saveCart(List<ProductsModel> products) {
    List<String> carts = [];
    for (var cartModel in products) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferencesManager.putStringList('savedCart', carts);
  }

  List<ProductsModel> getCartProducts() {
    List<String>? carts = [];

    if (sharedPreferencesManager.isKeyExists('savedCart') ?? false) {
      carts = sharedPreferencesManager.getStringList('savedCart');
    }
    List<ProductsModel> cartList = <ProductsModel>[];
    carts?.forEach((element) {
      var data = jsonDecode(element);
      data['variations'] = data['variations'] != null && data['variations'] != '' ? jsonEncode(data['variations']) : null;
      cartList.add(ProductsModel.fromJson(data));
    });
    return cartList;
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ?? AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ?? AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ?? AppConstants.defaultCurrencySymbol;
  }

  int getMakeOrderStatus() {
    return sharedPreferencesManager.getInt('makeOrders') ?? AppConstants.defaultMakeingOrder;
  }

  double getMinOrder() {
    return sharedPreferencesManager.getDouble('minOrder') ?? 0.0;
  }

  double freeOrderPrice() {
    return sharedPreferencesManager.getDouble('free') ?? 0.0;
  }

  double taxOrderPrice() {
    return sharedPreferencesManager.getDouble('tax') ?? 0.0;
  }

  double shippingPrice() {
    return sharedPreferencesManager.getDouble('shippingPrice') ?? 0.0;
  }

  String getShippingMethod() {
    return sharedPreferencesManager.getString('shipping') ?? AppConstants.defaultShippingMethod;
  }

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' && sharedPreferencesManager.getString('uid') != null ? true : false;
  }
}
