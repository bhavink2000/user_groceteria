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
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/redeem_model.dart';
import 'package:user/app/backend/parse/register_parse.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

class RegisterController extends GetxController implements GetxService {
  final RegisterParser parser;
  final firstNameRegister = TextEditingController();
  final lastNameRegister = TextEditingController();
  final emailRegister = TextEditingController();
  final passwordRegister = TextEditingController();
  final mobileRegister = TextEditingController();
  final referralCode = TextEditingController();
  String countryCode = '+91';
  RxBool passwordVisible = false.obs;
  RxBool isLogin = false.obs;
  String smsName = AppConstants.defaultSMSGateway;
  int verificationMethod = AppConstants.defaultVerificationForSignup;
  int smsId = 1;
  String otpCode = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  RegisterController({required this.parser});

  @override
  void onInit() async {
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    super.onInit();
    smsName = parser.getSMSName();
    verificationMethod = parser.getVerificationMethod();
  }

  void updateCountryCode(String code) {
    countryCode = code;
    update();
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
    update();
  }

  Future<void> register(context) async {
    if (firstNameRegister.text == '' || emailRegister.text == '' || passwordRegister.text == '' || mobileRegister.text == '' || lastNameRegister.text == '') {
      showToast('All fields are required');
      return;
    }

    if (!GetUtils.isEmail(emailRegister.text)) {
      showToast('Email is not valid');
      return;
    }

    isLogin.value = !isLogin.value;
    update();
    if (verificationMethod == 0) {
      var param = {
        'email': emailRegister.text,
        'subject': 'Verification'.tr,
        'header_text': 'Use this code for verification'.tr,
        'thank_you_text': "Don't share this otp to anybody else".tr,
        'mediaURL': '${Environments.apiBaseURL}storage/images/',
        'country_code': countryCode,
        'mobile': mobileRegister.text
      };
      Response response = await parser.sendVerificationMail(param);
      if (response.statusCode == 200) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          smsId = myMap['otp_id'];
          FocusManager.instance.primaryFocus?.unfocus();
          openOTPModal(context, emailRegister.text);
        } else {
          if (myMap['data'] != '' && myMap['data'] == false && myMap['status'] == 500) {
            showToast(myMap['message']);
          } else {
            showToast('Something went wrong while signup');
          }
        }
        update();
      } else if (response.statusCode == 500) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['success'] == false) {
          showToast(myMap['message']);
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
      if (smsName == '2') {
        var param = {'email': emailRegister.text, 'country_code': countryCode, 'mobile': mobileRegister.text};
        Response response = await parser.verifyMobileForeFirebase(param);
        if (response.statusCode == 200) {
          isLogin.value = !isLogin.value;
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
          if (myMap['data'] != '' && myMap['data'] == true) {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.toNamed(AppRouter.getFirebaseRegisterVerificationRoutes(),
                arguments: [countryCode, mobileRegister.text, emailRegister.text, firstNameRegister.text, lastNameRegister.text, passwordRegister.text, referralCode.text]);
          } else {
            if (myMap['data'] != '' && myMap['data'] == false && myMap['status'] == 500) {
              showToast(myMap['message']);
            } else {
              showToast('Something went wrong while signup');
            }
          }
          update();
        } else if (response.statusCode == 500) {
          isLogin.value = !isLogin.value;
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
          if (myMap['success'] == false) {
            showToast(myMap['message']);
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
        var param = {'country_code': countryCode, 'mobile': mobileRegister.text, 'email': emailRegister.text};
        Response response = await parser.sendRegisterOTP(param);
        if (response.statusCode == 200) {
          isLogin.value = !isLogin.value;
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
          if (myMap['data'] != '' && myMap['data'] == true) {
            smsId = myMap['otp_id'];
            FocusManager.instance.primaryFocus?.unfocus();
            openOTPModal(context, countryCode.toString() + mobileRegister.text.toString());
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
        createAccount(context);
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

  void createAccount(context) async {
    var param = {
      'email': emailRegister.text,
      'first_name': firstNameRegister.text,
      'last_name': lastNameRegister.text,
      'mobile': mobileRegister.text,
      'country_code': countryCode,
      'password': passwordRegister.text,
      'fcm_token': parser.getFcmToken(),
      'type': '1',
      'lat': '0',
      'lng': '0',
      'cover': 'NA',
      'status': 1,
      'others': 'NA',
      'date': '',
      'stripe_key': '',
      'referral_code': referralCode.text
    };
    Response response = await parser.registerPost(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '') {
        parser.saveInfo(myMap['token'].toString(), myMap['user']['id'].toString(), firstNameRegister.text, lastNameRegister.text, emailRegister.text, 'NA', mobileRegister.text);
        if (referralCode.text != '') {
          redeemCode(context);
        }
        Get.delete<HomeController>(force: true);
        Get.delete<AccountController>(force: true);
        Get.delete<OrderController>(force: true);
        Get.offNamed(AppRouter.getTabsRoute());
      } else {
        showToast('Something went wrong while signup');
      }
      update();
    } else if (response.statusCode == 500) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == false) {
        showToast(myMap['message']);
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

  Future<void> redeemCode(context) async {
    Response response = await parser.redeemReferralCode(referralCode.text);
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
        showToast('Something went wrong while signup');
      }
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == false) {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong');
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
