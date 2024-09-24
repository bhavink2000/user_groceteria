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

class LocationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LocationParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getActiveCities() async {
    return await apiService.getPublic(AppConstants.activeCities);
  }

  void saveCity(var cityId, var cityName) {
    sharedPreferencesManager.putBool('location', true);
    sharedPreferencesManager.putString('cityId', cityId);
    sharedPreferencesManager.putString('cityName', cityName);
  }

  void saveZipcode(var zipcode) {
    sharedPreferencesManager.putBool('location', true);
    sharedPreferencesManager.putString('zipcode', zipcode);
  }

  void saveLatLng(var lat, var lng, var address) {
    sharedPreferencesManager.putBool('location', true);
    sharedPreferencesManager.putString('lat', lat);
    sharedPreferencesManager.putString('lng', lng);
    sharedPreferencesManager.putString('address', address);
  }

  int getFindType() {
    return sharedPreferencesManager.getInt('findType') ?? 0;
  }
}
