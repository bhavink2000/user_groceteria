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
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/order_notes_model.dart';
import 'package:user/app/backend/models/order_status_model.dart';
import 'package:user/app/backend/parse/web_payment_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:jiffy/jiffy.dart';

class WebPaymentController extends GetxController implements GetxService {
  final WebPaymentsParser parser;

  String payMethod = '';
  String paymentURL = '';
  String apiURL = '';
  WebPaymentController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    apiURL = parser.apiService.appBaseUrl;
    payMethod = Get.arguments[0];
    if (payMethod != 'instamojo') {
      paymentURL = apiURL + Get.arguments[1];
    } else {
      paymentURL = Get.arguments[1];
    }
    update();
  }

  Future<void> createOrder(String orderId) async {
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
      'grand_total': Get.find<CheckoutController>().grandTotal,
      'delivery_charge': Get.find<CheckoutController>().deliveryPrice,
      'coupon_code': Get.find<CheckoutController>().selectedCoupon.id != null ? jsonEncode(Get.find<CheckoutController>().selectedCoupon) : '',
      'discount': Get.find<CheckoutController>().discount,
      'pay_key': orderId,
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
        openSuccessModal();
      }
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> verifyRazorpayPurchase(String payKey) async {
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
    Response response = await parser.verifyPurchase(payKey);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["success"];
      if (body['status'] == 'captured') {
        Get.back();
        createOrder(jsonEncode(body));
      }
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    update();
  }

  void openSuccessModal() {
    var context = Get.context as BuildContext;
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
}
