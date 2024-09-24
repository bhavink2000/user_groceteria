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
import 'package:user/app/backend/models/conversion_model.dart';
import 'package:user/app/backend/parse/chats_list_parse.dart';
import 'package:user/app/controller/inbox_controller.dart';
import 'package:user/app/helper/router.dart';

class ChatListController extends GetxController implements GetxService {
  final ChatListParser parser;
  String uid = '';
  bool apiCalled = false;
  List<ChatConversionModel> _chatList = <ChatConversionModel>[];
  List<ChatConversionModel> get chatList => _chatList;
  ChatListController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    uid = parser.getUID();
    getChatConversion();
  }

  Future<void> getChatConversion() async {
    Response response = await parser.getChatConversion(uid);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _chatList = [];
      body.forEach((data) {
        ChatConversionModel datas = ChatConversionModel.fromJson(data);
        _chatList.add(datas);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onChat(String uid, String name) {
    Get.delete<InboxController>(force: true);
    Get.toNamed(AppRouter.getInboxRoutes(), arguments: [uid, name]);
  }
}
