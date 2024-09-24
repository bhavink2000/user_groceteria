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
import 'package:user/app/controller/order_controller.dart';
import 'package:user/app/controller/order_details_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:skeletons/skeletons.dart';
import '../util/drawer.dart' as drawer;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Get.find<OrderController>().increment();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (value) {
        return SideMenu(
          key: _sideMenuKey,
          background: ThemeProvider.secondaryAppColor,
          menu: drawer.buildMenu(_sideMenuKey),
          type: SideMenuType.shrinkNSlide, // check above images
          inverse: true,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ThemeProvider.appColor,
              automaticallyImplyLeading: false,
              elevation: 0.0,
              centerTitle: false,
              title: Text('History'.tr, style: ThemeProvider.titleStyle),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    if (_sideMenuKey.currentState!.isOpened) {
                      _sideMenuKey.currentState?.closeSideMenu();
                    } else {
                      _sideMenuKey.currentState?.openSideMenu();
                    }
                  },
                  icon: const Icon(Icons.menu),
                )
              ],
            ),
            body: value.parser.haveLoggedIn() == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(height: 80, width: 80, child: Image.asset("assets/images/nothing.png", fit: BoxFit.cover)),
                      const SizedBox(height: 30),
                      Center(child: Text('Opps, Please sign in or sign up first!'.tr, style: const TextStyle(fontFamily: 'bold'))),
                    ],
                  )
                : value.apiCalled == false && value.parser.haveLoggedIn() == true
                    ? SkeletonListView()
                    : value.ordersList.isEmpty
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
                        : RefreshIndicator(
                            onRefresh: () async => await value.hardRefresh(),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: List.generate(
                                        value.ordersList.length,
                                        (index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.delete<OrderDetailsController>(force: true);
                                              Get.toNamed(AppRouter.getOrderDetailsRoutes(), arguments: [value.ordersList[index].id]);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(top: 16),
                                              decoration: BoxDecoration(
                                                color: ThemeProvider.whiteColor,
                                                boxShadow: [BoxShadow(color: ThemeProvider.greyColor.withOpacity(0.5), spreadRadius: 2, blurRadius: 7, offset: const Offset(0, 3))],
                                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 75,
                                                    width: 75,
                                                    child: FadeInImage(
                                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.ordersList[index].orders![0].cover}'),
                                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                                      },
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text('ORDER # '.tr + value.ordersList[index].id.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: Colors.grey)),
                                                          Column(
                                                            children: List.generate(value.ordersList[index].orders!.length, (orderIndex) {
                                                              return Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: <Widget>[
                                                                    Row(
                                                                      children: value.ordersList[index].orders![orderIndex].variations == null
                                                                          ? [
                                                                              Text(
                                                                                value.ordersList[index].orders![orderIndex].name!.length > 15
                                                                                    ? '${value.ordersList[index].orders![orderIndex].name!.substring(0, 15)}...'
                                                                                    : value.ordersList[index].orders![orderIndex].name!,
                                                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                                              ),
                                                                              const Text(' - '),
                                                                              if (value.ordersList[index].orders![orderIndex].haveGram == 1)
                                                                                Text(value.ordersList[index].orders![orderIndex].gram.toString() + 'grams'.tr,
                                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                              else if (value.ordersList[index].orders![orderIndex].haveKg == 1)
                                                                                Text(value.ordersList[index].orders![orderIndex].kg.toString() + ' kg'.tr,
                                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                              else if (value.ordersList[index].orders![orderIndex].haveLiter == 1)
                                                                                Text(value.ordersList[index].orders![orderIndex].liter.toString() + ' ltr'.tr,
                                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                              else if (value.ordersList[index].orders![orderIndex].haveMl == 1)
                                                                                Text(value.ordersList[index].orders![orderIndex].ml.toString() + ' ml'.tr,
                                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                              else if (value.ordersList[index].orders![orderIndex].havePcs == 1)
                                                                                Text(value.ordersList[index].orders![orderIndex].pcs.toString() + ' pcs'.tr,
                                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start),
                                                                              const Text(' - '),
                                                                              value.ordersList[index].orders![orderIndex].discount! > 0
                                                                                  ? value.currencySide == 'left'
                                                                                      ? Text(value.currencySymbol + value.ordersList[index].orders![orderIndex].discount.toString(),
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                                      : Text(value.ordersList[index].orders![orderIndex].discount.toString() + value.currencySymbol,
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                                  : value.currencySide == 'left'
                                                                                      ? Text(value.currencySymbol + value.ordersList[index].orders![orderIndex].originalPrice.toString(),
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                                      : Text(value.ordersList[index].orders![orderIndex].originalPrice.toString() + value.currencySymbol,
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                            ]
                                                                          : [
                                                                              Text(
                                                                                value.ordersList[index].orders![orderIndex].name!.length > 15
                                                                                    ? '${value.ordersList[index].orders![orderIndex].name!.substring(0, 15)}...'
                                                                                    : value.ordersList[index].orders![orderIndex].name!,
                                                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                                              ),
                                                                              const Text(' - '),
                                                                              Text(
                                                                                  value.ordersList[index].orders![orderIndex].variations![0].items![value.ordersList[index].orders![orderIndex].variant]
                                                                                      .title
                                                                                      .toString(),
                                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                              const Text(' - '),
                                                                              value.ordersList[index].orders![orderIndex].variations![0].items![value.ordersList[index].orders![orderIndex].variant]
                                                                                          .discount! >
                                                                                      0
                                                                                  ? value.currencySide == 'left'
                                                                                      ? Text(
                                                                                          value.currencySymbol +
                                                                                              value.ordersList[index].orders![orderIndex].variations![0]
                                                                                                  .items![value.ordersList[index].orders![orderIndex].variant].discount
                                                                                                  .toString(),
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                                      : Text(
                                                                                          value.ordersList[index].orders![orderIndex].variations![0]
                                                                                                  .items![value.ordersList[index].orders![orderIndex].variant].discount
                                                                                                  .toString() +
                                                                                              value.currencySymbol,
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                                  : value.currencySide == 'left'
                                                                                      ? Text(
                                                                                          value.currencySymbol +
                                                                                              value.ordersList[index].orders![orderIndex].variations![0]
                                                                                                  .items![value.ordersList[index].orders![orderIndex].variant].price
                                                                                                  .toString(),
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                                      : Text(
                                                                                          value.ordersList[index].orders![orderIndex].variations![0]
                                                                                                  .items![value.ordersList[index].orders![orderIndex].variant].price
                                                                                                  .toString() +
                                                                                              value.currencySymbol,
                                                                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                            ],
                                                                    ),
                                                                    Text('X ${value.ordersList[index].orders![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                Text('Grand Total'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                                                value.currencySide == 'left'
                                                                    ? Text(value.currencySymbol + value.ordersList[index].grandTotal.toString(),
                                                                        style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                                                    : Text(value.ordersList[index].grandTotal.toString() + value.currencySymbol,
                                                                        style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Text(value.ordersList[index].dateTime.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'semibold')),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    value.loadMore == true ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)) : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
          ),
        );
      },
    );
  }
}
