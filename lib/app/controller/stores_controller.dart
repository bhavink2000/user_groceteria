/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/stores_model.dart';
import 'package:user/app/backend/parse/stores_parse.dart';

class StoresController extends GetxController implements GetxService {
  final StoresParser parser;
  int findType = 1;
  List<StoresModel> _stores = <StoresModel>[];
  List<StoresModel> get stores => _stores;
  bool apiCalled = false;
  StoresController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    findType = parser.getFindType();
    if (findType == 1) {
      getWithGeoLocation();
    } else if (findType == 2) {
      getWithZipcode();
    } else if (findType == 0) {
      getWithCity();
    }
  }

  void parseInfo(body) {
    if (body != null) {
      _stores = [];
      body.forEach((data) {
        StoresModel datas = StoresModel.fromJson(data);
        _stores.add(datas);
      });
    }
    update();
  }

  Future<void> getWithCity() async {
    Response response = await parser.getWithCity();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      parseInfo(body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWithZipcode() async {
    Response response = await parser.getWithZipcode();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      parseInfo(body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWithGeoLocation() async {
    Response response = await parser.getWithLatLng();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      parseInfo(body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
