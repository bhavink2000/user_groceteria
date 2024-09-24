/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/google_address_model.dart';
import 'package:user/app/backend/parse/new_address_parse.dart';
import 'package:user/app/controller/address_controller.dart';
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/toast.dart';

class AddNewAddressController extends GetxController implements GetxService {
  final AddNewAddressParser parser;
  String title = '';
  String requestFrom = 'newAddress';
  bool isNew = true;
  final location = TextEditingController();
  final house = TextEditingController();
  final landmark = TextEditingController();
  final pincode = TextEditingController();
  String addressTitle = 'home';
  String addressId = '';
  RxBool isLogin = false.obs;
  AddNewAddressController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    String action = Get.arguments[1];
    requestFrom = Get.arguments[0];
    if (action == 'create') {
      title = 'Add New Address'.tr;
    } else {
      isNew = false;
      addressId = Get.arguments[2].toString();
      location.text = Get.arguments[3].toString();
      house.text = Get.arguments[4].toString();
      landmark.text = Get.arguments[5].toString();
      pincode.text = Get.arguments[6].toString();
      addressTitle = Get.arguments[7].toString();
      title = 'Update Address'.tr;
    }
    update();
  }

  Future<void> submitData(context) async {
    if (location.text == '' || house.text == '' || landmark.text == '' || pincode.text == '') {
      showToast('All fields are required');
      return;
    }
    isLogin.value = !isLogin.value;
    update();
    var response = await parser
        .getLatLngFromAddress('https://maps.googleapis.com/maps/api/geocode/json?address=${location.text} ${house.text} ${landmark.text}${pincode.text}&key=${Environments.googleMapsKeys}');
    debugPrint(response.bodyString);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      GoogleAddresModel address = GoogleAddresModel.fromJson(myMap);
      debugPrint(address.toString());
      if (address.results!.isNotEmpty) {
        debugPrint('ok');
        if (isNew == true) {
          debugPrint('create');
          saveAddress(address.results![0].geometry!.location!.lat.toString(), address.results![0].geometry!.location!.lng.toString(), context);
        } else {
          debugPrint('update');
          updateAddress(address.results![0].geometry!.location!.lat.toString(), address.results![0].geometry!.location!.lng.toString(), context);
        }
      } else {
        isLogin.value = !isLogin.value;
        showToast("could not determine your location");
        update();
      }
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> saveAddress(String lat, String lng, context) async {
    Response response = await parser.saveAddress(location.text, house.text, landmark.text, pincode.text, lat, lng, addressTitle);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body['id'] != '' && body['id'] != '') {
        isLogin.value = !isLogin.value;
        update();
        successToast('Address saved');
        if (requestFrom == 'newAddress') {
          Get.find<AddressController>().getMyList();
        } else if (requestFrom == 'checkout') {
          Get.find<CheckoutController>().getMyAddressList();
        }
        Navigator.pop(context);
      }
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> updateAddress(String lat, String lng, context) async {
    Response response = await parser.updateAddress(location.text, house.text, landmark.text, pincode.text, lat, lng, addressTitle, addressId);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      update();
      successToast('Address Updated'.tr);
      if (requestFrom == 'newAddress') {
        Get.find<AddressController>().getMyList();
      } else {}
      Navigator.pop(context);
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
  }
}
