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
import 'package:user/app/backend/models/wallet_models.dart';
import 'package:user/app/backend/parse/wallet_parse.dart';
import 'package:user/app/util/constant.dart';
import 'package:jiffy/jiffy.dart';

class WalletController extends GetxController implements GetxService {
  final WalletParser parser;
  bool apiCalled = false;
  List<WalletModel> _transactions = <WalletModel>[];
  List<WalletModel> get transactions => _transactions;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  double amount = 0.0;
  WalletController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getWallet();
  }

  Future<void> getWallet() async {
    Response response = await parser.getWalletList();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['transactions'] != null && myMap['data'] != null) {
        dynamic body = myMap["transactions"];
        dynamic user = myMap['data'];
        amount = double.tryParse(user['balance'].toString()) ?? 0.0;
        _transactions = [];
        body.forEach((data) {
          WalletModel datas = WalletModel.fromJson(data);
          datas.createdAt = Jiffy(datas.createdAt).format('yMMMMd');
          _transactions.add(datas);
        });
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
