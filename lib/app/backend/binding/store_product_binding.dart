/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/controller/store_products_controller.dart';

class StoreProductsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => StoreProductsController(parser: Get.find()));
  }
}
