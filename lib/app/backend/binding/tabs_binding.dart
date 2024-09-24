/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/categories_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TabsController(parser: Get.find()));
    Get.lazyPut(() => HomeController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => CategoriesController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => CartController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => OrderController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => AccountController(parser: Get.find()), fenix: true);
  }
}
