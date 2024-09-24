/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/redeem_model.dart';
import 'package:user/app/backend/parse/firebase_register_parse.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

class FirebaseRegisterController extends GetxController implements GetxService {
  final FirebaseRegisterParser parser;

  String countryCode = '';
  String phoneNumber = '';
  String apiURL = '';
  bool haveClicked = false;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String referralCode = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  FirebaseRegisterController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    apiURL = parser.apiService.appBaseUrl;
    countryCode = Get.arguments[0];
    phoneNumber = Get.arguments[1];
    email = Get.arguments[2];
    firstName = Get.arguments[3];
    lastName = Get.arguments[4];
    password = Get.arguments[5];
    referralCode = Get.arguments[6];
  }

  Future<void> onLogin(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    createAccount(context);
    showDialog(
        context: context,
        barrierColor: ThemeProvider.appColor,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(0.0),
            content: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Please wait'.tr,
                style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }

  Future<void> createAccount(context) async {
    var param = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'mobile': phoneNumber,
      'country_code': countryCode,
      'password': password,
      'fcm_token': parser.getFcmToken(),
      'type': '1',
      'lat': '0',
      'lng': '0',
      'cover': 'NA',
      'status': 1,
      'others': 'NA',
      'date': '',
      'stripe_key': '',
      'referral_code': referralCode
    };
    Response response = await parser.registerPost(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '') {
        parser.saveInfo(myMap['token'].toString(), myMap['user']['id'].toString(), firstName, lastName, email, 'NA', myMap['user']['mobile'].toString());
        if (referralCode != '') {
          redeemCode(context);
        }
        Get.delete<HomeController>(force: true);
        Get.delete<AccountController>(force: true);
        Get.delete<OrderController>(force: true);
        Get.offNamed(AppRouter.getTabsRoute());
      } else {
        showToast('Something went wrong while signup'.tr);
      }
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == false) {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  Future<void> redeemCode(context) async {
    Response response = await parser.redeemReferralCode(referralCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['data']['data'] != '') {
        dynamic body = myMap["data"];
        RedeemModel datas = RedeemModel.fromJson(body);

        var text = '';
        var amount = currencySide == 'left' ? currencySymbol + datas.amount.toString() : datas.amount.toString() + currencySymbol;
        if (datas.whoReceived == 1) {
          text = 'Congratulations your friend have received the '.tr + amount + ' on wallet'.tr;
        } else if (datas.whoReceived == 2) {
          text = 'Congratulations you have received the '.tr + amount + ' on wallet'.tr;
        } else if (datas.whoReceived == 3) {
          text = 'Congratulations you & your friend have received the '.tr + amount + ' on wallet'.tr;
        }
        openSuccessModal(context, text);
      } else {
        showToast('Something went wrong while signup'.tr);
      }
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == false) {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void openSuccessModal(context, String text) {
    HapticFeedback.lightImpact();

    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        title: Text('Alert!'.tr),
        content: Text(text),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Okay'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')))],
      ),
    );
  }
}
