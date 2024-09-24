/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/new_card_controller.dart';
import 'package:user/app/util/theme.dart';

class NewCardScreen extends StatefulWidget {
  const NewCardScreen({Key? key}) : super(key: key);

  @override
  State<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewCardController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            title: Text('Add New Card'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : AbsorbPointer(
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
                                      controller: value.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Email Address'.tr,
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
                                      controller: value.cardName,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Card Holder Name'.tr,
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
                                      controller: value.cardNumber,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [CreditCardNumberInputFormatter()],
                                      decoration: InputDecoration(
                                        labelText: 'Card Number'.tr,
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
                                      controller: value.cvcNumber,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [CreditCardCvcInputFormatter()],
                                      decoration: InputDecoration(
                                        labelText: 'CVC'.tr,
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
                                      controller: value.expireNumber,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [CreditCardExpirationDateFormatter()],
                                      decoration: InputDecoration(
                                        labelText: 'MM/YY'.tr,
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
                                            : Text('Add Card'.tr, style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'bold')),
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
