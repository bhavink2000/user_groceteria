/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/product_controller.dart';
import 'package:user/app/controller/sub_category_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  int _selectedIndex = 0;

  ScrollController controllerLeft = ScrollController();
  late ScrollController controllerRight;
  @override
  void initState() {
    controllerRight = ScrollController();
    controllerRight.addListener(() {
      if (controllerRight.position.pixels == controllerRight.position.maxScrollExtent) {
        Get.find<SubCategoryController>().increment();
      }
    });
    super.initState();
  }

  void onProductPage(int id, String name) {
    Get.delete<ProductController>(force: true);
    Get.toNamed(AppRouter.getProductRoutes(), arguments: [id, name]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubCategoryController>(builder: (value) {
      return Scaffold(
        appBar: AppBar(
          title: Text(value.cateName.toString(), style: ThemeProvider.titleStyle),
          backgroundColor: ThemeProvider.appColor,
          automaticallyImplyLeading: true,
          centerTitle: false,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              width: double.maxFinite,
              height: 50,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
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
                  )
                ],
              ),
            ),
          ),
        ),
        body: value.apiCalled == false
            ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
            : Row(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (context, constraint) {
                      return SingleChildScrollView(
                        controller: controllerLeft,
                        child: Container(
                          color: Colors.white,
                          width: 89,
                          child: IntrinsicHeight(
                            child: NavigationRail(
                              selectedIndex: _selectedIndex,
                              unselectedLabelTextStyle: const TextStyle(color: Colors.black),
                              onDestinationSelected: (int index) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                                Get.find<SubCategoryController>().changeCategory(index);
                              },
                              labelType: NavigationRailLabelType.all,
                              selectedIconTheme: const IconThemeData(color: ThemeProvider.appColor),
                              selectedLabelTextStyle: const TextStyle(color: ThemeProvider.appColor),
                              destinations: [
                                for (var item in value.category)
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.category_outlined),
                                    label: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        item.name.toString(),
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controllerRight,
                      child: value.productsCalled == false
                          ? GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              mainAxisSpacing: 8,
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 8,
                              childAspectRatio: 50 / 100,
                              children: List.generate(5, (index) {
                                return _dummyProductLoader();
                              }),
                            )
                          : GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              padding: EdgeInsets.zero,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 50 / 100,
                              children: List.generate(value.products.length, (index) {
                                return _buildSingleProduct(value.products[index], index);
                              }),
                            ),
                    ),
                  )
                ],
              ),
      );
    });
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
                  height: 130,
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
                child: Text(product.name.length > 10 ? product.name.substring(0, 10) + '...' : product.name, style: const TextStyle(fontSize: 14, fontFamily: 'medium')),
              ),
              (product.variations == null)
                  ? Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                        Get.find<SubCategoryController>().currencySide == 'left'
                                            ? Text('${Get.find<SubCategoryController>().currencySymbol}${product.originalPrice}',
                                                style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                            : Text('${product.originalPrice}${Get.find<SubCategoryController>().currencySymbol}',
                                                style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                        Get.find<SubCategoryController>().currencySide == 'left'
                                            ? Text('${Get.find<SubCategoryController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                            : Text('${product.sellPrice}${Get.find<SubCategoryController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Get.find<SubCategoryController>().currencySide == 'left'
                                            ? Text('${Get.find<SubCategoryController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                            : Text('${product.originalPrice}${Get.find<SubCategoryController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ])
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
                                                ? Get.find<SubCategoryController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<SubCategoryController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(Get.find<SubCategoryController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(product.variations![0].items![index].price.toString() + Get.find<SubCategoryController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(product.variations![0].items![index].discount.toString() + Get.find<SubCategoryController>().currencySymbol,
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                : Get.find<SubCategoryController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                Get.find<SubCategoryController>().currencySymbol +
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
                                                                Get.find<SubCategoryController>().currencySymbol,
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
                                                Get.find<SubCategoryController>().updateAddons(productIndex, e as int);
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
                            ? Get.find<SubCategoryController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(Get.find<SubCategoryController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(Get.find<SubCategoryController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(product.variations![0].items![product.variant].price.toString() + Get.find<SubCategoryController>().currencySymbol,
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(product.variations![0].items![product.variant].discount.toString() + Get.find<SubCategoryController>().currencySymbol,
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                            : Get.find<SubCategoryController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            Get.find<SubCategoryController>().currencySymbol +
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
                                            Get.find<SubCategoryController>().currencySymbol,
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
                          onPressed: () => Get.find<SubCategoryController>().addPopular(productIndex),
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
                              onTap: () => Get.find<SubCategoryController>().updatePopularProducts(productIndex, 'remove'),
                              child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                            ),
                            InkWell(
                              onTap: () => Get.find<SubCategoryController>().updatePopularProducts(productIndex, 'add'),
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

  Widget _dummyProductLoader() {
    return const SkeletonAvatar(style: SkeletonAvatarStyle(height: 40, width: 72));
  }
}
