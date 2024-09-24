/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/controller/stores_controller.dart';

class StoresBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => StoresController(parser: Get.find()));
  }
}
