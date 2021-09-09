import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/global_components/image_place_holder.dart';
import 'package:chowkaat/screens/product_detail/product_detail_screen.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatefulWidget {
  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  UserModel? user;

  Future<UserModel?> getUser() async {
    user = await UserPreferences().getUser();
    setState(() {});
    print(user?.userUid);
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    print(user?.userUid);
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<DataProvider>(context, listen: false);
    var userProducts =
        user == null ? null : provider.loadUserProducts(user?.userUid ?? '');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kWhite,
          body: user == null
              ? CircularProgressIndicator()
              : FutureBuilder(
                  future: userProducts,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                            color: kBlackish,
                          ),
                        );
                      default:
                        if (provider.userProducts!.isEmpty) {
                          return Center(
                              child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/nodata.png',
                                scale: 6,
                              ),
                              Positioned(
                                  top: 270,
                                  right: 120,
                                  child: Text(
                                    'تبلیغی موخود نیست',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kBlackish),
                                  )),
                            ],
                          ));
                        } else if (snapshot.hasData) {
                          return Column(
                            children: List.generate(
                              provider.userProducts!.length,
                              (index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                                product: provider
                                                    .userProducts![index],
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kWhite,
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              style: BorderStyle.solid))),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      MyImagePlaceHolder(
                                        height: size.width / 2.5,
                                        width: size.width / 2.5,
                                        imageLink: provider
                                            .userProducts![index].images![0],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 200,
                                                height: 50,
                                                child: Text(
                                                  provider.userProducts![index]
                                                          .name ??
                                                      '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                child: Text(
                                                  ' قیمت: ${provider.userProducts![index].price}افغانی  ',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'لحظاتی پیش در هرات',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                            ),
                          );
                        } else {
                          return Container();
                        }
                    }
                  },
                ),
        ),
      ),
    );
  }
}
