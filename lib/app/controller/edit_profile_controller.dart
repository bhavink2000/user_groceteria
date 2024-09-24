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
import 'package:user/app/backend/parse/edit_profile_parse.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/util/toast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController implements GetxService {
  final EditProfileParser parser;
  XFile? _selectedImage;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailAddress = TextEditingController();
  final mobileNumber = TextEditingController();
  String cover = '';
  bool apiCalled = false;
  bool isUploading = false;
  RxBool isLogin = false.obs;
  EditProfileController({required this.parser});
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    Response response = await parser.getProfile();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body != null && body != '') {
        firstName.text = body['first_name'] ?? '';
        lastName.text = body['last_name'] ?? '';
        emailAddress.text = body['email'] ?? '';
        mobileNumber.text = body['mobile'] ?? '';
        cover = body['cover'] ?? '';
        update();
      }
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void selectFromGallery(String kind) async {
    _selectedImage = await ImagePicker().pickImage(source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera, imageQuality: 25);
    update();
    if (_selectedImage != null) {
      Response response = await parser.uploadImage(_selectedImage as XFile);
      if (response.statusCode == 200) {
        _selectedImage = null;
        if (response.body['data'] != null && response.body['data'] != '') {
          dynamic body = response.body["data"];
          if (body['image_name'] != null && body['image_name'] != '') {
            isUploading = true;
            update();
            var param = {'cover': body['image_name'], 'id': parser.getUID()};
            Response response = await parser.updateProfile(param);
            isUploading = false;
            if (response.statusCode == 200) {
              cover = body['image_name'];
              parser.saveInfo(firstName.text, lastName.text, cover, mobileNumber.text);
              Get.find<AccountController>().changeInfo();
              update();
            } else {
              ApiChecker.checkApi(response);
              update();
            }
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  Future<void> updateProfileData() async {
    if (firstName.text == '' || lastName.text == '' || mobileNumber.text == '') {
      showToast('All fields are required'.tr);
      return;
    }
    isLogin.value = !isLogin.value;
    update();

    var param = {'cover': cover, 'first_name': firstName.text, 'last_name': lastName.text, 'mobile': mobileNumber.text, 'id': parser.getUID()};
    Response response = await parser.updateProfile(param);
    isLogin.value = !isLogin.value;
    if (response.statusCode == 200) {
      successToast('Profile Updated'.tr);
      parser.saveInfo(firstName.text, lastName.text, cover, mobileNumber.text);
      Get.find<AccountController>().changeInfo();
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }
}
