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
import 'package:user/app/backend/parse/sub_cate_product_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';

class SubCatesProductsController extends GetxController implements GetxService {
  final SubCatesProductParser parser;
  String subCateName = '';
  int subId = 0;
  var lastLimit = 1.obs;
  bool loadMore = false;
  bool apiCalled = false;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  int makeOrders = AppConstants.defaultMakeingOrder;
  List<ProductsModel> _products = <ProductsModel>[];
  List<ProductsModel> get products => _products;
  String selectedFilter = '';
  SubCatesProductsController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    makeOrders = parser.getMakeOrderStatus();
    subCateName = Get.arguments[1];
    subId = Get.arguments[0];
    update();
    getProducts();
  }

  Future<void> getProducts() async {
    Response response = await parser.getProducts(subId, lastLimit.value);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _products = [];
      body.forEach((data) {
        ProductsModel datas = ProductsModel.fromJson(data);
        _products.add(datas);
      });
      for (var element in _products) {
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
      _products.sort((a, b) => b.rating!.compareTo(a.rating!));
    } else if (kind == 'l-h') {
      selectedFilter = 'Price L-H'.tr;
      _products.sort((a, b) => a.originalPrice!.compareTo(b.originalPrice!));
    } else if (kind == 'h-l') {
      selectedFilter = 'Price H-L'.tr;
      _products.sort((a, b) => b.originalPrice!.compareTo(a.originalPrice!));
    } else if (kind == 'a-z') {
      selectedFilter = 'A-Z'.tr;
      _products.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
    } else if (kind == 'z-a') {
      selectedFilter = 'Z-A'.tr;
      _products.sort((a, b) => b.name.toString().compareTo(a.name.toString()));
    } else if (kind == 'off') {
      selectedFilter = '% Off'.tr;
      _products.sort((a, b) => b.discount!.compareTo(a.discount!));
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
    _products[index].variant = variantIndex;
    if (Get.find<CartController>().checkProductInCart(products[index].id ?? 0)) {
      Get.find<CartController>().updateProductAddons(products[index], variantIndex);
    }
    update();
  }

  Future<void> addPopular(int index) async {
    if (makeOrders == 0) {
      _products[index].quantity = 1;
      Get.find<CartController>().addItem(products[index]);
      Get.find<TabsController>().updateCartValue();
      Get.find<HomeController>().checkProductsCart();
      update();
    } else if (makeOrders == 1) {
      if (Get.find<CartController>().savedInCart.isEmpty) {
        _products[index].quantity = 1;
        Get.find<CartController>().addItem(products[index]);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
        update();
      } else if (Get.find<CartController>().savedInCart.isNotEmpty) {
        if (Get.find<CartController>().checkSameStore(products[index].storeId!)) {
          clearCartAlert().then((value) {
            if (value == true) {
              for (var element in _products) {
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
          _products[index].quantity = 1;
          Get.find<CartController>().addItem(products[index]);
          Get.find<TabsController>().updateCartValue();
          Get.find<HomeController>().checkProductsCart();
          update();
        }
      }
    }
  }

  Future<void> updatePopularProducts(int index, var kind) async {
    if (kind == 'add') {
      _products[index].quantity = _products[index].quantity + 1;
      Get.find<CartController>().addQuantity(_products[index]);
      Get.find<HomeController>().checkProductsCart();
    } else {
      if (_products[index].quantity == 1) {
        _products[index].quantity = 0;
        Get.find<CartController>().removeItem(_products[index]);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
      } else {
        _products[index].quantity = _products[index].quantity - 1;
        Get.find<CartController>().addQuantity(_products[index]);
        Get.find<HomeController>().checkProductsCart();
      }
    }
    update();
  }

  void updateProductCart() {
    for (var element in _products) {
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
}
