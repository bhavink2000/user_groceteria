/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/store_products_controller.dart';
import 'package:user/app/controller/stores_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoresController>(
      builder: (value) {
        return Scaffold(
          appBar:
              AppBar(title: const Text('Top Stores', style: ThemeProvider.titleStyle), backgroundColor: ThemeProvider.appColor, automaticallyImplyLeading: true, elevation: 0.0, centerTitle: false),
          body: SingleChildScrollView(
            child: value.apiCalled == true
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 50 / 100,
                      children: List.generate(value.stores.length, (index) {
                        return _buildStores(value.stores[index]);
                      }),
                    ),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 50 / 100,
                    children: List.generate(5, (index) {
                      return _dummyProductLoader();
                    }),
                  ),
          ),
        );
      },
    );
  }

  Widget _dummyProductLoader() {
    return const SkeletonAvatar(style: SkeletonAvatarStyle(height: 40, width: 72));
  }

  Widget _buildStores(store) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        height: 300,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: (Colors.grey[200])!, blurRadius: 5.0, offset: const Offset(0.0, 0.0))],
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 130,
              child: FadeInImage(
                image: NetworkImage('${Environments.apiBaseURL}storage/images/${store.cover}'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                },
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 8),
            Align(alignment: Alignment.center, child: Text(store.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontFamily: 'medium'))),
            Text(store.address.length > 30 ? store.address.substring(0, 30) + '...' : store.address, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            Align(alignment: Alignment.center, child: Text(store.openTime + ' - ' + store.closeTime, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black))),
            const SizedBox(height: 8),
            Center(
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                child: TextButton(
                  onPressed: () {
                    Get.delete<StoreProductsController>(force: true);
                    Get.toNamed(AppRouter.getStoreProductsRoute(), arguments: [store.uid, store.name]);
                  },
                  child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
