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
import 'package:user/app/backend/models/category_model.dart';
import 'package:user/app/backend/parse/categories_parse.dart';

class CategoriesController extends GetxController implements GetxService {
  final CategoriesParser parser;
  List<CategoryModel> _category = <CategoryModel>[];
  List<CategoryModel> get category => _category;

  bool apiCalled = false;
  CategoriesController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    getCategories();
  }

  Future<void> getCategories() async {
    Response response = await parser.getCategories();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _category = [];
      body.forEach((data) {
        CategoryModel datas = CategoryModel.fromJson(data);
        _category.add(datas);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
