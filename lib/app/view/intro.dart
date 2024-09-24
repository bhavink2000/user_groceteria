/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:user/app/controller/intro_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:get/get.dart';
import 'package:user/app/util/theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final CarouselController _controller = CarouselController();

  int _currentIndex = 0;
  void onDonePress() {
    Get.offNamed(AppRouter.getLocationRoute());
  }

  Widget getLanguages() {
    return PopupMenuButton(
      onSelected: (value) {},
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: IconButton(icon: const Icon(Icons.translate), color: ThemeProvider.whiteColor, onPressed: () {})),
      itemBuilder: (context) => AppConstants.languages
          .map(
            (e) => PopupMenuItem<String>(
              value: e.languageCode.toString(),
              onTap: () {
                var locale = Locale(e.languageCode.toString());
                Get.updateLocale(locale);
                Get.find<IntroController>().saveLanguage(e.languageCode);
              },
              child: Text(e.languageName.toString()),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.appColor,
          appBar: AppBar(elevation: 0, backgroundColor: ThemeProvider.appColor, actions: <Widget>[getLanguages()]),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildBody() {
    return CarouselSlider(
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
        height: double.infinity,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      carouselController: _controller,
      items: [1, 2, 3, 4].map(
        (i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                color: ThemeProvider.appColor,
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [if (i == 1) _buildSlide1(context) else if (i == 2) _buildSlide2(context) else if (i == 3) _buildSlide3(context) else if (i == 4) _buildSlide4(context)],
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }

  Widget _buildSlide1(BuildContext context) {
    return Column(
      children: [
        Container(height: 320, width: 200, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/sliders/1.png'), fit: BoxFit.contain))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text('Fresh fruits and Vegetables'.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'bold', color: Colors.white, fontSize: 20)),
            ),
            Text(
              'Fresh fruits and vegetables are an important part of a healthy diet. They contain essential vitamins, minerals, fiber and other nutrients that are essential for good health'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'regular'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide2(BuildContext context) {
    return Column(
      children: [
        Container(height: 320, width: 200, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/sliders/2.png'), fit: BoxFit.contain))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Grocery to your door steps'.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'bold', color: Colors.white, fontSize: 20)),
            ),
            Text(
              "We're slowly becoming more aware of how our individual choices can impact our planet. And food - how we consume it and how we shop for it - is one of the most important ways we can make a difference."
                  .tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'regular'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide3(BuildContext context) {
    return Column(
      children: [
        Container(height: 320, width: 200, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/sliders/3.png'), fit: BoxFit.contain))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Text('Best quality grocery'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.white, fontSize: 20))),
            Text(
              'Best quality product with organic maintenance but with affordable price.'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'regular'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide4(BuildContext context) {
    return Column(
      children: [
        Container(height: 320, width: 200, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/sliders/4.png'), fit: BoxFit.contain))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Text('Fastest Delivery'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.white, fontSize: 20))),
            Text(
              'Free delivery service for highest cart value, without minimum payment.'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'regular'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: ThemeProvider.appColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                if (_currentIndex == 0) {
                  onDonePress();
                } else {
                  _controller.previousPage();
                }
              },
              child: SizedBox(height: 50, width: 100, child: Center(child: Text(_currentIndex == 0 ? 'Skip'.tr : 'Previous'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.white)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                if (_currentIndex == 3) {
                  onDonePress();
                } else {
                  _controller.nextPage();
                }
              },
              child: SizedBox(height: 50, width: 100, child: Center(child: Text(_currentIndex == 3 ? 'Get Started'.tr : 'Next'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.white)))),
            ),
          ),
        ],
      ),
    );
  }
}
