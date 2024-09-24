/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/address_controller.dart';
import 'package:user/app/controller/new_address_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String selected = '';
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            title: Text('Address'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () {
                              Get.delete<AddNewAddressController>(force: true);
                              Get.toNamed(AppRouter.getNewAddressRoutes(), arguments: ['newAddress', 'create']);
                            },
                            icon: const Icon(Icons.add, color: Colors.black, size: 18),
                            label: Text('Add Address'.tr, style: const TextStyle(color: Colors.black, fontSize: 14)),
                          ),
                        ),
                      ),
                      value.list.isEmpty
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
                          : const SizedBox(),
                      for (var item in value.list)
                        ListTile(
                          textColor: ThemeProvider.blackColor,
                          iconColor: ThemeProvider.blackColor,
                          title: Text(item.title.toString().toUpperCase(), style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                          subtitle: Text('${item.address} ${item.house} ${item.landmark} ${item.pincode}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Get.delete<AddNewAddressController>(force: true);
                                  Get.toNamed(AppRouter.getNewAddressRoutes(), arguments: [
                                    'newAddress',
                                    'edit',
                                    item.id.toString(),
                                    item.address.toString(),
                                    item.house.toString(),
                                    item.landmark.toString(),
                                    item.pincode.toString(),
                                    item.title.toString()
                                  ]);
                                },
                                child: const Icon(Icons.edit, color: Colors.blue),
                              ),
                              GestureDetector(onTap: () => value.openConfirmButton(item.id as int), child: const Icon(Icons.delete, color: Colors.red))
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
