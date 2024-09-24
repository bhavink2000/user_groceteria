/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class StoreChargesModel {
  int? storeId;
  double? distance;
  double? tax;
  String? shipping;
  double? shippingPrice;

  StoreChargesModel({this.storeId, this.distance, this.tax, this.shipping, this.shippingPrice});

  StoreChargesModel.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    if (json['distance'] != '' && json['distance'] != null) {
      distance = double.tryParse(json['distance'].toString()) ?? 0.0;
    } else {
      distance = 0.0;
    }
    if (json['tax'] != '' && json['tax'] != null) {
      tax = double.tryParse(json['tax'].toString()) ?? 0.0;
    } else {
      tax = 0.0;
    }
    shipping = json['shipping'];
    if (json['shippingPrice'] != '' && json['shippingPrice'] != null) {
      shippingPrice = double.tryParse(json['shippingPrice'].toString()) ?? 0.0;
    } else {
      shippingPrice = 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['distance'] = distance;
    data['tax'] = tax;
    data['shipping'] = shipping;
    data['shippingPrice'] = shippingPrice;
    return data;
  }
}
