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
import 'package:user/app/controller/in_offers_controller.dart';
import 'package:user/app/controller/product_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class DealScreen extends StatefulWidget {
  const DealScreen({Key? key}) : super(key: key);

  @override
  State<DealScreen> createState() => _DealScreenState();
}

class _DealScreenState extends State<DealScreen> {
  bool toggleView = false;

  void onProductPage(int id, String name) {
    Get.delete<ProductController>(force: true);
    Get.toNamed(AppRouter.getProductRoutes(), arguments: [id, name]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InOffersController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Best Deals'.tr, style: ThemeProvider.titleStyle),
            backgroundColor: ThemeProvider.appColor,
            automaticallyImplyLeading: true,
            centerTitle: false,
            elevation: 0.0,
            actions: <Widget>[IconButton(onPressed: () => Get.toNamed(AppRouter.getSearchRoute()), icon: const Icon(Icons.search))],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Column(
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(value.topProducts.length.toString() + ' Items'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'medium', color: Colors.grey)),
                        ),
                        Row(
                          children: [
                            IconButton(
                                iconSize: 18,
                                onPressed: () {
                                  setState(() {
                                    toggleView = !toggleView;
                                  });
                                },
                                icon: toggleView == true ? const Icon(Icons.format_list_bulleted) : const Icon(Icons.grid_view)),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      elevation: 16,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          const SizedBox(height: 20),
                                          InkWell(
                                            onTap: () => value.filterProducts(context, 'rating'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'Popularity'.tr,
                                                style: TextStyle(fontSize: 14, fontFamily: value.selectedFilter == 'Popularity' ? 'bold' : 'regular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => value.filterProducts(context, 'l-h'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'Price - Low to High'.tr,
                                                style: TextStyle(fontSize: 14, fontFamily: value.selectedFilter == 'Price L-H' ? 'bold' : 'regular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => value.filterProducts(context, 'h-l'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'Price - Price L-H'.tr,
                                                style: TextStyle(fontSize: 14, fontFamily: value.selectedFilter == 'Price H-L' ? 'bold' : 'regular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => value.filterProducts(context, 'a-z'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'A - Z'.tr,
                                                style: TextStyle(fontSize: 14, fontFamily: value.selectedFilter == 'A-Z' ? 'bold' : 'regular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => value.filterProducts(context, 'z-a'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'Z - A'.tr,
                                                style: TextStyle(fontSize: 14, fontFamily: value.selectedFilter == 'Z-A' ? 'bold' : 'regular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => value.filterProducts(context, 'off'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                '% Off - High to Low'.tr,
                                                style: TextStyle(fontSize: 14, fontFamily: value.selectedFilter == '% Off' ? 'bold' : 'regular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.sort_by_alpha, color: Colors.black, size: 18),
                              label: Text('Filter '.tr + value.selectedFilter, style: const TextStyle(color: Colors.black, fontSize: 10)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: value.apiCalled == false
              ? SkeletonListView(
                  item: SkeletonListTile(
                    verticalSpacing: 12,
                    leadingStyle: const SkeletonAvatarStyle(width: 64, height: 64, shape: BoxShape.circle),
                    titleStyle: SkeletonLineStyle(height: 16, minLength: 200, randomLength: true, borderRadius: BorderRadius.circular(12)),
                    subtitleStyle: SkeletonLineStyle(height: 12, maxLength: 200, randomLength: true, borderRadius: BorderRadius.circular(12)),
                    hasSubtitle: true,
                  ),
                )
              : SingleChildScrollView(
                  child: toggleView == true
                      ? Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const ScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 60 / 100,
                            children: List.generate(
                              value.topProducts.length,
                              (index) {
                                return _buildSingleProduct(value.topProducts[index], index);
                              },
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            ListView(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              children: List.generate(
                                value.topProducts.length,
                                (index) {
                                  return _buildCartProduct(value.topProducts[index], index);
                                },
                              ),
                            )
                          ],
                        ),
                ),
        );
      },
    );
  }

  Widget _buildCartProduct(product, productIndex) {
    return Stack(
      children: [
        Container(
          color: ThemeProvider.whiteColor,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => onProductPage(product.id, product.name),
                child: SizedBox(
                  height: 70,
                  width: 70,
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => onProductPage(product.id, product.name),
                      child: Text(product.name.length > 15 ? product.name.substring(0, 15) + '...' : product.name, style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                    ),
                    (product.variations == null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              InkWell(
                                onTap: () => onProductPage(product.id, product.name),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: product.discount > 0
                                          ? Row(
                                              children: [
                                                Get.find<InOffersController>().currencySide == 'left'
                                                    ? Text('${Get.find<InOffersController>().currencySymbol}${product.originalPrice}',
                                                        style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                                    : Text('${product.originalPrice}${Get.find<InOffersController>().currencySymbol}',
                                                        style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                Get.find<InOffersController>().currencySide == 'left'
                                                    ? Text('${Get.find<InOffersController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                    : Text('${product.sellPrice}${Get.find<InOffersController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Get.find<InOffersController>().currencySide == 'left'
                                                    ? Text('${Get.find<InOffersController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                    : Text('${product.originalPrice}${Get.find<InOffersController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              )
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
                                                      ? Get.find<InOffersController>().currencySide == 'left'
                                                          ? Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                                Text(Get.find<InOffersController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                                Text(
                                                                  Get.find<InOffersController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                                )
                                                              ],
                                                            )
                                                          : Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                                Text(product.variations![0].items![index].price.toString() + Get.find<InOffersController>().currencySymbol,
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                                Text(
                                                                  product.variations![0].items![index].discount.toString() + Get.find<InOffersController>().currencySymbol,
                                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                                )
                                                              ],
                                                            )
                                                      : Get.find<InOffersController>().currencySide == 'left'
                                                          ? Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    product.variations?[0].items?[index].title +
                                                                        ' - ' +
                                                                        Get.find<InOffersController>().currencySymbol +
                                                                        product.variations?[0].items?[index].price.toString(),
                                                                    textAlign: TextAlign.start,
                                                                    style: const TextStyle(fontSize: 10))
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
                                                                        Get.find<InOffersController>().currencySymbol,
                                                                    textAlign: TextAlign.start,
                                                                    style: const TextStyle(fontSize: 10))
                                                              ],
                                                            ),
                                                  leading: Radio(
                                                    fillColor: MaterialStateProperty.resolveWith(getColor),
                                                    value: index,
                                                    groupValue: product.variant,
                                                    onChanged: (e) {
                                                      Get.find<InOffersController>().updateAddons(productIndex, e as int);
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
                                  ? Get.find<InOffersController>().currencySide == 'left'
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                            Text(Get.find<InOffersController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                            Text(
                                              Get.find<InOffersController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                            )
                                          ],
                                        )
                                      : Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                            Text(product.variations![0].items![product.variant].price.toString() + Get.find<InOffersController>().currencySymbol,
                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                            Text(
                                              product.variations![0].items![product.variant].discount.toString() + Get.find<InOffersController>().currencySymbol,
                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                            )
                                          ],
                                        )
                                  : Get.find<InOffersController>().currencySide == 'left'
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                product.variations?[0].items?[product.variant].title +
                                                    ' - ' +
                                                    Get.find<InOffersController>().currencySymbol +
                                                    product.variations?[0].items?[product.variant].price.toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 10))
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
                                                    Get.find<InOffersController>().currencySymbol,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 10))
                                          ],
                                        ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              (product.quantity == 0)
                  ? Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                      child: TextButton(
                        onPressed: () => Get.find<InOffersController>().addPopular(productIndex),
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
                            onTap: () => Get.find<InOffersController>().updatePopularProducts(productIndex, 'remove'),
                            child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                          ),
                          InkWell(
                            onTap: () => Get.find<InOffersController>().updatePopularProducts(productIndex, 'add'),
                            child: const Icon(Icons.add_circle, color: ThemeProvider.whiteColor, size: 30),
                          ),
                        ],
                      ),
                    )
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
              size: const Size.fromRadius(5),
              child: FittedBox(fit: BoxFit.cover, child: product.kind == 1 ? Image.asset('assets/images/veg.png') : Image.asset('assets/images/non.png')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleProduct(product, productIndex) {
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
                                          Get.find<InOffersController>().currencySide == 'left'
                                              ? Text('${Get.find<InOffersController>().currencySymbol}${product.originalPrice}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                              : Text('${product.originalPrice}${Get.find<InOffersController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                          Get.find<InOffersController>().currencySide == 'left'
                                              ? Text('${Get.find<InOffersController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.sellPrice}${Get.find<InOffersController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Get.find<InOffersController>().currencySide == 'left'
                                              ? Text('${Get.find<InOffersController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.originalPrice}${Get.find<InOffersController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
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
                                                ? Get.find<InOffersController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<InOffersController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(
                                                            Get.find<InOffersController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                            style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(product.variations![0].items![index].price.toString() + Get.find<InOffersController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(
                                                            product.variations![0].items![index].discount.toString() + Get.find<InOffersController>().currencySymbol,
                                                            style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                : Get.find<InOffersController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              product.variations?[0].items?[index].title +
                                                                  ' - ' +
                                                                  Get.find<InOffersController>().currencySymbol +
                                                                  product.variations?[0].items?[index].price.toString(),
                                                              textAlign: TextAlign.start,
                                                              style: const TextStyle(fontSize: 10))
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
                                                                  Get.find<InOffersController>().currencySymbol,
                                                              textAlign: TextAlign.start,
                                                              style: const TextStyle(fontSize: 10))
                                                        ],
                                                      ),
                                            leading: Radio(
                                              fillColor: MaterialStateProperty.resolveWith(getColor),
                                              value: index,
                                              groupValue: product.variant,
                                              onChanged: (e) {
                                                Get.find<InOffersController>().updateAddons(productIndex, e as int);
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
                            ? Get.find<InOffersController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(Get.find<InOffersController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(
                                        Get.find<InOffersController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                        style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                      )
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(product.variations![0].items![product.variant].price.toString() + Get.find<InOffersController>().currencySymbol,
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(
                                        product.variations![0].items![product.variant].discount.toString() + Get.find<InOffersController>().currencySymbol,
                                        style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                      )
                                    ],
                                  )
                            : Get.find<InOffersController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          product.variations?[0].items?[product.variant].title +
                                              ' - ' +
                                              Get.find<InOffersController>().currencySymbol +
                                              product.variations?[0].items?[product.variant].price.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10))
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
                                              Get.find<InOffersController>().currencySymbol,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10))
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
                          onPressed: () => Get.find<InOffersController>().addPopular(productIndex),
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
                              onTap: () => Get.find<InOffersController>().updatePopularProducts(productIndex, 'remove'),
                              child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                            ),
                            InkWell(
                              onTap: () => Get.find<InOffersController>().updatePopularProducts(productIndex, 'add'),
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
              child: FittedBox(fit: BoxFit.cover, child: product.kind == 1 ? Image.asset('assets/images/veg.png') : Image.asset('assets/images/non.png')),
            ),
          ),
        ),
      ],
    );
  }
}
