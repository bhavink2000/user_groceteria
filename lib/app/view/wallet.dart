/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/wallet_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            backgroundColor: ThemeProvider.appColor,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            centerTitle: false,
            title: Text('Wallet'.tr, style: ThemeProvider.titleStyle),
            bottom: value.apiCalled == true
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      width: double.infinity,
                      color: ThemeProvider.whiteColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: value.currencySide == 'left'
                                ? Text('${value.currencySymbol}${value.amount}', style: const TextStyle(fontSize: 20, fontFamily: 'bold', color: ThemeProvider.appColor))
                                : Text('${value.amount}${value.currencySymbol}', style: const TextStyle(fontSize: 20, fontFamily: 'bold', color: ThemeProvider.appColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text('All Transactions'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.appColor)),
                          ),
                          Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ThemeProvider.appColor))))
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var item in value.transactions)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.type.toString().toUpperCase(), textAlign: TextAlign.start, style: const TextStyle(fontFamily: 'bold', fontSize: 12)),
                                  Text(item.uuid.toString(), textAlign: TextAlign.start, style: const TextStyle(fontFamily: 'regular', fontSize: 10))
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  value.currencySide == 'left'
                                      ? Text('${value.currencySymbol}${item.amount}', style: const TextStyle(fontSize: 12, fontFamily: 'bold'))
                                      : Text('${item.amount}${value.currencySymbol}', style: const TextStyle(fontSize: 12, fontFamily: 'bold')),
                                  Text(item.createdAt.toString(), textAlign: TextAlign.end, style: const TextStyle(fontFamily: 'regular', fontSize: 10))
                                ],
                              ),
                            ],
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
