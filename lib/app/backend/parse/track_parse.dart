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

class TrackParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  TrackParser({required this.sharedPreferencesManager, required this.apiService});

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ?? AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ?? AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ?? AppConstants.defaultCurrencySymbol;
  }

  Future<Response> getDriverInfo(var id) async {
    return await apiService.postPrivate(AppConstants.getDriverInfo, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }
}
