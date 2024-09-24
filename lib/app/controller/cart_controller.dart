/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/backend/parse/cart_parse.dart';
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';

class CartController extends GetxController implements GetxService {
  final CartParser parser;
  List<ProductsModel> _savedInCart = <ProductsModel>[];
  List<ProductsModel> get savedInCart => _savedInCart;
  List<int?> itemId = [];
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  double _discount = 0.0;
  double get discount => _discount;

  double _walletDiscount = 0.0;
  double get walletDiscount => _walletDiscount;

  double _orderTax = 0.0;
  double get orderTax => _orderTax;

  double _orderPrice = 0.0;
  double get orderPrice => _orderPrice;

  double _shippingPrice = 0.0;
  double get shippingPrice => _shippingPrice;

  double _minOrderPrice = 0.0;
  double get minOrderPrice => _minOrderPrice;

  double _freeShipping = 0.0;
  double get freeShipping => _freeShipping;

  String _shippingMethod = AppConstants.defaultShippingMethod;
  String get shippingMethod => _shippingMethod;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  CartController({required this.parser});
  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    _minOrderPrice = parser.getMinOrder();
    _shippingPrice = parser.shippingPrice();
    _freeShipping = parser.freeOrderPrice();
    _shippingMethod = parser.getShippingMethod();
    _orderTax = parser.taxOrderPrice();
  }

  void getCart() {
    _savedInCart = [];
    _savedInCart.addAll(parser.getCartProducts());
    itemId = _savedInCart.map((e) => e.id).toList();
    Get.find<TabsController>().updateCartValue();
    calcuate();
    update();
  }

  Future<void> updateSavedAddons(int index, int variantIndex) async {
    _savedInCart[index].variant = variantIndex;
    parser.saveCart(_savedInCart);
    Get.find<HomeController>().checkProductsCart();
    calcuate();
    update();
  }

  Future<void> updateProductAddons(ProductsModel product, int variantIndex) async {
    int index = savedInCart.indexWhere((element) => element.id == product.id);
    if (index < 0) {
      return;
    }
    calcuate();
    updateSavedAddons(index, variantIndex);
  }

  Future<void> updatePopularProducts(int index, var kind) async {
    if (kind == 'add') {
      _savedInCart[index].quantity = _savedInCart[index].quantity + 1;
    } else {
      if (_savedInCart[index].quantity == 1) {
        _savedInCart[index].quantity = 0;
      } else {
        _savedInCart[index].quantity = _savedInCart[index].quantity - 1;
      }
    }
    calcuate();
    update();
  }

  void clearCart() {
    _savedInCart = [];
    itemId = [];
    _totalPrice = 0.0;
    _grandTotal = 0.0;
    _discount = 0.0;
    _walletDiscount = 0.0;
    _orderPrice = 0.0;
    parser.saveCart(_savedInCart);
    Get.find<HomeController>().checkProductsCart();
    Get.find<TabsController>().updateCartValue();
    calcuate();
    update();
  }

  void addItem(ProductsModel product) {
    _savedInCart.add(product);
    itemId.add(product.id);
    parser.saveCart(_savedInCart);
    calcuate();
    update();
  }

  void addQuantity(ProductsModel product) {
    int index = savedInCart.indexWhere((element) => element.id == product.id);
    if (product.quantity < 0) {
      removeItem(product);
    }
    _savedInCart[index].quantity = product.quantity;
    parser.saveCart(_savedInCart);
    calcuate();
    update();
  }

  void removeItem(ProductsModel product) {
    int index = savedInCart.indexWhere((element) => element.id == product.id);
    int itemIndex = itemId.indexOf(product.id);
    _savedInCart.removeAt(index);
    itemId.removeAt(itemIndex);
    parser.saveCart(_savedInCart);
    calcuate();
    update();
  }

  void calcuate() {
    double total = 0.0;
    for (var element in savedInCart) {
      if (element.discount! == 0) {
        if (element.size == 1) {
          if (element.variations != null && element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
            total = total + element.variations![0].items![element.variant].discount! * element.quantity;
          } else {
            total = total + element.variations![0].items![element.variant].price! * element.quantity;
          }
        } else {
          total = total + element.originalPrice! * element.quantity;
        }
      } else {
        if (element.size == 1) {
          if (element.variations != null && element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
            total = total + element.variations![0].items![element.variant].discount! * element.quantity;
          } else {
            total = total + element.variations![0].items![element.variant].price! * element.quantity;
          }
        } else {
          total = total + element.sellPrice! * element.quantity;
        }
      }
    }
    _totalPrice = double.parse((total).toStringAsFixed(2));
    update();
  }

  bool checkProductInCart(int id) {
    return savedInCart.where((element) => element.id == id).isNotEmpty;
  }

  int getQuantity(int id) {
    final index = savedInCart.indexWhere((element) => element.id == id);
    return index >= 0 ? savedInCart[index].quantity : 0;
  }

  int getVariant(int id) {
    final index = savedInCart.indexWhere((element) => element.id == id);
    return index >= 0 ? savedInCart[index].variant : 1;
  }

  bool checkSameStore(int storeId) {
    return savedInCart.where((element) => element.storeId == storeId).isEmpty;
  }

  void updateQuantity(int index, var kind) {
    if (_savedInCart[index].quantity < 1) {
      _savedInCart[index].quantity = 0;
      removeItem(_savedInCart[index]);
      Get.find<TabsController>().updateCartValue();
      Get.find<HomeController>().checkProductsCart();
      update();
      return;
    }
    if (kind == 'add') {
      _savedInCart[index].quantity = _savedInCart[index].quantity + 1;
      addQuantity(_savedInCart[index]);
      Get.find<HomeController>().checkProductsCart();
      update();
    } else {
      if (_savedInCart[index].quantity == 1) {
        _savedInCart[index].quantity = 0;
        removeItem(_savedInCart[index]);
        Get.find<TabsController>().updateCartValue();
        Get.find<HomeController>().checkProductsCart();
        update();
      } else {
        if (_savedInCart[index].quantity < 0) {
          _savedInCart[index].quantity = 0;
          removeItem(_savedInCart[index]);
          Get.find<TabsController>().updateCartValue();
          Get.find<HomeController>().checkProductsCart();
          update();
          return;
        }
        _savedInCart[index].quantity = _savedInCart[index].quantity - 1;
        addQuantity(_savedInCart[index]);
        Get.find<HomeController>().checkProductsCart();
        update();
      }
    }
    calcuate();
  }

  void onCheckout() {
    if (parser.haveLoggedIn() == true) {
      if (totalPrice < minOrderPrice) {
        dynamic text = '';
        if (currencySide == 'left') {
          text = '$currencySymbol $minOrderPrice';
        } else {
          text = '$minOrderPrice $currencySymbol';
        }
        showToast('Minimum order amount must be '.tr + text + ' or more'.tr);
      } else {
        Get.delete<CheckoutController>(force: true);
        Get.toNamed(AppRouter.getCheckoutRoute());
      }
    } else {
      Get.toNamed(AppRouter.getLoginRoute());
    }
  }
}
