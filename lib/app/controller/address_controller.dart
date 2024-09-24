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
import 'package:user/app/backend/models/address_model.dart';
import 'package:user/app/backend/parse/address_parse.dart';
import 'package:user/app/util/theme.dart';

class AddressController extends GetxController implements GetxService {
  final AddressParser parser;
  bool apiCalled = false;
  List<AddressModel> _list = <AddressModel>[];
  List<AddressModel> get list => _list;
  RxBool isLogin = false.obs;

  AddressController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getMyList();
  }

  Future<void> getMyList() async {
    Response response = await parser.getMyList();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _list = [];
      body.forEach((data) {
        AddressModel datas = AddressModel.fromJson(data);
        _list.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void openConfirmButton(int id) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        title: Text('Confirm'.tr),
        content: Text("Are you sure to delete this?".tr),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium'))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteAddress(context, id);
            },
            child: Text('Yes, Delete'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
          )
        ],
      ),
    );
  }

  Future<void> deleteAddress(context, int id) async {
    Response response = await parser.deleteItem(id);
    if (response.statusCode == 200) {
      getMyList();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
