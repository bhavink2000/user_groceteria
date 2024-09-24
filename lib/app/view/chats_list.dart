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
import 'package:user/app/controller/chat_list_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text('Chats'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: value.apiCalled == false
              ? SkeletonListView(itemCount: 5)
              : value.chatList.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(height: 80, width: 80, child: Image.asset("assets/images/nothing.png", fit: BoxFit.cover)),
                          const SizedBox(height: 30),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: List.generate(
                            value.chatList.length,
                            (index) {
                              return value.chatList[index].uid.toString() == value.uid
                                  ? Container(
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: InkWell(
                                        onTap: () => value.onChat(value.chatList[index].participants.toString(),
                                            '${value.chatList[index].receiverName} ${value.chatList[index].receiverLastName} ( ${value.chatList[index].receiverType} )'),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FittedBox(
                                                child: FadeInImage(
                                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.chatList[index].receiverCover}'),
                                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                                  },
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('${value.chatList[index].receiverName} ${value.chatList[index].receiverLastName}', style: const TextStyle(fontFamily: 'medium')),
                                                        const Icon(Icons.chevron_right)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: InkWell(
                                        onTap: () => value.onChat(value.chatList[index].uid.toString(),
                                            '${value.chatList[index].senderFirstName} ${value.chatList[index].senderLastName} ( ${value.chatList[index].senderType} )'),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FittedBox(
                                                child: FadeInImage(
                                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.chatList[index].senderCover}'),
                                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                                  },
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('${value.chatList[index].senderFirstName} ${value.chatList[index].senderLastName}', style: const TextStyle(fontFamily: 'medium')),
                                                        const Icon(Icons.chevron_right)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
