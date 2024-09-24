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
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/search_result_model.dart';
import 'package:user/app/backend/parse/search_parse.dart';

class AppSearchController extends GetxController implements GetxService {
  final SearchParser parser;
  TextEditingController searchController = TextEditingController();
  RxBool isEmpty = true.obs;
  AppSearchController({required this.parser});
  List<SearchResultModel> _result = <SearchResultModel>[];
  List<SearchResultModel> get result => _result;
  searchProducts(String name) {
    if (name.isNotEmpty && name != '') {
      getSearchResult(name);
    } else {
      _result = [];
      isEmpty = true.obs;
      update();
    }
  }

  void getSearchResult(String query) async {
    Response response = await parser.getSearchResult(query);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _result = [];
      isEmpty = false.obs;
      body.forEach((data) {
        SearchResultModel datas = SearchResultModel.fromJson(data);
        _result.add(datas);
      });
    } else {
      isEmpty = false.obs;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void clearData() {
    searchController.clear();
    _result = [];
    isEmpty = true.obs;
    update();
  }
}
