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

class WebPaymentsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  WebPaymentsParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> createOrder(var param) async {
    return await apiService.postPrivate(AppConstants.createOrder, param, sharedPreferencesManager.getString('token') ?? '');
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> verifyPurchase(var payKey) async {
    return await apiService.getPrivate(AppConstants.verifyRazorPayments + payKey, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> sendOrderMail(var param) async {
    return await apiService.postPrivate(AppConstants.sendMailOrder, param, sharedPreferencesManager.getString('token') ?? '');
  }

  String getName() {
    String firstName = sharedPreferencesManager.getString('firstName') ?? '';
    String lastName = sharedPreferencesManager.getString('lastName') ?? '';
    return '$firstName $lastName';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  String getSupportEmail() {
    return sharedPreferencesManager.getString('supportEmail') ?? '';
  }

  String getSupportPhone() {
    return sharedPreferencesManager.getString('supportPhone') ?? '';
  }
}
