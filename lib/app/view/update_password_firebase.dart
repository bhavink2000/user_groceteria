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
import 'package:user/app/controller/update_password_firebase_controller.dart';
import 'package:user/app/util/theme.dart';

class UpdatePasswordFirebaseScreen extends StatefulWidget {
  const UpdatePasswordFirebaseScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordFirebaseScreen> createState() => _UpdatePasswordFirebaseScreenState();
}

class _UpdatePasswordFirebaseScreenState extends State<UpdatePasswordFirebaseScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdatePasswordFirebaseController>(
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
              child: Container(
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
              ),
            ),
          ),
        );
      },
    );
  }
}
