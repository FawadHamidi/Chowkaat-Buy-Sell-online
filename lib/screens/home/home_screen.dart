import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/global_components/search_card.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_body.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<UserModel?> getUserData = UserPreferences().getUser();
    var provider = Provider.of<DataProvider>(context, listen: false);

    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverAppBar(
          elevation: 50,
          shadowColor: Colors.black,
          backgroundColor: kWhite,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: searchContainer(context),
          ),
          automaticallyImplyLeading: false,
          expandedHeight: 120,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
              background: Container(
            padding: EdgeInsets.only(bottom: 60, right: 10),
            child: FutureBuilder<UserModel?>(
                future: getUserData,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 5,
                            ),
                            Text('${snapshot.data!.userCity}, افغانستان'),
                          ],
                        )
                      : CircularProgressIndicator();
                }),
          )),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            HomeBody(),
          ]),
        )
      ],
    );
  }
}
