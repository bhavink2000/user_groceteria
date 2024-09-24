/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/parse/account_parse.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/util/theme.dart';

class AccountController extends GetxController implements GetxService {
  final AccountParser parser;
  bool haveAccount = false;
  String name = '';
  String email = '';
  String cover = '';
  AccountController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    haveAccount = parser.haveLoggedIn();
    name = parser.getName();
    email = parser.getEmail();
    cover = parser.getCover();
  }

  void cleanData() {
    haveAccount = false;
    update();
  }

  void changeInfo() {
    name = parser.getName();
    email = parser.getEmail();
    cover = parser.getCover();
    update();
  }

  Future<void> logout(context) async {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const SizedBox(width: 30),
          const CircularProgressIndicator(color: ThemeProvider.appColor),
          const SizedBox(width: 30),
          SizedBox(child: Text("Please wait".tr, style: const TextStyle(fontFamily: 'bold'))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    Response response = await parser.logout();
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
      parser.clearAccount();
      Get.find<OrderController>().getOrder();
      haveAccount = false;
      update();
    } else {
      Navigator.of(context).pop(true);
      ApiChecker.checkApi(response);
    }
    update();
  }
}
