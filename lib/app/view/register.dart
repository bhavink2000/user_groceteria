/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:user/app/controller/pages_controller.dart';
import 'package:user/app/controller/register_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (value) {
        return AbsorbPointer(
          absorbing: value.isLogin.value == false ? false : true,
          child: Scaffold(
            backgroundColor: ThemeProvider.appColor,
            body: SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    const Image(image: AssetImage('assets/images/logo.png'), width: 45, height: 45),
                    const SizedBox(height: 10),
                    const Text(AppConstants.appName, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'bold')),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('Welcome'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 18, fontFamily: 'bold')),
                          Text('Please register to your acount'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                          const SizedBox(height: 30),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: TextField(
                              controller: value.emailRegister,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'Email Address'.tr,
                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: TextField(
                              controller: value.passwordRegister,
                              textInputAction: TextInputAction.next,
                              obscureText: value.passwordVisible.value == true ? false : true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'Password'.tr,
                                suffixIcon: InkWell(
                                  onTap: () => value.togglePassword(),
                                  child: Icon(value.passwordVisible.value == false ? Icons.visibility : Icons.visibility_off, color: ThemeProvider.appColor),
                                ),
                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: TextField(
                              controller: value.firstNameRegister,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'First Name'.tr,
                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: TextField(
                              controller: value.lastNameRegister,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'Last Name'.tr,
                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: CountryCodePicker(
                                  onChanged: (e) => value.updateCountryCode(e.dialCode.toString()),
                                  initialSelection: 'IN',
                                  favorite: const ['+91', 'IN'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  showFlag: false,
                                  showFlagDialog: true,
                                  textStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                  child: TextField(
                                    controller: value.mobileRegister,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      labelText: 'Phone Number'.tr,
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: TextField(
                              controller: value.referralCode,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                labelText: 'Referral Code (Optional)'.tr,
                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                  text: 'By continuing, you agree to our '.tr,
                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Terms of Service'.tr,
                                      style: const TextStyle(fontSize: 10, color: ThemeProvider.blackColor, fontFamily: 'bold', decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.delete<AppPagesController>(force: true);
                                          Get.toNamed(AppRouter.getAppPagesRoute(), arguments: ['Terms & Conditions', '3'], preventDuplicates: false);
                                        },
                                    ),
                                    TextSpan(
                                      text: ' and '.tr,
                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Privacy Policy'.tr,
                                          style: const TextStyle(fontSize: 10, color: ThemeProvider.blackColor, fontFamily: 'bold', decoration: TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.delete<AppPagesController>(force: true);
                                              Get.toNamed(AppRouter.getAppPagesRoute(), arguments: ['Privacy Policy', '2'], preventDuplicates: false);
                                            },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                            child: ElevatedButton(
                              onPressed: () => value.register(context),
                              style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                              child: value.isLogin.value == true
                                  ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                  : Text('Sign Up'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account?'.tr,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          children: <TextSpan>[TextSpan(text: ' Sign In'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14))],
                        ),
                      ),
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
