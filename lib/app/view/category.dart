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
import 'package:user/app/controller/categories_controller.dart';
import 'package:user/app/controller/sub_cate_product_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:accordion/accordion.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:skeletons/skeletons.dart';
import '../util/drawer.dart' as drawer;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
      builder: (value) {
        return SideMenu(
          key: _sideMenuKey,
          background: ThemeProvider.secondaryAppColor,
          menu: drawer.buildMenu(_sideMenuKey),
          type: SideMenuType.shrinkNSlide, // check above images
          inverse: true,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Categories'.tr, style: ThemeProvider.titleStyle),
              backgroundColor: ThemeProvider.appColor,
              automaticallyImplyLeading: false,
              elevation: 0.0,
              centerTitle: false,
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
            body: value.parser.getStoreIds() != '' && value.parser.getStoreIds().isNotEmpty
                ? value.apiCalled == false
                    ? SkeletonListView()
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        controller: _scrollController,
                        child: Accordion(
                          disableScrolling: true,
                          maxOpenSections: 1,
                          headerBackgroundColorOpened: Colors.black54,
                          headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                          children: [
                            for (var item in value.category)
                              AccordionSection(
                                leftIcon: ClipRRect(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(10),
                                    child: FittedBox(
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
                                ),
                                rightIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                headerBackgroundColor: Colors.white,
                                contentBorderColor: const Color(0xffffffff),
                                headerBackgroundColorOpened: Colors.white,
                                header: Text(item.name.toString(), style: const TextStyle(color: Colors.black)),
                                content: Column(
                                  children: [
                                    for (var sub in item.subCates!)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: TextButton(
                                                onPressed: () {
                                                  Get.delete<SubCatesProductsController>(force: true);
                                                  Get.toNamed(AppRouter.getSubCategoryProductsRoute(), arguments: [sub.id, sub.name]);
                                                },
                                                child: Text(sub.name.toString(), style: const TextStyle(color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                contentHorizontalPadding: 20,
                                contentBorderWidth: 1,
                              ),
                          ],
                        ),
                      )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(height: 80, width: 80, child: Image.asset("assets/images/nothing.png", fit: BoxFit.cover)),
                      const SizedBox(height: 30),
                      Center(child: Text('No Stores Found Near You!'.tr, style: const TextStyle(fontFamily: 'bold'))),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
