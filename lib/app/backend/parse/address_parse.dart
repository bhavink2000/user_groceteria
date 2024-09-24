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

class AddressParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddressParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getMyList() async {
    return await apiService.postPrivate(AppConstants.getMyAddress, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> deleteItem(var id) async {
    return await apiService.postPrivate(AppConstants.deleteAddress, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }
}
