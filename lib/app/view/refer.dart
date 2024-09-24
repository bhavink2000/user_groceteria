/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/refer_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({Key? key}) : super(key: key);

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text('Refer & Earns'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : value.haveReferral == false
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(height: 80, width: 80, child: Image.asset("assets/images/nothing.png", fit: BoxFit.cover)),
                          const SizedBox(height: 30),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      ClipRRect(child: SizedBox.fromSize(size: const Size.fromRadius(70), child: FittedBox(fit: BoxFit.cover, child: Image.asset('assets/images/gift.png')))),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          value.referralData.title.toString(),
                                          maxLines: 4,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'bold', fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          value.referralData.message.toString(),
                                          maxLines: 4,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'regular', fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(value.myCode.toString(), style: const TextStyle(fontSize: 17))),
                                  InkWell(
                                    onTap: () => value.copyToClipBoard(),
                                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Icon(Icons.copy)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                              child: ElevatedButton(
                                onPressed: () => value.share(),
                                style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                child: Text('Invite Friends'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
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
