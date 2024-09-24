/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class InboxParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  InboxParser({required this.sharedPreferencesManager, required this.apiService});

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getChatRooms(var uid, var participants) async {
    return await apiService.postPrivate(AppConstants.getChatRooms, {'uid': uid, 'participants': participants}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> createChatRooms(var uid, var participants) async {
    return await apiService.postPrivate(AppConstants.createChatRooms, {'uid': uid, 'participants': participants, 'status': 1}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getChatList(var roomId) async {
    return await apiService.postPrivate(AppConstants.getChatList, {'room_id': roomId}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> sendMessage(var param) async {
    return await apiService.postPrivate(AppConstants.sendMessage, param, sharedPreferencesManager.getString('token') ?? '');
  }
}
