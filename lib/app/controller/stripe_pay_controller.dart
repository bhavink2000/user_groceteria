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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/order_notes_model.dart';
import 'package:user/app/backend/models/order_status_model.dart';
import 'package:user/app/backend/models/stripe_cards_model.dart';
import 'package:user/app/backend/parse/stripe_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:jiffy/jiffy.dart';

class StripePayController extends GetxController implements GetxService {
  final StripePayParser parser;
  bool apiCalled = false;
  bool cardsListCalled = false;
  List<StripeCardsModel> _cards = <StripeCardsModel>[];
  List<StripeCardsModel> get cards => _cards;
  String stripeKey = '';
  String selectedCard = '';
  double grandTotal = 0.0;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  String currencyCode = '';
  StripePayController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    grandTotal = Get.arguments[0];
    currencyCode = Get.arguments[1];
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getProfile();
  }

  Future<void> getProfile() async {
    Response response = await parser.getProfile();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body != null && body != '') {
        stripeKey = body['stripe_key'] ?? '';
        getStringCards();
        update();
      }
    } else {
      cardsListCalled = true;
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  Future<void> getStringCards() async {
    if (stripeKey != '' && stripeKey.isNotEmpty) {
      Response response = await parser.getStripeCards(stripeKey);
      cardsListCalled = true;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["success"];
        _cards = [];
        body['data'].forEach((data) {
          StripeCardsModel datas = StripeCardsModel.fromJson(data);
          _cards.add(datas);
        });
      } else {
        cardsListCalled = true;
        ApiChecker.checkApi(response);
        update();
      }
      update();
    } else {
      cardsListCalled = true;
      update();
    }
  }

  void saveCardToPay(String id) {
    selectedCard = id;
    update();
  }

  void createPayment() {
    if (selectedCard != '' && selectedCard.isNotEmpty) {
      Get.generalDialog(
        pageBuilder: (context, __, ___) => AlertDialog(
          title: Text('Are you sure?'.tr),
          content: Text("Orders once placed cannot be cancelled and are non-refundable".tr),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium'))),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                makePayment();
              },
              child: Text('Yes, Place Order'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
            )
          ],
        ),
      );
    } else {
      showToast('Please select card');
    }
  }

  Future<void> makePayment() async {
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
    var param = {'amount': grandTotal.toInt() * 100, 'currency': currencyCode, 'customer': stripeKey, 'card': selectedCard};
    Response response = await parser.checkout(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic successResponse = myMap["success"];
      createOrder(successResponse);
    } else {
      Get.back();
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  Future<void> createOrder(dynamic paymentInfo) async {
    var orderStatus = [];
    Get.find<CheckoutController>().storeIds.forEach((element) {
      var orderStatusParam = {'id': element, 'status': 'created'};
      OrderStatusModel datas = OrderStatusModel.fromJson(orderStatusParam);
      orderStatus.add(datas);
    });

    var orderNotes = [];
    var orderNotesParam = {'status': 1, 'value': 'Order Created', 'time': Jiffy().format('MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    orderNotes.add(orderNotesParse);
    var paramOrder = {
      'uid': parser.getUID(),
      'store_id': Get.find<CheckoutController>().storeIds.join(','),
      'date_time': Get.find<CheckoutController>().selectedDeliveryTime,
      'paid_method': Get.find<CheckoutController>().payMethodName,
      'order_to': Get.find<CheckoutController>().deliveryOrderTo,
      'orders': jsonEncode(Get.find<CartController>().savedInCart),
      'notes': jsonEncode(orderNotes),
      'address': Get.find<CheckoutController>().deliveryOrderTo == 'home' ? jsonEncode(Get.find<CheckoutController>().savedAddress) : '',
      'driver_id': '',
      'total': Get.find<CheckoutController>().itemTotal,
      'tax': Get.find<CheckoutController>().orderTax,
      'grand_total': grandTotal,
      'delivery_charge': Get.find<CheckoutController>().deliveryPrice,
      'coupon_code': Get.find<CheckoutController>().selectedCoupon.id != null ? jsonEncode(Get.find<CheckoutController>().selectedCoupon) : '',
      'discount': Get.find<CheckoutController>().discount,
      'pay_key': jsonEncode(paymentInfo),
      'status': jsonEncode(orderStatus),
      'assignee': '',
      'extra': jsonEncode(Get.find<CheckoutController>().storeCharges),
      'payStatus': 1,
      'wallet_used': Get.find<CheckoutController>().isWalletChecked == true && Get.find<CheckoutController>().walletDiscount > 0 ? 1 : 0,
      'wallet_price': Get.find<CheckoutController>().walletDiscount
    };

    Response response = await parser.createOrder(paramOrder);

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
