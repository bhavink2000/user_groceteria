/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/city_model.dart';
import 'package:user/app/backend/parse/location_parse.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController implements GetxService {
  final LocationParser parser;

  int findType = 0;
  bool apiCalled = false;

  List<CityModel> _list = <CityModel>[];
  List<CityModel> get list => _list;
  var cityId = '0';

  final zipCodeTxt = TextEditingController();

  LocationController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    findType = parser.getFindType();
    if (findType == 0) {
      getActiveCities();
    }
  }

  Future<void> getActiveCities() async {
    Response response = await parser.getActiveCities();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _list = [];
      body.forEach((data) {
        CityModel datas = CityModel.fromJson(data);
        _list.add(datas);
      });
    } else {
      apiCalled = true;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveCityId(var id, var name) {
    cityId = id;
    parser.saveCity(cityId, name);
    update();
  }

  void saveCityAndNavigate() {
    Get.offNamed(AppRouter.getTabsRoute());
  }

  void getLocation() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Featching Location".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    _determinePosition().then((value) async {
      Get.back();
      debugPrint(value.toString());
      List<Placemark> newPlace = await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark placeMark = newPlace[0];
      String name = placeMark.name.toString();
      String subLocality = placeMark.subLocality.toString();
      String locality = placeMark.locality.toString();
      String administrativeArea = placeMark.administrativeArea.toString();
      String postalCode = placeMark.postalCode.toString();
      String country = placeMark.country.toString();
      String address = "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";

      parser.saveLatLng(value.latitude.toString(), value.longitude.toString(), address.toString());
      debugPrint(address.toString());
      Get.offNamed(AppRouter.getTabsRoute());
    }).catchError((error) async {
      Get.back();
      debugPrint(error.toString());
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.'.tr);
    }
    return await Geolocator.getCurrentPosition();
  }

  void saveZipcode() {
    if (zipCodeTxt.text == '') {
      showToast('Please enter your zipcode');
      return;
    }
    parser.saveZipcode(zipCodeTxt.text);
    Get.offNamed(AppRouter.getTabsRoute());
  }
}
