/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class ChatListModel {
  int? id;
  int? roomId;
  String? uid;
  int? fromId;
  String? message;
  String? messageType;
  String? timestamp;
  String? extraField;
  int? status;

  ChatListModel({this.id, this.roomId, this.uid, this.fromId, this.message, this.messageType, this.timestamp, this.extraField, this.status});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    roomId = int.parse(json['room_id'].toString());
    uid = json['uid'].toString();
    fromId = int.parse(json['from_id'].toString());
    message = json['message'];
    messageType = json['message_type'];
    timestamp = json['timestamp'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['uid'] = uid;
    data['from_id'] = fromId;
    data['message'] = message;
    data['message_type'] = messageType;
    data['timestamp'] = timestamp;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
