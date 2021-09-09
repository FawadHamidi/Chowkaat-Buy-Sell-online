import 'package:chowkaat/screens/auth/log_in_screen.dart';
import 'package:chowkaat/screens/my_Account/my_account_screen.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOut extends StatefulWidget {
  @override
  _SignOutState createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
          child: InkWell(
        onTap: () async {
          await _auth.signOut();
          UserPreferences().removeUser();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Container(
          child: Text('Sign out'),
        ),
      )),
    );
  }
}
