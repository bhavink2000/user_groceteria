/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/location_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return ThemeProvider.whiteColor;
    }

    return GetBuilder<LocationController>(
      builder: (value) {
        return Scaffold(
          body: Column(
            children: [
              if (value.findType == 1)
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ThemeProvider.appColor, ThemeProvider.secondaryAppColor])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 300, width: 300, child: ClipPath(child: ClipRRect(child: Image.asset('assets/images/location.png', fit: BoxFit.fill)))),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text('Enable Location'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontFamily: 'semi-bold', color: ThemeProvider.whiteColor)),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Set your location to start exploring grocery stores around you'.tr,
                                style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.whiteColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.all(20),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Text('Location Permission'.tr, style: const TextStyle(fontSize: 24, fontFamily: 'bold')),
                                            const SizedBox(height: 10),
                                            Text('You have to grand background location permission'.tr, style: const TextStyle(fontFamily: 'semi-bold', fontSize: 18)),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
                                                  .tr,
                                              style: const TextStyle(fontFamily: 'semi-bold', fontSize: 14),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'If the permission is rejected, then you have to manually go to the settings to enable it'.tr,
                                              style: const TextStyle(fontFamily: 'semi-bold', fontSize: 18),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      value.getLocation();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: ThemeProvider.whiteColor,
                                                      backgroundColor: ThemeProvider.greyColor,
                                                      minimumSize: const Size.fromHeight(35),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    ),
                                                    child: Text('Deny'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16)),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      value.getLocation();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: ThemeProvider.whiteColor,
                                                      backgroundColor: ThemeProvider.appColor,
                                                      minimumSize: const Size.fromHeight(35),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    ),
                                                    child: Text('Continue'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: ThemeProvider.appColor,
                                backgroundColor: ThemeProvider.whiteColor,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(width: 5),
                                  Text('Use Current Location'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              else if (value.findType == 2)
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ThemeProvider.appColor, ThemeProvider.secondaryAppColor])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: value.zipCodeTxt,
                              decoration: InputDecoration(
                                labelText: 'Enter Zipcode'.tr,
                                fillColor: ThemeProvider.whiteColor,
                                filled: true,
                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ThemeProvider.secondaryAppColor)),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ThemeProvider.appColor)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Set your zipcode to start exploring grocery stores around you'.tr,
                                style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.whiteColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () => value.saveZipcode(),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: ThemeProvider.appColor,
                                backgroundColor: ThemeProvider.whiteColor,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Submit'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 16))]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              else if (value.findType == 0)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ThemeProvider.appColor, ThemeProvider.secondaryAppColor])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Select your city to start exploring grocery stores around you'.tr,
                          style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.whiteColor),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            if (value.apiCalled == false)
                              // ignore: unused_local_variable
                              for (var item in [1, 2, 3, 4, 5, 6])
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    children: [
                                      const SkeletonAvatar(style: SkeletonAvatarStyle(shape: BoxShape.circle, width: 20, height: 20)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SkeletonParagraph(
                                          style: SkeletonParagraphStyle(
                                            lines: 1,
                                            spacing: 6,
                                            lineStyle: SkeletonLineStyle(
                                              randomLength: true,
                                              height: 10,
                                              borderRadius: BorderRadius.circular(8),
                                              minLength: MediaQuery.of(context).size.width / 6,
                                              maxLength: MediaQuery.of(context).size.width / 3,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            else
                              for (var city in value.list)
                                ListTile(
                                  textColor: ThemeProvider.whiteColor,
                                  iconColor: ThemeProvider.whiteColor,
                                  title: Text(city.name.toString(), style: const TextStyle(color: ThemeProvider.whiteColor)),
                                  leading: Radio(
                                    fillColor: MaterialStateProperty.resolveWith(getColor),
                                    value: city.id.toString(),
                                    groupValue: value.cityId,
                                    onChanged: (e) => value.saveCityId(city.id.toString(), city.name.toString()),
                                  ),
                                )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      value.cityId != '0'
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () => value.saveCityAndNavigate(),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: ThemeProvider.appColor,
                                  backgroundColor: ThemeProvider.whiteColor,
                                  elevation: 0,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Select'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 16))]),
                              ),
                            )
                          : const SizedBox(height: 10),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
