/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

import 'package:user/app/backend/models/address_model.dart';
import 'package:user/app/backend/models/driver_assignment_model.dart';
import 'package:user/app/backend/models/order_notes_model.dart';
import 'package:user/app/backend/models/order_status_model.dart';
import 'package:user/app/backend/models/products_model.dart';
import 'package:user/app/backend/models/store_charges_model.dart';

class OrdersModel {
  int? id;
  int? uid;
  String? storeId;
  String? dateTime;
  String? paidMethod;
  String? orderTo;
  List<ProductsModel>? orders;
  List<OrderNotesModel>? notes;
  AddressModel? address;
  String? driverId;
  List<DriverAssignmentModel>? assignee;
  double? total;
  double? tax;
  double? grandTotal;
  double? discount;
  double? deliveryCharge;
  int? walletUsed;
  double? walletPrice;
  String? couponCode;
  List<StoreChargesModel>? extra;
  String? payKey;
  List<OrderStatusModel>? status;
  int? payStatus;
  String? extraField;

  OrdersModel(
      {this.id,
      this.uid,
      this.storeId,
      this.dateTime,
      this.paidMethod,
      this.orderTo,
      this.orders,
      this.notes,
      this.address,
      this.driverId,
      this.assignee,
      this.total,
      this.tax,
      this.grandTotal,
      this.discount,
      this.deliveryCharge,
      this.walletUsed,
      this.walletPrice,
      this.couponCode,
      this.extra,
      this.payKey,
      this.status,
      this.payStatus,
      this.extraField});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    storeId = json['store_id'];
    dateTime = json['date_time'];
    paidMethod = json['paid_method'];
    orderTo = json['order_to'];
    if (json['orders'] != null && json['orders'] != '') {
      orders = [];
      var listItems = jsonDecode(json['orders']);
      if (listItems.isNotEmpty) {
        listItems.forEach((data) {
          if (data['variations'] != null && data['variations'] != '' && data['variations'].runtimeType != String && data['variations'].runtimeType == List) {
            data['variations'] = jsonEncode(data['variations']);
          }
          ProductsModel datas = ProductsModel.fromJson(data);

          orders?.add(datas);
        });
      }
    } else {
      orders = null;
    }
    if (json['notes'] != null && json['notes'] != '') {
      notes = [];
      var listItems = jsonDecode(json['notes']);
      if (listItems.isNotEmpty) {
        listItems.forEach((data) {
          OrderNotesModel dataInfo = OrderNotesModel.fromJson(data);
          notes?.add(dataInfo);
        });
      }
    } else {
      notes = null;
    }
    if (json['address'] != null && json['address'] != '') {
      AddressModel addressInfo = AddressModel.fromJson(jsonDecode(json['address']));
      address = addressInfo;
    } else {
      address = json['address'];
    }
    driverId = json['driver_id'];
    if (json['assignee'] != null && json['assignee'] != '') {
      assignee = [];
      var listItems = jsonDecode(json['assignee']);
      if (listItems.isNotEmpty) {
        listItems.forEach((data) {
          DriverAssignmentModel info = DriverAssignmentModel.fromJson(data);
          assignee?.add(info);
        });
      }
    } else {
      assignee = [];
    }
    total = double.parse(json['total'].toString());
    tax = double.parse(json['tax'].toString());
    grandTotal = double.parse(json['grand_total'].toString());
    discount = double.parse(json['discount'].toString());
    deliveryCharge = double.parse(json['delivery_charge'].toString());
    walletUsed = int.parse(json['wallet_used'].toString());
    walletPrice = double.parse(json['wallet_price'].toString());
    couponCode = json['coupon_code'];
    if (json['extra'] != null && json['extra'] != '') {
      extra = [];
      var listItems = jsonDecode(json['extra']);
      if (listItems.isNotEmpty) {
        listItems.forEach((data) {
          StoreChargesModel datas = StoreChargesModel.fromJson(data);
          extra?.add(datas);
        });
      }
    } else {
      extra = null;
    }
    payKey = json['pay_key'];
    if (json['status'] != null && json['status'] != '') {
      status = [];
      var listItems = jsonDecode(json['status']);
      if (listItems.isNotEmpty) {
        listItems.forEach((data) {
          OrderStatusModel datas = OrderStatusModel.fromJson(data);
          status?.add(datas);
        });
      }
    } else {
      status = null;
    }
    payStatus = int.parse(json['payStatus'].toString());
    extraField = json['extra_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['store_id'] = storeId;
    data['date_time'] = dateTime;
    data['paid_method'] = paidMethod;
    data['order_to'] = orderTo;
    data['orders'] = orders;
    data['notes'] = notes;
    data['address'] = address;
    data['driver_id'] = driverId;
    data['assignee'] = assignee;
    data['total'] = total;
    data['tax'] = tax;
    data['grand_total'] = grandTotal;
    data['discount'] = discount;
    data['delivery_charge'] = deliveryCharge;
    data['wallet_used'] = walletUsed;
    data['wallet_price'] = walletPrice;
    data['coupon_code'] = couponCode;
    data['extra'] = extra;
    data['pay_key'] = payKey;
    data['status'] = status;
    data['payStatus'] = payStatus;
    data['extra_field'] = extraField;
    return data;
  }
}
