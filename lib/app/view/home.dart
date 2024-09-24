/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/in_offers_controller.dart';
import 'package:user/app/controller/popular_controller.dart';
import 'package:user/app/controller/product_controller.dart';
import 'package:user/app/controller/store_products_controller.dart';
import 'package:user/app/controller/stores_controller.dart';
import 'package:user/app/controller/sub_cate_product_controller.dart';
import 'package:user/app/controller/sub_category_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/controller/top_picked_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:skeletons/skeletons.dart';
import '../util/drawer.dart' as drawer;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final ScrollController _scrollController = ScrollController();

  void onProductPage(int id, String name) {
    Get.delete<ProductController>(force: true);
    Get.toNamed(AppRouter.getProductRoutes(), arguments: [id, name]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
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
              leading: GestureDetector(onTap: () => Get.offNamed(AppRouter.getLocationRoute()), child: const Icon(Icons.near_me)),
              centerTitle: false,
              title:
                  GestureDetector(onTap: () => Get.offNamed(AppRouter.getLocationRoute()), child: Text(value.titleName.toString(), overflow: TextOverflow.ellipsis, style: ThemeProvider.titleStyle)),
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
              bottom: value.haveData == true
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Container(
                        width: double.maxFinite,
                        height: 50,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () => Get.toNamed(AppRouter.getSearchRoute()),
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.all(10),
                                  child: TextField(
                                    style: const TextStyle(color: Colors.black),
                                    enabled: false,
                                    decoration: InputDecoration(
                                      hintText: 'Search products'.tr,
                                      prefixIcon: const Icon(Icons.search),
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade100)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade100)),
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            body: value.apiCalled == false
                ? getDummy()
                : value.haveData == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(height: 80, width: 80, child: Image.asset("assets/images/nothing.png", fit: BoxFit.cover)),
                          const SizedBox(height: 30),
                          Center(child: Text('No Stores Found Near You!'.tr, style: const TextStyle(fontFamily: 'bold'))),
                        ],
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('All Categories'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'medium')),
                                          TextButton(
                                            onPressed: () => Get.find<TabsController>().updateTabId(1),
                                            child: Text('View All'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [for (var item in value.category) buildCategoryImage(item.cover, (item.name), item.id)])),
                                value.topBanners.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Exclusive Offers'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'medium')),
                                                TextButton(
                                                  onPressed: () => Get.toNamed(AppRouter.getOffersRoute()),
                                                  child: Text('View All'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                value.topBanners.isNotEmpty
                                    ? Container(
                                        width: double.infinity,
                                        height: 100,
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: CarouselSlider(
                                          options: CarouselOptions(autoPlay: true, enlargeCenterPage: false, viewportFraction: 1.0, enlargeStrategy: CenterPageEnlargeStrategy.height),
                                          items: value.topBanners
                                              .map<Widget>(
                                                (item) => GestureDetector(
                                                  onTap: () => value.onBannerClick(item.type, item.link),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 100,
                                                    decoration: squareImage(item.cover),
                                                    child: Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Container(
                                                        width: 300,
                                                        margin: const EdgeInsets.only(bottom: 40),
                                                        decoration: const BoxDecoration(color: Color.fromARGB(150, 0, 0, 0)),
                                                        child: Text(
                                                          item.message.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'medium'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      )
                                    : const SizedBox(),
                                Container(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Top Picked'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'medium')),
                                          TextButton(
                                            onPressed: () {
                                              Get.delete<TopPickedController>(force: true);
                                              Get.toNamed(AppRouter.getTopPickedRoute());
                                            },
                                            child: Text('View All'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(value.topProducts.length, (index) {
                                      return _buildSingleProductTop(value.topProducts[index], index);
                                    }),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Products For You'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'medium')),
                                          TextButton(
                                            onPressed: () {
                                              Get.delete<PopularController>(force: true);
                                              Get.toNamed(AppRouter.getPopularRoute());
                                            },
                                            child: Text('View All'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(value.productsForYou.length, (index) {
                                      return _buildSingleProductForYou(value.productsForYou[index], index);
                                    }),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Best Deals'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'medium')),
                                          TextButton(
                                            onPressed: () {
                                              Get.delete<InOffersController>(force: true);
                                              Get.toNamed(AppRouter.getDealsRoute());
                                            },
                                            child: Text('View All'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(value.inOffers.length, (index) {
                                      return _buildSingleProductOffers(value.inOffers[index], index);
                                    }),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Top Stores'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'medium')),
                                          TextButton(
                                            onPressed: () {
                                              Get.delete<StoresController>(force: true);
                                              Get.toNamed(AppRouter.getStoreRoutes());
                                            },
                                            child: Text('View All'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(value.stores.length, (index) {
                                      return _buildStores(value.stores[index]);
                                    }),
                                  ),
                                ),
                                value.bottomBanners.isNotEmpty
                                    ? Container(
                                        width: double.infinity,
                                        height: 100,
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: CarouselSlider(
                                          options: CarouselOptions(autoPlay: true, enlargeCenterPage: false, viewportFraction: 1.0, enlargeStrategy: CenterPageEnlargeStrategy.height),
                                          items: value.bottomBanners
                                              .map<Widget>(
                                                (item) => GestureDetector(
                                                  onTap: () => value.onBannerClick(item.type, item.link),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 100,
                                                    decoration: squareImage(item.cover),
                                                    child: Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Container(
                                                        width: 300,
                                                        margin: const EdgeInsets.only(bottom: 40),
                                                        decoration: const BoxDecoration(color: Color.fromARGB(150, 0, 0, 0)),
                                                        child:
                                                            Text(item.message.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'medium')),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 10),
                                for (var items in value.category)
                                  Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: const BoxDecoration(color: Color(0xFFd0e3e3)),
                                        child: Text(items.name.toString(), style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'bold'), textAlign: TextAlign.center),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          padding: EdgeInsets.zero,
                                          children: List.generate(items.subCates?.length ?? 0, (index) {
                                            return _buildSingleCategory(items.subCates?[index]);
                                          }),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }

  Widget getDummy() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8)))
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  10,
                  (index) {
                    return SkeletonAvatar(style: SkeletonAvatarStyle(width: 50, height: 50, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8)))
              ],
            ),
            const SizedBox(height: 12),
            SkeletonLine(style: SkeletonLineStyle(height: 100, width: double.infinity, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8)))
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  10,
                  (index) {
                    return SkeletonAvatar(style: SkeletonAvatarStyle(width: 150, height: 160, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SkeletonLine(style: SkeletonLineStyle(height: 100, width: double.infinity, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8)))
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  10,
                  (index) {
                    return SkeletonAvatar(style: SkeletonAvatarStyle(width: 150, height: 160, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  squareImage(val) {
    return BoxDecoration(image: DecorationImage(image: NetworkImage('${Environments.apiBaseURL}storage/images/$val'), fit: BoxFit.cover, alignment: Alignment.center));
  }

  Widget _buildSingleProductTop(product, productIndex) {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: (Colors.grey[200])!, blurRadius: 5.0, offset: const Offset(0.0, 0.0))],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${product.cover}'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: Text(product.name.length > 15 ? product.name.substring(0, 15) + '...' : product.name, style: const TextStyle(fontSize: 14, fontFamily: 'medium')),
              ),
              (product.variations == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.haveGram == 1)
                          Text(product.gram + ' grams'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveKg == 1)
                          Text(product.kg + ' kg'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveLiter == 1)
                          Text(product.liter + ' ltr'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveMl == 1)
                          Text(product.ml + ' ml'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.havePcs == 1)
                          Text(product.pcs + ' pcs'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => onProductPage(product.id, product.name),
                          child: Row(
                            children: [
                              Expanded(
                                child: product.discount > 0
                                    ? Row(
                                        children: [
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.originalPrice}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                              : Text('${product.originalPrice}${Get.find<HomeController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.sellPrice}${Get.find<HomeController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.originalPrice}${Get.find<HomeController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Choose variant'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold'), textAlign: TextAlign.center),
                              content: Column(
                                children: [
                                  SizedBox(
                                    height: 200.0, // Change as per your requirement
                                    width: 300.0, // Change as per your requirement
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: product.variations?[0].items?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          Color getColor(Set<MaterialState> states) {
                                            return ThemeProvider.appColor;
                                          }

                                          return ListTile(
                                            textColor: ThemeProvider.appColor,
                                            iconColor: ThemeProvider.appColor,
                                            title: product.variations?[0].items?[index].discount > 0
                                                ? Get.find<HomeController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(product.variations![0].items![index].price.toString() + Get.find<HomeController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(product.variations![0].items![index].discount.toString() + Get.find<HomeController>().currencySymbol,
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                : Get.find<HomeController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                Get.find<HomeController>().currencySymbol +
                                                                product.variations?[0].items?[index].price.toString(),
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                product.variations?[0].items?[index].price.toString() +
                                                                Get.find<HomeController>().currencySymbol,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                            leading: Radio(
                                              fillColor: MaterialStateProperty.resolveWith(getColor),
                                              value: index,
                                              groupValue: product.variant,
                                              onChanged: (e) {
                                                Get.find<HomeController>().updateAddons(productIndex, e as int, 'top');
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: product.variations?[0].items?[product.variant].discount > 0
                            ? Get.find<HomeController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(product.variations![0].items![product.variant].price.toString() + Get.find<HomeController>().currencySymbol,
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(product.variations![0].items![product.variant].discount.toString() + Get.find<HomeController>().currencySymbol,
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                            : Get.find<HomeController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            Get.find<HomeController>().currencySymbol +
                                            product.variations?[0].items?[product.variant].price.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            product.variations?[0].items?[product.variant].price.toString() +
                                            Get.find<HomeController>().currencySymbol,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                      ),
                    ),
              Center(
                child: (product.quantity == 0)
                    ? Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                        child: TextButton(
                          onPressed: () => Get.find<HomeController>().addTopProducts(productIndex),
                          child: Text('Add'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 12)),
                        ),
                      )
                    : Container(
                        width: 100,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ThemeProvider.appColor),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Get.find<HomeController>().updateTopProducts(productIndex, 'remove'),
                              child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                            ),
                            InkWell(
                              onTap: () => Get.find<HomeController>().updateTopProducts(productIndex, 'add'),
                              child: const Icon(Icons.add_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 15,
          child: product.discount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromARGB(255, 255, 185, 48)),
                  child: Text('${product.discount}%', style: const TextStyle(color: Colors.white, fontFamily: 'medium')),
                )
              : const SizedBox(),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: ClipRRect(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(10),
              child: FittedBox(
                fit: BoxFit.cover,
                child: product.kind == 1 ? Image.asset('assets/images/veg.png') : Image.asset('assets/images/non.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleProductForYou(product, productIndex) {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: (Colors.grey[200])!, blurRadius: 5.0, offset: const Offset(0.0, 0.0))],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${product.cover}'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: Text(product.name.length > 15 ? product.name.substring(0, 15) + '...' : product.name, style: const TextStyle(fontSize: 14, fontFamily: 'medium')),
              ),
              (product.variations == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.haveGram == 1)
                          Text(product.gram + ' grams'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveKg == 1)
                          Text(product.kg + ' kg'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveLiter == 1)
                          Text(product.liter + ' ltr'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveMl == 1)
                          Text(product.ml + ' ml'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.havePcs == 1)
                          Text(product.pcs + ' pcs'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => onProductPage(product.id, product.name),
                          child: Row(
                            children: [
                              Expanded(
                                child: product.discount > 0
                                    ? Row(
                                        children: [
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.originalPrice}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                              : Text('${product.originalPrice}${Get.find<HomeController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.sellPrice}${Get.find<HomeController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.originalPrice}${Get.find<HomeController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Choose variant'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold'), textAlign: TextAlign.center),
                              content: Column(
                                children: [
                                  SizedBox(
                                    height: 200.0, // Change as per your requirement
                                    width: 300.0, // Change as per your requirement
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: product.variations?[0].items?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          Color getColor(Set<MaterialState> states) {
                                            return ThemeProvider.appColor;
                                          }

                                          return ListTile(
                                            textColor: ThemeProvider.appColor,
                                            iconColor: ThemeProvider.appColor,
                                            title: product.variations?[0].items?[index].discount > 0
                                                ? Get.find<HomeController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(product.variations![0].items![index].price.toString() + Get.find<HomeController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(product.variations![0].items![index].discount.toString() + Get.find<HomeController>().currencySymbol,
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                : Get.find<HomeController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                Get.find<HomeController>().currencySymbol +
                                                                product.variations?[0].items?[index].price.toString(),
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                product.variations?[0].items?[index].price.toString() +
                                                                Get.find<HomeController>().currencySymbol,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                            leading: Radio(
                                              fillColor: MaterialStateProperty.resolveWith(getColor),
                                              value: index,
                                              groupValue: product.variant,
                                              onChanged: (e) {
                                                Get.find<HomeController>().updateAddons(productIndex, e as int, 'popular');
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: product.variations?[0].items?[product.variant].discount > 0
                            ? Get.find<HomeController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(product.variations![0].items![product.variant].price.toString() + Get.find<HomeController>().currencySymbol,
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(product.variations![0].items![product.variant].discount.toString() + Get.find<HomeController>().currencySymbol,
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                            : Get.find<HomeController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            Get.find<HomeController>().currencySymbol +
                                            product.variations?[0].items?[product.variant].price.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            product.variations?[0].items?[product.variant].price.toString() +
                                            Get.find<HomeController>().currencySymbol,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                      ),
                    ),
              Center(
                child: (product.quantity == 0)
                    ? Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                        child: TextButton(
                          onPressed: () => Get.find<HomeController>().addPopular(productIndex),
                          child: Text('Add'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 10)),
                        ),
                      )
                    : Container(
                        width: 100,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ThemeProvider.appColor),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Get.find<HomeController>().updatePopularProducts(productIndex, 'remove'),
                              child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                            ),
                            InkWell(
                              onTap: () => Get.find<HomeController>().updatePopularProducts(productIndex, 'add'),
                              child: const Icon(Icons.add_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 15,
          child: product.discount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromARGB(255, 255, 185, 48)),
                  child: Text('${product.discount}%', style: const TextStyle(color: Colors.white, fontFamily: 'medium')),
                )
              : const SizedBox(),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: ClipRRect(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(10),
              child: FittedBox(
                fit: BoxFit.cover,
                child: product.kind == 1 ? Image.asset('assets/images/veg.png') : Image.asset('assets/images/non.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleProductOffers(product, productIndex) {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: (Colors.grey[200])!, blurRadius: 5.0, offset: const Offset(0.0, 0.0))],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${product.cover}'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: Text(product.name.length > 15 ? product.name.substring(0, 15) + '...' : product.name, style: const TextStyle(fontSize: 14, fontFamily: 'medium')),
              ),
              (product.variations == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.haveGram == 1)
                          Text(product.gram + ' grams'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveKg == 1)
                          Text(product.kg + ' kg'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveLiter == 1)
                          Text(product.liter + ' ltr'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.haveMl == 1)
                          Text(product.ml + ' ml'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                        else if (product.havePcs == 1)
                          Text(product.pcs + ' pcs'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => onProductPage(product.id, product.name),
                          child: Row(
                            children: [
                              Expanded(
                                child: product.discount > 0
                                    ? Row(
                                        children: [
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.originalPrice}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                              : Text('${product.originalPrice}${Get.find<HomeController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.sellPrice}${Get.find<HomeController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Get.find<HomeController>().currencySide == 'left'
                                              ? Text('${Get.find<HomeController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.originalPrice}${Get.find<HomeController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Choose variant'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold'), textAlign: TextAlign.center),
                              content: Column(
                                children: [
                                  SizedBox(
                                    height: 200.0, // Change as per your requirement
                                    width: 300.0, // Change as per your requirement
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: product.variations?[0].items?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          Color getColor(Set<MaterialState> states) {
                                            return ThemeProvider.appColor;
                                          }

                                          return ListTile(
                                            textColor: ThemeProvider.appColor,
                                            iconColor: ThemeProvider.appColor,
                                            title: product.variations?[0].items?[index].discount > 0
                                                ? Get.find<HomeController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(product.variations![0].items![index].price.toString() + Get.find<HomeController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(product.variations![0].items![index].discount.toString() + Get.find<HomeController>().currencySymbol,
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                : Get.find<HomeController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                Get.find<HomeController>().currencySymbol +
                                                                product.variations?[0].items?[index].price.toString(),
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                product.variations?[0].items?[index].price.toString() +
                                                                Get.find<HomeController>().currencySymbol,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                            leading: Radio(
                                              fillColor: MaterialStateProperty.resolveWith(getColor),
                                              value: index,
                                              groupValue: product.variant,
                                              onChanged: (e) {
                                                Get.find<HomeController>().updateAddons(productIndex, e as int, 'deal');
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: product.variations?[0].items?[product.variant].discount > 0
                            ? Get.find<HomeController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(Get.find<HomeController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(product.variations![0].items![product.variant].price.toString() + Get.find<HomeController>().currencySymbol,
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(product.variations![0].items![product.variant].discount.toString() + Get.find<HomeController>().currencySymbol,
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                            : Get.find<HomeController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            Get.find<HomeController>().currencySymbol +
                                            product.variations?[0].items?[product.variant].price.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            product.variations?[0].items?[product.variant].price.toString() +
                                            Get.find<HomeController>().currencySymbol,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                      ),
                    ),
              Center(
                child: (product.quantity == 0)
                    ? Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                        child: TextButton(
                          onPressed: () => Get.find<HomeController>().addDeals(productIndex),
                          child: Text('Add'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 10)),
                        ),
                      )
                    : Container(
                        width: 100,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ThemeProvider.appColor),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Get.find<HomeController>().updateDealsProducts(productIndex, 'remove'),
                              child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                            ),
                            InkWell(
                              onTap: () => Get.find<HomeController>().updateDealsProducts(productIndex, 'add'),
                              child: const Icon(Icons.add_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 15,
          child: product.discount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromARGB(255, 255, 185, 48)),
                  child: Text('${product.discount}%', style: const TextStyle(color: Colors.white, fontFamily: 'medium')),
                )
              : const SizedBox(),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: ClipRRect(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(10),
              child: FittedBox(
                fit: BoxFit.cover,
                child: product.kind == 1 ? Image.asset('assets/images/veg.png') : Image.asset('assets/images/non.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStores(product) {
    return Container(
      width: 200,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 5),
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
            height: 150,
            child: FadeInImage(
              image: NetworkImage('${Environments.apiBaseURL}storage/images/${product.cover}'),
              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
              },
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 8),
          Align(alignment: Alignment.center, child: Text(product.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontFamily: 'medium'))),
          Text(product.address.length > 40 ? product.address.substring(0, 40) + '...' : product.address, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Align(alignment: Alignment.center, child: Text(product.openTime + ' - ' + product.closeTime, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black))),
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
                  Get.toNamed(AppRouter.getStoreProductsRoute(), arguments: [product.uid, product.name]);
                },
                child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryImage(img, txt, id) {
    return InkWell(
      onTap: () {
        Get.delete<SubCategoryController>(force: true);
        Get.toNamed(AppRouter.getSubCategoryRoute(), arguments: [id, txt], preventDuplicates: false);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              child: ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/$img'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.contain);
                    },
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              txt.length > 10 ? txt.substring(0, 10) + '...' : txt,
              style: const TextStyle(fontFamily: 'semibold', fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleCategory(category) {
    return InkWell(
      onTap: () {
        Get.delete<SubCatesProductsController>(force: true);
        Get.toNamed(AppRouter.getSubCategoryProductsRoute(), arguments: [category.id, category.name]);
      },
      child: Container(
        color: const Color(0xFFFFFFF0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: FadeInImage(
                image: NetworkImage('${Environments.apiBaseURL}storage/images/${category.cover}'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png', fit: BoxFit.contain);
                },
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              category.name.length > 15 ? category.name.substring(0, 15) + '...' : category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontFamily: 'semibold'),
            ),
          ],
        ),
      ),
    );
  }
}
