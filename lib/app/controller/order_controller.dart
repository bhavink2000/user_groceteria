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
import 'package:user/app/backend/models/order_model.dart';
import 'package:user/app/backend/parse/orders_parse.dart';
import 'package:user/app/util/constant.dart';
import 'package:jiffy/jiffy.dart';

class OrderController extends GetxController implements GetxService {
  final OrderParser parser;
  bool loadMore = false;
  bool apiCalled = false;
  RxInt lastLimit = 1.obs;
  List<OrdersModel> _ordersList = <OrdersModel>[];
  List<OrdersModel> get ordersList => _ordersList;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  OrderController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getOrder();
  }

  Future<void> getOrder() async {
    if (parser.haveLoggedIn() == true) {
      Response response = await parser.getOrder(lastLimit.value);
      apiCalled = true;
      loadMore = false;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["data"];
        _ordersList = [];
        body.forEach((data) {
          OrdersModel datas = OrdersModel.fromJson(data);
          if (datas.orders!.isNotEmpty) {
            datas.dateTime = Jiffy(datas.dateTime).yMMMMEEEEdjm;
            _ordersList.add(datas);
          }
        });
        update();
      } else {
        ApiChecker.checkApi(response);
        update();
      }
      update();
    }
  }

  void increment() {
    loadMore = true;
    lastLimit = lastLimit++;
    update();
    getOrder();
  }

  Future<void> hardRefresh() async {
    lastLimit = 1.obs;
    apiCalled = false;
    update();
    await getOrder();
  }
}
