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
import 'package:user/app/util/constant.dart';
import 'package:get/get.dart';

class ProductParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProductParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getSingleProduct(var id) async {
    return await apiService.postPublic(AppConstants.getSingleProduct, {'id': id});
  }

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' && sharedPreferencesManager.getString('uid') != null ? true : false;
  }

  Future<Response> getProfile() async {
    return await apiService.postPrivate(AppConstants.getProfileData, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> saveFavourite(var productIds) async {
    return await apiService.postPrivate(AppConstants.addToFav, {'uid': sharedPreferencesManager.getString('uid'), 'ids': productIds}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateFavourite(var productIds) async {
    return await apiService.postPrivate(AppConstants.updateFav, {'id': sharedPreferencesManager.getString('uid'), 'ids': productIds}, sharedPreferencesManager.getString('token') ?? '');
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
