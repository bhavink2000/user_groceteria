/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:user/app/backend/models/products_model.dart';

class OrderDetailsModel {
  int? id;
  List<ProductsModel>? order;
  double? orderItemTotal;
  double? orderDiscount;
  double? shippingPrice;
  double? orderWalletDiscount;
  double? orderTaxAmount;
  String? storeName;
  String? orderStatus;
  double? toPay;

  OrderDetailsModel({this.id, this.order, this.orderItemTotal, this.orderDiscount, this.shippingPrice, this.orderWalletDiscount, this.orderTaxAmount, this.storeName, this.orderStatus, this.toPay});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    if (json['order'] != null) {
      order = json['order'];
    }
    orderItemTotal = double.parse(json['orderItemTotal'].toString());
    orderDiscount = double.parse(json['orderDiscount'].toString());
    shippingPrice = double.parse(json['shippingPrice'].toString());
    orderWalletDiscount = double.parse(json['orderWalletDiscount'].toString());
    orderTaxAmount = double.parse(json['orderTaxAmount'].toString());
    storeName = json['storeName'];
    orderStatus = json['orderStatus'];
    toPay = double.parse(json['toPay'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order'] = order;
    data['orderItemTotal'] = orderItemTotal;
    data['orderDiscount'] = orderDiscount;
    data['shippingPrice'] = shippingPrice;
    data['orderWalletDiscount'] = orderWalletDiscount;
    data['orderTaxAmount'] = orderTaxAmount;
    data['storeName'] = storeName;
    data['orderStatus'] = orderStatus;
    data['toPay'] = toPay;
    return data;
  }
}
