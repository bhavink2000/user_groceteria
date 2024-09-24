/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/app/controller/edit_profile_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text('Edit Profile'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  child: GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoActionSheet(
                                          title: Text('Choose From'.tr),
                                          actions: <CupertinoActionSheetAction>[
                                            CupertinoActionSheetAction(
                                              child: Text('Gallery'.tr),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                value.selectFromGallery('gallery');
                                              },
                                            ),
                                            CupertinoActionSheetAction(
                                              child: Text('Camera'.tr),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                value.selectFromGallery('camera');
                                              },
                                            ),
                                            CupertinoActionSheetAction(
                                              child: Text(
                                                'Cancel'.tr,
                                                style: const TextStyle(fontFamily: 'bold', color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(40),
                                        child: value.isUploading == false
                                            ? FadeInImage(
                                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                imageErrorBuilder: (context, error, stackTrace) {
                                                  return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                                },
                                                fit: BoxFit.fitWidth,
                                              )
                                            : const CircularProgressIndicator(color: ThemeProvider.appColor, strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.firstName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'First Name'.tr,
                              contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.lastName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Last Name'.tr,
                              contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            readOnly: true,
                            controller: value.emailAddress,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email'.tr,
                              contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.mobileNumber,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Mobile No'.tr,
                              contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                        child: InkWell(
                          onTap: () => value.updateProfileData(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0)), color: ThemeProvider.appColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                value.isLogin.value == true
                                    ? const CircularProgressIndicator(color: ThemeProvider.whiteColor)
                                    : Text('Save Profile'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 17, fontFamily: 'bold')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
