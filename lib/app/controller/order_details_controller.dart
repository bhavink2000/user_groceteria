/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/order_details_model.dart';
import 'package:user/app/backend/models/order_model.dart';
import 'package:user/app/backend/models/order_notes_model.dart';
import 'package:user/app/backend/models/stores_model.dart';
import 'package:user/app/backend/models/users_model.dart';
import 'package:user/app/backend/parse/order_details_parser.dart';
import 'package:user/app/controller/complaints_controller.dart';
import 'package:user/app/controller/give_reviews_controller.dart';
import 'package:user/app/controller/inbox_controller.dart';
import 'package:user/app/controller/track_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsController extends GetxController implements GetxService {
  final OrderDetailsParser parser;
  int orderId = 0;
  bool apiCalled = false;

  List<StoresModel> _stores = <StoresModel>[];
  List<StoresModel> get stores => _stores;

  OrdersModel _details = OrdersModel();
  OrdersModel get details => _details;

  List<OrderDetailsModel> _orderDetails = <OrderDetailsModel>[];
  List<OrderDetailsModel> get orderDetails => _orderDetails;

  List<UsersModel> _driversList = <UsersModel>[];
  List<UsersModel> get driversList => _driversList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  String invoiceURL = '';

  bool canCancel = false;
  bool isDelivered = false;

  OrderDetailsController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    orderId = Get.arguments[0] ?? 1;
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    invoiceURL = '${parser.apiService.appBaseUrl}${AppConstants.getInvoice}$orderId&token=${parser.getToken()}';
    update();
    getOrderDetails();
  }

  Future<void> getOrderDetails() async {
    Response response = await parser.getOrderDetails(orderId);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic orderInfo = myMap["data"];
      OrdersModel datas = OrdersModel.fromJson(orderInfo);
      datas.dateTime = Jiffy(datas.dateTime).yMMMMEEEEdjm;
      _details = datas;
      dynamic storeInfo = myMap["storeInfo"];
      if (storeInfo != null) {
        _stores = [];
        storeInfo.forEach((data) {
          StoresModel datas = StoresModel.fromJson(data);
          _stores.add(datas);
        });
      }
      List statusLength = details.status!.where((element) => element.status == 'created').toList();
      if (statusLength.length == details.status!.length) {
        canCancel = true;
        update();
      }

      List statusLengthRating = details.status!.where((element) => element.status == 'delivered').toList();
      if (statusLengthRating.length == details.status!.length) {
        isDelivered = true;
        update();
      }

      debugPrint(canCancel.toString());
      debugPrint(isDelivered.toString());
      List storeIds = _details.storeId!.split(',');
      storeIds = storeIds.map((e) => int.parse(e)).toList();
      _orderDetails = [];
      for (var data in storeIds) {
        var orderItem = details.orders!.where((element) => element.storeId == data).toList();
        var orderStatus = details.status!.firstWhereOrNull((element) => element.id == data)?.status;
        var storeName = stores.firstWhereOrNull((element) => element.uid == data)?.name;
        double total = 0.0;
        for (var element in orderItem) {
          if (element.discount! == 0) {
            if (element.size == 1) {
              if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                total = total + element.variations![0].items![element.variant].discount! * element.quantity;
              } else {
                total = total + element.variations![0].items![element.variant].price! * element.quantity;
              }
            } else {
              total = total + element.originalPrice! * element.quantity;
            }
          } else {
            if (element.size == 1) {
              if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                total = total + element.variations![0].items![element.variant].discount! * element.quantity;
              } else {
                total = total + element.variations![0].items![element.variant].price! * element.quantity;
              }
            } else {
              total = total + element.sellPrice! * element.quantity;
            }
          }
        }
        double discount = 0.0;
        double walletPrice = 0.0;
        if (details.discount! > 0) {
          discount = details.discount! / storeIds.length;
        }
        if (details.walletPrice! > 0) {
          walletPrice = details.walletPrice! / storeIds.length;
        }
        double deliveryCharge = 0.0;
        if (details.orderTo == 'home') {
          var charge = details.extra!.firstWhereOrNull((element) => element.storeId == data);
          if (charge?.shipping == 'km') {
            deliveryCharge = double.parse((charge?.distance)!.toStringAsFixed(2)) * double.parse((charge?.shippingPrice)!.toStringAsFixed(2));
          } else {
            deliveryCharge = double.parse((charge?.shippingPrice)!.toStringAsFixed(2)) / storeIds.length;
          }
        }
        dynamic driverInfo = myMap['driverInfo'];
        if (driverInfo != null && driverInfo != '') {
          _driversList = [];
          if (driverInfo.length > 0) {
            driverInfo.forEach((element) {
              UsersModel driverData = UsersModel.fromJson(element);
              _driversList.add(driverData);
            });
            debugPrint(driversList.length.toString());
          }
        }
        var taxAmount = details.extra!.firstWhereOrNull((element) => element.storeId == data)?.tax;
        double grandTotal = total + deliveryCharge + taxAmount!;
        double removeDiscount = discount + walletPrice;
        double amountToPay = grandTotal - removeDiscount;
        // double
        var param = {
          "id": data,
          "order": orderItem,
          "orderItemTotal": double.parse((total).toStringAsFixed(2)),
          "orderDiscount": double.parse((discount).toStringAsFixed(2)),
          "shippingPrice": double.parse((deliveryCharge).toStringAsFixed(2)),
          "orderWalletDiscount": double.parse((walletPrice).toStringAsFixed(2)),
          "orderTaxAmount": double.parse((taxAmount).toStringAsFixed(2)),
          "storeName": storeName,
          "orderStatus": orderStatus,
          "toPay": amountToPay > 0 ? double.parse((amountToPay).toStringAsFixed(2)) : 0
        };
        _orderDetails.add(OrderDetailsModel.fromJson(param));
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> launchInBrowser() async {
    var url = Uri.parse(invoiceURL);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void openHelpModal() {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Choose'.tr),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text('Chat'.tr),
            onPressed: () {
              Navigator.pop(context);
              onChat(parser.getAdminId().toString(), parser.getAdminName());
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Complaints'.tr),
            onPressed: () {
              Navigator.pop(context);
              Get.delete<ComplaintsController>(force: true);
              Get.toNamed(AppRouter.getComplaintsRoutes(), arguments: [orderId]);
            },
          ),
          CupertinoActionSheetAction(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  void openActionModalStore(String name, String email, String phone, String uid, bool canChat) {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('${'Contact'.tr} $name'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Email'.tr),
            onPressed: () {
              Navigator.pop(context);
              composeEmail(email);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Call'.tr),
            onPressed: () {
              Navigator.pop(context);
              makePhoneCall(phone);
            },
          ),
          canChat == true
              ? CupertinoActionSheetAction(
                  child: Text('Message'.tr),
                  onPressed: () {
                    Navigator.pop(context);
                    onChat(uid, name);
                  },
                )
              : const SizedBox(),
          CupertinoActionSheetAction(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> composeEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    await launchUrl(launchUri);
  }

  void onChat(String uid, String name) {
    Get.delete<InboxController>(force: true);
    Get.toNamed(AppRouter.getInboxRoutes(), arguments: [uid, name]);
  }

  void openOrderBillingInfo() {
    var context = Get.context as BuildContext;
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Billing Information'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold')), IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, size: 14))],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  orderDetails.length,
                  (index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(orderDetails[index].storeName.toString(), style: const TextStyle(fontSize: 14, fontFamily: 'bold')),
                              Text(orderDetails[index].orderStatus.toString(), style: const TextStyle(fontSize: 14, fontFamily: 'bold')),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                            orderDetails[index].order!.length,
                            (orderIndex) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: orderDetails[index].order![orderIndex].variations == null
                                          ? [
                                              Text(
                                                orderDetails[index].order![orderIndex].name.toString(),
                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                              ),
                                              const Text(' - '),
                                              if (orderDetails[index].order![orderIndex].haveGram == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].gram.toString() + ' grams'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].haveKg == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].kg.toString() + ' kg'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].haveLiter == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].liter.toString() + ' ltr'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].haveMl == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].ml.toString() + ' ml'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].havePcs == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].pcs.toString() + ' pcs'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                              const Text(' - '),
                                              orderDetails[index].order![orderIndex].discount! > 0
                                                  ? currencySide == 'left'
                                                      ? Text(currencySymbol + orderDetails[index].order![orderIndex].discount.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(orderDetails[index].order![orderIndex].discount.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                  : currencySide == 'left'
                                                      ? Text(currencySymbol + orderDetails[index].order![orderIndex].originalPrice.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(orderDetails[index].order![orderIndex].originalPrice.toString() + currencySymbol,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                            ]
                                          : [
                                              Text(
                                                orderDetails[index].order![orderIndex].name.toString(),
                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                              ),
                                              const Text(' - '),
                                              Text(orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].title.toString(),
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                              const Text(' - '),
                                              orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].discount! > 0
                                                  ? currencySide == 'left'
                                                      ? Text(
                                                          currencySymbol +
                                                              orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].discount.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(
                                                          orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].discount.toString() +
                                                              currencySymbol,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                  : currencySide == 'left'
                                                      ? Text(
                                                          currencySymbol +
                                                              orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].price.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(
                                                          orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].price.toString() +
                                                              currencySymbol,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                            ],
                                    ),
                                    Text('X ${orderDetails[index].order![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Order Item Total'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].orderItemTotal.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                                  : Text(orderDetails[index].orderItemTotal.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Order Delivery Charge'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].shippingPrice.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                                  : Text(orderDetails[index].shippingPrice.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Split Order Tax'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].orderTaxAmount.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                                  : Text(orderDetails[index].orderTaxAmount.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Split Order Discount'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].orderDiscount.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                                  : Text(orderDetails[index].orderDiscount.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Split Order Discount'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].orderDiscount.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                                  : Text(orderDetails[index].orderDiscount.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Split Order Wallet Discount'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].orderWalletDiscount.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                                  : Text(orderDetails[index].orderWalletDiscount.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.blackColor))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Amount to Pay'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.appColor)),
                              currencySide == 'left'
                                  ? Text(currencySymbol + orderDetails[index].toPay.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.appColor))
                                  : Text(orderDetails[index].toPay.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.appColor))
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bottomBorder() {
    return BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ThemeProvider.greyColor.shade300)));
  }

  void openRatingModal() {
    var context = Get.context as BuildContext;
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Rate Order'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold')), IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, size: 14))],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  orderDetails.length,
                  (index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(orderDetails[index].storeName.toString(), style: const TextStyle(fontSize: 14, fontFamily: 'bold')),
                              InkWell(
                                onTap: () {
                                  debugPrint(orderDetails[index].id.toString());
                                  Get.delete<GiveReviewsController>(force: true);
                                  Get.toNamed(AppRouter.getGiveReviewsRoutes(), arguments: ['store', orderDetails[index].id, orderDetails[index].storeName]);
                                },
                                child: const Icon(Icons.star_outline, color: ThemeProvider.orangeColor),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: List.generate(
                            orderDetails[index].order!.length,
                            (orderIndex) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: orderDetails[index].order![orderIndex].variations == null
                                          ? [
                                              Text(orderDetails[index].order![orderIndex].name.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                              const Text(' - '),
                                              if (orderDetails[index].order![orderIndex].haveGram == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].gram.toString() + ' grams'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].haveKg == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].kg.toString() + ' kg'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].haveLiter == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].liter.toString() + ' ltr'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].haveMl == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].ml.toString() + ' ml'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                )
                                              else if (orderDetails[index].order![orderIndex].havePcs == 1)
                                                Text(
                                                  orderDetails[index].order![orderIndex].pcs.toString() + ' pcs'.tr,
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                              const Text(' - '),
                                              orderDetails[index].order![orderIndex].discount! > 0
                                                  ? currencySide == 'left'
                                                      ? Text(currencySymbol + orderDetails[index].order![orderIndex].discount.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(orderDetails[index].order![orderIndex].discount.toString() + currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                  : currencySide == 'left'
                                                      ? Text(currencySymbol + orderDetails[index].order![orderIndex].originalPrice.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(orderDetails[index].order![orderIndex].originalPrice.toString() + currencySymbol,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                            ]
                                          : [
                                              Text(orderDetails[index].order![orderIndex].name.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                              const Text(' - '),
                                              Text(orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].title.toString(),
                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                              const Text(' - '),
                                              orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].discount! > 0
                                                  ? currencySide == 'left'
                                                      ? Text(
                                                          currencySymbol +
                                                              orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].discount.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(
                                                          orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].discount.toString() +
                                                              currencySymbol,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                  : currencySide == 'left'
                                                      ? Text(
                                                          currencySymbol +
                                                              orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].price.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : Text(
                                                          orderDetails[index].order![orderIndex].variations![0].items![orderDetails[index].order![orderIndex].variant].price.toString() +
                                                              currencySymbol,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                            ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.delete<GiveReviewsController>(force: true);
                                        Get.toNamed(AppRouter.getGiveReviewsRoutes(), arguments: ['product', orderDetails[index].order![orderIndex].id, orderDetails[index].order![orderIndex].name]);
                                      },
                                      child: const Icon(Icons.star_outline, color: ThemeProvider.orangeColor),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        driversList.isNotEmpty
                            ? Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Rate Driver'.tr, style: boldText()))
                            : const SizedBox(),
                        const SizedBox(height: 20),
                        for (var item in driversList)
                          InkWell(
                            onTap: () {
                              Get.delete<GiveReviewsController>(force: true);
                              Get.toNamed(AppRouter.getGiveReviewsRoutes(), arguments: ['driver', item.id, '${item.firstName} ${item.lastName}']);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(30),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                        },
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${item.firstName} ${item.lastName}', style: boldText()),
                                        const SizedBox(height: 5),
                                        Row(children: <Widget>[const Icon(Icons.mail, size: 17), const SizedBox(width: 5), Text(item.email.toString())]),
                                        const SizedBox(height: 5),
                                        Row(children: <Widget>[const Icon(Icons.call, size: 17), const SizedBox(width: 5), Text(item.mobile.toString())]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void cancelOrder() {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        title: Text('Are you sure?'.tr),
        content: Text("to cancel this order?".tr),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium'))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updateOrderStatus();
            },
            child: Text('Yes, Cancel Order'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
          )
        ],
      ),
    );
  }

  Future<void> updateOrderStatus() async {
    var orderNotesParam = {'status': 1, 'value': 'Order cancelled by you', 'time': Jiffy().format('MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    _details.notes!.add(orderNotesParse);
    for (var item in _details.status!) {
      if (item.status == 'created') {
        item.status = 'cancelled';
      }
    }
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Updating Order".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    var param = {'id': orderId, 'notes': jsonEncode(details.notes), 'status': jsonEncode(details.status), 'order_status': 'cancelled'};
    Response response = await parser.updateOrderStatus(param);
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body == true) {
        successToast('Status Updated');
        onBack();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  boldText() {
    return const TextStyle(fontSize: 14, fontFamily: 'bold');
  }

  String getStoreOrderStatus(var uid) {
    var status = details.status!.firstWhere((element) => element.id.toString() == uid.toString()).status;
    return status ?? '';
  }

  String getDriverOrderStatus(var id) {
    var uid = details.assignee!.firstWhere((element) => element.driver.toString() == id.toString()).assignee;
    var status = details.status!.firstWhere((element) => element.id.toString() == uid.toString()).status;
    return status ?? '';
  }

  void trackOrderWithStore(var uid) {
    var store = _stores.firstWhere((element) => element.uid.toString() == uid.toString());
    var amount = _orderDetails.firstWhere((element) => element.id.toString() == uid.toString()).toPay;
    Get.delete<TrackingController>(force: true);
    Get.toNamed(AppRouter.getTrackingRoutes(), arguments: [
      'store', //0
      store.name, // 1
      store.address, //2
      store.cover, // 3
      store.lat, // 4
      store.lng, // 5
      store.mobile, // 6
      amount, // 7
      details.paidMethod // 8
    ]);
  }

  void trackOrderWithDriver(var id) {
    debugPrint(id.toString());
    var driver = _driversList.firstWhere((element) => element.id.toString() == id.toString());
    var uid = details.assignee!.firstWhere((element) => element.driver.toString() == id.toString()).assignee;
    var amount = _orderDetails.firstWhere((element) => element.id.toString() == uid.toString()).toPay;
    Get.delete<TrackingController>(force: true);
    Get.toNamed(AppRouter.getTrackingRoutes(), arguments: [
      'driver', // 0
      driver.id, // 1
      '${driver.firstName!} ${driver.lastName}', // 2
      driver.cover, // 3
      driver.lat, // 4
      driver.lng, // 5
      _details.address!.lat, // 6
      _details.address!.lng, // 7
      driver.mobile, // 8
      amount, // 9
      details.paidMethod // 10
    ]);
  }
}
