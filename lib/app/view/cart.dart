/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../util/drawer.dart' as drawer;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
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
              title: Text('Cart'.tr, style: ThemeProvider.titleStyle),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      if (_sideMenuKey.currentState!.isOpened) {
                        _sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        _sideMenuKey.currentState?.openSideMenu();
                      }
                    },
                    icon: const Icon(Icons.menu))
              ],
            ),
            body: value.savedInCart.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(height: 80, width: 80, child: Image.asset("assets/images/nothing.png", fit: BoxFit.cover)),
                        const SizedBox(height: 30),
                        Center(child: Text('Your cart is empty'.tr, style: const TextStyle(fontFamily: 'bold'))),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text('Your Cart'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 18), textAlign: TextAlign.start),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: List.generate(value.savedInCart.length, (index) {
                            return _buildCartProduct(value.savedInCart[index], index);
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Order once placed cannot be cancelled and are non-refunable'.tr, style: const TextStyle(fontSize: 10, color: ThemeProvider.appColor, fontFamily: 'regular')),
                        )
                      ],
                    ),
                  ),
            bottomNavigationBar: value.savedInCart.isNotEmpty
                ? Material(
                    color: ThemeProvider.appColor,
                    child: InkWell(
                      onTap: () => value.onCheckout(),
                      child: SizedBox(
                        height: kToolbarHeight,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Get.find<CartController>().currencySide == 'left'
                                    ? '${value.savedInCart.length}${' Items : '.tr}${Get.find<CartController>().currencySymbol}${value.totalPrice}'
                                    : '${value.savedInCart.length}${' Items : '.tr}${value.totalPrice}${Get.find<CartController>().currencySymbol}',
                                style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.whiteColor),
                              ),
                              TextButton(onPressed: () => value.onCheckout(), child: Text('Checkout'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.whiteColor))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
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
              SizedBox(
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name.length > 15 ? product.name.substring(0, 15) + '...' : product.name, style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: product.discount > 0
                                        ? Row(
                                            children: [
                                              Get.find<CartController>().currencySide == 'left'
                                                  ? Text(
                                                      '${Get.find<CartController>().currencySymbol}${product.originalPrice}',
                                                      style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough),
                                                    )
                                                  : Text(
                                                      '${product.originalPrice}${Get.find<CartController>().currencySymbol}',
                                                      style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough),
                                                    ),
                                              Get.find<CartController>().currencySide == 'left'
                                                  ? Text('${Get.find<CartController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                  : Text('${product.sellPrice}${Get.find<CartController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Get.find<CartController>().currencySide == 'left'
                                                  ? Text('${Get.find<CartController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                  : Text('${product.originalPrice}${Get.find<CartController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                            ],
                                          ),
                                  ),
                                ],
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
                                                      ? Get.find<CartController>().currencySide == 'left'
                                                          ? Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                                Text(Get.find<CartController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                                Text(
                                                                  Get.find<CartController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                                )
                                                              ],
                                                            )
                                                          : Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                                Text(product.variations![0].items![index].price.toString() + Get.find<CartController>().currencySymbol,
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                                Text(
                                                                  product.variations![0].items![index].discount.toString() + Get.find<CartController>().currencySymbol,
                                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                                )
                                                              ],
                                                            )
                                                      : Get.find<CartController>().currencySide == 'left'
                                                          ? Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  product.variations?[0].items?[index].title +
                                                                      ' - ' +
                                                                      Get.find<CartController>().currencySymbol +
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
                                                                      Get.find<CartController>().currencySymbol,
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
                                                      Get.find<CartController>().updateSavedAddons(productIndex, e as int);
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
                                  ? Get.find<CartController>().currencySide == 'left'
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                            Text(Get.find<CartController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                            Text(
                                              Get.find<CartController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                            )
                                          ],
                                        )
                                      : Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                            Text(product.variations![0].items![product.variant].price.toString() + Get.find<CartController>().currencySymbol,
                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                            Text(
                                              product.variations![0].items![product.variant].discount.toString() + Get.find<CartController>().currencySymbol,
                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                            )
                                          ],
                                        )
                                  : Get.find<CartController>().currencySide == 'left'
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                product.variations?[0].items?[product.variant].title +
                                                    ' - ' +
                                                    Get.find<CartController>().currencySymbol +
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
                                                    Get.find<CartController>().currencySymbol,
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
              Container(
                width: 100,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ThemeProvider.appColor),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(onTap: () => Get.find<CartController>().updateQuantity(productIndex, 'remove'), child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(product.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                    ),
                    InkWell(onTap: () => Get.find<CartController>().updateQuantity(productIndex, 'add'), child: const Icon(Icons.add_circle, color: ThemeProvider.whiteColor, size: 30)),
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
}

class Item {
  const Item(this.img, this.name);
  final String img;
  final String name;
}
