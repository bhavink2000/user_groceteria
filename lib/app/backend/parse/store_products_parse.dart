/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class StoreProductsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  StoreProductsParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getProducts(var storeId, int limitNumber) async {
    limitNumber = limitNumber * 10;

    return await apiService.postPublic(AppConstants.getStoreProducts, {'id': storeId, 'limit': limitNumber});
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
}
