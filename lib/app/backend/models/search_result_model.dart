/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class SearchResultModel {
  int? id;
  String? name;
  int? storeId;
  String? cover;

  SearchResultModel({this.id, this.name, this.storeId, this.cover});

  SearchResultModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    storeId = int.parse(json['store_id'].toString());
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['store_id'] = storeId;
    data['cover'] = cover;
    return data;
  }
}
