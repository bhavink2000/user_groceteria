/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class BannersModel {
  int? id;
  int? cityId;
  String? cover;
  int? position;
  String? link;
  int? type;
  String? message;
  String? extraField;
  String? from;
  String? to;
  int? status;

  BannersModel({this.id, this.cityId, this.cover, this.position, this.link, this.type, this.message, this.extraField, this.from, this.to, this.status});

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    cityId = int.parse(json['city_id'].toString());
    cover = json['cover'];
    position = int.parse(json['position'].toString());
    link = json['link'];
    type = int.parse(json['type'].toString());
    message = json['message'];
    extraField = json['extra_field'];
    from = json['from'];
    to = json['to'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city_id'] = cityId;
    data['cover'] = cover;
    data['position'] = position;
    data['link'] = link;
    data['type'] = type;
    data['message'] = message;
    data['extra_field'] = extraField;
    data['from'] = from;
    data['to'] = to;
    data['status'] = status;
    return data;
  }
}
