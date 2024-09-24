/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/view/account.dart';
import 'package:user/app/view/cart.dart';
import 'package:user/app/view/category.dart';
import 'package:user/app/view/history.dart';
import 'package:user/app/view/home.dart';
import 'package:get/get.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [const HomeScreen(), const CategoryScreen(), const CartScreen(), const HistoryScreen(), const AccountScreen()];
    return GetBuilder<TabsController>(
      builder: (value) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: InkWell(
                  child: (GNav(
                    rippleColor: ThemeProvider.appColor,
                    hoverColor: ThemeProvider.appColor,
                    haptic: false,
                    curve: Curves.easeOutExpo,
                    tabBorderRadius: 15,
                    textStyle: const TextStyle(fontFamily: 'bold', color: Colors.white),
                    duration: const Duration(milliseconds: 300),
                    gap: 5,
                    color: Colors.grey.shade400,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    tabs: [
                      GButton(icon: Icons.home, text: 'Home'.tr, backgroundColor: ThemeProvider.appColor),
                      GButton(icon: Icons.view_module_outlined, text: 'Categories'.tr, backgroundColor: ThemeProvider.appColor),
                      GButton(
                        icon: Icons.shopping_cart_outlined,
                        text: 'Cart'.tr,
                        backgroundColor: ThemeProvider.appColor,
                        leading: badge.Badge(
                          showBadge: value.cartTotal > 0,
                          badgeStyle: badge.BadgeStyle(badgeColor: value.tabId == 2 ? ThemeProvider.whiteColor : ThemeProvider.appColor),
                          badgeContent: Text(value.cartTotal.toString(), style: TextStyle(color: value.tabId == 2 ? ThemeProvider.appColor : ThemeProvider.whiteColor)),
                          child: Icon(Icons.add_shopping_cart, color: value.tabId == 2 ? Colors.white : Colors.grey),
                        ),
                      ),
                      GButton(icon: Icons.newspaper, text: 'History'.tr, backgroundColor: ThemeProvider.appColor),
                      GButton(icon: Icons.account_circle_outlined, text: 'Account'.tr, backgroundColor: ThemeProvider.appColor),
                    ],
                    selectedIndex: value.tabId,
                    onTabChange: (index) => value.updateTabId(index),
                  )),
                ),
              ),
            ),
            body: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: value.tabController, children: pages),
          ),
        );
      },
    );
  }
}
