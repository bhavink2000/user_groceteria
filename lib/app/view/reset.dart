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
import 'package:get/get.dart';
import 'package:user/app/controller/reset_password_controller.dart';
import 'package:user/app/util/theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.appColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text('Reset Password'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: AbsorbPointer(
            absorbing: value.isLogin.value == false ? false : true,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  if (value.resetWith == 0 && value.divNumber == 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text('Reset Password'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 18, fontFamily: 'bold')),
                                Text('Please enter your credentials'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                                const SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                  child: TextField(
                                    controller: value.emailReset,
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
                                  height: 45,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                  child: ElevatedButton(
                                    onPressed: () => value.sendMail(),
                                    style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                    child: value.isLogin.value == true
                                        ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                        : Text('Send OTP'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (value.resetWith == 0 && value.divNumber == 2)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text('Reset Password'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 18, fontFamily: 'bold')),
                                Text('Please enter your credentials'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                                const SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                  child: TextField(
                                    controller: value.passwordReset,
                                    textInputAction: TextInputAction.done,
                                    obscureText: value.passwordVisible.value == true ? false : true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      labelText: 'New Password'.tr,
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
                                    controller: value.confirmPasswordReset,
                                    textInputAction: TextInputAction.done,
                                    obscureText: value.passwordVisible.value == true ? false : true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      labelText: 'Confirm Password'.tr,
                                      suffixIcon: InkWell(
                                        onTap: () => value.togglePassword(),
                                        child: Icon(value.passwordVisible.value == false ? Icons.visibility : Icons.visibility_off, color: ThemeProvider.appColor),
                                      ),
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                  child: ElevatedButton(
                                    onPressed: () => value.updatePassword(),
                                    style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                    child: value.isLogin.value == true
                                        ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                        : Text('Update Password'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (value.resetWith == 1 && value.divNumber == 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text('Reset Password'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 18, fontFamily: 'bold')),
                                Text('Please enter your credentials'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
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
                                          controller: value.phoneReset,
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
                                    onPressed: () => value.sendSMS(),
                                    style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                    child: value.isLogin.value == true
                                        ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                        : Text('Send OTP'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (value.resetWith == 1 && value.divNumber == 2)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text('Reset Password'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 18, fontFamily: 'bold')),
                                Text('Please enter your credentials'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14, fontFamily: 'regular')),
                                const SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                  child: TextField(
                                    controller: value.passwordReset,
                                    textInputAction: TextInputAction.done,
                                    obscureText: value.passwordVisible.value == true ? false : true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      labelText: 'New Password'.tr,
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
                                    controller: value.confirmPasswordReset,
                                    textInputAction: TextInputAction.done,
                                    obscureText: value.passwordVisible.value == true ? false : true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      labelText: 'Confirm Password'.tr,
                                      suffixIcon: InkWell(
                                        onTap: () => value.togglePassword(),
                                        child: Icon(value.passwordVisible.value == false ? Icons.visibility : Icons.visibility_off, color: ThemeProvider.appColor),
                                      ),
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                  child: ElevatedButton(
                                    onPressed: () => value.updatePasswordWitPhone(),
                                    style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                    child: value.isLogin.value == true
                                        ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                        : Text('Update Password'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
