import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chowkaat/screens/add_product/add_product_screen.dart';
import 'package:chowkaat/screens/auth/sign_out.dart';
import 'package:chowkaat/screens/auth/user_detail.dart';
import 'package:chowkaat/screens/chat/chat_rooms_screen.dart';
import 'package:chowkaat/screens/home/home_screen.dart';
import 'package:chowkaat/screens/my_Account/my_account_screen.dart';
import 'package:chowkaat/screens/user_products/user_products.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> animation;
  // late CurvedAnimation curve;
  int _activeIndex = 0;
  List<Widget> _pageList = [
    HomeScreen(),
    UserProducts(),
    ChatRoomsScreen(),
    MyAccount(),
  ];
  List<IconData> _iconList = [
    Icons.dashboard_rounded,
    Icons.article,
    Icons.question_answer,
    Icons.account_circle,
  ];
  List<String> _titleList = [
    'صفحه اصلی',
    "تبلیغ ها",
    "چت",
    "حساب",
  ];
  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );
    // curve = CurvedAnimation(
    //   parent: _animationController,
    //   curve: Interval(
    //     0.5,
    //     1.0,
    //     curve: Curves.fastOutSlowIn,
    //   ),
    // );
    // animation = Tween<double>(
    //   begin: 0,
    //   end: 1,
    // ).animate(curve);
    // _animationController.forward();
    // _animationController.dispose();

    //   if (this.mounted) {
    //     Future.delayed(
    //       Duration(seconds: 1),
    //       () {
    //         if (this.mounted) {
    //           setState(() {
    //             _animationController.forward();
    //           });
    //         }
    //
    //         // _animationController.dispose();
    //       },
    //     );
    //   }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kWhite,
          floatingActionButton: FloatingActionButton(
            backgroundColor: kBlackish,
            child: Icon(
              Icons.add,
              size: 30,
              color: kWhite,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProduct()));
            },
            //params
          ),
          body: Container(
            child: _pageList[_activeIndex],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: _iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? kYellowish : kBlackish;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Icon(
                    _iconList[index],
                    size: 22,
                    color: color,
                  ),
                  Text(
                    _titleList[index],
                    maxLines: 1,
                    style: TextStyle(color: color),
                  ),
                ],
              );
            },
            backgroundColor: kWhite,
            activeIndex: _activeIndex,
            splashColor: kYellowish,
            // notchAndCornersAnimation: animation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.softEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => setState(() => _activeIndex = index),
          ),
        ),
      ),
    );
  }
}
