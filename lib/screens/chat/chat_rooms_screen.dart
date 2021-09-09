import 'dart:async';
import 'dart:ui';

import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/chat/chat_screen.dart';
import 'package:chowkaat/services/firestore_services.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  var chatRoomsFuture;

  String? myUid;
  String? userUid;
  String? userImage;
  String? userName;
  String? lastMessage;
  getMyInfoFromSharedPreferences() async {
    myUid = await UserPreferences().getUserUid();
  }

  getChatRooms() async {
    var currentUser;
    chatRoomsFuture = await DataServices().getChatRooms(myUid);
    userUid =
        chatRoomsFuture!.docs[0].id.replaceAll(myUid!, "").replaceAll("_", "");

    currentUser = await DataServices().getUserByUid(userUid!);
    userName = currentUser!.docs[0]['user_name'];
    userImage = currentUser!.docs[0]['user_photo'];

    // setState(() {});
  }

  // getUserDetails() async {
  //   QuerySnapshot<Object?>? currentUser;
  //   chatRoomsStream!.listen((event) async {}).onData((data) async {
  //     userUid = data.docs[0].id.replaceAll(myUid!, "").replaceAll("_", "");
  //     currentUser = await DataServices().getUserByUid(userUid!);
  //     userImage = currentUser!.docs[0]['user_photo'];
  //     userName = currentUser!.docs[0]['user_name'];
  //     lastMessage = currentUser!.docs[0]['last_message'];
  //     print('%%%%%%%%%%%%%%%%%%%%%%%%$userUid');
  //   });
  //   print('########################$userUid');
  // }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    await getChatRooms();
    return chatRoomsFuture;
  }

  Widget chatRoomsList() {
    return FutureBuilder<dynamic>(
        future: doThisOnLaunch(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(
                  color: kYellowish,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('No chat yet!'),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: Text('No chat yet!'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          Product product = Product();
                          product.userName = userName;
                          product.userPhoto = userImage;
                          product.userUid = userUid;
                          product.id = 1;
                          product.price = "";
                          product.images = [
                            'https://firebasestorage.googleapis.com/v0/b/chowkaat-51ce5.appspot.com/o/posts%2Fimage_picker1490720060495668536.jpg?alt=media&token=a5d6fa92-6379-4692-9d23-967fe42d3906'
                          ];
                          product.name = '';
                          product.subCategory = '';
                          product.city = "";
                          product.description = "";
                          product.category = "";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(model: product)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.3))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: kBlackish.withOpacity(0.2),
                              backgroundImage: NetworkImage(userImage ?? ''),
                              radius: 30,
                            ),
                            title: Text(
                              userName ?? '',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(ds["last_message"]),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
          }
        });
  }

  // getUserDetails() async {
  //
  //   print(userName);
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   doThisOnLaunch();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: chatRoomsList(),
    );
  }
}
