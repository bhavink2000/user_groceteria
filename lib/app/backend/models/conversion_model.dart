/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class ChatConversionModel {
  String? senderFirstName;
  int? uid;
  String? receiverName;
  int? participants;
  String? senderLastName;
  String? senderCover;
  String? receiverLastName;
  String? receiverCover;
  String? senderType;
  String? receiverType;

  ChatConversionModel(
      {this.senderFirstName, this.uid, this.receiverName, this.participants, this.senderLastName, this.senderCover, this.receiverLastName, this.receiverCover, this.senderType, this.receiverType});

  ChatConversionModel.fromJson(Map<String, dynamic> json) {
    senderFirstName = json['sender_first_name'];
    uid = int.parse(json['uid'].toString());
    receiverName = json['receiver_name'];
    participants = int.parse(json['participants'].toString());
    senderLastName = json['sender_last_name'];
    senderCover = json['sender_cover'];
    receiverLastName = json['receiver_last_name'];
    receiverCover = json['receiver_cover'];
    senderType = json['sender_type'];
    receiverType = json['receiver_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_first_name'] = senderFirstName;
    data['uid'] = uid;
    data['receiver_name'] = receiverName;
    data['participants'] = participants;
    data['sender_last_name'] = senderLastName;
    data['sender_cover'] = senderCover;
    data['receiver_last_name'] = receiverLastName;
    data['receiver_cover'] = receiverCover;
    data['sender_type'] = senderType;
    data['receiver_type'] = receiverType;
    return data;
  }
}
