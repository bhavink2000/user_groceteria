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

class SubCategoryParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SubCategoryParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getSubCategories(var id) async {
    return await apiService.postPublic(AppConstants.getSubCategories, {'id': id});
  }

  Future<Response> getProducts(int limitNumber, var cateId, var subId) async {
    limitNumber = limitNumber * 10;

    return await apiService.postPublic(AppConstants.getProductsWithSubCategory, {'storeIds': sharedPreferencesManager.getString('storeIds'), 'limit': limitNumber, 'id': cateId, 'sub': subId});
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
