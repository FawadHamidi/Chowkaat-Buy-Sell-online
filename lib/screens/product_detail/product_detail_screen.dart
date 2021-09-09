import 'package:cached_network_image/cached_network_image.dart';
import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/chat/chat_screen.dart';
import 'package:chowkaat/services/firestore_services.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/my_carousel_slider.dart';

class ProductDetailScreen extends StatefulWidget {
  Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? myUid, myName;
  bool isMyUid = false;

  getMyInfoFromSharedPreferences() async {
    myUid = await UserPreferences().getUserUid();
    myName = await UserPreferences().getUserName();
  }

  getChatRoomIdByUserNames(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doThisOnLaunch();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    child: MyCarousel(
                      product: widget.product,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    '${widget.product.price} افغانی ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.favorite_outline,
                                  size: 30,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    widget.product.name ?? '',
                                    style: TextStyle(fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      ' ${widget.product.city}, افغانستان',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 0.8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'توضیحات:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.product.description ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                ),
                                Divider(
                                  thickness: 0.8,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.grey.shade200,
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${widget.product.userPhoto}',
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            widget.product.userName ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '20 تبلیغ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.product.userUid == myUid ? false : true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        await _makePhoneCall(
                            'tel:${widget.product.userPhoneNumber}');
                      },
                      child: Container(
                        height: 50,
                        color: kBlackish,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              color: kWhite,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'تماس',
                              style: TextStyle(color: kWhite),
                            )
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          var chatRoomId = getChatRoomIdByUserNames(
                              widget.product.userUid, myUid);
                          Map<String, dynamic> chatRoomInfoMap = {
                            "users": [widget.product.userName, myName]
                          };
                          provider.createChatRoom(chatRoomId, chatRoomInfoMap);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        model: widget.product,
                                      )));
                        },
                        child: Container(
                          height: 50,
                          color: kBlackish,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outlined,
                                color: kWhite,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'پیام',
                                style: TextStyle(color: kWhite),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
