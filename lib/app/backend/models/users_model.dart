/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class UsersModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? address;
  String? date;
  int? city;
  String? cover;
  String? lat;
  String? lng;
  int? gender;
  int? verified;
  String? fcmToken;
  String? current;
  String? others;
  String? stripeKey;
  String? extraField;
  int? status;

  UsersModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.mobile,
      this.address,
      this.date,
      this.city,
      this.cover,
      this.lat,
      this.lng,
      this.gender,
      this.verified,
      this.fcmToken,
      this.current,
      this.others,
      this.stripeKey,
      this.extraField,
      this.status});

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    address = json['address'];
    date = json['date'];
    city = int.parse(json['city'].toString());
    cover = json['cover'];
    lat = json['lat'];
    lng = json['lng'];
    gender = int.parse(json['gender'].toString());
    if (json['verified'] != null && json['verified'] != '') {
      verified = int.parse(json['verified'].toString());
    } else {
      verified = 1;
    }
    fcmToken = json['fcm_token'];
    current = json['current'];
    others = json['others'];
    stripeKey = json['stripe_key'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['address'] = address;
    data['date'] = date;
    data['city'] = city;
    data['cover'] = cover;
    data['lat'] = lat;
    data['lng'] = lng;
    data['gender'] = gender;
    data['verified'] = verified;
    data['fcm_token'] = fcmToken;
    data['current'] = current;
    data['others'] = others;
    data['stripe_key'] = stripeKey;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
