/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class CheckoutParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CheckoutParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getStoreList(var ids) async {
    return await apiService.postPrivate(AppConstants.cartStoreList, {'id': ids}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getCouponsList() async {
    return await apiService.getPublic(AppConstants.getCouponsList);
  }

  Future<Response> getPaymentList() async {
    return await apiService.getPrivate(AppConstants.getPaymentsList, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getMyAddressList() async {
    return await apiService.postPrivate(AppConstants.getMyAddress, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> createOrder(var param) async {
    return await apiService.postPrivate(AppConstants.createOrder, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> sendOrderMail(var param) async {
    return await apiService.postPrivate(AppConstants.sendMailOrder, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getInstaMojoPayLink(var param) async {
    return await apiService.postPrivate(AppConstants.payWithInstaMojo, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getMyWalletBalance() async {
    return await apiService.postPrivate(AppConstants.getMyWalletBalance, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  String getPhone() {
    return sharedPreferencesManager.getString('phone') ?? '';
  }

  String getSupportEmail() {
    return sharedPreferencesManager.getString('supportEmail') ?? '';
  }

  String getSupportPhone() {
    return sharedPreferencesManager.getString('supportPhone') ?? '';
  }

  String getName() {
    String firstName = sharedPreferencesManager.getString('firstName') ?? '';
    String lastName = sharedPreferencesManager.getString('lastName') ?? '';
    return '$firstName $lastName';
  }

  String getFirstName() {
    return sharedPreferencesManager.getString('firstName') ?? '';
  }

  String getLastName() {
    return sharedPreferencesManager.getString('lastName') ?? '';
  }

  String getAppLogo() {
    return sharedPreferencesManager.getString('appLogo') ?? '';
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ?? AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ?? AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ?? AppConstants.defaultCurrencySymbol;
  }

  double shippingPrice() {
    return sharedPreferencesManager.getDouble('shippingPrice') ?? 0.0;
  }

  String getShippingMethod() {
    return sharedPreferencesManager.getString('shipping') ?? AppConstants.defaultShippingMethod;
  }

  double freeOrderPrice() {
    return sharedPreferencesManager.getDouble('free') ?? 0.0;
  }
}
