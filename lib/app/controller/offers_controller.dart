/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/banners_model.dart';
import 'package:user/app/backend/parse/offers_parse.dart';
import 'package:user/app/controller/product_controller.dart';
import 'package:user/app/controller/sub_category_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:url_launcher/url_launcher.dart';

class OffersController extends GetxController implements GetxService {
  final OfferParser parser;
  List<BannersModel> _banners = <BannersModel>[];
  List<BannersModel> get banners => _banners;
  bool apiCalled = false;
  OffersController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    getAllOffers();
  }

  Future<void> getAllOffers() async {
    Response response = await parser.getAllOffers();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _banners = [];
      body.forEach((data) {
        BannersModel datas = BannersModel.fromJson(data);
        _banners.add(datas);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onBannerClick(var type, var value) {
    if (type == 0) {
      Get.delete<SubCategoryController>(force: true);
      Get.toNamed(AppRouter.getSubCategoryRoute(), arguments: [int.parse(value), 'Offers'], preventDuplicates: false);
    } else if (type == 1) {
      Get.delete<ProductController>(force: true);
      Get.toNamed(AppRouter.getProductRoutes(), arguments: [int.parse(value), 'Offers']);
    } else {
      launchInBrowser(value);
    }
  }

  Future<void> launchInBrowser(var link) async {
    var url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
