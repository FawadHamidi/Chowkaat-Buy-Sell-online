import 'package:chowkaat/utilis/my_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool showLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController countryCodeController =
      TextEditingController(text: '+93');
  TextEditingController phoneNumberController = TextEditingController();
  String? verificationId;
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          key: _globalKey,
          backgroundColor: kWhite,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kBlackish,
            title: Text('ورود به حساب کاربری'),
          ),
          body: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شمارۀ موبایل خود را وارد کنید',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'برای استفاده از امکانات چوکات, لطفأ شمارۀ موبایل خودرا وارد کنید. کد تأیید به این شماره پیام داده خواهد شد.',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      enabled: false,
                                      maxLength: 3,
                                      controller: countryCodeController,
                                      decoration: InputDecoration(
                                          prefixIcon: Image.asset(
                                            'assets/images/flag.png',
                                            scale: 20,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            top: 15,
                                          )),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: phoneNumberController,
                                      maxLength: 9,
                                      decoration: InputDecoration(
                                        hintText: 'شماره موبایل',
                                      ),
                                    )),
                              ],
                            ),
                          )
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
                                if (mounted) {
                                  setState(() {
                                    showLoading = true;
                                  });
                                }
                                await _auth.verifyPhoneNumber(
                                    phoneNumber: countryCodeController.text +
                                        phoneNumberController.text,
                                    verificationCompleted:
                                        (phoneAuthCredential) async {
                                      setState(() {
                                        showLoading = false;
                                      });
                                    },
                                    verificationFailed:
                                        (verificationFailed) async {
                                      if (mounted) {
                                        setState(() {
                                          showLoading = false;
                                        });
                                      }
                                      _globalKey.currentState!.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  verificationFailed.message ??
                                                      '')));
                                    },
                                    codeSent:
                                        (verificationId, resendingToken) async {
                                      if (mounted) {
                                        setState(() {
                                          showLoading = false;
                                        });
                                      }
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OTPScreen(
                                                    verificationId:
                                                        this.verificationId,
                                                    phoneNumber:
                                                        phoneNumberController
                                                            .text,
                                                  )));
                                      this.verificationId = verificationId;
                                    },
                                    codeAutoRetrievalTimeout: (value) async {});
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
}
