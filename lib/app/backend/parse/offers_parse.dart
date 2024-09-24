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

class OfferParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OfferParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getAllOffers() async {
    return await apiService.postPublic(AppConstants.getOffers, {'id': sharedPreferencesManager.getString('cityId')});
  }
}
