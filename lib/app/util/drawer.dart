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
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/chat_list_controller.dart';
import 'package:user/app/controller/contact_controller.dart';
import 'package:user/app/controller/refer_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/controller/wallet_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';

Widget buildMenu(sideMenuKey) {
  return GetBuilder<AccountController>(
    builder: (value) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(30),
                        child: value.haveAccount == true
                            ? FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                placeholder: const AssetImage("assets/images/logo.png"),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth);
                                },
                                fit: BoxFit.fitWidth,
                              )
                            : FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                placeholder: const AssetImage("assets/images/logo.png"),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth);
                                },
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    value.haveAccount == true ? Text(value.name.toString(), style: const TextStyle(color: ThemeProvider.whiteColor)) : const SizedBox(),
                    SizedBox(height: value.haveAccount == true ? 10 : 0),
                    const Text(Environments.appName, style: TextStyle(color: ThemeProvider.whiteColor)),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsController>().updateTabId(0);
              },
              leading: const Icon(Icons.home, size: 20.0, color: ThemeProvider.whiteColor),
              title: Text('Home'.tr),
              textColor: ThemeProvider.whiteColor,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsController>().updateTabId(3);
              },
              leading: const Icon(Icons.newspaper, size: 20.0, color: ThemeProvider.whiteColor),
              title: Text('Orders'.tr),
              textColor: ThemeProvider.whiteColor,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsController>().updateTabId(4);
              },
              leading: const Icon(Icons.account_circle_outlined, size: 20.0, color: ThemeProvider.whiteColor),
              title: Text('Profile'.tr),
              textColor: ThemeProvider.whiteColor,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.toNamed(AppRouter.getLanguagesRoute());
              },
              leading: const Icon(Icons.translate, size: 20.0, color: ThemeProvider.whiteColor),
              title: Text('Languages'.tr),
              textColor: ThemeProvider.whiteColor,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.delete<ContactController>(force: true);
                Get.toNamed(AppRouter.getContactRoutes());
              },
              leading: const Icon(Icons.attach_email_outlined, size: 20.0, color: ThemeProvider.whiteColor),
              title: Text('Contact Us'.tr),
              textColor: ThemeProvider.whiteColor,
              dense: true,
            ),
            value.haveAccount == true
                ? ListTile(
                    onTap: () {
                      if (sideMenuKey.currentState!.isOpened) {
                        sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        sideMenuKey.currentState?.openSideMenu();
                      }
                      Get.delete<ChatListController>(force: true);
                      Get.toNamed(AppRouter.getChatListRoutes());
                    },
                    leading: const Icon(Icons.wechat_outlined, size: 20.0, color: ThemeProvider.whiteColor),
                    title: Text('Chats'.tr),
                    textColor: ThemeProvider.whiteColor,
                    dense: true,
                  )
                : const SizedBox(),
            value.haveAccount == true
                ? ListTile(
                    onTap: () {
                      if (sideMenuKey.currentState!.isOpened) {
                        sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        sideMenuKey.currentState?.openSideMenu();
                      }
                      Get.delete<WalletController>(force: true);
                      Get.toNamed(AppRouter.getWalletRoutes());
                    },
                    leading: const Icon(Icons.account_balance_wallet_outlined, size: 20.0, color: ThemeProvider.whiteColor),
                    title: Text('Wallet'.tr),
                    textColor: ThemeProvider.whiteColor,
                    dense: true,
                  )
                : const SizedBox(),
            value.haveAccount == true
                ? ListTile(
                    onTap: () {
                      if (sideMenuKey.currentState!.isOpened) {
                        sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        sideMenuKey.currentState?.openSideMenu();
                      }
                      Get.delete<ReferController>(force: true);
                      Get.toNamed(AppRouter.getReferRoutes());
                    },
                    leading: const Icon(Icons.card_giftcard, size: 20.0, color: ThemeProvider.whiteColor),
                    title: Text('Refer & Earn'.tr),
                    textColor: ThemeProvider.whiteColor,
                    dense: true,
                  )
                : const SizedBox(),
            value.haveAccount == true
                ? ListTile(
                    onTap: () {
                      if (sideMenuKey.currentState!.isOpened) {
                        sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        sideMenuKey.currentState?.openSideMenu();
                      }
                      var context = Get.context as BuildContext;
                      value.logout(context);
                    },
                    leading: const Icon(Icons.logout, size: 20.0, color: ThemeProvider.whiteColor),
                    title: Text('Logout'.tr),
                    textColor: ThemeProvider.whiteColor,
                    dense: true,
                  )
                : const SizedBox(),
          ],
        ),
      );
    },
  );
}
