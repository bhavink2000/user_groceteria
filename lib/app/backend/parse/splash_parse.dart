/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/util/constant.dart';

class SplashParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;
  SplashParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getAppSettings() async {
    Response response = await apiService.getPublic(AppConstants.appSettings);
    return response;
  }

  Future<bool> initAppSettings() {
    return Future.value(true);
  }

  bool showSplash() {
    return sharedPreferencesManager.getBool('intro');
  }

  void setIntro(bool intro) {
    sharedPreferencesManager.putBool('intro', intro);
  }

  void saveBasicInfo(var type, var currencyCode, var currencySide, var currencySymbol, var makeOrders, var smsName, var verifyWith, var userLogin, var supportEmail, var appName, var minOrder,
      var shipping, var shippingPrice, var tax, var free, var appLogo, var supportName, var supportId, var resetWith, var supportPhone) {
    sharedPreferencesManager.putInt('findType', type);
    sharedPreferencesManager.putString('currencyCode', currencyCode);
    sharedPreferencesManager.putString('currencySide', currencySide);
    sharedPreferencesManager.putString('currencySymbol', currencySymbol);
    sharedPreferencesManager.putInt('makeOrders', makeOrders);
    sharedPreferencesManager.putString('smsName', smsName);
    sharedPreferencesManager.putInt('user_verify_with', verifyWith);
    sharedPreferencesManager.putInt('userLogin', userLogin);
    sharedPreferencesManager.putString('supportEmail', supportEmail);
    sharedPreferencesManager.putString('appName', appName);
    sharedPreferencesManager.putDouble('minOrder', minOrder);
    sharedPreferencesManager.putString('shipping', shipping);
    sharedPreferencesManager.putDouble('shippingPrice', shippingPrice);
    sharedPreferencesManager.putDouble('tax', tax);
    sharedPreferencesManager.putDouble('free', free);
    sharedPreferencesManager.putString('appLogo', appLogo);
    sharedPreferencesManager.putInt('supportUID', supportId);
    sharedPreferencesManager.putString('supportName', supportName);
    sharedPreferencesManager.putInt('resetWith', resetWith);
    sharedPreferencesManager.putString('supportPhone', supportPhone);
  }

  String getLanguagesCode() {
    return sharedPreferencesManager.getString('language') ?? 'en';
  }

  void saveDeviceToken(String token) {
    sharedPreferencesManager.putString('fcm_token', token);
  }
}
