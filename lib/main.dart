import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/provider/images_provider.dart';
import 'package:chowkaat/screens/auth/log_in_screen.dart';
import 'package:chowkaat/screens/landing/landing_screen.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<UserModel?> getUserData = UserPreferences().getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
          create: (context) => DataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: FutureBuilder<UserModel?>(
            future: getUserData,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.userUid == null) {
                    // return SendFile(phone: "8989",);
                    return LoginScreen();
                  } else {
                    return LandingScreen();
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
