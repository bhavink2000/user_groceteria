/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class UpdatesModel {
  int? id;
  String? key;
  String? value;
  int? status;
  String? extraField;

  UpdatesModel({this.id, this.key, this.value, this.status, this.extraField});

  UpdatesModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    key = json['key'];
    value = json['value'];
    status = int.parse(json['status'].toString());
    extraField = json['extra_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['value'] = value;
    data['status'] = status;
    data['extra_field'] = extraField;
    return data;
  }
}
