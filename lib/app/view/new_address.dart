/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/new_address_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewAddressController>(
      builder: (value) {
        Color getColor(Set<MaterialState> states) {
          return ThemeProvider.appColor;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            title: Text(value.title, style: ThemeProvider.titleStyle),
          ),
          body: AbsorbPointer(
            absorbing: value.isLogin.value == false ? false : true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: value.location,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Location'.tr,
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: value.house,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'House / Flat No'.tr,
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: value.landmark,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Landmark'.tr,
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: value.pincode,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Pincode'.tr,
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Save As'.tr.toUpperCase(), textAlign: TextAlign.start, style: const TextStyle(fontFamily: 'bold')),
                        ),
                        ListTile(
                          textColor: ThemeProvider.blackColor,
                          iconColor: ThemeProvider.blackColor,
                          title: Text('Home'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                          leading: const Icon(Icons.home_outlined),
                          trailing: Radio(
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: 'home',
                            groupValue: value.addressTitle,
                            onChanged: (e) {
                              setState(() {
                                value.addressTitle = e.toString();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          textColor: ThemeProvider.blackColor,
                          iconColor: ThemeProvider.blackColor,
                          title: Text('Work'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                          leading: const Icon(Icons.work_outline),
                          trailing: Radio(
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: 'work',
                            groupValue: value.addressTitle,
                            onChanged: (e) {
                              setState(() {
                                value.addressTitle = e.toString();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          textColor: ThemeProvider.blackColor,
                          iconColor: ThemeProvider.blackColor,
                          title: Text('Other'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                          leading: const Icon(Icons.other_houses_outlined),
                          trailing: Radio(
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: 'other',
                            groupValue: value.addressTitle,
                            onChanged: (e) {
                              setState(() {
                                value.addressTitle = e.toString();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                          child: InkWell(
                            onTap: () => value.submitData(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 13.0),
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: ThemeProvider.appColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  value.isLogin.value == true
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text('Submit'.tr, style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'bold')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
