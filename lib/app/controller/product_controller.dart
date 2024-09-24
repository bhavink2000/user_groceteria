/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/backend/parse/product_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/in_offers_controller.dart';
import 'package:user/app/controller/popular_controller.dart';
import 'package:user/app/controller/store_products_controller.dart';
import 'package:user/app/controller/sub_cate_product_controller.dart';
import 'package:user/app/controller/sub_category_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/controller/top_picked_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';

class ProductController extends GetxController implements GetxService {
  final ProductParser parser;
  String productName = '';
  int productId = 0;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  int makeOrders = AppConstants.defaultMakeingOrder;
  bool apiCalled = false;

  late ProductsModel _details;
  ProductsModel get details => _details;
  List<String>? images = [];
  List<ProductsModel> _related = <ProductsModel>[];
  List<ProductsModel> get related => _related;
  List favIds = [];
  bool isFav = false;
  bool haveCreateFavList = false;
  ProductController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    makeOrders = parser.getMakeOrderStatus();
    productName = Get.arguments[1];
    productId = Get.arguments[0];
    getProductInfo(productId);
  }

  Future<void> getProductInfo(int id) async {
    Response response = await parser.getSingleProduct(id);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      ProductsModel datas = ProductsModel.fromJson(body);
      if (Get.find<CartController>().checkProductInCart(id)) {
        datas.quantity = Get.find<CartController>().getQuantity(id);
        datas.variant = Get.find<CartController>().getVariant(id);
      } else {
        datas.quantity = 0;
      }
      _details = datas;
      try {
        List<dynamic> list = jsonDecode(datas.images.toString());
        images!.add(details.cover.toString());
        for (var element in list) {
          if (element != null && element != '') {
            images!.add(element);
          }
        }
      } catch (e) {
        e;
      }
      if (parser.haveLoggedIn() == true) {
        getProfileData();
      }
      _related = [];
      dynamic relatedItems = myMap['related'];
      relatedItems.forEach((data) {
        ProductsModel datas = ProductsModel.fromJson(data);
        if (datas.id != id) {
          _related.add(datas);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getProfileData() async {
    Response response = await parser.getProfile();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["fav"];
      if (body != null && body != '') {
        haveCreateFavList = true;
        String ids = body['ids'] ?? '';
        if (ids != '') {
          favIds = ids.split(',').map((e) => int.parse(e)).toList();
          debugPrint(favIds.toString());
        }
        isFav = favIds.contains(productId);
        update();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> updateAddons(int variantIndex) async {
    _details.variant = variantIndex;
    if (Get.find<CartController>().checkProductInCart(details.id ?? 0)) {
      Get.find<CartController>().updateProductAddons(details, variantIndex);
    }
    update();
  }

  Future<void> addPopular() async {
    if (makeOrders == 0) {
      _details.quantity = 1;
      Get.find<CartController>().addItem(_details);
      Get.find<TabsController>().updateCartValue();
      Get.find<HomeController>().checkProductsCart();
      Get.find<SubCategoryController>().updateProductCart();
      Get.find<StoreProductsController>().updateProductCart();
      Get.find<PopularController>().updateProductCart();
      Get.find<InOffersController>().updateProductCart();
      Get.find<TopPickedController>().updateProductCart();
      Get.find<SubCatesProductsController>().updateProductCart();
      update();
    } else if (makeOrders == 1) {
      if (Get.find<CartController>().savedInCart.isEmpty) {
        _details.quantity = 1;
        Get.find<CartController>().addItem(_details);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
        Get.find<SubCategoryController>().updateProductCart();
        Get.find<StoreProductsController>().updateProductCart();
        Get.find<PopularController>().updateProductCart();
        Get.find<InOffersController>().updateProductCart();
        Get.find<TopPickedController>().updateProductCart();
        Get.find<SubCatesProductsController>().updateProductCart();
        update();
      } else if (Get.find<CartController>().savedInCart.isNotEmpty) {
        if (Get.find<CartController>().checkSameStore(_details.storeId!)) {
          clearCartAlert().then((value) {
            if (value == true) {
              Get.find<CartController>().clearCart();
            }
          }).catchError((error) {
            showToast(error);
          });
        } else {
          _details.quantity = 1;
          Get.find<CartController>().addItem(_details);
          Get.find<TabsController>().updateCartValue();
          Get.find<HomeController>().checkProductsCart();
          Get.find<SubCategoryController>().updateProductCart();
          Get.find<StoreProductsController>().updateProductCart();
          Get.find<PopularController>().updateProductCart();
          Get.find<InOffersController>().updateProductCart();
          Get.find<TopPickedController>().updateProductCart();
          Get.find<SubCatesProductsController>().updateProductCart();
          update();
        }
      }
    }
  }

  Future<void> updateTopProducts(var kind) async {
    if (kind == 'add') {
      _details.quantity = _details.quantity + 1;
      Get.find<CartController>().addQuantity(_details);
      Get.find<HomeController>().checkProductsCart();
      Get.find<SubCategoryController>().updateProductCart();
      Get.find<StoreProductsController>().updateProductCart();
      Get.find<PopularController>().updateProductCart();
      Get.find<InOffersController>().updateProductCart();
      Get.find<TopPickedController>().updateProductCart();
      Get.find<SubCatesProductsController>().updateProductCart();
    } else {
      if (_details.quantity == 1) {
        _details.quantity = 0;
        Get.find<CartController>().removeItem(_details);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
        Get.find<SubCategoryController>().updateProductCart();
        Get.find<StoreProductsController>().updateProductCart();
        Get.find<PopularController>().updateProductCart();
        Get.find<InOffersController>().updateProductCart();
        Get.find<TopPickedController>().updateProductCart();
        Get.find<SubCatesProductsController>().updateProductCart();
      } else {
        _details.quantity = _details.quantity - 1;
        Get.find<CartController>().addQuantity(_details);
        Get.find<HomeController>().checkProductsCart();
        Get.find<SubCategoryController>().updateProductCart();
        Get.find<StoreProductsController>().updateProductCart();
        Get.find<PopularController>().updateProductCart();
        Get.find<InOffersController>().updateProductCart();
        Get.find<TopPickedController>().updateProductCart();
        Get.find<SubCatesProductsController>().updateProductCart();
      }
    }
    update();
  }

  Future<void> onFavourite() async {
    if (favIds.contains(productId)) {
      favIds.remove(productId);
      isFav = false;
      update();
      Response response = await parser.updateFavourite(favIds.join(','));
      apiCalled = true;
      if (response.statusCode == 200) {
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    } else {
      if (haveCreateFavList == true) {
        favIds.add(productId);
        isFav = true;
        update();
        Response response = await parser.updateFavourite(favIds.join(','));
        apiCalled = true;
        if (response.statusCode == 200) {
        } else {
          ApiChecker.checkApi(response);
        }
        update();
      } else {
        favIds.add(productId);
        isFav = true;
        update();
        Response response = await parser.saveFavourite(favIds.join(','));
        apiCalled = true;
        if (response.statusCode == 200) {
        } else {
          ApiChecker.checkApi(response);
        }
        update();
      }
    }
  }

  Future<void> share() async {
    String title = '${'Your friend'.tr} has invited you to ${Environments.appName}';

    await FlutterShare.share(title: title, text: details.name.toString(), linkUrl: '${Environments.apiBaseURL}storage/images/${details.cover}', chooserTitle: 'Share with buddies'.tr);
  }
}
