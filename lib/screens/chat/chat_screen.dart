import 'package:chowkaat/models/chat_model.dart';
import 'package:chowkaat/models/chat_room_model.dart';
import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/services/firestore_services.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Product model;

  ChatScreen({required this.model});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageTextController = TextEditingController();
  String chatRoomId = '';
  String? myName, myPhoto, myUid;
  Stream<QuerySnapshot<Object?>>? messageStream;

  getMyInfoFromSharedPreferences() async {
    myName = await UserPreferences().getUserName();
    myPhoto = await UserPreferences().getUserPhoto();
    myUid = await UserPreferences().getUserUid();
    chatRoomId = getChatRoomIdByUserNames(widget.model.userUid, myUid);
  }

  getChatRoomIdByUserNames(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    ChatModel chatModel = ChatModel();

    if (_messageTextController.text != "") {
      String message = _messageTextController.text;
      chatModel.message = message;
      chatModel.sendBy = myName;
      provider.addChat(chatModel, chatRoomId).then((value) {
        ChatRoom chatRoom = ChatRoom();
        chatRoom.lastMessage = message;
        chatRoom.lastMessageSendBy = myName;
        chatRoom.users = [widget.model.userUid ?? '', myUid ?? ''];
        provider.updateChatRoom(chatRoom, chatRoomId);
      });

      if (sendClicked) {
        _messageTextController.text = "";
      }
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: sendByMe ? Radius.circular(30) : Radius.circular(0),
                bottomRight:
                    sendByMe ? Radius.circular(0) : Radius.circular(30),
              ),
              color: sendByMe ? kBlackish : kBlackish.withOpacity(0.2),
            ),
            child: Text(
              message,
              style: TextStyle(color: sendByMe ? kWhite : Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(
                color: kBlackish,
              ),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return Center(
                child: Text('No chat yet!'),
              );
            } else {
              return Container(
                padding: const EdgeInsets.only(bottom: 10, top: 15),
                margin: EdgeInsets.only(
                    bottom: 60, top: widget.model.name == '' ? 0 : 100),
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return chatMessageTile(
                        ds["message"], myName == ds["sendBy"]);
                  },
                ),
              );
            }
        }
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DataServices().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    await getAndSetMessages();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doThisOnLaunch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            leading: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                backgroundColor: kWhite.withOpacity(0.8),
                backgroundImage: NetworkImage(widget.model.userPhoto ?? ''),
              ),
            ),
            backgroundColor: kBlackish,
            title: Text(widget.model.userName ?? ''),
          ),
          body: Stack(
            children: [
              Visibility(
                visible: widget.model.name == '' ? false : true,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: kWhite, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 1,
                        spreadRadius: 1)
                  ]),
                  width: size.width,
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.model.images![0],
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  widget.model.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(
                                  ' قیمت: ${widget.model.price}افغانی  ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'لحظاتی پیش در هرات',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              chatMessages(),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: kBlackish,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextField(
                            controller: _messageTextController,
                            decoration: InputDecoration(
                                hintText: 'Type a message',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                border: InputBorder.none),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            addMessage(true);
                          },
                          child: Icon(
                            Icons.send_rounded,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
