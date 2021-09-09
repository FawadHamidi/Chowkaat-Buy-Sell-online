import 'package:cached_network_image/cached_network_image.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/auth/log_in_screen.dart';
import 'package:chowkaat/screens/my_Account/components/drop_down_button.dart';
import 'package:chowkaat/services/firestore_services.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/constants.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String? myUid, myName, myPhoto, myBio, myCity, myNumber;
  Future? future;
  bool isLoading = false;

  TextEditingController changeNameController = TextEditingController();
  TextEditingController changeBioController = TextEditingController();

  getMyInfoFromSharedPreferences() async {
    myUid = await UserPreferences().getUserUid();
    myName = await UserPreferences().getUserName();
    myPhoto = await UserPreferences().getUserPhoto();
    myBio = await UserPreferences().getUserBio();
    myCity = await UserPreferences().getUserCity();
    myNumber = await UserPreferences().getUserNumber();
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
    future = Future.delayed(Duration(seconds: 1));
  }

  String city = 'هرات';
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Center(
                  child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kBlackish,
                        backgroundImage: NetworkImage(myPhoto ?? ''),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 30, bottom: 10),
                        height: size.height - 380,
                        width: size.width - 40,
                        decoration: BoxDecoration(
                          color: kBlackish,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              DetailListTile(
                                text: myName ?? '',
                                title: 'نام:',
                                onTap: () async {
                                  _showMyDialog(
                                    context,
                                    controller: changeNameController,
                                    title: "نام",
                                    onTap: () async {
                                      await DataServices().updateUserName(
                                          userName: changeNameController.text,
                                          userUid: myUid ?? '');
                                      UserPreferences().setUserName(
                                          changeNameController.text);
                                      await getMyInfoFromSharedPreferences();
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                              DetailListTile(
                                text: myCity ?? '',
                                title: 'شهر:',
                                onTap: () {
                                  var provider = Provider.of<DataProvider>(
                                      context,
                                      listen: false);
                                  _showMyDialog(context,
                                      isTextField: false,
                                      title: 'شهر', onTap: () async {
                                    if (provider.cityForMyAccountDropDown !=
                                        null) {
                                      await DataServices().updateUserCity(
                                          userCity: provider
                                                  .cityForMyAccountDropDown ??
                                              '',
                                          userUid: myUid ?? '');
                                      UserPreferences().setUserCity(
                                          provider.cityForMyAccountDropDown ??
                                              "");
                                      await getMyInfoFromSharedPreferences();
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                      widget: MyDropDownButton(
                                        city: myCity,
                                      ));
                                },
                              ),
                              DetailListTile(
                                text: myNumber ?? '',
                                title: 'شماره:',
                                rtl: false,
                                editable: false,
                                onTap: () {},
                              ),
                              DetailListTile(
                                text: myBio ?? '',
                                title: 'درباره:',
                                onTap: () async {
                                  _showMyDialog(
                                    context,
                                    controller: changeBioController,
                                    title: "درباره",
                                    onTap: () async {
                                      await DataServices().updateUserBio(
                                          userBio: changeBioController.text,
                                          userUid: myUid ?? '');
                                      UserPreferences()
                                          .setUserBio(changeBioController.text);
                                      await getMyInfoFromSharedPreferences();
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await _auth.signOut();
                          UserPreferences().removeUser();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Container(
                          height: 50,
                          width: size.width - 40,
                          decoration: BoxDecoration(
                              color: kBlackish,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ]),
                          child: Center(
                            child: Text(
                              "خروج از حساب",
                              style: TextStyle(color: kWhite, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              : Center(
                  child: CircularProgressIndicator(
                    color: kBlackish,
                  ),
                );
        });
  }

  Future<void> _showMyDialog(BuildContext context,
      {required String title,
      required GestureTapCallback onTap,
      TextEditingController? controller,
      bool isTextField = true,
      Widget? widget}) async {
    return showDialog<void>(
      context: context, // user must tap button!
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(title),
            content: isTextField
                ? TextField(
                    controller: controller,
                  )
                : widget,
            actions: <Widget>[
              TextButton(
                  child: const Text(
                    'ذخیره',
                    style: TextStyle(color: kYellowish),
                  ),
                  onPressed: onTap),
              TextButton(
                child: const Text(
                  'بازگشت',
                  style: TextStyle(color: kBlackish),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailListTile extends StatelessWidget {
  const DetailListTile(
      {Key? key,
      required this.text,
      required this.title,
      this.editable = true,
      this.rtl = true,
      required this.onTap})
      : super(key: key);
  final String title;
  final String text;
  final bool rtl;
  final GestureTapCallback onTap;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kWhite.withOpacity(0.1)))),
      child: ListTile(
        leading: Text(
          title,
          style: TextStyle(color: kWhite, fontSize: 20),
        ),
        title: Container(
          padding: EdgeInsets.only(left: rtl ? 0 : 40),
          child: Text(
            text,
            maxLines: 4,
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(color: kWhite, fontSize: 20),
          ),
        ),
        trailing: GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.edit,
              color: editable ? kWhite : kBlackish,
            )),
      ),
    );
  }
}
