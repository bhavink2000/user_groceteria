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
import 'package:user/app/backend/parse/login_parse.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class LoginController extends GetxController implements GetxService {
  final LoginParser parser;
  final emailLogin = TextEditingController();
  final phoneLogin = TextEditingController();
  final passwordLogin = TextEditingController();
  String countryCode = '+91';
  RxBool passwordVisible = false.obs;
  RxBool isLogin = false.obs;
  bool isWebViewLoading = true;
  String smsName = AppConstants.defaultSMSGateway;
  int smsId = 1;
  String otpCode = '';
  int loginVersion = AppConstants.userLogin;
  LoginController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    smsName = parser.getSMSName();
    loginVersion = parser.getUserLoginMethod();
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
    update();
  }

  void updateCountryCode(String code) {
    countryCode = code;
    update();
  }

  Future<void> login() async {
    if (emailLogin.text == '' || passwordLogin.text == '') {
      showToast('All fields are required');
      return;
    }
    if (!GetUtils.isEmail(emailLogin.text)) {
      showToast('Email is not valid');
      return;
    }
    isLogin.value = !isLogin.value;
    update();

    var param = {'email': emailLogin.text, 'password': passwordLogin.text};
    Response response = await parser.loginPost(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '' && myMap['user']['type'] == 'user') {
        if (myMap['user']['status'] == 1) {
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
          showToast('Your account is suspended');
        }
      } else {
        showToast('Something went wrong while signup');
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

  Future<void> loginWithPhonePassword() async {
    if (phoneLogin.text == '' || passwordLogin.text == '') {
      showToast('All fields are required');
      return;
    }
    isLogin.value = !isLogin.value;
    update();

    var param = {'country_code': countryCode, 'mobile': phoneLogin.text, 'password': passwordLogin.text};
    Response response = await parser.loginWithPhonePasswordPost(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '' && myMap['user']['type'] == 'user') {
        if (myMap['user']['status'] == 1) {
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
          showToast('Your account is suspended');
        }
      } else {
        showToast('Something went wrong while signup');
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

  Future<void> loginWithPhoneOTP(context) async {
    if (phoneLogin.text == '') {
      showToast('Phone Number is required');
      return;
    }

    if (smsName == '2') {
      isLogin.value = !isLogin.value;
      update();

      var param = {'country_code': countryCode, 'mobile': phoneLogin.text};
      Response response = await parser.verifyPhoneWithFirebase(param);
      if (response.statusCode == 200) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          FocusManager.instance.primaryFocus?.unfocus();
          Get.toNamed(AppRouter.getFirebaseVerificationRoutes(), arguments: [countryCode, phoneLogin.text]);
        } else {
          showToast('Something went wrong while signup');
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
    } else {
      isLogin.value = !isLogin.value;
      update();

      var param = {'country_code': countryCode, 'mobile': phoneLogin.text};
      Response response = await parser.verifyPhone(param);
      if (response.statusCode == 200) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          smsId = myMap['otp_id'];
          FocusManager.instance.primaryFocus?.unfocus();
          openOTPModal(context, countryCode.toString() + phoneLogin.text.toString());
        } else {
          showToast('Something went wrong while signup');
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

  void openOTPModal(context, String text) {
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          title: Text("Verification".tr, textAlign: TextAlign.center),
          content: AbsorbPointer(
            absorbing: isLogin.value == false ? false : true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    Text('We have sent verification code on'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'medium')),
                    Text(text, style: const TextStyle(fontSize: 12, fontFamily: 'medium')),
                    const SizedBox(height: 10),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: ThemeProvider.greyColor,
                      keyboardType: TextInputType.number,
                      focusedBorderColor: ThemeProvider.appColor,
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        otpCode = verificationCode;
                        onOtpSubmit(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            AbsorbPointer(
              absorbing: isLogin.value == false ? false : true,
              child: Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                child: ElevatedButton(
                  onPressed: () async {
                    if (otpCode != '' && otpCode.length >= 6) {
                      onOtpSubmit(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                  child: isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Verify'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> onOtpSubmit(context) async {
    isLogin.value = !isLogin.value;
    update();
    var param = {'id': smsId, 'otp': otpCode};
    Response response = await parser.verifyOTP(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['success'] == true) {
        Navigator.of(context).pop(true);
        loginWithPhoneToken();
      } else {
        showToast('Something went wrong while signup');
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
  }

  Future<void> loginWithPhoneToken() async {
    isLogin.value = !isLogin.value;
    update();
    var param = {'country_code': countryCode, 'mobile': phoneLogin.text};
    Response response = await parser.loginWithPhoneToken(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '' && myMap['user']['type'] == 'user') {
        if (myMap['user']['status'] == 1) {
          parser.saveInfo(myMap['token'].toString(), myMap['user']['id'].toString(), myMap['user']['first_name'].toString(), myMap['user']['last_name'].toString(), myMap['user']['email'].toString(),
              myMap['user']['cover'].toString(), myMap['user']['mobile'].toString());
          var param = {'id': myMap['user']['id'].toString(), 'fcm_token': parser.getFcmToken()};
          await parser.updateProfile(param);
          Get.delete<HomeController>(force: true);
          Get.delete<AccountController>(force: true);
          Get.delete<LoginController>(force: true);
          Get.delete<OrderController>(force: true);
          Get.offNamed(AppRouter.getTabsRoute());
        } else {
          showToast('Your account is suspended');
        }
      } else {
        showToast('Something went wrong while signup');
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
  }
}
