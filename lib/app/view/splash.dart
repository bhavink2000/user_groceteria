/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/app/controller/splash_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:user/app/util/toast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Get.find<SplashController>().initSharedData();
    _routing();
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  void _routing() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        if (Get.find<SplashController>().getLanguageCode() != '') {
          var locale = Get.find<SplashController>().getLanguageCode();
          Get.updateLocale(Locale(locale));
        } else {
          var locale = Get.find<SplashController>().defaultLanguage.languageCode != '' && Get.find<SplashController>().defaultLanguage.languageCode != ''
              ? Locale(Get.find<SplashController>().defaultLanguage.languageCode.toString())
              : const Locale('en');
          Get.updateLocale(locale);
        }

        if (Get.find<SplashController>().showIntro() == false) {
          Get.find<SplashController>().setIntro(true);
          Get.offNamed(AppRouter.getInitialRoute());
        } else {
          Get.find<SplashController>().setIntro(true);
          Get.offNamed(AppRouter.getLocationRoute());
        }
      } else {
        Get.toNamed(AppRouter.getErrorRoute());
      }
    });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      e;
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;

    if (isNotConnected) {
      showToast('No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: ThemeProvider.whiteColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/splash.gif', height: 200, width: 200),
                const CircularProgressIndicator(color: ThemeProvider.appColor),
                const SizedBox(height: 30),
                const Text('Powered By ${AppConstants.companyName}', style: TextStyle(fontFamily: 'bold'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
