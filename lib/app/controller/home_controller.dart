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
import 'package:user/app/backend/models/banners_model.dart';
import 'package:user/app/backend/models/category_model.dart';
import 'package:user/app/backend/models/city_model.dart';
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/backend/models/stores_model.dart';
import 'package:user/app/backend/parse/home_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/product_controller.dart';
import 'package:user/app/controller/sub_category_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/controller/theme_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController implements GetxService {
  final HomeParser parser;
  int findType = 1;
  HomeController({required this.parser});

  List<CategoryModel> _category = <CategoryModel>[];
  List<CategoryModel> get category => _category;

  List<StoresModel> _stores = <StoresModel>[];
  List<StoresModel> get stores => _stores;

  List<ProductsModel> _topProducts = <ProductsModel>[];
  List<ProductsModel> get topProducts => _topProducts;

  List<ProductsModel> _productsForYou = <ProductsModel>[];
  List<ProductsModel> get productsForYou => _productsForYou;

  List<ProductsModel> _inOffers = <ProductsModel>[];
  List<ProductsModel> get inOffers => _inOffers;

  List<BannersModel> _topBanners = <BannersModel>[];
  List<BannersModel> get topBanners => _topBanners;

  List<BannersModel> _bottomBanners = <BannersModel>[];
  List<BannersModel> get bottomBanners => _bottomBanners;

  late CityModel _cityInfo;
  CityModel get cityInfo => _cityInfo;
  bool apiCalled = false;
  bool haveData = false;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  int makeOrders = AppConstants.defaultMakeingOrder;

  String titleName = '';
  @override
  void onInit() async {
    super.onInit();
    findType = parser.getFindType();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    makeOrders = parser.getMakeOrderStatus();
    if (findType == 1) {
      getWithGeoLocation();
      titleName = parser.getAddressName();
    } else if (findType == 2) {
      getWithZipcode();
      titleName = parser.getZipcodeName();
    } else if (findType == 0) {
      getWithCity();
      titleName = parser.getCityName();
    }
  }

  void parseInfo(body) {
    if (body != null) {
      haveData = true;
      if (body['category'] != null) {
        _category = [];
        body['category'].forEach((data) {
          CategoryModel datas = CategoryModel.fromJson(data);
          _category.add(datas);
        });
      }

      if (body['stores'] != null) {
        _stores = [];
        body['stores'].forEach((data) {
          StoresModel datas = StoresModel.fromJson(data);
          _stores.add(datas);
        });
      }

      if (body['topProducts'] != null) {
        _topProducts = [];
        body['topProducts'].forEach((data) {
          ProductsModel datas = ProductsModel.fromJson(data);
          _topProducts.add(datas);
        });
      }

      if (body['homeProducts'] != null) {
        _productsForYou = [];
        body['homeProducts'].forEach((data) {
          ProductsModel datas = ProductsModel.fromJson(data);
          _productsForYou.add(datas);
        });
      }

      if (body['inOffers'] != null) {
        _inOffers = [];
        body['inOffers'].forEach((data) {
          ProductsModel datas = ProductsModel.fromJson(data);
          _inOffers.add(datas);
        });
      }

      if (body['banners'] != null) {
        _topBanners = [];
        _bottomBanners = [];
        body['banners'].forEach((data) {
          BannersModel datas = BannersModel.fromJson(data);
          if (data['position'] == 0) {
            _topBanners.add(datas);
          } else {
            _bottomBanners.add(datas);
          }
        });
      }

      if (body['cityInfo'] != null) {
        CityModel cityData = CityModel.fromJson(body['cityInfo']);
        _cityInfo = cityData;
        parser.saveCity(_cityInfo.id.toString());
      }

      if (body['storeIds'] != null) {
        List<dynamic> storeIds = body['storeIds'];
        parser.saveStoreIds(storeIds.join(','));
      } else {
        parser.removeStoreIds();
      }
    } else {
      haveData = false;
      parser.removeStoreIds();
    }
    checkProductsCart();
    update();
  }

  void checkProductsCart() {
    for (var element in _topProducts) {
      if (Get.find<CartController>().checkProductInCart(element.id ?? 0)) {
        element.quantity = Get.find<CartController>().getQuantity(element.id ?? 0);
        element.variant = Get.find<CartController>().getVariant(element.id ?? 1);
      } else {
        element.quantity = 0;
      }
    }

    for (var element in _productsForYou) {
      if (Get.find<CartController>().checkProductInCart(element.id ?? 0)) {
        element.quantity = Get.find<CartController>().getQuantity(element.id ?? 0);
        element.variant = Get.find<CartController>().getVariant(element.id ?? 1);
      } else {
        element.quantity = 0;
      }
    }

    for (var element in _inOffers) {
      if (Get.find<CartController>().checkProductInCart(element.id ?? 0)) {
        element.quantity = Get.find<CartController>().getQuantity(element.id ?? 0);
        element.variant = Get.find<CartController>().getVariant(element.id ?? 1);
      } else {
        element.quantity = 0;
      }
    }
    update();
  }

  Future<void> addTopProducts(int index) async {
    if (makeOrders == 0) {
      _topProducts[index].quantity = 1;
      Get.find<CartController>().addItem(topProducts[index]);
      Get.find<TabsController>().updateCartValue();
      update();
    } else if (makeOrders == 1) {
      if (Get.find<CartController>().savedInCart.isEmpty) {
        _topProducts[index].quantity = 1;
        Get.find<CartController>().addItem(topProducts[index]);
        Get.find<TabsController>().updateCartValue();
        update();
      } else if (Get.find<CartController>().savedInCart.isNotEmpty) {
        if (Get.find<CartController>().checkSameStore(topProducts[index].storeId!)) {
          clearCartAlert().then((value) {
            if (value == true) {
              Get.find<CartController>().clearCart();
            }
          }).catchError((error) {
            showToast(error);
          });
        } else {
          _topProducts[index].quantity = 1;
          Get.find<CartController>().addItem(topProducts[index]);
          Get.find<TabsController>().updateCartValue();
          update();
        }
      }
    }
  }

  Future<void> updateTopProducts(int index, var kind) async {
    if (kind == 'add') {
      _topProducts[index].quantity = _topProducts[index].quantity + 1;
      Get.find<CartController>().addQuantity(_topProducts[index]);
    } else {
      if (_topProducts[index].quantity == 1) {
        _topProducts[index].quantity = 0;
        Get.find<CartController>().removeItem(_topProducts[index]);
        Get.find<TabsController>().updateCartValue();
      } else {
        _topProducts[index].quantity = _topProducts[index].quantity - 1;
        Get.find<CartController>().addQuantity(_topProducts[index]);
      }
    }
    update();
  }

  Future<void> addPopular(int index) async {
    if (makeOrders == 0) {
      _productsForYou[index].quantity = 1;
      Get.find<CartController>().addItem(productsForYou[index]);
      Get.find<TabsController>().updateCartValue();
      update();
    } else if (makeOrders == 1) {
      if (Get.find<CartController>().savedInCart.isEmpty) {
        _productsForYou[index].quantity = 1;
        Get.find<CartController>().addItem(productsForYou[index]);
        Get.find<TabsController>().updateCartValue();
        update();
      } else if (Get.find<CartController>().savedInCart.isNotEmpty) {
        if (Get.find<CartController>().checkSameStore(productsForYou[index].storeId!)) {
          clearCartAlert().then((value) {
            if (value == true) {
              Get.find<CartController>().clearCart();
            }
          }).catchError((error) {
            showToast(error);
          });
        } else {
          _productsForYou[index].quantity = 1;
          Get.find<CartController>().addItem(productsForYou[index]);
          Get.find<TabsController>().updateCartValue();
          update();
        }
      }
    }
  }

  Future<void> updatePopularProducts(int index, var kind) async {
    if (kind == 'add') {
      _productsForYou[index].quantity = _productsForYou[index].quantity + 1;
      Get.find<CartController>().addQuantity(_productsForYou[index]);
    } else {
      if (_productsForYou[index].quantity == 1) {
        _productsForYou[index].quantity = 0;
        Get.find<CartController>().removeItem(_productsForYou[index]);
        Get.find<TabsController>().updateCartValue();
      } else {
        _productsForYou[index].quantity = _productsForYou[index].quantity - 1;
        Get.find<CartController>().addQuantity(_productsForYou[index]);
      }
    }
    update();
  }

  Future<void> addDeals(int index) async {
    if (makeOrders == 0) {
      _inOffers[index].quantity = 1;
      Get.find<CartController>().addItem(inOffers[index]);
      Get.find<TabsController>().updateCartValue();
      update();
    } else if (makeOrders == 1) {
      if (Get.find<CartController>().savedInCart.isEmpty) {
        _inOffers[index].quantity = 1;
        Get.find<CartController>().addItem(inOffers[index]);
        Get.find<TabsController>().updateCartValue();
        update();
      } else if (Get.find<CartController>().savedInCart.isNotEmpty) {
        if (Get.find<CartController>().checkSameStore(inOffers[index].storeId!)) {
          clearCartAlert().then((value) {
            if (value == true) {
              Get.find<CartController>().clearCart();
            }
          }).catchError((error) {
            showToast(error);
          });
        } else {
          _inOffers[index].quantity = 1;
          Get.find<CartController>().addItem(inOffers[index]);
          Get.find<TabsController>().updateCartValue();
          update();
        }
      }
    }
  }

  Future<void> updateDealsProducts(int index, var kind) async {
    if (kind == 'add') {
      _inOffers[index].quantity = _inOffers[index].quantity + 1;
      Get.find<CartController>().addQuantity(_inOffers[index]);
    } else {
      if (_inOffers[index].quantity == 1) {
        _inOffers[index].quantity = 0;
        Get.find<CartController>().removeItem(_inOffers[index]);
        Get.find<TabsController>().updateCartValue();
      } else {
        _inOffers[index].quantity = _inOffers[index].quantity - 1;
        Get.find<CartController>().addQuantity(_inOffers[index]);
      }
    }
    update();
  }

  Future<void> updateAddons(int index, int variantIndex, var arrayName) async {
    if (arrayName == 'top') {
      _topProducts[index].variant = variantIndex;
      if (Get.find<CartController>().checkProductInCart(topProducts[index].id ?? 0)) {
        Get.find<CartController>().updateProductAddons(topProducts[index], variantIndex);
      }
    }

    if (arrayName == 'popular') {
      _productsForYou[index].variant = variantIndex;
      if (Get.find<CartController>().checkProductInCart(productsForYou[index].id ?? 0)) {
        Get.find<CartController>().updateProductAddons(productsForYou[index], variantIndex);
      }
    }

    if (arrayName == 'deal') {
      _inOffers[index].variant = variantIndex;
      if (Get.find<CartController>().checkProductInCart(inOffers[index].id ?? 0)) {
        Get.find<CartController>().updateProductAddons(inOffers[index], variantIndex);
      }
    }

    update();
  }

  Future<void> getWithCity() async {
    Response response = await parser.getWithCity();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      parseInfo(body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWithZipcode() async {
    Response response = await parser.getWithZipcode();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      parseInfo(body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWithGeoLocation() async {
    Response response = await parser.getWithLatLng();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      parseInfo(body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void changeTheme() {
    Get.find<ThemeController>().toggleTheme();
  }

  void onBannerClick(var type, var value) {
    debugPrint(type.toString() + value.toString());
    if (type == 0) {
      debugPrint('open category');
      var name = _category.firstWhere((element) => element.id.toString() == value).name;
      Get.delete<SubCategoryController>(force: true);
      Get.toNamed(AppRouter.getSubCategoryRoute(), arguments: [int.parse(value), name], preventDuplicates: false);
    } else if (type == 1) {
      debugPrint('open product');
      Get.delete<ProductController>(force: true);
      Get.toNamed(AppRouter.getProductRoutes(), arguments: [int.parse(value), 'Offers']);
    } else {
      debugPrint('open link');
      launchInBrowser(value);
    }
  }

  Future<void> launchInBrowser(var link) async {
    var url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
