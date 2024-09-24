/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/backend/models/sub_cate_model.dart';
import 'package:user/app/backend/parse/sub_category_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';

class SubCategoryController extends GetxController implements GetxService {
  final SubCategoryParser parser;
  List<SubCategoryModel> _category = <SubCategoryModel>[];
  List<SubCategoryModel> get category => _category;

  List<ProductsModel> _products = <ProductsModel>[];
  List<ProductsModel> get products => _products;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  int makeOrders = AppConstants.defaultMakeingOrder;
  int cateId = 0;
  int subId = 0;
  bool apiCalled = false;
  bool productsCalled = false;
  String cateName = '';
  var lastLimit = 1.obs;
  bool loadMore = false;
  SubCategoryController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    makeOrders = parser.getMakeOrderStatus();
    int id = Get.arguments[0];
    cateName = Get.arguments[1];
    cateId = id;
    getSubCategories(id);
  }

  Future<void> getSubCategories(int id) async {
    Response response = await parser.getSubCategories(id);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _category = [];
      body.forEach((data) {
        SubCategoryModel datas = SubCategoryModel.fromJson(data);
        _category.add(datas);
      });
      if (category.isNotEmpty) {
        subId = category[0].id as int;
        getProducts();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getProducts() async {
    Response response = await parser.getProducts(lastLimit.value, cateId, subId);
    productsCalled = true;
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

  void increment() {
    loadMore = true;
    lastLimit = lastLimit++;
    update();
    getProducts();
  }

  void changeCategory(var index) {
    _products = [];
    subId = category[index].id as int;
    productsCalled = false;
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
