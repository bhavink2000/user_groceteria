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
import 'package:user/app/controller/search_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppSearchController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            title: Row(
              children: [
                Flexible(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: value.searchController,
                      onChanged: value.searchProducts,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search products'.tr,
                        prefixIcon: const Icon(Icons.search),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade100)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade100)),
                        filled: true,
                        fillColor: ThemeProvider.whiteColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      ),
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))],
            automaticallyImplyLeading: false,
          ),
          body: value.isEmpty.isFalse && value.result.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i in value.result)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () {
                              Get.delete<ProductController>(force: true);
                              Get.toNamed(AppRouter.getProductRoutes(), arguments: [i.id, i.name]);
                            },
                            child: ListTile(
                              leading: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 44, minHeight: 44, maxWidth: 64, maxHeight: 64),
                                child: FadeInImage(
                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${i.cover}'),
                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                  },
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              title: Text(i.name.toString(), style: const TextStyle(fontSize: 10.0)),
                            ),
                          ),
                        )
                    ],
                  ),
                )
              : Container(),
        );
      },
    );
  }
}
