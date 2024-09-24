/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class SettingsModel {
  int? id;
  String? currencySymbol;
  String? currencySide;
  String? currencyCode;
  String? appDirection;
  String? logo;
  String? smsName;
  int? delivery;
  int? findType;
  int? makeOrders;
  int? resetPwd;
  int? userLogin;
  int? storeLogin;
  int? userVerifyWith;
  int? driverLogin;
  int? webLogin;
  int? loginStyle;
  int? registerStyle;
  int? homePageStyleApp;
  String? countryModal;
  String? webCategory;
  String? defaultCountryCode;
  String? defaultCityId;
  String? defaultDeliveryZip;
  String? social;
  String? appColor;
  int? appStatus;
  int? driverAssign;
  String? extraField;
  int? status;

  SettingsModel(
      {this.id,
      this.currencySymbol,
      this.currencySide,
      this.currencyCode,
      this.appDirection,
      this.logo,
      this.smsName,
      this.delivery,
      this.findType,
      this.makeOrders,
      this.resetPwd,
      this.userLogin,
      this.storeLogin,
      this.userVerifyWith,
      this.driverLogin,
      this.webLogin,
      this.loginStyle,
      this.registerStyle,
      this.homePageStyleApp,
      this.countryModal,
      this.webCategory,
      this.defaultCountryCode,
      this.defaultCityId,
      this.defaultDeliveryZip,
      this.social,
      this.appColor,
      this.appStatus,
      this.driverAssign,
      this.extraField,
      this.status});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    currencySymbol = json['currencySymbol'];
    currencySide = json['currencySide'];
    currencyCode = json['currencyCode'];
    appDirection = json['appDirection'];
    logo = json['logo'];
    smsName = json['sms_name'];
    delivery = int.parse(json['delivery'].toString());
    findType = int.parse(json['findType'].toString());
    makeOrders = int.parse(json['makeOrders'].toString());
    resetPwd = int.parse(json['reset_pwd'].toString());
    userLogin = int.parse(json['user_login'].toString());
    storeLogin = int.parse(json['store_login'].toString());
    userVerifyWith = int.parse(json['user_verify_with'].toString());
    driverLogin = int.parse(json['driver_login'].toString());
    webLogin = int.parse(json['web_login'].toString());
    loginStyle = int.parse(json['login_style'].toString());
    registerStyle = int.parse(json['register_style'].toString());
    homePageStyleApp = int.parse(json['home_page_style_app'].toString());
    countryModal = json['country_modal'];
    webCategory = json['web_category'];
    defaultCountryCode = json['default_country_code'];
    defaultCityId = json['default_city_id'];
    defaultDeliveryZip = json['default_delivery_zip'];
    social = json['social'];
    appColor = json['app_color'];
    appStatus = int.parse(json['app_status'].toString());
    driverAssign = int.parse(json['driver_assign'].toString());
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currencySymbol'] = currencySymbol;
    data['currencySide'] = currencySide;
    data['currencyCode'] = currencyCode;
    data['appDirection'] = appDirection;
    data['logo'] = logo;
    data['sms_name'] = smsName;
    data['delivery'] = delivery;
    data['findType'] = findType;
    data['makeOrders'] = makeOrders;
    data['reset_pwd'] = resetPwd;
    data['user_login'] = userLogin;
    data['store_login'] = storeLogin;
    data['user_verify_with'] = userVerifyWith;
    data['driver_login'] = driverLogin;
    data['web_login'] = webLogin;
    data['login_style'] = loginStyle;
    data['register_style'] = registerStyle;
    data['home_page_style_app'] = homePageStyleApp;
    data['country_modal'] = countryModal;
    data['web_category'] = webCategory;
    data['default_country_code'] = defaultCountryCode;
    data['default_city_id'] = defaultCityId;
    data['default_delivery_zip'] = defaultDeliveryZip;
    data['social'] = social;
    data['app_color'] = appColor;
    data['app_status'] = appStatus;
    data['driver_assign'] = driverAssign;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
