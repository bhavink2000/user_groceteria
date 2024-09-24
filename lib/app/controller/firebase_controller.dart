/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/parse/firebase_parse.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/login_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

class FirebaseController extends GetxController implements GetxService {
  final FirebaseParser parser;
  String countryCode = '';
  String phoneNumber = '';
  String apiURL = '';
  bool haveClicked = false;
  FirebaseController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    apiURL = parser.apiService.appBaseUrl;
    countryCode = Get.arguments[0];
    phoneNumber = Get.arguments[1];
  }

  Future<void> onLogin(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loginWithPhoneToken(context);
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          content: Padding(
            padding: const EdgeInsets.all(5),
            child: Text('Please wait'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 14), textAlign: TextAlign.center),
          ),
        );
      },
    );
  }

  Future<void> loginWithPhoneToken(context) async {
    update();
    var param = {'country_code': countryCode, 'mobile': phoneNumber};
    Response response = await parser.loginWithPhoneToken(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '' && myMap['user']['type'] == 'user') {
        if (myMap['user']['status'] == 1) {
          Navigator.of(context).pop(true);
          parser.saveInfo(myMap['token'].toString(), myMap['user']['id'].toString(), myMap['user']['first_name'].toString(), myMap['user']['last_name'].toString(), myMap['user']['email'].toString(),
              myMap['user']['cover'].toString(), myMap['user']['mobile'].toString());
          var param = {'id': myMap['user']['id'].toString(), 'fcm_token': parser.getFcmToken()};
          await parser.updateProfile(param);
          Get.delete<HomeController>(force: true);
          Get.delete<LoginController>(force: true);
          Get.delete<AccountController>(force: true);
          Get.delete<OrderController>(force: true);
          Get.offNamed(AppRouter.getTabsRoute());
        } else {
          showToast('Your account is suspended'.tr);
        }
      } else {
        showToast('Something went wrong while signup'.tr);
      }
      update();
    } else if (response.statusCode == 401) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }
}
