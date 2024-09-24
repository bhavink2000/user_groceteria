/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/address_model.dart';
import 'package:user/app/backend/models/coupon_code_model.dart';
import 'package:user/app/backend/models/order_notes_model.dart';
import 'package:user/app/backend/models/order_status_model.dart';
import 'package:user/app/backend/models/payment_model.dart';
import 'package:user/app/backend/models/store_charges_model.dart';
import 'package:user/app/backend/models/stores_model.dart';
import 'package:user/app/backend/parse/checkout_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/controller/stripe_pay_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/controller/web_payment_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:jiffy/jiffy.dart';

class CheckoutController extends GetxController implements GetxService {
  final CheckoutParser parser;
  List<int?> storeUID = [];
  bool apiCalled = false;
  List<StoresModel> _topStores = <StoresModel>[];
  List<StoresModel> get topStores => _topStores;

  List<CouponCodeModel> _couponcodes = <CouponCodeModel>[];
  List<CouponCodeModel> get couponcodes => _couponcodes;

  late CouponCodeModel _selectedCoupon = CouponCodeModel();
  CouponCodeModel get selectedCoupon => _selectedCoupon;

  List<AddressModel> _listAddress = <AddressModel>[];
  List<AddressModel> get listAddress => _listAddress;

  List<OrderStatusModel> _orderStatus = <OrderStatusModel>[];
  List<OrderStatusModel> get orderStatus => _orderStatus;

  List<OrderNotesModel> _orderNotes = <OrderNotesModel>[];
  List<OrderNotesModel> get orderNotes => _orderNotes;

  List<StoreChargesModel> _storeCharges = <StoreChargesModel>[];
  List<StoreChargesModel> get storeCharges => _storeCharges;

  List<PaymentModel> _paymentsList = <PaymentModel>[];
  List<PaymentModel> get paymentsList => _paymentsList;

  bool isAddressAPICalled = false;
  bool isPaymentAPICalled = false;
  String selectedAddressId = '';

  late AddressModel _savedAddress = AddressModel();
  AddressModel get savedAddress => _savedAddress;

  String _shippingMethod = AppConstants.defaultShippingMethod;
  String get shippingMethod => _shippingMethod;

  double _shippingPrice = 0.0;
  double get shippingPrice => _shippingPrice;

  double _deliveryPrice = 0.0;
  double get deliveryPrice => _deliveryPrice;

  double _freeShipping = 0.0;
  double get freeShipping => _freeShipping;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  String deliveryOrderTo = 'home';
  String selectedTime = 'Today - '.tr + Jiffy().yMMMMd;
  String selectedDeliveryTime = Jiffy().format('yyyy-MM-dd hh:mm:ss');
  String selectedPaymentId = '';
  String payMethodName = '';
  double balance = 0.0;
  double walletDiscount = 0.0;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  bool isWalletChecked = false;
  String couponId = '';
  double itemTotal = 0.0;
  double orderTax = 0.0;
  double discount = 0.0;
  int totalItems = 0;

  List<int?> storeIds = [];

  CheckoutController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    _shippingMethod = parser.getShippingMethod();
    _shippingPrice = parser.shippingPrice();
    _freeShipping = parser.freeOrderPrice();

    totalItems = Get.find<CartController>().savedInCart.length;
    Get.find<CartController>().savedInCart.forEach((element) {
      storeIds.add(element.storeId);
    });
    itemTotal = Get.find<CartController>().totalPrice;
    orderTax = Get.find<CartController>().orderTax;
    storeIds = [
      ...{...storeIds}
    ];

    getStoreList(storeIds.join(','));
    getMyWalletAmount();
    calculateAllCharges();
  }

  Future<void> getStoreList(var ids) async {
    Response response = await parser.getStoreList(ids);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _topStores = [];
      storeUID = [];
      body.forEach((data) {
        StoresModel datas = StoresModel.fromJson(data);
        _topStores.add(datas);
        storeUID.add(datas.uid);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getMyAddressList() async {
    Response response = await parser.getMyAddressList();
    isAddressAPICalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _listAddress = [];
      body.forEach((data) {
        AddressModel datas = AddressModel.fromJson(data);
        _listAddress.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getPaymentList() async {
    Response response = await parser.getPaymentList();
    isPaymentAPICalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _paymentsList = [];
      body.forEach((data) {
        PaymentModel datas = PaymentModel.fromJson(data);
        _paymentsList.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getMyWalletAmount() async {
    Response response = await parser.getMyWalletBalance();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body != null && body != '' && body['balance'] != null && body['balance'] != '') {
        balance = double.tryParse(body['balance'].toString()) ?? 0.0;
        walletDiscount = double.tryParse(body['balance'].toString()) ?? 0.0;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveDeliveryOrder(String deliveryTo) {
    deliveryOrderTo = deliveryTo;
    if (deliveryOrderTo == 'store') {
      _deliveryPrice = 0;
    }
    calculateAllCharges();
    update();
  }

  void saveDeliveryTime(String deliveryTime, String time) {
    if (time == 'today') {
      selectedDeliveryTime = Jiffy().format('yyyy-MM-dd hh:mm:ss');
    } else {
      selectedDeliveryTime = Jiffy().add(days: 1).format('yyyy-MM-dd hh:mm:ss');
    }
    selectedTime = deliveryTime;
    update();
  }

  Future<void> getCoupons(context) async {
    AlertDialog alert = AlertDialog(content: Row(children: [const CircularProgressIndicator(), Container(margin: const EdgeInsets.only(left: 7), child: Text("Please wait".tr))]));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    Response response = await parser.getCouponsList();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _couponcodes = [];
      body.forEach((data) {
        CouponCodeModel datas = CouponCodeModel.fromJson(data);
        datas.dateTime = Jiffy(datas.dateTime.toString(), "yyyy-MM-dd").yMMMMd;
        _couponcodes.add(datas);
      });
      Navigator.of(context).pop(true);
      openOffersModal();
      update();
    } else {
      Navigator.of(context).pop(true);
      ApiChecker.checkApi(response);
    }
    update();
  }

  void openOffersModal() {
    Color getColor(Set<MaterialState> states) {
      return ThemeProvider.appColor;
    }

    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        insetPadding: const EdgeInsets.all(0.0),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("coupon codes".tr, style: const TextStyle(fontFamily: 'bold', fontSize: 12)),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.close, size: 12)),
            )
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                for (var options in couponcodes)
                  ListTile(
                    isThreeLine: true,
                    textColor: ThemeProvider.blackColor,
                    iconColor: ThemeProvider.blackColor,
                    title: Text('Use coupon code '.tr + options.name.toString(), style: const TextStyle(fontFamily: 'bold', fontSize: 10)),
                    subtitle: Text(options.descriptions.toString() + ' - Valid until '.tr + options.dateTime.toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    leading: ClipRRect(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10),
                        child: FadeInImage(
                          image: NetworkImage('${Environments.apiBaseURL}storage/images/${options.image}'),
                          placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    trailing: Radio(
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: options.id.toString(),
                      groupValue: couponId,
                      onChanged: (e) {
                        var selectedItem = couponcodes.firstWhereOrNull((element) => element.id.toString() == e);
                        if (selectedItem?.id.toString() == e) {
                          if (Get.find<CartController>().totalPrice >= selectedItem!.min) {
                            couponId = e.toString();
                            _selectedCoupon = selectedItem;
                            if (_selectedCoupon.type == 'per') {
                              double percentage(numFirst, per) {
                                return (numFirst / 100) * per;
                              }

                              discount = percentage(itemTotal, _selectedCoupon.off);
                            } else {
                              discount = _selectedCoupon.off ?? 0.0;
                            }
                            update();
                            calculateAllCharges();
                            Navigator.of(context).pop(true);
                          } else {
                            showToast("Sorry minimum cart value must be ".tr + selectedItem.min.toString() + ' or equal'.tr);
                          }
                        }
                      },
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateWalletChecked(bool status) {
    isWalletChecked = status;
    calculateAllCharges();
    update();
  }

  void clearCouponCode() {
    _selectedCoupon = CouponCodeModel();
    discount = 0;
    calculateAllCharges();
    update();
  }

  void saveDeliveryAddress(String id) {
    if (id != '' && id.isNotEmpty) {
      selectedAddressId = id;
      update();
      _savedAddress = _listAddress.firstWhere((element) => element.id.toString() == selectedAddressId);
      if (_savedAddress.id.toString() == selectedAddressId) {
        double totalMeters = 0.0;
        _storeCharges = [];
        for (var element in _topStores) {
          double storeDistance = 0.0;
          storeDistance = Geolocator.distanceBetween(
            double.tryParse(savedAddress.lat.toString()) ?? 0.0,
            double.tryParse(savedAddress.lng.toString()) ?? 0.0,
            double.tryParse(element.lat.toString()) ?? 0.0,
            double.tryParse(element.lng.toString()) ?? 0.0,
          );
          totalMeters = totalMeters + storeDistance;
          double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
          double dividedTax = orderTax / _topStores.length;
          var storeExtra = {'store_id': element.uid, 'distance': distance, 'tax': double.parse((dividedTax).toStringAsFixed(2)), 'shipping': shippingMethod, 'shippingPrice': shippingPrice};
          StoreChargesModel storeChargeObj = StoreChargesModel.fromJson(storeExtra);
          _storeCharges.add(storeChargeObj);
        }
        totalMeters = totalMeters / 1000;
        double roundDistanceInKM = double.parse((totalMeters).toStringAsFixed(2));
        if (freeShipping > itemTotal) {
          if (shippingMethod == 'km') {
            double distancePricer = roundDistanceInKM * shippingPrice;
            _deliveryPrice = double.parse((distancePricer).toStringAsFixed(2));
          } else {
            _deliveryPrice = shippingPrice;
          }
        } else {
          _deliveryPrice = 0;
        }
        calculateAllCharges();
        update();
      }
    } else {
      showToast('Please Select Delivery Address'.tr);
    }
  }

  void onStoreDelivery() {
    _storeCharges = [];
    for (var element in _topStores) {
      double dividedTax = orderTax / _topStores.length;
      var storeExtra = {'store_id': element.uid, 'distance': 0, 'tax': double.parse((dividedTax).toStringAsFixed(2)), 'shipping': shippingMethod, 'shippingPrice': shippingPrice};
      StoreChargesModel storeChargeObj = StoreChargesModel.fromJson(storeExtra);
      _storeCharges.add(storeChargeObj);
    }
    _deliveryPrice = 0;
    calculateAllCharges();
    update();
  }

  void calculateAllCharges() {
    double totalPrice = itemTotal + orderTax + deliveryPrice;

    walletDiscount = balance;
    if (isWalletChecked == true) {
      if (totalPrice <= walletDiscount) {
        walletDiscount = totalPrice;
        totalPrice = totalPrice - walletDiscount;
      } else {
        totalPrice = totalPrice - walletDiscount;
      }
    } else {
      if (totalPrice <= discount) {
        discount = totalPrice;
        totalPrice = totalPrice - discount;
      } else {
        totalPrice = totalPrice - discount;
      }
    }
    _grandTotal = double.parse((totalPrice).toStringAsFixed(2));
  }

  void onPaymentMethodChanged(String id) {
    selectedPaymentId = id;
    if (selectedPaymentId == '1') {
      payMethodName = 'cod';
    } else if (selectedPaymentId == '2') {
      payMethodName = 'stripe';
    } else if (selectedPaymentId == '3') {
      payMethodName = 'paypal';
    } else if (selectedPaymentId == '4') {
      payMethodName = 'paytm';
    } else if (selectedPaymentId == '5') {
      payMethodName = 'razorpay';
    } else if (selectedPaymentId == '6') {
      payMethodName = 'instamojo';
    } else if (selectedPaymentId == '7') {
      payMethodName = 'paystack';
    } else if (selectedPaymentId == '8') {
      payMethodName = 'flutterwave';
    }
    update();
  }

  void onPaymentButton() {
    if (selectedPaymentId != '' && selectedPaymentId.isNotEmpty) {
      if (selectedPaymentId != '2') {
        Get.generalDialog(
          pageBuilder: (context, __, ___) => AlertDialog(
            title: Text('Are you sure?'.tr),
            content: Text("Orders once placed cannot be cancelled and are non-refundable".tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedPaymentId == '1') {
                    createOrder();
                  } else if (selectedPaymentId == '3') {
                    Get.delete<WebPaymentController>(force: true);
                    var paymentURL = AppConstants.payPalPayLink + grandTotal.toString();
                    Get.toNamed(AppRouter.getWebPaymentsRoutes(), arguments: [payMethodName, paymentURL]);
                  } else if (selectedPaymentId == '4') {
                    Get.delete<WebPaymentController>(force: true);
                    var paymentURL = AppConstants.payTmPayLink + grandTotal.toString();
                    Get.toNamed(AppRouter.getWebPaymentsRoutes(), arguments: [payMethodName, paymentURL]);
                  } else if (selectedPaymentId == '5') {
                    Get.delete<WebPaymentController>(force: true);
                    var paymentPayLoad = {
                      'amount': double.parse((grandTotal * 100).toStringAsFixed(2)).toString(),
                      'email': parser.getEmail(),
                      'logo': '${parser.apiService.appBaseUrl}storage/images/${parser.getAppLogo()}',
                      'name': parser.getName(),
                      'app_color': '#f47878'
                    };

                    String queryString = Uri(queryParameters: paymentPayLoad).query;
                    var paymentURL = AppConstants.razorPayLink + queryString;

                    Get.toNamed(AppRouter.getWebPaymentsRoutes(), arguments: [payMethodName, paymentURL]);
                  } else if (selectedPaymentId == '6') {
                    payWithInstaMojo();
                  } else if (selectedPaymentId == '7') {
                    var rng = Random();
                    var paykey = List.generate(12, (_) => rng.nextInt(100));
                    Get.delete<WebPaymentController>(force: true);
                    var paymentPayLoad = {
                      'email': parser.getEmail(),
                      'amount': double.parse((grandTotal * 100).toStringAsFixed(2)).toString(),
                      'first_name': parser.getFirstName(),
                      'last_name': parser.getLastName(),
                      'ref': paykey.join()
                    };
                    String queryString = Uri(queryParameters: paymentPayLoad).query;
                    var paymentURL = AppConstants.paystackCheckout + queryString;

                    Get.toNamed(AppRouter.getWebPaymentsRoutes(), arguments: [payMethodName, paymentURL]);
                  } else if (selectedPaymentId == '8') {
                    Get.delete<WebPaymentController>(force: true);
                    var gateway = paymentsList.firstWhereOrNull((element) => element.id.toString() == selectedPaymentId);
                    var paymentPayLoad = {
                      'amount': grandTotal.toString(),
                      'email': parser.getEmail(),
                      'phone': parser.getPhone(),
                      'name': parser.getName(),
                      'code': gateway!.currencyCode.toString(),
                      'logo': '${parser.apiService.appBaseUrl}storage/images/${parser.getAppLogo()}',
                      'app_name': Environments.appName
                    };

                    String queryString = Uri(queryParameters: paymentPayLoad).query;
                    var paymentURL = AppConstants.flutterwaveCheckout + queryString;

                    Get.toNamed(AppRouter.getWebPaymentsRoutes(), arguments: [payMethodName, paymentURL]);
                  }
                },
                child: Text('Yes, Place Order'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
              )
            ],
          ),
        );
      } else {
        Get.delete<StripePayController>(force: true);
        var gateway = paymentsList.firstWhereOrNull((element) => element.id.toString() == selectedPaymentId);
        Get.toNamed(AppRouter.getStripePayRoutes(), arguments: [grandTotal, gateway!.currencyCode.toString()]);
      }
    } else {
      showToast('Please Select Payment Method'.tr);
    }
  }

  Future<void> payWithInstaMojo() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Please wait".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    var param = {
      'allow_repeated_payments': 'False',
      'amount': grandTotal,
      'buyer_name': parser.getName(),
      'purpose': 'Orders',
      'redirect_url': '${parser.apiService.appBaseUrl}/api/v1/success_payments',
      'phone': parser.getPhone() != '' ? parser.getPhone() : '8888888888888888',
      'send_email': 'True',
      'webhook': parser.apiService.appBaseUrl,
      'send_sms': 'True',
      'email': parser.getEmail()
    };
    Response response = await parser.getInstaMojoPayLink(param);
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["success"];
      if (body['payment_request'] != '' && body['payment_request']['longurl'] != '') {
        Get.delete<WebPaymentController>(force: true);
        var paymentURL = body['payment_request']['longurl'];
        Get.toNamed(AppRouter.getWebPaymentsRoutes(), arguments: [payMethodName, paymentURL]);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> createOrder() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Creating Order".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    _orderStatus = [];
    for (var element in storeIds) {
      var orderStatusParam = {'id': element, 'status': 'created'};
      OrderStatusModel datas = OrderStatusModel.fromJson(orderStatusParam);
      _orderStatus.add(datas);
    }
    _orderNotes = [];
    var orderNotesParam = {'status': 1, 'value': 'Order Created', 'time': Jiffy().format('MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    _orderNotes.add(orderNotesParse);
    var param = {
      'uid': parser.getUID(),
      'store_id': storeIds.join(','),
      'date_time': selectedDeliveryTime,
      'paid_method': payMethodName,
      'order_to': deliveryOrderTo,
      'orders': jsonEncode(Get.find<CartController>().savedInCart),
      'notes': jsonEncode(orderNotes),
      'address': deliveryOrderTo == 'home' ? jsonEncode(savedAddress) : '',
      'driver_id': '',
      'total': itemTotal,
      'tax': orderTax,
      'grand_total': grandTotal,
      'delivery_charge': deliveryPrice,
      'coupon_code': selectedCoupon.id != null ? jsonEncode(selectedCoupon) : '',
      'discount': discount,
      'pay_key': 'cod',
      'status': jsonEncode(orderStatus),
      'assignee': '',
      'extra': jsonEncode(storeCharges),
      'payStatus': 1,
      'wallet_used': isWalletChecked == true && walletDiscount > 0 ? 1 : 0,
      'wallet_price': walletDiscount
    };

    Response response = await parser.createOrder(param);

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body['id'] != '') {
        var mailParam = {
          "id": body['id'],
          "mediaURL": '${Environments.apiBaseURL}storage/images/',
          "subject": 'Your Order Created Successfully'.tr,
          "email": parser.getEmail(),
          "username": parser.getName(),
          "store_phone": parser.getSupportPhone(),
          "store_email": parser.getSupportEmail()
        };
        await parser.sendOrderMail(mailParam);
        Get.back();
        var context = Get.context as BuildContext;
        // ignore: use_build_context_synchronously
        showModalBottomSheet(
          isDismissible: false,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    const Icon(Icons.check_circle_outline, size: 60, color: ThemeProvider.appColor),
                    const SizedBox(height: 10),
                    Text('Your Order Created Successfully'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('You can view the order tracking info in the'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 12)),
                        Text(' Profile '.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 12)),
                        Text('section.'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 12))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20.0),
                      child: InkWell(
                        onTap: () {
                          Get.find<CartController>().clearCart();
                          Get.find<OrderController>().getOrder();
                          Get.offAllNamed(AppRouter.getTabsRoute());
                          Get.find<TabsController>().updateTabId(0);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0)), color: ThemeProvider.appColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Go to Home'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 17, fontFamily: 'regular'))],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
                      child: InkWell(
                        onTap: () {
                          Get.find<CartController>().clearCart();
                          Get.find<OrderController>().getOrder();
                          Get.offAllNamed(AppRouter.getTabsRoute());
                          Get.find<TabsController>().updateTabId(3);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Go to Order'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 17, fontFamily: 'regular'))],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    update();
  }
}
