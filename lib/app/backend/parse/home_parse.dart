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

class HomeParser {
  final ApiService apiService;
  final SharedPreferencesManager sharedPreferencesManager;

  HomeParser({required this.apiService, required this.sharedPreferencesManager});

  int getFindType() {
    return sharedPreferencesManager.getInt('findType') ?? 0;
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

  Future<Response> getWithCity() async {
    return await apiService.postPublic(AppConstants.withCity, {'id': sharedPreferencesManager.getString('cityId')});
  }

  Future<Response> getWithZipcode() async {
    return await apiService.postPublic(AppConstants.withZipcode, {'zipcode': sharedPreferencesManager.getString('zipcode')});
  }

  Future<Response> getWithLatLng() async {
    return await apiService.postPublic(AppConstants.withGeoLocation, {'lat': sharedPreferencesManager.getString('lat'), 'lng': sharedPreferencesManager.getString('lng')});
  }

  void saveCity(var cityId) {
    sharedPreferencesManager.putString('cityId', cityId);
  }

  void saveStoreIds(var storeIds) {
    sharedPreferencesManager.putString('storeIds', storeIds);
  }

  void removeStoreIds() {
    sharedPreferencesManager.clearKey('storeIds');
  }

  String getCityName() {
    return sharedPreferencesManager.getString('cityName') ?? '';
  }

  String getAddressName() {
    return sharedPreferencesManager.getString('address') ?? '';
  }

  String getZipcodeName() {
    return sharedPreferencesManager.getString('zipcode') ?? '';
  }
}
