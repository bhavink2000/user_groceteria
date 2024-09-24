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
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/controller/new_address_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:skeletons/skeletons.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CarouselController _controller = CarouselController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            title: Text('Checkout'.tr, style: ThemeProvider.titleStyle),
            backgroundColor: ThemeProvider.appColor,
            automaticallyImplyLeading: false,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor),
              onPressed: () {
                if (_currentIndex == 0) {
                  Get.back();
                } else if (_currentIndex == 2 && value.deliveryOrderTo == 'home') {
                  _controller.animateToPage(1);
                } else if (_currentIndex == 2 && value.deliveryOrderTo == 'store') {
                  _controller.animateToPage(0);
                } else if (_currentIndex == 1) {
                  _controller.animateToPage(0);
                }
              },
            ),
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Column(
                children: [
                  Container(
                    color: ThemeProvider.whiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: _currentIndex >= 0 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: _currentIndex >= 0 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Delivery Options'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: _currentIndex >= 0 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _currentIndex >= 0 ? ThemeProvider.appColor : ThemeProvider.blackColor))),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: _currentIndex >= 1 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: _currentIndex >= 1 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Delivery Address'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: _currentIndex >= 1 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _currentIndex >= 1 ? ThemeProvider.appColor : ThemeProvider.blackColor))),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: _currentIndex >= 2 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: _currentIndex >= 2 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Payments'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: _currentIndex >= 2 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: _buildBody(value),
          bottomNavigationBar: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                value.deliveryOrderTo == 'store' && _currentIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Note : Please visit all the stores listed on top'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red, fontSize: 10)),
                      )
                    : const SizedBox(),
                Material(
                  color: ThemeProvider.appColor,
                  child: InkWell(
                    onTap: () {
                      if (value.deliveryOrderTo == 'home' && _currentIndex == 0) {
                        value.getMyAddressList();
                        _controller.nextPage();
                      } else if (value.deliveryOrderTo == 'store' && _currentIndex == 0) {
                        value.onStoreDelivery();
                        value.getPaymentList();
                        _controller.animateToPage(2);
                      } else if (value.deliveryOrderTo == 'home' && _currentIndex == 1) {
                        value.saveDeliveryAddress(value.selectedAddressId);
                        if (value.savedAddress.id != null && value.savedAddress.address != '') {
                          value.getPaymentList();
                          _controller.nextPage();
                        }
                      } else if (_currentIndex == 2) {
                        value.onPaymentButton();
                      }
                    },
                    child: SizedBox(
                      height: kToolbarHeight,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            value.currencySide == 'left'
                                ? Text('${value.totalItems}${' Items : '.tr}${value.currencySymbol} ${value.grandTotal}',
                                    style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.whiteColor))
                                : Text('${value.totalItems}${' Items : '.tr}${value.grandTotal} ${value.currencySymbol}',
                                    style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.whiteColor)),
                            TextButton(
                              onPressed: () {
                                if (value.deliveryOrderTo == 'home' && _currentIndex == 0) {
                                  value.getMyAddressList();
                                  _controller.nextPage();
                                } else if (value.deliveryOrderTo == 'store' && _currentIndex == 0) {
                                  value.onStoreDelivery();
                                  value.getPaymentList();
                                  _controller.animateToPage(2);
                                } else if (value.deliveryOrderTo == 'home' && _currentIndex == 1) {
                                  value.saveDeliveryAddress(value.selectedAddressId);
                                  if (value.savedAddress.id != null && value.savedAddress.address != '') {
                                    value.getPaymentList();
                                    _controller.nextPage();
                                  }
                                } else if (_currentIndex == 2) {
                                  value.onPaymentButton();
                                }
                              },
                              child: Text(
                                _currentIndex != 2 ? 'Next'.tr : 'Payment'.tr,
                                style: const TextStyle(fontSize: 14, color: ThemeProvider.whiteColor),
                              ),
                            ),
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

  Widget _buildBody(value) {
    return CarouselSlider(
      options: CarouselOptions(
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
          height: double.infinity,
          viewportFraction: 1.0,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
          scrollPhysics: const NeverScrollableScrollPhysics()),
      carouselController: _controller,
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              color: ThemeProvider.whiteColor,
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [if (i == 1) _buildDeliveryOptions(context, value) else if (i == 2) _buildDeliveryAddress(context, value) else if (i == 3) _buildPayments(context, value)],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  _showPopupMenu(Offset offset, value) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        for (var item in AppConstants.deliveryTimes)
          PopupMenuItem<String>(value: item.id.toString(), onTap: () => value.saveDeliveryTime(item.name.toString(), item.id.toString()), child: Text(item.name)),
      ],
      elevation: 8.0,
    );
  }

  Widget _buildDeliveryOptions(context, value) {
    Color getColor(Set<MaterialState> states) {
      return ThemeProvider.appColor;
    }

    return Column(
      children: [
        Container(
          color: Colors.grey.shade100,
          width: double.infinity,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: Text('Delivery from'.tr, style: const TextStyle(fontFamily: 'bold'))),
        ),
        Column(
          children: [
            for (var options in AppConstants.deliveryOptions)
              ListTile(
                textColor: ThemeProvider.blackColor,
                iconColor: ThemeProvider.blackColor,
                title: Text(options.name.tr),
                leading: ClipRRect(child: SizedBox.fromSize(size: const Size.fromRadius(10), child: FittedBox(fit: BoxFit.cover, child: Image.asset(options.image)))),
                trailing: Radio(fillColor: MaterialStateProperty.resolveWith(getColor), value: options.id, groupValue: value.deliveryOrderTo, onChanged: (e) => value.saveDeliveryOrder(e)),
              )
          ],
        ),
        value.deliveryOrderTo == 'store'
            ? Container(
                color: Colors.grey.shade100,
                width: double.infinity,
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: Text('Stores'.tr, style: const TextStyle(fontFamily: 'bold'))),
              )
            : const SizedBox(),
        value.deliveryOrderTo == 'store'
            ? Column(
                children: [
                  for (var stores in value.topStores)
                    ListTile(
                      textColor: ThemeProvider.blackColor,
                      iconColor: ThemeProvider.blackColor,
                      title: Text(stores.name, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                      subtitle: Text(stores.address, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      leading: ClipRRect(child: SizedBox.fromSize(size: const Size.fromRadius(10), child: const Icon(Icons.pin_drop_outlined))),
                    )
                ],
              )
            : const SizedBox(),
        Container(
          color: Colors.grey.shade100,
          width: double.infinity,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: Text('Delivery Time'.tr, style: const TextStyle(fontFamily: 'bold'))),
        ),
        ListTile(
          title: GestureDetector(onTapDown: (TapDownDetails details) => _showPopupMenu(details.globalPosition, value), child: Text('Select Time'.tr)),
          trailing: GestureDetector(onTapDown: (TapDownDetails details) => _showPopupMenu(details.globalPosition, value), child: SizedBox(child: Text(value.selectedTime))),
        ),
        Container(
          width: double.infinity,
          color: Colors.grey.shade100,
          child: InkWell(
            onTap: () {
              if (value.isWalletChecked == false) {
                value.getCoupons(context);
              }
            },
            child: ListTile(
              textColor: ThemeProvider.appColor,
              iconColor: ThemeProvider.appColor,
              title: value.selectedCoupon != null && value.selectedCoupon!.min > 0 ? Text('Coupon Applied'.tr) : Text('Apply Coupon code'.tr),
              leading: ClipRRect(child: SizedBox.fromSize(size: const Size.fromRadius(10), child: FittedBox(fit: BoxFit.cover, child: Image.asset('assets/images/discount.png')))),
              trailing: value.selectedCoupon != null && value.selectedCoupon!.min > 0
                  ? TextButton(onPressed: () => value.clearCouponCode(), child: Text('Remove'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')))
                  : const SizedBox(),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ListTile(
            textColor: ThemeProvider.blackColor,
            iconColor: ThemeProvider.blackColor,
            title: Text('${Environments.appName} ${'Balance'.tr}', style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'bold')),
            subtitle: value.currencySide == 'left'
                ? Text('${'Available Balance '.tr + value.currencySymbol}${value.balance}', style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'regular'))
                : Text('${'Available Balance '.tr + value.balance}${value.currencySymbol}', style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'regular')),
            trailing: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: value.isWalletChecked,
              onChanged: value.balance <= 0 || value.selectedCoupon!.min > 0 ? null : (bool? status) => value.updateWalletChecked(status),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text('Item Total'.tr), value.currencySide == 'left' ? Text(value.currencySymbol + value.itemTotal.toString()) : Text(value.itemTotal.toString() + value.currencySymbol)],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Taxes & Charges'.tr),
              value.currencySide == 'left' ? Text(value.currencySymbol + value.orderTax.toString()) : Text(value.orderTax.toString() + value.currencySymbol)
            ],
          ),
        ),
        value.discount > 0
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Discount'.tr, style: const TextStyle(color: Colors.red)),
                    value.currencySide == 'left'
                        ? Text(value.currencySymbol + value.discount.toString(), style: const TextStyle(color: Colors.red))
                        : Text(value.discount.toString() + value.currencySymbol, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              )
            : const SizedBox(),
        value.balance > 0 && value.isWalletChecked == true
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Wallet Balance'.tr, style: const TextStyle(color: Colors.red)),
                    value.currencySide == 'left'
                        ? Text(value.currencySymbol + value.balance.toString(), style: const TextStyle(color: Colors.red))
                        : Text(value.balance.toString() + value.currencySymbol, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              )
            : const SizedBox(),
        value.deliveryPrice > 0 && value.deliveryOrderTo == 'home'
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Delivery Charges'.tr),
                    value.currencySide == 'left' ? Text(value.currencySymbol + value.deliveryPrice.toString()) : Text(value.deliveryPrice.toString() + value.currencySymbol),
                  ],
                ),
              )
            : const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Grand Total'.tr, style: const TextStyle(fontFamily: 'bold')),
              value.currencySide == 'left'
                  ? Text(value.currencySymbol + value.grandTotal.toString(), style: const TextStyle(fontFamily: 'bold'))
                  : Text(value.grandTotal.toString() + value.currencySymbol, style: const TextStyle(fontFamily: 'bold')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress(context, value) {
    Color getColor(Set<MaterialState> states) {
      return ThemeProvider.appColor;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Get.delete<AddNewAddressController>(force: true);
                Get.toNamed(AppRouter.getNewAddressRoutes(), arguments: ['checkout', 'create']);
              },
              icon: const Icon(Icons.add, color: Colors.black, size: 18),
              label: Text('Add Address'.tr, style: const TextStyle(color: Colors.black, fontSize: 14)),
            ),
          ),
        ),
        SingleChildScrollView(
          child: value.isAddressAPICalled == false
              ? Column(children: [SizedBox(height: 400, child: SkeletonListView())])
              : Column(
                  children: [
                    for (var item in value.listAddress)
                      ListTile(
                        textColor: ThemeProvider.blackColor,
                        iconColor: ThemeProvider.blackColor,
                        title: Text(item.title.toString().toUpperCase(), style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 14)),
                        subtitle: Text('${item.address} ${item.house} ${item.landmark} ${item.pincode}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        leading: Radio(
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: item.id.toString(),
                          groupValue: value.selectedAddressId,
                          onChanged: (e) => value.saveDeliveryAddress(e),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
        )
      ],
    );
  }

  Widget _buildPayments(context, value) {
    Color getColor(Set<MaterialState> states) {
      return ThemeProvider.appColor;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Item Total'.tr),
                value.currencySide == 'left' ? Text(value.currencySymbol + value.itemTotal.toString()) : Text(value.itemTotal.toString() + value.currencySymbol),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Taxes & Charges'.tr),
                value.currencySide == 'left' ? Text(value.currencySymbol + value.orderTax.toString()) : Text(value.orderTax.toString() + value.currencySymbol),
              ],
            ),
          ),
          value.discount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Discount'.tr, style: const TextStyle(color: Colors.red)),
                      value.currencySide == 'left'
                          ? Text(value.currencySymbol + value.discount.toString(), style: const TextStyle(color: Colors.red))
                          : Text(value.discount.toString() + value.currencySymbol, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                )
              : const SizedBox(),
          value.balance > 0 && value.isWalletChecked == true
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Wallet Balance'.tr, style: const TextStyle(color: Colors.red)),
                      value.currencySide == 'left'
                          ? Text(value.currencySymbol + value.balance.toString(), style: const TextStyle(color: Colors.red))
                          : Text(value.balance.toString() + value.currencySymbol, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                )
              : const SizedBox(),
          value.deliveryPrice > 0 && value.deliveryOrderTo == 'home'
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Delivery Charges'.tr),
                      value.currencySide == 'left' ? Text(value.currencySymbol + value.deliveryPrice.toString()) : Text(value.deliveryPrice.toString() + value.currencySymbol),
                    ],
                  ),
                )
              : const SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Grand Total'.tr, style: const TextStyle(fontFamily: 'bold')),
                value.currencySide == 'left'
                    ? Text(value.currencySymbol + value.grandTotal.toString(), style: const TextStyle(fontFamily: 'bold'))
                    : Text(value.grandTotal.toString() + value.currencySymbol, style: const TextStyle(fontFamily: 'bold')),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade100,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text('Select Payment Gateway'.tr, style: const TextStyle(fontFamily: 'bold'), textAlign: TextAlign.center),
            ),
          ),
          value.isPaymentAPICalled == false ? Column(children: [SizedBox(height: 400, child: SkeletonListView())]) : const SizedBox(),
          for (var options in value.paymentsList)
            ListTile(
              textColor: ThemeProvider.blackColor,
              iconColor: ThemeProvider.blackColor,
              title: Text(options.name),
              leading: ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(10),
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${options.cover}'),
                    placeholder: const AssetImage("assets/images/credit-card.png"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/credit-card.png', fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              trailing: Radio(
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: options.id.toString(),
                groupValue: value.selectedPaymentId,
                onChanged: (e) => value.onPaymentMethodChanged(e),
              ),
            )
        ],
      ),
    );
  }
}
