/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/order_details_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            title: Text('ORDER # '.tr + value.orderId.toString(), style: ThemeProvider.titleStyle),
            actions: <Widget>[
              IconButton(onPressed: () => value.launchInBrowser(), icon: const Icon(Icons.print_outlined)),
              IconButton(onPressed: () => value.openHelpModal(), icon: const Icon(Icons.question_mark_outlined))
            ],
          ),
          bottomNavigationBar: value.canCancel == true || value.isDelivered == true
              ? Material(
                  color: ThemeProvider.appColor,
                  child: SizedBox(
                    height: kToolbarHeight,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          value.isDelivered == true
                              ? TextButton(
                                  onPressed: () => value.openRatingModal(),
                                  child: Text('Rate Order'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.whiteColor)),
                                )
                              : TextButton(
                                  onPressed: () => value.cancelOrder(),
                                  child: Text('Cancel Order'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.whiteColor)),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          decoration: bottomBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Orders'.tr, style: boldText()),
                              TextButton(onPressed: () => value.openOrderBillingInfo(), child: Text('More Details'.tr, style: const TextStyle(color: Colors.black, fontFamily: 'bold')))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: List.generate(value.orderDetails.length, (index) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: bottomBorder(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(value.orderDetails[index].storeName.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'bold')),
                                      Text(value.orderDetails[index].orderStatus.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'bold')),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: List.generate(
                                    value.orderDetails[index].order!.length,
                                    (orderIndex) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: value.orderDetails[index].order![orderIndex].variations == null
                                                  ? [
                                                      Text(
                                                          value.orderDetails[index].order![orderIndex].name!.length > 25
                                                              ? '${value.orderDetails[index].order![orderIndex].name!.substring(0, 25)}...'
                                                              : value.orderDetails[index].order![orderIndex].name!,
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                      const Text(' - '),
                                                      if (value.orderDetails[index].order![orderIndex].haveGram == 1)
                                                        Text(value.orderDetails[index].order![orderIndex].gram.toString() + ' grams'.tr,
                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                      else if (value.orderDetails[index].order![orderIndex].haveKg == 1)
                                                        Text(value.orderDetails[index].order![orderIndex].kg.toString() + ' kg'.tr,
                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                      else if (value.orderDetails[index].order![orderIndex].haveLiter == 1)
                                                        Text(value.orderDetails[index].order![orderIndex].liter.toString() + ' ltr'.tr,
                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                      else if (value.orderDetails[index].order![orderIndex].haveMl == 1)
                                                        Text(value.orderDetails[index].order![orderIndex].ml.toString() + ' ml'.tr,
                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                      else if (value.orderDetails[index].order![orderIndex].havePcs == 1)
                                                        Text(value.orderDetails[index].order![orderIndex].pcs.toString() + ' pcs'.tr,
                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start),
                                                      const Text(' - '),
                                                      value.orderDetails[index].order![orderIndex].discount! > 0
                                                          ? value.currencySide == 'left'
                                                              ? Text(value.currencySymbol + value.orderDetails[index].order![orderIndex].discount.toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              : Text(value.orderDetails[index].order![orderIndex].discount.toString() + value.currencySymbol,
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                          : value.currencySide == 'left'
                                                              ? Text(value.currencySymbol + value.orderDetails[index].order![orderIndex].originalPrice.toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              : Text(value.orderDetails[index].order![orderIndex].originalPrice.toString() + value.currencySymbol,
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                    ]
                                                  : [
                                                      Text(
                                                        value.orderDetails[index].order![orderIndex].name!.length > 25
                                                            ? '${value.orderDetails[index].order![orderIndex].name!.substring(0, 25)}...'
                                                            : value.orderDetails[index].order![orderIndex].name!,
                                                        style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                      ),
                                                      const Text(' - '),
                                                      Text(value.orderDetails[index].order![orderIndex].variations![0].items![value.orderDetails[index].order![orderIndex].variant].title.toString(),
                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                      const Text(' - '),
                                                      value.orderDetails[index].order![orderIndex].variations![0].items![value.orderDetails[index].order![orderIndex].variant].discount! > 0
                                                          ? value.currencySide == 'left'
                                                              ? Text(
                                                                  value.currencySymbol +
                                                                      value.orderDetails[index].order![orderIndex].variations![0].items![value.orderDetails[index].order![orderIndex].variant].discount
                                                                          .toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              : Text(
                                                                  value.orderDetails[index].order![orderIndex].variations![0].items![value.orderDetails[index].order![orderIndex].variant].discount
                                                                          .toString() +
                                                                      value.currencySymbol,
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                          : value.currencySide == 'left'
                                                              ? Text(
                                                                  value.currencySymbol +
                                                                      value.orderDetails[index].order![orderIndex].variations![0].items![value.orderDetails[index].order![orderIndex].variant].price
                                                                          .toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              : Text(
                                                                  value.orderDetails[index].order![orderIndex].variations![0].items![value.orderDetails[index].order![orderIndex].variant].price
                                                                          .toString() +
                                                                      value.currencySymbol,
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                    ],
                                            ),
                                            Text('X ${value.orderDetails[index].order![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: bottomBorder(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Amount to Pay'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                      value.currencySide == 'left'
                                          ? Text(value.currencySymbol + value.orderDetails[index].toPay.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                          : Text(value.orderDetails[index].toPay.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Deliver to'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 12)),
                              Text(value.details.orderTo.toString().toUpperCase(), style: const TextStyle(fontFamily: 'bold'))
                            ],
                          ),
                        ),
                        value.details.orderTo == 'home'
                            ? Text(
                                '${value.details.address!.landmark.toString().toUpperCase()} ${value.details.address!.house.toString().toUpperCase()} ${value.details.address!.address.toString().toUpperCase()} ${value.details.address!.pincode.toString().toUpperCase()}',
                                style: const TextStyle(fontFamily: 'bold', fontSize: 12))
                            : const SizedBox(),
                        Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Basic Detail'.tr, style: boldText())),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text('Order ID'.tr, style: greyFont()), Text(value.details.id.toString(), style: darkFont())],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text('Payment Method'.tr, style: greyFont()), Text(value.details.paidMethod == 'cod' ? 'COD'.tr : 'PAID'.tr, style: darkFont())],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text('Delivery On'.tr, style: greyFont()), Text(value.details.dateTime.toString(), style: darkFont())],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Order Tracking'.tr, style: boldText())),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              value.details.notes!.length,
                              (index) {
                                return TimelineTile(
                                  alignment: TimelineAlign.start,
                                  lineXY: 0.1,
                                  isFirst: index == 0 ? true : false,
                                  indicatorStyle: const IndicatorStyle(width: 5, color: ThemeProvider.greyColor, padding: EdgeInsets.all(6)),
                                  endChild: getContentOfTracking(value.details.notes![index].value.toString().tr, value.details.notes![index].time.toString()),
                                  beforeLineStyle: const LineStyle(color: ThemeProvider.greyColor),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Stores Information'.tr, style: boldText())),
                        for (var item in value.stores)
                          InkWell(
                            onTap: () => value.openActionModalStore(item.name.toString(), item.email.toString(), item.mobile.toString(), item.uid.toString(), true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      ClipRRect(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(30),
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                            },
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(item.name.toString(), style: boldText()),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.mail, size: 17), const SizedBox(width: 5), Text(item.email.toString())]),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.call, size: 17), const SizedBox(width: 5), Text(item.mobile.toString())]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  value.getStoreOrderStatus(item.uid) == 'ongoing' || value.getStoreOrderStatus(item.uid) == 'accepted'
                                      ? IconButton(onPressed: () => value.trackOrderWithStore(item.uid), icon: const Icon(Icons.near_me_sharp, color: ThemeProvider.orangeColor))
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        value.driversList.isNotEmpty
                            ? Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Drivers Information'.tr, style: boldText()))
                            : const SizedBox(),
                        for (var item in value.driversList)
                          InkWell(
                            onTap: () => value.openActionModalStore('${item.firstName} ${item.lastName}', item.email.toString(), item.mobile.toString(), item.id.toString(), false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      ClipRRect(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(30),
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                            },
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('${item.firstName} ${item.lastName}', style: boldText()),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.mail, size: 17), const SizedBox(width: 5), Text(item.email.toString())]),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.call, size: 17), const SizedBox(width: 5), Text(item.mobile.toString())]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  value.getDriverOrderStatus(item.id) == 'ongoing' || value.getDriverOrderStatus(item.id) == 'accepted'
                                      ? IconButton(onPressed: () => value.trackOrderWithDriver(item.id), icon: const Icon(Icons.near_me_sharp, color: ThemeProvider.orangeColor))
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget getContentOfTracking(String title, String message) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: const TextStyle(color: Color(0xFF636564), fontSize: 12, fontFamily: 'bold')),
              const SizedBox(height: 6),
              Text(message, style: const TextStyle(color: Color(0xFF636564), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  bottomBorder() {
    return BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ThemeProvider.greyColor.shade300)));
  }

  boldText() {
    return const TextStyle(fontSize: 14, fontFamily: 'bold');
  }

  greyFont() {
    return const TextStyle(color: Colors.grey, fontSize: 12);
  }

  darkFont() {
    return const TextStyle(fontFamily: 'bold', fontSize: 12);
  }
}
