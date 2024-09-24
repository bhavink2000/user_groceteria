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
import 'package:user/app/controller/offers_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OffersController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(title: Text('Offers'.tr, style: ThemeProvider.titleStyle), backgroundColor: ThemeProvider.appColor, automaticallyImplyLeading: true, centerTitle: false, elevation: 0.0),
          body: value.apiCalled == false
              ? getDummy()
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      for (var item in value.banners)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                          child: GestureDetector(
                            onTap: () => value.onBannerClick(item.type, item.link),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'), fit: BoxFit.cover, alignment: Alignment.center),
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 250,
                                  margin: const EdgeInsets.only(bottom: 40),
                                  decoration: const BoxDecoration(color: Color.fromARGB(150, 0, 0, 0)),
                                  child: Text(item.message.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'medium')),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget getDummy() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SkeletonAvatar(style: SkeletonAvatarStyle(width: double.infinity, minHeight: MediaQuery.of(context).size.height / 8, maxHeight: MediaQuery.of(context).size.height / 3)),
      ),
    );
  }
}
