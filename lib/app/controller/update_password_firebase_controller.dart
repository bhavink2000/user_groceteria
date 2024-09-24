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
import 'package:user/app/backend/parse/update_password_firebase_parse.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/toast.dart';

class UpdatePasswordFirebaseController extends GetxController implements GetxService {
  final UpdatePasswordFirebaseParser parser;
  String countryCode = '';
  String phoneNumber = '';
  String token = '';

  RxBool isLogin = false.obs;

  final passwordReset = TextEditingController();
  final confirmPasswordReset = TextEditingController();

  RxBool passwordVisible = false.obs;

  UpdatePasswordFirebaseController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    countryCode = Get.arguments[0];
    phoneNumber = Get.arguments[1];
    token = Get.arguments[2];
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
    update();
  }

  Future<void> updatePasswordWitPhone() async {
    if (passwordReset.text == '' || confirmPasswordReset.text == '') {
      showToast('All fields are required');
      return;
    }

    if (passwordReset.text != confirmPasswordReset.text) {
      showToast('Password mismatch');
      return;
    }

    isLogin.value = !isLogin.value;
    update();
    var param = {'country_code': countryCode, 'mobile': phoneNumber, 'password': passwordReset.text};
    Response response = await parser.updatePasswordWithPhone(param, token);
    debugPrint(response.bodyString.toString());
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['data'] == true) {
        successToast('Password Updated');
        Get.offNamed(AppRouter.getLoginRoute());
      } else {
        if (myMap['data'] != '' && myMap['data'] == false && myMap['status'] == 500) {
          showToast(myMap['message']);
        } else {
          showToast('Something went wrong while signup');
        }
      }
      update();
    } else if (response.statusCode == 401) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 500) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }
}
