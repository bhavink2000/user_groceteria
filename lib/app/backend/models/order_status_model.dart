/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class OrderStatusModel {
  int? id;
  String? status;

  OrderStatusModel({this.id, this.status});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != '' && json['id'] != null) {
      id = int.tryParse(json['id'].toString()) ?? 1;
    } else {
      id = 1;
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}
