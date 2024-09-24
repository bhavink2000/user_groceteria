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
import 'package:user/app/controller/stripe_pay_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class StripePayScreen extends StatefulWidget {
  const StripePayScreen({Key? key}) : super(key: key);

  @override
  State<StripePayScreen> createState() => _StripePayScreenState();
}

class _StripePayScreenState extends State<StripePayScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return ThemeProvider.appColor;
    }

    return GetBuilder<StripePayController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            title: Text('Pay with Stripe'.tr, style: ThemeProvider.titleStyle),
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
                            onPressed: () => Get.toNamed(AppRouter.getNewCardStripeRoutes()),
                            icon: const Icon(Icons.add, color: Colors.black, size: 18),
                            label: Text('Add New Card'.tr, style: const TextStyle(color: Colors.black, fontSize: 14)),
                          ),
                        ),
                      ),
                      value.cardsListCalled == false ? Column(children: [SizedBox(height: 400, child: SkeletonListView())]) : const SizedBox(),
                      for (var item in value.cards)
                        ListTile(
                          textColor: ThemeProvider.blackColor,
                          iconColor: ThemeProvider.blackColor,
                          title: Text('XXXX XXXX XXXX ${item.last4.toString().toUpperCase()}', style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                          subtitle: Text('${'Expiry '.tr}${item.expMonth} / ${item.expYear}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          trailing: Radio(
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: item.id.toString(),
                            groupValue: value.selectedCard,
                            onChanged: (e) => value.saveCardToPay(e.toString()),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
          bottomNavigationBar: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  color: ThemeProvider.appColor,
                  child: InkWell(
                    onTap: () => value.createPayment(),
                    child: SizedBox(
                      height: kToolbarHeight,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            value.currencySide == 'left'
                                ? Text('Payment '.tr + value.currencySymbol + value.grandTotal.toString(), style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.whiteColor))
                                : Text('Payment '.tr + value.grandTotal.toString() + value.currencySymbol, style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.whiteColor)),
                          ],
                        ),
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
