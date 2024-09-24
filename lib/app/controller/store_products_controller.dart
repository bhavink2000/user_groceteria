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
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/backend/parse/store_products_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/inbox_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';

class StoreProductsController extends GetxController implements GetxService {
  final StoreProductsParser parser;
  String storeName = '';
  int storeId = 0;
  var lastLimit = 1.obs;
  bool loadMore = false;
  bool apiCalled = false;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  int makeOrders = AppConstants.defaultMakeingOrder;
  List<ProductsModel> _topProducts = <ProductsModel>[];
  List<ProductsModel> get topProducts => _topProducts;
  String selectedFilter = '';
  StoreProductsController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    makeOrders = parser.getMakeOrderStatus();
    storeName = Get.arguments[1];
    storeId = Get.arguments[0];
    getProducts();
  }

  Future<void> getProducts() async {
    Response response = await parser.getProducts(storeId, lastLimit.value);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _topProducts = [];
      body.forEach((data) {
        ProductsModel datas = ProductsModel.fromJson(data);
        _topProducts.add(datas);
      });
      for (var element in _topProducts) {
        if (Get.find<CartController>().checkProductInCart(element.id ?? 0)) {
          element.quantity = Get.find<CartController>().getQuantity(element.id ?? 0);
          element.variant = Get.find<CartController>().getVariant(element.id ?? 1);
        } else {
          element.quantity = 0;
          element.variant = 1;
        }
      }
      loadMore = false;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void filterProducts(context, String kind) {
    if (kind == 'rating') {
      selectedFilter = 'Popularity'.tr;
      _topProducts.sort((a, b) => b.rating!.compareTo(a.rating!));
    } else if (kind == 'l-h') {
      selectedFilter = 'Price L-H'.tr;
      _topProducts.sort((a, b) => a.originalPrice!.compareTo(b.originalPrice!));
    } else if (kind == 'h-l') {
      selectedFilter = 'Price H-L'.tr;
      _topProducts.sort((a, b) => b.originalPrice!.compareTo(a.originalPrice!));
    } else if (kind == 'a-z') {
      selectedFilter = 'A-Z'.tr;
      _topProducts.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
    } else if (kind == 'z-a') {
      selectedFilter = 'Z-A'.tr;
      _topProducts.sort((a, b) => b.name.toString().compareTo(a.name.toString()));
    } else if (kind == 'off') {
      selectedFilter = '% Off'.tr;
      _topProducts.sort((a, b) => b.discount!.compareTo(a.discount!));
    }
    Navigator.of(context).pop(true);
    update();
  }

  void increment() {
    loadMore = true;
    lastLimit = lastLimit++;
    update();
    getProducts();
  }

  Future<void> updateAddons(int index, int variantIndex) async {
    _topProducts[index].variant = variantIndex;
    if (Get.find<CartController>().checkProductInCart(topProducts[index].id ?? 0)) {
      Get.find<CartController>().updateProductAddons(topProducts[index], variantIndex);
    }
    update();
  }

  Future<void> addPopular(int index) async {
    if (makeOrders == 0) {
      _topProducts[index].quantity = 1;
      Get.find<CartController>().addItem(topProducts[index]);
      Get.find<TabsController>().updateCartValue();
      Get.find<HomeController>().checkProductsCart();
      update();
    } else if (makeOrders == 1) {
      if (Get.find<CartController>().savedInCart.isEmpty) {
        _topProducts[index].quantity = 1;
        Get.find<CartController>().addItem(topProducts[index]);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
        update();
      } else if (Get.find<CartController>().savedInCart.isNotEmpty) {
        if (Get.find<CartController>().checkSameStore(topProducts[index].storeId!)) {
          clearCartAlert().then((value) {
            if (value == true) {
              for (var element in _topProducts) {
                element.quantity = 0;
                element.variant = 1;
              }
              Get.find<CartController>().clearCart();
              update();
            }
          }).catchError((error) {
            showToast(error);
          });
        } else {
          _topProducts[index].quantity = 1;
          Get.find<CartController>().addItem(topProducts[index]);
          Get.find<TabsController>().updateCartValue();
          Get.find<HomeController>().checkProductsCart();
          update();
        }
      }
    }
  }

  Future<void> updatePopularProducts(int index, var kind) async {
    if (kind == 'add') {
      _topProducts[index].quantity = _topProducts[index].quantity + 1;
      Get.find<CartController>().addQuantity(_topProducts[index]);
      Get.find<HomeController>().checkProductsCart();
    } else {
      if (_topProducts[index].quantity == 1) {
        _topProducts[index].quantity = 0;
        Get.find<CartController>().removeItem(_topProducts[index]);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
      } else {
        _topProducts[index].quantity = _topProducts[index].quantity - 1;
        Get.find<CartController>().addQuantity(_topProducts[index]);
        Get.find<HomeController>().checkProductsCart();
      }
    }
    update();
  }

  void updateProductCart() {
    for (var element in _topProducts) {
      if (Get.find<CartController>().checkProductInCart(element.id ?? 0)) {
        element.quantity = Get.find<CartController>().getQuantity(element.id ?? 0);
        element.variant = Get.find<CartController>().getVariant(element.id ?? 1);
      } else {
        element.quantity = 0;
        element.variant = 1;
      }
    }
    update();
  }

  void onStoreChat() {
    Get.delete<InboxController>(force: true);
    Get.toNamed(AppRouter.getInboxRoutes(), arguments: [storeId, storeName]);
  }
}
