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

class AddNewAddressParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddNewAddressParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> saveAddress(var location, var house, var landmark, var pincode, var lat, var lng, var title) async {
    var param = {'uid': sharedPreferencesManager.getString('uid'), 'address': location, 'lat': lat, 'lng': lng, 'title': title, 'house': house, 'landmark': landmark, 'pincode': pincode};
    return await apiService.postPrivate(AppConstants.saveAddress, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateAddress(var location, var house, var landmark, var pincode, var lat, var lng, var title, var id) async {
    var param = {'id': id, 'uid': sharedPreferencesManager.getString('uid'), 'address': location, 'lat': lat, 'lng': lng, 'title': title, 'house': house, 'landmark': landmark, 'pincode': pincode};
    return await apiService.postPrivate(AppConstants.updateAddress, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getLatLngFromAddress(String url) async {
    return await apiService.getExternal(url);
  }
}
