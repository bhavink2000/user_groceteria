/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class CouponCodeModel {
  int? id;
  String? name;
  double? off;
  String? type;
  int? upto;
  late double min;
  String? from;
  String? to;
  String? dateTime;
  String? descriptions;
  String? image;
  int? manage;
  String? storeId;
  int? status;
  String? extraField;

  CouponCodeModel(
      {this.id, this.name, this.off, this.type, this.upto, this.min = 0, this.from, this.to, this.dateTime, this.descriptions, this.image, this.manage, this.storeId, this.status, this.extraField});

  CouponCodeModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    if (json['off'] != '' && json['off'] != null) {
      off = double.tryParse(json['off'].toString()) ?? 0.0;
    } else {
      off = 0.0;
    }
    type = json['type'];
    upto = int.parse(json['upto'].toString());
    if (json['min'] != '' && json['min'] != null) {
      min = double.tryParse(json['min'].toString()) ?? 0.0;
    } else {
      min = 0.0;
    }
    from = json['from'];
    to = json['to'];
    dateTime = json['date_time'];
    descriptions = json['descriptions'];
    image = json['image'];
    manage = int.parse(json['manage'].toString());
    storeId = json['store_id'];
    status = int.parse(json['status'].toString());
    extraField = json['extra_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['off'] = off;
    data['type'] = type;
    data['upto'] = upto;
    data['min'] = min;
    data['from'] = from;
    data['to'] = to;
    data['date_time'] = dateTime;
    data['descriptions'] = descriptions;
    data['image'] = image;
    data['manage'] = manage;
    data['store_id'] = storeId;
    data['status'] = status;
    data['extra_field'] = extraField;
    return data;
  }
}
