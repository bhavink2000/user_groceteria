/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:jiffy/jiffy.dart';

class StoresModel {
  int? id;
  int? uid;
  String? name;
  String? mobile;
  String? email;
  String? lat;
  String? lng;
  int? verified;
  String? address;
  String? descriptions;
  String? images;
  String? cover;
  String? openTime;
  String? closeTime;
  int? isClosed;
  String? certificateUrl;
  String? certificateType;
  double? rating;
  int? totalRating;
  int? cid;
  String? zipcode;
  String? extraField;
  int? status;

  StoresModel(
      {this.id,
      this.uid,
      this.name,
      this.email,
      this.mobile,
      this.lat,
      this.lng,
      this.verified,
      this.address,
      this.descriptions,
      this.images,
      this.cover,
      this.openTime,
      this.closeTime,
      this.isClosed,
      this.certificateUrl,
      this.certificateType,
      this.rating,
      this.totalRating,
      this.cid,
      this.zipcode,
      this.extraField,
      this.status});

  StoresModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    name = json['name'];
    mobile = json['mobile'];
    lat = json['lat'];
    lng = json['lng'];
    verified = json['verified'] != null && json['verified'] != '' ? int.parse(json['verified'].toString()) : 0;
    address = json['address'];
    descriptions = json['descriptions'];
    images = json['images'];
    cover = json['cover'];
    if (json['open_time'] != null && json['open_time'] != '') {
      // ignore: prefer_interpolation_to_compose_strings
      openTime = Jiffy('2011-10-31 ' + json['open_time']).format("hh:mm a");
    } else {
      openTime = '08:00 AM';
    }
    if (json['close_time'] != null && json['close_time'] != '') {
      // ignore: prefer_interpolation_to_compose_strings
      closeTime = Jiffy('2011-10-31 ' + json['close_time']).format("hh:mm a");
    } else {
      closeTime = '10:00 PM';
    }
    isClosed = json['isClosed'] != null && json['isClosed'] != '' ? int.parse(json['isClosed'].toString()) : 0;
    certificateUrl = json['certificate_url'];
    certificateType = json['certificate_type'];
    if (json['rating'] != '' && json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString()) ?? 0.0;
    } else {
      rating = 0.0;
    }
    totalRating = json['total_rating'] != null && json['total_rating'] != '' ? int.parse(json['total_rating'].toString()) : 0;
    cid = int.parse(json['cid'].toString());
    zipcode = json['zipcode'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['name'] = name;
    data['mobile'] = mobile;
    data['lat'] = lat;
    data['lng'] = lng;
    data['verified'] = verified;
    data['address'] = address;
    data['descriptions'] = descriptions;
    data['images'] = images;
    data['cover'] = cover;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['isClosed'] = isClosed;
    data['certificate_url'] = certificateUrl;
    data['certificate_type'] = certificateType;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['cid'] = cid;
    data['zipcode'] = zipcode;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['email'] = email;
    return data;
  }
}
