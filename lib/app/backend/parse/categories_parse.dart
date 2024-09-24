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

class CategoriesParser {
  final ApiService apiService;
  final SharedPreferencesManager sharedPreferencesManager;

  CategoriesParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getCategories() async {
    return await apiService.getPublic(AppConstants.getCategories);
  }

  String getStoreIds() {
    return sharedPreferencesManager.getString('storeIds') ?? '';
  }
}
