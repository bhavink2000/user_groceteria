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

class StoresParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  StoresParser({required this.sharedPreferencesManager, required this.apiService});

  int getFindType() {
    return sharedPreferencesManager.getInt('findType') ?? 0;
  }

  Future<Response> getWithCity() async {
    return await apiService.postPublic(AppConstants.storesWithCity, {'id': sharedPreferencesManager.getString('cityId')});
  }

  Future<Response> getWithZipcode() async {
    return await apiService.postPublic(AppConstants.storeWithZipcode, {'zipcode': sharedPreferencesManager.getString('zipcode')});
  }

  Future<Response> getWithLatLng() async {
    return await apiService.postPublic(AppConstants.storesWithGeoLocation, {'lat': sharedPreferencesManager.getString('lat'), 'lng': sharedPreferencesManager.getString('lng')});
  }
}
