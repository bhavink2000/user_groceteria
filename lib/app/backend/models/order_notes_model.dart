/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class OrderNotesModel {
  int? status;
  String? value;
  String? time;

  OrderNotesModel({this.status, this.value, this.time});

  OrderNotesModel.fromJson(Map<String, dynamic> json) {
    status = int.parse(json['status'].toString());
    value = json['value'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['value'] = value;
    data['time'] = time;
    return data;
  }
}
