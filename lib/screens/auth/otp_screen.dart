import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/auth/user_detail.dart';
import 'package:chowkaat/screens/landing/landing_screen.dart';
import 'package:chowkaat/services/firestore_services.dart';
import 'package:chowkaat/services/share_services.dart';

import 'package:chowkaat/utilis/my_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';

import 'components/otp_text_feild.dart';

class OTPScreen extends StatefulWidget {
  var verificationId;
  var phoneNumber;

  OTPScreen({this.verificationId, this.phoneNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();
  TextEditingController text3 = TextEditingController();
  TextEditingController text4 = TextEditingController();
  TextEditingController text5 = TextEditingController();
  TextEditingController text6 = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
  bool _onEditing = true;
  String _otp = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kBlackish,
            title: Text(''),
          ),
          body: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'کد تأیید',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              '  لطفا کد تأیید که به شماره 0${widget.phoneNumber} فرستاده شد وارد کنید.',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: VerificationCode(
                              textStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                              underlineColor: Colors.blueAccent,
                              keyboardType: TextInputType.number,
                              length: 6,
                              onCompleted: (String value) {
                                setState(() {
                                  _otp = value;
                                });
                              },
                              onEditing: (bool value) {
                                setState(() {
                                  _onEditing = value;
                                });
                              },
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     OtpTextField(controller: text1),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     OtpTextField(controller: text2),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     OtpTextField(controller: text3),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     OtpTextField(controller: text4),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     OtpTextField(controller: text5),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     OtpTextField(controller: text6),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: size.width,
                            child: InkWell(
                              onTap: () async {
                                PhoneAuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.verificationId,
                                        smsCode: _otp);
                                signInWithPhoneAuthCredential(
                                    phoneAuthCredential);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kBlackish,
                                ),
                                child: Center(
                                    child: Text(
                                  'بعدی',
                                  style: TextStyle(color: kWhite, fontSize: 20),
                                )),
                              ),
                            )))
                  ],
                ),
        ),
      ),
    );
  }

  signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      var provider = Provider.of<DataProvider>(context, listen: false);
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      var currentUser =
          await DataServices().getUser("+93${widget.phoneNumber}");
      print(currentUser!.size);
      if (authCredential.user != null && currentUser.size <= 0) {
        provider.userUid = authCredential.user!.uid;
        provider.phoneNumber = authCredential.user!.phoneNumber;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserDetailScreen()));
      } else if (currentUser.size > 0) {
        UserModel userModel = UserModel();
        // var currentUser =
        //     await DataServices().getUser("+93${widget.phoneNumber}");
        provider.phoneNumber = currentUser.docs[0]['phone_number'];
        provider.userName = currentUser.docs[0]['user_name'];
        provider.userUid = currentUser.docs[0]['user_uid'];
        provider.userPhoto = currentUser.docs[0]['user_photo'];
        provider.userCity = currentUser.docs[0]['user_city'];
        provider.userBio = currentUser.docs[0]['user_bio'];
        userModel.phoneNumber = provider.phoneNumber;
        userModel.userBio = provider.userBio;
        userModel.userName = provider.userName;
        userModel.userUid = provider.userUid;
        userModel.userCity = provider.userCity;
        userModel.userPhoto = provider.userPhoto;
        // await provider.addUserDetails(userModel);
        UserPreferences().saveUser(userModel);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        showLoading = false;
      });
    }
  }
}
