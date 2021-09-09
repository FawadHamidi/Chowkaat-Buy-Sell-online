import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/landing/landing_screen.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/constants.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  UserModel? userModel;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userBioController = TextEditingController();
  // List<String> profileImages = [
  //   'assets/images/man1.png',
  //   'assets/images/man2.png',
  //   'assets/images/man3.png',
  //   'assets/images/woman1.png',
  //   'assets/images/woman2.png',
  //   'assets/images/woman3.png',
  // ];
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = UserModel();
  }

  bool _isLoading = false;
  String city = 'هرات';
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  userProfileImages[selectedIndex])),
                          borderRadius: BorderRadius.circular(100),
                          color: kBlackish,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6)
                          ]),
                    ),
                    Positioned(
                        top: 120,
                        left: 110,
                        child: ClipOval(
                          child: Container(
                            height: 25,
                            width: 25,
                            color: kBlackish,
                            child: Icon(
                              Icons.add,
                              color: kWhite,
                            ),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: userProfileImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage(userProfileImages[index])),
                              borderRadius: BorderRadius.circular(100),
                              color: kBlackish.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6)
                              ]),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 10,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kBlackish,
                  ),
                  height: size.height / 3,
                  width: size.width - 100,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: kWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)),
                            child: TextFormField(
                              controller: userNameController,
                              style: TextStyle(
                                color: kWhite,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'نام کاربری',
                                  hintStyle: TextStyle(color: kWhite),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: kWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)),
                            child: TextFormField(
                              controller: userBioController,
                              style: TextStyle(
                                color: kWhite,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'درباره',
                                  hintStyle: TextStyle(color: kWhite),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: size.width - 10,
                              decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: kBlackish,
                                  iconEnabledColor: kWhite,
                                  value: city,
                                  items: kCities.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          item,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: kWhite,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      this.city = value!;
                                      // provider.userCity = value;
                                    });
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  width: size.width,
                  child: InkWell(
                    onTap: () async {
                      provider.userBio = userBioController.text;
                      provider.userName = userNameController.text;
                      provider.userPhoto = userProfileImages[selectedIndex];
                      userModel!.phoneNumber = provider.phoneNumber;
                      userModel!.userBio = userBioController.text;
                      userModel!.userName = userNameController.text;
                      userModel!.userUid = provider.userUid;
                      userModel!.userCity = this.city;
                      userModel!.userPhoto = userProfileImages[selectedIndex];
                      await provider.addUserDetails(
                          userModel!, provider.userUid ?? '');
                      UserPreferences().saveUser(userModel!);
                      setState(() {
                        _isLoading = true;
                      });
                      await Future.delayed(Duration(seconds: 3));
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingScreen()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kBlackish,
                      ),
                      child: Center(
                          child: _isLoading == false
                              ? Text(
                                  'ذخیره',
                                  style: TextStyle(color: kWhite, fontSize: 20),
                                )
                              : Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: kWhite,
                                  ),
                                )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
