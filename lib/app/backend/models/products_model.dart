/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

class ProductsModel {
  int? id;
  int? storeId;
  String? cover;
  String? name;
  String? images;
  double? originalPrice;
  double? sellPrice;
  double? discount;
  int? kind;
  int? cateId;
  int? subCateId;
  int? inHome;
  int? isSingle;
  int? haveGram;
  String? gram;
  int? haveKg;
  String? kg;
  int? havePcs;
  String? pcs;
  int? haveLiter;
  String? liter;
  int? haveMl;
  String? ml;
  String? descriptions;
  String? keyFeatures;
  String? disclaimer;
  String? expDate;
  int? typeOf;
  int? inOffer;
  int? inStoke;
  double? rating;
  int? totalRating;
  List<Variations>? variations;
  int? size;
  int? status;
  late int quantity;
  late int variant;
  String? extraField;

  ProductsModel(
      {this.id,
      this.storeId,
      this.cover,
      this.name,
      this.images,
      this.originalPrice,
      this.sellPrice,
      this.discount,
      this.kind,
      this.cateId,
      this.subCateId,
      this.inHome,
      this.isSingle,
      this.haveGram,
      this.gram,
      this.haveKg,
      this.kg,
      this.havePcs,
      this.pcs,
      this.haveLiter,
      this.liter,
      this.haveMl,
      this.ml,
      this.descriptions,
      this.keyFeatures,
      this.disclaimer,
      this.expDate,
      this.typeOf,
      this.inOffer,
      this.inStoke,
      this.rating,
      this.totalRating,
      this.variations,
      this.size,
      this.status,
      this.quantity = 0,
      this.variant = 0,
      this.extraField});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    storeId = int.parse(json['store_id'].toString());
    cover = json['cover'];
    name = json['name'];
    images = json['images'];
    originalPrice = double.parse(json['original_price'].toString());
    sellPrice = double.parse(json['sell_price'].toString());
    discount = double.parse(json['discount'].toString());
    kind = int.parse(json['kind'].toString());
    cateId = int.parse(json['cate_id'].toString());
    subCateId = int.parse(json['sub_cate_id'].toString());
    inHome = int.parse(json['in_home'].toString());
    isSingle = int.parse(json['is_single'].toString());
    haveGram = int.parse(json['have_gram'].toString());
    gram = json['gram'];
    haveKg = int.parse(json['have_kg'].toString());
    kg = json['kg'];
    havePcs = int.parse(json['have_pcs'].toString());
    pcs = json['pcs'];
    haveLiter = int.parse(json['have_liter'].toString());
    liter = json['liter'];
    haveMl = int.parse(json['have_ml'].toString());
    ml = json['ml'];
    descriptions = json['descriptions'];
    keyFeatures = json['key_features'];
    disclaimer = json['disclaimer'];
    expDate = json['exp_date'];
    typeOf = int.parse(json['type_of'].toString());
    inOffer = int.parse(json['in_offer'].toString());
    inStoke = int.parse(json['in_stoke'].toString());
    if (json['rating'] != '' && json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString()) ?? 0.0;
    } else {
      rating = 0.0;
    }
    totalRating = int.parse(json['total_rating'].toString());
    if (json['variations'] != null && json['variations'] != '') {
      variations = <Variations>[];
      List<dynamic> list = jsonDecode(json['variations']);
      if (list.isNotEmpty) {
        for (var v in list) {
          if (v['items']?.length > 0) {
            variations!.add(Variations.fromJson(v));
          } else {
            variations = null;
            variant = 1;
          }
        }
        variant = 0;
      } else {
        variations = null;
        variant = 1;
      }
    } else {
      variations = null;
      variant = 1;
    }
    size = int.parse(json['size'].toString());
    status = int.parse(json['status'].toString());
    if (json['quantity'] != null && json['quantity'] != 0 && json['quantity'] != '') {
      quantity = int.parse(json['quantity'].toString());
    } else {
      quantity = 0;
    }
    if (json['variant'] != null && json['variant'] != 0 && json['variant'] != '') {
      variant = int.parse(json['variant'].toString());
    }
    extraField = json['extra_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['cover'] = cover;
    data['name'] = name;
    data['images'] = images;
    data['original_price'] = originalPrice;
    data['sell_price'] = sellPrice;
    data['discount'] = discount;
    data['kind'] = kind;
    data['cate_id'] = cateId;
    data['sub_cate_id'] = subCateId;
    data['in_home'] = inHome;
    data['is_single'] = isSingle;
    data['have_gram'] = haveGram;
    data['gram'] = gram;
    data['have_kg'] = haveKg;
    data['kg'] = kg;
    data['have_pcs'] = havePcs;
    data['pcs'] = pcs;
    data['have_liter'] = haveLiter;
    data['liter'] = liter;
    data['have_ml'] = haveMl;
    data['ml'] = ml;
    data['descriptions'] = descriptions;
    data['key_features'] = keyFeatures;
    data['disclaimer'] = disclaimer;
    data['exp_date'] = expDate;
    data['type_of'] = typeOf;
    data['in_offer'] = inOffer;
    data['in_stoke'] = inStoke;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['size'] = size;
    data['status'] = status;
    data['quantity'] = quantity;
    data['variant'] = variant;
    data['extra_field'] = extraField;
    return data;
  }
}

class Variations {
  String? title;
  String? type;
  List<Items>? items;

  Variations({this.title, this.type, this.items});

  Variations.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['type'] = type;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? title;
  double? price;
  double? discount;

  Items({this.title, this.price, this.discount});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = double.parse(json['price'].toString());
    discount = double.parse(json['discount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['discount'] = discount;
    return data;
  }
}
