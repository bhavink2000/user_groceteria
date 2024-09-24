/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:user/app/controller/login_controller.dart';
import 'package:user/app/controller/reset_password_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.appColor,
          body: AbsorbPointer(
            absorbing: value.isLogin.value == false ? false : true,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  if (value.loginVersion == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                Text('Please login to your acount'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                                const SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                  child: TextField(
                                    controller: value.emailLogin,
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
                                    controller: value.passwordLogin,
                                    textInputAction: TextInputAction.done,
                                    obscureText: value.passwordVisible.value == true ? false : true,
                                    decoration: InputDecoration(
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
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.delete<ResetPasswordController>(force: true);
                                      Get.toNamed(AppRouter.getResetPasswordRoutes());
                                    },
                                    child: Text('Forgot Password?'.tr, textAlign: TextAlign.right, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 14, fontFamily: 'regular')),
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                  child: ElevatedButton(
                                    onPressed: () => value.login(),
                                    style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                    child: value.isLogin.value == true
                                        ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                        : Text('Sign In'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account?".tr,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                children: <TextSpan>[TextSpan(text: ' Sign Up'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14))],
                              ),
                            ),
                            onTap: () => Get.toNamed(AppRouter.getRegisterRoute()),
                          ),
                        ],
                      ),
                    ),
                  if (value.loginVersion == 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                Text('Please login to your acount'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                                const SizedBox(height: 30),
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
                                          controller: value.phoneLogin,
                                          textInputAction: TextInputAction.done,
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
                                    controller: value.passwordLogin,
                                    textInputAction: TextInputAction.done,
                                    obscureText: value.passwordVisible.value == true ? false : true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      suffixIcon: InkWell(
                                        onTap: () => value.togglePassword(),
                                        child: Icon(value.passwordVisible.value == false ? Icons.visibility : Icons.visibility_off, color: ThemeProvider.appColor),
                                      ),
                                      labelText: 'Password'.tr,
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text('Forgot Password?'.tr, textAlign: TextAlign.right, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 14, fontFamily: 'regular')),
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                  child: ElevatedButton(
                                    onPressed: () => value.loginWithPhonePassword(),
                                    style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                    child: value.isLogin.value == true
                                        ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                        : Text('Sign In'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account?".tr,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                children: <TextSpan>[TextSpan(text: ' Sign Up'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14))],
                              ),
                            ),
                            onTap: () => Get.toNamed(AppRouter.getRegisterRoute()),
                          ),
                        ],
                      ),
                    ),
                  if (value.loginVersion == 2)
                    AbsorbPointer(
                      absorbing: value.isLogin.value == false ? false : true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                  Text('Please login to your acount'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: CountryCodePicker(
                                          onChanged: (e) => e,
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
                                            controller: value.phoneLogin,
                                            textInputAction: TextInputAction.done,
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
                                    height: 45,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                    child: ElevatedButton(
                                      onPressed: () => value.loginWithPhoneOTP(context),
                                      style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                      child: value.isLogin.value == true
                                          ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                          : Text('Send OTP'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account?".tr,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  children: <TextSpan>[TextSpan(text: ' Sign Up'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14))],
                                ),
                              ),
                              onTap: () => Get.toNamed(AppRouter.getRegisterRoute()),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
