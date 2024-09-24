/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class GeneralModel {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;
  double? min;
  double? free;
  double? tax;
  String? shipping;
  double? shippingPrice;
  int? status;
  String? extraField;

  GeneralModel(
      {this.id,
      this.name,
      this.mobile,
      this.email,
      this.address,
      this.city,
      this.state,
      this.zip,
      this.country,
      this.min,
      this.free,
      this.tax,
      this.shipping,
      this.shippingPrice,
      this.status,
      this.extraField});

  GeneralModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    if (json['min'] != '' && json['min'] != null) {
      min = double.tryParse(json['min'].toString()) ?? 0.0;
    } else {
      min = 0.0;
    }
    if (json['free'] != '' && json['free'] != null) {
      free = double.tryParse(json['free'].toString()) ?? 0.0;
    } else {
      free = 0.0;
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
    status = int.parse(json['status'].toString());
    extraField = json['extra_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['country'] = country;
    data['min'] = min;
    data['free'] = free;
    data['tax'] = tax;
    data['shipping'] = shipping;
    data['shippingPrice'] = shippingPrice;
    data['status'] = status;
    data['extra_field'] = extraField;
    return data;
  }
}
