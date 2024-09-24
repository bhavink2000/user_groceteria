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
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  void onProductPage(int id, String name) {
    Get.delete<ProductController>(force: true);
    Get.toNamed(AppRouter.getProductRoutes(), arguments: [id, name], preventDuplicates: false);
  }

  squareImage(val) {
    return BoxDecoration(image: DecorationImage(image: NetworkImage('${Environments.apiBaseURL}storage/images/$val'), fit: BoxFit.cover, alignment: Alignment.center));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            automaticallyImplyLeading: true,
            elevation: 0.0,
            centerTitle: false,
            title: Text(value.productName, style: ThemeProvider.titleStyle),
            actions: <Widget>[
              IconButton(onPressed: () => value.onFavourite(), icon: Icon(value.isFav == true ? Icons.favorite : Icons.favorite_border)),
              IconButton(onPressed: () => value.share(), icon: const Icon(Icons.share_outlined))
            ],
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: CarouselSlider(
                          options: CarouselOptions(autoPlay: true, enableInfiniteScroll: false, enlargeCenterPage: false, viewportFraction: 1.0, enlargeStrategy: CenterPageEnlargeStrategy.height),
                          items: value.images!
                              .map<Widget>(
                                (item) => GestureDetector(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/$item'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.contain);
                                      },
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: (Colors.grey[300])!))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.details.name!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontFamily: 'bold')),
                            Row(
                              children: [
                                Expanded(
                                  child: (value.details.variations == null)
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (value.details.haveGram == 1)
                                              Text(value.details.gram.toString() + ' grams'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                                            else if (value.details.haveKg == 1)
                                              Text(value.details.kg.toString() + ' kg'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                                            else if (value.details.haveLiter == 1)
                                              Text(value.details.liter.toString() + ' ltr'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                                            else if (value.details.haveMl == 1)
                                              Text(value.details.ml.toString() + ' ml'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start)
                                            else if (value.details.havePcs == 1)
                                              Text(value.details.pcs.toString() + ' pcs'.tr, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.start),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: value.details.discount! > 0
                                                      ? Row(
                                                          children: [
                                                            Get.find<ProductController>().currencySide == 'left'
                                                                ? Text('${Get.find<ProductController>().currencySymbol}${value.details.originalPrice}',
                                                                    style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                                                : Text('${value.details.originalPrice}${Get.find<ProductController>().currencySymbol}',
                                                                    style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                            Get.find<ProductController>().currencySide == 'left'
                                                                ? Text('${Get.find<ProductController>().currencySymbol}${value.details.sellPrice}',
                                                                    style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                                : Text('${value.details.sellPrice}${Get.find<ProductController>().currencySymbol}',
                                                                    style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            Get.find<ProductController>().currencySide == 'left'
                                                                ? Text('${Get.find<ProductController>().currencySymbol}${value.details.originalPrice}',
                                                                    style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                                : Text('${value.details.originalPrice}${Get.find<ProductController>().currencySymbol}',
                                                                    style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                                          ],
                                                        ),
                                                ),
                                              ],
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
                                                            itemCount: value.details.variations?[0].items?.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              Color getColor(Set<MaterialState> states) {
                                                                return ThemeProvider.appColor;
                                                              }

                                                              return ListTile(
                                                                textColor: ThemeProvider.appColor,
                                                                iconColor: ThemeProvider.appColor,
                                                                title: value.details.variations![0].items![index].discount! > 0
                                                                    ? Get.find<ProductController>().currencySide == 'left'
                                                                        ? Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text('${value.details.variations![0].items![index].title!} - ',
                                                                                  textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                                              Text(Get.find<ProductController>().currencySymbol + value.details.variations![0].items![index].price.toString(),
                                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                                              Text(Get.find<ProductController>().currencySymbol + value.details.variations![0].items![index].discount.toString(),
                                                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                                            ],
                                                                          )
                                                                        : Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text('${value.details.variations![0].items![index].title!} - ',
                                                                                  textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                                              Text(value.details.variations![0].items![index].price.toString() + Get.find<ProductController>().currencySymbol,
                                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                                              Text(value.details.variations![0].items![index].discount.toString() + Get.find<ProductController>().currencySymbol,
                                                                                  style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                                            ],
                                                                          )
                                                                    : Get.find<ProductController>().currencySide == 'left'
                                                                        ? Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                '${value.details.variations![0].items![index].title!} - ${Get.find<ProductController>().currencySymbol}${value.details.variations![0].items![index].price}',
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
                                                                                '${value.details.variations![0].items![index].title!} - ${value.details.variations![0].items![index].price}${Get.find<ProductController>().currencySymbol}',
                                                                                textAlign: TextAlign.start,
                                                                                style: const TextStyle(fontSize: 10),
                                                                              )
                                                                            ],
                                                                          ),
                                                                leading: Radio(
                                                                  fillColor: MaterialStateProperty.resolveWith(getColor),
                                                                  value: index,
                                                                  groupValue: value.details.variant,
                                                                  onChanged: (e) {
                                                                    Get.find<ProductController>().updateAddons(e as int);
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
                                            child: value.details.variations![0].items![value.details.variant].discount! > 0
                                                ? Get.find<ProductController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('${value.details.variations![0].items![value.details.variant].title!} - ',
                                                              textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<ProductController>().currencySymbol + value.details.variations![0].items![value.details.variant].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(Get.find<ProductController>().currencySymbol + value.details.variations![0].items![value.details.variant].discount.toString(),
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('${value.details.variations![0].items![value.details.variant].title!} - ',
                                                              textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                                          Text(value.details.variations![0].items![value.details.variant].price.toString() + Get.find<ProductController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(value.details.variations![0].items![value.details.variant].discount.toString() + Get.find<ProductController>().currencySymbol,
                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                        ],
                                                      )
                                                : Get.find<ProductController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '${value.details.variations![0].items![value.details.variant].title!} - ${Get.find<ProductController>().currencySymbol}${value.details.variations![0].items![value.details.variant].price}',
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
                                                            '${value.details.variations![0].items![value.details.variant].title!} - ${value.details.variations![0].items![value.details.variant].price}${Get.find<ProductController>().currencySymbol}',
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 10),
                                value.details.quantity == 0
                                    ? Container(
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                                        child: TextButton(
                                          onPressed: () => Get.find<ProductController>().addPopular(),
                                          child: Text('Add'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 10)),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ThemeProvider.appColor),
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () => Get.find<ProductController>().updateTopProducts('remove'),
                                              child: const Icon(Icons.remove_circle, color: ThemeProvider.whiteColor, size: 30),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Text(value.details.quantity.toString(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 18, fontFamily: 'semi-bold')),
                                            ),
                                            InkWell(
                                              onTap: () => Get.find<ProductController>().updateTopProducts('add'),
                                              child: const Icon(Icons.add_circle, color: ThemeProvider.whiteColor, size: 30),
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            value.details.descriptions != ''
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildTitleLabel('Descriptions'),
                                      const SizedBox(height: 16),
                                      Text(value.details.descriptions.toString(), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                      const SizedBox(height: 16),
                                    ],
                                  )
                                : const SizedBox(),
                            value.details.keyFeatures != ''
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildTitleLabel('Heighlight'),
                                      const SizedBox(height: 16),
                                      Text(value.details.keyFeatures.toString(), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                      const SizedBox(height: 16),
                                    ],
                                  )
                                : const SizedBox(),
                            value.details.disclaimer != ''
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildTitleLabel('Disclaimer'),
                                      const SizedBox(height: 16),
                                      Text(value.details.disclaimer.toString(), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                      const SizedBox(height: 16),
                                    ],
                                  )
                                : const SizedBox(),
                            _buildTitleLabel('Maybe You Likes'),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  value.related.length,
                                  (index) {
                                    return _buildSingleProduct(value.related[index], index);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSingleProduct(product, index) {
    return Stack(
      children: [
        Container(
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
                                          Get.find<ProductController>().currencySide == 'left'
                                              ? Text('${Get.find<ProductController>().currencySymbol}${product.originalPrice}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                              : Text('${product.originalPrice}${Get.find<ProductController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                          Get.find<ProductController>().currencySide == 'left'
                                              ? Text('${Get.find<ProductController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.sellPrice}${Get.find<ProductController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Get.find<ProductController>().currencySide == 'left'
                                              ? Text('${Get.find<ProductController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                              : Text('${product.originalPrice}${Get.find<ProductController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
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
                                                ? Get.find<ProductController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(Get.find<ProductController>().currencySymbol + product.variations![0].items![index].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(
                                                            Get.find<ProductController>().currencySymbol + product.variations![0].items![index].discount.toString(),
                                                            style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(product.variations?[0].items?[index].title + ' - ', textAlign: TextAlign.start, style: const TextStyle(fontSize: 10)),
                                                          Text(product.variations![0].items![index].price.toString() + Get.find<ProductController>().currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                          Text(
                                                            product.variations![0].items![index].discount.toString() + Get.find<ProductController>().currencySymbol,
                                                            style: const TextStyle(fontFamily: 'bold', fontSize: 10),
                                                          )
                                                        ],
                                                      )
                                                : Get.find<ProductController>().currencySide == 'left'
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product.variations?[0].items?[index].title +
                                                                ' - ' +
                                                                Get.find<ProductController>().currencySymbol +
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
                                                                Get.find<ProductController>().currencySymbol,
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
                            ? Get.find<ProductController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(Get.find<ProductController>().currencySymbol + product.variations![0].items![product.variant].price.toString(),
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(Get.find<ProductController>().currencySymbol + product.variations![0].items![product.variant].discount.toString(),
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.variations?[0].items?[product.variant].title + ' - ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                                      Text(product.variations![0].items![product.variant].price.toString() + Get.find<ProductController>().currencySymbol,
                                          style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Text(product.variations![0].items![product.variant].discount.toString() + Get.find<ProductController>().currencySymbol,
                                          style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                    ],
                                  )
                            : Get.find<ProductController>().currencySide == 'left'
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.variations?[0].items?[product.variant].title +
                                            ' - ' +
                                            Get.find<ProductController>().currencySymbol +
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
                                            Get.find<ProductController>().currencySymbol,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                      ),
                    ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeProvider.appColor),
                  child: TextButton(
                    onPressed: () => onProductPage(product.id, product.name),
                    child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 10)),
                  ),
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

  Widget _buildTitleLabel(val) {
    return Text('$val'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'medium'));
  }

  btnBox() {
    return BoxDecoration(border: Border.all(width: 2, color: ThemeProvider.appColor), borderRadius: const BorderRadius.all(Radius.circular(3)));
  }
}
