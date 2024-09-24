/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class AddressModel {
  int? id;
  int? uid;
  String? title;
  String? address;
  String? house;
  String? landmark;
  String? pincode;
  String? lat;
  String? lng;
  String? extraField;
  int? status;

  AddressModel({this.id, this.uid, this.title, this.address, this.house, this.landmark, this.pincode, this.lat, this.lng, this.extraField, this.status});

  AddressModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null && json['id'] != '') {
      id = int.parse(json['id'].toString());
    } else {
      id = 0;
    }
    if (json['uid'] != null && json['uid'] != '') {
      uid = int.parse(json['uid'].toString());
    } else {
      uid = 0;
    }
    if (json['title'] != null && json['title'] != '') {
      title = json['title'];
    } else {
      title = '';
    }
    if (json['address'] != null && json['address'] != '') {
      address = json['address'];
    } else {
      address = '';
    }
    if (json['house'] != null && json['house'] != '') {
      house = json['house'];
    } else {
      house = '';
    }
    if (json['landmark'] != null && json['landmark'] != '') {
      landmark = json['landmark'];
    } else {
      landmark = '';
    }
    if (json['pincode'] != null && json['pincode'] != '') {
      pincode = json['pincode'];
    } else {
      pincode = '';
    }
    if (json['lat'] != null && json['lat'] != '') {
      lat = json['lat'];
    } else {
      lat = '';
    }
    if (json['lng'] != null && json['lng'] != '') {
      lng = json['lng'];
    } else {
      lng = '';
    }
    if (json['extra_field'] != null && json['extra_field'] != '') {
      extraField = json['extra_field'];
    } else {
      extraField = '';
    }
    if (json['status'] != null && json['status'] != '') {
      status = int.parse(json['status'].toString());
    } else {
      status = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['title'] = title;
    data['address'] = address;
    data['house'] = house;
    data['landmark'] = landmark;
    data['pincode'] = pincode;
    data['lat'] = lat;
    data['lng'] = lng;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
